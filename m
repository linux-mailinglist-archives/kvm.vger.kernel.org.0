Return-Path: <kvm+bounces-54359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CD342B1FDA6
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 04:15:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C492C7AB589
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 02:13:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06079281371;
	Mon, 11 Aug 2025 02:14:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 730C62580CF;
	Mon, 11 Aug 2025 02:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754878440; cv=none; b=FnzelPVEJkumuHXng1lPXBuIM7qdFrSBWqv6UDq53AGdml2wANB5XwDomQJvOQiWaIhbePg4ZLwXjhZxV/1b07mTr6ejjIt9ntkOwHf+Q4UA0PjVaSM8I62C9md8ohkxA7MZcwJKQ1Bit/xENg4jqsARbAMtUJVnhC3VCL2i2ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754878440; c=relaxed/simple;
	bh=R3ZYPelq7B2wOcscDEbwM8RdfSfF7asWSOgJ1o3wNwQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lGXx+D202moRaEkCd2X/9jdOs/Bbmbp8Zf2tilvw/7ve95e3SKwd/9ZimdlbI6k/k9f8M7dJ9G3hadi0bS5l3dJjSKoEkEGzwpEmXlS+WHCXGbSy1dCtmph0/wqyfPVgiA8iQuDMIpW4KOSA0htOdaq0kG4lhSMRaz/pcxZRMdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxlnDcUZlorBg+AQ--.51719S3;
	Mon, 11 Aug 2025 10:13:48 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJDxQ+TYUZloMZtBAA--.48509S7;
	Mon, 11 Aug 2025 10:13:47 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] LoongArch: KVM: Add address alignment check in pch_pic register access
Date: Mon, 11 Aug 2025 10:13:44 +0800
Message-Id: <20250811021344.3678306-6-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowJDxQ+TYUZloMZtBAA--.48509S7
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With pch_pic device, its register is based on MMIO address space,
different access size 1/2/4/8 is supported. And base address should
be naturally aligned with its access size, here add alignment check
in its register access emulation function.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/pch_pic.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/pch_pic.c
index 0710b5ab286e..5ee24dbf3c4c 100644
--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -151,6 +151,11 @@ static int kvm_pch_pic_read(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 	}
 
+	if (addr & (len - 1)) {
+		kvm_err("%s: pch pic not aligned addr %llx len %d\n", __func__, addr, len);
+		return -EINVAL;
+	}
+
 	/* statistics of pch pic reading */
 	vcpu->stat.pch_pic_read_exits++;
 	ret = loongarch_pch_pic_read(s, addr, len, val);
@@ -246,6 +251,11 @@ static int kvm_pch_pic_write(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 	}
 
+	if (addr & (len - 1)) {
+		kvm_err("%s: pch pic not aligned addr %llx len %d\n", __func__, addr, len);
+		return -EINVAL;
+	}
+
 	/* statistics of pch pic writing */
 	vcpu->stat.pch_pic_write_exits++;
 	ret = loongarch_pch_pic_write(s, addr, len, val);
-- 
2.39.3


