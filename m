Return-Path: <kvm+bounces-22093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06763939BCF
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 09:38:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8F453B214A4
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 07:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E475714B94E;
	Tue, 23 Jul 2024 07:38:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7E9114A4E9;
	Tue, 23 Jul 2024 07:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721720311; cv=none; b=tCyQe2SsxD7Ognz4PIrP5J+eFe2kIKpwyz/rKXY6uEXg6WyOjyzLWO37cdcklP50gjGozAo/nlDFzn29eeIkTfi7e6mDt4o9LlB/O6q69Iq4YaHadDqZlaEitOTS7CwQemZn8HELvybnCkKU34Yz1U6NGaUt0YxHzUG3o6lWLMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721720311; c=relaxed/simple;
	bh=ZTzMUqY8joLASIi7mv9v5tM2TSHOz+ePsO7TCtOMSVU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nHEg1kyRVQ1zR07mDPTvBZqIzAMxsGr+YU9w9GyrNR93Bmc3N48cKc/q2tqFhzsLH9z4VRhpJ1fXxJCm5F03zDL1aHqc1aun+t7j5uGkO4jxS3CyKw2pQGuUKb6parKn8TZJ6uNs9MkiSjl5QN//ZWYLKQU0/ioxirR2gCfV9qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxvOryXZ9m6WAAAA--.1598S3;
	Tue, 23 Jul 2024 15:38:26 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxusbxXZ9m+l9VAA--.59486S2;
	Tue, 23 Jul 2024 15:38:26 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Peter Zijlstra <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>
Cc: WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: [PATCH 0/2] LoongArch: KVM: Add paravirt qspinlock support
Date: Tue, 23 Jul 2024 15:38:23 +0800
Message-Id: <20240723073825.1811600-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxusbxXZ9m+l9VAA--.59486S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Lock Holder Preemption (LHP) is classic problem especially on VM, if
lock holder vCPU is preempted on host, other vCPUs will do busy looping
and waste pCPU time. And there is no hw Pause Loop Exiting (PLE) supported
on LoongArch system also.

Here pavavirt qspinlock is introduced, by the kernel compiling test, it
improves performance greatly if pVCPU is shared by multiple vCPUs. The
testbed is on 3C5000 Dual-way machine with 32 cores and 2 numa nodes,
test case is kcbench on kernel mainline 5.10, the detailed command is
"kcbench --src /root/src/linux"

Performance on host machine
                      kernel compile time       performance impact
   Original           150.29 seconds
   With patch         150.20 seconds            almost no impact

Performance on virtual machine:
1. 1 VM  with 32 vCPUs and 2 numa node
                      kernel compile time       performance impact
   Original           173.07 seconds
   With patch         171.73 seconds            +1%

2. 2 VMs with 32 vCPUs and 2 numa node
                      kernel compile time       performance impact
   Original           2362.04 seconds
   With patch         354.17 seconds            +566%

Bibo Mao (2):
  LoongArch: KVM: Add paravirt qspinlock in kvm side
  LoongArch: KVM: Add paravirt qspinlock in guest side

 arch/loongarch/Kconfig                        | 14 +++
 arch/loongarch/include/asm/Kbuild             |  1 -
 arch/loongarch/include/asm/kvm_host.h         |  4 +
 arch/loongarch/include/asm/kvm_para.h         |  1 +
 arch/loongarch/include/asm/loongarch.h        |  1 +
 arch/loongarch/include/asm/paravirt.h         | 47 ++++++++++
 arch/loongarch/include/asm/qspinlock.h        | 39 ++++++++
 .../include/asm/qspinlock_paravirt.h          |  6 ++
 arch/loongarch/kernel/paravirt.c              | 88 +++++++++++++++++++
 arch/loongarch/kernel/smp.c                   |  4 +-
 arch/loongarch/kvm/exit.c                     | 24 ++++-
 arch/loongarch/kvm/vcpu.c                     | 13 ++-
 12 files changed, 238 insertions(+), 4 deletions(-)
 create mode 100644 arch/loongarch/include/asm/qspinlock.h
 create mode 100644 arch/loongarch/include/asm/qspinlock_paravirt.h


base-commit: 7846b618e0a4c3e08888099d1d4512722b39ca99
-- 
2.39.3


