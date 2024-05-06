Return-Path: <kvm+bounces-16600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C9148BC589
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 03:45:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F33928227F
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 01:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2699C3D966;
	Mon,  6 May 2024 01:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tg/TaYks"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A7B1E4A8;
	Mon,  6 May 2024 01:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714959921; cv=none; b=T5tmUu9NNR6rONjx7LpunXq+fWLxq6qyVcfYHTKncQ5oepneDdA/omMh1GtU0B0t3lMD44eL7zQpjjmBExHRL+YM2UH9D3gpUmQyDb893gjcVWLz3HAm3aEgi8y/KQ2Oade4N1UwnNucydgvutGHsxu5RAeK7isGKJa7Q7TgpE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714959921; c=relaxed/simple;
	bh=CpeTkL00XI5p8XOXv0IJrxVoS2FK/cvm+CcUs8j3DwY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ajDhGRuIgviaiwJYwKeSA9cKWeMcpVIjlEHFrJZWmr+/5vgVoLMmI6rwvQmRQsJcikBut1VxFZWgCTz5kD8lGQ7CAxd0GAK3KvI0PRN/Eoge6X/sQ0uQz9ZacPpW54Nc6K6gtxXwUPN5fno4wafLqGs0VmEkzsl7SfCKjnLGkmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tg/TaYks; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB80FC116B1;
	Mon,  6 May 2024 01:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714959920;
	bh=CpeTkL00XI5p8XOXv0IJrxVoS2FK/cvm+CcUs8j3DwY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tg/TaYkszAjtYXC8JAyxTHDcez48kwp0UwJmHXcoKp7v7aFx9mEFjymBjdqwWLIMm
	 lsxUtJkx9D1rdWXst909Ksv0gYIDmBIO1lKJ4LkcmMQ3nNAGOVEG1Froo/UwF4cRq+
	 FoE64WOVbHVG21P/BNhFp+vC2lR8hvV+0M8cdkr8akD7NgOeJTzaW3u3uF7qWgrbCa
	 wRKUzKss3g6bQrVyMOKbE3TSwkm2pcoNHZLphADI+HzQHvJ+43rp+pE+gItSYDAcMu
	 37q4QMFjLUoJzo9PnamOEu0OxQHb8I57yvUvxbp6txwl+807Yot8tnU+CjqdE2aJ3Q
	 onYUM579g/2dA==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a59ad344f7dso217212066b.0;
        Sun, 05 May 2024 18:45:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUDlfXVNTxcd/Fmk332zxVjvQfu/dRuBrkR0KXlHS3a3FzwUATwRqmygrheFpKD7kUcLr4ZQbTXv6+/acl98+exATx0dgh4f/ePVgqBUFWO9/xHv+heslTOlQ7hG97OIuG6
X-Gm-Message-State: AOJu0YxbAXgH86vjjjYHvolhRNvrbkTX57hc4Eo50ibQWK4fIVHDexiS
	CU0+C0HNXaZqNo4Q7geU2/a3GismHZ779FibTwLblBh/eVw0x3HWzDQHFCmS+UCLAHHdm0nuZne
	1Ub0e86Nn+fNB1R98LgJ1QzALtxA=
X-Google-Smtp-Source: AGHT+IEHL/Rd2Ivrj03R56osKN5biZdcJ05JD1oXZPm7WgO/Z3n+UAmeiWepgvHWc4P8S3s6KrRNFDemhWa8vwiLbLc=
X-Received: by 2002:a17:906:3bd5:b0:a59:afdd:590f with SMTP id
 v21-20020a1709063bd500b00a59afdd590fmr2638734ejf.58.1714959919437; Sun, 05
 May 2024 18:45:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240428100518.1642324-1-maobibo@loongson.cn>
In-Reply-To: <20240428100518.1642324-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 6 May 2024 09:45:10 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6c2Wym4w5WchP=K1fHv8uVFDp59CATYKcH3mGYDxnKmA@mail.gmail.com>
Message-ID: <CAAhV-H6c2Wym4w5WchP=K1fHv8uVFDp59CATYKcH3mGYDxnKmA@mail.gmail.com>
Subject: Re: [PATCH v8 0/6] LoongArch: Add pv ipi support on LoongArch VM
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

I have done an off-list discussion with some KVM experts, and they
think user-space have its right to know PV features, so cpucfg
solution is acceptable.

And I applied this series with some modifications at
https://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.g=
it/log/?h=3Dloongarch-kvm
You can test it now. But it seems the upstream qemu cannot enable PV IPI no=
w.

I will reply to other patches about my modifications.

Huacai

