Return-Path: <kvm+bounces-32881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D798F9E1170
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 03:46:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D3B7B22B4E
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 02:46:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 013231547F0;
	Tue,  3 Dec 2024 02:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HwFRtTk1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8ED537E9;
	Tue,  3 Dec 2024 02:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733194007; cv=none; b=RvJlZRExT3VCe2wrC6ozAY6eSsR1yGikiOCwDj8g9zlP52avvJkMR4VH2CrK9ic941SHgQT8jysz5ruonI6+9ogOZCkYyrI2rom6mtn2QGqLuY2Vvs/1ZyK1CmxBQwE5yVo3y2MYzTtZ1Wfse6YKNdIPJZtBSPMgeHnbobwVOYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733194007; c=relaxed/simple;
	bh=xKVi89L7ac97ndmNAqbzFdCpSOEK1iUEUOiBRblPYRY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kGvow3+1oQGdhRiaMDSnFS6Qqky8O/QaRY1H6bdx/4TzAo110bE4AiM0tRrh75h5TnCGm9gAt5ZSSPyK/0gxxsXHN0B9kDAm7Ea08gB5+hYvRkQeNF23ov0jmHQshT/c/XI8pLYn489eQKD01nbhc02cweOuGQHJEZVbYZu20pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HwFRtTk1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79AEC4CED1;
	Tue,  3 Dec 2024 02:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733194006;
	bh=xKVi89L7ac97ndmNAqbzFdCpSOEK1iUEUOiBRblPYRY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HwFRtTk1IoYjYHIbn7+eV/HRil7AKrqIVrAPBhNekz8zvS5/5BXcAEgMMhnx0hCWx
	 q59YYBmu/ZTHc1lqhGFvRQRsK/F15c2AiAUK4Mjvts2yM3FPBuq3Zz8bCp7LviF810
	 0vZEL1iIY/Tcmamh62bE1TENsbdwZ4XtJkdpAh0cslyuxZ6VvAyAVnI2S37LAntEHY
	 dtt96/t10AVYqFWzpWt3/bLLWsTgsoH7VrgHTl/4ZE4vdw3Jm/gOVBUSEBWcuTR9iz
	 c/Pepc3NHYadFyXme032efVQPzWA1s+C6ZzP/FG16QxIZu829C/N7wcSqNFaDWFR/q
	 c61t+V7q7z0Ww==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aa51b8c5f4dso717391566b.2;
        Mon, 02 Dec 2024 18:46:46 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUP+FTmWtSUrYkcHByMvuz9sRwLV5T6c5tePKUCxuwdRhnkaP62sLDKFEiyI+XCIppwXNo=@vger.kernel.org, AJvYcCWtmIkrseG/GDbmHQ2ugcr8elo+RiFuNeYweFl5ixD7wy1sk+uyUmrUU9pz4ZLru43X9FakXnENMxeC/g5w@vger.kernel.org
X-Gm-Message-State: AOJu0YzcmR62A8xuWlnvRvE4mKWvyZHiy3dsimvsomoVJTMc1qwl3ujr
	FqDHKZqQYKMvlDj1LDWb0XvgkSSPNMhqtK9zmUTkg9sIxQ0X6VDPSjyDVjla4nE6qCyeB5OBnaB
	KGvdpyo2ul4W09IuWN7lBQH5XlBo=
X-Google-Smtp-Source: AGHT+IHfHqhhI01QfIKaZT2stl6foHnCHZqWTf1mI7OIlldIoAaFVcU+D3Ifb02BBONWPt4DcGk65bbdyw9cFwCh+lg=
X-Received: by 2002:a17:906:4c2:b0:aa5:4672:663b with SMTP id
 a640c23a62f3a-aa5f7f2ba80mr37338566b.55.1733194005376; Mon, 02 Dec 2024
 18:46:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241113031727.2815628-1-maobibo@loongson.cn> <20241113031727.2815628-2-maobibo@loongson.cn>
