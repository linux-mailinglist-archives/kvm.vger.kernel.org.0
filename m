Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCE75F431C
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 14:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiJDMlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 08:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiJDMku (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 08:40:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC8427B03
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 05:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664887225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rS43AypZxrOkyjsu/uie1oIn3FaNNy02n/1hWreF3DM=;
        b=L+LaKFRRXPQ8Fn5hE6VA67ksbUmP5/eW4ATJY0ustF/4bHyYlwZ4qVNhSjYjGigHh/4UAg
        +MufrIOFzc7mC0SKjbFoPDrfVQ8T7DLcGK7IfxE7OlBd7O9IkkUfR80hWRhhTQArTLgE8C
        iRpb4uutzS9/rBf7/f1rsU9pxmD2JYM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-67-K8s0V1HXN0-J98ngCawLyg-1; Tue, 04 Oct 2022 08:40:21 -0400
X-MC-Unique: K8s0V1HXN0-J98ngCawLyg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6C87101245E;
        Tue,  4 Oct 2022 12:40:20 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2FDD77AE5;
        Tue,  4 Oct 2022 12:40:18 +0000 (UTC)
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
Subject: [PATCH v11 08/46] KVM: x86: hyper-v: Resurrect dedicated KVM_REQ_HV_TLB_FLUSH flag
Date:   Tue,  4 Oct 2022 14:39:18 +0200
Message-Id: <20221004123956.188909-9-vkuznets@redhat.com>
In-Reply-To: <20221004123956.188909-1-vkuznets@redhat.com>
References: <20221004123956.188909-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 504daf473092..45c390c804f0 100644
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
index dd599afc85f5..64c5d2bc863f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3737,6 +3737,13 @@ static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
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
index f1e3a4ec53ba..0539d216f760 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3404,6 +3404,12 @@ static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 	}
 
 	static_call(kvm_x86_flush_tlb_guest)(vcpu);
+
+	/*
+	 * Flushing all "guest" TLB is always a superset of Hyper-V's fine
+	 * grained flushing.
+	 */
+	kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
 }
 
 
@@ -10478,6 +10484,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 		kvm_service_local_tlb_flush_requests(vcpu);
 
+		if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
+			kvm_vcpu_flush_tlb_guest(vcpu);
+
 		if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {
 			vcpu->run->exit_reason = KVM_EXIT_TPR_ACCESS;
 			r = 0;
-- 
2.37.3

