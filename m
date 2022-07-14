Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D39E574FDB
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 15:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240194AbiGNNv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 09:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240116AbiGNNun (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 09:50:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1A6CD61D49
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 06:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657806629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3NWYiIwrbWzGQuQHzZltSQbi1JIegzL6rBK0G1Q9IIQ=;
        b=gSSvmgmPyH9xpCN3WX43xBndoYjYNBPyQPeuq2O+4QvDuvQ6etGj7PGFFp0ZQ9NcNusJ3v
        sFPuuXPAz8T6qXh9K8ckq/T1/mIPydLbeymnVlvHmd7/8WJnuDK74cPuCVXOm4di9HSPED
        pq9a0pCxjwIHEU58e3nC5cEW0nHPaTQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-pn0r7VMQNES21wz9BPfdow-1; Thu, 14 Jul 2022 09:50:23 -0400
X-MC-Unique: pn0r7VMQNES21wz9BPfdow-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 715691C01B31;
        Thu, 14 Jul 2022 13:50:22 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 231D92166B26;
        Thu, 14 Jul 2022 13:50:20 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 21/39] KVM: nVMX: hyper-v: Enable L2 TLB flush
Date:   Thu, 14 Jul 2022 15:49:11 +0200
Message-Id: <20220714134929.1125828-22-vkuznets@redhat.com>
In-Reply-To: <20220714134929.1125828-1-vkuznets@redhat.com>
References: <20220714134929.1125828-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable L2 TLB flush feature on nVMX when:
- Enlightened VMCS is in use.
- The feature flag is enabled in eVMCS.
- The feature flag is enabled in partition assist page.

Perform synthetic vmexit to L1 after processing TLB flush call upon
request (HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH).

Note: nested_evmcs_l2_tlb_flush_enabled() uses cached VP assist page copy
which gets updated from nested_vmx_handle_enlightened_vmptrld(). This is
also guaranteed to happen post migration with eVMCS backed L2 running.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c  | 17 +++++++++++++++++
 arch/x86/kvm/vmx/evmcs.h  | 10 ++++++++++
 arch/x86/kvm/vmx/nested.c | 22 ++++++++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 7cd7b16942c6..870de69172be 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -6,6 +6,7 @@
 #include "../hyperv.h"
 #include "../cpuid.h"
 #include "evmcs.h"
+#include "nested.h"
 #include "vmcs.h"
 #include "vmx.h"
 #include "trace.h"
@@ -433,6 +434,22 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
+
+	if (!hv_vcpu || !evmcs)
+		return false;
+
+	if (!evmcs->hv_enlightenments_control.nested_flush_hypercall)
+		return false;
+
+	return hv_vcpu->vp_assist_page.nested_control.features.directhypercall;
+}
+
 void vmx_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu)
 {
+	nested_vmx_vmexit(vcpu, HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH, 0, 0);
 }
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 22d238b36238..0267b6191e6c 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -66,6 +66,15 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
 #define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
 #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
 
+/*
+ * Note, Hyper-V isn't actually stealing bit 28 from Intel, just abusing it by
+ * pairing it with architecturally impossible exit reasons.  Bit 28 is set only
+ * on SMI exits to a SMI transfer monitor (STM) and if and only if a MTF VM-Exit
+ * is pending.  I.e. it will never be set by hardware for non-SMI exits (there
+ * are only three), nor will it ever be set unless the VMM is an STM.
+ */
+#define HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH 0x10000031
+
 struct evmcs_field {
 	u16 offset;
 	u16 clean_field;
@@ -245,6 +254,7 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 			uint16_t *vmcs_version);
 void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata);
 int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
+bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu);
 void vmx_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
 
 #endif /* __KVM_X86_VMX_EVMCS_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b3ebb18375e3..863fdb8c6beb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1171,6 +1171,17 @@ static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	/*
+	 * KVM_REQ_HV_TLB_FLUSH flushes entries from either L1's VP_ID or
+	 * L2's VP_ID upon request from the guest. Make sure we check for
+	 * pending entries for the case when the request got misplaced (e.g.
+	 * a transition from L2->L1 happened while processing L2 TLB flush
+	 * request or vice versa). kvm_hv_vcpu_flush_tlb() will not flush
+	 * anything if there are no requests in the corresponding buffer.
+	 */
+	if (to_hv_vcpu(vcpu))
+		kvm_make_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
+
 	/*
 	 * If vmcs12 doesn't use VPID, L1 expects linear and combined mappings
 	 * for *all* contexts to be flushed on VM-Enter/VM-Exit, i.e. it's a
@@ -3266,6 +3277,12 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 
 static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * Note: nested_get_evmcs_page() also updates 'vp_assist_page' copy
+	 * in 'struct kvm_vcpu_hv' in case eVMCS is in use, this is mandatory
+	 * to make nested_evmcs_l2_tlb_flush_enabled() work correctly post
+	 * migration.
+	 */
 	if (!nested_get_evmcs_page(vcpu)) {
 		pr_debug_ratelimited("%s: enlightened vmptrld failed\n",
 				     __func__);
@@ -5992,6 +6009,11 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
 		 * Handle L2's bus locks in L0 directly.
 		 */
 		return true;
+	case EXIT_REASON_VMCALL:
+		/* Hyper-V L2 TLB flush hypercall is handled by L0 */
+		return guest_hv_cpuid_has_l2_tlb_flush(vcpu) &&
+			nested_evmcs_l2_tlb_flush_enabled(vcpu) &&
+			kvm_hv_is_tlb_flush_hcall(vcpu);
 	default:
 		break;
 	}
-- 
2.35.3

