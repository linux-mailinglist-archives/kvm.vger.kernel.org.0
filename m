Return-Path: <kvm+bounces-20329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AD0A69138D4
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2024 09:54:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D8D92B213B2
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2024 07:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C3695EE97;
	Sun, 23 Jun 2024 07:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fjzVTtlN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E61A1EB25;
	Sun, 23 Jun 2024 07:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719129280; cv=none; b=Rn14AzdQOnYrYH7bV3cIXSyOGLpf1RY+sRMelYE724Hx3S/G8pBfOKBMxGisg4lQa1ECgPHCJ8E5tllMzmcuX+ChW/tqTwHkPO7UInJWF3g62woUWZHBLABRWE4qiZo2o0aYJ0xrJtRQqsV5zc8HgclECBdR/RaUe7/bn27C1Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719129280; c=relaxed/simple;
	bh=ThHtxcaKKJwtVm2xy20agXL0ZX0dERp9fOWFUzR3UYE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KinioCwlc6IyDdeS4/OxS41RCb+zGavjGSHItwIUUmpoeIjWEye4UNPw+4mFI+BPrA9FnSk4peYoupov0W4eeAvgALYc938HpI6fwTzTajfXhD4DeKSOUVAatl9NTpi7fWxMBsSdyhs91rsXwpvus60QWvDhY6WRKs4FEUFW9Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fjzVTtlN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F50C4AF07;
	Sun, 23 Jun 2024 07:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719129280;
	bh=ThHtxcaKKJwtVm2xy20agXL0ZX0dERp9fOWFUzR3UYE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fjzVTtlNvcqEcEWoI7PTcgEaP05YEThGRVzHIK+T6emDKWo8EkJMekvfW1cPoYFya
	 vjydGf3Sd/2ZstS/C+7waFpTNrcI9NLsxjhQ/TfsKeFgC11WZshIyQBblMP/omiNzQ
	 XZ5jTNGITRb+QC4fg8u65nSUzvtELaA43wyItCiOVr6+i/5J23dUZeR0MwIyZGcbW6
	 I/U23FwBgitUtHKhx0SEPU9vAwQP1de4tYhKcpNpOQ4PQHJ8F+Ab7J4041O3kIEhlg
	 Fl00t73NSaZwRKFIycU5UqHxhqKk1V01IFCH9J7Bw6IshO9DGUYqpImBcL0fYHBm07
	 7PWIUpGJ8oJHQ==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a724e067017so13570166b.0;
        Sun, 23 Jun 2024 00:54:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWCu1Mn3BwTONovQFrHaRjkDrhNk+5zHW+K7hoWZNOGv9Zy7mrEA2ZexGPBDkXC4OEtci/YEaxGx5z98J7qE3WA7gmxSQ5y0LnwpdDGlAtm9uz9LKMS8ovQ3DieYle6awIw
X-Gm-Message-State: AOJu0Yz9trxsiI8QhxeMKcDT9a3w5e9CeEvEN01J71/ktY9f9K8a0FdD
	6lmtGp9N2Qd6fyhKB0L7nZ+KtB27q1GmwK5iKnG75mVZoxIYSYCI9TUZl+1KQ6I3GL5YgyaCWH9
	dPmMgLgKrotCGlFKu5Lbe1RpEl9c=
X-Google-Smtp-Source: AGHT+IGdC1A4u0QMdJ5YUs7riJv01FR+EPkPDRGgR5UUavmgBTFDjQAr6hX4Lj47/t24hlDFWdbZw/JP6EbumzLYr88=
X-Received: by 2002:a17:906:81b:b0:a6f:cf64:a5d9 with SMTP id
 a640c23a62f3a-a7245c483a1mr76829066b.49.1719129278558; Sun, 23 Jun 2024
 00:54:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240619080940.2690756-1-maobibo@loongson.cn> <20240619080940.2690756-2-maobibo@loongson.cn>
In-Reply-To: <20240619080940.2690756-2-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 23 Jun 2024 15:54:26 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7zF7zDZQ0tHtZndTmWDteaV=nAwXL3Q1P2zcJssVt7tA@mail.gmail.com>
Message-ID: <CAAhV-H7zF7zDZQ0tHtZndTmWDteaV=nAwXL3Q1P2zcJssVt7tA@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] LoongArch: KVM: Delay secondary mmu tlb flush
 until guest entry
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, 
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Wed, Jun 19, 2024 at 4:09=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> If there is page fault for secondary mmu, there needs tlb flush
What does "secondary mmu" in this context mean? Maybe "guest mmu"?

Huacai

