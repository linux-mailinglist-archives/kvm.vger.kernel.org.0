Return-Path: <kvm+bounces-64314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F751C7EEC9
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 04:55:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id F19E33461EB
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 03:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 488792BE04F;
	Mon, 24 Nov 2025 03:54:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98CC6D271;
	Mon, 24 Nov 2025 03:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763956460; cv=none; b=CAinwtfD4YW+Y6ABMlclS4vTU3wzs4w91O1iCsbjfmPc7iaHLPBJBSQsoaH/PrKlSNqZMkSVDRGaBym2kOwi+Fm4EnwlzdQe7pIVTO1yvgBpbs5Sy5xHyIVDeBPPh1x+br+tiTZxz3DKqTc9I+aASuX8M27vs6PPWvzs3mbUwUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763956460; c=relaxed/simple;
	bh=ozldes7sXHK5/MYLDu0oEhNYtVTl8elUPIrO8YO8r0k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LrMrEq9n1oTsWzmPxHSKtyWx7VCOiSz0N6ZeidZGIAoK6QB7SN/u3iEuL6NdZ70KUtpP95TkUykv7ByLQ68Pl3WndQxK/qPOGU87pAne2eNvEsvtk/eA9MbcB5WGgYQWty3urfWM3fmvQ/CwhR18COUGZzFNs7hq+JUHgyhmVVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxrtPh1iNpylonAA--.14330S3;
	Mon, 24 Nov 2025 11:54:09 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJAxusDa1iNp4WE9AQ--.13468S4;
	Mon, 24 Nov 2025 11:54:09 +0800 (CST)
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
Subject: [PATCH v2 2/3] LoongArch: Add paravirt support with vcpu_is_preempted() in guest side
Date: Mon, 24 Nov 2025 11:54:00 +0800
Message-Id: <20251124035402.3817179-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20251124035402.3817179-1-maobibo@loongson.cn>
References: <20251124035402.3817179-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxusDa1iNp4WE9AQ--.13468S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Function vcpu_is_preempted() is used to check whether vCPU is preempted
or not. Here add implementation with vcpu_is_preempted() when option
CONFIG_PARAVIRT is enabled.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/qspinlock.h |  5 +++++
 arch/loongarch/kernel/paravirt.c       | 16 ++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/loongarch/include/asm/qspinlock.h b/arch/loongarch/include/asm/qspinlock.h
index e76d3aa1e1eb..9a5b7ba1f4cb 100644
--- a/arch/loongarch/include/asm/qspinlock.h
+++ b/arch/loongarch/include/asm/qspinlock.h
@@ -34,6 +34,11 @@ static inline bool virt_spin_lock(struct qspinlock *lock)
 	return true;
 }
 
+#ifdef CONFIG_SMP
+#define vcpu_is_preempted	vcpu_is_preempted
+bool vcpu_is_preempted(int cpu);
+#endif
+
 #endif /* CONFIG_PARAVIRT */
 
 #include <asm-generic/qspinlock.h>
diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
index b1b51f920b23..d4163679adc4 100644
--- a/arch/loongarch/kernel/paravirt.c
+++ b/arch/loongarch/kernel/paravirt.c
@@ -246,6 +246,7 @@ static void pv_disable_steal_time(void)
 }
 
 #ifdef CONFIG_SMP
+DEFINE_STATIC_KEY_FALSE(virt_preempt_key);
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
-- 
2.39.3