On Sun, Apr 28, 2024 at 6:05=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> On physical machine, ipi HW uses IOCSR registers, however there is trap
> into hypervisor when vcpu accesses IOCSR registers if system is in VM
> mode. SWI is a interrupt mechanism like SGI on ARM, software can send
> interrupt to CPU, only that on LoongArch SWI can only be sent to local CP=
U
> now. So SWI can not used for IPI on real HW system, however it can be use=
d
> on VM when combined with hypercall method. IPI can be sent with hypercall
> method and SWI interrupt is injected to vcpu, vcpu can treat SWI
> interrupt as IPI.
>
> With PV IPI supported, there is one trap with IPI sending, however with I=
PI
> receiving there is no trap. with IOCSR HW ipi method, there will be one
> trap with IPI sending and two trap with ipi receiving.
>
> Also IPI multicast support is added for VM, the idea comes from x86 PV ip=
i.
> IPI can be sent to 128 vcpus in one time. With IPI multicast support, tra=
p
> will be reduced greatly.
>
> Here is the microbenchmarck data with "perf bench futex wake" testcase on
> 3C5000 single-way machine, there are 16 cpus on 3C5000 single-way machine=
,
> VM has 16 vcpus also. The benchmark data is ms time unit to wakeup 16
> threads, the performance is better if data is smaller.
>
> physical machine                     0.0176 ms
> VM original                          0.1140 ms
> VM with pv ipi patch                 0.0481 ms
>
> It passes to boot with 128/256 vcpus, and passes to run runltp command
> with package ltp-20230516.
>
> ---
> v7 --- v8:
>  1. Remove kernel PLV mode checking with cpucfg emulation for hypervisor
> feature inquiry.
>  2. Remove document about loongarch hypercall ABI per request of huacai,
> will add English/Chinese doc at the same time in later.
>
> v6 --- v7:
>   1. Refine LoongArch virt document by review comments.
>   2. Add function kvm_read_reg()/kvm_write_reg() in hypercall emulation,
> and later it can be used for other trap emulations.
>
> v5 --- v6:
>   1. Add privilege checking when emulating cpucfg at index 0x4000000 --
> 0x400000FF, return 0 if not executed at kernel mode.
>   2. Add document about LoongArch pv ipi with new creatly directory
> Documentation/virt/kvm/loongarch/
>   3. Fix pv ipi handling in kvm backend function kvm_pv_send_ipi(),
> where min should plus BITS_PER_LONG with second bitmap, otherwise
> VM with more than 64 vpus fails to boot.
>   4. Adjust patch order and code refine with review comments.
>
> v4 --- v5:
>   1. Refresh function/macro name from review comments.
>
> v3 --- v4:
>   1. Modfiy pv ipi hook function name call_func_ipi() and
> call_func_single_ipi() with send_ipi_mask()/send_ipi_single(), since pv
> ipi is used for both remote function call and reschedule notification.
>   2. Refresh changelog.
>
> v2 --- v3:
>   1. Add 128 vcpu ipi multicast support like x86
>   2. Change cpucfg base address from 0x10000000 to 0x40000000, in order
> to avoid confliction with future hw usage
>   3. Adjust patch order in this patchset, move patch
> Refine-ipi-ops-on-LoongArch-platform to the first one.
>
> v1 --- v2:
>   1. Add hw cpuid map support since ipi routing uses hw cpuid
>   2. Refine changelog description
>   3. Add hypercall statistic support for vcpu
>   4. Set percpu pv ipi message buffer aligned with cacheline
>   5. Refine pv ipi send logic, do not send ipi message with if there is
> pending ipi message.
> ---
> Bibo Mao (6):
>   LoongArch/smp: Refine some ipi functions on LoongArch platform
>   LoongArch: KVM: Add hypercall instruction emulation support
>   LoongArch: KVM: Add cpucfg area for kvm hypervisor
>   LoongArch: KVM: Add vcpu search support from physical cpuid
>   LoongArch: KVM: Add pv ipi support on kvm side
>   LoongArch: Add pv ipi support on guest kernel side
>
>  arch/loongarch/Kconfig                        |   9 +
>  arch/loongarch/include/asm/Kbuild             |   1 -
>  arch/loongarch/include/asm/hardirq.h          |   5 +
>  arch/loongarch/include/asm/inst.h             |   1 +
>  arch/loongarch/include/asm/irq.h              |  10 +-
>  arch/loongarch/include/asm/kvm_host.h         |  27 +++
>  arch/loongarch/include/asm/kvm_para.h         | 155 ++++++++++++++++++
>  arch/loongarch/include/asm/kvm_vcpu.h         |  11 ++
>  arch/loongarch/include/asm/loongarch.h        |  11 ++
>  arch/loongarch/include/asm/paravirt.h         |  27 +++
>  .../include/asm/paravirt_api_clock.h          |   1 +
>  arch/loongarch/include/asm/smp.h              |  31 ++--
>  arch/loongarch/include/uapi/asm/Kbuild        |   2 -
>  arch/loongarch/kernel/Makefile                |   1 +
>  arch/loongarch/kernel/irq.c                   |  24 +--
>  arch/loongarch/kernel/paravirt.c              | 151 +++++++++++++++++
>  arch/loongarch/kernel/perf_event.c            |  14 +-
>  arch/loongarch/kernel/smp.c                   |  62 ++++---
>  arch/loongarch/kernel/time.c                  |  12 +-
>  arch/loongarch/kvm/exit.c                     | 132 +++++++++++++--
>  arch/loongarch/kvm/vcpu.c                     |  94 ++++++++++-
>  arch/loongarch/kvm/vm.c                       |  11 ++
>  22 files changed, 690 insertions(+), 102 deletions(-)
>  create mode 100644 arch/loongarch/include/asm/kvm_para.h
>  create mode 100644 arch/loongarch/include/asm/paravirt.h
>  create mode 100644 arch/loongarch/include/asm/paravirt_api_clock.h
>  delete mode 100644 arch/loongarch/include/uapi/asm/Kbuild
>  create mode 100644 arch/loongarch/kernel/paravirt.c
>
>
> base-commit: 5eb4573ea63d0c83bf58fb7c243fc2c2b6966c02
> --
> 2.39.3
>
>