> operation indexed with fault gpa address and VMID. VMID is stored
> at register CSR_GSTAT and will be reload or recalculated during
> guest entry.
>
> Currently CSR_GSTAT is not saved and restored during vcpu context
> switch, it is recalculated during guest entry. So CSR_GSTAT is in
> effect only when vcpu runs in guest mode, however it may be not in
> effected if vcpu exits to host mode, since register CSR_GSTAT may
> be stale, it maybe records VMID of last scheduled vcpu, rather than
> current vcpu.
>
> Function kvm_flush_tlb_gpa() should be called with its real VMID,
> here move it to guest entrance. Also arch specific request id
> KVM_REQ_TLB_FLUSH_GPA is added to flush tlb, and it can be optimized
> if VMID is updated, since all guest tlb entries will be invalid if
> VMID is updated.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/kvm_host.h |  2 ++
>  arch/loongarch/kvm/main.c             |  1 +
>  arch/loongarch/kvm/mmu.c              |  4 ++--
>  arch/loongarch/kvm/tlb.c              |  5 +----
>  arch/loongarch/kvm/vcpu.c             | 18 ++++++++++++++++++
>  5 files changed, 24 insertions(+), 6 deletions(-)
>
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/inclu=
de/asm/kvm_host.h
> index c87b6ea0ec47..32c4948f534f 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -30,6 +30,7 @@
>  #define KVM_PRIVATE_MEM_SLOTS          0
>
>  #define KVM_HALT_POLL_NS_DEFAULT       500000
> +#define KVM_REQ_TLB_FLUSH_GPA          KVM_ARCH_REQ(0)
>
>  #define KVM_GUESTDBG_SW_BP_MASK                \
>         (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP)
> @@ -190,6 +191,7 @@ struct kvm_vcpu_arch {
>
>         /* vcpu's vpid */
>         u64 vpid;
> +       gpa_t flush_gpa;
>
>         /* Frequency of stable timer in Hz */
>         u64 timer_mhz;
> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> index 86a2f2d0cb27..844736b99d38 100644
> --- a/arch/loongarch/kvm/main.c
> +++ b/arch/loongarch/kvm/main.c
> @@ -242,6 +242,7 @@ void kvm_check_vpid(struct kvm_vcpu *vcpu)
>                 kvm_update_vpid(vcpu, cpu);
>                 trace_kvm_vpid_change(vcpu, vcpu->arch.vpid);
>                 vcpu->cpu =3D cpu;
> +               kvm_clear_request(KVM_REQ_TLB_FLUSH_GPA, vcpu);
>         }
>
>         /* Restore GSTAT(0x50).vpid */
> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> index 98883aa23ab8..9e39d28fec35 100644
> --- a/arch/loongarch/kvm/mmu.c
> +++ b/arch/loongarch/kvm/mmu.c
> @@ -908,8 +908,8 @@ int kvm_handle_mm_fault(struct kvm_vcpu *vcpu, unsign=
ed long gpa, bool write)
>                 return ret;
>
>         /* Invalidate this entry in the TLB */
> -       kvm_flush_tlb_gpa(vcpu, gpa);
> -
> +       vcpu->arch.flush_gpa =3D gpa;
> +       kvm_make_request(KVM_REQ_TLB_FLUSH_GPA, vcpu);
>         return 0;
>  }
>
> diff --git a/arch/loongarch/kvm/tlb.c b/arch/loongarch/kvm/tlb.c
> index 02535df6b51f..ebdbe9264e9c 100644
> --- a/arch/loongarch/kvm/tlb.c
> +++ b/arch/loongarch/kvm/tlb.c
> @@ -23,10 +23,7 @@ void kvm_flush_tlb_all(void)
>
>  void kvm_flush_tlb_gpa(struct kvm_vcpu *vcpu, unsigned long gpa)
>  {
> -       unsigned long flags;
> -
> -       local_irq_save(flags);
> +       lockdep_assert_irqs_disabled();
>         gpa &=3D (PAGE_MASK << 1);
>         invtlb(INVTLB_GID_ADDR, read_csr_gstat() & CSR_GSTAT_GID, gpa);
> -       local_irq_restore(flags);
>  }
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 9e8030d45129..b747bd8bc037 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -51,6 +51,16 @@ static int kvm_check_requests(struct kvm_vcpu *vcpu)
>         return RESUME_GUEST;
>  }
>
> +static void kvm_late_check_requests(struct kvm_vcpu *vcpu)
> +{
> +       lockdep_assert_irqs_disabled();
> +       if (kvm_check_request(KVM_REQ_TLB_FLUSH_GPA, vcpu))
> +               if (vcpu->arch.flush_gpa !=3D INVALID_GPA) {
> +                       kvm_flush_tlb_gpa(vcpu, vcpu->arch.flush_gpa);
> +                       vcpu->arch.flush_gpa =3D INVALID_GPA;
> +               }
> +}
> +
>  /*
>   * Check and handle pending signal and vCPU requests etc
>   * Run with irq enabled and preempt enabled
> @@ -101,6 +111,13 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu=
)
>                 /* Make sure the vcpu mode has been written */
>                 smp_store_mb(vcpu->mode, IN_GUEST_MODE);
>                 kvm_check_vpid(vcpu);
> +
> +               /*
> +                * Called after function kvm_check_vpid()
> +                * Since it updates csr_gstat used by kvm_flush_tlb_gpa()=
,
> +                * also it may clear KVM_REQ_TLB_FLUSH_GPA pending bit
> +                */
> +               kvm_late_check_requests(vcpu);
>                 vcpu->arch.host_eentry =3D csr_read64(LOONGARCH_CSR_EENTR=
Y);
>                 /* Clear KVM_LARCH_SWCSR_LATEST as CSR will change when e=
nter guest */
>                 vcpu->arch.aux_inuse &=3D ~KVM_LARCH_SWCSR_LATEST;
> @@ -994,6 +1011,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         struct loongarch_csrs *csr;
>
>         vcpu->arch.vpid =3D 0;
> +       vcpu->arch.flush_gpa =3D INVALID_GPA;
>
>         hrtimer_init(&vcpu->arch.swtimer, CLOCK_MONOTONIC, HRTIMER_MODE_A=
BS_PINNED);
>         vcpu->arch.swtimer.function =3D kvm_swtimer_wakeup;
> --
> 2.39.3
>

