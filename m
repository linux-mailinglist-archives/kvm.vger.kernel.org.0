Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5744F8439
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 17:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345306AbiDGP7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 11:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345303AbiDGP7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 11:59:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 46168CD64D
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 08:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649347030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nTqvwcAlY6CYewXqdt7KubzIeeUKOoXEAcdnufjwWCI=;
        b=Y0yHsZrUFU7cDcS3Z5erM3KgaUwxFMqY+1PtvVFWtxbjsHttXqy0W0PoAsxNgfrhQCK9IX
        NrGtajO0V3tcZNqC7E2w0APrhVFRs873KfGKsSd+uoQ9/9XTq/Tv1AbgqbX+uD4Nn90svn
        F2hO0Nduhr7sQnMSCbVoVhdEXikmXCw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-Sp_a8_oVM6-I27_nOIpR5A-1; Thu, 07 Apr 2022 11:57:09 -0400
X-MC-Unique: Sp_a8_oVM6-I27_nOIpR5A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7FBE858F19;
        Thu,  7 Apr 2022 15:57:08 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1876428EE1;
        Thu,  7 Apr 2022 15:57:06 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/31] KVM: nVMX: Keep track of hv_vm_id/hv_vp_id when eVMCS is in use
Date:   Thu,  7 Apr 2022 17:56:23 +0200
Message-Id: <20220407155645.940890-10-vkuznets@redhat.com>
In-Reply-To: <20220407155645.940890-1-vkuznets@redhat.com>
References: <20220407155645.940890-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To handle Direct TLB flush requests from L2, KVM needs to keep track
of L2's VM_ID/VP_IDs which are set by L1 hypervisor. 'Partition assist
page' address is also needed to handle post-flush exit to L1 upon
request.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/vmx/nested.c       | 15 +++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4458abc1d41d..01f094a2208f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -622,6 +622,12 @@ struct kvm_vcpu_hv {
 
 	/* Preallocated buffer for handling hypercalls passing sparse vCPU set */
 	u64 sparse_banks[64];
+
+	struct {
+		u64 pa_page_gpa;
+		u64 vm_id;
+		u32 vp_id;
+	} nested;
 };
 
 /* Xen HVM per vcpu emulation context */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f18744f7ff82..4075cf8d61f4 100644
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
@@ -1592,11 +1599,19 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
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
2.35.1

