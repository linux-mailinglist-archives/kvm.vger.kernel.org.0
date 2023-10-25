Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B867D70E8
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 17:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbjJYPZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 11:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234954AbjJYPZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 11:25:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D81185
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 08:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698247461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aqVJ3m6WMqYD4Mz4M4HGMFb+ujgiADMaHsCLEbrm/TU=;
        b=HDFHOyGeavZ3BnJOY4u8skd06DrjIZKeUhVJ0dKOUFOXdMm1aapZehdJT0qHraWOPn45Hy
        7vInt7ob+VHIM7oNswXYtrMK1v3NzwhXztAMMydxxE64jlG8dJyHIviF9LW3lu//HFFk0M
        hvhtnZSpp9x3Kmzgb8yS19AQnhtl+Pk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-458-nHjdpyvmNDuLue8Mc-4EaA-1; Wed,
 25 Oct 2023 11:24:16 -0400
X-MC-Unique: nHjdpyvmNDuLue8Mc-4EaA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DB1E3827962;
        Wed, 25 Oct 2023 15:24:16 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F2152166B26;
        Wed, 25 Oct 2023 15:24:15 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 07/14] KVM: x86: hyper-v: Introduce kvm_hv_nested_transtion_tlb_flush() helper
Date:   Wed, 25 Oct 2023 17:23:59 +0200
Message-ID: <20231025152406.1879274-8-vkuznets@redhat.com>
In-Reply-To: <20231025152406.1879274-1-vkuznets@redhat.com>
References: <20231025152406.1879274-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a preparation to making Hyper-V emulation optional, introduce a helper
to handle pending KVM_REQ_HV_TLB_FLUSH requests.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.h     | 12 ++++++++++++
 arch/x86/kvm/svm/nested.c | 10 ++--------
 arch/x86/kvm/vmx/nested.c | 10 ++--------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index ddb1d0b019e6..75dcbe598fbc 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -246,6 +246,18 @@ static inline int kvm_hv_verify_vp_assist(struct kvm_vcpu *vcpu)
 	return kvm_hv_get_assist_page(vcpu);
 }
 
+static inline void kvm_hv_nested_transtion_tlb_flush(struct kvm_vcpu *vcpu, bool tdp_enabled)
+{
+	/*
+	 * KVM_REQ_HV_TLB_FLUSH flushes entries from either L1's VP_ID or
+	 * L2's VP_ID upon request from the guest. Make sure we check for
+	 * pending entries in the right FIFO upon L1/L2 transition as these
+	 * requests are put by other vCPUs asynchronously.
+	 */
+	if (to_hv_vcpu(vcpu) && tdp_enabled)
+		kvm_make_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
+}
+
 int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 3fea8c47679e..74c04102ef01 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -487,14 +487,8 @@ static void nested_save_pending_event_to_vmcb12(struct vcpu_svm *svm,
 
 static void nested_svm_transition_tlb_flush(struct kvm_vcpu *vcpu)
 {
-	/*
-	 * KVM_REQ_HV_TLB_FLUSH flushes entries from either L1's VP_ID or
-	 * L2's VP_ID upon request from the guest. Make sure we check for
-	 * pending entries in the right FIFO upon L1/L2 transition as these
-	 * requests are put by other vCPUs asynchronously.
-	 */
-	if (to_hv_vcpu(vcpu) && npt_enabled)
-		kvm_make_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
+	/* Handle pending Hyper-V TLB flush requests */
+	kvm_hv_nested_transtion_tlb_flush(vcpu, npt_enabled);
 
 	/*
 	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c5ec0ef51ff7..382c0746d069 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1139,14 +1139,8 @@ static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	/*
-	 * KVM_REQ_HV_TLB_FLUSH flushes entries from either L1's VP_ID or
-	 * L2's VP_ID upon request from the guest. Make sure we check for
-	 * pending entries in the right FIFO upon L1/L2 transition as these
-	 * requests are put by other vCPUs asynchronously.
-	 */
-	if (to_hv_vcpu(vcpu) && enable_ept)
-		kvm_make_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
+	/* Handle pending Hyper-V TLB flush requests */
+	kvm_hv_nested_transtion_tlb_flush(vcpu, enable_ept);
 
 	/*
 	 * If vmcs12 doesn't use VPID, L1 expects linear and combined mappings
-- 
2.41.0

