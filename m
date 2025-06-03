Return-Path: <kvm+bounces-48289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 675C4ACC37B
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 11:48:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 83BD41893965
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 09:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E2BB2874FC;
	Tue,  3 Jun 2025 09:46:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91D5B28468E;
	Tue,  3 Jun 2025 09:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748943988; cv=none; b=cH0UMsbD2GxyAaWi1LoLp7fWIjhDo4fWAscFZTGF0dFHfezVs7+NU4OmsC0bPgH/bavefjJ0jVSQ1th4mOA2dRijyJG5sU+wihXCivBwasfQtZjzS9fmpEzn5uCoW7gyV1d/KXYeKarhDB8OEeDJf2Y9/NFbg7qarOJYVfNsBSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748943988; c=relaxed/simple;
	bh=kQftfHPBDsUUTI3JW3uAzM2EfMR08UoYntTLsU4QPLA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cAoLcs+pY/aZwsArDvfY+tYiSnXjR8+VkcCVNin4nwBO1xA69xkT7cWLmIqVe2MTaSFnxKP63MToFQJZNQq5tBm1veMiKDVJh0CQj9QcIYaSzvi4/L7c7g/gwSefGaglbdNz92WDOCckMv5pPrtI2leh6dGOgtlfb75epQn6gB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxmnFjxD5oSQwKAQ--.32749S3;
	Tue, 03 Jun 2025 17:46:11 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMDxH+VfxD5ot8gGAQ--.23188S2;
	Tue, 03 Jun 2025 17:46:07 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/7] LoongArch: KVM: Enhancement about eiointc emulation
Date: Tue,  3 Jun 2025 17:45:59 +0800
Message-Id: <20250603094606.1053622-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDxH+VfxD5ot8gGAQ--.23188S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

This series fix four issues about kernel eiointc emulation list as
follows:
  1. The first patch fixes type forced assignment issue.
  2. The second patch fixes interrupt route with physical cpu.
  3. The third patch disables update property num_cpu and feature
  4. The fourth patch adds validation check about num_cpu from user
     space.

Also there is code cleanup with kernel eiointc emulation.

---
v1 ... v2:
  1. Add extra fix in patch 3 and patch 4, add num_cpu validation check
  2. Name of stat information keeps unchanged, only move it from VM stat
     to vCPU stat.
---
Bibo Mao (7):
  LoongArch: KVM: Fix interrupt route update with eiointc
  LoongArch: KVM: Check interrupt route from physical cpu with eiointc
  LoongArch: KVM: Disable update property num_cpu and feature with
    eiointc
  LoongArch: KVM: Check validation of num_cpu from user space
  LoongArch: KVM: Use standard bitops API with eiointc
  LoongArch: KVM: Remove unused parameter len
  LoongArch: KVM: Add stat information with kernel irqchip

 arch/loongarch/include/asm/kvm_host.h |  12 +--
 arch/loongarch/kvm/intc/eiointc.c     | 129 ++++++++++++++++----------
 arch/loongarch/kvm/intc/ipi.c         |  28 +-----
 arch/loongarch/kvm/intc/pch_pic.c     |   4 +-
 arch/loongarch/kvm/vcpu.c             |   8 +-
 5 files changed, 97 insertions(+), 84 deletions(-)


base-commit: fe4281644c62ce9385d3b9165e27d6c86ae0a845
-- 
2.39.3


