Return-Path: <kvm+bounces-16124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E3A48B4B20
	for <lists+kvm@lfdr.de>; Sun, 28 Apr 2024 12:05:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 250E0B21240
	for <lists+kvm@lfdr.de>; Sun, 28 Apr 2024 10:05:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FB5857876;
	Sun, 28 Apr 2024 10:05:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58AD851C3F;
	Sun, 28 Apr 2024 10:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714298727; cv=none; b=nsTGaaDRVmZvciRFPZdRkvJYTb3WWw9WIad8rhlysMcLfRGez5hsRt4h+Fe/MTBIKzxwaQ6SqDQzQu/+ayroH2rTA7aPl3pdttujE4e3RmmU7o0oxJUK3uA1UxqHyp4dKi1Rzeu3KVfnkwUt3zA8ZChboSYI4Eb4wKRateEFQ3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714298727; c=relaxed/simple;
	bh=DQwXWemmmFb5FzU1InRORYzSXMrEHPxbPz5hpOSMo18=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=leyUqEhEzbVKPgEyz5uPR148cAmB5cyn1NXt2TSZY87hQXKyK//I+oHVGwad/yzvplL2OMWmB7hy2kWfnN+j6nnL2IKZjepbt3W1LbrXiBDyVU7bJ4NupsEOUSF17jzHb2G20NrgK8pEN8WM6RieaPCIa6plWgtsYq+NMSgR8M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxpOpgHy5mo10EAA--.3551S3;
	Sun, 28 Apr 2024 18:05:20 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxsFVeHy5maTIIAA--.5646S2;
	Sun, 28 Apr 2024 18:05:18 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v8 0/6] LoongArch: Add pv ipi support on LoongArch VM
Date: Sun, 28 Apr 2024 18:05:12 +0800
Message-Id: <20240428100518.1642324-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxsFVeHy5maTIIAA--.5646S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

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

It passes to boot with 128/256 vcpus, and passes to run runltp command
with package ltp-20230516.

---
v7 --- v8:
 1. Remove kernel PLV mode checking with cpucfg emulation for hypervisor
feature inquiry.
 2. Remove document about loongarch hypercall ABI per request of huacai,
will add English/Chinese doc at the same time in later.

v6 --- v7:
  1. Refine LoongArch virt document by review comments.
  2. Add function kvm_read_reg()/kvm_write_reg() in hypercall emulation,
and later it can be used for other trap emulations.

v5 --- v6:
  1. Add privilege checking when emulating cpucfg at index 0x4000000 --
0x400000FF, return 0 if not executed at kernel mode.
  2. Add document about LoongArch pv ipi with new creatly directory
Documentation/virt/kvm/loongarch/
  3. Fix pv ipi handling in kvm backend function kvm_pv_send_ipi(),
where min should plus BITS_PER_LONG with second bitmap, otherwise
VM with more than 64 vpus fails to boot.
  4. Adjust patch order and code refine with review comments.

v4 --- v5:
  1. Refresh function/macro name from review comments.

v3 --- v4:
  1. Modfiy pv ipi hook function name call_func_ipi() and
call_func_single_ipi() with send_ipi_mask()/send_ipi_single(), since pv
ipi is used for both remote function call and reschedule notification.
  2. Refresh changelog.

v2 --- v3:
  1. Add 128 vcpu ipi multicast support like x86
  2. Change cpucfg base address from 0x10000000 to 0x40000000, in order
to avoid confliction with future hw usage
  3. Adjust patch order in this patchset, move patch
Refine-ipi-ops-on-LoongArch-platform to the first one.

v1 --- v2:
  1. Add hw cpuid map support since ipi routing uses hw cpuid
  2. Refine changelog description
  3. Add hypercall statistic support for vcpu
  4. Set percpu pv ipi message buffer aligned with cacheline
  5. Refine pv ipi send logic, do not send ipi message with if there is
pending ipi message.
---
Bibo Mao (6):
  LoongArch/smp: Refine some ipi functions on LoongArch platform
  LoongArch: KVM: Add hypercall instruction emulation support
  LoongArch: KVM: Add cpucfg area for kvm hypervisor
  LoongArch: KVM: Add vcpu search support from physical cpuid
  LoongArch: KVM: Add pv ipi support on kvm side
  LoongArch: Add pv ipi support on guest kernel side

 arch/loongarch/Kconfig                        |   9 +
 arch/loongarch/include/asm/Kbuild             |   1 -
 arch/loongarch/include/asm/hardirq.h          |   5 +
 arch/loongarch/include/asm/inst.h             |   1 +
 arch/loongarch/include/asm/irq.h              |  10 +-
 arch/loongarch/include/asm/kvm_host.h         |  27 +++
 arch/loongarch/include/asm/kvm_para.h         | 155 ++++++++++++++++++
 arch/loongarch/include/asm/kvm_vcpu.h         |  11 ++
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
 arch/loongarch/kvm/exit.c                     | 132 +++++++++++++--
 arch/loongarch/kvm/vcpu.c                     |  94 ++++++++++-
 arch/loongarch/kvm/vm.c                       |  11 ++
 22 files changed, 690 insertions(+), 102 deletions(-)
 create mode 100644 arch/loongarch/include/asm/kvm_para.h
 create mode 100644 arch/loongarch/include/asm/paravirt.h
 create mode 100644 arch/loongarch/include/asm/paravirt_api_clock.h
 delete mode 100644 arch/loongarch/include/uapi/asm/Kbuild
 create mode 100644 arch/loongarch/kernel/paravirt.c


base-commit: 5eb4573ea63d0c83bf58fb7c243fc2c2b6966c02
-- 
2.39.3


