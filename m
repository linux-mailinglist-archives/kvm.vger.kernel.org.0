Return-Path: <kvm+bounces-24232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0023D9529B8
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 09:16:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F6471F21DD1
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 07:16:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF68F1991CD;
	Thu, 15 Aug 2024 07:15:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A058717AE05;
	Thu, 15 Aug 2024 07:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723706151; cv=none; b=eLK4bS7CypSV7RCI6kvCilyCs3l2wzXP8Ock4NocVrP66rS8T5/FIxOjdrOzR4BBhppmqV6pIDDL0uk1u7Gc+il9EL8YsLtT1eiAhpVHdaxfv0HvhsZIkKDG/Y3/o1Jpfgr1mMdH+x+5fkn/86v8C4zcUTg+ndkm+ZyxzN7DQrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723706151; c=relaxed/simple;
	bh=9Ops6y/qiRMiprboMO91mjAS8YqvIO7mhp62wdO8VR0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W+HnzZ27VUkEgvaOkASRuWhQZ+v0xxsQMOd8nE5EoW25Y0M4nIcIYIC+HrjyUeknZWdNe/X918GgSjaVX/2j/VpxhRVRbOKgQ7NEyXfxZe2GU01/L8wLeELs/C0vGea0NoKxQDXtxAETDA8Xuw6jwTUi69s83Za2/5vIP0g2SRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxmOkiq71moIsUAA--.47297S3;
	Thu, 15 Aug 2024 15:15:46 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMDxG2chq71mlesUAA--.1465S3;
	Thu, 15 Aug 2024 15:15:45 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] LoongArch: Fix AP booting issue in VM mode
Date: Thu, 15 Aug 2024 15:15:44 +0800
Message-Id: <20240815071545.925867-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240815071545.925867-1-maobibo@loongson.cn>
References: <20240815071545.925867-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDxG2chq71mlesUAA--.1465S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Native IPI is used for AP booting, it is booting interface between
OS and BIOS firmware. The paravirt ipi is only used inside OS, native
IPI is necessary to boot AP.

When booting AP, BP writes kernel entry address in the HW mailbox of
AP and send IPI interrupt to AP. AP executes idle instruction and
waits for interrupt or SW events, and clears IPI interrupt and jumps
to kernel entry from HW mailbox.

Between BP writes HW mailbox and is ready to send IPI to AP, AP is woken
up by SW events and jumps to kernel entry, so ACTION_BOOT_CPU IPI
interrupt will keep pending during AP booting. And native IPI interrupt
handler needs be registered so that it can clear pending native IPI, else
there will be endless IRQ handling during AP booting stage.

Here native ipi interrupt is initialized even if paravirt IPI is used.

Fixes: 74c16b2e2b0c ("LoongArch: KVM: Add PV IPI support on guest side")

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kernel/paravirt.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
index 9c9b75b76f62..348920b25460 100644
--- a/arch/loongarch/kernel/paravirt.c
+++ b/arch/loongarch/kernel/paravirt.c
@@ -13,6 +13,9 @@ static int has_steal_clock;
 struct static_key paravirt_steal_enabled;
 struct static_key paravirt_steal_rq_enabled;
 static DEFINE_PER_CPU(struct kvm_steal_time, steal_time) __aligned(64);
+#ifdef CONFIG_SMP
+static struct smp_ops old_ops;
+#endif
 
 static u64 native_steal_clock(int cpu)
 {
@@ -55,6 +58,11 @@ static void pv_send_ipi_single(int cpu, unsigned int action)
 	int min, old;
 	irq_cpustat_t *info = &per_cpu(irq_stat, cpu);
 
+	if (unlikely(action == ACTION_BOOT_CPU)) {
+		old_ops.send_ipi_single(cpu, action);
+		return;
+	}
+
 	old = atomic_fetch_or(BIT(action), &info->message);
 	if (old)
 		return;
@@ -71,6 +79,12 @@ static void pv_send_ipi_mask(const struct cpumask *mask, unsigned int action)
 	__uint128_t bitmap = 0;
 	irq_cpustat_t *info;
 
+	if (unlikely(action == ACTION_BOOT_CPU)) {
+		/* Use native IPI to boot AP */
+		old_ops.send_ipi_mask(mask, action);
+		return;
+	}
+
 	if (cpumask_empty(mask))
 		return;
 
@@ -141,6 +155,8 @@ static void pv_init_ipi(void)
 {
 	int r, swi;
 
+	/* Init native ipi irq since AP booting uses it */
+	old_ops.init_ipi();
 	swi = get_percpu_irq(INT_SWI0);
 	if (swi < 0)
 		panic("SWI0 IRQ mapping failed\n");
@@ -179,6 +195,9 @@ int __init pv_ipi_init(void)
 		return 0;
 
 #ifdef CONFIG_SMP
+	old_ops.init_ipi	= mp_ops.init_ipi;
+	old_ops.send_ipi_single = mp_ops.send_ipi_single;
+	old_ops.send_ipi_mask	= mp_ops.send_ipi_mask;
 	mp_ops.init_ipi		= pv_init_ipi;
 	mp_ops.send_ipi_single	= pv_send_ipi_single;
 	mp_ops.send_ipi_mask	= pv_send_ipi_mask;
-- 
2.39.3


