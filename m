Return-Path: <kvm+bounces-22947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EC547944E45
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 16:43:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B08AB21346
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 14:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 362281A57F1;
	Thu,  1 Aug 2024 14:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YYE9UY03"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EA01A57DF
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 14:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722523397; cv=none; b=OIDKAZa1vvCpEVNdYYR12N3bzLhpPLzoUv5f8D+/0K0KQYMi3Wh39mFQ8JxqIv6JZ3dFrL2uhTpPFIUHlA0Oj5vbF1EBDN0G2Qc3E7OygQH9NVwM2ER0+Wgdbxo2VQ9foAI1PFojp43Njca+kwQKYAJMsJAV4N3Le9bo5JJe9aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722523397; c=relaxed/simple;
	bh=IsY6cT/EMNbdEHxsGGmKU2yom71VQGN3eoqzlVoDRMA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vojookl6i9yIjjI082PvGRI5yX0QXi/C2NvxzlKTImBAC3ifwsFiWqQjghKGV5fEfgbWzRKCQGQyiRFL8j6d4RVDDn+uHIMiS6CNeM8p1n+YpwjjK5Tili0VHFyRlGr2r7y/wTN+1HDihEMRNKwoldV2wtw3D0U+U9GuEj4RWBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YYE9UY03; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e05d72f044cso9865321276.3
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 07:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722523395; x=1723128195; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9BUCK9RfTKafiexBRvCEwFw2qC43V57hNjDHfumiy08=;
        b=YYE9UY03WQXLd7HA54lXGldbJlRGM4DHY9ytzkq4PbfGlKR42ibEuz87xtMFFZxHbl
         dTe65TWt75K5mHOpMYT8GsgFIgcDKPpmDJej+dLWm5ivKhrXPHHXaeI5AwnvZsgKSChl
         NZEJXzP+qB8kPr/XOXBHOPRosXOGbxov/d7IA3RpYPJusxC5GoFEvNgz+Fan8bibhFt9
         BKT1oqtQKqGSY8rKJGpitLat4IsYrtnM/AFpM6l2Amoz1UEbdIngFmUcKsdfq3abrBbq
         eaLWPZmIYHo3iOfrKjFuVqbaj+Bk3FyfpWZ24fLk04K7zlFigQlD0H3Wa1JqFEMVcOjR
         oglg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722523395; x=1723128195;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9BUCK9RfTKafiexBRvCEwFw2qC43V57hNjDHfumiy08=;
        b=rOOkdEHrWFyxCqsEN6qDEwhI3Dpx//wpKDOIaLIndLAjP7+Bn7lactwEyXmmoVhsi2
         qL88QguX9Uyzodj84NIwBUOGYgUHA3Z73mfU8AwQnu1cWjk6gQHh91okbCxFV1DpB+AU
         GetW9eC15yARuSNKJ/K1F26GJUObuIcFEMC6BdbTZrHFvpwjC02d3MU708pNyCZ6RLsH
         vKufkcrDUj7aL32VDcGpQI/ChpamuCW1kjujTXXJ8gV3LKO3crrOlDaSB0uucgOCXsRO
         xIITh50Vgnpj9S4Xr38aagI9w08jMDGN+wHmIbxRuf3/IupZB1NcOrJVhKxSwOkBvS0v
         leiA==
X-Forwarded-Encrypted: i=1; AJvYcCVB8WaxS3jz4G5gfAj6ZhHoNjo0GFrauOOmmheM+flvy++S1sYu5WBn9GjZxpCmnbw/87xZ0YCeQprhV/AAWeqNCMIn
X-Gm-Message-State: AOJu0YzN5hZ7Lm0z0BlRTCd9kfo3Me+mraUS9AFKCVKr6jPUcnUqFb8R
	cus9r/QWw84NEY7s0idNUg7nX1x9RfpP1PlQsyBjUEK8UWzRIa6L0rqxoBpk6+fWwyZ5E+Yuox6
	/yw==
X-Google-Smtp-Source: AGHT+IHkE7Ce/eHqXIIWUhOrz6iZ7wUAM+0kNmbjyrQoG1wEe6+vtvmxZ2gwjb9N0RAQKGaJuDaT2daG0VE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1104:b0:e0b:b6f3:85 with SMTP id
 3f1490d57ef6-e0bde2f0105mr658276.2.1722523394843; Thu, 01 Aug 2024 07:43:14
 -0700 (PDT)
Date: Thu, 1 Aug 2024 07:43:13 -0700
In-Reply-To: <87wml0egzo.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-6-seanjc@google.com>
 <87wml0egzo.fsf@draig.linaro.org>
Message-ID: <ZqufAYyVOa9M1z76@google.com>
Subject: Re: [PATCH v12 05/84] KVM: Add kvm_release_page_unused() API to put
 pages that KVM never consumes
From: Sean Christopherson <seanjc@google.com>
To: "Alex =?utf-8?Q?Benn=C3=A9e?=" <alex.bennee@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 01, 2024, Alex Benn=C3=A9e wrote:
> Sean Christopherson <seanjc@google.com> writes:
>=20
> > Add an API to release an unused page, i.e. to put a page without markin=
g
> > it accessed or dirty.  The API will be used when KVM faults-in a page b=
ut
> > bails before installing the guest mapping (and other similar flows).
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  include/linux/kvm_host.h | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 3d9617d1de41..c5d39a337aa3 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1201,6 +1201,15 @@ unsigned long gfn_to_hva_prot(struct kvm *kvm, g=
fn_t gfn, bool *writable);
> >  unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t g=
fn);
> >  unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot, gf=
n_t gfn,
> >  				      bool *writable);
> > +
> > +static inline void kvm_release_page_unused(struct page *page)
> > +{
> > +	if (!page)
> > +		return;
> > +
> > +	put_page(page);
> > +}
>=20
> I guess it's unfamiliarity with the mm layout but I was trying to find
> where the get_pages come from to see the full pattern of allocate and
> return. I guess somewhere in the depths of hva_to_pfn() from
> hva_to_pfn_retry()?

If successful, get_user_page_fast_only() and get_user_pages_unlocked() grab=
 a
reference on behalf of the caller.

As of this patch, hva_to_pfn_remapped() also grabs a reference to pages tha=
t
appear to be refcounted, which is the underlying wart this series aims to f=
ix.
In KVM's early days, it _only_ supported GUP, i.e. if KVM got a pfn, that p=
fn
was (a) backed by struct page and (b) KVM had a reference to said page.  Th=
at
led to the current mess, as KVM didn't get reworked to properly track pages=
 vs.
pfns when support for VM_MIXEDMAP was added.

	/*
	 * Get a reference here because callers of *hva_to_pfn* and
	 * *gfn_to_pfn* ultimately call kvm_release_pfn_clean on the
	 * returned pfn.  This is only needed if the VMA has VM_MIXEDMAP
	 * set, but the kvm_try_get_pfn/kvm_release_pfn_clean pair will
	 * simply do nothing for reserved pfns.
	 *
	 * Whoever called remap_pfn_range is also going to call e.g.
	 * unmap_mapping_range before the underlying pages are freed,
	 * causing a call to our MMU notifier.
	 *
	 * Certain IO or PFNMAP mappings can be backed with valid
	 * struct pages, but be allocated without refcounting e.g.,
	 * tail pages of non-compound higher order allocations, which
	 * would then underflow the refcount when the caller does the
	 * required put_page. Don't allow those pages here.
	 */
	if (!kvm_try_get_pfn(pfn))
		r =3D -EFAULT;

