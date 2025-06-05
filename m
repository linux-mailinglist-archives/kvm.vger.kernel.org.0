Return-Path: <kvm+bounces-48572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C2290ACF54A
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:21:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1DAC01888784
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 17:22:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D2992777EC;
	Thu,  5 Jun 2025 17:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="naB4+ZoJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263821EB5CE
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 17:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749144108; cv=none; b=VWDGMuR3R5TjensrvtAVm/mSQtxJH6W9Kmim5mGe5oJMi8nHjbQ4kvYV45NgkKhStiHAfPrIV5376hzGCAWD6lTjUFHUMnyXe5nyEr9jXqsOcgYrGlQF3/7y/HeNOb0PlqBOgZ+U0f7KIVhqhlx9BApOixIJxSS8/inVnd1yABM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749144108; c=relaxed/simple;
	bh=4V8L/ybUxc6FKBuceCtlDWB7oFiWSmwhpxFUgnu5AZc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y/GIPVRPsA7pjTaZngZ8prJCXxgRMufuMih8wmyecQ3+WNOomMqNHVFS0iBChyfZs6XPoLTmf7+CJBDCWjq0l9+QHNqw7dZDVgdVZDeNohW2gN4ZomEfRXXe+Adg2dF5mm8NkOWZJtnA2s8232FfT/eXnE9YJkH1zPy8cZ/gtiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=naB4+ZoJ; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-70e767ce72eso13456007b3.1
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 10:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749144105; x=1749748905; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2yuifU/GgSLJ5/xk8l2XPGXYtLOIp8EHM4xRZI56bKQ=;
        b=naB4+ZoJmBLVdYX7QT7N7mwegyQmhL0T9ApuUByhBoZBaoW7m9OhmBozPefudVpPwS
         85tYR2Lgf0D0xB4TigqqS0HiOM+mGKASsWiyUK/4wDWdy3h/blGij5PJ8V4d0sRhogp7
         UE0pWxfT1ZvCmXz4kVTOX/5LEEgSKOWjpsKKtyHtlEz8Sc2L91vnZkqoaRD/KYWlJthp
         zkzZ64Ylojlxw5eozsT298Fhe1caMfalSTj8VsiSxXIvRfRZTFZTWYRPOhuTMycQWUR/
         HKp4ZiPNpZ4GgRaXxP6zykN4kOo0A2CcHx8ycHSDPsfSftEYvXmd72Aslha08gupBbFs
         VN7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749144105; x=1749748905;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2yuifU/GgSLJ5/xk8l2XPGXYtLOIp8EHM4xRZI56bKQ=;
        b=DZHZ5n4KrgtXonbZfQcXgNpihaWEt54KLGb2DHOytS8R+kNRGoon3vsIelGMR9uVKQ
         svNBxyra/hHl2iShOSsxd5jZxLcrF9EeoMSp8U2o/OEOr+syj6fbYHdc49NJ+/kzAURx
         VjqjSAsHw/j/5odtCZmCt9sd+rOOsYqnIGvWTTcZqyVXA6AD3WGz00ZklFXachPerJ1w
         7Y8go9kzol5ysVEc9shghZr51mSC7sl+K+zl+5fuZAnw48Wv+ffBoeVoLMEUoM1g0oB6
         6IRutC1fmhDfBCF9EuD9q8vy9UKl6xnId9d/6fxaQqrM2xMrIQHvMfXBZjOydIi0QJ5s
         oCmw==
X-Gm-Message-State: AOJu0Yz1V6OPh8UV7ozZWseaLbosk5DI00BedhzG8dvHWkXZFzZocYup
	ebb2SVk420XWu7t8ctvY/fwxlkO476x0554nD6FLD3Lj0KCey1zgL3Oylzb1jnTPlKyNdrVQb6M
	LjobdpSbABbXM1ANSAXbng59l9+Dn//JJFu9kPakG
