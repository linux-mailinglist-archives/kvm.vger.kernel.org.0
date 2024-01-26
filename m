Return-Path: <kvm+bounces-7184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 365BD83DF7D
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 18:09:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80CBE1F223AD
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 17:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3EDE1EA7D;
	Fri, 26 Jan 2024 17:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HAgEIMGH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2D01DDEC
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 17:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706288975; cv=none; b=mmxMwkdAAESVBlXgbcTRiD3oCJ1N73/ucHg1R+g+ohbjTiqtnuaj+R+f1fbZB0MpomT6ZZAG48J/8R5d5W+LTUPmSr5ScRjr9545TG0mMSD3IvwJyepsRAW9AXkonQaoNbyDSPlKChhXhJBI/zFPHRPHhT7xJItMLrS6nNvN2aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706288975; c=relaxed/simple;
	bh=1Itxm1FlK+7eTWBtRV8lcts+Jbjl9/9Cqttu314keig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e40HFqwPdSVgewXq4/WqwEhJCReI9GeR+4lyyLeYI31qsX9x9KA6VsYxd2DV2s9URReDiHlk0NiXPfqTVbju4TLPHHJt9pPbXQ4XxonNEbDdi1eivOLVbNKeVMepOKsSkonvwiOfZ64fAFLENSBumpJBOkl9KvzFnD/mSvpB1m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HAgEIMGH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706288971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C0SzL+zRQ0KIywrJY/fgdSQ4/8H3RGQGGgFdpnwjnFM=;
	b=HAgEIMGH/JaNXn+ECB7Gbzj6cmJcTAZissice4IFVegsQ2Jto6chW0xGgXQbrzDbMpvp+a
	FcmsLLarrUJPNx6bB7WDgrW9y9BKsAoP62aEK0jCbs6MeM1FQWJtqsfbwBG75jbFB5j1MB
	jCjTYz6OvVqK06Hy1Wye+X8eQFY71ng=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-339-GoFDshduMBif9C4KcHWOSA-1; Fri, 26 Jan 2024 12:09:24 -0500
X-MC-Unique: GoFDshduMBif9C4KcHWOSA-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-429a8494838so9071351cf.0
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 09:09:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706288963; x=1706893763;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C0SzL+zRQ0KIywrJY/fgdSQ4/8H3RGQGGgFdpnwjnFM=;
        b=EwoofVAosAQN9wEF4znVBCNa+KOzbCCdHALR12NZQwn2Nbt7Raim8+rgl5dGXm0UHJ
         4nt/aEifkeFVC9UglXrsm10+FEQdDHlTMNIXRjb5j9MCoy+pwf+76yHXMKX5og8YNQob
         T+OC31w375Dki3MKMGG25KPhOGpuQIfeU811W5YNUDMtYyaR2U0J06W83gKiicAqQVsR
         DCjbiSnAZZQnGFaHyw66msGDfVP5Q/aTz3qKXJczK3W2hphaD8F6oqaznccaKVqqkfHp
         v7Wn11Zw93AOAzXkl64Hk/u3qctPUeeWC9tUDZmRRDXC4hLIqX/FkHg19aRVdXJ+A1cq
         7tHw==
X-Gm-Message-State: AOJu0YznXtPiP43miw0PUTb1D/Xv8k5cy1pMryyLhWHoWZ+XlrVQtgjT
	UgEcT04ivcSiVKozHIdsK/PxwoqXFnVwNf6diSGi8/RmTHqdzffQpNGYNN1dJQXpqC/g30nDArQ
	QyolQ7Z25TTl8L7rVOUNTJuXdM0RM2gc2YV5w+XAMJm75JSRGmw==
X-Received: by 2002:ac8:5791:0:b0:42a:68be:493b with SMTP id v17-20020ac85791000000b0042a68be493bmr151990qta.51.1706288962998;
        Fri, 26 Jan 2024 09:09:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEMEn5J69PlD8XDoh2aJKf7NGXp79yfni+xfngZy/is5njHnWBvpbsZ6vZtEWSXFh2+HXFY0w==
