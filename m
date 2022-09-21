Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D106D5C015D
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 17:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiIUP1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 11:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbiIUP0v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 11:26:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44287755B
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663773938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2GyyAiTZXcJIAL4UAl4iHShGvCARmYBjvKHE9EFWXTo=;
        b=PX0wgLDijfwPtwG7YlLVNHvLz3/FSfT5NaB7YEZ5QIUcCypYJLTGRSfzcJQaiVYt7nvB7q
        rUYEnGssEUqOG/rJLCm87AsDzKUpDdB8cldxueFzfGyu01TuNb0o1iw5EXKGjlyhm9gJow
        fKMg65aks4uxtb1eFZIthJoJz1wvgsU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-4p1zDNS_MGqT3kzaY9a_zA-1; Wed, 21 Sep 2022 11:25:34 -0400
X-MC-Unique: 4p1zDNS_MGqT3kzaY9a_zA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81E081C0755C;
        Wed, 21 Sep 2022 15:25:33 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 612112166B26;
        Wed, 21 Sep 2022 15:25:31 +0000 (UTC)
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
Subject: [PATCH v10 20/39] KVM: nVMX: hyper-v: Enable L2 TLB flush
Date:   Wed, 21 Sep 2022 17:24:17 +0200
Message-Id: <20220921152436.3673454-21-vkuznets@redhat.com>
In-Reply-To: <20220921152436.3673454-1-vkuznets@redhat.com>
References: <20220921152436.3673454-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
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
index 635a0c81ff1d..f7fedc3ed247 100644
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
@@ -501,6 +502,22 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
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
index 7ad56fbc4b4d..dd1589336e79 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -63,6 +63,15 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
 #define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (0)
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
@@ -241,6 +250,7 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 			uint16_t *vmcs_version);
 void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata);
 int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
+bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu);
 void vmx_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
 
 #endif /* __KVM_X86_VMX_EVMCS_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0634518a6719..1451a7a2c488 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1132,6 +1132,17 @@ static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
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
@@ -3267,6 +3278,12 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 
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
@@ -6143,6 +6160,11 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
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
2.37.3