X-Gm-Gg: ASbGncu9h1LZvQ6HVgJY56kaDzlWmC2fhBWKTnKHUoM2LkPytlgv2fZmwXsdRG95LFD
	9CpNOWcHSFA+fkTibCCZNBLBg3HabaZMUPPKiuaCW/aQ48CxbJmYassbF25kD5TwLac1qeJZj4g
	Tn3m/hKe5BQYEAXqEfdF9Rb/xF0p4VATWzcHdmWepTppxNMe4gctXvLGfQMkycU/V4beqbIDdDV
	g==
X-Google-Smtp-Source: AGHT+IG2aMH3e/VGttY3DUFTtqo9ReBTemdadVuiwwnclWCr3bQrzFUxeGlMD9zJC2ioENrYKFR0XA2p1e9mvSbrCnY=
X-Received: by 2002:a05:6902:1142:b0:e81:793e:ff49 with SMTP id
 3f1490d57ef6-e81a2276d76mr813113276.7.1749144104655; Thu, 05 Jun 2025
 10:21:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-15-tabba@google.com>
In-Reply-To: <20250605153800.557144-15-tabba@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 5 Jun 2025 10:21:07 -0700
X-Gm-Features: AX0GCFs89UiAUdqi87KLx3EqbaAtmlmJBJ8iGKLNvJzc0pcWTcavyJKD8TjotMU
Message-ID: <CADrL8HVtsJugNRgzgyiOwpOtSAi4iz3LNcjt8kDinUp99jWyYw@mail.gmail.com>
Subject: Re: [PATCH v11 14/18] KVM: arm64: Handle guest_memfd-backed guest
 page faults
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 5, 2025 at 8:38=E2=80=AFAM Fuad Tabba <tabba@google.com> wrote:
>
> Add arm64 support for handling guest page faults on guest_memfd backed
> memslots. Until guest_memfd supports huge pages, the fault granule is
> restricted to PAGE_SIZE.
>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Hi Fuad, sorry for not getting back to you on v10. I like this patch
much better than the v9 version, thank you! Some small notes below.

> ---
>  arch/arm64/kvm/mmu.c | 93 ++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 90 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index ce80be116a30..f14925fe6144 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1508,6 +1508,89 @@ static void adjust_nested_fault_perms(struct kvm_s=
2_trans *nested,
>         *prot |=3D kvm_encode_nested_level(nested);
>  }
>
> +#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT |=
 KVM_PGTABLE_WALK_SHARED)
