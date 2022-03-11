Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984234D6522
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 16:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238457AbiCKPwG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 10:52:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349834AbiCKPvr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 10:51:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2041C1CC7D2
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 07:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647013839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6r/JqSRUySk6LAWAAPPTCCWXEHb1+Sqs9cztwTx0ODo=;
        b=Sfk7ep0v9cmrwWEY+xLCzBzpum717uH9J9DKrXC9l8tbY1NQP8ehZQGJai1zfpQW8YmjhH
        bu/CUmBsrH1YnjsuwqTunQlFo4a45XbrmLoLvy1TXHIEpAVYo0VS7gh2NNR04U0+OtW1xj
        U8ZUf4cbgv6uoQ6B6Pv3WQUJaqEuH/Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-9akMTh3jODir0AtxJpsvyA-1; Fri, 11 Mar 2022 10:50:36 -0500
X-MC-Unique: 9akMTh3jODir0AtxJpsvyA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B981F824FA6;
        Fri, 11 Mar 2022 15:50:34 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40DB6866D1;
        Fri, 11 Mar 2022 15:50:32 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/31] KVM: nVMX: hyper-v: Direct TLB flush
Date:   Fri, 11 Mar 2022 16:49:28 +0100
Message-Id: <20220311154943.2299191-17-vkuznets@redhat.com>
In-Reply-To: <20220311154943.2299191-1-vkuznets@redhat.com>
References: <20220311154943.2299191-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable Direct TLB flush feature on nVMX when:
- Enlightened VMCS is in use.
- Direct TLB flush flag is enabled in eVMCS.
- Direct TLB flush is enabled in partition assist page.

Perform synthetic vmexit to L1 after processing TLB flush call upon
request (HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH).

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c  | 20 ++++++++++++++++++++
 arch/x86/kvm/vmx/evmcs.h  |  3 +++
 arch/x86/kvm/vmx/nested.c | 16 ++++++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 1705c4973636..cdf7ec5cb64c 100644
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
@@ -438,6 +439,25 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+bool nested_evmcs_direct_flush_enabled(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
+	struct hv_vp_assist_page assist_page;
+
+	if (!evmcs)
+		return false;
+
+	if (!evmcs->hv_enlightenments_control.nested_flush_hypercall)
+		return false;
+
+	if (unlikely(!kvm_hv_get_assist_page(vcpu, &assist_page)))
+		return false;
+
+	return assist_page.nested_control.features.directhypercall;
+}
+
 void vmx_post_hv_direct_flush(struct kvm_vcpu *vcpu)
 {
+	nested_vmx_vmexit(vcpu, HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH, 0, 0);
 }
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 8862692a4c5d..ab0949c22d2d 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -65,6 +65,8 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
 #define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
 #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
 
+#define HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH 0x10000031
+
 struct evmcs_field {
 	u16 offset;
 	u16 clean_field;
@@ -244,6 +246,7 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 			uint16_t *vmcs_version);
 void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata);
 int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
+bool nested_evmcs_direct_flush_enabled(struct kvm_vcpu *vcpu);
 void vmx_post_hv_direct_flush(struct kvm_vcpu *vcpu);
 
 #endif /* __KVM_X86_VMX_EVMCS_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3121b761b1ee..efed9a199c84 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1168,6 +1168,17 @@ static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	/*
+	 * KVM_REQ_HV_TLB_FLUSH flushes entries from either L1's VPID or
+	 * L2's VPID upon request from the guest. Make sure we check for
+	 * pending entries for the case when the request got misplaced (e.g.
+	 * a transition from L2->L1 happened while processing Direct TLB flush
+	 * request or vice versa). kvm_hv_vcpu_flush_tlb() will not flush
+	 * anything if there are no requests in the corresponding buffer.
+	 */
+	if (to_hv_vcpu(vcpu))
+		kvm_make_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
+
 	/*
 	 * If vmcs12 doesn't use VPID, L1 expects linear and combined mappings
 	 * for *all* contexts to be flushed on VM-Enter/VM-Exit, i.e. it's a
@@ -5972,6 +5983,11 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
 		 * Handle L2's bus locks in L0 directly.
 		 */
 		return true;
+	case EXIT_REASON_VMCALL:
+		/* Hyper-V Direct TLB flush hypercall is handled by L0 */
+		return kvm_hv_direct_tlb_flush_exposed(vcpu) &&
+			nested_evmcs_direct_flush_enabled(vcpu) &&
+			kvm_hv_is_tlb_flush_hcall(vcpu);
 	default:
 		break;
 	}
-- 
2.35.1