In-Reply-To: <20241113031727.2815628-2-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 3 Dec 2024 10:46:36 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5PoitK=a_snYA=PjDoZxWT5QcbrJfnMe3DJGXN=J0tZA@mail.gmail.com>
Message-ID: <CAAhV-H5PoitK=a_snYA=PjDoZxWT5QcbrJfnMe3DJGXN=J0tZA@mail.gmail.com>
Subject: Re: [RFC 1/5] LoongArch: KVM: Add vmid support for stage2 MMU
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Wed, Nov 13, 2024 at 11:17=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
te:
>
> LoongArch KVM hypervisor supports two-level MMU, vpid index is used
> for stage1 MMU and vmid index is used for stage2 MMU.
>
> On 3A5000, vmid must be the same with vpid. On 3A6000 platform vmid
> may separate from vpid. If vcpu migrate to different physical CPUs,
> vpid need change however vmid can keep the same with old value. Also
> vmid index of the while VM machine on physical CPU the same, all vCPUs
> on the VM can share the same vmid index on one physical CPU.
>
> Here vmid index is added and it keeps the same with vpid still.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/kvm_host.h | 3 +++
>  arch/loongarch/kernel/asm-offsets.c   | 1 +
>  arch/loongarch/kvm/main.c             | 1 +
>  arch/loongarch/kvm/switch.S           | 5 ++---
>  arch/loongarch/kvm/tlb.c              | 5 ++++-
>  5 files changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/inclu=
de/asm/kvm_host.h
> index d6bb72424027..6151c7c470d5 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -166,6 +166,9 @@ struct kvm_vcpu_arch {
>         unsigned long host_tp;
>         unsigned long host_pgd;
>
> +       /* vmid info for guest VM */
> +       unsigned long vmid;
vmid is a member of kvm_vcpu_arch, no of kvm_arch?

> +
>         /* Host CSRs are used when handling exits from guest */
>         unsigned long badi;
>         unsigned long badv;
> diff --git a/arch/loongarch/kernel/asm-offsets.c b/arch/loongarch/kernel/=
asm-offsets.c
> index bee9f7a3108f..4e9a9311afd3 100644
> --- a/arch/loongarch/kernel/asm-offsets.c
> +++ b/arch/loongarch/kernel/asm-offsets.c
> @@ -307,6 +307,7 @@ static void __used output_kvm_defines(void)
>         OFFSET(KVM_ARCH_HSP, kvm_vcpu_arch, host_sp);
>         OFFSET(KVM_ARCH_HTP, kvm_vcpu_arch, host_tp);
>         OFFSET(KVM_ARCH_HPGD, kvm_vcpu_arch, host_pgd);
> +       OFFSET(KVM_ARCH_VMID, kvm_vcpu_arch, vmid);
>         OFFSET(KVM_ARCH_HANDLE_EXIT, kvm_vcpu_arch, handle_exit);
>         OFFSET(KVM_ARCH_HEENTRY, kvm_vcpu_arch, host_eentry);
>         OFFSET(KVM_ARCH_GEENTRY, kvm_vcpu_arch, guest_eentry);
> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> index 27e9b94c0a0b..8c16bff80053 100644
> --- a/arch/loongarch/kvm/main.c
> +++ b/arch/loongarch/kvm/main.c
> @@ -212,6 +212,7 @@ static void kvm_update_vpid(struct kvm_vcpu *vcpu, in=
t cpu)
>
>         context->vpid_cache =3D vpid;
>         vcpu->arch.vpid =3D vpid;
I think vpid should also be:
           vcpu->arch.vpid =3D vpid & vpid_mask;

Huacai

> +       vcpu->arch.vmid =3D vcpu->arch.vpid & vpid_mask;
>  }
>
>  void kvm_check_vpid(struct kvm_vcpu *vcpu)
> diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
> index 0c292f818492..2774343f64d3 100644
> --- a/arch/loongarch/kvm/switch.S
> +++ b/arch/loongarch/kvm/switch.S
> @@ -72,9 +72,8 @@
>         ldx.d   t0, t1, t0
>         csrwr   t0, LOONGARCH_CSR_PGDL
>
> -       /* Mix GID and RID */
> -       csrrd           t1, LOONGARCH_CSR_GSTAT
> -       bstrpick.w      t1, t1, CSR_GSTAT_GID_SHIFT_END, CSR_GSTAT_GID_SH=
IFT
> +       /* Set VMID for gpa --> hpa mapping */
> +       ld.d            t1, a2, KVM_ARCH_VMID
>         csrrd           t0, LOONGARCH_CSR_GTLBC
>         bstrins.w       t0, t1, CSR_GTLBC_TGID_SHIFT_END, CSR_GTLBC_TGID_=
SHIFT
>         csrwr           t0, LOONGARCH_CSR_GTLBC
> diff --git a/arch/loongarch/kvm/tlb.c b/arch/loongarch/kvm/tlb.c
> index ebdbe9264e9c..38daf936021d 100644
> --- a/arch/loongarch/kvm/tlb.c
> +++ b/arch/loongarch/kvm/tlb.c
> @@ -23,7 +23,10 @@ void kvm_flush_tlb_all(void)
>
>  void kvm_flush_tlb_gpa(struct kvm_vcpu *vcpu, unsigned long gpa)
>  {
> +       unsigned int vmid;
> +
>         lockdep_assert_irqs_disabled();
>         gpa &=3D (PAGE_MASK << 1);
> -       invtlb(INVTLB_GID_ADDR, read_csr_gstat() & CSR_GSTAT_GID, gpa);
> +       vmid =3D (vcpu->arch.vmid << CSR_GSTAT_GID_SHIFT) & CSR_GSTAT_GID=
;
> +       invtlb(INVTLB_GID_ADDR, vmid, gpa);
>  }
> --
> 2.39.3
>

