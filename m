Return-Path: <kvm+bounces-66308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D80DBCCEA65
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 07:31:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 51ADE305E358
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 06:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D11E32DE6E6;
	Fri, 19 Dec 2025 06:30:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA6602DA75F;
	Fri, 19 Dec 2025 06:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766125844; cv=none; b=jkdQG2r56jMTFuDEXuiYDv9BruKHFyoCnTTsxMUwAZRApS8EWj2cHiHVAWA4CA8hjGz3fQxdCya0B1jXLGnWayIGpNUegFoUyWOfWSl7WO9hIyNTuHEHVmS9Np4Mi9LAye7iBzD//7ZdsxR22vTnwlMrFV7BabuWrCF3kl48VnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766125844; c=relaxed/simple;
	bh=3cuMPz6ATxGaiqM4JNQ+xrnm7gl4HpleDzVq7J7439Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dcxcl5k4vwWpGSx1QY/ULtYgAdKiGBYfFw5LqtSOSQQ2j36e/qfzwJ8maErjtC/ErZHq1GthmDvTnQ26b38OQx0Irfa+Mirr4Tc1fJ75DtKtNAZvxUjpVpoNNi8ikD2X7IfKuy1NZTzFhrvGKhjS9I13+ZPoH6/+oZEybBZQLrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxqsL_8ERpO8EAAA--.2502S3;
	Fri, 19 Dec 2025 14:30:23 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBx68H+8ERpt6kBAA--.3572S2;
	Fri, 19 Dec 2025 14:30:22 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	WANG Xuerui <kernel@xen0n.name>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] LoongArch: KVM: Add paravirt preempt support
Date: Fri, 19 Dec 2025 14:30:19 +0800
Message-Id: <20251219063021.1778659-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBx68H+8ERpt6kBAA--.3572S2
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
between over-commited VM and host is osq_lock(). if vcpu_is_preempted()
is implemented on VM, it can avoid  unnecessary busy-loop waiting and
enter sleep state quickly if lock-hold vCPU is preempted.

Here is test result with kcbench on 3D6000 and 3C6000 hardware machines,
time unit is second to compile kernel with defconfig, performance is
better with smaller value.
3D6000 Dual-way 64 Core 128 Threads
 One VM with 128 vCPUs, no overcommit, NUMA
             Orginal       With-patch       Improvement
  VM         91.72         92.4             < -1%
  Host       89.7          89.75            < -0.1%
 Two VMs overcommit with 128 vCPUs, UMA
             Orginal       With-patch       Improvement
  VM1        306.9         197.5            +36%
  VM2        303.7         197.8            +35%
  Host       89.7          89.75             < -0.1%
 Two VMs overcommit with 128 vCPUs, NUMA
             Orginal       With-patch       Improvement
  VM1        317.1         159              +50%
  VM2        317.5         158              +50%
  Host       89.7          89.75            < -0.1%
3C5000  Dual-way 32 Core
 One VM with 32 vCPUs, NUMA
             Orginal       With-patch       Improvement
  VM         208           207              < +0.5%
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

---
v3 ... v4:
  1. Base on the latest version 6.19.0-rc1, and solve some confliction
     issues.
  2. Move definition and usage about variable virt_preempt_key outside of
     CONFIG_SMP.

v2 ... v3:
  1. Remove CONFIG_SMP checking in header file asm/qspinlock.h, since
     this file is included only if CONFIG_SMP is defined.
  2. Replace internal variable pv_preempted with static_key_enabled()
     method.
  3. Add static type define with variable virt_preempt_key.
  4. Merge previous patch 2 and patch 3 into one patch.

v1 ... v2:
  1. Rename feature KVM_FEATURE_PREEMPT_HINT with KVM_FEATURE_PREEMPT,
     remove HINT in feature name.
  2. Rename reverve field with __u8 pad[47] rather than combination of
     __u8  u8_pad[3] and __u32 pad[11]
  3. Rename internal function _kvm_set_vcpu_preempted() with
     kvm_vcpu_set_pv_preempted(), remove prefix "_" and also in order to
     avoid duplication name with common API in future.
  4. Remove static variable u8 preempted and macro KVM_VCPU_PREEMPTED is
     used directly.
  5. Move definition of vcpu_is_preempted() from file spinlock.h to
     qspinlock.h, since CONFIG_PARAVIRT is used in qspinlock.h already.
  6. Add CONFIG_SMP checking with vcpu_is_preempted() to solve compile
     issue reported by LKP if CONFIG_SMP is disabled.
  7. Add static key virt_preempt_key with vcpu_is_preempted(), remove
     mp_ops.vcpu_is_preempted method.
---
Bibo Mao (2):
  LoongArch: KVM: Add paravirt preempt feature in hypervisor side
  LoongArch: Add paravirt support with vcpu_is_preempted() in guest side

 arch/loongarch/include/asm/kvm_host.h      |  2 +
 arch/loongarch/include/asm/kvm_para.h      |  4 +-
 arch/loongarch/include/asm/qspinlock.h     |  3 ++
 arch/loongarch/include/uapi/asm/kvm.h      |  1 +
 arch/loongarch/include/uapi/asm/kvm_para.h |  1 +
 arch/loongarch/kernel/paravirt.c           | 21 ++++++++-
 arch/loongarch/kvm/vcpu.c                  | 53 +++++++++++++++++++++-
 arch/loongarch/kvm/vm.c                    |  3 ++
 8 files changed, 85 insertions(+), 3 deletions(-)


base-commit: dd9b004b7ff3289fb7bae35130c0a5c0537266af
-- 
2.39.3


