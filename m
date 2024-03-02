Return-Path: <kvm+bounces-10703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 535A386EF55
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 08:52:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E65AB2448D
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 07:51:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2049168A8;
	Sat,  2 Mar 2024 07:51:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3591125B2;
	Sat,  2 Mar 2024 07:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709365887; cv=none; b=o9gVrQZA/LT6xxA3VdLA8v25SZ10Exi/pnX+VFFve4TAqoDo+V1j6uH6Kbv9uk3GRO4r+hO6qW7lpNAVxulV6Vz7Ch2rhfRNYoxM83evkeoNd9qRinMkBGNpr23JFfd/585g5Gq3gHXT5GrKEcIcnQxTbJmWoNZof8We0rk2/Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709365887; c=relaxed/simple;
	bh=o3q1u0pG1faOVKC8mBP4iV1gk27RLSStqnjTvqSvTpo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=C62yES3wGZ7gl28qmhU7ER86y9Z4Z9/bC0BYQVg9OTGatrzInB/WwA9UmOss6+ha/i8GnlifPA52y0WisqTt2eqj1cBAzgINrNiTCMliHgwSl29I+pAAyYAyDiIq9dRVyE1XYWkG2CQYFnFo9bhsg3pNjvhDIbg512T6GflyfL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxuvB62uJldYYTAA--.49603S3;
	Sat, 02 Mar 2024 15:51:22 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxrhN42uJlLU9MAA--.16478S2;
	Sat, 02 Mar 2024 15:51:20 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH v6 0/7] LoongArch: Add pv ipi support on LoongArch VM
Date: Sat,  2 Mar 2024 15:51:13 +0800
Message-Id: <20240302075120.1414999-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxrhN42uJlLU9MAA--.16478S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxJw4DuF1xWw1xZw48KrWDWrX_yoW7Jw1Dpa
	yUurnxWFs5Gr93Zwnxtas3ur98Jw1xG34aq3W2yrW8CrW2qF1UZr48Gr98Aas5Jw4fJFW0
	qF1rGw1Yg3WDAabCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1q6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJwAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
	Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jw0_
	WrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
	xGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwCFI7km07C267AKxVWUXVWUAwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
	vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IY
	x2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26c
	xKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAF
	wI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UN6p9UUUUU=

On physical machine, ipi HW uses IOCSR registers, however there is trap
into hypervisor when vcpu accesses IOCSR registers if system is in VM
mode. SWI is a interrupt mechanism like SGI on ARM, software can send
interrupt to CPU, only that on LoongArch SWI can only be sent to local CPU
now. So SWI can not used for IPI on real HW system, however it can be used
on VM when combined with hypercall method. IPI can be sent with hypercall
method and SWI interrupt is injected to vcpu, vcpu can treat SWI
interrupt as IPI.

With PV IPI supported, there is one trap with IPI sending, however with IPI
receiving there is no trap. with IOCSR HW ipi method, there will be one
trap with IPI sending and two trap with ipi receiving.

Also IPI multicast support is added for VM, the idea comes from x86 PV ipi.
IPI can be sent to 128 vcpus in one time. With IPI multicast support, trap
will be reduced greatly.

Here is the microbenchmarck data with "perf bench futex wake" testcase on
3C5000 single-way machine, there are 16 cpus on 3C5000 single-way machine,
VM has 16 vcpus also. The benchmark data is ms time unit to wakeup 16
threads, the performance is better if data is smaller.

physical machine                     0.0176 ms
VM original                          0.1140 ms
VM with pv ipi patch                 0.0481 ms

It passes to boot with 128/256 vcpus, runltp command in package ltp-20230516
passes to run with 16 cores.

---
Change in V6:
  1. Add privilege checking when emulating cpucfg at index 0x4000000 --
0x400000FF, return 0 if not executed at kernel mode.
  2. Add document about LoongArch pv ipi with new creatly directory
Documentation/virt/kvm/loongarch/
  3. Fix pv ipi handling in kvm backend function kvm_pv_send_ipi(),
where min should plus BITS_PER_LONG with second bitmap, otherwise
VM with more than 64 vpus fails to boot.
  4. Adjust patch order and code refine with review comments.
 
Change in V5:
  1. Refresh function/macro name from review comments.

Change in V4:
  1. Modfiy pv ipi hook function name call_func_ipi() and
call_func_single_ipi() with send_ipi_mask()/send_ipi_single(), since pv
ipi is used for both remote function call and reschedule notification.
  2. Refresh changelog.

Change in V3:
  1. Add 128 vcpu ipi multicast support like x86
  2. Change cpucfg base address from 0x10000000 to 0x40000000, in order
to avoid confliction with future hw usage
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
Bibo Mao (7):
  LoongArch/smp: Refine some ipi functions on LoongArch platform
  LoongArch: KVM: Add hypercall instruction emulation support
  LoongArch: KVM: Add cpucfg area for kvm hypervisor
  LoongArch: KVM: Add vcpu search support from physical cpuid
  LoongArch: KVM: Add pv ipi support on kvm side
  LoongArch: Add pv ipi support on guest kernel side
  Documentation: KVM: Add hypercall for LoongArch

 Documentation/virt/kvm/index.rst              |   1 +
 .../virt/kvm/loongarch/hypercalls.rst         |  79 +++++++++
 Documentation/virt/kvm/loongarch/index.rst    |  10 ++
 arch/loongarch/Kconfig                        |   9 +
 arch/loongarch/include/asm/Kbuild             |   1 -
 arch/loongarch/include/asm/hardirq.h          |   5 +
 arch/loongarch/include/asm/inst.h             |   1 +
 arch/loongarch/include/asm/irq.h              |  10 +-
 arch/loongarch/include/asm/kvm_host.h         |  27 +++
 arch/loongarch/include/asm/kvm_para.h         | 156 ++++++++++++++++++
 arch/loongarch/include/asm/kvm_vcpu.h         |   1 +
 arch/loongarch/include/asm/loongarch.h        |  11 ++
 arch/loongarch/include/asm/paravirt.h         |  27 +++
 .../include/asm/paravirt_api_clock.h          |   1 +
 arch/loongarch/include/asm/smp.h              |  31 ++--
 arch/loongarch/include/uapi/asm/Kbuild        |   2 -
 arch/loongarch/kernel/Makefile                |   1 +
 arch/loongarch/kernel/irq.c                   |  24 +--
 arch/loongarch/kernel/paravirt.c              | 151 +++++++++++++++++
 arch/loongarch/kernel/perf_event.c            |  14 +-
 arch/loongarch/kernel/smp.c                   |  62 ++++---
 arch/loongarch/kernel/time.c                  |  12 +-
 arch/loongarch/kvm/exit.c                     | 141 ++++++++++++++--
 arch/loongarch/kvm/vcpu.c                     |  94 ++++++++++-
 arch/loongarch/kvm/vm.c                       |  11 ++
 25 files changed, 780 insertions(+), 102 deletions(-)
 create mode 100644 Documentation/virt/kvm/loongarch/hypercalls.rst
 create mode 100644 Documentation/virt/kvm/loongarch/index.rst
 create mode 100644 arch/loongarch/include/asm/kvm_para.h
 create mode 100644 arch/loongarch/include/asm/paravirt.h
 create mode 100644 arch/loongarch/include/asm/paravirt_api_clock.h
 delete mode 100644 arch/loongarch/include/uapi/asm/Kbuild
 create mode 100644 arch/loongarch/kernel/paravirt.c


base-commit: 87adedeba51a822533649b143232418b9e26d08b
-- 
2.39.3


