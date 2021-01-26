Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6108D303F66
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405583AbhAZNzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:55:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33284 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405409AbhAZNuN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 08:50:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611668922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pRIqDxa8Eqp/dceX3rzIDts32DXH9jUfdiWE6LFyhYI=;
        b=UKhvP/xHqtX1OwEb1vt7YrJ28pM2Cq7wv5l9xwaLXPRKEaSy/xkGu5asY7Cqp5np2SrD5i
        KEhwNG0JtlUEIFquJHkRU9EQkFyjOYlR7POWlbbZBAJguV8BTJNv3cL+VC+XVj8OLPIYxo
        HWrAj57Sf5VTcyF/Awiw2rX1644ZclQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-g2rJEuHbMjyqkqZ5CFSYEg-1; Tue, 26 Jan 2021 08:48:40 -0500
X-MC-Unique: g2rJEuHbMjyqkqZ5CFSYEg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74C8F15721;
        Tue, 26 Jan 2021 13:48:39 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E55775D9C2;
        Tue, 26 Jan 2021 13:48:37 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 10/15] KVM: x86: hyper-v: Always use to_hv_vcpu() accessor to get to 'struct kvm_vcpu_hv'
Date:   Tue, 26 Jan 2021 14:48:11 +0100
Message-Id: <20210126134816.1880136-11-vkuznets@redhat.com>
In-Reply-To: <20210126134816.1880136-1-vkuznets@redhat.com>
References: <20210126134816.1880136-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
 arch/x86/kvm/lapic.h   |  2 ++
 arch/x86/kvm/vmx/vmx.c |  8 +++++---
 arch/x86/kvm/x86.c     |  4 +++-
 5 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 9a52a07fab81..18e00fb46b15 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -190,7 +190,7 @@ static void kvm_hv_notify_acked_sint(struct kvm_vcpu *vcpu, u32 sint)
 static void synic_exit(struct kvm_vcpu_hv_synic *synic, u32 msr)
 {
 	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
-	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 
 	hv_vcpu->exit.type = KVM_EXIT_HYPERV_SYNIC;
 	hv_vcpu->exit.u.synic.msr = msr;
@@ -293,7 +293,7 @@ static int kvm_hv_syndbg_complete_userspace(struct kvm_vcpu *vcpu)
 static void syndbg_exit(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_hv_syndbg *syndbg = to_hv_syndbg(vcpu);
-	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 
 	hv_vcpu->exit.type = KVM_EXIT_HYPERV_SYNDBG;
 	hv_vcpu->exit.u.syndbg.msr = msr;
@@ -839,7 +839,9 @@ void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu)
 
 bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu)
 {
-	if (!(vcpu->arch.hyperv.hv_vapic & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE))
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
+	if (!(hv_vcpu->hv_vapic & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE))
 		return false;
 	return vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED;
 }
@@ -1213,7 +1215,7 @@ static u64 current_task_runtime_100ns(void)
 
 static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 {
-	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 
 	switch (msr) {
 	case HV_X64_MSR_VP_INDEX: {
@@ -1376,7 +1378,7 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 			  bool host)
 {
 	u64 data = 0;
-	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 
 	switch (msr) {
 	case HV_X64_MSR_VP_INDEX:
@@ -1494,7 +1496,7 @@ static __always_inline unsigned long *sparse_set_to_vcpu_mask(
 static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool ex)
 {
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(current_vcpu);
 	struct hv_tlb_flush_ex flush_ex;
 	struct hv_tlb_flush flush;
 	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index fdb321ba9c3f..be1e3f5d1df6 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -119,7 +119,9 @@ static inline struct kvm_vcpu *hv_stimer_to_vcpu(struct kvm_vcpu_hv_stimer *stim
 
 static inline bool kvm_hv_has_stimer_pending(struct kvm_vcpu *vcpu)
 {
-	return !bitmap_empty(vcpu->arch.hyperv.stimer_pending_bitmap,
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
+	return !bitmap_empty(hv_vcpu->stimer_pending_bitmap,
 			     HV_SYNIC_STIMER_COUNT);
 }
 
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 4de7579e206c..4ad2fbbd962a 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -6,6 +6,8 @@
 
 #include <linux/kvm_host.h>
 
+#include "hyperv.h"
+
 #define KVM_APIC_INIT		0
 #define KVM_APIC_SIPI		1
 #define KVM_APIC_LVT_NUM	6
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9db84508aa0b..443878dd775c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6733,12 +6733,14 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
 
 	/* All fields are clean at this point */
-	if (static_branch_unlikely(&enable_evmcs))
+	if (static_branch_unlikely(&enable_evmcs)) {
+		struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
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
index 868d2bf8fb95..4c2b1f4260c6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8894,8 +8894,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			goto out;
 		}
 		if (kvm_check_request(KVM_REQ_HV_EXIT, vcpu)) {
+			struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
 			vcpu->run->exit_reason = KVM_EXIT_HYPERV;
-			vcpu->run->hyperv = vcpu->arch.hyperv.exit;
+			vcpu->run->hyperv = hv_vcpu->exit;
 			r = 0;
 			goto out;
 		}
-- 
2.29.2

