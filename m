Return-Path: <kvm+bounces-8137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C83B84BE11
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 20:26:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CD3B1C22926
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 19:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8DE2168BA;
	Tue,  6 Feb 2024 19:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OZgETXBM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C78A14276
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 19:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707247584; cv=none; b=Cmjp9Q8saqXeRZFMsTYeiQbCcCYDgZJlsAc/FW4xYWMMuGnyyXL4rRMi5tnn3X8bpbvAkVAFzK9/sk94bdpZnMd0DSrs3dl8fU1dX4rxFHdLA+HPdRvvwHVl+1ZBcFiibcEMZ0Jts9EW6wgKtdZBGpL+WbeHB0bs+QvPgZ0C1mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707247584; c=relaxed/simple;
	bh=2IVNfTFN74V9QsXarcsI9Qa3mRL5DTVBDrkPHn2//J4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YOZaiGSlzk33hXt1Pn0rW7TsVc1PtKrPhO9KAM0RXJ/ioXpyuBUdk9DV5sLprsHGygcqyXXx/WJJkkTDNMVi7ITCmNs592W7C8WofP3cZCodF43ihYoV/Hmojs50zw3RJXBDC7gwSJRqPI9LxyAOLcZnbzu7esqXLhZjae+5PPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OZgETXBM; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5115744dfe5so1921760e87.2
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 11:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707247580; x=1707852380; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=upl/2DpL4kPgGQe8I7dejnn2s278HRsnVm1Xw4wi8yc=;
        b=OZgETXBM/lPx2euz9TELUFVpp3POsjbLk11PxKNGTyFquQO6stNskdZ2drV6k3G9rc
         W+J2n2wnxdOE2wNE/HeaE9DR2kq9H7oLdesjSk59o0zUkHtAi9X6c7X0POk5jyQly3XE
         cvbFFa0buWVUcqhe7GWm4rdW0HHYnGPp2wzXKoCU2GDmlyonRQlsm9PtNjj2Klne+Yti
         zZiINkTYLKKCJFk7nAXNk/xiucTo6/g6Wl2mYn3Bby0QFitiir8A5vE7RIDtBYEKgy5C
         tB5fOdS4zzXF6H5snytgK7tyh+wxf2UDNCtqiosMIjITyoHlWZs6mFMZyQZ3I7nJaE+J
         6ODQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707247580; x=1707852380;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=upl/2DpL4kPgGQe8I7dejnn2s278HRsnVm1Xw4wi8yc=;
        b=CUZSs133BRhjkpavw2elgdR6Ut8k54uxALqnjoNy0frJ5FrpPq3sLXeEgZGFC/STYG
         EcS+6INrPGWwc9kEeIpJ5j6LidkUwpXib03NdR+uAIxaEj2r/UlQ937uIbL/jJhA2ZQN
         UFnnnQLCStoo+8Fq07skJlr2EGQOWbMxG/T2cdEXlxGnLPzBJBFy+FswCh0EZN1dMNCC
         xzGS7OvlMc0n/YuG4mYtkhyTBR5zGXpC15ZHZa/f32XzBbWvUAasv7yNwpR1pNixUkBq
         luH0ArBT2o+s1Zbeh5ln5djmJ/D/k/FVCn62ohnYZq9NObOfnRWQCU/3rb9CpMzz5gPq
         nizA==
X-Gm-Message-State: AOJu0Ywg6BJK9mp/iprLDbYyY1bp1ZBDGUDmDlGMOaD4vFZiLx/GYWyo
	Zfcbk8tTh3RcGHxjgj4VX5YFuyBy+RfrwpCjLVmlPtuys0y9mVe/Fnl7tRoRjoRH/gs9vOC7IAh
	YEQ6wnnbYK5DetVmOCzLiEZCsRDAdinforqE6
X-Google-Smtp-Source: AGHT+IG+tvKN/pRkaEnin+a71EeSaheXzc94ai9MnINUEVrkSa0dR8ilsgGoU4rIjkVl4x7PWjkGCyUxO5doIqdgicI=
X-Received: by 2002:a05:6512:480c:b0:511:6512:9d3e with SMTP id
 eo12-20020a056512480c00b0051165129d3emr9716lfb.33.1707247579889; Tue, 06 Feb
 2024 11:26:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1705965634.git.isaku.yamahata@intel.com> <1a64f798b550dad9e096603e8dae3b6e8fb2fbd5.1705965635.git.isaku.yamahata@intel.com>
