Return-Path: <kvm+bounces-50962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34247AEB204
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 11:06:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 834613AA54E
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 09:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F24302957C1;
	Fri, 27 Jun 2025 09:05:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74101293C5F;
	Fri, 27 Jun 2025 09:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751015116; cv=none; b=rAKJ1no3WYhKlaVe8vbb/MaSOleZaAi8AVYvMaZmwbvaj9wM34UOqyfxBULg641hjixKpdgYfmARQn+i9FE04L3Qr2TQn66DoKt+GX/fHz9rxX55fEyjKpigVRnXahwKNTYR4VUAPahquGjtsJbRmBLP/wEei5nBt6668IHJKF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751015116; c=relaxed/simple;
	bh=G6D8VhvAz8OaikcjLILwf6y5ICJUOgJt9byBOEzD1jI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=k2CAxHOaJDqUJNSp/xzllpWWmVfXeiAUerDtKqvAd0OSU66rH1YvUU0p4DWBtBCcG/u16WoovpsO+rja/MRaWkrBgcN+OZbFADl0AsvPp8yZQoBAMa4CBjSs3sTJf0Cm3l2HD8MSImVps18daH25YaM2vfGxauLn1Ad1kkc0PQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxC3LFXl5oQjIeAQ--.995S3;
	Fri, 27 Jun 2025 17:05:09 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxM+TEXl5ovCsAAA--.1247S2;
	Fri, 27 Jun 2025 17:05:08 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/6] LoongArch: KVM: Fixes with eiointc emulation
Date: Fri, 27 Jun 2025 17:05:01 +0800
Message-Id: <20250627090507.808319-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxM+TEXl5ovCsAAA--.1247S2
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
  6. The sixth patch adds address alignment check
  
---
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
Bibo Mao (6):
  LoongArch: KVM: Fix interrupt route update with eiointc
  LoongArch: KVM: Check interrupt route from physical cpu
  LoongArch: KVM: Disable update property num_cpu and feature
  LoongArch: KVM: Check validation of num_cpu from user space
  LoongArch: KVM: Avoid overflow with array index
  LoongArch: KVM: Add address alignment check

 arch/loongarch/kvm/intc/eiointc.c | 96 ++++++++++++++++++++++---------
 1 file changed, 68 insertions(+), 28 deletions(-)


base-commit: f02769e7f272d6f42b9767f066c5a99afd2338f3
-- 
2.39.3


