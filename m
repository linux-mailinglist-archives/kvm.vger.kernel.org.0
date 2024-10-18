Return-Path: <kvm+bounces-29178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E96E99A459D
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 20:19:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 850F0285A84
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 18:19:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83F6C204080;
	Fri, 18 Oct 2024 18:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b="UN+RJ2k4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BE51822E5
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 18:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729275571; cv=none; b=htEk+tQPDqKGcuWCyD0NgYd1wN0FGCOq0wHoFlid+GlpxL3/2+uA8gUaVJGw6ITIgV5b5Fpv2TJHoArcBpYsrzKUupKBFZxwwISoZ/JpVqKi04SnPSHbviwRFuEeG8PMqlqM2/yvt8K1uWeycXEcvAzLglSmjm5XVNvs8lKlrGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729275571; c=relaxed/simple;
	bh=X1FME06xZowgQ1ycjXxU88JX+wm7nJhBG6WVqhf2YCM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GZhSJaPMfEUKvyiZN5lyjV69RXFFAlVmbEzW7TCN0HnqBgUDScKnSqxPIqdUkDZbTtH07gK7yx0Hgbi1pAuVu1B6maAyZdfev1mb0REW37HvhR70GQ0rRcf/yBuS8sTOx5RDt/XS7pAU1kD/rU85clyjvV+cMML+5JKLDLU+iHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atishpatra.org; spf=pass smtp.mailfrom=atishpatra.org; dkim=pass (1024-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b=UN+RJ2k4; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atishpatra.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atishpatra.org
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-539f8490856so2924245e87.2
        for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 11:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google; t=1729275566; x=1729880366; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pxmy3sqS1cAQNJxt5t1dQqvUlQlW6137zV247JNa2jc=;
        b=UN+RJ2k4VUngRNmlLZRxFxbqDxJLAySw3GKkiUAmjlNp6qoPKQEMIXN47jfV/+taug
         7yIDixgNLIq/qNQ60vrpShLXmANFCETuHq2uL2MJleyMCSETKRVtCjFVEaRs1KwbG1hG
         p3mmuUXrn0DEh3P2k+WMbgMln6A5FFlB3hB40=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729275566; x=1729880366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pxmy3sqS1cAQNJxt5t1dQqvUlQlW6137zV247JNa2jc=;
        b=lc8rcT6qOMfh9kfsaw8ITOMkntNEYpPC2Wi4/mh5M2yGScnz6+uQQU3hApUFr/2hge
         KwlidP+N3hmkbegn1sey9mWf9oDmKRlt/diqD8wL3CpqmHq7dTDQoUhdoKudepvnVMaA
         8aKLD0GbeQ/l5QHmAmznAy/lTZwN7oGpjtdOzv3OdQkSm4PEUo94OUjTQDl/XEfm415Y
         sezoauyh/0CTKayCVo2KNtcl1w4SX61U81AfWJ+fMzlC66wYOILNKCD8u1iBryOs6vaj
         mmkr449/99e7yhf5RaZPV+3oCkoO0SkIByENKQeqaF/Qfca5QllrdmFoE7GcQ8ngg7HS
         xXhA==
X-Forwarded-Encrypted: i=1; AJvYcCWfq/I+GlkMHUKKbwJVnOBH1xdg2Y28cKZ+4yGQAn+csnSZ+UowsSYXdLqUyUzMD2Qx9DI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzju2Rqv4VFh35EsERknnSuVJFSxm5oOTnIHUq0sKMmntY07Lwg
	tz6CZCDGDMrUXjnYlnVP+6Iijk7Un7tDIFPQIFTxbTCAEgWdG7+8fePDDr1qokZRdqHwrbwj1qc
	O72L91ossb13OvkOAHqtwf9w9WtfqiPYhoZot
X-Google-Smtp-Source: AGHT+IGLSZ/N96+nb+vxMw7TLpdFodBpcXt3/6JNGph7qbHR8v9giErxbk5rPWl+B+oeV3iBAMPMirdWB8KYguTmhvQ=
X-Received: by 2002:a05:6512:b19:b0:539:d2e2:41ff with SMTP id
 2adb3069b0e04-53a15493465mr2068480e87.23.1729275565749; Fri, 18 Oct 2024
 11:19:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240719160913.342027-1-apatel@ventanamicro.com> <20240719160913.342027-9-apatel@ventanamicro.com>
In-Reply-To: <20240719160913.342027-9-apatel@ventanamicro.com>
From: Atish Patra <atishp@atishpatra.org>
Date: Fri, 18 Oct 2024 11:19:14 -0700
Message-ID: <CAOnJCUJ6sCc5CKcHQBuLmW=Z2+j1MqBBTv309uqJeywp0s4V=A@mail.gmail.com>
Subject: Re: [PATCH 08/13] RISC-V: KVM: Add common nested acceleration support
To: Anup Patel <apatel@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 19, 2024 at 9:09=E2=80=AFAM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> Add a common nested acceleration support which will be shared by
> all parts of KVM RISC-V. This nested acceleration support detects
> and enables SBI NACL extension usage based on static keys which
> ensures minimum impact on the non-nested scenario.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_nacl.h | 205 ++++++++++++++++++++++++++++++
>  arch/riscv/kvm/Makefile           |   1 +
>  arch/riscv/kvm/main.c             |  53 +++++++-
>  arch/riscv/kvm/nacl.c             | 152 ++++++++++++++++++++++
>  4 files changed, 409 insertions(+), 2 deletions(-)
>  create mode 100644 arch/riscv/include/asm/kvm_nacl.h
>  create mode 100644 arch/riscv/kvm/nacl.c
>
> diff --git a/arch/riscv/include/asm/kvm_nacl.h b/arch/riscv/include/asm/k=
vm_nacl.h
> new file mode 100644
> index 000000000000..a704e8000a58
> --- /dev/null
> +++ b/arch/riscv/include/asm/kvm_nacl.h
> @@ -0,0 +1,205 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2024 Ventana Micro Systems Inc.
> + */
> +
> +#ifndef __KVM_NACL_H
> +#define __KVM_NACL_H
> +
> +#include <linux/jump_label.h>
> +#include <linux/percpu.h>
> +#include <asm/byteorder.h>
> +#include <asm/csr.h>
> +#include <asm/sbi.h>
> +
> +DECLARE_STATIC_KEY_FALSE(kvm_riscv_nacl_available);
> +#define kvm_riscv_nacl_available() \
> +       static_branch_unlikely(&kvm_riscv_nacl_available)
> +
> +DECLARE_STATIC_KEY_FALSE(kvm_riscv_nacl_sync_csr_available);
> +#define kvm_riscv_nacl_sync_csr_available() \
> +       static_branch_unlikely(&kvm_riscv_nacl_sync_csr_available)
> +
> +DECLARE_STATIC_KEY_FALSE(kvm_riscv_nacl_sync_hfence_available);
> +#define kvm_riscv_nacl_sync_hfence_available() \
> +       static_branch_unlikely(&kvm_riscv_nacl_sync_hfence_available)
> +
> +DECLARE_STATIC_KEY_FALSE(kvm_riscv_nacl_sync_sret_available);
> +#define kvm_riscv_nacl_sync_sret_available() \
> +       static_branch_unlikely(&kvm_riscv_nacl_sync_sret_available)
> +
> +DECLARE_STATIC_KEY_FALSE(kvm_riscv_nacl_autoswap_csr_available);
> +#define kvm_riscv_nacl_autoswap_csr_available() \
> +       static_branch_unlikely(&kvm_riscv_nacl_autoswap_csr_available)
> +
> +struct kvm_riscv_nacl {
> +       void *shmem;
> +       phys_addr_t shmem_phys;
> +};
> +DECLARE_PER_CPU(struct kvm_riscv_nacl, kvm_riscv_nacl);
> +
> +void __kvm_riscv_nacl_hfence(void *shmem,
> +                            unsigned long control,
> +                            unsigned long page_num,
> +                            unsigned long page_count);
> +
> +int kvm_riscv_nacl_enable(void);
> +
> +void kvm_riscv_nacl_disable(void);
> +
> +void kvm_riscv_nacl_exit(void);
> +
> +int kvm_riscv_nacl_init(void);
> +
> +#ifdef CONFIG_32BIT
> +#define lelong_to_cpu(__x)     le32_to_cpu(__x)
> +#define cpu_to_lelong(__x)     cpu_to_le32(__x)
> +#else
> +#define lelong_to_cpu(__x)     le64_to_cpu(__x)
> +#define cpu_to_lelong(__x)     cpu_to_le64(__x)
> +#endif
> +
> +#define nacl_shmem()                                                   \
> +       this_cpu_ptr(&kvm_riscv_nacl)->shmem
> +#define nacl_shmem_fast()                                              \
> +       (kvm_riscv_nacl_available() ? nacl_shmem() : NULL)
> +

I don't see any usage of this one. Most of the callers of nacl_shmem
probably require more to do if nacl is available
and need the conditional block anyways. Am I missing something ?

> +#define nacl_sync_hfence(__e)                                          \
> +       sbi_ecall(SBI_EXT_NACL, SBI_EXT_NACL_SYNC_HFENCE,               \
> +                 (__e), 0, 0, 0, 0, 0)
> +
> +#define nacl_hfence_mkconfig(__type, __order, __vmid, __asid)          \
> +({                                                                     \
> +       unsigned long __c =3D SBI_NACL_SHMEM_HFENCE_CONFIG_PEND;         =
 \
> +       __c |=3D ((__type) & SBI_NACL_SHMEM_HFENCE_CONFIG_TYPE_MASK)     =
 \
> +               << SBI_NACL_SHMEM_HFENCE_CONFIG_TYPE_SHIFT;             \
> +       __c |=3D (((__order) - SBI_NACL_SHMEM_HFENCE_ORDER_BASE) &       =
 \
> +               SBI_NACL_SHMEM_HFENCE_CONFIG_ORDER_MASK)                \
> +               << SBI_NACL_SHMEM_HFENCE_CONFIG_ORDER_SHIFT;            \
> +       __c |=3D ((__vmid) & SBI_NACL_SHMEM_HFENCE_CONFIG_VMID_MASK)     =
 \
> +               << SBI_NACL_SHMEM_HFENCE_CONFIG_VMID_SHIFT;             \
> +       __c |=3D ((__asid) & SBI_NACL_SHMEM_HFENCE_CONFIG_ASID_MASK);    =
 \
> +       __c;                                                            \
> +})
> +
> +#define nacl_hfence_mkpnum(__order, __addr)                            \
> +       ((__addr) >> (__order))
> +
> +#define nacl_hfence_mkpcount(__order, __size)                          \
> +       ((__size) >> (__order))
> +
> +#define nacl_hfence_gvma(__shmem, __gpa, __gpsz, __order)              \
> +__kvm_riscv_nacl_hfence(__shmem,                                       \
> +       nacl_hfence_mkconfig(SBI_NACL_SHMEM_HFENCE_TYPE_GVMA,           \
> +                          __order, 0, 0),                              \
> +       nacl_hfence_mkpnum(__order, __gpa),                             \
> +       nacl_hfence_mkpcount(__order, __gpsz))
> +
> +#define nacl_hfence_gvma_all(__shmem)                                  \
> +__kvm_riscv_nacl_hfence(__shmem,                                       \
> +       nacl_hfence_mkconfig(SBI_NACL_SHMEM_HFENCE_TYPE_GVMA_ALL,       \
> +                          0, 0, 0), 0, 0)
> +
> +#define nacl_hfence_gvma_vmid(__shmem, __vmid, __gpa, __gpsz, __order) \
> +__kvm_riscv_nacl_hfence(__shmem,                                       \
> +       nacl_hfence_mkconfig(SBI_NACL_SHMEM_HFENCE_TYPE_GVMA_VMID,      \
> +                          __order, __vmid, 0),                         \
> +       nacl_hfence_mkpnum(__order, __gpa),                             \
> +       nacl_hfence_mkpcount(__order, __gpsz))
> +
> +#define nacl_hfence_gvma_vmid_all(__shmem, __vmid)                     \
> +__kvm_riscv_nacl_hfence(__shmem,                                       \
> +       nacl_hfence_mkconfig(SBI_NACL_SHMEM_HFENCE_TYPE_GVMA_VMID_ALL,  \
> +                          0, __vmid, 0), 0, 0)
> +
> +#define nacl_hfence_vvma(__shmem, __vmid, __gva, __gvsz, __order)      \
> +__kvm_riscv_nacl_hfence(__shmem,                                       \
> +       nacl_hfence_mkconfig(SBI_NACL_SHMEM_HFENCE_TYPE_VVMA,           \
> +                          __order, __vmid, 0),                         \
> +       nacl_hfence_mkpnum(__order, __gva),                             \
> +       nacl_hfence_mkpcount(__order, __gvsz))
> +
> +#define nacl_hfence_vvma_all(__shmem, __vmid)                          \
> +__kvm_riscv_nacl_hfence(__shmem,                                       \
> +       nacl_hfence_mkconfig(SBI_NACL_SHMEM_HFENCE_TYPE_VVMA_ALL,       \
> +                          0, __vmid, 0), 0, 0)
> +
> +#define nacl_hfence_vvma_asid(__shmem, __vmid, __asid, __gva, __gvsz, __=
order)\
> +__kvm_riscv_nacl_hfence(__shmem,                                       \
> +       nacl_hfence_mkconfig(SBI_NACL_SHMEM_HFENCE_TYPE_VVMA_ASID,      \
> +                          __order, __vmid, __asid),                    \
> +       nacl_hfence_mkpnum(__order, __gva),                             \
> +       nacl_hfence_mkpcount(__order, __gvsz))
> +
> +#define nacl_hfence_vvma_asid_all(__shmem, __vmid, __asid)             \
> +__kvm_riscv_nacl_hfence(__shmem,                                       \
> +       nacl_hfence_mkconfig(SBI_NACL_SHMEM_HFENCE_TYPE_VVMA_ASID_ALL,  \
> +                          0, __vmid, __asid), 0, 0)
> +
> +#define nacl_csr_read(__shmem, __csr)                                  \
> +({                                                                     \
> +       unsigned long *__a =3D (__shmem) + SBI_NACL_SHMEM_CSR_OFFSET;    =
 \
> +       lelong_to_cpu(__a[SBI_NACL_SHMEM_CSR_INDEX(__csr)]);            \
> +})
> +
> +#define nacl_csr_write(__shmem, __csr, __val)                          \
> +do {                                                                   \
> +       void *__s =3D (__shmem);                                         =
 \
> +       unsigned int __i =3D SBI_NACL_SHMEM_CSR_INDEX(__csr);            =
 \
> +       unsigned long *__a =3D (__s) + SBI_NACL_SHMEM_CSR_OFFSET;        =
 \
> +       u8 *__b =3D (__s) + SBI_NACL_SHMEM_DBITMAP_OFFSET;               =
 \
> +       __a[__i] =3D cpu_to_lelong(__val);                               =
 \
> +       __b[__i >> 3] |=3D 1U << (__i & 0x7);                            =
 \
> +} while (0)
> +
> +#define nacl_csr_swap(__shmem, __csr, __val)                           \
> +({                                                                     \
> +       void *__s =3D (__shmem);                                         =
 \
> +       unsigned int __i =3D SBI_NACL_SHMEM_CSR_INDEX(__csr);            =
 \
> +       unsigned long *__a =3D (__s) + SBI_NACL_SHMEM_CSR_OFFSET;        =
 \
> +       u8 *__b =3D (__s) + SBI_NACL_SHMEM_DBITMAP_OFFSET;               =
 \
> +       unsigned long __r =3D lelong_to_cpu(__a[__i]);                   =
 \
> +       __a[__i] =3D cpu_to_lelong(__val);                               =
 \
> +       __b[__i >> 3] |=3D 1U << (__i & 0x7);                            =
 \
> +       __r;                                                            \
> +})
> +
> +#define nacl_sync_csr(__csr)                                           \
> +       sbi_ecall(SBI_EXT_NACL, SBI_EXT_NACL_SYNC_CSR,                  \
> +                 (__csr), 0, 0, 0, 0, 0)
> +
> +#define ncsr_read(__csr)                                               \
> +({                                                                     \
> +       unsigned long __r;                                              \
> +       if (kvm_riscv_nacl_available())                                 \
> +               __r =3D nacl_csr_read(nacl_shmem(), __csr);              =
 \
> +       else                                                            \
> +               __r =3D csr_read(__csr);                                 =
 \
> +       __r;                                                            \
> +})
> +
> +#define ncsr_write(__csr, __val)                                       \
> +do {                                                                   \
> +       if (kvm_riscv_nacl_sync_csr_available())                        \
> +               nacl_csr_write(nacl_shmem(), __csr, __val);             \
> +       else                                                            \
> +               csr_write(__csr, __val);                                \
> +} while (0)
> +
> +#define ncsr_swap(__csr, __val)                                         =
       \