In-Reply-To: <1a64f798b550dad9e096603e8dae3b6e8fb2fbd5.1705965635.git.isaku.yamahata@intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Tue, 6 Feb 2024 11:26:07 -0800
Message-ID: <CAAhR5DEpX1AMQ1EwFB9TsvRufZ5Cwvpx2u9xGtXU5gbQA67fxg@mail.gmail.com>
Subject: Re: [PATCH v18 063/121] KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page()
 for use by TDX
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Sean Christopherson <seanjc@google.com>, Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, 
	hang.yuan@intel.com, tina.zhang@intel.com, 
	Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 22, 2024 at 3:56=E2=80=AFPM <isaku.yamahata@intel.com> wrote:
>
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Introduce a helper to directly (pun intended) fault-in a TDP page
> without having to go through the full page fault path.  This allows
> TDX to get the resulting pfn and also allows the RET_PF_* enums to
> stay in mmu.c where they belong.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v14 -> v15:
> - Remove loop in kvm_mmu_map_tdp_page() and return error code based on
>   RET_FP_xxx value to avoid potential infinite loop.  The caller should
>   loop on -EAGAIN instead now.
> ---
>  arch/x86/kvm/mmu.h     |  3 +++
>  arch/x86/kvm/mmu/mmu.c | 57 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 60 insertions(+)
>
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index bad6a1e43a54..ebf91b605c37 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -184,6 +184,9 @@ static inline void kvm_mmu_refresh_passthrough_bits(s=
truct kvm_vcpu *vcpu,
>         __kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
>  }
>
> +int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_cod=
e,
> +                        int max_level);
> +
>  /*
>   * Check if a given access (described through the I/D, W/R and U/S bits =
of a
>   * page fault error code pfec) causes a permission fault with the given =
PTE
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7db152f46d82..26d215e85b76 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4635,6 +4635,63 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, stru=
ct kvm_page_fault *fault)
>         return direct_page_fault(vcpu, fault);
>  }
>
> +int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_cod=
e,
> +                        int max_level)
> +{
> +       int r;
> +       struct kvm_page_fault fault =3D (struct kvm_page_fault) {
> +               .addr =3D gpa,
> +               .error_code =3D error_code,
> +               .exec =3D error_code & PFERR_FETCH_MASK,
> +               .write =3D error_code & PFERR_WRITE_MASK,
> +               .present =3D error_code & PFERR_PRESENT_MASK,
> +               .rsvd =3D error_code & PFERR_RSVD_MASK,
> +               .user =3D error_code & PFERR_USER_MASK,
> +               .prefetch =3D false,
> +               .is_tdp =3D true,
> +               .is_private =3D error_code & PFERR_GUEST_ENC_MASK,
> +               .nx_huge_page_workaround_enabled =3D is_nx_huge_page_enab=
led(vcpu->kvm),
> +       };
> +
> +       WARN_ON_ONCE(!vcpu->arch.mmu->root_role.direct);
> +       fault.gfn =3D gpa_to_gfn(fault.addr) & ~kvm_gfn_shared_mask(vcpu-=
>kvm);
> +       fault.slot =3D kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
> +
> +       r =3D mmu_topup_memory_caches(vcpu, false);
> +       if (r)
> +               return r;
> +
> +       fault.max_level =3D max_level;
> +       fault.req_level =3D PG_LEVEL_4K;
> +       fault.goal_level =3D PG_LEVEL_4K;
> +
> +#ifdef CONFIG_X86_64
> +       if (tdp_mmu_enabled)
> +               r =3D kvm_tdp_mmu_page_fault(vcpu, &fault);
> +       else
> +#endif
> +               r =3D direct_page_fault(vcpu, &fault);

Are we ever going to hit the direct_page_fault case? I thought TDX
only supported tdp_mmu?

> +
> +       if (is_error_noslot_pfn(fault.pfn) || vcpu->kvm->vm_bugged)
> +               return -EFAULT;
> +
> +       switch (r) {
> +       case RET_PF_RETRY:
> +               return -EAGAIN;
> +
> +       case RET_PF_FIXED:
> +       case RET_PF_SPURIOUS:
> +               return 0;
> +
> +       case RET_PF_CONTINUE:
> +       case RET_PF_EMULATE:
> +       case RET_PF_INVALID:
> +       default:
> +               return -EIO;
> +       }
> +}
> +EXPORT_SYMBOL_GPL(kvm_mmu_map_tdp_page);
> +
>  static void nonpaging_init_context(struct kvm_mmu *context)
>  {
>         context->page_fault =3D nonpaging_page_fault;
> --
> 2.25.1
>

