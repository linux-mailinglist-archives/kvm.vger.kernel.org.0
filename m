Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592E6536515
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 17:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353731AbiE0P4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 11:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353713AbiE0P4B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 11:56:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C0E913F43E
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 08:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653666959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jvVypFU8cKBqnApHqPxnC+pRazcecZGORSFb1nR7b5w=;
        b=fzX16ic/AGeHJTQwdOAPlXonmgUwCEHoLapGLq46cJfjdZd7TqcLc5LLDQmhsdJorga5mF
        5HS1EzErq5reL+Gf26Z/02bo8nYXwpLhnGkfa3Lb64V5Ug9y/DGoevJvAI6FIqxyaPgS+h
        /UioNFL0gADI39bB7aVBa22zs8Iv+ZM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-AoSqcEdENc6ks_NUSHdZ5A-1; Fri, 27 May 2022 11:55:56 -0400
X-MC-Unique: AoSqcEdENc6ks_NUSHdZ5A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AE0F811E75;
        Fri, 27 May 2022 15:55:55 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B3182166B29;
        Fri, 27 May 2022 15:55:52 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 02/37] KVM: x86: hyper-v: Resurrect dedicated KVM_REQ_HV_TLB_FLUSH flag
Date:   Fri, 27 May 2022 17:55:11 +0200
Message-Id: <20220527155546.1528910-3-vkuznets@redhat.com>
In-Reply-To: <20220527155546.1528910-1-vkuznets@redhat.com>
References: <20220527155546.1528910-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
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

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/hyperv.c           |  4 ++--
 arch/x86/kvm/x86.c              | 10 ++++++++--
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4d9548563c32..01384145b366 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -105,6 +105,8 @@
 	KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_MMU_FREE_OBSOLETE_ROOTS \
 	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_HV_TLB_FLUSH \
+	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 46f9dfb60469..b402ad059eb9 100644
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
index c1f2d8898d80..e83afc454769 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3370,11 +3370,17 @@ static inline void kvm_vcpu_flush_tlb_current(struct kvm_vcpu *vcpu)
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

