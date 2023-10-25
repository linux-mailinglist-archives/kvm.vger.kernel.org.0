Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49707D70D1
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 17:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344804AbjJYP0q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 11:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235175AbjJYP0Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 11:26:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E3013D
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 08:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698247466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DJT1dzs0rA2lb6ZxEiA/GvslNdAfBFWFuffs3fDq6+g=;
        b=B8e71YMxo2/cKEEEQfHhzKhXiMuKekMuAGGEECCToy/NOOSz7a1ZBk0mD+dGlQIMJ8DIIP
        R7kcWEJAkBGMh/iAWXuf5xeNpwEWzzeQoa77qNTfKWfoOYQ0QFa9EteEl9zgL5Iz8y1Kcs
        hBOnwyiTXUEsF84msxR2bxQMj8iQ+8A=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-222-B0mAP7kiPwqGwTY9gHC4Bw-1; Wed,
 25 Oct 2023 11:24:23 -0400
X-MC-Unique: B0mAP7kiPwqGwTY9gHC4Bw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 257163827962;
        Wed, 25 Oct 2023 15:24:23 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 397422166B26;
        Wed, 25 Oct 2023 15:24:22 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 13/14] KVM: nVMX: hyper-v: Hide more stuff under CONFIG_KVM_HYPERV
Date:   Wed, 25 Oct 2023 17:24:05 +0200
Message-ID: <20231025152406.1879274-14-vkuznets@redhat.com>
In-Reply-To: <20231025152406.1879274-1-vkuznets@redhat.com>
References: <20231025152406.1879274-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 2 ++
 arch/x86/kvm/vmx/vmx.c    | 3 +++
 arch/x86/kvm/vmx/vmx.h    | 2 ++
 3 files changed, 7 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fa04aa38ad52..4777d867419c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6642,6 +6642,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 
 		set_current_vmptr(vmx, kvm_state->hdr.vmx.vmcs12_pa);
+#ifdef CONFIG_KVM_HYPERV
 	} else if (kvm_state->flags & KVM_STATE_NESTED_EVMCS) {
 		/*
 		 * nested_vmx_handle_enlightened_vmptrld() cannot be called
@@ -6651,6 +6652,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		 */
 		vmx->nested.hv_evmcs_vmptr = EVMPTR_MAP_PENDING;
 		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
+#endif
 	} else {
 		return -EINVAL;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 27411665bef9..6e0ff015c5ff 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4826,7 +4826,10 @@ static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
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

