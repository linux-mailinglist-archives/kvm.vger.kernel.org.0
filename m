Return-Path: <kvm+bounces-21017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4378F9280A3
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 04:56:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA5CE1F219B9
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:56:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 766552B9B9;
	Fri,  5 Jul 2024 02:56:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 102CC15ACB;
	Fri,  5 Jul 2024 02:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720148182; cv=none; b=Ny07OoA/jT5TeAfxsMb4Lu5gaSeh/z5YW/Y7nIakHjAJ83IQAJ7VJ4pROouYzwdSq6tFFOnnVu67+JnIK6SLlHbJzmludY3+A34LhHdar2EnjADRnQ/OoliZ3FwXATr1AF17GHCv3F9lDITxbhbjjER9oIAqW5J1ib2vjzmV2f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720148182; c=relaxed/simple;
	bh=FErVnGZBnVPe3rBGh6Uj6uA/qd22/RzO7aFkY19Fc4w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ciBBOXdcFJpml7B5JM1ADXgkDmGb91r/giBw+xT/0zyf0YVbgQ82XoTMQS27YeWsJlEJ6JYmC4dJGIqtxZIytk6IlvtLCFJPJ54+dm1YBNji+YLe8x3v1qpRrk8tuWYUlElVTiip+x/xR+JSPeui7a96IOAU6P5lNkG1WUQffpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8DxzfDSYIdm2iQBAA--.3870S3;
	Fri, 05 Jul 2024 10:56:18 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxWcbRYIdm3tE7AA--.7292S2;
	Fri, 05 Jul 2024 10:56:17 +0800 (CST)
From: Xianglai Li <lixianglai@loongson.cn>
To: linux-kernel@vger.kernel.org
Cc: Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	Min Zhou <zhoumin@loongson.cn>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	WANG Xuerui <kernel@xen0n.name>,
	Xianglai li <lixianglai@loongson.cn>
Subject: [PATCH 00/11] Added Interrupt controller emulation for loongarch kvm
Date: Fri,  5 Jul 2024 10:38:43 +0800
Message-Id: <20240705023854.1005258-1-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxWcbRYIdm3tE7AA--.7292S2
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

Cc: Bibo Mao <maobibo@loongson.cn> 
Cc: Huacai Chen <chenhuacai@kernel.org> 
Cc: kvm@vger.kernel.org 
Cc: loongarch@lists.linux.dev 
Cc: Min Zhou <zhoumin@loongson.cn> 
Cc: Paolo Bonzini <pbonzini@redhat.com> 
Cc: Tianrui Zhao <zhaotianrui@loongson.cn> 
Cc: WANG Xuerui <kernel@xen0n.name> 
Cc: Xianglai li <lixianglai@loongson.cn> 

Xianglai Li (11):
  LoongArch: KVM: Add iocsr and mmio bus simulation in kernel
  LoongArch: KVM: Add IPI device support
  LoongArch: KVM: Add IPI read and write function
  LoongArch: KVM: Add IPI user mode read and write function
  LoongArch: KVM: Add EXTIOI device support
  LoongArch: KVM: Add EXTIOI read and write functions
  LoongArch: KVM: Add EXTIOI user mode read and write functions
  LoongArch: KVM: Add PCHPIC device support
  LoongArch: KVM: Add PCHPIC read and write functions
  LoongArch: KVM: Add PCHPIC user mode read and write functions
  LoongArch: KVM: Add irqfd support

 arch/loongarch/include/asm/kvm_extioi.h  |  95 +++
 arch/loongarch/include/asm/kvm_host.h    |  30 +
 arch/loongarch/include/asm/kvm_ipi.h     |  52 ++
 arch/loongarch/include/asm/kvm_pch_pic.h |  61 ++
 arch/loongarch/include/uapi/asm/kvm.h    |   9 +
 arch/loongarch/kvm/Kconfig               |   3 +
 arch/loongarch/kvm/Makefile              |   4 +
 arch/loongarch/kvm/exit.c                |  69 +-
 arch/loongarch/kvm/intc/extioi.c         | 783 +++++++++++++++++++++++
 arch/loongarch/kvm/intc/ipi.c            | 539 ++++++++++++++++
 arch/loongarch/kvm/intc/pch_pic.c        | 538 ++++++++++++++++
 arch/loongarch/kvm/irqfd.c               |  87 +++
 arch/loongarch/kvm/main.c                |  19 +-
 arch/loongarch/kvm/vcpu.c                |   3 +
 arch/loongarch/kvm/vm.c                  |  53 +-
 include/linux/kvm_host.h                 |   1 +
 include/uapi/linux/kvm.h                 |   8 +
 17 files changed, 2332 insertions(+), 22 deletions(-)
 create mode 100644 arch/loongarch/include/asm/kvm_extioi.h
 create mode 100644 arch/loongarch/include/asm/kvm_ipi.h
 create mode 100644 arch/loongarch/include/asm/kvm_pch_pic.h
 create mode 100644 arch/loongarch/kvm/intc/extioi.c
 create mode 100644 arch/loongarch/kvm/intc/ipi.c
 create mode 100644 arch/loongarch/kvm/intc/pch_pic.c
 create mode 100644 arch/loongarch/kvm/irqfd.c


base-commit: afcd48134c58d6af45fb3fdb648f1260b20f2326
-- 
2.39.1


