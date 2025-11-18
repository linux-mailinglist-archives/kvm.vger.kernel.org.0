Return-Path: <kvm+bounces-63517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C392C681FD
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 09:07:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id B674E2A3BB
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 08:07:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BCCB309EEB;
	Tue, 18 Nov 2025 08:07:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECF67307AE4;
	Tue, 18 Nov 2025 08:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763453234; cv=none; b=sAoVImXtdguL9VEhmVgqiVrAvR97bxc+OxDfbIVnR9c1Cc8Q6U07MCLUDDxckXFNR3Pa6zcuX9yJ7UqF4BRrda3AKZSJKwm8Z1OZh6O2EDzaR8GM4co4VJFVgNqFDl//WSskEwmjgmyOQyQohuWEq1uQzslRw0zW/kcHOFi/LBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763453234; c=relaxed/simple;
	bh=NrRX9it4MnWayj4eZuSINZrMRfhV19Whgr9Ms4aUU7I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ERT4Ojb0ooKUYi+2AM7+Cz+jQo1BXZ8hZZiVgQ/dAz2zBjMhEq6IftQdVj7K5sZP/QcLeUgH00GLGI4kuHezxyuQAS8qHTUdBsETtmjAdd14HG8vOJPfAXMpaaliV0fzbF7cVlsCCL9dcJV98Jz0oRs9sr8W/XWAPd5uSGMIj3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Cx778qKRxp+9gkAA--.11769S3;
	Tue, 18 Nov 2025 16:07:06 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxjcEhKRxpUhc3AQ--.33984S4;
	Tue, 18 Nov 2025 16:07:04 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Waiman Long <longman@redhat.com>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	x86@kernel.org
Subject: [PATCH 2/3] LoongArch: Add paravirt support with vcpu_is_preempted()
Date: Tue, 18 Nov 2025 16:06:55 +0800
Message-Id: <20251118080656.2012805-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20251118080656.2012805-1-maobibo@loongson.cn>
References: <20251118080656.2012805-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxjcEhKRxpUhc3AQ--.33984S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Function vcpu_is_preempted() is used to check whether vCPU is preempted
or not. Here add implementation with vcpu_is_preempted() when option
CONFIG_PARAVIRT is enabled.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/smp.h      |  1 +
 arch/loongarch/include/asm/spinlock.h |  5 +++++
 arch/loongarch/kernel/paravirt.c      | 16 ++++++++++++++++
 arch/loongarch/kernel/smp.c           |  6 ++++++
 4 files changed, 28 insertions(+)

diff --git a/arch/loongarch/include/asm/smp.h b/arch/loongarch/include/asm/smp.h
index 3a47f52959a8..5b37f7bf2060 100644
--- a/arch/loongarch/include/asm/smp.h
+++ b/arch/loongarch/include/asm/smp.h
@@ -18,6 +18,7 @@ struct smp_ops {
 	void (*init_ipi)(void);
 	void (*send_ipi_single)(int cpu, unsigned int action);
 	void (*send_ipi_mask)(const struct cpumask *mask, unsigned int action);
+	bool (*vcpu_is_preempted)(int cpu);
 };
 extern struct smp_ops mp_ops;
 
diff --git a/arch/loongarch/include/asm/spinlock.h b/arch/loongarch/include/asm/spinlock.h
index 7cb3476999be..c001cef893aa 100644
--- a/arch/loongarch/include/asm/spinlock.h
+++ b/arch/loongarch/include/asm/spinlock.h
@@ -5,6 +5,11 @@
 #ifndef _ASM_SPINLOCK_H
 #define _ASM_SPINLOCK_H
 
+#ifdef CONFIG_PARAVIRT
+#define vcpu_is_preempted	vcpu_is_preempted
+bool vcpu_is_preempted(int cpu);
+#endif
+
 #include <asm/processor.h>
 #include <asm/qspinlock.h>
 #include <asm/qrwlock.h>
diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
index b1b51f920b23..b99404b6b13f 100644
--- a/arch/loongarch/kernel/paravirt.c
+++ b/arch/loongarch/kernel/paravirt.c
@@ -52,6 +52,13 @@ static u64 paravt_steal_clock(int cpu)
 #ifdef CONFIG_SMP
 static struct smp_ops native_ops;
 
+static bool pv_vcpu_is_preempted(int cpu)
+{
+	struct kvm_steal_time *src = &per_cpu(steal_time, cpu);
+
+	return !!(src->preempted & KVM_VCPU_PREEMPTED);
+}
+
 static void pv_send_ipi_single(int cpu, unsigned int action)
 {
 	int min, old;
@@ -308,6 +315,9 @@ int __init pv_time_init(void)
 		pr_err("Failed to install cpu hotplug callbacks\n");
 		return r;
 	}
+
+	if (kvm_para_has_feature(KVM_FEATURE_PREEMPT_HINT))
+		mp_ops.vcpu_is_preempted = pv_vcpu_is_preempted;
 #endif
 
 	static_call_update(pv_steal_clock, paravt_steal_clock);
@@ -332,3 +342,9 @@ int __init pv_spinlock_init(void)
 
 	return 0;
 }
+
+bool notrace vcpu_is_preempted(int cpu)
+{
+	return mp_ops.vcpu_is_preempted(cpu);
+}
+EXPORT_SYMBOL(vcpu_is_preempted);
diff --git a/arch/loongarch/kernel/smp.c b/arch/loongarch/kernel/smp.c
index 46036d98da75..f04192fedf8d 100644
--- a/arch/loongarch/kernel/smp.c
+++ b/arch/loongarch/kernel/smp.c
@@ -307,10 +307,16 @@ static void loongson_init_ipi(void)
 		panic("IPI IRQ request failed\n");
 }
 
+static bool loongson_vcpu_is_preempted(int cpu)
+{
+	return false;
+}
+
 struct smp_ops mp_ops = {
 	.init_ipi		= loongson_init_ipi,
 	.send_ipi_single	= loongson_send_ipi_single,
 	.send_ipi_mask		= loongson_send_ipi_mask,
+	.vcpu_is_preempted	= loongson_vcpu_is_preempted,
 };
 
 static void __init fdt_smp_setup(void)
-- 
2.39.3


