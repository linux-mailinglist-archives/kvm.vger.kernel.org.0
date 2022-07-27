Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C56B5828A1
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 16:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233882AbiG0O3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 10:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233750AbiG0O33 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 10:29:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9712BB2F
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 07:29:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8946EB8218E
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 14:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392D3C43140;
        Wed, 27 Jul 2022 14:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658932166;
        bh=wvQcYBDMZgGC7R1FOa29dKIsNXbtHBpMnjlFhjIm9vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UgZNHlgB582XRBn7Ey7Kho+/sBrG8lYhfh7kb+D4mL49XF0k7j9j8LRGwfe7CxeqC
         Mq5yGqBM0kjg7GsHZAJ6AiVFbeLhVRMf66qBNZCaGW1/za31bT+0eWh+wljcV46LJv
         erhaGIxvMuJtF1QHVeU7ImkosUKqTgzJELeo7+knxFM4r6Z7GBceptEE5sjlVJ8mzc
         IPVP6bioBKAV4CVQWqipSq3IPyxN2A+NnqgDTPT6DyOiYY8WBLWPBSuFlr7dYAxRIC
         xq5cQ12NhJ/5wmJiH+hS5wJUFjQglKbBIpBv7xeJL5/K1QxRkUev1nWXrRIPgOVuRI
         T3Ac90p6eS9Rw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oGi2O-00APjL-7y;
        Wed, 27 Jul 2022 15:29:24 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     mark.rutland@arm.com, broonie@kernel.org,
        madvenka@linux.microsoft.com, tabba@google.com,
        oliver.upton@linux.dev, qperret@google.com, kaleshsingh@google.com,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, catalin.marinas@arm.com,
        andreyknvl@gmail.com, vincenzo.frascino@arm.com,
        mhiramat@kernel.org, ast@kernel.org, wangkefeng.wang@huawei.com,
        elver@google.com, keirf@google.com, yuzenghui@huawei.com,
        ardb@kernel.org, oupton@google.com, kernel-team@android.com
Subject: [PATCH 4/6] KVM: arm64: Move nVHE-only helpers into kvm/stacktrace.c
Date:   Wed, 27 Jul 2022 15:29:04 +0100
Message-Id: <20220727142906.1856759-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220727142906.1856759-1-maz@kernel.org>
References: <20220726073750.3219117-18-kaleshsingh@google.com>
 <20220727142906.1856759-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, mark.rutland@arm.com, broonie@kernel.org, madvenka@linux.microsoft.com, tabba@google.com, oliver.upton@linux.dev, qperret@google.com, kaleshsingh@google.com, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, andreyknvl@gmail.com, vincenzo.frascino@arm.com, mhiramat@kernel.org, ast@kernel.org, wangkefeng.wang@huawei.com, elver@google.com, keirf@google.com, yuzenghui@huawei.com, ardb@kernel.org, oupton@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_nvhe_stack_kern_va() only makes sense as part of the nVHE
unwinder, so simply move it there.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/stacktrace/nvhe.h | 41 ------------------------
 arch/arm64/kvm/stacktrace.c              | 41 ++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
index a096216d8970..d5527b600390 100644
--- a/arch/arm64/include/asm/stacktrace/nvhe.h
+++ b/arch/arm64/include/asm/stacktrace/nvhe.h
@@ -49,47 +49,6 @@ DECLARE_KVM_NVHE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overf
 DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_stacktrace_info, kvm_stacktrace_info);
 DECLARE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 
-/*
- * kvm_nvhe_stack_kern_va - Convert KVM nVHE HYP stack addresses to a kernel VAs
- *
- * The nVHE hypervisor stack is mapped in the flexible 'private' VA range, to
- * allow for guard pages below the stack. Consequently, the fixed offset address
- * translation macros won't work here.
- *
- * The kernel VA is calculated as an offset from the kernel VA of the hypervisor
- * stack base.
- *
- * Returns true on success and updates @addr to its corresponding kernel VA;
- * otherwise returns false.
- */
-static inline bool kvm_nvhe_stack_kern_va(unsigned long *addr,
-					  enum stack_type type)
-{
-	struct kvm_nvhe_stacktrace_info *stacktrace_info;
-	unsigned long hyp_base, kern_base, hyp_offset;
-
-	stacktrace_info = this_cpu_ptr_nvhe_sym(kvm_stacktrace_info);
-
-	switch (type) {
-	case STACK_TYPE_HYP:
-		kern_base = (unsigned long)*this_cpu_ptr(&kvm_arm_hyp_stack_page);
-		hyp_base = (unsigned long)stacktrace_info->stack_base;
-		break;
-	case STACK_TYPE_OVERFLOW:
-		kern_base = (unsigned long)this_cpu_ptr_nvhe_sym(overflow_stack);
-		hyp_base = (unsigned long)stacktrace_info->overflow_stack_base;
-		break;
-	default:
-		return false;
-	}
-
-	hyp_offset = *addr - hyp_base;
-
-	*addr = kern_base + hyp_offset;
-
-	return true;
-}
-
 void kvm_nvhe_dump_backtrace(unsigned long hyp_offset);
 
 #endif	/* __KVM_NVHE_HYPERVISOR__ */
diff --git a/arch/arm64/kvm/stacktrace.c b/arch/arm64/kvm/stacktrace.c
index 4d5fec3175ff..417665854f86 100644
--- a/arch/arm64/kvm/stacktrace.c
+++ b/arch/arm64/kvm/stacktrace.c
@@ -21,6 +21,47 @@
 
 #include <asm/stacktrace/nvhe.h>
 
+/*
+ * kvm_nvhe_stack_kern_va - Convert KVM nVHE HYP stack addresses to a kernel VAs
+ *
+ * The nVHE hypervisor stack is mapped in the flexible 'private' VA range, to
+ * allow for guard pages below the stack. Consequently, the fixed offset address
+ * translation macros won't work here.
+ *
+ * The kernel VA is calculated as an offset from the kernel VA of the hypervisor
+ * stack base.
+ *
+ * Returns true on success and updates @addr to its corresponding kernel VA;
+ * otherwise returns false.
+ */
+static bool kvm_nvhe_stack_kern_va(unsigned long *addr,
+				   enum stack_type type)
+{
+	struct kvm_nvhe_stacktrace_info *stacktrace_info;
+	unsigned long hyp_base, kern_base, hyp_offset;
+
+	stacktrace_info = this_cpu_ptr_nvhe_sym(kvm_stacktrace_info);
+
+	switch (type) {
+	case STACK_TYPE_HYP:
+		kern_base = (unsigned long)*this_cpu_ptr(&kvm_arm_hyp_stack_page);
+		hyp_base = (unsigned long)stacktrace_info->stack_base;
+		break;
+	case STACK_TYPE_OVERFLOW:
+		kern_base = (unsigned long)this_cpu_ptr_nvhe_sym(overflow_stack);
+		hyp_base = (unsigned long)stacktrace_info->overflow_stack_base;
+		break;
+	default:
+		return false;
+	}
+
+	hyp_offset = *addr - hyp_base;
+
+	*addr = kern_base + hyp_offset;
+
+	return true;
+}
+
 static bool on_overflow_stack(unsigned long sp, unsigned long size,
 			      struct stack_info *info)
 {
-- 
2.34.1

