Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616B27821C8
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 05:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbjHUDWs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Aug 2023 23:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbjHUDWr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Aug 2023 23:22:47 -0400
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989F79D;
        Sun, 20 Aug 2023 20:22:45 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=hao.xiang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Vq9XIXN_1692588161;
Received: from localhost(mailfrom:hao.xiang@linux.alibaba.com fp:SMTPD_---0Vq9XIXN_1692588161)
          by smtp.aliyun-inc.com;
          Mon, 21 Aug 2023 11:22:42 +0800
From:   Hao Xiang <hao.xiang@linux.alibaba.com>
To:     kvm@vger.kernel.org
Cc:     shannon.zhao@linux.alibaba.com, pbonzini@redhat.com,
        seanjc@google.com, linux-kernel@vger.kernel.org,
        Hao Xiang <hao.xiang@linux.alibaba.com>
Subject: [PATCH] kvm: x86: emulate MSR_PLATFORM_INFO msr bits
Date:   Mon, 21 Aug 2023 11:22:31 +0800
Message-Id: <1692588151-33716-1-git-send-email-hao.xiang@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For intel platform, The BzyMhz field of Turbostat shows zero
due to the missing of part msr bits of MSR_PLATFORM_INFO.

Acquire necessary msr bits, and expose following msr info to guest,
to make sure guest can get correct turbo frequency info.

MSR_PLATFORM_INFO bits
bit 15:8, Maximum Non-Turbo Ratio (MAX_NON_TURBO_LIM_RATIO)
bit 47:40, Maximum Efficiency Ratio (MAX_EFFICIENCY_RATIO)

Signed-off-by: Hao Xiang <hao.xiang@linux.alibaba.com>
---
 arch/x86/include/asm/msr-index.h |  4 ++++
 arch/x86/kvm/x86.c               | 25 ++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 1d11135..1c8a276 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -68,6 +68,10 @@
 #define MSR_PLATFORM_INFO		0x000000ce
 #define MSR_PLATFORM_INFO_CPUID_FAULT_BIT	31
 #define MSR_PLATFORM_INFO_CPUID_FAULT		BIT_ULL(MSR_PLATFORM_INFO_CPUID_FAULT_BIT)
+/* MSR_PLATFORM_INFO bit 15:8, Maximum Non-Turbo Ratio (MAX_NON_TURBO_LIM_RATIO) */
+#define MSR_PLATFORM_INFO_MAX_NON_TURBO_LIM_RATIO	0x00000000ff00
+/* MSR_PLATFORM_INFO bit 47:40, Maximum Efficiency Ratio (MAX_EFFICIENCY_RATIO) */
+#define MSR_PLATFORM_INFO_MAX_EFFICIENCY_RATIO		0xff0000000000
 
 #define MSR_IA32_UMWAIT_CONTROL			0xe1
 #define MSR_IA32_UMWAIT_CONTROL_C02_DISABLE	BIT(0)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c381770..621c3e1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1679,6 +1679,29 @@ static u64 kvm_get_arch_capabilities(void)
 	return data;
 }
 
+
+static u64 kvm_get_msr_platform_info(void)
+{
+	u64 msr_platform_info = 0;
+
+	rdmsrl_safe(MSR_PLATFORM_INFO, &msr_platform_info);
+	/*
+	 * MSR_PLATFORM_INFO bits:
+	 * bit 15:8, Maximum Non-Turbo Ratio (MAX_NON_TURBO_LIM_RATIO)
+	 * bit 31, CPUID Faulting Enabled (CPUID_FAULTING_EN)
+	 * bit 47:40, Maximum Efficiency Ratio (MAX_EFFICIENCY_RATIO)
+	 *
+	 * Emulate part msr bits, expose above msr info to guest,
+	 * to make sure guest can get correct turbo frequency info.
+	 */
+
+	msr_platform_info &= (MSR_PLATFORM_INFO_MAX_NON_TURBO_RATIO |
+			MSR_PLATFORM_INFO_MAX_EFFICIENCY_RATIO);
+	msr_platform_info |= MSR_PLATFORM_INFO_CPUID_FAULT;
+
+	return msr_platform_info;
+}
+
 static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
 {
 	switch (msr->index) {
@@ -11919,7 +11942,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		goto free_guest_fpu;
 
 	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
-	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
+	vcpu->arch.msr_platform_info = kvm_get_msr_platform_info();
 	kvm_xen_init_vcpu(vcpu);
 	kvm_vcpu_mtrr_init(vcpu);
 	vcpu_load(vcpu);
-- 
1.8.3.1

