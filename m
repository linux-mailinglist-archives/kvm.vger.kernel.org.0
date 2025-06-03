Return-Path: <kvm+bounces-48290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B363ACC386
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 11:49:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22969188A44F
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 09:49:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50AF6283FF8;
	Tue,  3 Jun 2025 09:48:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5B59283FDB;
	Tue,  3 Jun 2025 09:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748944079; cv=none; b=W2NmUy1uFLQZWaMJWyYdxA9E4CrT2n8DY8XRxtZp5pccpn44GePARwk/D/jYMb4o63KI1rJPAvPXcxfs4trus2h+TC+fmX1vbFts4rkKam88h3y9h6nVJqWpYN3Kse26Q1sZ4QJ9mh15oNgarj6aaa44OHNvxWAJxI4kCzoOjMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748944079; c=relaxed/simple;
	bh=syz4EWWOsQFL4lJ34h4n8mIngUtsi28fhTqXgIsObXw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qpXjMAqlkLWBIKS0HpEGzumcvr6FfeaIUlbZIWjbSGLSRQeBvF2sdxg3yJeBAsyx2HVnMe6IoGWk70aaETdq7IN1VBgMpwBt6+VuUic3cREcwmZch74hDi80zkuBMiynBg7HgSRgkB4Y2QsXczVkjOvsqB63N7M7oa/AUNYX1o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxvnNqxD5oXgwKAQ--.65478S3;
	Tue, 03 Jun 2025 17:46:18 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMDxH+VfxD5ot8gGAQ--.23188S9;
	Tue, 03 Jun 2025 17:46:17 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/7] LoongArch: KVM: Add stat information with kernel irqchip
Date: Tue,  3 Jun 2025 17:46:06 +0800
Message-Id: <20250603094606.1053622-8-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250603094606.1053622-1-maobibo@loongson.cn>
References: <20250603094606.1053622-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDxH+VfxD5ot8gGAQ--.23188S9
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Move stat information about kernel irqchip from VM to vCPU, since
all vm exiting event should be vCPU relative. And also add entry
with structure kvm_vcpu_stats_desc[], so that it can display with
directory /sys/kernel/debug/kvm.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h | 12 ++++++------
 arch/loongarch/kvm/intc/eiointc.c     |  4 ++--
 arch/loongarch/kvm/intc/ipi.c         | 28 ++++-----------------------
 arch/loongarch/kvm/intc/pch_pic.c     |  4 ++--
 arch/loongarch/kvm/vcpu.c             |  8 +++++++-
 5 files changed, 21 insertions(+), 35 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index a3c4cc46c892..0cecbd038bb3 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -50,12 +50,6 @@ struct kvm_vm_stat {
 	struct kvm_vm_stat_generic generic;
 	u64 pages;
 	u64 hugepages;
-	u64 ipi_read_exits;
-	u64 ipi_write_exits;
-	u64 eiointc_read_exits;
-	u64 eiointc_write_exits;
-	u64 pch_pic_read_exits;
-	u64 pch_pic_write_exits;
 };
 
 struct kvm_vcpu_stat {
@@ -65,6 +59,12 @@ struct kvm_vcpu_stat {
 	u64 cpucfg_exits;
 	u64 signal_exits;
 	u64 hypercall_exits;
+	u64 ipi_read_exits;
+	u64 ipi_write_exits;
+	u64 eiointc_read_exits;
+	u64 eiointc_write_exits;
+	u64 pch_pic_read_exits;
+	u64 pch_pic_write_exits;
 };
 
 #define KVM_MEM_HUGEPAGE_CAPABLE	(1UL << 0)
diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 0b11edd16d1d..0e7c975f5e74 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -311,7 +311,7 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 	}
 
-	vcpu->kvm->stat.eiointc_read_exits++;
+	vcpu->stat.eiointc_read_exits++;
 	spin_lock_irqsave(&eiointc->lock, flags);
 	switch (len) {
 	case 1:
@@ -685,7 +685,7 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 	}
 
