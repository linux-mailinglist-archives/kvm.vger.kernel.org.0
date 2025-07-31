Return-Path: <kvm+bounces-53772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC876B16CFD
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 09:59:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE61B5811FE
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 07:59:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FA2C29E0F7;
	Thu, 31 Jul 2025 07:59:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6075299A90;
	Thu, 31 Jul 2025 07:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753948755; cv=none; b=C4ywpbLZBqArq7RuuhiSpzeK4acTpkNg9zu+ptC7OVqm9V9F+jooI9PYoa7idq9uam9eszXs0z8L9G7JpD6TkihX5Xi8N7y1HezquTZWbK9OzpZgfjNB/womIkyp2774VQb2+oolVPcFHdomAD/MHjFmkNKuodCj09kc7LFlzKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753948755; c=relaxed/simple;
	bh=yuwDMQaN1n08PnQ2obCyZtUsRTbepkQE5wM3gcaQJ14=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ivID9F08Tsd+SWJ43PCqsGIoyA5rjAVZf0JlbXt/aKzog6FH+L2yZabe/gOR1LwAgM5XHcKHf0LSw9mP2ctKhM3F9+9p5y7MAyuqH4mMJtla6tJUTS3whpDn2DieYkBp1fYeuUUtHc6zjJT3FrswxUBjGcbGf+5R9pglmCDE3I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Axx2lMIotoP9A1AQ--.6941S3;
	Thu, 31 Jul 2025 15:59:08 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJDx_8NMIotopCUvAA--.38868S2;
	Thu, 31 Jul 2025 15:59:08 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] LoongArch: KVM: Access mailbox directly in mail_send()
Date: Thu, 31 Jul 2025 15:59:07 +0800
Message-Id: <20250731075907.189847-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDx_8NMIotopCUvAA--.38868S2
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
index fe734dc062ed..832b2d4aa2ef 100644
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

base-commit: 038d61fd642278bab63ee8ef722c50d10ab01e8f
-- 
2.39.3


