Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334ED588D54
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 15:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237995AbiHCNl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 09:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237978AbiHCNl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 09:41:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 804256567
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 06:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659534083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gg5x542UJMY4IXoXA5LSeOoEwqDIJ2MzCT9W4GzukKw=;
        b=PDA2MbTkAlyP/NsdtTGJ8Z9sVui/enXzgpHTS192dg6K1zYf5t2qQKbyXcaRkzRT+okdgn
        9m4Nseh3MlbvGLjbaH+TVpQqkhBtpBDeP5UxWcmuh7QN3fPkyyxfDFVgDdgIdvFVK9a2kG
        C9HDQ26nY86HYHAgHUnom0sq5cenAcI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-nPQvsSEvNkqMIm9WPvasAA-1; Wed, 03 Aug 2022 09:41:19 -0400
X-MC-Unique: nPQvsSEvNkqMIm9WPvasAA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E84901881451;
        Wed,  3 Aug 2022 13:41:18 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7136A492C3B;
        Wed,  3 Aug 2022 13:41:16 +0000 (UTC)
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
Subject: [PATCH v9 02/40] KVM: x86: hyper-v: Resurrect dedicated KVM_REQ_HV_TLB_FLUSH flag
Date:   Wed,  3 Aug 2022 15:40:32 +0200
Message-Id: <20220803134110.397885-3-vkuznets@redhat.com>
In-Reply-To: <20220803134110.397885-1-vkuznets@redhat.com>
References: <20220803134110.397885-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation to implementing fine-grained Hyper-V TLB flush and
L2 TLB flush, resurrect dedicated KVM_REQ_HV_TLB_FLUSH request bit. As
KVM_REQ_TLB_FLUSH_GUEST/KVM_REQ_TLB_FLUSH_CURRENT are stronger operations,
clear KVM_REQ_HV_TLB_FLUSH request in kvm_service_local_tlb_flush_requests()
when any of these were also requested.

No (real) functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/hyperv.c           |  4 ++--
 arch/x86/kvm/x86.c              | 10 ++++++++--
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 503262dd6a85..c851db4344a9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -108,6 +108,8 @@
 	KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_MMU_FREE_OBSOLETE_ROOTS \
 	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_HV_TLB_FLUSH \
+	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index ed804447589c..ff69352d1387 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1876,11 +1876,11 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	 * analyze it here, flush TLB regardless of the specified address space.
 	 */
 	if (all_cpus) {
-		kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH_GUEST);
+		kvm_make_all_cpus_request(kvm, KVM_REQ_HV_TLB_FLUSH);
 	} else {
 		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask, vcpu_mask);
 
-		kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST, vcpu_mask);
+		kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH, vcpu_mask);
 	}
 
 ret_success:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 55b37dba6c54..eea435013bd0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3401,11 +3401,17 @@ static inline void kvm_vcpu_flush_tlb_current(struct kvm_vcpu *vcpu)
  */
 void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu)
 {
-	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
+	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu)) {
 		kvm_vcpu_flush_tlb_current(vcpu);
+		kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
+	}
 
-	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu))
+	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu)) {
+		kvm_vcpu_flush_tlb_guest(vcpu);
+		kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
+	} else if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu)) {
 		kvm_vcpu_flush_tlb_guest(vcpu);
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_service_local_tlb_flush_requests);
 
-- 
2.35.3