> +({                                                                     \
> +       unsigned long __r;                                              \
> +       if (kvm_riscv_nacl_sync_csr_available())                        \
> +               __r =3D nacl_csr_swap(nacl_shmem(), __csr, __val);       =
 \
> +       else                                                            \
> +               __r =3D csr_swap(__csr, __val);                          =
 \
> +       __r;                                                            \
> +})
> +
> +#define nsync_csr(__csr)                                               \
> +do {                                                                   \
> +       if (kvm_riscv_nacl_sync_csr_available())                        \
> +               nacl_sync_csr(__csr);                                   \
> +} while (0)
> +
> +#endif
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index c1eac0d093de..0fb1840c3e0a 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -16,6 +16,7 @@ kvm-y +=3D aia_device.o
>  kvm-y +=3D aia_imsic.o
>  kvm-y +=3D main.o
>  kvm-y +=3D mmu.o
> +kvm-y +=3D nacl.o
>  kvm-y +=3D tlb.o
>  kvm-y +=3D vcpu.o
>  kvm-y +=3D vcpu_exit.o
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index bab2ec34cd87..fd78f40bbb04 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -10,8 +10,8 @@
>  #include <linux/err.h>
>  #include <linux/module.h>
>  #include <linux/kvm_host.h>
> -#include <asm/csr.h>
>  #include <asm/cpufeature.h>
> +#include <asm/kvm_nacl.h>
>  #include <asm/sbi.h>
>
>  long kvm_arch_dev_ioctl(struct file *filp,
> @@ -22,6 +22,12 @@ long kvm_arch_dev_ioctl(struct file *filp,
>
>  int kvm_arch_hardware_enable(void)
>  {
> +       int rc;
> +
> +       rc =3D kvm_riscv_nacl_enable();
> +       if (rc)
> +               return rc;
> +
>         csr_write(CSR_HEDELEG, KVM_HEDELEG_DEFAULT);
>         csr_write(CSR_HIDELEG, KVM_HIDELEG_DEFAULT);
>
> @@ -49,11 +55,14 @@ void kvm_arch_hardware_disable(void)
>         csr_write(CSR_HVIP, 0);
>         csr_write(CSR_HEDELEG, 0);
>         csr_write(CSR_HIDELEG, 0);
> +
> +       kvm_riscv_nacl_disable();
>  }
>
>  static int __init riscv_kvm_init(void)
>  {
>         int rc;
> +       char slist[64];
>         const char *str;
>
>         if (!riscv_isa_extension_available(NULL, h)) {
> @@ -71,16 +80,53 @@ static int __init riscv_kvm_init(void)
>                 return -ENODEV;
>         }
>
> +       rc =3D kvm_riscv_nacl_init();
> +       if (rc && rc !=3D -ENODEV)
> +               return rc;
> +
>         kvm_riscv_gstage_mode_detect();
>
>         kvm_riscv_gstage_vmid_detect();
>
>         rc =3D kvm_riscv_aia_init();
> -       if (rc && rc !=3D -ENODEV)
> +       if (rc && rc !=3D -ENODEV) {
> +               kvm_riscv_nacl_exit();
>                 return rc;
> +       }
>
>         kvm_info("hypervisor extension available\n");
>
> +       if (kvm_riscv_nacl_available()) {
> +               rc =3D 0;
> +               slist[0] =3D '\0';
> +               if (kvm_riscv_nacl_sync_csr_available()) {
> +                       if (rc)
> +                               strcat(slist, ", ");
> +                       strcat(slist, "sync_csr");
> +                       rc++;
> +               }
> +               if (kvm_riscv_nacl_sync_hfence_available()) {
> +                       if (rc)
> +                               strcat(slist, ", ");
> +                       strcat(slist, "sync_hfence");
> +                       rc++;
> +               }
> +               if (kvm_riscv_nacl_sync_sret_available()) {
> +                       if (rc)
> +                               strcat(slist, ", ");
> +                       strcat(slist, "sync_sret");
> +                       rc++;
> +               }
> +               if (kvm_riscv_nacl_autoswap_csr_available()) {
> +                       if (rc)
> +                               strcat(slist, ", ");
> +                       strcat(slist, "autoswap_csr");
> +                       rc++;
> +               }
> +               kvm_info("using SBI nested acceleration with %s\n",
> +                        (rc) ? slist : "no features");
> +       }
> +
>         switch (kvm_riscv_gstage_mode()) {
>         case HGATP_MODE_SV32X4:
>                 str =3D "Sv32x4";
> @@ -108,6 +154,7 @@ static int __init riscv_kvm_init(void)
>         rc =3D kvm_init(sizeof(struct kvm_vcpu), 0, THIS_MODULE);
>         if (rc) {
>                 kvm_riscv_aia_exit();
> +               kvm_riscv_nacl_exit();
>                 return rc;
>         }
>
> @@ -119,6 +166,8 @@ static void __exit riscv_kvm_exit(void)
>  {
>         kvm_riscv_aia_exit();
>
> +       kvm_riscv_nacl_exit();
> +
>         kvm_exit();
>  }
>  module_exit(riscv_kvm_exit);
> diff --git a/arch/riscv/kvm/nacl.c b/arch/riscv/kvm/nacl.c
> new file mode 100644
> index 000000000000..08a95ad9ada2
> --- /dev/null
> +++ b/arch/riscv/kvm/nacl.c
> @@ -0,0 +1,152 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2024 Ventana Micro Systems Inc.
> + */
> +
> +#include <linux/kvm_host.h>
> +#include <linux/vmalloc.h>
> +#include <asm/kvm_nacl.h>
> +
> +DEFINE_STATIC_KEY_FALSE(kvm_riscv_nacl_available);
> +DEFINE_STATIC_KEY_FALSE(kvm_riscv_nacl_sync_csr_available);
> +DEFINE_STATIC_KEY_FALSE(kvm_riscv_nacl_sync_hfence_available);
> +DEFINE_STATIC_KEY_FALSE(kvm_riscv_nacl_sync_sret_available);
> +DEFINE_STATIC_KEY_FALSE(kvm_riscv_nacl_autoswap_csr_available);
> +DEFINE_PER_CPU(struct kvm_riscv_nacl, kvm_riscv_nacl);
> +
> +void __kvm_riscv_nacl_hfence(void *shmem,
> +                            unsigned long control,
> +                            unsigned long page_num,
> +                            unsigned long page_count)
> +{
> +       int i, ent =3D -1, try_count =3D 5;
> +       unsigned long *entp;
> +
> +again:
> +       for (i =3D 0; i < SBI_NACL_SHMEM_HFENCE_ENTRY_MAX; i++) {
> +               entp =3D shmem + SBI_NACL_SHMEM_HFENCE_ENTRY_CONFIG(i);
> +               if (lelong_to_cpu(*entp) & SBI_NACL_SHMEM_HFENCE_CONFIG_P=
END)
> +                       continue;
> +
> +               ent =3D i;
> +               break;
> +       }
> +
> +       if (ent < 0) {
> +               if (try_count) {
> +                       nacl_sync_hfence(-1UL);
> +                       goto again;
> +               } else {
> +                       pr_warn("KVM: No free entry in NACL shared memory=
\n");
> +                       return;
> +               }
> +       }
> +
> +       entp =3D shmem + SBI_NACL_SHMEM_HFENCE_ENTRY_CONFIG(i);
> +       *entp =3D cpu_to_lelong(control);
> +       entp =3D shmem + SBI_NACL_SHMEM_HFENCE_ENTRY_PNUM(i);
> +       *entp =3D cpu_to_lelong(page_num);
> +       entp =3D shmem + SBI_NACL_SHMEM_HFENCE_ENTRY_PCOUNT(i);
> +       *entp =3D cpu_to_lelong(page_count);
> +}
> +
> +int kvm_riscv_nacl_enable(void)
> +{
> +       int rc;
> +       struct sbiret ret;
> +       struct kvm_riscv_nacl *nacl;
> +
> +       if (!kvm_riscv_nacl_available())
> +               return 0;
> +       nacl =3D this_cpu_ptr(&kvm_riscv_nacl);
> +
> +       ret =3D sbi_ecall(SBI_EXT_NACL, SBI_EXT_NACL_SET_SHMEM,
> +                       nacl->shmem_phys, 0, 0, 0, 0, 0);
> +       rc =3D sbi_err_map_linux_errno(ret.error);
> +       if (rc)
> +               return rc;
> +
> +       return 0;
> +}
> +
> +void kvm_riscv_nacl_disable(void)
> +{
> +       if (!kvm_riscv_nacl_available())
> +               return;
> +
> +       sbi_ecall(SBI_EXT_NACL, SBI_EXT_NACL_SET_SHMEM,
> +                 SBI_SHMEM_DISABLE, SBI_SHMEM_DISABLE, 0, 0, 0, 0);
> +}
> +
> +void kvm_riscv_nacl_exit(void)
> +{
> +       int cpu;
> +       struct kvm_riscv_nacl *nacl;
> +
> +       if (!kvm_riscv_nacl_available())
> +               return;
> +
> +       /* Allocate per-CPU shared memory */
> +       for_each_possible_cpu(cpu) {
> +               nacl =3D per_cpu_ptr(&kvm_riscv_nacl, cpu);
> +               if (!nacl->shmem)
> +                       continue;
> +
> +               free_pages((unsigned long)nacl->shmem,
> +                          get_order(SBI_NACL_SHMEM_SIZE));
> +               nacl->shmem =3D NULL;
> +               nacl->shmem_phys =3D 0;
> +       }
> +}
> +
> +static long nacl_probe_feature(long feature_id)
> +{
> +       struct sbiret ret;
> +
> +       if (!kvm_riscv_nacl_available())
> +               return 0;
> +
> +       ret =3D sbi_ecall(SBI_EXT_NACL, SBI_EXT_NACL_PROBE_FEATURE,
> +                       feature_id, 0, 0, 0, 0, 0);
> +       return ret.value;
> +}
> +
> +int kvm_riscv_nacl_init(void)
> +{
> +       int cpu;
> +       struct page *shmem_page;
> +       struct kvm_riscv_nacl *nacl;
> +
> +       if (sbi_spec_version < sbi_mk_version(1, 0) ||
> +           sbi_probe_extension(SBI_EXT_NACL) <=3D 0)
> +               return -ENODEV;
> +
> +       /* Enable NACL support */
> +       static_branch_enable(&kvm_riscv_nacl_available);
> +
> +       /* Probe NACL features */
> +       if (nacl_probe_feature(SBI_NACL_FEAT_SYNC_CSR))
> +               static_branch_enable(&kvm_riscv_nacl_sync_csr_available);
> +       if (nacl_probe_feature(SBI_NACL_FEAT_SYNC_HFENCE))
> +               static_branch_enable(&kvm_riscv_nacl_sync_hfence_availabl=
e);
> +       if (nacl_probe_feature(SBI_NACL_FEAT_SYNC_SRET))
> +               static_branch_enable(&kvm_riscv_nacl_sync_sret_available)=
;
> +       if (nacl_probe_feature(SBI_NACL_FEAT_AUTOSWAP_CSR))
> +               static_branch_enable(&kvm_riscv_nacl_autoswap_csr_availab=
le);
> +
> +       /* Allocate per-CPU shared memory */
> +       for_each_possible_cpu(cpu) {
> +               nacl =3D per_cpu_ptr(&kvm_riscv_nacl, cpu);
> +
> +               shmem_page =3D alloc_pages(GFP_KERNEL | __GFP_ZERO,
> +                                        get_order(SBI_NACL_SHMEM_SIZE));
> +               if (!shmem_page) {
> +                       kvm_riscv_nacl_exit();
> +                       return -ENOMEM;
> +               }
> +               nacl->shmem =3D page_to_virt(shmem_page);
> +               nacl->shmem_phys =3D page_to_phys(shmem_page);
> +       }
> +
> +       return 0;
> +}
> --
> 2.34.1
>

Otherwise, it looks good to me.

Reviewed-by: Atish Patra <atishp@rivosinc.com>

--=20
Regards,
Atish

