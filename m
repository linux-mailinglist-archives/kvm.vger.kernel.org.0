Return-Path: <kvm+bounces-63515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 47E4FC68230
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 09:11:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8208834FE2E
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 08:07:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E554B307AE0;
	Tue, 18 Nov 2025 08:07:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B1BD305079;
	Tue, 18 Nov 2025 08:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763453231; cv=none; b=jXS37Mt0+OXLsNgZeXoXS3BskjZgK+5dxj8SabDJK7ZSHgxhNx8dpgiaVa95PeTCHJPZQMArpp/0NnvOncBRc7LOqfvSFW8kc/RQcTWzDQpMbNGixQqy7ZI4IjM78XhmTUweKK41BAYOqov2ghc6/iEXHj84wyyTXQjSqUr0zWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763453231; c=relaxed/simple;
	bh=HPN0xRK11gTW7zctCo3QreKAkFMRFcOSKv/dl7uN7u8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NX55zxozs4NKlhcrn1Yv78GbJovNRdhRWiJewYzgjKHE/DRa4qL8+9BmROXFiyQr1dpAU2Q84S64+BJhuGbcerfnPh2vGxB0lX8zJ9LmOL9GCOk2IZnR8StLFh2WOQ+0e1N7x6iEUvhSB4sfGbWw0KqFWStLcgc+yptsWcLGKrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Dx_tIiKRxp69gkAA--.14100S3;
	Tue, 18 Nov 2025 16:06:58 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxjcEhKRxpUhc3AQ--.33984S2;
	Tue, 18 Nov 2025 16:06:57 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] LoongArch: KVM: Add paravirt preempt hint support
Date: Tue, 18 Nov 2025 16:06:53 +0800
Message-Id: <20251118080656.2012805-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxjcEhKRxpUhc3AQ--.33984S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

vCPU preempt hint is useful with sched and lock on some platforms, here
new feature KVM_FEATURE_PREEMPT_HINT is added and VMM can selectively
enable it.

Test case kcbench is used to compile Linux kernel code, the test result
shows that it is useful on 3D6000 Dual-way machine with 64 cores and 128
hyperthreads, however no improvemet on 3C5000 Dual-way machine with 32
cores. With perf top command when running test case, the main difference
between over-commited VM and host is osq_lock(), it can avoid
unnecessary busy-loop waiting and enter sleep state quickly if lock-hold
vCPU is preempted.

Here is test result with kcbench, time unit is second to compile kernel
with defconfig, performance is better with smaller value.
3D6000 Dual-way 64 Core 128 Threads
 One VM with 128 vCPUs, no overcommit, NUMA
             Orginal       With-patch       Improvement
  VM         91.72         92.4             < -1%
  Host       89.7          89.75            < -0.1%
 Two VMs overcommit with 128 vCPUs, UMA
             Orginal       With-patch       Improvement
  VM1        306.9         197.5            36%
  VM2        303.7         197.8            35%
  Host       89.7          89.75             < -0.1%
 Two VMs overcommit with 128 vCPUs, NUMA
             Orginal       With-patch       Improvement
  VM1        317.1         159              50%
  VM2        317.5         158              50%
  Host       89.7          89.75            < -0.1%
3C5000  Dual-way 32 Core
 One VM with 32 vCPUs, NUMA
             Orginal       With-patch       Improvement
  VM         208           207              < 0.5%
  Host       184           185              < -0.5%
 Two VMs overcommit with 32 vCPUs, UMA
             Orginal       With-patch       Improvement
  VM1        439           444              -1%
  VM2        437           438              < -0.2%
  Host       184           185              < -0.5%
 Two VMs overcommit with 32 vCPUs, NUMA
             Orginal       With-patch       Improvement
  VM1        422           425              < -1%
  VM2        418           415              < -1%
  Host       184           185              < -0.5%

Bibo Mao (3):
  LoongArch: KVM: Add preempt hint feature in hypervisor side
  LoongArch: Add paravirt support with vcpu_is_preempted()
  LoongArch: Add paravirt preempt hint print prompt

 arch/loongarch/include/asm/kvm_host.h      |  2 +
 arch/loongarch/include/asm/kvm_para.h      |  5 +-
 arch/loongarch/include/asm/smp.h           |  1 +
 arch/loongarch/include/asm/spinlock.h      |  5 ++
 arch/loongarch/include/uapi/asm/kvm.h      |  1 +
 arch/loongarch/include/uapi/asm/kvm_para.h |  1 +
 arch/loongarch/kernel/paravirt.c           | 24 +++++++++-
 arch/loongarch/kernel/smp.c                |  6 +++
 arch/loongarch/kvm/vcpu.c                  | 54 +++++++++++++++++++++-
 arch/loongarch/kvm/vm.c                    |  5 +-
 10 files changed, 100 insertions(+), 4 deletions(-)


base-commit: 6a23ae0a96a600d1d12557add110e0bb6e32730c
-- 
2.39.3


