Return-Path: <kvm+bounces-52100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ABDAB0160A
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:29:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BEAFB7BD878
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 08:28:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09E9120C009;
	Fri, 11 Jul 2025 08:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="NVM00Gkt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330E3201004
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 08:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752222528; cv=none; b=kOf3RPdqXKddINAT2WROGxa4esjiWzQPyczl8jF46GYiQJx7xAZ5N3MbvdwLvPGytQDMsyRy+4KRWiXAF/RbzAyRIg67AKzR21ZKsUuwS/foRm/8MA58rBfp2T7gJ8zc4iUknws3uUOdHvkmu4et3utbH+HEmaWOXRWc3UQ6qNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752222528; c=relaxed/simple;
	bh=C63gSTJaFjfjDN2UWFDRtg1QOpvYxMR7H4rF2lT5drI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=slRaZTfyARynY09G3CzRBPd709B+lAdmD8biBESBjwnR8nc+yH8zEBTkt9xGwOW3bj3zzC58LjYhx5JWkCsvRUuWYNSAz373osBm+Aslm1ix37vPo62ySrnbjB8Ws12WsFzS35ZCKCexV9363PDDpI/ZdBa6wdfx8UXq88UjDUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=NVM00Gkt; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-553b60de463so1802304e87.3
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 01:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1752222522; x=1752827322; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0V0DETkdpP2SJ8ZAwZpM11qaGZR3zWsJjRJIwEWhwAQ=;
        b=NVM00GktKXif7zA+3bfsJqNLb36npTdPBOQ7b0L+cwOKTmOEwBQZRarmWdK8DOx1dN
         iAgJ7dtMdvT6/9/Z4iGkcgp2dsN+hKU4qx0fv7km6Ye7YMcleJNUFKp0vSSDJ9/EDdpT
         fe73CtMHhFWI0NGtnVQdc54UVNDee0Tc7DYftlQsLWT/LDLpK+qyDAieSLkTQgTNF9TB
         9+JpuHcf2vdXbWTfzk4LMksJGke/XvEqv9CTm4P7jScizwa0mWHXl1tCvOgoBphUDjs5
         gRKhWwMwRaJcGj1eOziVTVrfCyuRwWiHAdMeZTJUb++5sU+Dn33jOHWGLF9wO6dOwPbl
         2fHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752222522; x=1752827322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0V0DETkdpP2SJ8ZAwZpM11qaGZR3zWsJjRJIwEWhwAQ=;
        b=dKjxqzzEPdnDagL00ruJ61F0DNVga/9hDAqpk+Tsfxfz6CIq8pIKS4WiUARxj5F7sx
         ivKp9wnU+P7SzmhlLjounRDZgNHluU+UPB4BHzAfWawDDMpqzKQjWA5QA7gtU7MdPobB
         BwaAtyFAPDWTAz9ZvDBj2d6v8Kkc5HbKPoJiWizldpkx+k4iJhZNyOFOFfMYP9FXz9Dm
         GZ+riXw+As79R7nGEt97UJol+dEZV/ZU7lJgs1X8Z7z6QcAkDzXjRz48XEDJtPdy23ri
         dMn9x3aLGgXdLOix6gsGc4TM7r9s+wkm+eXJBTVvyJnvlbAgVPjJX58UMLUIOFEJ0NBC
         JEbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTRHrNkZktRO/mz/agIHZoFAA1xsxENM/hg4iUgXMwNfinEaKWumBY68obLkEiZiXTn5g=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLJYe+pW0gHvrZjf8OybCbWwvGqsM6wczvjRRn+l37jzRC+fcc
	I7rInsX36OdNerCfQZ2nFPIYPEd7pnZppTfyPQSj/ol/V5QoVaSncN3IfcjQjM/wh3MqNn+Ks2F
	W4jx8My7MbA+RUHZxEjr4mXrAcIHK4W9uHRDRNw1Jcg==
X-Gm-Gg: ASbGncsOjpzMskQF4GDnDcnldMGvIBT+VB9ZJqGQJhRxOI5zBPXZHzMHS0lkFYW+UbN
	PvKwmcT99UCGuAVXb4snBV7zFQ+1lnUw4EeTiUSIoC3qN7kxL/fnI0ynicsN9Js4IPjxVwdDTJL
	ZlzOBOX0oPxVLT92IVT5cPe5ybU0+ikjUNDFledy6W+Zwb/AlK5SeQeflBisNso3Jap3kg4ttBw
	/CYJ6VUEPSXFWSQ398=
X-Google-Smtp-Source: AGHT+IGtSsp8vscJn4tzXANU6jXxzJIchtHLYA0CLdSkilBhXH8dJCPNqfw6YPZF2NmYpG1AnNSZ4hh9Y0QgbqWWiuk=
X-Received: by 2002:a05:6512:3da3:b0:553:268e:5019 with SMTP id
 2adb3069b0e04-55a044c9ba0mr720126e87.11.1752222522119; Fri, 11 Jul 2025
 01:28:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250710133030.88940-1-luxu.kernel@bytedance.com>
