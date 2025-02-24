Return-Path: <kvm+bounces-38986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F9D6A419D7
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 10:58:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 020277A57A5
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 09:56:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6603250BE6;
	Mon, 24 Feb 2025 09:56:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAF3924A053;
	Mon, 24 Feb 2025 09:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740390986; cv=none; b=cAtN1VubXKI1DTLshRYrpEQ8m8NrvFI4f5P4qzGEhg2XGTTM3v6ju+myUxlHIj8J437uzKg0y6WfTfnDpH8UZK5bIL7yWcmENjZEbnjPILFeOSAiwGbP56g71UGMJwzeJaudm47jiromuASLkEUfrfD264OM9RdyWn27emRKWk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740390986; c=relaxed/simple;
	bh=vTY7IcIUedKbnWecJ5rFRLrsW0yOtuv4iisggvG/U4M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fZcnaVZy4CwvmnTDAn7J99CeTXBQf31o489NWcxCvZ7GpWofcdVwXoNhz4u9V8U/hhXSVNkHhVasYO+KFF5rNQcZIcNmoI0HPH4UlV2dc49msXtKy8hSjaphuJ4ifNrRNnN2DADnrZsC3BRHP8dvH5vwarm/BHOC1Y45a7AkrsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxIK9DQrxnK6+AAA--.21994S3;
	Mon, 24 Feb 2025 17:56:19 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMBxXsVCQrxnRBkmAA--.9703S4;
	Mon, 24 Feb 2025 17:56:19 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] LoongArch: KVM: Implement arch specified functions for guest perf
Date: Mon, 24 Feb 2025 17:56:17 +0800
Message-Id: <20250224095618.1436016-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250224095618.1436016-1-maobibo@loongson.cn>
References: <20250224095618.1436016-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxXsVCQrxnRBkmAA--.9703S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Three architecture specified functions are added for guest perf
feature, they are kvm_arch_pmi_in_guest(), kvm_arch_vcpu_in_kernel()
and kvm_arch_vcpu_get_ip().

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h |  2 ++
 arch/loongarch/kvm/vcpu.c             | 26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 590982cd986e..49b71ea9c44f 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -12,6 +12,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_types.h>
 #include <linux/mutex.h>
+#include <linux/perf_event.h>
 #include <linux/spinlock.h>
 #include <linux/threads.h>
 #include <linux/types.h>
@@ -291,6 +292,7 @@ static inline int kvm_get_pmu_num(struct kvm_vcpu_arch *arch)
 
 /* Debug: dump vcpu state */
 int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu);
+bool kvm_arch_pmi_in_guest(struct kvm_vcpu *vcpu);
 
 /* MMU handling */
 void kvm_flush_tlb_all(void);
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 3318a55a0699..fb85c38f4886 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -361,8 +361,34 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 {
+	unsigned long val;
+
+	preempt_disable();
+	val = gcsr_read(LOONGARCH_CSR_CRMD);
+	preempt_enable();
+
+	return (val & CSR_PRMD_PPLV) == 0;
+}
+
+#ifdef CONFIG_GUEST_PERF_EVENTS
+unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.pc;
+}
+
+/*
+ * Returns true if a Performance Monitoring Interrupt (PMI), a.k.a. perf event,
+ * arrived in guest context.  For loongarch64, if pmu is not passthrough to VM,
+ * any event that arrives while a vCPU is loaded is considered to be "in guest".
+ */
+bool kvm_arch_pmi_in_guest(struct kvm_vcpu *vcpu)
+{
+	if (vcpu && !(vcpu->arch.aux_inuse & KVM_LARCH_PMU))
+		return true;
+
 	return false;
 }
+#endif
 
 bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu)
 {
-- 
2.39.3


