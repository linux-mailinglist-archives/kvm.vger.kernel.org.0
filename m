Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9284C0B02
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 05:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238105AbiBWEU2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 23:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238097AbiBWEUX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 23:20:23 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7483B57E
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:56 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d07ae11464so161220897b3.14
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wX3uLQzTSI1VGuKWaldZ9OxCxf9p8PEqoE0rKvDDfEY=;
        b=Kf5M0rxY7HQQeZge6xI5zVRK2n2hqX67dNO4ZfduWzrnYcNHFWeUg6et/fV66kMTv9
         f3yK6Yl1K3Rf5O3bbEuBdW12/ZYF9SuD5mkVNppx/+UfgCTU0qr6XUJkDPFOc/Oe37sU
         EUWuxkItN92Y6rYy1DwSj8++FXcg1m+6/7j1CFy0Na2YsV+ZP/ayfTUOl0p7Mh1TzUGE
         x/59SqmzMR2JBIXSbQaVin+KiZw9cDuhjNnx/nH5/fQs7TJQ+IZZBeLXQn209Lx0af92
         4jmDJJiHNB9g0ulDKUFPq7U1w6vuxSjflkmLk7luJbee+y9MyDgIBi+MVcqR6av2cYo1
         tvOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wX3uLQzTSI1VGuKWaldZ9OxCxf9p8PEqoE0rKvDDfEY=;
        b=qBkoK5yekmgdEdzybpUP3y4wa4kB9X0hwiSN4qUmH4g94wzac8DyVJhaeGkGCOC/qY
         T0ukWNzaHbMKu/Mwunn3VWk242URg5CI8Sr7CSDsNJnreutD55zHKBD/21+IvmijWE/H
         HxjjjGyPx96E/Jv5HCmqGvFpUZp/TfejGN9u0Ea46fP/OaGoiHant5KdFckIpLYeGtHE
         mxsskRzaN5MgBTucSKv3Huuo3fDt4SlXH8TasQcSAg1VSgAx+O+pwgx8poe/uQ4ZavwB
         aU2rzBp28THQ9cmjm73viQMLro4d2CzxTbnWsN6Z9851EOCpek5OiFhROgHAstYPGVKn
         yYUA==
X-Gm-Message-State: AOAM530h0brNfCbHY7dt/rUlTGbT891pawFJTaqXXAr1vUAgbhf1BBV+
        tFeVQ3d5j3rnf8ss172mo4NRd7Zpb2w=
X-Google-Smtp-Source: ABdhPJx2YT+GU5lWSgnrMCYBlsHI2XDxNPpCJLOOdiCNG5irLKCRPgODRJMyBSnjRIKFdre9AH202Lw+e4M=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:ac53:0:b0:624:6fce:7c6e with SMTP id
 r19-20020a25ac53000000b006246fce7c6emr16211592ybd.164.1645589996212; Tue, 22
 Feb 2022 20:19:56 -0800 (PST)
