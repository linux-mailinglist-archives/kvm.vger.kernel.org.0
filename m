Return-Path: <kvm+bounces-44623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7617CA9FE33
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 02:17:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C670A480353
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 00:17:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B3C613AC1;
	Tue, 29 Apr 2025 00:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TmGN4vtA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23CA1876
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 00:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745885851; cv=none; b=rUidTxM6tJh1MNbk8IvaAEeMT0ncsq6HP3eOvqW3W0Ay0Za1/xwQAo5glQwtQkb0pu4f6A3tSbYaLDJEKVwno/C+qkTrTnFd+F7Z+gVnBdn0QbMAvHN/7VY22IU9aZlLTnYnXoeHgPLi4EUFqlFGJVzG+JF1xz5QX8kOR9NW2Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745885851; c=relaxed/simple;
	bh=TtAdh5uY0NHkP/lALeKaJpFQ62xkU8WosA70diPZrN0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rp0q/8kNe6E8r/DtN9glMwIxBc/pMz34KFfVZ0wGej3zzyu1TI0Qhd7GSHGfFIDrW5D8DVzYE/Yh5TijS0R5w4meiBN1V/ei7lmOT3tmlfjmhHsay/1WLOzF7A6woOMBBYHp6YO160675pl6QsZADLBTb/Kt7uRO0v9g0vyyJ6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TmGN4vtA; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2240aad70f2so29685ad.0
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 17:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745885849; x=1746490649; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TDzm1+qfTVZiBRlIx1GDSrpJfd8MWZVsRapkAUH1tFw=;
        b=TmGN4vtANZJ6EGF77wvyCZSaELMlKA6nIdBQkyNDD1Nyci+E7FS9rD7ZJ/1P05v/Hr
         yuiMd94JBpgTqN9pddvZTniyD2N7cEaMvpJX3oGzgrRQJZXkAXwvBFUF5PM8fSJBX2LB
         VrSxevk2HszB2lL11eI5IuW2i0Nkwq7h+fNa+HUNf9iCf1KUyyzJ1KwIHCh93lQeVscs
         2+0Ih3d1uIqs+h0NzT0TQACepzVq8iJV3vNfyReCdc0O9ROSxkl6vuOyJrfxv5KdNGWb
         pXOjGfciBOG+BWyfqtW4iZ8raEuWyQ7BcPC43sow16VAE8MZmhKtu0O+kAqtUlU8/JO1
         Bv/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745885849; x=1746490649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TDzm1+qfTVZiBRlIx1GDSrpJfd8MWZVsRapkAUH1tFw=;
        b=NUCEWnJZ1HKPzQ4cdlM1tk2SqiYjPCFJ4uNG2GfyjKAQFpR8+k1rlYvlCWemZa6PYb
         FuBjfGwfjXdokX3SQNdwsshOkaKqFTryr7UqvaTMxOLTWYzJihAq29K+cYdiUXGnmOx5
         4sW67AFHHO+IWfezIRN2Ys3d93DK/0b2//Xw6cTPOWL/cDRKY8cknvQyHzPfu4fspaB+
         tfLCWMEsOfiACku+DWqB7Bs/Wi7RNeh0PsXmYEsaGAErBtA6zvewbTl9+kIr24g98HTW
         lTXkgckV3zYtss+0LBZavdH8jFrT0so7eRj2Y3JkCtlSEsNvhDC6H/Jkjq8sChZMhf+c
         p6lQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlhz+2eYX9pjxtV+G0VkzXRy2LxnpyI9OKaCBNlfnY0DVlIgNCYekoVaSB1UbDBO+YUFo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJDkJUWP9KjFbCNFlQvG6jH9poYD0lT3AszimInZlmzCRa+eXJ
	wTHxoH7GjKm1up1PyiMF7Fc27ZJJkaJVcG3oZM32QJOrbFxDlNNtRE6XALodmiLU0MZ2oi1NLqT
	nqMoAV/j8rygzYrXwLzsGaCzBB8I/0pzberWx
X-Gm-Gg: ASbGncsL0Fv7y7/m4IY3wq8/cit2ASXcZpZnG6lssXmxuSavu7ZWf6SsEg9D+9lU0dk
	Uz5oztWdTEh1nb3qcxzW8Q+Pi4ADMEpI7hLU8A+Gkp+RFHZL/InDXhJiu9ttUUHCBwAFMX/Q7+L
	ItUDrRDWFfwjsCg7ndlbvykVrPV1SrvmIkgLfYQo7O+Hp86iESAza2