X-Received: by 2002:ac8:5791:0:b0:42a:68be:493b with SMTP id v17-20020ac85791000000b0042a68be493bmr151967qta.51.1706288962670;
        Fri, 26 Jan 2024 09:09:22 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-176-119.web.vodafone.de. [109.43.176.119])
        by smtp.gmail.com with ESMTPSA id ex7-20020a05622a518700b0042994b3c20dsm677135qtb.29.2024.01.26.09.09.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jan 2024 09:09:22 -0800 (PST)
Message-ID: <135941df-2f8b-4fd5-91c7-40b413e6eae3@redhat.com>
Date: Fri, 26 Jan 2024 18:09:08 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] bulk: Prefer fast cpu_env() over slower CPU QOM cast
 macro
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
 Richard Henderson <richard.henderson@linaro.org>, qemu-s390x@nongnu.org,
 qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Anthony Perard <anthony.perard@citrix.com>, Paul Durrant <paul@xen.org>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Nicholas Piggin <npiggin@gmail.com>, =?UTF-8?B?RnLDqWTDqXJpYyBCYXJyYXQ=?=
 <fbarrat@linux.ibm.com>, Daniel Henrique Barboza <danielhb413@gmail.com>,
 David Gibson <david@gibson.dropbear.id.au>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, Alexander Graf
 <agraf@csgraf.de>, Michael Rolnik <mrolnik@gmail.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Cameron Esfahani <dirty@apple.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, David Woodhouse
 <dwmw2@infradead.org>, Laurent Vivier <laurent@vivier.eu>,
 Aurelien Jarno <aurelien@aurel32.net>, Jiaxun Yang
 <jiaxun.yang@flygoat.com>, Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
 Huacai Chen <chenhuacai@kernel.org>, Chris Wulff <crwulff@gmail.com>,
 Marek Vasut <marex@denx.de>, Stafford Horne <shorne@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 Bin Meng <bin.meng@windriver.com>, Weiwei Li <liwei1518@gmail.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 David Hildenbrand <david@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Halil Pasic <pasic@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
 Artyom Tarasenko <atar4qemu@gmail.com>,
 Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
 Max Filippov <jcmvbkbc@gmail.com>, xen-devel@lists.xenproject.org,
 kvm@vger.kernel.org
References: <20240125165648.49898-1-philmd@linaro.org>
 <20240125165648.49898-3-philmd@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240125165648.49898-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 25/01/2024 17.56, Philippe Mathieu-Daudé wrote:
> Mechanical patch produced running the command documented
> in scripts/coccinelle/cpu_env.cocci_template header.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/i386/hvf/vmx.h                   |  9 +++----
>   hw/i386/vmmouse.c                       |  6 ++---
>   hw/i386/xen/xen-hvm.c                   |  3 +--
>   hw/intc/arm_gicv3_cpuif_common.c        |  3 +--
>   hw/ppc/mpc8544_guts.c                   |  3 +--
>   hw/ppc/pnv.c                            |  3 +--
>   hw/ppc/pnv_xscom.c                      |  3 +--
>   hw/ppc/ppce500_spin.c                   |  3 +--
>   hw/ppc/spapr.c                          |  3 +--
>   hw/ppc/spapr_caps.c                     |  6 ++---
>   target/alpha/cpu.c                      | 21 +++++----------
>   target/alpha/gdbstub.c                  |  6 ++---
>   target/alpha/helper.c                   | 12 +++------
>   target/alpha/mem_helper.c               |  9 +++----
>   target/arm/cpu.c                        | 15 ++++-------
>   target/arm/debug_helper.c               |  6 ++---
>   target/arm/gdbstub.c                    |  6 ++---
>   target/arm/gdbstub64.c                  |  6 ++---
>   target/arm/helper.c                     |  9 +++----
>   target/arm/hvf/hvf.c                    | 12 +++------
>   target/arm/kvm.c                        |  3 +--
>   target/arm/ptw.c                        |  3 +--
>   target/arm/tcg/cpu32.c                  |  3 +--
>   target/avr/cpu.c                        | 21 +++++----------
>   target/avr/gdbstub.c                    |  6 ++---
>   target/avr/helper.c                     |  9 +++----
>   target/cris/cpu.c                       |  3 +--
>   target/cris/gdbstub.c                   |  9 +++----
>   target/cris/helper.c                    | 12 +++------
>   target/cris/translate.c                 |  3 +--
>   target/hppa/cpu.c                       |  6 ++---
>   target/hppa/int_helper.c                |  6 ++---
>   target/hppa/mem_helper.c                |  3 +--
>   target/i386/arch_memory_mapping.c       |  3 +--
>   target/i386/cpu-dump.c                  |  3 +--
>   target/i386/cpu.c                       | 36 +++++++++----------------
>   target/i386/helper.c                    | 30 +++++++--------------
>   target/i386/hvf/hvf.c                   |  6 ++---
>   target/i386/hvf/x86.c                   |  3 +--
>   target/i386/hvf/x86_emu.c               |  6 ++---
>   target/i386/hvf/x86_task.c              | 10 +++----
>   target/i386/hvf/x86hvf.c                |  6 ++---
>   target/i386/kvm/kvm.c                   |  6 ++---
>   target/i386/kvm/xen-emu.c               | 30 +++++++--------------
>   target/i386/tcg/sysemu/bpt_helper.c     |  3 +--
>   target/i386/tcg/tcg-cpu.c               | 12 +++------
>   target/i386/tcg/user/excp_helper.c      |  3 +--
>   target/i386/tcg/user/seg_helper.c       |  3 +--
>   target/m68k/cpu.c                       | 30 +++++++--------------
>   target/m68k/gdbstub.c                   |  6 ++---
>   target/m68k/helper.c                    |  3 +--
>   target/m68k/m68k-semi.c                 |  6 ++---
>   target/m68k/op_helper.c                 |  9 +++----
>   target/m68k/translate.c                 |  3 +--
>   target/microblaze/helper.c              |  3 +--
>   target/microblaze/translate.c           |  3 +--
>   target/mips/cpu.c                       |  9 +++----
>   target/mips/gdbstub.c                   |  6 ++---
>   target/mips/kvm.c                       | 27 +++++++------------
>   target/mips/sysemu/physaddr.c           |  3 +--
>   target/mips/tcg/exception.c             |  3 +--
>   target/mips/tcg/op_helper.c             |  3 +--
>   target/mips/tcg/sysemu/special_helper.c |  3 +--
>   target/mips/tcg/sysemu/tlb_helper.c     |  6 ++---
>   target/mips/tcg/translate.c             |  3 +--
>   target/nios2/cpu.c                      |  9 +++----
>   target/nios2/helper.c                   |  3 +--
>   target/nios2/nios2-semi.c               |  6 ++---
>   target/openrisc/gdbstub.c               |  3 +--
>   target/openrisc/interrupt.c             |  6 ++---
>   target/openrisc/translate.c             |  3 +--
>   target/ppc/cpu_init.c                   |  9 +++----
>   target/ppc/excp_helper.c                |  3 +--
>   target/ppc/gdbstub.c                    | 12 +++------
>   target/ppc/kvm.c                        |  6 ++---
>   target/ppc/ppc-qmp-cmds.c               |  3 +--
>   target/ppc/user_only_helper.c           |  3 +--
>   target/riscv/arch_dump.c                |  6 ++---
>   target/riscv/cpu.c                      | 15 ++++-------
>   target/riscv/cpu_helper.c               | 13 +++------
>   target/riscv/debug.c                    |  9 +++----
>   target/riscv/gdbstub.c                  |  6 ++---
>   target/riscv/kvm/kvm-cpu.c              |  6 ++---
>   target/riscv/tcg/tcg-cpu.c              |  9 +++----
>   target/riscv/translate.c                |  3 +--
>   target/rx/gdbstub.c                     |  6 ++---
>   target/rx/helper.c                      |  6 ++---
>   target/rx/translate.c                   |  3 +--
>   target/s390x/cpu-dump.c                 |  3 +--
>   target/s390x/gdbstub.c                  |  6 ++---
>   target/s390x/helper.c                   |  3 +--
>   target/s390x/kvm/kvm.c                  |  6 ++---
>   target/s390x/tcg/excp_helper.c          |  9 +++----
>   target/s390x/tcg/translate.c            |  3 +--
>   target/sh4/cpu.c                        | 15 ++++-------
>   target/sh4/gdbstub.c                    |  6 ++---
>   target/sh4/helper.c                     |  9 +++----
>   target/sh4/translate.c                  |  3 +--
>   target/sparc/cpu.c                      | 12 +++------
>   target/sparc/gdbstub.c                  |  3 +--
>   target/sparc/int32_helper.c             |  3 +--
>   target/sparc/int64_helper.c             |  3 +--
>   target/sparc/ldst_helper.c              |  6 ++---
>   target/sparc/mmu_helper.c               | 15 ++++-------
>   target/sparc/translate.c                |  3 +--
>   target/tricore/cpu.c                    | 12 +++------
>   target/tricore/gdbstub.c                |  6 ++---
>   target/tricore/helper.c                 |  3 +--
>   target/tricore/translate.c              |  3 +--
>   target/xtensa/dbg_helper.c              |  3 +--
>   target/xtensa/exc_helper.c              |  3 +--
>   target/xtensa/gdbstub.c                 |  6 ++---
>   target/xtensa/helper.c                  |  9 +++----
>   target/xtensa/translate.c               |  3 +--
>   114 files changed, 273 insertions(+), 548 deletions(-)

