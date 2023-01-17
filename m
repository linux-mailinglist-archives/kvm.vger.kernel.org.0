Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC06A66DB2D
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 11:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236025AbjAQKcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 05:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236467AbjAQKav (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 05:30:51 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D1531E00
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 02:29:41 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id n7so4001869wrx.5
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 02:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MDKiG+yaIBG32YeRExq1BkXRALN1IzcYPeADcuqdbME=;
        b=EWov0XL/TSftaliENyT9wmGA0XZ2OXoTzEElQls0lrL4rRGkpE4P4VnFzVn/92WNrx
         8hCscACUC6gwoycxSSYQ46ppCops0sK9b4IURjvqtLtuM0XYLib1XmJ7mDC7fBl90olF
         QMyAKiYOePV5FzJAA5Lr60jgI3YAG/Y1DZxTYTqbW8+NkmEMtyDWJ8OM82DJQkzPB9xf
         m4l66Fvpklfy3UAF6cC1jTgyAtdLSsongAWxVKY4U/88VZJHH8ZRkBegmg7fTJbhi4tF
         yTPP7X7g6jk0cyvvXlt1c2tYpPtBbG4zVyQTz25m2wpxLSORJUhQ6Lqf8QAyDNHQcv/R
         koWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MDKiG+yaIBG32YeRExq1BkXRALN1IzcYPeADcuqdbME=;
        b=jVHmG856XcgxWMQILatNvgKdpCGqdVa9aEUFrQy+TROljr0580K2yQ2xqn8kTXlYdd
         OiR453PNpBANIN8TU2slws7NXG9ZukkjX+Iv7dxcFchylNGJ/uP17D4m9NE3HA+0YcRQ
         o0hK5EXLyLCEF9IUHymuV7RsnRgKx1OT5dX44C0Fed7K6nCSPfSSp0Op6ySIbulO5lg5
         E0+FrG+hamOA4CNSrvM6SakgVSKGNp8cJBC7UHgdVBQgwH/BB43cUaqux+F6IM8xTdm2
         XyCjF7ycVvKbijp5pj2v7EjxMAfMmdSilfqonmfVOPJ1yhDJ3GZJj4QYg88Ai2rFGYu4
         BPdQ==
X-Gm-Message-State: AFqh2kobppfc3F9UWXtpMj/eLph/dMoPkgKIWkB09zPJ92MEUh3o5Nbl
        dXD2Gys5Oiz+H2Jh2txdczJDxQ==
X-Google-Smtp-Source: AMrXdXvvQ8gEDZq/zX0imjLfv8vFIVyAm5rEkf1DlSDRyDNv3uHditi+vtgujPI5Sa9dfLTkaJop2w==
X-Received: by 2002:a05:6000:3c2:b0:2bd:beff:9c47 with SMTP id b2-20020a05600003c200b002bdbeff9c47mr2847870wrg.67.1673951380055;
        Tue, 17 Jan 2023 02:29:40 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:17d8:e5ec:f870:7b46])
        by smtp.gmail.com with ESMTPSA id j15-20020a5d452f000000b0028f9132e9ddsm28389844wra.39.2023.01.17.02.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 02:29:39 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com,
        bagasdotme@gmail.com, pbonzini@redhat.com
Cc:     fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [v3 5/6] KVM: arm64: Support the VCPU preemption check
Date:   Tue, 17 Jan 2023 10:29:29 +0000
Message-Id: <20230117102930.1053337-6-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230117102930.1053337-1-usama.arif@bytedance.com>
References: <20230117102930.1053337-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Support the vcpu_is_preempted() functionality under KVM/arm64. This will
enhance lock performance on overcommitted hosts (more runnable VCPUs
than physical CPUs in the system) as doing busy waits for preempted
VCPUs will hurt system performance far worse than early yielding.

Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 arch/arm64/include/asm/paravirt.h |   2 +
 arch/arm64/include/asm/spinlock.h |  16 ++++-
 arch/arm64/kernel/paravirt.c      | 113 ++++++++++++++++++++++++++++++
 3 files changed, 130 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/paravirt.h b/arch/arm64/include/asm/paravirt.h
index 9aa193e0e8f2..4ccb4356c56b 100644
--- a/arch/arm64/include/asm/paravirt.h
+++ b/arch/arm64/include/asm/paravirt.h
@@ -19,10 +19,12 @@ static inline u64 paravirt_steal_clock(int cpu)
 }
 
 int __init pv_time_init(void);
+int __init pv_lock_init(void);
 
 #else
 
 #define pv_time_init() do {} while (0)
+#define pv_lock_init() do {} while (0)
 
 #endif // CONFIG_PARAVIRT
 
diff --git a/arch/arm64/include/asm/spinlock.h b/arch/arm64/include/asm/spinlock.h
index 0525c0b089ed..7023efa4de96 100644
--- a/arch/arm64/include/asm/spinlock.h
+++ b/arch/arm64/include/asm/spinlock.h
@@ -10,7 +10,20 @@
 
 /* See include/linux/spinlock.h */
 #define smp_mb__after_spinlock()	smp_mb()
