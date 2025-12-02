Return-Path: <kvm+bounces-65060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 97B1BC99E87
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 03:48:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 707754E269D
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 02:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2C833FF1;
	Tue,  2 Dec 2025 02:48:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 443F32327A3;
	Tue,  2 Dec 2025 02:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764643727; cv=none; b=i0Cv5PQUIxj8OXN36an7pkkEl+pE9Pb9ciixwGNdm9D8+bXvcp5hBGIbkS8x+rAP8PnaHfNJeatigbZum/UQUbZeZOtHmhsNVNYsts5hKIe+Q1xCpTmbbxTB5frmyEuEOKJFPXlvP2n44N/XG8GweoPOVqhH8c1WkXKM4+WkQUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764643727; c=relaxed/simple;
	bh=nE2t1I20Enc2+HgdbUl7tzfxy3h/haitVvgL2k8h6pc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NGvd3EOaCUW3DMXdUF6PxPTrKxNSg9AlFZ2PAykEsQaEoxE/Q1MXxWpPSin2egP4vkioiQBTgb73iZEhx9DH2PDUfns8gI3iebhN0NRgcCTtMo2gDBrnAVXukneC5fxw3wmdpIKMIYoqlVmDNz/0nwGFTfqfr47V06dHHjo4/h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxVNCDUy5piygqAA--.25417S3;
	Tue, 02 Dec 2025 10:48:35 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxmcCCUy5p1ExEAQ--.28502S2;
	Tue, 02 Dec 2025 10:48:34 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] LoongArch: KVM: Add paravirt preempt support
Date: Tue,  2 Dec 2025 10:48:30 +0800
Message-Id: <20251202024833.1714363-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxmcCCUy5p1ExEAQ--.28502S2
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
 arch/loongarch/kernel/paravirt.c           | 23 +++++++++-
 arch/loongarch/kvm/vcpu.c                  | 53 +++++++++++++++++++++-
 arch/loongarch/kvm/vm.c                    |  5 +-
 8 files changed, 88 insertions(+), 4 deletions(-)


base-commit: 4664fb427c8fd0080f40109f5e2b2090a6fb0c84
-- 
2.39.3


