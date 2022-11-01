Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC9D614DD3
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 16:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbiKAPIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 11:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiKAPHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 11:07:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8602220D5
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 08:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667314812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LhhcrvG+7RwHzHHKMtMlqTTJoFvq/28FWWa9Z7l4uf8=;
        b=T/nSHSiW/9J27GRLOQRMhIG9j9ncAwg+PZ1bVx2VFhm+NV27VawwVKJbGYtS74P/eG62Ck
        CTk02x/MUA6xHyJbvH9ashe5AOvlBMV5Su6bGtSD/6Q5aUpMZ1Js9M04ie+dK9mDAjvdfO
        Dcz3uzm7MsQroq7VFuiKBX3zdpSM8tM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-483-eyrpg5fiP2uappcwww7VVQ-1; Tue, 01 Nov 2022 10:56:56 -0400
X-MC-Unique: eyrpg5fiP2uappcwww7VVQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9930D1C0BC62;
        Tue,  1 Nov 2022 14:56:55 +0000 (UTC)
Received: from ovpn-194-149.brq.redhat.com (ovpn-194-149.brq.redhat.com [10.40.194.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A36F7C2C8D8;
        Tue,  1 Nov 2022 14:56:53 +0000 (UTC)
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
Subject: [PATCH v13 45/48] KVM: selftests: Introduce rdmsr_from_l2() and use it for MSR-Bitmap tests
Date:   Tue,  1 Nov 2022 15:54:23 +0100
Message-Id: <20221101145426.251680-46-vkuznets@redhat.com>
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

Hyper-V MSR-Bitmap tests do RDMSR from L2 to exit to L1. While 'evmcs_test'
correctly clobbers all GPRs (which are not preserved), 'hyperv_svm_test'
does not. Introduce and use common rdmsr_from_l2() to avoid code
duplication and remove hardcoding of MSRs.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  9 +++++++
 .../testing/selftests/kvm/x86_64/evmcs_test.c | 24 ++++---------------
 .../selftests/kvm/x86_64/hyperv_svm_test.c    |  8 +++----
 3 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index fbaf0b6cec4b..a14b7e4ea7c4 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -520,6 +520,15 @@ static inline void cpu_relax(void)
 		"hlt\n"	\
 		)
 
+/* Exit to L1 from L2 with RDMSR instruction */
+static inline void rdmsr_from_l2(uint32_t msr)
+{
+	/* Currently, L1 doesn't preserve GPRs during vmexits. */
+	__asm__ __volatile__ ("rdmsr" : : "c"(msr) :
+			      "rax", "rbx", "rdx", "rsi", "rdi", "r8", "r9",
+			      "r10", "r11", "r12", "r13", "r14", "r15");
+}
+
 bool is_intel_cpu(void);
 bool is_amd_cpu(void);
 
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 74f076ba574b..a9f511c192c2 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -30,22 +30,6 @@ static void guest_nmi_handler(struct ex_regs *regs)
 {
 }
 
-/* Exits to L1 destroy GRPs! */
-static inline void rdmsr_fs_base(void)
-{
-	__asm__ __volatile__ ("mov $0xc0000100, %%rcx; rdmsr" : : :
-			      "rax", "rbx", "rcx", "rdx",
-			      "rsi", "rdi", "r8", "r9", "r10", "r11", "r12",
-			      "r13", "r14", "r15");
-}
-static inline void rdmsr_gs_base(void)
-{
-	__asm__ __volatile__ ("mov $0xc0000101, %%rcx; rdmsr" : : :
-			      "rax", "rbx", "rcx", "rdx",
-			      "rsi", "rdi", "r8", "r9", "r10", "r11", "r12",
-			      "r13", "r14", "r15");
-}
-
 void l2_guest_code(void)
 {
 	GUEST_SYNC(7);
@@ -58,11 +42,11 @@ void l2_guest_code(void)
 	vmcall();
 
 	/* MSR-Bitmap tests */
-	rdmsr_fs_base(); /* intercepted */
-	rdmsr_fs_base(); /* intercepted */
-	rdmsr_gs_base(); /* not intercepted */
+	rdmsr_from_l2(MSR_FS_BASE); /* intercepted */
+	rdmsr_from_l2(MSR_FS_BASE); /* intercepted */
+	rdmsr_from_l2(MSR_GS_BASE); /* not intercepted */
 	vmcall();
-	rdmsr_gs_base(); /* intercepted */
+	rdmsr_from_l2(MSR_GS_BASE); /* intercepted */
 
 	/* Done, exit to L1 and never come back.  */
 	vmcall();
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
index 1c3fc38b4f15..e30419766c8a 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
@@ -30,11 +30,11 @@ void l2_guest_code(void)
 	vmmcall();
 
 	/* MSR-Bitmap tests */
-	rdmsr(MSR_FS_BASE); /* intercepted */
-	rdmsr(MSR_FS_BASE); /* intercepted */
-	rdmsr(MSR_GS_BASE); /* not intercepted */
+	rdmsr_from_l2(MSR_FS_BASE); /* intercepted */
+	rdmsr_from_l2(MSR_FS_BASE); /* intercepted */
+	rdmsr_from_l2(MSR_GS_BASE); /* not intercepted */
 	vmmcall();
-	rdmsr(MSR_GS_BASE); /* intercepted */
+	rdmsr_from_l2(MSR_GS_BASE); /* intercepted */
 
 	GUEST_SYNC(5);
 
-- 
2.37.3