+#define vcpu_is_preempted vcpu_is_preempted
+
+#ifdef CONFIG_PARAVIRT
+#include <linux/static_call_types.h>
+
+bool dummy_vcpu_is_preempted(int cpu);
 
+DECLARE_STATIC_CALL(pv_vcpu_is_preempted, dummy_vcpu_is_preempted);
+static inline bool vcpu_is_preempted(int cpu)
+{
+	return static_call(pv_vcpu_is_preempted)(cpu);
+}
+
+#else
 /*
  * Changing this will break osq_lock() thanks to the call inside
  * smp_cond_load_relaxed().
@@ -18,10 +31,11 @@
  * See:
  * https://lore.kernel.org/lkml/20200110100612.GC2827@hirez.programming.kicks-ass.net
  */
-#define vcpu_is_preempted vcpu_is_preempted
 static inline bool vcpu_is_preempted(int cpu)
 {
 	return false;
 }
 
+#endif /* CONFIG_PARAVIRT */
+
 #endif /* __ASM_SPINLOCK_H */
diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
index aa718d6a9274..c56d701db1bb 100644
--- a/arch/arm64/kernel/paravirt.c
+++ b/arch/arm64/kernel/paravirt.c
@@ -20,8 +20,10 @@
 #include <linux/types.h>
 #include <linux/static_call.h>
 
+#include <asm/hypervisor.h>
 #include <asm/paravirt.h>
 #include <asm/pvclock-abi.h>
+#include <asm/pvlock-abi.h>
 #include <asm/smp_plat.h>
 
 struct static_key paravirt_steal_enabled;
@@ -38,7 +40,12 @@ struct pv_time_stolen_time_region {
 	struct pvclock_vcpu_stolen_time __rcu *kaddr;
 };
 
+struct pv_lock_state_region {
+	struct pvlock_vcpu_state __rcu *kaddr;
+};
+
 static DEFINE_PER_CPU(struct pv_time_stolen_time_region, stolen_time_region);
+static DEFINE_PER_CPU(struct pv_lock_state_region, lock_state_region);
 
 static bool steal_acc = true;
 static int __init parse_no_stealacc(char *arg)
@@ -174,3 +181,109 @@ int __init pv_time_init(void)
 
 	return 0;
 }
+
+static bool native_vcpu_is_preempted(int cpu)
+{
+	return false;
+}
+
+DEFINE_STATIC_CALL(pv_vcpu_is_preempted, native_vcpu_is_preempted);
+
+static bool para_vcpu_is_preempted(int cpu)
+{
+	struct pv_lock_state_region *reg;
+	__le64 preempted_le;
+
+	reg = per_cpu_ptr(&lock_state_region, cpu);
+	if (!reg->kaddr) {
+		pr_warn_once("PV lock enabled but not configured for cpu %d\n",
+			     cpu);
+		return false;
+	}
+
+	preempted_le = le64_to_cpu(READ_ONCE(reg->kaddr->preempted));
+
+	return !!(preempted_le);
+}
+
+static int pvlock_vcpu_state_dying_cpu(unsigned int cpu)
+{
+	struct pv_lock_state_region *reg;
+
+	reg = this_cpu_ptr(&lock_state_region);
+	if (!reg->kaddr)
+		return 0;
+
+	memunmap(reg->kaddr);
+	memset(reg, 0, sizeof(*reg));
+
+	return 0;
+}
+
+static int init_pvlock_vcpu_state(unsigned int cpu)
+{
+	struct pv_lock_state_region *reg;
+	struct arm_smccc_res res;
+
+	reg = this_cpu_ptr(&lock_state_region);
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PV_LOCK_FUNC_ID, &res);
+
+	if (res.a0 == SMCCC_RET_NOT_SUPPORTED) {
+		pr_warn("Failed to init PV lock data structure\n");
+		return -EINVAL;
+	}
+
+	reg->kaddr = memremap(res.a0,
+			      sizeof(struct pvlock_vcpu_state),
+			      MEMREMAP_WB);
+
+	if (!reg->kaddr) {
+		pr_warn("Failed to map PV lock data structure\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int kvm_arm_init_pvlock(void)
+{
+	int ret;
+
+	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN,
+				"hypervisor/arm/pvlock:online",
+				init_pvlock_vcpu_state,
+				pvlock_vcpu_state_dying_cpu);
+	if (ret < 0) {
+		pr_warn("PV-lock init failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static bool has_kvm_pvlock(void)
+{
+	return kvm_arm_hyp_service_available(ARM_SMCCC_KVM_FUNC_PV_LOCK);
+}
+
+int __init pv_lock_init(void)
+{
+	int ret;
+
+	if (is_hyp_mode_available())
+		return 0;
+
+	if (!has_kvm_pvlock())
+		return 0;
+
+	ret = kvm_arm_init_pvlock();
+	if (ret)
+		return ret;
+
+	static_call_update(pv_vcpu_is_preempted, para_vcpu_is_preempted);
+	pr_info("using PV-lock preempted\n");
+
+	return 0;
+}
+early_initcall(pv_lock_init);
-- 
2.25.1

