Return-Path: <kvm+bounces-31395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4942A9C36B5
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 03:56:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE15C1F21FC4
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 02:56:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F34813AD20;
	Mon, 11 Nov 2024 02:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bBvKOBmS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E90D224D4;
	Mon, 11 Nov 2024 02:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731293751; cv=none; b=XLFdUIsWEeq2VUEK8l3Kb+Ai6JUEw7U3rz4jXwy6Wur5jfQkbAuNB/4pjAXRvTsTllbX+nNQQQCD6HX4Gq1D5UOY4ekFBwVd58AWR43OLOMGOYfMkcNY3aNGQAk6tnDZbsD2Zbvku8CxOFqKEZrx+4ZEGmXoijVMvENmPyWIrJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731293751; c=relaxed/simple;
	bh=HScUf/0mJI0h2P0D1CtSIPUJdAuxe+P+7zYDm1Fxna8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HLUVrMr2HfNDvrCod1mC+2Dt7o70rfRUnJdicLc3f+9YDl8cXXg2PHR714YINo/hET8HL4cyHeRasO2vZRcTR3ol6R6vAWN7d8X9KaB+Ck+B1m7ctOjUsBwTUp95f1nKYSwPxFFqxKkGDFabgvTXojd7gDhY/oMYQSsGukH9dd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bBvKOBmS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FE5C4CECD;
	Mon, 11 Nov 2024 02:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731293750;
	bh=HScUf/0mJI0h2P0D1CtSIPUJdAuxe+P+7zYDm1Fxna8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=bBvKOBmS2SEx2ss/TPyZHvX2/b9bEfNE1orxM5YqSvJBWTjMTk2biN/hmJDZoniiq
	 JyrOsRMlAZd/KyDuPCDxLjwZrUZgcWxkfs2EBK8Lp9EQyhhrSM/H/ZtDKBMLK+Ag55
	 YeZS07o01iXHyZfqkcLqQvNv/tUZo6G6mdQavmWxgNUr1orWWkMXEDjhVWMYIekf1k
	 41pwM+Ldqlf//Dn9T7EHnA7WTwSp/elcY4+O10SzPl0LJU7yTukoewPvwwP610dKGZ
	 CzPjLHrb28nt4nw7FMjzvtSV8ju17S2pZLCSosGspyIuZxUF2TIJ0jsJVDKkqban/+
	 CpjgIDnUYPTPw==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5c9634c9160so4965083a12.2;
        Sun, 10 Nov 2024 18:55:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX9zsQ+Yba/rj3knO0j7jRuR1vfI/EIosmKx6K7beXk4VIJ5stB0N4C1mDprcrFR7CER8M=@vger.kernel.org
X-Gm-Message-State: AOJu0YytEgG6wvbmq9CWMitGtxWh1FRDohJrnM78f6FrWYeSAUObdXkX
	7GOVoowOuAJEo1dDrfCOXBoLhLpZwR+TrerP2pjs7bZgGrdDHRxmWvmjZMsWM4D0zDwBliwUQ6z
	Kq1E4AqP3wmzKkNi9N+I6k6LkpLM=
X-Google-Smtp-Source: AGHT+IE9ZVU6MUnQyJE3IEZDEKcc4yDVpoQPgjNAf/AzyzceYa7gsBsvYyyHQWmatNCKqPWzX8N5Di7puhbpLxstkDE=
X-Received: by 2002:a17:907:9603:b0:a99:ed0c:1d6 with SMTP id
 a640c23a62f3a-a9ef000750cmr1066361766b.49.1731293749308; Sun, 10 Nov 2024
 18:55:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241108033437.2727574-1-lixianglai@loongson.cn>
In-Reply-To: <20241108033437.2727574-1-lixianglai@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 11 Nov 2024 10:55:37 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7Tmi8LSn6kDsMj8HkhcUb9zY1EOx2-KnpeTriickbaKQ@mail.gmail.com>
Message-ID: <CAAhV-H7Tmi8LSn6kDsMj8HkhcUb9zY1EOx2-KnpeTriickbaKQ@mail.gmail.com>
Subject: Re: [PATCH V4 00/11] Added Interrupt controller emulation for
 loongarch kvm
To: Xianglai Li <lixianglai@loongson.cn>
Cc: linux-kernel@vger.kernel.org, Bibo Mao <maobibo@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Xianglai,

I have applied this series with some build fixes and style fixes at:
https://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.g=
it/log/?h=3Dloongarch-kvm

Please confirm whether it works as expected, thanks.


Huacai

