Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2373614D69
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 15:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbiKAO5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 10:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiKAO4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 10:56:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B541C91A
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 07:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667314543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VPRegZuW8RFQJgWdrL1ZPVnD1aDzWB4g8LWboQSy57E=;
        b=PO6kBEL+y8oeU6Qi3Oy4Wnoh29R3VjsVhKX5Mx6MxQwXpLN2Ot+jSxQvmXh7u0X8SRT1f1
        UD4IwapH7iruxHlCEY+7HFb/eWE6BZGMLTX3FTOlIzM70aTG/JGfJ+hlGVPNbBXkgsQC59
        xGRF9vohJAELhuvYNpDb2jPK6AK2YTs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-ErHdDIX5PKS-GmqP6Vf77g-1; Tue, 01 Nov 2022 10:55:38 -0400
X-MC-Unique: ErHdDIX5PKS-GmqP6Vf77g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43BFC1C05EC7;
        Tue,  1 Nov 2022 14:55:28 +0000 (UTC)
Received: from ovpn-194-149.brq.redhat.com (ovpn-194-149.brq.redhat.com [10.40.194.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF236C2C8D8;
        Tue,  1 Nov 2022 14:55:19 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v13 19/48] KVM: nVMX: Keep track of hv_vm_id/hv_vp_id when eVMCS is in use
Date:   Tue,  1 Nov 2022 15:53:57 +0100
Message-Id: <20221101145426.251680-20-vkuznets@redhat.com>
In-Reply-To: <20221101145426.251680-1-vkuznets@redhat.com>
References: <20221101145426.251680-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To handle L2 TLB flush requests, KVM needs to keep track of L2's VM_ID/
VP_IDs which are set by L1 hypervisor. 'Partition assist page' address is
also needed to handle post-flush exit to L1 upon request.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/vmx/nested.c       | 15 +++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5d590157266e..ede163b6f955 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -649,6 +649,12 @@ struct kvm_vcpu_hv {
 
 	/* Preallocated buffer for handling hypercalls passing sparse vCPU set */
 	u64 sparse_banks[HV_MAX_SPARSE_VCPU_BANKS];
+
+	struct {
+		u64 pa_page_gpa;
+		u64 vm_id;
+		u32 vp_id;
+	} nested;
 };
 
 /* Xen HVM per vcpu emulation context */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index feab88a13026..7a4260416d88 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -224,6 +224,7 @@ static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
 
 static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
 {
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
@@ -232,6 +233,12 @@ static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
 	}
 
 	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
+
+	if (hv_vcpu) {
+		hv_vcpu->nested.pa_page_gpa = INVALID_GPA;
+		hv_vcpu->nested.vm_id = 0;
+		hv_vcpu->nested.vp_id = 0;
+	}
 }
 
 static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
@@ -1556,11 +1563,19 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
 {
 	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
 	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(&vmx->vcpu);
 
 	/* HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE */
 	vmcs12->tpr_threshold = evmcs->tpr_threshold;
 	vmcs12->guest_rip = evmcs->guest_rip;
 
+	if (unlikely(!(hv_clean_fields &
+		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_ENLIGHTENMENTSCONTROL))) {
+		hv_vcpu->nested.pa_page_gpa = evmcs->partition_assist_page;
+		hv_vcpu->nested.vm_id = evmcs->hv_vm_id;
+		hv_vcpu->nested.vp_id = evmcs->hv_vp_id;
+	}
+
 	if (unlikely(!(hv_clean_fields &
 		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC))) {
 		vmcs12->guest_rsp = evmcs->guest_rsp;
-- 
2.37.3

