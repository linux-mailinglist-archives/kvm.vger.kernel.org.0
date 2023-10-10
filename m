Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C494B7C012B
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 18:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbjJJQEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 12:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbjJJQEK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 12:04:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1EA6A7
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 09:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696953797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NWcz0QuaamBHPubxsGVpnjxU2WbSV2mTYTPQXIgc2HM=;
        b=QfbWEXJGjZsk5xkmbLuRSNEjS/LPthgnLa2zTnJ7LqXdR1SXY3dQvcEussLNmnLnF9/4ok
        ejFSKno+ftuUxezPcral8Inm8QN6+VnBkaZYQ+62RsNnoPUdXgWsQrASoMPQZ+A4+I3rX+
        uVYDM5r817oIKIDIb19ARjNLm1ZGnWw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-bo9lrJ0uMFeRNKVEJqenWQ-1; Tue, 10 Oct 2023 12:03:13 -0400
X-MC-Unique: bo9lrJ0uMFeRNKVEJqenWQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAA2485A5BE;
        Tue, 10 Oct 2023 16:03:12 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26FBE1B94;
        Tue, 10 Oct 2023 16:03:12 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH RFC 10/11] KVM: nVMX: hyper-v: Hide more stuff under CONFIG_KVM_HYPERV
Date:   Tue, 10 Oct 2023 18:02:59 +0200
Message-ID: <20231010160300.1136799-11-vkuznets@redhat.com>
In-Reply-To: <20231010160300.1136799-1-vkuznets@redhat.com>
References: <20231010160300.1136799-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'hv_evmcs_vmptr'/'hv_evmcs_map'/'hv_evmcs' fields in 'struct nested_vmx'
should not be used when !CONFIG_KVM_HYPERV, hide them when
!CONFIG_KVM_HYPERV.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 2 ++
 arch/x86/kvm/vmx/vmx.c    | 3 +++
 arch/x86/kvm/vmx/vmx.h    | 2 ++
 3 files changed, 7 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d539904d8f1e..10cb35cd7a19 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6650,6 +6650,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 
 		set_current_vmptr(vmx, kvm_state->hdr.vmx.vmcs12_pa);
+#ifdef CONFIG_KVM_HYPERV
 	} else if (kvm_state->flags & KVM_STATE_NESTED_EVMCS) {
 		/*
 		 * nested_vmx_handle_enlightened_vmptrld() cannot be called
@@ -6659,6 +6660,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		 */
 		vmx->nested.hv_evmcs_vmptr = EVMPTR_MAP_PENDING;
 		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
+#endif
 	} else {
 		return -EINVAL;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 04eb5d4d28bc..3b1bd3d97150 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4834,7 +4834,10 @@ static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	vmx->nested.posted_intr_nv = -1;
 	vmx->nested.vmxon_ptr = INVALID_GPA;
 	vmx->nested.current_vmptr = INVALID_GPA;
+
+#ifdef CONFIG_KVM_HYPERV
 	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
+#endif
 
 	vcpu->arch.microcode_version = 0x100000000ULL;
 	vmx->msr_ia32_feature_control_valid_bits = FEAT_CTL_LOCKED;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index c2130d2c8e24..55addb8eef01 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -241,9 +241,11 @@ struct nested_vmx {
 		bool guest_mode;
 	} smm;
 
+#ifdef CONFIG_KVM_HYPERV
 	gpa_t hv_evmcs_vmptr;
 	struct kvm_host_map hv_evmcs_map;
 	struct hv_enlightened_vmcs *hv_evmcs;
+#endif
 };
 
 struct vcpu_vmx {
-- 
2.41.0