On Fri, Nov 8, 2024 at 11:53=E2=80=AFAM Xianglai Li <lixianglai@loongson.cn=
> wrote:
>
> Before this, the interrupt controller simulation has been completed
> in the user mode program. In order to reduce the loss caused by frequent
> switching of the virtual machine monitor from kernel mode to user mode
> when the guest accesses the interrupt controller, we add the interrupt
> controller simulation in kvm.
>
> The following is a virtual machine simulation diagram of interrupted
> connections:
>   +-----+    +---------+     +-------+
>   | IPI |--> | CPUINTC | <-- | Timer |
>   +-----+    +---------+     +-------+
>                  ^
>                  |
>            +---------+
>            | EIOINTC |
>            +---------+
>             ^       ^
>             |       |
>      +---------+ +---------+
>      | PCH-PIC | | PCH-MSI |
>      +---------+ +---------+
>        ^      ^          ^
>        |      |          |
> +--------+ +---------+ +---------+
> | UARTs  | | Devices | | Devices |
> +--------+ +---------+ +---------+
>
> In this series of patches, we mainly realized the simulation of
> IPI EIOINTC PCH-PIC interrupt controller.
>
> The simulation of IPI EIOINTC PCH-PIC interrupt controller mainly
> completes the creation simulation of the interrupt controller,
> the register address space read and write simulation,
> and the interface with user mode to obtain and set the interrupt
> controller state for the preservation,
> recovery and migration of virtual machines.
>
> IPI simulation implementation reference:
> https://github.com/loongson/LoongArch-Documentation/tree/main/docs/Loongs=
on-3A5000-usermanual-EN/inter-processor-interrupts-and-communication
>
> EIOINTC simulation implementation reference:
> https://github.com/loongson/LoongArch-Documentation/tree/main/docs/Loongs=
on-3A5000-usermanual-EN/io-interrupts/extended-io-interrupts
>
> PCH-PIC simulation implementation reference:
> https://github.com/loongson/LoongArch-Documentation/blob/main/docs/Loongs=
on-7A1000-usermanual-EN/interrupt-controller.adoc
>
> For PCH-MSI, we used irqfd mechanism to send the interrupt signal
> generated by user state to kernel state and then to EIOINTC without
> maintaining PCH-MSI state in kernel state.
>
> You can easily get the code from the link below:
> the kernel:
> https://github.com/lixianglai/linux
> the branch is: interrupt-v4
>
> the qemu:
> https://github.com/lixianglai/qemu
> the branch is: interrupt-v3
>
> Please note that the code above is regularly updated based on community
> reviews.
>
> change log:
> V3->V4:
> 1.Fix some macro definition names and some formatting errors
> 2.Combine the IPI two device address Spaces into one address device space
> 3.Optimize the function kvm_vm_ioctl_irq_line implementation, directly ca=
ll the public function kvm_set_irq for interrupt distribution
> 4.Optimize the description of the commit log
> 5.Deleting an interface trace_kvm_iocsr
>
> V2->V3:
> 1.Modify the macro definition name:
> KVM_DEV_TYPE_LA_* ->  KVM_DEV_TYPE_LOONGARCH_*
> 2.Change the short name for "Extended I/O Interrupt Controller" from EXTI=
OI to EIOINTC
> Rename file extioi.c to eiointc.c
> Rename file extioi.h to eiointc.h
>
> V1->V2:
> 1.Remove redundant blank lines according to community comments
> 2.Remove simplified redundant code
> 3.Adds 16 bits of read/write interface to the eiointc iocsr address space
> 4.Optimize user - and kernel-mode data access interfaces: Access
> fixed length data each time to prevent memory overruns
> 5.Added virtual eiointc, where interrupts can be routed to cpus other tha=
n cpu 4
>
> Cc: Bibo Mao <maobibo@loongson.cn>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: kvm@vger.kernel.org
> Cc: loongarch@lists.linux.dev
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: Xianglai li <lixianglai@loongson.cn>
>
> Xianglai Li (11):
>   LoongArch: KVM: Add iocsr and mmio bus simulation in kernel
>   LoongArch: KVM: Add IPI device support
>   LoongArch: KVM: Add IPI read and write function
>   LoongArch: KVM: Add IPI user mode read and write function
>   LoongArch: KVM: Add EIOINTC device support
>   LoongArch: KVM: Add EIOINTC read and write functions
>   LoongArch: KVM: Add EIOINTC user mode read and write functions
>   LoongArch: KVM: Add PCHPIC device support
>   LoongArch: KVM: Add PCHPIC read and write functions
>   LoongArch: KVM: Add PCHPIC user mode read and write functions
>   LoongArch: KVM: Add irqfd support
>
>  arch/loongarch/include/asm/kvm_eiointc.h |  122 +++
>  arch/loongarch/include/asm/kvm_host.h    |   18 +-
>  arch/loongarch/include/asm/kvm_ipi.h     |   46 +
>  arch/loongarch/include/asm/kvm_pch_pic.h |   61 ++
>  arch/loongarch/include/uapi/asm/kvm.h    |   19 +
>  arch/loongarch/kvm/Kconfig               |    5 +-
>  arch/loongarch/kvm/Makefile              |    4 +
>  arch/loongarch/kvm/exit.c                |   80 +-
>  arch/loongarch/kvm/intc/eiointc.c        | 1055 ++++++++++++++++++++++
>  arch/loongarch/kvm/intc/ipi.c            |  468 ++++++++++
>  arch/loongarch/kvm/intc/pch_pic.c        |  523 +++++++++++
>  arch/loongarch/kvm/irqfd.c               |   97 ++
>  arch/loongarch/kvm/main.c                |   19 +-
>  arch/loongarch/kvm/vcpu.c                |    3 +
>  arch/loongarch/kvm/vm.c                  |   22 +
>  include/linux/kvm_host.h                 |    1 +
>  include/uapi/linux/kvm.h                 |    8 +
>  17 files changed, 2522 insertions(+), 29 deletions(-)
>  create mode 100644 arch/loongarch/include/asm/kvm_eiointc.h
>  create mode 100644 arch/loongarch/include/asm/kvm_ipi.h
>  create mode 100644 arch/loongarch/include/asm/kvm_pch_pic.h
>  create mode 100644 arch/loongarch/kvm/intc/eiointc.c
>  create mode 100644 arch/loongarch/kvm/intc/ipi.c
>  create mode 100644 arch/loongarch/kvm/intc/pch_pic.c
>  create mode 100644 arch/loongarch/kvm/irqfd.c
>
>
> base-commit: 906bd684e4b1e517dd424a354744c5b0aebef8af
> --
> 2.39.1
>

