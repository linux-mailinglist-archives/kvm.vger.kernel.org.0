Return-Path: <kvm+bounces-47916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 783EFAC753C
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 03:11:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 500281C01B2D
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 01:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A7D61B4244;
	Thu, 29 May 2025 01:11:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41217155C83;
	Thu, 29 May 2025 01:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748481072; cv=none; b=tf9iZ/XVteR/k1wBWl/XJF1eH7rZgp/9CvPQVE78Zdz2cJwb1KhwVTVM+dJVVuGLgZBYVMtVe2k7T7VE3n3RwOpPyQ2HrLl95hhqPkyoY+59D0xnSY6O6Nqt/u48eBmvob1PtIgUpW5QEfi4s4/SNuVOney1wAhY+tfHso4Lv60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748481072; c=relaxed/simple;
	bh=wOBSgxrE3eFgY8U43apRcxIY0s0fPyaGRr5Is1W7FEM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eYQoOJ4mmCfEgxYadN4JgaUozk795nVUVQweV2n1mcm64OgL6+YTPyCYrxFPH5hhMLu5VOKclLVNDekK9mkLmCS2nxpGIi4ZUArYiR5k1USbOGRWM7Pxr2Te7EMlTqZt/Ttb5F4qv4HNLeNbFgtI948a2m9H4whWORQYXJp1dGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxbWsntDdofB4BAQ--.20456S3;
	Thu, 29 May 2025 09:11:03 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMCx_cYmtDdoR0P5AA--.57458S2;
	Thu, 29 May 2025 09:11:02 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] LoongArch: KVM: Enhancement about eiointc emulation
Date: Thu, 29 May 2025 09:10:57 +0800
Message-Id: <20250529011102.378749-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCx_cYmtDdoR0P5AA--.57458S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

This series fix two issue about kernel eiointc emulation, one is caused
by type forced assignment, the other is to use physical cpu with
interrupt route.

Also there is code cleanup with kernel eiointc emulation.

Bibo Mao (5):
  LoongArch: KVM: Fix interrupt route update with eiointc
  LoongArch: KVM: Check interrupt route from physical cpu with eiointc
  LoongArch: KVM: Use standard bitops API with eiointc
  LoongArch: KVM: Remove unused parameter len
  LoongArch: KVM: Add stat information with kernel irqchip

 arch/loongarch/include/asm/kvm_host.h |  9 +--
 arch/loongarch/kvm/intc/eiointc.c     | 98 ++++++++++++++-------------
 arch/loongarch/kvm/intc/ipi.c         | 28 ++------
 arch/loongarch/kvm/intc/pch_pic.c     |  4 +-
 arch/loongarch/kvm/vcpu.c             |  5 +-
 5 files changed, 65 insertions(+), 79 deletions(-)


base-commit: feacb1774bd5eac6382990d0f6d1378dc01dd78f
-- 
2.39.3