A huge patch ... I wonder whether it would make sense to split it up by 
target architecture to ease the review?

...
> diff --git a/hw/i386/vmmouse.c b/hw/i386/vmmouse.c
> index a8d014d09a..eb0613bfbe 100644
> --- a/hw/i386/vmmouse.c
> +++ b/hw/i386/vmmouse.c
> @@ -74,8 +74,7 @@ struct VMMouseState {
>   
>   static void vmmouse_get_data(uint32_t *data)
>   {
> -    X86CPU *cpu = X86_CPU(current_cpu);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(CPU(current_cpu));

No need for the CPU() cast here, current_cpu is already
of type "CPUState *".

>   
>       data[0] = env->regs[R_EAX]; data[1] = env->regs[R_EBX];
>       data[2] = env->regs[R_ECX]; data[3] = env->regs[R_EDX];
> @@ -84,8 +83,7 @@ static void vmmouse_get_data(uint32_t *data)
>   
>   static void vmmouse_set_data(const uint32_t *data)
>   {
> -    X86CPU *cpu = X86_CPU(current_cpu);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(CPU(current_cpu));

dito.

>       env->regs[R_EAX] = data[0]; env->regs[R_EBX] = data[1];
>       env->regs[R_ECX] = data[2]; env->regs[R_EDX] = data[3];
> diff --git a/hw/i386/xen/xen-hvm.c b/hw/i386/xen/xen-hvm.c
> index f42621e674..3d3ae49be5 100644
> --- a/hw/i386/xen/xen-hvm.c
> +++ b/hw/i386/xen/xen-hvm.c
> @@ -487,8 +487,7 @@ static void regs_to_cpu(vmware_regs_t *vmport_regs, ioreq_t *req)
>   
>   static void regs_from_cpu(vmware_regs_t *vmport_regs)
>   {
> -    X86CPU *cpu = X86_CPU(current_cpu);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(CPU(current_cpu));

dito.

>       vmport_regs->ebx = env->regs[R_EBX];
>       vmport_regs->ecx = env->regs[R_ECX];
...
> diff --git a/hw/ppc/mpc8544_guts.c b/hw/ppc/mpc8544_guts.c
> index a26e83d048..3c6a852ad4 100644
> --- a/hw/ppc/mpc8544_guts.c
> +++ b/hw/ppc/mpc8544_guts.c
> @@ -71,8 +71,7 @@ static uint64_t mpc8544_guts_read(void *opaque, hwaddr addr,
>                                     unsigned size)
>   {
>       uint32_t value = 0;
> -    PowerPCCPU *cpu = POWERPC_CPU(current_cpu);
> -    CPUPPCState *env = &cpu->env;
> +    CPUPPCState *env = cpu_env(CPU(current_cpu));

dito ...

I'll stop here, please respin with the cpu_env(CPU(current_cpu)) fixed to
cpu_env(current_cpu), and please split the patch by target CPU types.

  Thanks,
   Thomas


