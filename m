Return-Path: <kvm+bounces-16207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D67018B67A0
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 03:45:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14F2D1C223B4
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 01:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 655B99460;
	Tue, 30 Apr 2024 01:45:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 746B88F6F;
	Tue, 30 Apr 2024 01:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714441515; cv=none; b=i595w4SGIuA7v1bQJ1gP99eRBbZuYokngDL0SZdxzEVWyLfiTaCd+/nme5vb/02e3peQibEqTZVqit6Sn90eDJvh64YBDjjx8B0RKGqiiOpzJGtuub9dUJ0/3Y342iHaIXxal5RHG1a8W4AnRPESxr09DM6ebQlSXZbzRYLaGHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714441515; c=relaxed/simple;
	bh=FCCUCcSRQzl70WCsycckCWI1PlotsQL9ggX/zV1th3M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=suOvGwtiO1QJVkSggpX/wBgEIu9yRchcHeQwXRt3KPqwwp2ZGnNplm65ZsYlv0VwHUWakoVIJYxZB/IS0IcK/QkyHt7Pr8ksC+7P86HYWNb3b5B8uqauguOQJrAPIlKnOw8SQroWVV2O+UqSHN0CzZ4Gah8pvWbPovJnJ4q/OOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxN+klTTBmsjoFAA--.5166S3;
	Tue, 30 Apr 2024 09:45:09 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxyt0hTTBmfrwKAA--.25728S2;
	Tue, 30 Apr 2024 09:45:05 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Juergen Gross <jgross@suse.com>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	virtualization@lists.linux.dev
Subject: [PATCH v2 0/2] LoongArch: Add steal time support
Date: Tue, 30 Apr 2024 09:45:03 +0800
Message-Id: <20240430014505.2102631-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Cxyt0hTTBmfrwKAA--.25728S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Para-virt feature steal time is added in both kvm and guest kernel side.
It is silimar with other architectures, steal time structure comes from
guest memory, also pseduo register is used to save/restore base address
of steal time structure, so that vm migration is supported also.

---
v2:
  1. Add PARAVIRT_TIME_ACCOUNTING kconfig option in file
arch/loongarch/Kconfig
  2. Function name change such as replace pv_register_steal_time with
pv_enable_steal_time etc

---
Bibo Mao (2):
  LoongArch: KVM: Add steal time support in kvm side
  LoongArch: Add steal time support in guest side

 arch/loongarch/Kconfig                 |  11 +++
 arch/loongarch/include/asm/kvm_host.h  |   7 ++
 arch/loongarch/include/asm/kvm_para.h  |  10 ++
 arch/loongarch/include/asm/loongarch.h |   1 +
 arch/loongarch/include/asm/paravirt.h  |   5 +
 arch/loongarch/include/uapi/asm/kvm.h  |   4 +
 arch/loongarch/kernel/paravirt.c       | 131 +++++++++++++++++++++++++
 arch/loongarch/kernel/time.c           |   2 +
 arch/loongarch/kvm/exit.c              |  29 +++++-
 arch/loongarch/kvm/vcpu.c              | 120 ++++++++++++++++++++++
 10 files changed, 318 insertions(+), 2 deletions(-)


base-commit: 2c8159388952f530bd260e097293ccc0209240be
-- 
2.39.3


