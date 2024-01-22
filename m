Return-Path: <kvm+bounces-6535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A129835EFD
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 11:03:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD1771C22312
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 10:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9735F3A29F;
	Mon, 22 Jan 2024 10:03:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A8063A1B2;
	Mon, 22 Jan 2024 10:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705917799; cv=none; b=SPhSJY5xZ8jcANYI+5wmMOYEQBazhohRQsW2/WYTkRch8jobjVuyS0SNQ7BEmpc6zBwEc7WsdOeKIfwBRLdwtD7CN+k9yrMh0Terf5fEzODJQe1vz6A42061T1EsgetkJNuikYkZPqjZZCuDSmbYWDv980Minxn3B1/qyh0msdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705917799; c=relaxed/simple;
	bh=QaI3TybrSwMrvvtSXZ4vLNzCCTaXiUn84Mwme6n7XeI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LUYm2ceYg8GnzNe0XZ+tHvUMgRcgan6GCl6b7sh8U5khvNYe9BSSYgNoY9J6s5BtrdWYWW/k7xc0XpdwqYsG81yPmmribLmBJtAeLPcWf2/Q70dKmioNJ7NnYi+qDHCGMoPc6Ou7ohhazeSahIF6o4iGV/8wXiJTaobyAXw2pqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxafBiPa5l8YMDAA--.14784S3;
	Mon, 22 Jan 2024 18:03:14 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxXs1hPa5l52oRAA--.11303S2;
	Mon, 22 Jan 2024 18:03:13 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v3 0/6] LoongArch: Add pv ipi support on LoongArch VM
Date: Mon, 22 Jan 2024 18:03:07 +0800
Message-Id: <20240122100313.1589372-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxXs1hPa5l52oRAA--.11303S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxCw47WF1kWF1kKF1fAFWfCrX_yoW5KryDpF
	Zrurn3Wr4rGr93Zwnxt3srurn8Jr1xGw1ag3WayrWUC3yaqFyUZr4kGryDZFykJa1rJrW0
	qr1rGw1ag3WUAabCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Fb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	XVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7V
	AKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v2
	6r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIx
	AIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2
	KfnxnUUI43ZEXa7IU8hiSPUUUUU==

This patchset adds pv ipi support for VM. On physical machine, ipi HW
uses IOCSR registers, however there is trap into hypervisor when vcpu
accesses IOCSR registers if system is in VM mode. SWI is a interrupt
mechanism like SGI on ARM, software can send interrupt to CPU, only that
on LoongArch SWI can only be sent to local CPU now. So SWI can not used
for IPI on real HW system, however it can be used on VM when combined with
hypercall method. This patch uses SWI interrupt for IPI mechanism, SWI
injection uses hypercall method. And there is one trap with IPI sending,
however with SWI interrupt handler there is no trap.

Here is the microbenchmarck data with perf bench futex wake case on 3C5000
single-way machine, there are 16 cpus on 3C5000 single-way machine, VM
has 16 vcpus also. The benchmark data is ms time unit to wakeup 16 threads,
the performance is higher if data is smaller.

perf bench futex wake, Wokeup 16 of 16 threads in ms
--physical machine--   --VM original--   --VM with pv ipi patch--
  0.0176 ms               0.1140 ms            0.0481 ms 

---
Change in V3:
  1. Add 128 vcpu ipi multicast support like x86
  2. Change cpucfg base address from 0x10000000 to 0x40000000 which is
used to dectect hypervisor type, in order to avoid confliction with future
hw usage
  3. Adjust patch order in this patchset, move patch 
Refine-ipi-ops-on-LoongArch-platform to the first one.

Change in V2:
  1. Add hw cpuid map support since ipi routing uses hw cpuid
  2. Refine changelog description
  3. Add hypercall statistic support for vcpu
  4. Set percpu pv ipi message buffer aligned with cacheline
  5. Refine pv ipi send logic, do not send ipi message with if there is
pending ipi message.
---

Bibo Mao (6):
  LoongArch/smp: Refine ipi ops on LoongArch platform
  LoongArch: KVM: Add hypercall instruction emulation support
  LoongArch: KVM: Add cpucfg area for kvm hypervisor
  LoongArch: Add paravirt interface for guest kernel
  LoongArch: KVM: Add physical cpuid map support
  LoongArch: Add pv ipi support on LoongArch system

 arch/loongarch/Kconfig                        |   9 +
 arch/loongarch/include/asm/Kbuild             |   1 -
 arch/loongarch/include/asm/hardirq.h          |   5 +
 arch/loongarch/include/asm/inst.h             |   1 +
 arch/loongarch/include/asm/irq.h              |  10 +-
 arch/loongarch/include/asm/kvm_host.h         |  27 +++
 arch/loongarch/include/asm/kvm_para.h         | 157 ++++++++++++++++++
 arch/loongarch/include/asm/kvm_vcpu.h         |   1 +
 arch/loongarch/include/asm/loongarch.h        |  11 ++
 arch/loongarch/include/asm/paravirt.h         |  27 +++
 .../include/asm/paravirt_api_clock.h          |   1 +
 arch/loongarch/include/asm/smp.h              |  31 ++--
 arch/loongarch/include/uapi/asm/Kbuild        |   2 -
 arch/loongarch/kernel/Makefile                |   1 +
 arch/loongarch/kernel/irq.c                   |  24 +--
 arch/loongarch/kernel/paravirt.c              | 154 +++++++++++++++++
 arch/loongarch/kernel/perf_event.c            |  14 +-
 arch/loongarch/kernel/setup.c                 |   2 +
 arch/loongarch/kernel/smp.c                   |  60 ++++---
 arch/loongarch/kernel/time.c                  |  12 +-
 arch/loongarch/kvm/exit.c                     | 125 ++++++++++++--
 arch/loongarch/kvm/vcpu.c                     |  94 ++++++++++-
 arch/loongarch/kvm/vm.c                       |  11 ++
 23 files changed, 678 insertions(+), 102 deletions(-)
 create mode 100644 arch/loongarch/include/asm/kvm_para.h
 create mode 100644 arch/loongarch/include/asm/paravirt.h
 create mode 100644 arch/loongarch/include/asm/paravirt_api_clock.h
 delete mode 100644 arch/loongarch/include/uapi/asm/Kbuild
 create mode 100644 arch/loongarch/kernel/paravirt.c


base-commit: 7a396820222d6d4c02057f41658b162bdcdadd0e
-- 
2.39.3


