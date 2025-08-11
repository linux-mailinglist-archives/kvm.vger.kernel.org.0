Return-Path: <kvm+bounces-54355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17948B1FD9B
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 04:14:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8AE627A354A
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 02:12:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 869EA25A2C7;
	Mon, 11 Aug 2025 02:13:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 780B257C9F;
	Mon, 11 Aug 2025 02:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754878438; cv=none; b=uqUKBnmCn4CEaNh1YXIJogQTnC/USyAXOwvGi063Y0cNuNRRCTSxCqJIlVlD8VAqaNJXVwSltAShNk8FHbdx4pnfMpmG9UkLqsjPUJvx+PTd9krSoU1vIMyElOFmWBplxh5xUol6ebfZYo2AWJfjDU+OkoyJftF6Je49Hbl7kq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754878438; c=relaxed/simple;
	bh=WG6yIOZUAT/D/HhjVb6MFrB/X8K8IjW1AFFtDlQJeJA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BgskU3u+lbQSHwLvgLOF0vk2JBE2RPymt+ueAPy5klDIRMs2FvH/Kown2uWM4vtnTeQ96vEj6Qqv02uQVR8zc8thjcMZKJRZ8rdJ7mXTkdPDU0CCd0ypdI0nyKGdllkQo7M+X0XloEroEtJl7ousqcs+pwCfP51y6u6b0tuT1EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxrOLaUZlonBg+AQ--.11514S3;
	Mon, 11 Aug 2025 10:13:46 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJDxQ+TYUZloMZtBAA--.48509S3;
	Mon, 11 Aug 2025 10:13:45 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] LoongArch: KVM: Set version information at initial stage
Date: Mon, 11 Aug 2025 10:13:40 +0800
Message-Id: <20250811021344.3678306-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250811021344.3678306-1-maobibo@loongson.cn>
References: <20250811021344.3678306-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxQ+TYUZloMZtBAA--.48509S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Register PCH_PIC_INT_ID constains version and supported irq number
information, and it is read only register. The detailed value can
be set at initial stage, rather than read callback.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_pch_pic.h | 15 +++++++++++-
 arch/loongarch/kvm/intc/pch_pic.c        | 30 +++++++++++++++++-------
 2 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_pch_pic.h b/arch/loongarch/include/asm/kvm_pch_pic.h
index e6df6a4c1c70..3228db8f84a3 100644
--- a/arch/loongarch/include/asm/kvm_pch_pic.h
+++ b/arch/loongarch/include/asm/kvm_pch_pic.h
@@ -34,13 +34,26 @@
 #define PCH_PIC_INT_ISR_END		0x3af
 #define PCH_PIC_POLARITY_START		0x3e0
 #define PCH_PIC_POLARITY_END		0x3e7
-#define PCH_PIC_INT_ID_VAL		0x7000000UL
+#define PCH_PIC_INT_ID_VAL		0x7UL
 #define PCH_PIC_INT_ID_VER		0x1UL
 
+union LoongArchPIC_ID {
+	struct {
+		uint8_t _reserved_0[3];
+		uint8_t id;
+		uint8_t version;
+		uint8_t _reserved_1;
+		uint8_t irq_num;
+		uint8_t _reserved_2;
+	} desc;
+	uint64_t data;
+};
+
 struct loongarch_pch_pic {
 	spinlock_t lock;
 	struct kvm *kvm;
 	struct kvm_io_device device;
+	union LoongArchPIC_ID id;
 	uint64_t mask; /* 1:disable irq, 0:enable irq */
 	uint64_t htmsi_en; /* 1:msi */
 	uint64_t edge; /* 1:edge triggered, 0:level triggered */
diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/pch_pic.c
index 6f00ffe05c54..2c26c0836a05 100644
--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -120,20 +120,13 @@ static int loongarch_pch_pic_read(struct loongarch_pch_pic *s, gpa_t addr, int l
 {
 	int offset, index, ret = 0;
 	u32 data = 0;
-	u64 int_id = 0;
 
 	offset = addr - s->pch_pic_base;
 
 	spin_lock(&s->lock);
 	switch (offset) {
 	case PCH_PIC_INT_ID_START ... PCH_PIC_INT_ID_END:
-		/* int id version */
-		int_id |= (u64)PCH_PIC_INT_ID_VER << 32;
-		/* irq number */
-		int_id |= (u64)31 << (32 + 16);
-		/* int id value */
-		int_id |= PCH_PIC_INT_ID_VAL;
-		*(u64 *)val = int_id;
+		*(u64 *)val = s->id.data;
 		break;
 	case PCH_PIC_MASK_START ... PCH_PIC_MASK_END:
 		offset -= PCH_PIC_MASK_START;
@@ -467,7 +460,7 @@ static int kvm_setup_default_irq_routing(struct kvm *kvm)
 
 static int kvm_pch_pic_create(struct kvm_device *dev, u32 type)
 {
-	int ret;
+	int ret, i, irq_num;
 	struct kvm *kvm = dev->kvm;
 	struct loongarch_pch_pic *s;
 
@@ -483,6 +476,25 @@ static int kvm_pch_pic_create(struct kvm_device *dev, u32 type)
 	if (!s)
 		return -ENOMEM;
 
+	/*
+	 * With Loongson 7A1000 user manual
+	 * Chapter 5.2 "Description of Interrupt-related Registers"
+	 *
+	 * Interrupt controller identification register 1
+	 *   Bit 24-31 Interrupt Controller ID
+	 * Interrupt controller identification register 2
+	 *   Bit  0-7  Interrupt Controller version number
+	 *   Bit 16-23 The number of interrupt sources supported
+	 */
+	irq_num = 32;
+	s->id.desc.id = PCH_PIC_INT_ID_VAL;
+	s->id.desc.version = PCH_PIC_INT_ID_VER;
+	s->id.desc.irq_num = irq_num - 1;
+	s->mask = -1UL;
+	for (i = 0; i < irq_num; i++) {
+		s->route_entry[i] = 1;
+		s->htmsi_vector[i] = i;
+	}
 	spin_lock_init(&s->lock);
 	s->kvm = kvm;
 	kvm->arch.pch_pic = s;
-- 
2.39.3


