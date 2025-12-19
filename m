Return-Path: <kvm+bounces-66306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F90ECCEA59
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 07:30:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 63FB1302068D
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 06:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73C162D73A7;
	Fri, 19 Dec 2025 06:30:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA4EF20459A;
	Fri, 19 Dec 2025 06:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766125837; cv=none; b=f2ZQnM7JlppV4SRRpSOfRgE/ALivpZtvvf6OBcsghVdcRT5E1EKbrihWsjyLq/bz9fVR3Wvn4F5RjJQ1yJp+Xq3hHLefgDekPam4/PRheQj6k19MAHO+ykQswq+etWWO6QXWdDvgroPf4XZmqA2IrTMTpVvbZ6aHJZSMXeSGdbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766125837; c=relaxed/simple;
	bh=h9z/6qbd/OGEIpaySvsaPfol1flse6Q3YVPb7qNoTs4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W+vXkx+SXHTHwVMzrsSuy1U6LsHdgI6RGFTQ+Qmsu6DyzTrT7FPtLnhgBz5VbbOs1+RJsndXQpATWLFmPYaJwTJRrO6iKa1AbreNlnbLaThv/jAWm9F3D8u+sTJfnocg5TwetjZ4XHwRc43a4GaRsikV3seBXOmGWNPxktWcv6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxOMIC8URpRcEAAA--.2475S3;
	Fri, 19 Dec 2025 14:30:26 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBx68H+8ERpt6kBAA--.3572S4;
	Fri, 19 Dec 2025 14:30:25 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	WANG Xuerui <kernel@xen0n.name>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] LoongArch: Add paravirt support with vcpu_is_preempted() in guest side
Date: Fri, 19 Dec 2025 14:30:21 +0800
Message-Id: <20251219063021.1778659-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20251219063021.1778659-1-maobibo@loongson.cn>
References: <20251219063021.1778659-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBx68H+8ERpt6kBAA--.3572S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Function vcpu_is_preempted() is used to check whether vCPU is preempted
or not. Here add implementation with vcpu_is_preempted() when option
CONFIG_PARAVIRT is enabled.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Acked-by: Juergen Gross <jgross@suse.com>
---
 arch/loongarch/include/asm/qspinlock.h |  3 +++
 arch/loongarch/kernel/paravirt.c       | 21 ++++++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/qspinlock.h b/arch/loongarch/include/asm/qspinlock.h
index e76d3aa1e1eb..fa3eaf7e48f2 100644
--- a/arch/loongarch/include/asm/qspinlock.h
+++ b/arch/loongarch/include/asm/qspinlock.h
@@ -34,6 +34,9 @@ static inline bool virt_spin_lock(struct qspinlock *lock)
 	return true;
 }
 
+#define vcpu_is_preempted	vcpu_is_preempted
+bool vcpu_is_preempted(int cpu);
+
 #endif /* CONFIG_PARAVIRT */
 
 #include <asm-generic/qspinlock.h>
diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
index b1b51f920b23..a81a3e871dd1 100644
--- a/arch/loongarch/kernel/paravirt.c
+++ b/arch/loongarch/kernel/paravirt.c
@@ -12,6 +12,7 @@ static int has_steal_clock;
 struct static_key paravirt_steal_enabled;
 struct static_key paravirt_steal_rq_enabled;
 static DEFINE_PER_CPU(struct kvm_steal_time, steal_time) __aligned(64);
+static DEFINE_STATIC_KEY_FALSE(virt_preempt_key);
 DEFINE_STATIC_KEY_FALSE(virt_spin_lock_key);
 
 static u64 native_steal_clock(int cpu)
@@ -267,6 +268,18 @@ static int pv_time_cpu_down_prepare(unsigned int cpu)
 
 	return 0;
 }
+
+bool notrace vcpu_is_preempted(int cpu)
+{
+	struct kvm_steal_time *src;
+
+	if (!static_branch_unlikely(&virt_preempt_key))
+		return false;
+
+	src = &per_cpu(steal_time, cpu);
+	return !!(src->preempted & KVM_VCPU_PREEMPTED);
+}
+EXPORT_SYMBOL(vcpu_is_preempted);
 #endif
 
 static void pv_cpu_reboot(void *unused)
@@ -308,6 +321,9 @@ int __init pv_time_init(void)
 		pr_err("Failed to install cpu hotplug callbacks\n");
 		return r;
 	}
+
+	if (kvm_para_has_feature(KVM_FEATURE_PREEMPT))
+		static_branch_enable(&virt_preempt_key);
 #endif
 
 	static_call_update(pv_steal_clock, paravt_steal_clock);
@@ -318,7 +334,10 @@ int __init pv_time_init(void)
 		static_key_slow_inc(&paravirt_steal_rq_enabled);
 #endif
 
-	pr_info("Using paravirt steal-time\n");
+	if (static_key_enabled(&virt_preempt_key))
+		pr_info("Using paravirt steal-time with preempt enabled\n");
+	else
+		pr_info("Using paravirt steal-time with preempt disabled\n");
 
 	return 0;
 }
-- 
2.39.3


