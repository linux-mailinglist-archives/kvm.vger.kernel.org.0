Return-Path: <kvm+bounces-51889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 090F2AFE1C9
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 10:03:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AC0F16FFEE
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 08:03:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CDDE23C4EC;
	Wed,  9 Jul 2025 08:02:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 045A92222D0;
	Wed,  9 Jul 2025 08:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752048162; cv=none; b=RSiWBhTh1zhmJy3VpRIIkN2QdH1olFX8jdSzf2zhDuuaaqt4dHcWqMr49Mcc3JLYTf9ac9btvUhbfwFpc9c7OsSknN9YPBVP3VOLB7l+i2G6f9DAnJhR3gtH5Xelzc641Ng9aK2eHLqOAHDXVa+ROiJnt0kmKGhr84IYoJWDlyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752048162; c=relaxed/simple;
	bh=BUgPGjWpn/5cTFdXjgeSnXucpvBBjqJ1G3jY8tlkWnc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qFdOjUL+4lYYh4y53/riKQYgWoIH8qd6YAe8cTKlk0vKaZkwBHhxnxiFAK1xvrYENoNosz/uImdgWSZkPfYvvFWjcaHYYFvABxgfc5ynFQqcF4oBjHc0E26xKgl44LPW/C3xzgQ+xJSSM840emP0jLK9J3zG8oF3EkP+gXbGSag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Axx2kaIm5oTyklAQ--.44988S3;
	Wed, 09 Jul 2025 16:02:34 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxpeQZIm5oS6cPAA--.24964S2;
	Wed, 09 Jul 2025 16:02:34 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 0/8] LoongArch: KVM: Enhancement with eiointc emulation
Date: Wed,  9 Jul 2025 16:02:25 +0800
Message-Id: <20250709080233.3948503-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxpeQZIm5oS6cPAA--.24964S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

This series add generic eiointc 8 bytes access interface, so that 1/2/4/8
bytes access can use the generic 8 bytes access interface. It reduce
about 500 lines redundant code and make eiointc emulation driver
simpler than ever.

---
v5 ... v6:
  1. Merge previous patch 5 & 6 into one, patch 7 & 10 into into one and
     patch 12 and patch 13 into one.
  2. Use sign extension with destination register for IOCSRRD.{B/H/W}
     kernel emulation.

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
Bibo Mao (8):
  LoongArch: KVM: Use standard bitops API with eiointc
  LoongArch: KVM: Remove unused parameter len
  LoongArch: KVM: Add stat information with kernel irqchip
  LoongArch: KVM: Remove never called default case statement
  LoongArch: KVM: Use generic function loongarch_eiointc_read()
  LoongArch: KVM: Remove some unnecessary local variables
  LoongArch: KVM: Replace eiointc_enable_irq() with eiointc_update_irq()
  LoongArch: KVM: Add generic function loongarch_eiointc_write()

 arch/loongarch/include/asm/kvm_host.h |  12 +-
 arch/loongarch/kvm/intc/eiointc.c     | 558 ++++----------------------
 arch/loongarch/kvm/intc/ipi.c         |  28 +-
 arch/loongarch/kvm/intc/pch_pic.c     |   4 +-
 arch/loongarch/kvm/vcpu.c             |   8 +-
 5 files changed, 102 insertions(+), 508 deletions(-)


base-commit: 733923397fd95405a48f165c9b1fbc8c4b0a4681
-- 
2.39.3


