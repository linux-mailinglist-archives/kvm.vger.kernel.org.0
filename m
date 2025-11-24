Return-Path: <kvm+bounces-64311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10F40C7EEB3
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 04:54:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 064083A5716
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 03:54:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C3D829992B;
	Mon, 24 Nov 2025 03:54:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BBDED271;
	Mon, 24 Nov 2025 03:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763956456; cv=none; b=nobb1VXFzz3leqtlCshCLwdt6KoiicvfLELYg6P2GZ4E/9OGnKWPaPG9C+b3bLeyS/NoyyZDkVnyWD4L1dizm5ct3bQMdiZJRPb1XTDftDbY1OdSbDJY92//zxP/rvL0gsOvQSVxv+QrGxNt1+ooHgljKTrAkSY9hXd/skgkSNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763956456; c=relaxed/simple;
	bh=WugNzPDpWWSDwFJKcGztz11pEF9XdZ3BNRHxQmJiXOY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Q7RFHON1C0eZxR7FyFX/kMk9ECzlXCMuoPOprTdWB8uxKtAKGtJZfTB5pap/FLNa/7hd5K42d2zRC/i0BIxy1LTnDs+troH8lxNu30GA/nKM/00nfBvEgIGzf6kUjLkATup/OqHGHMSBEd36G7+/Pnrv/I3/VGfdGsrP3QZmNUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxztLb1iNpulonAA--.18262S3;
	Mon, 24 Nov 2025 11:54:03 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJAxusDa1iNp4WE9AQ--.13468S2;
	Mon, 24 Nov 2025 11:54:03 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] LoongArch: KVM: Add paravirt preempt support
Date: Mon, 24 Nov 2025 11:53:58 +0800
Message-Id: <20251124035402.3817179-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxusDa1iNp4WE9AQ--.13468S2
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
---
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
Bibo Mao (3):
  LoongArch: KVM: Add paravirt preempt feature in hypervisor side
  LoongArch: Add paravirt support with vcpu_is_preempted() in guest side
  LoongArch: Add paravirt preempt print prompt

 arch/loongarch/include/asm/kvm_host.h      |  2 +
 arch/loongarch/include/asm/kvm_para.h      |  4 +-
 arch/loongarch/include/asm/qspinlock.h     |  5 ++
 arch/loongarch/include/uapi/asm/kvm.h      |  1 +
 arch/loongarch/include/uapi/asm/kvm_para.h |  1 +
 arch/loongarch/kernel/paravirt.c           | 24 +++++++++-
 arch/loongarch/kvm/vcpu.c                  | 53 +++++++++++++++++++++-
 arch/loongarch/kvm/vm.c                    |  5 +-
 8 files changed, 91 insertions(+), 4 deletions(-)


base-commit: ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d
-- 
2.39.3