-	vcpu->kvm->stat.eiointc_write_exits++;
+	vcpu->stat.eiointc_write_exits++;
 	spin_lock_irqsave(&eiointc->lock, flags);
 	switch (len) {
 	case 1:
diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ipi.c
index fe734dc062ed..e658d5b37c04 100644
--- a/arch/loongarch/kvm/intc/ipi.c
+++ b/arch/loongarch/kvm/intc/ipi.c
@@ -268,36 +268,16 @@ static int kvm_ipi_read(struct kvm_vcpu *vcpu,
 			struct kvm_io_device *dev,
 			gpa_t addr, int len, void *val)
 {
-	int ret;
-	struct loongarch_ipi *ipi;
-
-	ipi = vcpu->kvm->arch.ipi;
-	if (!ipi) {
-		kvm_err("%s: ipi irqchip not valid!\n", __func__);
-		return -EINVAL;
-	}
-	ipi->kvm->stat.ipi_read_exits++;
-	ret = loongarch_ipi_readl(vcpu, addr, len, val);
-
-	return ret;
+	vcpu->stat.ipi_read_exits++;
+	return loongarch_ipi_readl(vcpu, addr, len, val);
 }
 
 static int kvm_ipi_write(struct kvm_vcpu *vcpu,
 			struct kvm_io_device *dev,
 			gpa_t addr, int len, const void *val)
 {
-	int ret;
-	struct loongarch_ipi *ipi;
-
-	ipi = vcpu->kvm->arch.ipi;
-	if (!ipi) {
-		kvm_err("%s: ipi irqchip not valid!\n", __func__);
-		return -EINVAL;
-	}
-	ipi->kvm->stat.ipi_write_exits++;
-	ret = loongarch_ipi_writel(vcpu, addr, len, val);
-
-	return ret;
+	vcpu->stat.ipi_write_exits++;
+	return loongarch_ipi_writel(vcpu, addr, len, val);
 }
 
 static const struct kvm_io_device_ops kvm_ipi_ops = {
diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/pch_pic.c
index 08fce845f668..6f00ffe05c54 100644
--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -196,7 +196,7 @@ static int kvm_pch_pic_read(struct kvm_vcpu *vcpu,
 	}
 
 	/* statistics of pch pic reading */
-	vcpu->kvm->stat.pch_pic_read_exits++;
+	vcpu->stat.pch_pic_read_exits++;
 	ret = loongarch_pch_pic_read(s, addr, len, val);
 
 	return ret;
@@ -303,7 +303,7 @@ static int kvm_pch_pic_write(struct kvm_vcpu *vcpu,
 	}
 
 	/* statistics of pch pic writing */
-	vcpu->kvm->stat.pch_pic_write_exits++;
+	vcpu->stat.pch_pic_write_exits++;
 	ret = loongarch_pch_pic_write(s, addr, len, val);
 
 	return ret;
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 5af32ec62cb1..d1b8c50941ca 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -20,7 +20,13 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, idle_exits),
 	STATS_DESC_COUNTER(VCPU, cpucfg_exits),
 	STATS_DESC_COUNTER(VCPU, signal_exits),
-	STATS_DESC_COUNTER(VCPU, hypercall_exits)
+	STATS_DESC_COUNTER(VCPU, hypercall_exits),
+	STATS_DESC_COUNTER(VCPU, ipi_read_exits),
+	STATS_DESC_COUNTER(VCPU, ipi_write_exits),
+	STATS_DESC_COUNTER(VCPU, eiointc_read_exits),
+	STATS_DESC_COUNTER(VCPU, eiointc_write_exits),
+	STATS_DESC_COUNTER(VCPU, pch_pic_read_exits),
+	STATS_DESC_COUNTER(VCPU, pch_pic_write_exits)
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
-- 
2.39.3


