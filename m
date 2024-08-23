Return-Path: <kvm+bounces-24875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DDE3D95C9AB
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 11:52:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 870F01F25685
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 09:52:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E527183CA5;
	Fri, 23 Aug 2024 09:51:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D4D9156C69;
	Fri, 23 Aug 2024 09:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724406699; cv=none; b=oAXl+Gz5FlcAeTpdlck3clEqzReCOLm2EmZGkX230ac/qZVyk6thhSfOTg/qD0X1YoGYCVPVghSNXU/l/gH5zdP/ZHKh11hmwHY/4rh+ct7MTz7nVrHz7APdlLhBBkaTt2DiZsQhGgo4Z5g3IzvGptcowG9gketkuBhDCSw66Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724406699; c=relaxed/simple;
	bh=C8gCDi4bx7K5dvL9d6JMbn5lWQebebIemiNddyZcteg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QOspu8OqE/2rA8OPgTZ1pirkM1zIvbV3bog2EI88ME7kk4R9rL1NpjiZRlImk7/ASdL9+gGWjzJbpruv9NBE5fP0j29ixymkJQJvxBxOeWoVNrKczu1ffYTDVI6OaLh79LQBwEFSQNALl4+c/neprAp6RMxuA3jaxTVObv5oSPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8AxSZqmW8hmCEodAA--.25019S3;
	Fri, 23 Aug 2024 17:51:34 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowMCxC2ekW8hm2SsfAA--.39816S2;
	Fri, 23 Aug 2024 17:51:32 +0800 (CST)
From: Xianglai Li <lixianglai@loongson.cn>
To: linux-kernel@vger.kernel.org
Cc: Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	WANG Xuerui <kernel@xen0n.name>,
	Xianglai li <lixianglai@loongson.cn>
Subject: [[PATCH V2 00/10] Added Interrupt controller emulation for loongarch kvm
Date: Fri, 23 Aug 2024 17:33:54 +0800
Message-Id: <20240823093404.204450-1-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCxC2ekW8hm2SsfAA--.39816S2
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Before this, the interrupt controller simulation has been completed
in the user mode program. In order to reduce the loss caused by frequent
switching of the virtual machine monitor from kernel mode to user mode
when the guest accesses the interrupt controller, we add the interrupt
controller simulation in kvm.

The following is a virtual machine simulation diagram of interrupted
connections:
  +-----+    +---------+     +-------+
  | IPI |--> | CPUINTC | <-- | Timer |
  +-----+    +---------+     +-------+
                 ^
                 |
           +---------+
           | EIOINTC |
           +---------+
            ^       ^
            |       |
     +---------+ +---------+
     | PCH-PIC | | PCH-MSI |
     +---------+ +---------+
       ^      ^          ^
       |      |          |
+--------+ +---------+ +---------+
| UARTs  | | Devices | | Devices |
+--------+ +---------+ +---------+

In this series of patches, we mainly realized the simulation of
IPI EXTIOI PCH-PIC interrupt controller.

The simulation of IPI EXTIOI PCH-PIC interrupt controller mainly
completes the creation simulation of the interrupt controller,
the register address space read and write simulation,
and the interface with user mode to obtain and set the interrupt
controller state for the preservation,
recovery and migration of virtual machines.

IPI simulation implementation reference:
https://github.com/loongson/LoongArch-Documentation/tree/main/docs/Loongson-3A5000-usermanual-EN/inter-processor-interrupts-and-communication

EXTIOI simulation implementation reference:
https://github.com/loongson/LoongArch-Documentation/tree/main/docs/Loongson-3A5000-usermanual-EN/io-interrupts/extended-io-interrupts

PCH-PIC simulation implementation reference:
https://github.com/loongson/LoongArch-Documentation/blob/main/docs/Loongson-7A1000-usermanual-EN/interrupt-controller.adoc

For PCH-MSI, we used irqfd mechanism to send the interrupt signal
generated by user state to kernel state and then to EXTIOI without
maintaining PCH-MSI state in kernel state.

You can easily get the code from the link below:
the kernel:
https://github.com/lixianglai/linux
the branch is: interrupt

the qemu:
https://github.com/lixianglai/qemu
the branch is: interrupt

Please note that the code above is regularly updated based on community
reviews.

change log:
V1->V2:
1.Remove redundant blank lines according to community comments
2.Remove simplified redundant code
3.Adds 16 bits of read/write interface to the extioi iocsr address space
4.Optimize user - and kernel-mode data access interfaces: Access
fixed length data each time to prevent memory overruns
5.Added virtual extioi, where interrupts can be routed to cpus other than cpu 4

Cc: Bibo Mao <maobibo@loongson.cn> 
Cc: Huacai Chen <chenhuacai@kernel.org> 
Cc: kvm@vger.kernel.org 
Cc: loongarch@lists.linux.dev 
Cc: Paolo Bonzini <pbonzini@redhat.com> 
Cc: Tianrui Zhao <zhaotianrui@loongson.cn> 
Cc: WANG Xuerui <kernel@xen0n.name> 
Cc: Xianglai li <lixianglai@loongson.cn> 

Xianglai Li (10):
  LoongArch: KVM: Add iocsr and mmio bus simulation in kernel
  LoongArch: KVM: Add IPI device support
  LoongArch: KVM: Add IPI read and write function
  LoongArch: KVM: Add IPI user mode read and write function
  LoongArch: KVM: Add EXTIOI device support
  LoongArch: KVM: Add EXTIOI read and write functions
  LoongArch: KVM: Add PCHPIC device support
  LoongArch: KVM: Add PCHPIC read and write functions
  LoongArch: KVM: Add PCHPIC user mode read and write functions
  LoongArch: KVM: Add irqfd support

 arch/loongarch/include/asm/kvm_extioi.h  |  122 +++
 arch/loongarch/include/asm/kvm_host.h    |   30 +
 arch/loongarch/include/asm/kvm_ipi.h     |   52 ++
 arch/loongarch/include/asm/kvm_pch_pic.h |   61 ++
 arch/loongarch/include/uapi/asm/kvm.h    |   19 +
 arch/loongarch/kvm/Kconfig               |    3 +
 arch/loongarch/kvm/Makefile              |    4 +
 arch/loongarch/kvm/exit.c                |   86 +-
 arch/loongarch/kvm/intc/extioi.c         | 1056 ++++++++++++++++++++++
 arch/loongarch/kvm/intc/ipi.c            |  510 +++++++++++
 arch/loongarch/kvm/intc/pch_pic.c        |  521 +++++++++++
 arch/loongarch/kvm/irqfd.c               |   87 ++
 arch/loongarch/kvm/main.c                |   18 +-
 arch/loongarch/kvm/vcpu.c                |    3 +
 arch/loongarch/kvm/vm.c                  |   53 +-
 include/linux/kvm_host.h                 |    1 +
 include/trace/events/kvm.h               |   35 +
 include/uapi/linux/kvm.h                 |    8 +
 18 files changed, 2641 insertions(+), 28 deletions(-)
 create mode 100644 arch/loongarch/include/asm/kvm_extioi.h
 create mode 100644 arch/loongarch/include/asm/kvm_ipi.h
 create mode 100644 arch/loongarch/include/asm/kvm_pch_pic.h
 create mode 100644 arch/loongarch/kvm/intc/extioi.c
 create mode 100644 arch/loongarch/kvm/intc/ipi.c
 create mode 100644 arch/loongarch/kvm/intc/pch_pic.c
 create mode 100644 arch/loongarch/kvm/irqfd.c


base-commit: 872cf28b8df9c5c3a1e71a88ee750df7c2513971
-- 
2.39.1