> +
> +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> +                     struct kvm_s2_trans *nested,
> +                     struct kvm_memory_slot *memslot, bool is_perm)
> +{
> +       bool logging, write_fault, exec_fault, writable;
> +       enum kvm_pgtable_walk_flags flags =3D KVM_PGTABLE_WALK_MEMABORT_F=
LAGS;
> +       enum kvm_pgtable_prot prot =3D KVM_PGTABLE_PROT_R;
> +       struct kvm_pgtable *pgt =3D vcpu->arch.hw_mmu->pgt;
> +       struct page *page;
> +       struct kvm *kvm =3D vcpu->kvm;
> +       void *memcache;
> +       kvm_pfn_t pfn;
> +       gfn_t gfn;
> +       int ret;
> +
> +       ret =3D prepare_mmu_memcache(vcpu, !is_perm, &memcache);
> +       if (ret)
> +               return ret;
> +
> +       if (nested)
> +               gfn =3D kvm_s2_trans_output(nested) >> PAGE_SHIFT;
> +       else
> +               gfn =3D fault_ipa >> PAGE_SHIFT;
> +
> +       logging =3D memslot_is_logging(memslot);

AFAICT, `logging` will always be `false` for now, so we can simplify
this function quite a bit. And IMHO, it *should* be simplified, as it
cannot be tested.

> +       write_fault =3D kvm_is_write_fault(vcpu);
> +       exec_fault =3D kvm_vcpu_trap_is_exec_fault(vcpu);
> +
> +       if (write_fault && exec_fault) {
> +               kvm_err("Simultaneous write and execution fault\n");
> +               return -EFAULT;
> +       }
> +
> +       if (is_perm && !write_fault && !exec_fault) {
> +               kvm_err("Unexpected L2 read permission error\n");
> +               return -EFAULT;
> +       }

I think, ideally, these above checks should be put into a separate
function and shared with user_mem_abort(). (The VM_BUG_ON(write_fault
&& exec_fault) that user_mem_abort() does seems fine to me, I don't see a
real need to change it to -EFAULT.)

> +
> +       ret =3D kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
> +       if (ret) {
> +               kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
> +                                             write_fault, exec_fault, fa=
lse);
> +               return ret;
> +       }
> +
> +       writable =3D !(memslot->flags & KVM_MEM_READONLY) &&
> +                  (!logging || write_fault);
> +
> +       if (nested)
> +               adjust_nested_fault_perms(nested, &prot, &writable);
> +
> +       if (writable)
> +               prot |=3D KVM_PGTABLE_PROT_W;
> +
> +       if (exec_fault ||
> +           (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
> +            (!nested || kvm_s2_trans_executable(nested))))
> +               prot |=3D KVM_PGTABLE_PROT_X;
> +
> +       kvm_fault_lock(kvm);
> +       if (is_perm) {
> +               /*
> +                * Drop the SW bits in favour of those stored in the
> +                * PTE, which will be preserved.
> +                */
> +               prot &=3D ~KVM_NV_GUEST_MAP_SZ;
> +               ret =3D KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, f=
ault_ipa, prot, flags);

I think you should drop this `is_perm` path, as it is an optimization
for dirty logging, which we don't currently do. :)

When we want to add dirty logging support, we probably ought to move
this mapping code (the lines kvm_fault_lock() and kvm_fault_unlock())
into its own function and share it with user_mem_abort().

> +       } else {
> +               ret =3D KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa=
, PAGE_SIZE,
> +                                            __pfn_to_phys(pfn), prot,
> +                                            memcache, flags);
> +       }
> +       kvm_release_faultin_page(kvm, page, !!ret, writable);
> +       kvm_fault_unlock(kvm);
> +
> +       if (writable && !ret)
> +               mark_page_dirty_in_slot(kvm, memslot, gfn);
> +
> +       return ret !=3D -EAGAIN ? ret : 0;
> +}
> +
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                           struct kvm_s2_trans *nested,
>                           struct kvm_memory_slot *memslot, unsigned long =
hva,
> @@ -1532,7 +1615,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
>         enum kvm_pgtable_prot prot =3D KVM_PGTABLE_PROT_R;
>         struct kvm_pgtable *pgt;
>         struct page *page;
> -       enum kvm_pgtable_walk_flags flags =3D KVM_PGTABLE_WALK_HANDLE_FAU=
LT | KVM_PGTABLE_WALK_SHARED;
> +       enum kvm_pgtable_walk_flags flags =3D KVM_PGTABLE_WALK_MEMABORT_F=
LAGS;
>
>         if (fault_is_perm)
>                 fault_granule =3D kvm_vcpu_trap_get_perm_fault_granule(vc=
pu);
> @@ -1959,8 +2042,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>                 goto out_unlock;
>         }
>
> -       ret =3D user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
> -                            esr_fsc_is_permission_fault(esr));
> +       if (kvm_slot_has_gmem(memslot))
> +               ret =3D gmem_abort(vcpu, fault_ipa, nested, memslot,
> +                                esr_fsc_is_permission_fault(esr));
> +       else
> +               ret =3D user_mem_abort(vcpu, fault_ipa, nested, memslot, =
hva,
> +                                    esr_fsc_is_permission_fault(esr));

I like this split! Thank you!


>         if (ret =3D=3D 0)
>                 ret =3D 1;
>  out:
> --
> 2.49.0.1266.g31b7d2e469-goog
>

