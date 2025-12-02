Return-Path: <kvm+bounces-65061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 32372C99E8D
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 03:49:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E18DF4E2456
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 02:49:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6988727F727;
	Tue,  2 Dec 2025 02:48:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0BE718A6DB;
	Tue,  2 Dec 2025 02:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764643728; cv=none; b=ZDXczeP1EEz8MPOsSrXR2Z3eEnu3zZ9hxlyLEUdF8Hqlo30GL29003Ew+1f+ESsfvqd6ytfmfDNW+mCNfft3mRTi0daV3Qps17wBG/hwFUDCWcQqcJNxyWrvX+tsmsjjUyLBKRMJP7AqwpvIrv2W0JW9lSicojx44ZLstttKR80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764643728; c=relaxed/simple;
	bh=AMM3iQesbOT8MbdyNXnOl8moc4a9QY9eF4Acmh0befI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VPFa07YhHgqtEXahBQhjHroOtrI/wFAVhXh9rH3BJKKt5LdVAbv8REzrfwZCevsBQgixVRqcPCEA6ym8w3d3ei9xm5B8HW4/M4Od8SBne6Y15qK6Fpr5JoN5yxnMXfcHKfNML87smcX4tgpWtu+GW4vfDaaGV3mq+EbiThDcl58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Dx+tGJUy5pmCgqAA--.26109S3;
	Tue, 02 Dec 2025 10:48:41 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxmcCCUy5p1ExEAQ--.28502S4;
	Tue, 02 Dec 2025 10:48:40 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	x86@kernel.org
Subject: [PATCH v3 2/2] LoongArch: Add paravirt support with vcpu_is_preempted() in guest side
Date: Tue,  2 Dec 2025 10:48:32 +0800
Message-Id: <20251202024833.1714363-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20251202024833.1714363-1-maobibo@loongson.cn>
References: <20251202024833.1714363-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxmcCCUy5p1ExEAQ--.28502S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Function vcpu_is_preempted() is used to check whether vCPU is preempted
or not. Here add implementation with vcpu_is_preempted() when option
CONFIG_PARAVIRT is enabled.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/qspinlock.h |  3 +++
 arch/loongarch/kernel/paravirt.c       | 23 ++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

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
index b1b51f920b23..b61a93c6aec8 100644
--- a/arch/loongarch/kernel/paravirt.c
+++ b/arch/loongarch/kernel/paravirt.c
@@ -246,6 +246,7 @@ static void pv_disable_steal_time(void)
 }
 
 #ifdef CONFIG_SMP
+static DEFINE_STATIC_KEY_FALSE(virt_preempt_key);
 static int pv_time_cpu_online(unsigned int cpu)
 {
 	unsigned long flags;
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
@@ -318,7 +334,12 @@ int __init pv_time_init(void)
 		static_key_slow_inc(&paravirt_steal_rq_enabled);
 #endif
 
-	pr_info("Using paravirt steal-time\n");
+#ifdef CONFIG_SMP
+	if (static_key_enabled(&virt_preempt_key))
+		pr_info("Using paravirt steal-time with preempt enabled\n");
+	else
+#endif
+		pr_info("Using paravirt steal-time with preempt disabled\n");
 
 	return 0;
 }
-- 
2.39.3


