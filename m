Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3202C5C014B
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 17:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbiIUP0w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 11:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiIUP0I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 11:26:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393B04A103
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663773927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VgwoWDd5bt7nOFU6BFKnmAPSt72XWIGAGR3NfQeIV18=;
        b=H5PQETq1WFy7WhYX4LXEC85gwIicDP4BU+jThVQPZ0dROYio7/+MRJglxp5yh3u5yN9Rby
        D2h0b40RV1xh9V9lXyOZniriZeASbD1tJKc/frOtNasRLNUd9BA/IFNKYNhYoReyYbRpks
        3ETD3biH+6QK7MId3jeBwcKE9rAUzrE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-NB0CfUz5Nku03DujFlZfqA-1; Wed, 21 Sep 2022 11:25:16 -0400
X-MC-Unique: NB0CfUz5Nku03DujFlZfqA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25268296A608;
        Wed, 21 Sep 2022 15:25:16 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D523A2166B26;
        Wed, 21 Sep 2022 15:25:13 +0000 (UTC)
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
Subject: [PATCH v10 13/39] KVM: nVMX: Keep track of hv_vm_id/hv_vp_id when eVMCS is in use
Date:   Wed, 21 Sep 2022 17:24:10 +0200
Message-Id: <20220921152436.3673454-14-vkuznets@redhat.com>
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

To handle L2 TLB flush requests, KVM needs to keep track of L2's VM_ID/
VP_IDs which are set by L1 hypervisor. 'Partition assist page' address is
also needed to handle post-flush exit to L1 upon request.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/vmx/nested.c       | 15 +++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 025c0d6cda69..b2413f58b919 100644
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
index 4da0558943ce..0b79cab4b5fc 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -225,6 +225,7 @@ static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
 
 static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
 {
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
@@ -233,6 +234,12 @@ static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
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
@@ -1557,11 +1564,19 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
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

