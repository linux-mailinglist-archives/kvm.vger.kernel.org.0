Return-Path: <kvm+bounces-26241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 92AA897368F
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 13:59:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3DE291F25B93
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 11:59:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E83318FDDC;
	Tue, 10 Sep 2024 11:58:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACF8618DF9E;
	Tue, 10 Sep 2024 11:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725969537; cv=none; b=DRb9bjuc2aQsZpqKvtmU9LEkcxTZtT8M55z8cBhQI6Iy+KHt5prGfreZG+WOXc8KhwhoXaQGI0j5ubwGDj+dfHVAsmex34gCPEknP0R7JQ6LDvmBdW+FL0Rwb/2ErmbcqvedrhH2+FASWnIBfTXu5WKv4/UjHcaAWqloeo2grdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725969537; c=relaxed/simple;
	bh=MVGA51egBnHRQ28a/BV+aqFmJLRJM1TC1uppm6jiYuI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PQ0xue2i22P6nvSTyh7YzPRrz1C5soiZq/NIuj0lC3i+WIFz82uv/+wHfEbFJHqemTuKlLl6tBxAsX0NOpkEITsKby8yTlixqPun55tiBoBweyZ8qaiUJCUws0XDlg7UZ5i4wjiR/Tknn0AViWKob9OcZ4fEDa+w+mfl7+iR15Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8Axbep2NOBm360DAA--.8734S3;
	Tue, 10 Sep 2024 19:58:46 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front2 (Coremail) with SMTP id qciowMCxSsZwNOBm+GEDAA--.16096S2;
	Tue, 10 Sep 2024 19:58:42 +0800 (CST)
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
Subject: [PATCH V3 00/11] Added Interrupt controller emulation for loongarch kvm
Date: Tue, 10 Sep 2024 19:40:54 +0800
Message-Id: <20240910114105.4062286-1-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qciowMCxSsZwNOBm+GEDAA--.16096S2
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
IPI EIOINTC PCH-PIC interrupt controller.

The simulation of IPI EIOINTC PCH-PIC interrupt controller mainly
completes the creation simulation of the interrupt controller,
the register address space read and write simulation,
and the interface with user mode to obtain and set the interrupt
controller state for the preservation,
recovery and migration of virtual machines.

IPI simulation implementation reference:
https://github.com/loongson/LoongArch-Documentation/tree/main/docs/Loongson-3A5000-usermanual-EN/inter-processor-interrupts-and-communication

EIOINTC simulation implementation reference:
https://github.com/loongson/LoongArch-Documentation/tree/main/docs/Loongson-3A5000-usermanual-EN/io-interrupts/extended-io-interrupts

PCH-PIC simulation implementation reference:
https://github.com/loongson/LoongArch-Documentation/blob/main/docs/Loongson-7A1000-usermanual-EN/interrupt-controller.adoc

For PCH-MSI, we used irqfd mechanism to send the interrupt signal
generated by user state to kernel state and then to EIOINTC without
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
V2->V3:
1.Modify the macro definition name:
KVM_DEV_TYPE_LA_* ->  KVM_DEV_TYPE_LOONGARCH_*
2.Change the short name for "Extended I/O Interrupt Controller" from EXTIOI to EIOINTC
Rename file extioi.c to eiointc.c
Rename file extioi.h to eiointc.h

V1->V2:
1.Remove redundant blank lines according to community comments
2.Remove simplified redundant code
3.Adds 16 bits of read/write interface to the eiointc iocsr address space
4.Optimize user - and kernel-mode data access interfaces: Access
fixed length data each time to prevent memory overruns
5.Added virtual eiointc, where interrupts can be routed to cpus other than cpu 4

Cc: Bibo Mao <maobibo@loongson.cn> 
Cc: Huacai Chen <chenhuacai@kernel.org> 
Cc: kvm@vger.kernel.org 
Cc: loongarch@lists.linux.dev 
Cc: Paolo Bonzini <pbonzini@redhat.com> 
Cc: Tianrui Zhao <zhaotianrui@loongson.cn> 
Cc: WANG Xuerui <kernel@xen0n.name> 
Cc: Xianglai li <lixianglai@loongson.cn> 

Xianglai Li (11):
  LoongArch: KVM: Add iocsr and mmio bus simulation in kernel
  LoongArch: KVM: Add IPI device support
  LoongArch: KVM: Add IPI read and write function
  LoongArch: KVM: Add IPI user mode read and write function
  LoongArch: KVM: Add EIOINTC device support
  LoongArch: KVM: Add EIOINTC read and write functions
  LoongArch: KVM: Add EIOINTC user mode read and write functions
  LoongArch: KVM: Add PCHPIC device support
  LoongArch: KVM: Add PCHPIC read and write functions
  LoongArch: KVM: Add PCHPIC user mode read and write functions
  LoongArch: KVM: Add irqfd support

 arch/loongarch/include/asm/kvm_eiointc.h |  122 +++
 arch/loongarch/include/asm/kvm_host.h    |   32 +-
 arch/loongarch/include/asm/kvm_ipi.h     |   52 ++
 arch/loongarch/include/asm/kvm_pch_pic.h |   61 ++
 arch/loongarch/include/uapi/asm/kvm.h    |   19 +
 arch/loongarch/kvm/Kconfig               |    3 +
 arch/loongarch/kvm/Makefile              |    4 +
 arch/loongarch/kvm/exit.c                |   86 +-
 arch/loongarch/kvm/intc/eiointc.c        | 1056 ++++++++++++++++++++++
 arch/loongarch/kvm/intc/ipi.c            |  510 +++++++++++
 arch/loongarch/kvm/intc/pch_pic.c        |  521 +++++++++++
 arch/loongarch/kvm/irqfd.c               |   87 ++
 arch/loongarch/kvm/main.c                |   18 +-
 arch/loongarch/kvm/vcpu.c                |    3 +
 arch/loongarch/kvm/vm.c                  |   53 +-
 include/linux/kvm_host.h                 |    1 +
 include/trace/events/kvm.h               |   35 +
 include/uapi/linux/kvm.h                 |    8 +
 18 files changed, 2642 insertions(+), 29 deletions(-)
 create mode 100644 arch/loongarch/include/asm/kvm_eiointc.h
 create mode 100644 arch/loongarch/include/asm/kvm_ipi.h
 create mode 100644 arch/loongarch/include/asm/kvm_pch_pic.h
 create mode 100644 arch/loongarch/kvm/intc/eiointc.c
 create mode 100644 arch/loongarch/kvm/intc/ipi.c
 create mode 100644 arch/loongarch/kvm/intc/pch_pic.c
 create mode 100644 arch/loongarch/kvm/irqfd.c


base-commit: bc83b4d1f08695e85e85d36f7b803da58010161d
-- 
2.39.1


