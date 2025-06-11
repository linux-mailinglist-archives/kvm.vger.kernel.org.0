Return-Path: <kvm+bounces-48941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98AD2AD482A
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 03:47:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 488E43A88B0
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:46:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99F14176FB0;
	Wed, 11 Jun 2025 01:47:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D14C19A;
	Wed, 11 Jun 2025 01:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749606422; cv=none; b=JXZhwoQdh6z8bpWDoLeJJLaET2eObzR9g22tqzrUrqF5temKLUjRXaK1Kfuexl94JSXp4Jkx90zAiPj8u/YcA4o5iDEkBoQhIe50949SU7aVImYb9RLBN0bVxZS0TIBkLngej1I7qQJ/JC260k4M6lKFf3otVzE2GFgOoGVUCss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749606422; c=relaxed/simple;
	bh=zcNwtPl3Bu4wOJoWI9YqomflrSwr11gYivs7PCI9B8E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bIdzaRODC6THn+1fYN8g23jJkkWNGw380cCp6qBB1JfCzfD12Jr/ykWuTNkYWD7lQRPVYUAqCaxdApqL7QJ3IpTwhSOG6zs9ZhR8yRY4mR1C40l/KyPbzDMuZVU1s/5s58648JcJ3NW4aXKWDc0J0F/5AFUnvj+aD1ceWbDtmlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxnOIM4EhonEITAQ--.11959S3;
	Wed, 11 Jun 2025 09:46:52 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMCx7MQL4Eho0EoVAQ--.65102S2;
	Wed, 11 Jun 2025 09:46:52 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/9] LoongArch: KVM: INTC: Enhancement about eiointc emulation
Date: Wed, 11 Jun 2025 09:46:42 +0800
Message-Id: <20250611014651.3042734-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCx7MQL4Eho0EoVAQ--.65102S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

This series fix five issues about kernel eiointc emulation list as
follows:
  1. The first patch fixes type forced assignment issue.
  2. The second patch fixes interrupt route with physical cpu.
  3. The third patch disables update property num_cpu and feature
  4. The fourth patch adds validation check about num_cpu from user
     space.
  5. Overflow with array index when emulate register EIOINTC_ENABLE
     writing operation.

Also there is code cleanup with kernel eiointc emulation.

---
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

Bibo Mao (9):
  LoongArch: KVM: INTC: Fix interrupt route update with eiointc
  LoongArch: KVM: INTC: Check interrupt route from physical cpu
  LoongArch: KVM: INTC: Disable update property num_cpu and feature
  LoongArch: KVM: INTC: Check validation of num_cpu from user space
  LoongArch: KVM: INTC: Avoid overflow with array index
  LoongArch: KVM: INTC: Use standard bitops API with eiointc
  LoongArch: KVM: INTC: Remove unused parameter len
  LoongArch: KVM: INTC: Add stat information with kernel irqchip
  LoongArch: KVM: INTC: Add address alignment check

 arch/loongarch/include/asm/kvm_host.h |  12 +-
 arch/loongarch/kvm/intc/eiointc.c     | 167 +++++++++++++++-----------
 arch/loongarch/kvm/intc/ipi.c         |  28 +----
 arch/loongarch/kvm/intc/pch_pic.c     |   4 +-
 arch/loongarch/kvm/vcpu.c             |   8 +-
 5 files changed, 117 insertions(+), 102 deletions(-)


base-commit: aef17cb3d3c43854002956f24c24ec8e1a0e3546
-- 
2.39.3


