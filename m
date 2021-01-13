Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC4C2F4D51
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 15:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbhAMOjB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 09:39:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30688 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726492AbhAMOjA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 09:39:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610548653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DSWza1pLefjTPdtH59MZHMtC3byDyGWJLydnL5pSMfQ=;
        b=aO/hv0u8kIstZMtC/m+f2vk2Htm07rE9MdAe++4EQlrCSV42Y98ssRGK17l9O4weoAg0MJ
        PV9SPi+cbOD/Rm+EdbKJhdHy4kAs7WZrHmOgMxQSV4MSxSK2qFIvhrBc79GPhnGB6nPoO4
        uYIm/UsTwc8ZgBj3fHV6Y1uKNQjB21I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-RtzqT6jMPUuwvOBDGpZoxg-1; Wed, 13 Jan 2021 09:37:32 -0500
X-MC-Unique: RtzqT6jMPUuwvOBDGpZoxg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AC0A80A5C0;
        Wed, 13 Jan 2021 14:37:31 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 745F65C3E0;
        Wed, 13 Jan 2021 14:37:29 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 3/7] KVM: x86: hyper-v: Always use vcpu_to_hv_vcpu() accessor to get to 'struct kvm_vcpu_hv'
Date:   Wed, 13 Jan 2021 15:37:17 +0100
Message-Id: <20210113143721.328594-4-vkuznets@redhat.com>
In-Reply-To: <20210113143721.328594-1-vkuznets@redhat.com>
References: <20210113143721.328594-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a preparation to allocating Hyper-V context dynamically, make it clear
who's the user of the said context.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c  | 14 ++++++++------
 arch/x86/kvm/hyperv.h  |  4 +++-
 arch/x86/kvm/lapic.h   |  6 +++++-
 arch/x86/kvm/vmx/vmx.c |  9 ++++++---
 arch/x86/kvm/x86.c     |  4 +++-
 5 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 922c69dcca4d..82f51346118f 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -190,7 +190,7 @@ static void kvm_hv_notify_acked_sint(struct kvm_vcpu *vcpu, u32 sint)
 static void synic_exit(struct kvm_vcpu_hv_synic *synic, u32 msr)
 {
 	struct kvm_vcpu *vcpu = synic_to_vcpu(synic);
-	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
+	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
 
 	hv_vcpu->exit.type = KVM_EXIT_HYPERV_SYNIC;
 	hv_vcpu->exit.u.synic.msr = msr;
@@ -294,7 +294,7 @@ static int kvm_hv_syndbg_complete_userspace(struct kvm_vcpu *vcpu)
 static void syndbg_exit(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
-	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
+	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
 
 	hv_vcpu->exit.type = KVM_EXIT_HYPERV_SYNDBG;
 	hv_vcpu->exit.u.syndbg.msr = msr;
@@ -840,7 +840,9 @@ void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu)
 
 bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu)
 {
-	if (!(vcpu->arch.hyperv.hv_vapic & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE))
+	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
+
+	if (!(hv_vcpu->hv_vapic & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE))
 		return false;
 	return vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED;
 }
@@ -1216,7 +1218,7 @@ static u64 current_task_runtime_100ns(void)
 
 static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 {
-	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
+	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
 
 	switch (msr) {
 	case HV_X64_MSR_VP_INDEX: {
@@ -1379,7 +1381,7 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 			  bool host)
 {
 	u64 data = 0;
-	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
+	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
 
 	switch (msr) {
 	case HV_X64_MSR_VP_INDEX:
@@ -1494,7 +1496,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *current_vcpu, u64 ingpa,
 			    u16 rep_cnt, bool ex)
 {
 	struct kvm *kvm = current_vcpu->kvm;
-	struct kvm_vcpu_hv *hv_vcpu = &current_vcpu->arch.hyperv;
+	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(current_vcpu);
 	struct hv_tlb_flush_ex flush_ex;
 	struct hv_tlb_flush flush;
 	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 6d7def2b0aad..6300038e7a52 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -114,7 +114,9 @@ static inline struct kvm_vcpu *stimer_to_vcpu(struct kvm_vcpu_hv_stimer *stimer)
 
 static inline bool kvm_hv_has_stimer_pending(struct kvm_vcpu *vcpu)
 {
-	return !bitmap_empty(vcpu->arch.hyperv.stimer_pending_bitmap,
+	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
+
+	return !bitmap_empty(hv_vcpu->stimer_pending_bitmap,
 			     HV_SYNIC_STIMER_COUNT);
 }
 
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 4fb86e3a9dd3..dec7356f2fcd 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -6,6 +6,8 @@
 
 #include <linux/kvm_host.h>
 
+#include "hyperv.h"
+
 #define KVM_APIC_INIT		0
 #define KVM_APIC_SIPI		1
 #define KVM_APIC_LVT_NUM	6
@@ -127,7 +129,9 @@ int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 
 static inline bool kvm_hv_vapic_assist_page_enabled(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.hyperv.hv_vapic & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE;
+	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
+
+	return hv_vcpu->hv_vapic & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE;
 }
 
 int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 75c9c6a0a3a4..7fe09b69a465 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -50,6 +50,7 @@
 #include "capabilities.h"
 #include "cpuid.h"
 #include "evmcs.h"
+#include "hyperv.h"
 #include "irq.h"
 #include "kvm_cache_regs.h"
 #include "lapic.h"
@@ -6732,12 +6733,14 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
 
 	/* All fields are clean at this point */
-	if (static_branch_unlikely(&enable_evmcs))
+	if (static_branch_unlikely(&enable_evmcs)) {
+		struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
+
 		current_evmcs->hv_clean_fields |=
 			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 
-	if (static_branch_unlikely(&enable_evmcs))
-		current_evmcs->hv_vp_id = vcpu->arch.hyperv.vp_index;
+		current_evmcs->hv_vp_id = hv_vcpu->vp_index;
+	}
 
 	/* MSR_IA32_DEBUGCTLMSR is zeroed on vmexit. Restore it if needed */
 	if (vmx->host_debugctlmsr)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3f7c1fc7a3ce..30fbbf53ff1e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8879,8 +8879,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			goto out;
 		}
 		if (kvm_check_request(KVM_REQ_HV_EXIT, vcpu)) {
+			struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
+
 			vcpu->run->exit_reason = KVM_EXIT_HYPERV;
-			vcpu->run->hyperv = vcpu->arch.hyperv.exit;
+			vcpu->run->hyperv = hv_vcpu->exit;
 			r = 0;
 			goto out;
 		}
-- 
2.29.2

