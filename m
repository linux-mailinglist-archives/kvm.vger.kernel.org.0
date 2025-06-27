Return-Path: <kvm+bounces-50965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E4DFAEB20C
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 11:06:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B53545612AA
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 09:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E40CD298CAE;
	Fri, 27 Jun 2025 09:05:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C88BF2951BA;
	Fri, 27 Jun 2025 09:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751015118; cv=none; b=snC9yqaBTLm8LhkAHYWqP7cVDGDdVq/HF/5zPJjI6KG8NRtnT8vSCsdA97domepNu1LHbntbE2G9b0HLceVeTitVBW677DLgAVIwc4poDXB2044lGH0cijCmMvJExL2EA9a24VHlu1WPDgPAYi4TAaRNERRv1jzRMrCRHx5x1ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751015118; c=relaxed/simple;
	bh=9DFt5yBIByc8A5fTofoeJFiaxrEmzDqhpsfJB8V5+8g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tDOGNhUbHQcqTlwnZUWK4e4uVGScmQpTOmkj8O58FetyEes08W4ahH+weKTgyiLEx4TqimzlDzit97aJ6x+/qCji0UcZ8bwecPOcoUIqD3Tp4b2pH12Jte9iUTlWuvLCp2UtAKp5Lb8oERJkd3grjs5UoukCQq+ZvwO+y8cjRbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxnOLKXl5oVjIeAQ--.31464S3;
	Fri, 27 Jun 2025 17:05:14 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxM+TEXl5ovCsAAA--.1247S8;
	Fri, 27 Jun 2025 17:05:14 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v4 6/6] LoongArch: KVM: Add address alignment check
Date: Fri, 27 Jun 2025 17:05:07 +0800
Message-Id: <20250627090507.808319-7-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250627090507.808319-1-maobibo@loongson.cn>
References: <20250627090507.808319-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxM+TEXl5ovCsAAA--.1247S8
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

IOCSR instruction supports 1/2/4/8 bytes access, the address should
be naturally aligned with its access size. Here address alignment
checking is added in eiointc kernel emulation.

Cc: stable@vger.kernel.org
Fixes: 3956a52bc05b ("LoongArch: KVM: Add EIOINTC read and write functions")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index d54fe805bf6e..fab5cf52779c 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -316,6 +316,11 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 	}
 
+	if (addr & (len - 1)) {
+		kvm_err("%s: eiointc not aligned addr %llx len %d\n", __func__, addr, len);
+		return -EINVAL;
+	}
+
 	vcpu->kvm->stat.eiointc_read_exits++;
 	spin_lock_irqsave(&eiointc->lock, flags);
 	switch (len) {
@@ -687,6 +692,11 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 	}
 
+	if (addr & (len - 1)) {
+		kvm_err("%s: eiointc not aligned addr %llx len %d\n", __func__, addr, len);
+		return -EINVAL;
+	}
+
 	vcpu->kvm->stat.eiointc_write_exits++;
 	spin_lock_irqsave(&eiointc->lock, flags);
 	switch (len) {
-- 
2.39.3


