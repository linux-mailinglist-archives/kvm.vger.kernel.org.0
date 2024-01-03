Return-Path: <kvm+bounces-5503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4A468228D6
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 08:17:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60007285198
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 07:17:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 158EC1862A;
	Wed,  3 Jan 2024 07:16:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09B1518049;
	Wed,  3 Jan 2024 07:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxvuvACZVlwnIBAA--.5773S3;
	Wed, 03 Jan 2024 15:16:16 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Dxqb2_CZVlm1EYAA--.43800S2;
	Wed, 03 Jan 2024 15:16:15 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Juergen Gross <jgross@suse.com>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH 0/5] LoongArch: Add pv ipi support on LoongArch VM
Date: Wed,  3 Jan 2024 15:16:10 +0800
Message-Id: <20240103071615.3422264-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Dxqb2_CZVlm1EYAA--.43800S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxCw4rGw1kAF48Jr18WF1xJFc_yoWrJF4xpF
	y3Crn3Gr4UGrn3Ars3t345Wr98Jr97Gw1aga1ay392kFZFvF1UZr4kGFWkAFyvqayrtF40
	qr1rG342ga1UJwcCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUk2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1q6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv
	67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2
	Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
	6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0x
	vE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE
	42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6x
	kF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUoxR6UUUUU

This patchset adds pv ipi support for VM. On physical machine, ipi HW
uses IOCSR registers, however there will be trap into hypervisor with
IOCSR registers access. This patch uses SWI interrupt for IPI
notification. During ipi sending with hypercall method, there is still
one trap; however with SWI interrupt handler there is no trap.

This patch passes to runltp testcases, and unixbench score is 99% of
that on physical machine on 3C5000 single way machine. Here is unixbench
score with 16 cores on 3C5000 single way machine.

----------------UnixBench score on 3C5000 machine with 16 cores --------
Dhrystone 2 using register variables         116700.0  339749961.8  29113.1
Double-Precision Whetstone                       55.0      57716.9  10494.0
Execl Throughput                                 43.0      33563.4   7805.4
File Copy 1024 bufsize 2000 maxblocks          3960.0    1017912.5   2570.5
File Copy 256 bufsize 500 maxblocks            1655.0     260061.4   1571.4
File Copy 4096 bufsize 8000 maxblocks          5800.0    3216109.4   5545.0
Pipe Throughput                               12440.0   18404312.0  14794.5
Pipe-based Context Switching                   4000.0    3395856.2   8489.6
Process Creation                                126.0      55684.8   4419.4
Shell Scripts (1 concurrent)                     42.4      55901.8  13184.4
Shell Scripts (8 concurrent)                      6.0       7396.5  12327.5
System Call Overhead                          15000.0    6997351.4   4664.9
System Benchmarks Index Score                                        7288.6

----------------UnixBench score on VM with 16 cores -----------------
Dhrystone 2 using register variables         116700.0  341649555.5  29275.9
Double-Precision Whetstone                       55.0      57490.9  10452.9
Execl Throughput                                 43.0      33663.8   7828.8
File Copy 1024 bufsize 2000 maxblocks          3960.0    1047631.2   2645.5
File Copy 256 bufsize 500 maxblocks            1655.0     286671.0   1732.2
File Copy 4096 bufsize 8000 maxblocks          5800.0    3243588.2   5592.4
Pipe Throughput                               12440.0   16353087.8  13145.6
Pipe-based Context Switching                   4000.0    3100690.0   7751.7
Process Creation                                126.0      51502.1   4087.5
Shell Scripts (1 concurrent)                     42.4      56665.3  13364.4
Shell Scripts (8 concurrent)                      6.0       7412.1  12353.4
System Call Overhead                          15000.0    6962239.6   4641.5
System Benchmarks Index Score                                        7205.8

Bibo Mao (5):
  LoongArch: KVM: Add hypercall instruction emulation support
  LoongArch: KVM: Add cpucfg area for kvm hypervisor
  LoongArch/smp: Refine ipi ops on LoongArch platform
  LoongArch: Add paravirt interface for guest kernel
  LoongArch: Add pv ipi support on LoongArch system

 arch/loongarch/Kconfig                        |   7 +
 arch/loongarch/include/asm/Kbuild             |   1 -
 arch/loongarch/include/asm/hardirq.h          |   5 +
 arch/loongarch/include/asm/inst.h             |   1 +
 arch/loongarch/include/asm/irq.h              |  10 +-
 arch/loongarch/include/asm/kvm_para.h         | 157 ++++++++++++++++++
 arch/loongarch/include/asm/loongarch.h        |  10 ++
 arch/loongarch/include/asm/paravirt.h         |  27 +++
 .../include/asm/paravirt_api_clock.h          |   1 +
 arch/loongarch/include/asm/smp.h              |  31 ++--
 arch/loongarch/include/uapi/asm/Kbuild        |   2 -
 arch/loongarch/kernel/Makefile                |   1 +
 arch/loongarch/kernel/irq.c                   |  24 +--
 arch/loongarch/kernel/paravirt.c              | 144 ++++++++++++++++
 arch/loongarch/kernel/perf_event.c            |  14 +-
 arch/loongarch/kernel/setup.c                 |   2 +
 arch/loongarch/kernel/smp.c                   |  61 ++++---
 arch/loongarch/kernel/time.c                  |  12 +-
 arch/loongarch/kvm/exit.c                     | 118 +++++++++++--
 19 files changed, 527 insertions(+), 101 deletions(-)
 create mode 100644 arch/loongarch/include/asm/kvm_para.h
 create mode 100644 arch/loongarch/include/asm/paravirt.h
 create mode 100644 arch/loongarch/include/asm/paravirt_api_clock.h
 delete mode 100644 arch/loongarch/include/uapi/asm/Kbuild
 create mode 100644 arch/loongarch/kernel/paravirt.c


base-commit: 610a9b8f49fbcf1100716370d3b5f6f884a2835a
-- 
2.39.3