Date:   Wed, 23 Feb 2022 04:18:41 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-17-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 16/19] selftests: KVM: Create helper for making SMCCC calls
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Oliver Upton <oupton@google.com>,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PSCI and PV stolen time tests both need to make SMCCC calls within
the guest. Create a helper for making SMCCC calls and rework the
existing tests to use the library function.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 .../testing/selftests/kvm/aarch64/psci_test.c | 25 ++++++-------------
 .../selftests/kvm/include/aarch64/processor.h | 22 ++++++++++++++++
 .../selftests/kvm/lib/aarch64/processor.c     | 25 +++++++++++++++++++
 tools/testing/selftests/kvm/steal_time.c      | 13 +++-------
 4 files changed, 58 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index 4c5f6814030f..8c998f0b802c 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -26,32 +26,23 @@
 static uint64_t psci_cpu_on(uint64_t target_cpu, uint64_t entry_addr,
 			    uint64_t context_id)
 {
-	register uint64_t x0 asm("x0") = PSCI_0_2_FN64_CPU_ON;
-	register uint64_t x1 asm("x1") = target_cpu;
-	register uint64_t x2 asm("x2") = entry_addr;
-	register uint64_t x3 asm("x3") = context_id;
+	struct arm_smccc_res res;
 
-	asm("hvc #0"
-	    : "=r"(x0)
-	    : "r"(x0), "r"(x1), "r"(x2), "r"(x3)
-	    : "memory");
+	smccc_hvc(PSCI_0_2_FN64_CPU_ON, target_cpu, entry_addr, context_id,
+		  0, 0, 0, 0, &res);
 
-	return x0;
+	return res.a0;
 }
 
 static uint64_t psci_affinity_info(uint64_t target_affinity,
 				   uint64_t lowest_affinity_level)
 {
-	register uint64_t x0 asm("x0") = PSCI_0_2_FN64_AFFINITY_INFO;
-	register uint64_t x1 asm("x1") = target_affinity;
-	register uint64_t x2 asm("x2") = lowest_affinity_level;
+	struct arm_smccc_res res;
 
-	asm("hvc #0"
-	    : "=r"(x0)
-	    : "r"(x0), "r"(x1), "r"(x2)
-	    : "memory");
+	smccc_hvc(PSCI_0_2_FN64_AFFINITY_INFO, target_affinity, lowest_affinity_level,
+		  0, 0, 0, 0, 0, &res);
 
-	return x0;
+	return res.a0;
 }
 
 static void guest_main(uint64_t target_cpu)
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 8f9f46979a00..59ece9d4e0d1 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -185,4 +185,26 @@ static inline void local_irq_disable(void)
 	asm volatile("msr daifset, #3" : : : "memory");
 }
 
+/**
+ * struct arm_smccc_res - Result from SMC/HVC call
+ * @a0-a3 result values from registers 0 to 3
+ */
+struct arm_smccc_res {
+	unsigned long a0;
+	unsigned long a1;
+	unsigned long a2;
+	unsigned long a3;
+};
+
+/**
+ * smccc_hvc - Invoke a SMCCC function using the hvc conduit
+ * @function_id: the SMCCC function to be called
+ * @arg0-arg6: SMCCC function arguments, corresponding to registers x1-x7
+ * @res: pointer to write the return values from registers x0-x3
+ *
+ */
+void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
+	       uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5,
+	       uint64_t arg6, struct arm_smccc_res *res);
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 9343d82519b4..6a041289fa80 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -500,3 +500,28 @@ void __attribute__((constructor)) init_guest_modes(void)
 {
        guest_modes_append_default();
 }
+
+void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
+	       uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5,
+	       uint64_t arg6, struct arm_smccc_res *res)
+{
+	asm volatile("mov   w0, %w[function_id]\n"
+		     "mov   x1, %[arg0]\n"
+		     "mov   x2, %[arg1]\n"
+		     "mov   x3, %[arg2]\n"
+		     "mov   x4, %[arg3]\n"
+		     "mov   x5, %[arg4]\n"
+		     "mov   x6, %[arg5]\n"
+		     "mov   x7, %[arg6]\n"
+		     "hvc   #0\n"
+		     "mov   %[res0], x0\n"
+		     "mov   %[res1], x1\n"
+		     "mov   %[res2], x2\n"
+		     "mov   %[res3], x3\n"
+		     : [res0] "=r"(res->a0), [res1] "=r"(res->a1),
+		       [res2] "=r"(res->a2), [res3] "=r"(res->a3)
+		     : [function_id] "r"(function_id), [arg0] "r"(arg0),
+		       [arg1] "r"(arg1), [arg2] "r"(arg2), [arg3] "r"(arg3),
+		       [arg4] "r"(arg4), [arg5] "r"(arg5), [arg6] "r"(arg6)
+		     : "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7");
+}
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 62f2eb9ee3d5..8c4e811bd586 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -118,17 +118,10 @@ struct st_time {
 
 static int64_t smccc(uint32_t func, uint64_t arg)
 {
-	unsigned long ret;
+	struct arm_smccc_res res;
 
-	asm volatile(
-		"mov	w0, %w1\n"
-		"mov	x1, %2\n"
-		"hvc	#0\n"
-		"mov	%0, x0\n"
-	: "=r" (ret) : "r" (func), "r" (arg) :
-	  "x0", "x1", "x2", "x3");
-
-	return ret;
+	smccc_hvc(func, arg, 0, 0, 0, 0, 0, 0, &res);
+	return res.a0;
 }
 
 static void check_status(struct st_time *st)
-- 
2.35.1.473.g83b2b277ed-goog