X-Google-Smtp-Source: AGHT+IE7qWnuEGtb81GXmfyxZl0tPexDAgZBRBoxZQ1fhAS2GP/GynpROlpisZ0kYH4Rw0V3i1mzxf8qevFi3335i6A=
X-Received: by 2002:a17:903:2b0b:b0:220:ce33:6385 with SMTP id
 d9443c01a7336-22de85f7039mr817705ad.9.1745885848664; Mon, 28 Apr 2025
 17:17:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250424030033.32635-1-yan.y.zhao@intel.com> <20250424030603.329-1-yan.y.zhao@intel.com>
In-Reply-To: <20250424030603.329-1-yan.y.zhao@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 28 Apr 2025 17:17:16 -0700
X-Gm-Features: ATxdqUGeL8ypFUSsnqhfPgI5DME3qp0DSapIk65oBkLUIZ_2uMEylH3Tqvzx8cM
Message-ID: <CAGtprH9_McMDepbuvWMLRvHooPdtE4RHog=Dgr_zFXT5s49nXA@mail.gmail.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	dave.hansen@intel.com, kirill.shutemov@intel.com, tabba@google.com, 
	ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, 
	david@redhat.com, vbabka@suse.cz, jroedel@suse.de, thomas.lendacky@amd.com, 
	pgonda@google.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, ira.weiny@intel.com, isaku.yamahata@intel.com, 
	xiaoyao.li@intel.com, binbin.wu@linux.intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2025 at 8:07=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wro=
te:
>
> Increase folio ref count before mapping a private page, and decrease
> folio ref count after a mapping failure or successfully removing a privat=
e
> page.
>
> The folio ref count to inc/dec corresponds to the mapping/unmapping level=
,
> ensuring the folio ref count remains balanced after entry splitting or
> merging.
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 355b21fc169f..e23dce59fc72 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1501,9 +1501,9 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t =
root_hpa, int pgd_level)
>         td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
>  }
>
> -static void tdx_unpin(struct kvm *kvm, struct page *page)
> +static void tdx_unpin(struct kvm *kvm, struct page *page, int level)
>  {
> -       put_page(page);
> +       folio_put_refs(page_folio(page), KVM_PAGES_PER_HPAGE(level));
>  }
>
>  static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
> @@ -1517,13 +1517,13 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_=
t gfn,
>
>         err =3D tdh_mem_page_aug(&kvm_tdx->td, gpa, tdx_level, page, &ent=
ry, &level_state);
>         if (unlikely(tdx_operand_busy(err))) {
> -               tdx_unpin(kvm, page);
> +               tdx_unpin(kvm, page, level);
>                 return -EBUSY;
>         }
>
>         if (KVM_BUG_ON(err, kvm)) {
>                 pr_tdx_error_2(TDH_MEM_PAGE_AUG, err, entry, level_state)=
;
> -               tdx_unpin(kvm, page);
> +               tdx_unpin(kvm, page, level);
>                 return -EIO;
>         }
>
> @@ -1570,10 +1570,11 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gf=
n_t gfn,
>          * a_ops->migrate_folio (yet), no callback is triggered for KVM o=
n page
>          * migration.  Until guest_memfd supports page migration, prevent=
 page
>          * migration.
> -        * TODO: Once guest_memfd introduces callback on page migration,
> -        * implement it and remove get_page/put_page().
> +        * TODO: To support in-place-conversion in gmem in futre, remove
> +        * folio_ref_add()/folio_put_refs().

With necessary infrastructure in guest_memfd [1] to prevent page
migration, is it necessary to acquire extra folio refcounts? If not,
why not just cleanup this logic now?

[1] https://git.kernel.org/pub/scm/virt/kvm/kvm.git/tree/virt/kvm/guest_mem=
fd.c?h=3Dkvm-coco-queue#n441

> Only increase the folio ref count
> +        * when there're errors during removing private pages.
>          */
> -       get_page(page);
> +       folio_ref_add(page_folio(page), KVM_PAGES_PER_HPAGE(level));
>
>         /*
>          * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
> @@ -1647,7 +1648,7 @@ static int tdx_sept_drop_private_spte(struct kvm *k=
vm, gfn_t gfn,
>                 return -EIO;
>
>         tdx_clear_page(page, level);
> -       tdx_unpin(kvm, page);
> +       tdx_unpin(kvm, page, level);
>         return 0;
>  }
>
> @@ -1727,7 +1728,7 @@ static int tdx_sept_zap_private_spte(struct kvm *kv=
m, gfn_t gfn,
>         if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level)=
 &&
>             !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
>                 atomic64_dec(&kvm_tdx->nr_premapped);
> -               tdx_unpin(kvm, page);
> +               tdx_unpin(kvm, page, level);
>                 return 0;
>         }
>
> --
> 2.43.2
>