In-Reply-To: <20250710133030.88940-1-luxu.kernel@bytedance.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Fri, 11 Jul 2025 13:58:29 +0530
X-Gm-Features: Ac12FXwuJjdqyUgP0BGYuxw7gbsx-L955BFg8zTc93L-MwymMDnq-8tfsptw_tg
Message-ID: <CAK9=C2W60a2otfJKucJc_d4=X9YBTep1zSp+wa8E7-kL7tJR0Q@mail.gmail.com>
Subject: Re: [PATCH v2] RISC-V: KVM: Delegate kvm unhandled faults to VS mode
To: Xu Lu <luxu.kernel@bytedance.com>
Cc: rkrcmar@ventanamicro.com, cleger@rivosinc.com, anup@brainfault.org, 
	atish.patra@linux.dev, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 10, 2025 at 7:00=E2=80=AFPM Xu Lu <luxu.kernel@bytedance.com> w=
rote:
>
> Delegate faults which are not handled by kvm to VS mode to avoid
> unnecessary traps to HS mode. These faults include illegal instruction
> fault, instruction access fault, load access fault and store access
> fault.
>
> The delegation of illegal instruction fault is particularly important
> to guest applications that use vector instructions frequently. In such
> cases, an illegal instruction fault will be raised when guest user thread
> uses vector instruction the first time and then guest kernel will enable
> user thread to execute following vector instructions.
>
> The fw pmu event counters remain undeleted so that guest can still get
> these events via sbi call. Guest will only see zero count on these
> events and know 'firmware' has delegated these faults.

Currently, we don't delegate illegal instruction faults and various
access faults to Guest because we allow Guest to count PMU
firmware events. Refer, [1] and [2] for past discussions.

[1] http://lists.infradead.org/pipermail/linux-riscv/2024-August/059658.htm=
l
[2] https://lore.kernel.org/all/20241224-kvm_guest_stat-v2-0-08a77ac36b02@r=
ivosinc.com/

I do understand that additional redirection hoop can slow down
lazy enabling of vector state so drop delegating various access
faults.

Regards,
Anup

>
> Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
> ---
>  arch/riscv/include/asm/kvm_host.h |  4 ++++
>  arch/riscv/kvm/vcpu_exit.c        | 18 ------------------
>  2 files changed, 4 insertions(+), 18 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/k=
vm_host.h
> index 85cfebc32e4cf..e04851cf0115c 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -44,7 +44,11 @@
>  #define KVM_REQ_STEAL_UPDATE           KVM_ARCH_REQ(6)
>
>  #define KVM_HEDELEG_DEFAULT            (BIT(EXC_INST_MISALIGNED) | \
> +                                        BIT(EXC_INST_ACCESS)     | \
> +                                        BIT(EXC_INST_ILLEGAL)    | \
>                                          BIT(EXC_BREAKPOINT)      | \
> +                                        BIT(EXC_LOAD_ACCESS)     | \
> +                                        BIT(EXC_STORE_ACCESS)    | \
>                                          BIT(EXC_SYSCALL)         | \
>                                          BIT(EXC_INST_PAGE_FAULT) | \
>                                          BIT(EXC_LOAD_PAGE_FAULT) | \
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index 6e0c184127956..6e2302c65e193 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -193,11 +193,6 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struc=
t kvm_run *run,
>         ret =3D -EFAULT;
>         run->exit_reason =3D KVM_EXIT_UNKNOWN;
>         switch (trap->scause) {
> -       case EXC_INST_ILLEGAL:
> -               kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ILLEGAL_INSN)=
;
> -               vcpu->stat.instr_illegal_exits++;
> -               ret =3D vcpu_redirect(vcpu, trap);
> -               break;
>         case EXC_LOAD_MISALIGNED:
>                 kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_MISALIGNED_LO=
AD);
>                 vcpu->stat.load_misaligned_exits++;
> @@ -208,19 +203,6 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struc=
t kvm_run *run,
>                 vcpu->stat.store_misaligned_exits++;
>                 ret =3D vcpu_redirect(vcpu, trap);
>                 break;
> -       case EXC_LOAD_ACCESS:
> -               kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ACCESS_LOAD);
> -               vcpu->stat.load_access_exits++;
> -               ret =3D vcpu_redirect(vcpu, trap);
> -               break;
> -       case EXC_STORE_ACCESS:
> -               kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ACCESS_STORE)=
;
> -               vcpu->stat.store_access_exits++;
> -               ret =3D vcpu_redirect(vcpu, trap);
> -               break;
> -       case EXC_INST_ACCESS:
> -               ret =3D vcpu_redirect(vcpu, trap);
> -               break;
>         case EXC_VIRTUAL_INST_FAULT:
>                 if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
>                         ret =3D kvm_riscv_vcpu_virtual_insn(vcpu, run, tr=
ap);
> --
> 2.20.1
>
>

