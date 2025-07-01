Return-Path: <kvm+bounces-51136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1783CAEECBB
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 05:09:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9A4A3AE1DE
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 03:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 164561E5B68;
	Tue,  1 Jul 2025 03:08:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8953D1D07BA;
	Tue,  1 Jul 2025 03:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751339333; cv=none; b=QmPIafbMwqKZ6Ccxa9iJzTjFdgil+jxqwPrLL7P/OKpv5WxV4k+oXdbm3geHRm9m6Lv83k/2GEpit8zjDKyBkS8Dg5kenzmos1aq0UpLLN6KftExR2CLyXZh7XPP1QZCQr8iKtFSEE/CtBTTqNiEKmfLeUVoCq9sjj83W9+d/7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751339333; c=relaxed/simple;
	bh=w3cAM2YNsuUQH4SDURh13UbZAyKSz80FNlzqhpMgLnw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sL4yWhEugdwOrRFhCkSUQEnFb3KViPOQ5JOHaYCRNScNZCLz2PxPfz/ylZ/rVo3ElN3fQiyeM6RlFu/o4x2j3oc9ws4rnn4Tc/qX1X0eAtsIxjNz61J9SkCNHnQuep4lzyC49bIeXBY1npCw9pJa8k2vK8LjWjAmzHx40ieobxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxjXI+UWNonE4gAQ--.4950S3;
	Tue, 01 Jul 2025 11:08:46 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxpeQ7UWNolGYEAA--.27732S2;
	Tue, 01 Jul 2025 11:08:46 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 00/13] LoongArch: KVM: Enhancement with eiointc emulation
Date: Tue,  1 Jul 2025 11:08:29 +0800
Message-Id: <20250701030842.1136519-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxpeQ7UWNolGYEAA--.27732S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

This series add generic eiointc 8 bytes access interface, so that 1/2/4/8
bytes access can use the generic 8 bytes access interface. It reduce
about 300 lines redundant code and make eiointc emulation driver simple
than ever.

---
v4 ... v5
  1. Rebase patch on latest kernel where bugfix of eiointc has been
     merged.
  2. Add generic eiointc 8 bytes access interface, 1/2/4/8 bytes access
     uses generic 8 bytes access interface.

v3 ... v4:
  1. Remove patch about enhancement and only keep bugfix relative
     patches.
  2. Remove INTC indication in the patch title.
  3. With access size, keep default case unchanged besides 1/2/4/8 since
     here all patches are bugfix
  4. Firstly check return value of copy_from_user() with error path,
     keep the same order with old patch in patch 4.

v2 ... v3:
  1. Add prefix INTC: in title of every patch.
  2. Fix array index overflow when emulate register EIOINTC_ENABLE
     writing operation.
  3. Add address alignment check with eiointc register access operation.

v1 ... v2:
  1. Add extra fix in patch 3 and patch 4, add num_cpu validation check
  2. Name of stat information keeps unchanged, only move it from VM stat
     to vCPU stat.
---
Bibo Mao (13):
  LoongArch: KVM: Use standard bitops API with eiointc
  LoongArch: KVM: Remove unused parameter len
  LoongArch: KVM: Add stat information with kernel irqchip
  LoongArch: KVM: Remove never called default case statement
  LoongArch: KVM: Rename loongarch_eiointc_readq with
    loongarch_eiointc_read
  LoongArch: KVM: Use generic read function loongarch_eiointc_read
  LoongArch: KVM: Remove some unnecessary local variables
  LoongArch: KVM: Use concise api __ffs()
  LoongArch: KVM: Replace eiointc_enable_irq() with eiointc_update_irq()
  LoongArch: KVM: Remove local variable offset
  LoongArch: KVM: Rename old_data with old
  LoongArch: KVM: Add generic function loongarch_eiointc_write()
  LoongArch: KVM: Use generic interface loongarch_eiointc_write()

 arch/loongarch/include/asm/kvm_host.h |  12 +-
 arch/loongarch/kvm/intc/eiointc.c     | 557 ++++----------------------
 arch/loongarch/kvm/intc/ipi.c         |  28 +-
 arch/loongarch/kvm/intc/pch_pic.c     |   4 +-
 arch/loongarch/kvm/vcpu.c             |   8 +-
 5 files changed, 102 insertions(+), 507 deletions(-)


base-commit: d0b3b7b22dfa1f4b515fd3a295b3fd958f9e81af
-- 
2.39.3


