Return-Path: <kvm+bounces-54756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CC0EB275AE
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 04:28:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 765775E3DD7
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F188929AB1B;
	Fri, 15 Aug 2025 02:26:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2C8529AB09;
	Fri, 15 Aug 2025 02:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755224791; cv=none; b=MGQbyIxedSiCYsjdpJ2LuUEKBHXKp8OC+coVplgXW3OUzxp4j/r6EVNUO/xy8elJ3SSr4z4IGE+IqBbtL8K2gPmCtp4NbGd5RaSLZ8Q8KZoatUfGgHd9O7MKHx1GflKkaadYIzd5zqagQ3+zYiVMuPExrpDb8+Ax2arY7Qr3fdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755224791; c=relaxed/simple;
	bh=tHt/ryI3WiDCTTiso+ZH2sfHUPG+grJOHuFEqk8eQAM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bZT3fn2ptRHLnAWYq7ORGa0L/kBeNlkeuRiiMbm9E1D5rNeaEFFbjpseq9o8i2KIltc3aN/6rO8N+fT9Q+Z9G4yOkcjZdAI9N6tGdxOFboHAeZkYBzVHZSxeWHUJT7FTsK/eycc8SyFMIu0dMaTMSlROKWSPL9eJm74MolpbYYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxlnDQmp5oRhpAAQ--.55752S3;
	Fri, 15 Aug 2025 10:26:24 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJAxQMLOmp5oMPRMAA--.26771S2;
	Fri, 15 Aug 2025 10:26:23 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] LoongArch: KVM: Small enhancements about IPI and LBT
Date: Fri, 15 Aug 2025 10:26:17 +0800
Message-Id: <20250815022621.508174-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxQMLOmp5oMPRMAA--.26771S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Thre are some small enhancement about IPI emulation and LBT enabling in
LoongArch KVM. With IPI, it supports sending command to vCPU itself. And
with LBT it adds flag checking int function kvm_own_lbt() and make it
robust.

---
v2 ... v3:
  1. Fix stack protector issue in send_ipi_data()

v1 ... v2:
  1. Add sending IPI command to vCPU itself
  2. Avoid duplicated LBT enabling in kvm_own_lbt()
---
Bibo Mao (4):
  LoongArch: KVM: Fix stack protector issue in send_ipi_data()
  LoongArch: KVM: Access mailbox directly in mail_send()
  LoongArch: KVM: Add implementation with IOCSR_IPI_SET
  LoongArch: KVM: Make function kvm_own_lbt() robust

 arch/loongarch/kvm/intc/ipi.c | 57 ++++++++++++++++++++++-------------
 arch/loongarch/kvm/vcpu.c     |  8 +++--
 2 files changed, 41 insertions(+), 24 deletions(-)


base-commit: dfc0f6373094dd88e1eaf76c44f2ff01b65db851
-- 
2.39.3


