Return-Path: <kvm+bounces-64276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FB98C7C308
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 03:39:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5BA23A6A94
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 02:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D49712C2360;
	Sat, 22 Nov 2025 02:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C3bSo81U"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AD7275B18
	for <kvm@vger.kernel.org>; Sat, 22 Nov 2025 02:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763779171; cv=none; b=NnSrexSGs/ZOjXZ86yRMRO4mY2B1PdX41FoXIM9jrlWvW69Qzgnrws2Av0SgSoXUq/sVPs4atabriAlCKZ7nN1AHSt35/1d0oRhogte48XQPsUFz1r21mbqsqGZiVYrZJlb0asL/MHt0mGLdQKX6FuZf0CsbtpRehMY0QXdCoxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763779171; c=relaxed/simple;
	bh=S5MhBjEpkRIXWb7CuzJvS8KPPQXUwQ9+CpcYi40II14=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t2ZsaLshdAUfthnHP0PAPLCXixzlGezi1trgZKQ5jDAMsNLjrELMZ4UEmxdx55zZ3pYTathGUBkPtj9afyjFKfvK6fUJvTU+PXsj4vOla4cteoiazhYNnBs/mnG/Tpv4+ykAQEjYt8xuEjPOKyYH+5mXdxI9iDS4WG9o60xEE6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C3bSo81U; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE460C19421
	for <kvm@vger.kernel.org>; Sat, 22 Nov 2025 02:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763779170;
	bh=S5MhBjEpkRIXWb7CuzJvS8KPPQXUwQ9+CpcYi40II14=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=C3bSo81Ub9+5AuJDZaiRGeBT0BmHlkRI3tHvV1Z0mO+vGQMiYV5xL5cNva6OwGFNl
	 K37QJkWt8+RESc6BOxAfSZqXe+uSJPb0xoqvcBlQE9CDOYMtpuLKWpb3NxfBAW2y5d
	 Ge7LKAKesAzBQKy1CfBjfS9ZyBhl16ZpXuwszO+tYc5ZEIxGFLfrBVJLgf9wILR0Ve
	 0W4Af4NynLYRrwl8nVPhRxZe9uGET/mD8gXQOhvWcMh2D2IzMgEjbGznW0dxWc+6gV
	 tPzZGdb96a5x9waxVh2YBIJfVI5Wlg31i3tk3wp9NwUgKqwScbqE8L8HHrDHTMJgu2
	 /Z9oPRUv8FUtw==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b7355f6ef12so564253766b.3
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:39:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWPow01a9/Q877Yt6zF0gutzmazMcZWYGmmJGXzyg68jsDTT7hPfnf8EMZJQB15IG4m6AU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0Ev9cgOKL/W5YRnDTg8R4XpivQgyE4JZj2JfU7UQD8x6cWi7t
	VwWibX8Vx+MohLt4fUZLLLxggQUwWE2htiqgPDhakabgsSHM+cdczNln1H4aqhw3w3TW9xfIcnP
	LwYgp9RlNtVd7LXO/GfpXsOcAupfYZ0w=
X-Google-Smtp-Source: AGHT+IGXGmEsVMVsrAXCqbyd//DKrhU/3oYYyuF5sSO+PvjuDqpYWQ6ntXSeVDpWj+wtf7kbva8BAM1sr1ZedISBaCc=
X-Received: by 2002:a17:907:dab:b0:b73:4fbb:37a2 with SMTP id
 a640c23a62f3a-b7671514106mr450217466b.5.1763779169176; Fri, 21 Nov 2025
 18:39:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250930093741.2734974-1-maobibo@loongson.cn>
In-Reply-To: <20250930093741.2734974-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 22 Nov 2025 10:39:20 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4AkF3pYN31ADCnMLVirDcEhMjyr+FekBz1pQ+aggh9FQ@mail.gmail.com>
X-Gm-Features: AWmQ_bkSX84detPY8GsFn078-cYShG7j0bc94PploS1gqcktqZ0VBU_MS5srXnI
Message-ID: <CAAhV-H4AkF3pYN31ADCnMLVirDcEhMjyr+FekBz1pQ+aggh9FQ@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Get VM PMU capability from HW GCFG register
To: Bibo Mao <maobibo@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied with some small changes, thanks.

Huacai

