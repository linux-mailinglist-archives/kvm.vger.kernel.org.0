Return-Path: <kvm+bounces-65459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 116E9CAA23B
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 08:13:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 29AF530607EA
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 07:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACA782DF3EA;
	Sat,  6 Dec 2025 07:11:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96E9DF9C0;
	Sat,  6 Dec 2025 07:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765005096; cv=none; b=ibIt2+FRTKRaA9ZvD7tIB8y8iZIqW1dvhAk6eF6uLj4US5IcZAzF9N2jDjZp93YOD5jueYUU2cqZsizL+vowv50Jyou3I7XN9ZVpZ5pQy1OpaFOPR6TgihGJ2p921IVeds+ewwBeEqaOs+5ROaqLYv1iKBwqFsyxvn7vasgJrwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765005096; c=relaxed/simple;
	bh=9V/onz2K/9sX76jTQNWsngnlSPPRu86/S7HcLPUZy88=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fLMP6JA5Ywacb9ZswGWV1yL4DCN+nyRTsyacFPV2A1qd05NegYmKy7xSpfLKEIvtVGPuhDbb7C79iufT4aQ47zOxTERHFA9V4QVD3l0+c/BmNgaI/Iau2fziB3NgubF7AMLqed9NfKgeEmWLpgeUZqDLC3k63riuDCf7BNNdIX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8CxL9Ma1zNp7LMrAA--.27366S3;
	Sat, 06 Dec 2025 15:11:22 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowJCx2sAX1zNpmFZGAQ--.33246S2;
	Sat, 06 Dec 2025 15:11:20 +0800 (CST)
From: Song Gao <gaosong@loongson.cn>
To: maobibo@loongson.cn,
	chenhuacai@kernel.org
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	kernel@xen0n.name,
	linux-kernel@vger.kernel.org,
	lixianglai@loongson.cn
Subject: [PATCH v3 0/4] LongArch: KVM: Add AVEC support irqchip in kernel 
Date: Sat,  6 Dec 2025 14:46:54 +0800
Message-Id: <20251206064658.714100-1-gaosong@loongson.cn>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCx2sAX1zNpmFZGAQ--.33246S2
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Hi,

This series adds AVEC-related macros, implements the DINTC in-kernel irqchip device,
enables irqfd to deliver MSI to DINTC, and supports injecting MSI interrupts
to the target vCPU.


V3: Fix kvm_arch_set_irq_inatomic() missing dintc set msi.(patch3)

V2:
https://patchew.org/linux/20251128091125.2720148-1-gaosong@loongson.cn/

Thanks.
Song Gao

Song Gao (4):
  LongArch: KVM: Add some maccros for AVEC
  LongArch: KVM: Add DINTC device support
  LongArch: KVM: Add irqfd set dintc msi
  LongArch: KVM: Add dintc inject msi to the dest vcpu

 arch/loongarch/include/asm/irq.h       |   8 ++
 arch/loongarch/include/asm/kvm_dintc.h |  22 +++++
 arch/loongarch/include/asm/kvm_host.h  |   8 ++
 arch/loongarch/include/uapi/asm/kvm.h  |   4 +
 arch/loongarch/kvm/Makefile            |   1 +
 arch/loongarch/kvm/intc/dintc.c        | 116 +++++++++++++++++++++++++
 arch/loongarch/kvm/interrupt.c         |   1 +
 arch/loongarch/kvm/irqfd.c             |  45 ++++++++--
 arch/loongarch/kvm/main.c              |   5 ++
 arch/loongarch/kvm/vcpu.c              |  55 ++++++++++++
 drivers/irqchip/irq-loongarch-avec.c   |   5 +-
 include/uapi/linux/kvm.h               |   2 +
 12 files changed, 263 insertions(+), 9 deletions(-)
 create mode 100644 arch/loongarch/include/asm/kvm_dintc.h
 create mode 100644 arch/loongarch/kvm/intc/dintc.c

-- 
2.39.3


