Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807F1614DED
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 16:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbiKAPLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 11:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiKAPK5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 11:10:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8061F62D
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 08:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667314983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LOUGLluRpMRF9uSeYX+rMhu5JSjqwUvxazi0wJ8T/Q0=;
        b=fHW0oCVztsIX32wp5YJG2ERo7ZCfN2s3zeEHtDpzAyPdF6fkdAshUzeWYuq87wk87eUW7y
        +uA+VvmEh+FwpOm16HPIcevB0O6W5PljTY5BxbNUyI8Kq+edB3lMcFauaPAlXvXk/aWKkH
        1se3dXcShFMOv+AhurFUfm5PmkdM/iU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-4gNBrDGbPk2OCpfdBODVWg-1; Tue, 01 Nov 2022 10:56:53 -0400
X-MC-Unique: 4gNBrDGbPk2OCpfdBODVWg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C3468027F5;
        Tue,  1 Nov 2022 14:56:53 +0000 (UTC)
Received: from ovpn-194-149.brq.redhat.com (ovpn-194-149.brq.redhat.com [10.40.194.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32FA4C15BA5;
        Tue,  1 Nov 2022 14:56:51 +0000 (UTC)
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
Subject: [PATCH v13 44/48] KVM: selftests: Stuff RAX/RCX with 'safe' values in vmmcall()/vmcall()
Date:   Tue,  1 Nov 2022 15:54:22 +0100
Message-Id: <20221101145426.251680-45-vkuznets@redhat.com>
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

vmmcall()/vmcall() are used to exit from L2 to L1 and no concrete hypercall
ABI is currenty followed. With the introduction of Hyper-V L2 TLB flush
it becomes (theoretically) possible that L0 will take responsibility for
handling the call and no L1 exit will happen. Prevent this by stuffing RAX
(KVM ABI) and RCX (Hyper-V ABI) with 'safe' values.

While on it, convert vmmcall() to 'static inline', make it setup stack
frame and move to include/x86_64/svm_util.h.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/processor.h      |  5 -----
 .../selftests/kvm/include/x86_64/svm_util.h       | 14 ++++++++++++++
 tools/testing/selftests/kvm/include/x86_64/vmx.h  | 15 ++++++++++-----
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index f21d933a2663..fbaf0b6cec4b 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -510,11 +510,6 @@ static inline void cpu_relax(void)
 	asm volatile("rep; nop" ::: "memory");
 }
 
-#define vmmcall()		\
-	__asm__ __volatile__(	\
-		"vmmcall\n"	\
-		)
-
 #define ud2()			\
 	__asm__ __volatile__(	\
 		"ud2\n"	\
diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
index 7aee6244ab6a..044f0f872ba9 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
@@ -32,6 +32,20 @@ struct svm_test_data {
 	uint64_t msr_gpa;
 };
 
+static inline void vmmcall(void)
+{
+	/*
+	 * Stuff RAX and RCX with "safe" values to make sure L0 doesn't handle
+	 * it as a valid hypercall (e.g. Hyper-V L2 TLB flush) as the intended
+	 * use of this function is to exit to L1 from L2.  Clobber all other
+	 * GPRs as L1 doesn't correctly preserve them during vmexits.
+	 */
+	__asm__ __volatile__("push %%rbp; vmmcall; pop %%rbp"
+			     : : "a"(0xdeadbeef), "c"(0xbeefdead)
+			     : "rbx", "rdx", "rsi", "rdi", "r8", "r9",
+			       "r10", "r11", "r12", "r13", "r14", "r15");
+}
+
 #define stgi()			\
 	__asm__ __volatile__(	\
 		"stgi\n"	\
diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 9e0ef83e7091..ced793fa6a73 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -437,11 +437,16 @@ static inline int vmresume(void)
 
 static inline void vmcall(void)
 {
-	/* Currently, L1 destroys our GPRs during vmexits.  */
-	__asm__ __volatile__("push %%rbp; vmcall; pop %%rbp" : : :
-			     "rax", "rbx", "rcx", "rdx",
-			     "rsi", "rdi", "r8", "r9", "r10", "r11", "r12",
-			     "r13", "r14", "r15");
+	/*
+	 * Stuff RAX and RCX with "safe" values to make sure L0 doesn't handle
+	 * it as a valid hypercall (e.g. Hyper-V L2 TLB flush) as the intended
+	 * use of this function is to exit to L1 from L2.  Clobber all other
+	 * GPRs as L1 doesn't correctly preserve them during vmexits.
+	 */
+	__asm__ __volatile__("push %%rbp; vmcall; pop %%rbp"
+			     : : "a"(0xdeadbeef), "c"(0xbeefdead)
+			     : "rbx", "rdx", "rsi", "rdi", "r8", "r9",
+			       "r10", "r11", "r12", "r13", "r14", "r15");
 }
 
 static inline int vmread(uint64_t encoding, uint64_t *value)
-- 
2.37.3

