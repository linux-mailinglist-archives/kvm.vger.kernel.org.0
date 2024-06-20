Return-Path: <kvm+bounces-20036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0723790FBB5
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 05:36:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BACBF1F2280A
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 03:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B7A023774;
	Thu, 20 Jun 2024 03:36:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46FDB3C00;
	Thu, 20 Jun 2024 03:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718854559; cv=none; b=V56ZdFFeCG8LVpTqC9MtdbkNqkVxi4aYdV03Ynq75fjdoGKB080G9ZypSqIsa/Mfvf4woHIB13itoe6Fb8C+MMn00k4mqUSLUmGiSNWQ2/8xVfctZ0U47yaub2UfBMiXWc7M85BxGwI6HzPhjl3oZ9juMiFfJ+ZAS7v61fLv5vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718854559; c=relaxed/simple;
	bh=pxEJn23nT6+sqxNt5VIguQ2SC4vykVQraEA5VugQ+mQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bfFC3hBRxDfjPB3i81Kyflc6ztpswAOu0cyOfXLepnJI1v/WyQxo2IuH5O9bgjfp7zP7h7OsrfBc3s4TZoN7cYWJUEbf+cRhVpYeMeGzjDgoNFOrn1HOyez+nizE7KXk88+IlyW6XHxRt9hClJl8InllMLdXUzLTS+MFyFCovZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Bx3+uZo3NmSWkIAA--.18063S3;
	Thu, 20 Jun 2024 11:35:53 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Cx78eYo3Nm6ugpAA--.35757S2;
	Thu, 20 Jun 2024 11:35:53 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] LoongArch: KVM: Sync pending interrupt when getting ESTAT from user mode
Date: Thu, 20 Jun 2024 11:35:52 +0800
Message-Id: <20240620033552.2739845-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Cx78eYo3Nm6ugpAA--.35757S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Currently interrupt is posted and cleared with async mode, and it is saved
in SW state vcpu::arch::irq_pending and vcpu::arch::irq_clear. When vcpu
is ready to run, interrupt is synced to ESTAT CSR register from SW state
vcpu::arch::irq_pending at guest entrance.

During VM migration stage, vcpu is put into stopped state, however
pending interrupt is not synced to ESTAT CSR register. So there will be
interrupt lost when VCPU is stopped and migrated to other host machines.

Here when ESTAT CSR register is read from VMM user mode, pending
interrupt is synced to ESTAT also. So that VMM can get correct pending
interrupt.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index b747bd8bc037..81622cd055af 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -371,9 +371,18 @@ static int _kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *val)
 		return -EINVAL;
 
 	if (id == LOONGARCH_CSR_ESTAT) {
+		preempt_disable();
+		vcpu_load(vcpu);
+		/*
+		 * Sync pending interrupt into estat so that interrupt
+		 * remains during migration stage
+		 */
+		kvm_deliver_intr(vcpu);
 		/* ESTAT IP0~IP7 get from GINTC */
 		gintc = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_GINTC) & 0xff;
 		*val = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_ESTAT) | (gintc << 2);
+		vcpu_put(vcpu);
+		preempt_enable();
 		return 0;
 	}
 

base-commit: 92e5605a199efbaee59fb19e15d6cc2103a04ec2
-- 
2.39.3


