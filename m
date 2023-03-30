Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6246D0A65
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 17:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbjC3Pu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 11:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbjC3PuW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 11:50:22 -0400
Received: from out-18.mta1.migadu.com (out-18.mta1.migadu.com [IPv6:2001:41d0:203:375::12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E140993F9
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 08:49:59 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680191393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5vP+Gfs+9zHHCR8XXLDdZLzVRuJOqjfpkgA4LdG4drY=;
        b=On9NpbYx91kNxmdnVdTIQaYEnZXRbKZM8azN0otm6NeK02G2oCjgcHgp07/Jh/jsouP5/J
        hGABXjTAenpXzWYFJS3MjDr5hP6iF4gM5XgAzCJ9hTWpyItlLeP1hPv3oaLi9VHTek7u04
        rUCygI2ThPNOBkpjBlS/cLW0/Jlmm8g=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 12/13] KVM: selftests: Add a helper for SMCCC calls with SMC instruction
Date:   Thu, 30 Mar 2023 15:49:17 +0000
Message-Id: <20230330154918.4014761-13-oliver.upton@linux.dev>
In-Reply-To: <20230330154918.4014761-1-oliver.upton@linux.dev>
References: <20230330154918.4014761-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Build a helper for doing SMCs in selftests by macro-izing the current
HVC implementation and taking the conduit instruction as an argument.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../selftests/kvm/include/aarch64/processor.h | 13 +++++
 .../selftests/kvm/lib/aarch64/processor.c     | 52 ++++++++++++-------
 2 files changed, 46 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 5f977528e09c..cb537253a6b9 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -214,6 +214,19 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
 	       uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5,
 	       uint64_t arg6, struct arm_smccc_res *res);
 
+/**
+ * smccc_smc - Invoke a SMCCC function using the smc conduit
+ * @function_id: the SMCCC function to be called
+ * @arg0-arg6: SMCCC function arguments, corresponding to registers x1-x7
+ * @res: pointer to write the return values from registers x0-x3
+ *
+ */
+void smccc_smc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
+	       uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5,
+	       uint64_t arg6, struct arm_smccc_res *res);
+
+
+
 uint32_t guest_get_vcpuid(void);
 
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 5972a23b2765..24e8122307f4 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -508,29 +508,43 @@ void aarch64_get_supported_page_sizes(uint32_t ipa,
 	close(kvm_fd);
 }
 
+#define __smccc_call(insn, function_id, arg0, arg1, arg2, arg3, arg4, arg5,	\
+		     arg6, res)							\
+	asm volatile("mov   w0, %w[function_id]\n"				\
+		     "mov   x1, %[arg0]\n"					\
+		     "mov   x2, %[arg1]\n"					\
+		     "mov   x3, %[arg2]\n"					\
+		     "mov   x4, %[arg3]\n"					\
+		     "mov   x5, %[arg4]\n"					\
+		     "mov   x6, %[arg5]\n"					\
+		     "mov   x7, %[arg6]\n"					\
+		     #insn  "#0\n"						\
+		     "mov   %[res0], x0\n"					\
+		     "mov   %[res1], x1\n"					\
+		     "mov   %[res2], x2\n"					\
+		     "mov   %[res3], x3\n"					\
+		     : [res0] "=r"(res->a0), [res1] "=r"(res->a1),		\
+		       [res2] "=r"(res->a2), [res3] "=r"(res->a3)		\
+		     : [function_id] "r"(function_id), [arg0] "r"(arg0),	\
+		       [arg1] "r"(arg1), [arg2] "r"(arg2), [arg3] "r"(arg3),	\
+		       [arg4] "r"(arg4), [arg5] "r"(arg5), [arg6] "r"(arg6)	\
+		     : "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7")
+
+
 void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
 	       uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5,
 	       uint64_t arg6, struct arm_smccc_res *res)
 {
-	asm volatile("mov   w0, %w[function_id]\n"
-		     "mov   x1, %[arg0]\n"
-		     "mov   x2, %[arg1]\n"
-		     "mov   x3, %[arg2]\n"
-		     "mov   x4, %[arg3]\n"
-		     "mov   x5, %[arg4]\n"
-		     "mov   x6, %[arg5]\n"
-		     "mov   x7, %[arg6]\n"
-		     "hvc   #0\n"
-		     "mov   %[res0], x0\n"
-		     "mov   %[res1], x1\n"
-		     "mov   %[res2], x2\n"
-		     "mov   %[res3], x3\n"
-		     : [res0] "=r"(res->a0), [res1] "=r"(res->a1),
-		       [res2] "=r"(res->a2), [res3] "=r"(res->a3)
-		     : [function_id] "r"(function_id), [arg0] "r"(arg0),
-		       [arg1] "r"(arg1), [arg2] "r"(arg2), [arg3] "r"(arg3),
-		       [arg4] "r"(arg4), [arg5] "r"(arg5), [arg6] "r"(arg6)
-		     : "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7");
+	__smccc_call(hvc, function_id, arg0, arg1, arg2, arg3, arg4, arg5,
+		     arg6, res);
+}
+
+void smccc_smc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
+	       uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5,
+	       uint64_t arg6, struct arm_smccc_res *res)
+{
+	__smccc_call(smc, function_id, arg0, arg1, arg2, arg3, arg4, arg5,
+		     arg6, res);
 }
 
 void kvm_selftest_arch_init(void)
-- 
2.40.0.348.gf938b09366-goog

