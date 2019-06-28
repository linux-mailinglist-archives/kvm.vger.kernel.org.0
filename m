Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56F6359926
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 13:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfF1LXt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 07:23:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54938 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbfF1LXq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 07:23:46 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 727CC85362;
        Fri, 28 Jun 2019 11:23:43 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.43.2.155])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AC075DD61;
        Fri, 28 Jun 2019 11:23:40 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 2/2] x86/kvm/nVMX: fix VMCLEAR when Enlightened VMCS is in use
Date:   Fri, 28 Jun 2019 13:23:33 +0200
Message-Id: <20190628112333.31165-3-vkuznets@redhat.com>
In-Reply-To: <20190628112333.31165-1-vkuznets@redhat.com>
References: <20190628112333.31165-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 28 Jun 2019 11:23:46 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When Enlightened VMCS is in use, it is valid to do VMCLEAR and,
according to TLFS, this should "transition an enlightened VMCS from the
active to the non-active state". It is, however, wrong to assume that
it is only valid to do VMCLEAR for the eVMCS which is currently active
on the vCPU performing VMCLEAR.

Currently, the logic in handle_vmclear() is broken: in case, there is no
active eVMCS on the vCPU doing VMCLEAR we treat the argument as a 'normal'
VMCS and kvm_vcpu_write_guest() to the 'launch_state' field irreversibly
corrupts the memory area.

So, in case the VMCLEAR argument is not the current active eVMCS on the
vCPU, how can we know if the area it is pointing to is a normal or an
enlightened VMCS?
Thanks to the bug in Hyper-V (see commit 72aeb60c52bf7 ("KVM: nVMX: Verify
eVMCS revision id match supported eVMCS version on eVMCS VMPTRLD")) we can
not, the revision can't be used to distinguish between them. So let's
assume it is always enlightened in case enlightened vmentry is enabled in
the assist page. Also, check if vmx->nested.enlightened_vmcs_enabled to
minimize the impact for 'unenlightened' workloads.

Fixes: b8bbab928fb1 ("KVM: nVMX: implement enlightened VMPTRLD and VMCLEAR")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c  | 18 ++++++++++++++++++
 arch/x86/kvm/vmx/evmcs.h  |  1 +
 arch/x86/kvm/vmx/nested.c | 32 ++++++++++++++++++--------------
 3 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 1a6b3e1581aa..758462a565b3 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -3,6 +3,7 @@
 #include <linux/errno.h>
 #include <linux/smp.h>
 
+#include "../hyperv.h"
 #include "evmcs.h"
 #include "vmcs.h"
 #include "vmx.h"
@@ -309,6 +310,23 @@ void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
 }
 #endif
 
+bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa)
+{
+	struct hv_vp_assist_page assist_page;
+
+	*evmcs_gpa = -1ull;
+
+	if (unlikely(!kvm_hv_get_assist_page(vcpu, &assist_page)))
+		return false;
+
+	if (unlikely(!assist_page.enlighten_vmentry))
+		return false;
+
+	*evmcs_gpa = assist_page.current_nested_vmcs;
+
+	return true;
+}
+
 uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
 {
        struct vcpu_vmx *vmx = to_vmx(vcpu);
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index e0fcef85b332..39a24eec8884 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -195,6 +195,7 @@ static inline void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf) {}
 static inline void evmcs_touch_msr_bitmap(void) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
+bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa);
 uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
 int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 			uint16_t *vmcs_version);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f1dfb8ef4634..e7a4931bc914 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1765,27 +1765,22 @@ static int nested_vmx_handle_enlightened_vmptrld(struct kvm_vcpu *vcpu,
 						 bool from_launch)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct hv_vp_assist_page assist_page;
 	bool evmcs_gpa_changed = false;
+	u64 evmcs_gpa;
 
 	if (likely(!vmx->nested.enlightened_vmcs_enabled))
 		return 1;
 
-	if (unlikely(!kvm_hv_get_assist_page(vcpu, &assist_page)))
+	if (!nested_enlightened_vmentry(vcpu, &evmcs_gpa))
 		return 1;
 
-	if (unlikely(!assist_page.enlighten_vmentry))
-		return 1;
-
-	if (unlikely(assist_page.current_nested_vmcs !=
-		     vmx->nested.hv_evmcs_vmptr)) {
-
+	if (unlikely(evmcs_gpa != vmx->nested.hv_evmcs_vmptr)) {
 		if (!vmx->nested.hv_evmcs)
 			vmx->nested.current_vmptr = -1ull;
 
 		nested_release_evmcs(vcpu);
 
-		if (kvm_vcpu_map(vcpu, gpa_to_gfn(assist_page.current_nested_vmcs),
+		if (kvm_vcpu_map(vcpu, gpa_to_gfn(evmcs_gpa),
 				 &vmx->nested.hv_evmcs_map))
 			return 0;
 
@@ -1820,7 +1815,7 @@ static int nested_vmx_handle_enlightened_vmptrld(struct kvm_vcpu *vcpu,
 		}
 
 		vmx->nested.dirty_vmcs12 = true;
-		vmx->nested.hv_evmcs_vmptr = assist_page.current_nested_vmcs;
+		vmx->nested.hv_evmcs_vmptr = evmcs_gpa;
 
 		evmcs_gpa_changed = true;
 		/*
@@ -4335,6 +4330,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 zero = 0;
 	gpa_t vmptr;
+	u64 evmcs_gpa;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
@@ -4350,10 +4346,18 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 		return nested_vmx_failValid(vcpu,
 			VMXERR_VMCLEAR_VMXON_POINTER);
 
-	if (vmx->nested.hv_evmcs_map.hva) {
-		if (vmptr == vmx->nested.hv_evmcs_vmptr)
-			nested_release_evmcs(vcpu);
-	} else {
+	/*
+	 * When Enlightened VMEntry is enabled on the calling CPU we treat
+	 * memory area pointer by vmptr as Enlightened VMCS (as there's no good
+	 * way to distinguish it from VMCS12) and we must not corrupt it by
+	 * writing to the non-existent 'launch_state' field. The area doesn't
+	 * have to be the currently active EVMCS on the calling CPU and there's
+	 * nothing KVM has to do to transition it from 'active' to 'non-active'
+	 * state. It is possible that the area will stay mapped as
+	 * vmx->nested.hv_evmcs but this shouldn't be a problem.
+	 */
+	if (likely(!vmx->nested.enlightened_vmcs_enabled ||
+		   !nested_enlightened_vmentry(vcpu, &evmcs_gpa))) {
 		if (vmptr == vmx->nested.current_vmptr)
 			nested_release_vmcs12(vcpu);
 
-- 
2.20.1

