Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E07607AF9
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 17:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiJUPgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 11:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiJUPgL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 11:36:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DD026FFB1
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 08:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666366549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RDSHYxVi1kBMKwIC4tF0p+He0fNlSzqqM7rw0k/jC4U=;
        b=DRBfHJ7HFZ7oDaHDTwK/uCBmEvKiF4ses1kI0a8SkPIgvL4SEF6WXxF9OX0A2jfze4JIuC
        xbUX+JEOZAV/xwsU1qsWK6WrZm2phbNBA+0UeAR3bG/Am+1RVrqM/nQPFY2s24VhImG7p3
        9IhItgBse2kiAJQekl+3OQB7Z6Sthxc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-BsqLX6VXMQ2AJdjwfNMmkQ-1; Fri, 21 Oct 2022 11:35:48 -0400
X-MC-Unique: BsqLX6VXMQ2AJdjwfNMmkQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 632F7800B30;
        Fri, 21 Oct 2022 15:35:47 +0000 (UTC)
Received: from ovpn-192-65.brq.redhat.com (ovpn-192-65.brq.redhat.com [10.40.192.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 88E0740CA41F;
        Fri, 21 Oct 2022 15:35:44 +0000 (UTC)
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
Subject: [PATCH v12 08/46] KVM: x86: hyper-v: Resurrect dedicated KVM_REQ_HV_TLB_FLUSH flag
Date:   Fri, 21 Oct 2022 17:34:43 +0200
Message-Id: <20221021153521.1216911-9-vkuznets@redhat.com>
In-Reply-To: <20221021153521.1216911-1-vkuznets@redhat.com>
References: <20221021153521.1216911-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation to implementing fine-grained Hyper-V TLB flush and
L2 TLB flush, resurrect dedicated KVM_REQ_HV_TLB_FLUSH request bit. As
KVM_REQ_TLB_FLUSH_GUEST is a stronger operation, clear KVM_REQ_HV_TLB_FLUSH
request in kvm_vcpu_flush_tlb_guest().

The flush itself is temporary handled by kvm_vcpu_flush_tlb_guest().

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/hyperv.c           | 4 ++--
 arch/x86/kvm/svm/svm.c          | 7 +++++++
 arch/x86/kvm/x86.c              | 9 +++++++++
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 50fe0c7a5571..05d90e11e535 100644
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
index 0adf4a437e85..3c0f639f6a05 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1870,11 +1870,11 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
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
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58f0077d9357..9210a8840224 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3738,6 +3738,13 @@ static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	/*
+	 * Unlike VMX, SVM doesn't provide a way to flush only NPT TLB entries.
+	 * A TLB flush for the current ASID flushes both "host" and "guest" TLB
+	 * entries, and thus is a superset of Hyper-V's fine grained flushing.
+	 */
+	kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
+
 	/*
 	 * Flush only the current ASID even if the TLB flush was invoked via
 	 * kvm_flush_remote_tlbs().  Although flushing remote TLBs requires all
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fdda5f447f87..bf2aa77b7a2f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3417,6 +3417,12 @@ static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 	}
 
 	static_call(kvm_x86_flush_tlb_guest)(vcpu);
+
+	/*
+	 * Flushing all "guest" TLB is always a superset of Hyper-V's fine
+	 * grained flushing.
+	 */
+	kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
 }
 
 
@@ -10491,6 +10497,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 		kvm_service_local_tlb_flush_requests(vcpu);
 
+		if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
+			kvm_vcpu_flush_tlb_guest(vcpu);
+
 		if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {
 			vcpu->run->exit_reason = KVM_EXIT_TPR_ACCESS;
 			r = 0;
-- 
2.37.3

