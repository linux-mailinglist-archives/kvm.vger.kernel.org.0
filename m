Return-Path: <kvm+bounces-9349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E87B985EFCF
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 04:28:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CD582835F2
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 03:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92E991775E;
	Thu, 22 Feb 2024 03:28:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6727168BD;
	Thu, 22 Feb 2024 03:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708572490; cv=none; b=aLko0rUzwrEjGfHVrFcUdSQ/MAgTd0x0lzYHn7vEn1TdTbGpttoTrw5JQY/niB9LsRGXFIaGXtucTvfY73f0K9kqaVSJXa/XBKTTukR3pIAXIwI0l+WCGBhyaWn8g12rNkuUTFWFVNMBxxwQUoJtDs1N6uyx73UYc/5j3qo2uhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708572490; c=relaxed/simple;
	bh=g1rTH16jjRqZ9k/FyIw+Uz8qJkzVdUUTrfr37YwDLcM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=k8ZygTG/l2uJjn2ETcxU1l1cBf59rbp5lD6+NaGnV6mw/v+kgKcwzXcZ7ad/vXqiYXYgKGySuyLQg8HM/7OGDr4NhCEDFKgquQamdSbD0JSr/+2DsdnQz++eBzkSNf1KHb5C4nZejfoTiEAO3OR25efyoz6QVdXzqkv88jII+jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxefBFv9ZlVwoQAA--.42484S3;
	Thu, 22 Feb 2024 11:28:05 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxrhNDv9Zl+nM+AA--.41033S2;
	Thu, 22 Feb 2024 11:28:03 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v5 0/6] LoongArch: Add pv ipi support on LoongArch VM
Date: Thu, 22 Feb 2024 11:27:57 +0800
Message-Id: <20240222032803.2177856-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxrhNDv9Zl+nM+AA--.41033S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxJw4DuF1xWw1xZw48KrWDWrX_yoWrWF1xpa
	9rurn8Wr4rGryfZwnxt3s3urn8Jw1xG34aq3W2y3yUC3y2qFyUZr4kGryDAa4kJw4fJrW0
	qF1rGw1ag3WUAabCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Fb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r126r13M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	AVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7V
	AKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v2
	6r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIx
	AIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2
	KfnxnUUI43ZEXa7IU8sL05UUUUU==

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
VM has 16 vcpus also. The benchmark data is ms time unit to wakeup 16 threads,
the performance is better if data is smaller.

physical machine                     0.0176 ms
VM original                          0.1140 ms
VM with pv ipi patch                 0.0481 ms

---
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
Bibo Mao (6):
  LoongArch/smp: Refine some ipi functions on LoongArch platform
  LoongArch: KVM: Add hypercall instruction emulation support
  LoongArch: KVM: Add cpucfg area for kvm hypervisor
  LoongArch: Add paravirt interface for guest kernel
  LoongArch: KVM: Add vcpu search support from physical cpuid
  LoongArch: Add pv ipi support on LoongArch system

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
 arch/loongarch/kernel/paravirt.c              | 153 +++++++++++++++++
 arch/loongarch/kernel/perf_event.c            |  14 +-
 arch/loongarch/kernel/setup.c                 |   2 +
 arch/loongarch/kernel/smp.c                   |  60 ++++---
 arch/loongarch/kernel/time.c                  |  12 +-
 arch/loongarch/kvm/exit.c                     | 125 ++++++++++++--
 arch/loongarch/kvm/vcpu.c                     |  94 ++++++++++-
 arch/loongarch/kvm/vm.c                       |  11 ++
 23 files changed, 676 insertions(+), 102 deletions(-)
 create mode 100644 arch/loongarch/include/asm/kvm_para.h
 create mode 100644 arch/loongarch/include/asm/paravirt.h
 create mode 100644 arch/loongarch/include/asm/paravirt_api_clock.h
 delete mode 100644 arch/loongarch/include/uapi/asm/Kbuild
 create mode 100644 arch/loongarch/kernel/paravirt.c


base-commit: 39133352cbed6626956d38ed72012f49b0421e7b
-- 
2.39.3


