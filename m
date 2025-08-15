Return-Path: <kvm+bounces-54757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB741B275B0
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 04:28:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D8075E0BEC
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:27:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A265929B23C;
	Fri, 15 Aug 2025 02:26:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F03129AB1A;
	Fri, 15 Aug 2025 02:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755224792; cv=none; b=lxSYFBi1Hm/km8iPBO1cLK9SERZiBzzVQRrwRxiajGibatrEK2CaVt7DTX881h2USUyBsJgG3uZeXDLMj1d8eM3qkb/HPPI/0N/g151EW4dbgKan7SeNH1kpsIeRxyK2HdwvLUAvf1ddIpIYivgX0Ea6b913nU2m3uSCSYi2GNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755224792; c=relaxed/simple;
	bh=N+/gd/Xj0nhzvrRWHgCyeX0pWQeceiAuB6zzwJu22M8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u9TphhkHgkehzJ3EQm0y0EZiRafjhfVJBkKKhquqmmAvGM4xw/O8C1p4/dDdW3nYLA5A5UTN9GJ2tSSfJpyaOOr+xbU3mlkGtnsju1vQR5Ou1tcvCOx6mzRKBTaD1f53Gg2ihXx5varspAVYv5MbfP7YOD33FWAUUjbxKy5kev8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxaeHTmp5oTBpAAQ--.13126S3;
	Fri, 15 Aug 2025 10:26:27 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJAxQMLOmp5oMPRMAA--.26771S4;
	Fri, 15 Aug 2025 10:26:27 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/4] LoongArch: KVM: Access mailbox directly in mail_send()
Date: Fri, 15 Aug 2025 10:26:19 +0800
Message-Id: <20250815022621.508174-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250815022621.508174-1-maobibo@loongson.cn>
References: <20250815022621.508174-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxQMLOmp5oMPRMAA--.26771S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With function mail_send(), it is to write mailbox of other VCPUs.
Existing simple APIs read_mailbox/write_mailbox can be used directly
rather than send command on IOCSR address.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/ipi.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ipi.c
index 7925651d2ccf..f27f79a0c1e0 100644
--- a/arch/loongarch/kvm/intc/ipi.c
+++ b/arch/loongarch/kvm/intc/ipi.c
@@ -134,7 +134,8 @@ static int send_ipi_data(struct kvm_vcpu *vcpu, gpa_t addr, uint64_t data)
 
 static int mail_send(struct kvm *kvm, uint64_t data)
 {
-	int cpu, mailbox, offset;
+	int i, cpu, mailbox, offset;
+	uint32_t val = 0, mask = 0;
 	struct kvm_vcpu *vcpu;
 
 	cpu = ((data & 0xffffffff) >> 16) & 0x3ff;
@@ -144,9 +145,18 @@ static int mail_send(struct kvm *kvm, uint64_t data)
 		return -EINVAL;
 	}
 	mailbox = ((data & 0xffffffff) >> 2) & 0x7;
-	offset = IOCSR_IPI_BASE + IOCSR_IPI_BUF_20 + mailbox * 4;
+	offset = IOCSR_IPI_BUF_20 + mailbox * 4;
+	if ((data >> 27) & 0xf) {
+		val = read_mailbox(vcpu, offset, 4);
+		for (i = 0; i < 4; i++)
+			if (data & (BIT(27 + i)))
+				mask |= (0xff << (i * 8));
+		val &= mask;
+	}
 
-	return send_ipi_data(vcpu, offset, data);
+	val |= ((uint32_t)(data >> 32) & ~mask);
+	write_mailbox(vcpu, offset, val, 4);
+	return 0;
 }
 
 static int any_send(struct kvm *kvm, uint64_t data)
-- 
2.39.3