On Tue, Sep 30, 2025 at 5:37=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> Now VM PMU capability comes from host PMU capability directly, instead
> bit 23 of HW GCFG CSR register also show PMU capability for VM. It
> will be better if it comes from HW GCFG CSR register rather than host
> PMU capability, especially when LVZ function is emulated in TCG mode,
> however without PMU capability.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/kvm_host.h  |  8 +++++++
>  arch/loongarch/include/asm/loongarch.h |  2 ++
>  arch/loongarch/kvm/vm.c                | 30 +++++++++++++++++---------
>  3 files changed, 30 insertions(+), 10 deletions(-)
>
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/inclu=
de/asm/kvm_host.h
> index 0cecbd038bb3..392480c9b958 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -126,6 +126,8 @@ struct kvm_arch {
>         struct kvm_phyid_map  *phyid_map;
>         /* Enabled PV features */
>         unsigned long pv_features;
> +       /* Supported features from KVM */
> +       unsigned long support_features;
>
>         s64 time_offset;
>         struct kvm_context __percpu *vmcs;
> @@ -293,6 +295,12 @@ static inline int kvm_get_pmu_num(struct kvm_vcpu_ar=
ch *arch)
>         return (arch->cpucfg[6] & CPUCFG6_PMNUM) >> CPUCFG6_PMNUM_SHIFT;
>  }
>
> +/* Check whether KVM support this feature, however VMM may disable it */
> +static inline bool kvm_vm_support(struct kvm_arch *arch, int feature)
> +{
> +       return !!(arch->support_features & BIT_ULL(feature));
> +}
> +
>  bool kvm_arch_pmi_in_guest(struct kvm_vcpu *vcpu);
>
>  /* Debug: dump vcpu state */
> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/incl=
ude/asm/loongarch.h
> index 09dfd7eb406e..b640f8f6d7bd 100644
> --- a/arch/loongarch/include/asm/loongarch.h
> +++ b/arch/loongarch/include/asm/loongarch.h
> @@ -510,6 +510,8 @@
>  #define  CSR_GCFG_GPERF_SHIFT          24
>  #define  CSR_GCFG_GPERF_WIDTH          3
>  #define  CSR_GCFG_GPERF                        (_ULCAST_(0x7) << CSR_GCF=
G_GPERF_SHIFT)
> +#define  CSR_GCFG_GPMP_SHIFT           23
> +#define  CSR_GCFG_GPMP                 (_ULCAST_(0x1) << CSR_GCFG_GPMP_S=
HIFT)
>  #define  CSR_GCFG_GCI_SHIFT            20
>  #define  CSR_GCFG_GCI_WIDTH            2
>  #define  CSR_GCFG_GCI                  (_ULCAST_(0x3) << CSR_GCFG_GCI_SH=
IFT)
> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
> index edccfc8c9cd8..735ad20d9ea9 100644
> --- a/arch/loongarch/kvm/vm.c
> +++ b/arch/loongarch/kvm/vm.c
> @@ -6,6 +6,7 @@
>  #include <linux/kvm_host.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/kvm_vcpu.h>
> +#include <asm/kvm_csr.h>
>  #include <asm/kvm_eiointc.h>
>  #include <asm/kvm_pch_pic.h>
>
> @@ -24,6 +25,23 @@ const struct kvm_stats_header kvm_vm_stats_header =3D =
{
>                                         sizeof(kvm_vm_stats_desc),
>  };
>
> +static void kvm_vm_init_features(struct kvm *kvm)
> +{
> +       unsigned long val;
> +
> +       /* Enable all PV features by default */
> +       kvm->arch.pv_features =3D BIT(KVM_FEATURE_IPI);
> +       kvm->arch.support_features =3D BIT(KVM_LOONGARCH_VM_FEAT_PV_IPI);
> +       if (kvm_pvtime_supported()) {
> +               kvm->arch.pv_features |=3D BIT(KVM_FEATURE_STEAL_TIME);
> +               kvm->arch.support_features |=3D BIT(KVM_LOONGARCH_VM_FEAT=
_PV_STEALTIME);
> +       }
> +
> +       val =3D read_csr_gcfg();
> +       if (val & CSR_GCFG_GPMP)
> +               kvm->arch.support_features |=3D BIT(KVM_LOONGARCH_VM_FEAT=
_PMU);
> +}
> +
>  int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  {
>         int i;
> @@ -42,11 +60,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long ty=
pe)
>         spin_lock_init(&kvm->arch.phyid_map_lock);
>
>         kvm_init_vmcs(kvm);
> -
> -       /* Enable all PV features by default */
> -       kvm->arch.pv_features =3D BIT(KVM_FEATURE_IPI);
> -       if (kvm_pvtime_supported())
> -               kvm->arch.pv_features |=3D BIT(KVM_FEATURE_STEAL_TIME);
> +       kvm_vm_init_features(kvm);
>
>         /*
>          * cpu_vabits means user address space only (a half of total).
> @@ -137,13 +151,9 @@ static int kvm_vm_feature_has_attr(struct kvm *kvm, =
struct kvm_device_attr *attr
>                         return 0;
>                 return -ENXIO;
>         case KVM_LOONGARCH_VM_FEAT_PMU:
> -               if (cpu_has_pmp)
> -                       return 0;
> -               return -ENXIO;
>         case KVM_LOONGARCH_VM_FEAT_PV_IPI:
> -               return 0;
>         case KVM_LOONGARCH_VM_FEAT_PV_STEALTIME:
> -               if (kvm_pvtime_supported())
> +               if (kvm_vm_support(&kvm->arch, attr->attr))
>                         return 0;
>                 return -ENXIO;
>         default:
>
> base-commit: e5f0a698b34ed76002dc5cff3804a61c80233a7a
> --
> 2.39.3
>
>

