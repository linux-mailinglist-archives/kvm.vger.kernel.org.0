Return-Path: <kvm+bounces-8064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B05784AB87
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 02:25:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0091F286953
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 01:25:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8AF81866;
	Tue,  6 Feb 2024 01:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fywgBDTf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FC51391
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 01:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707182722; cv=none; b=pHf7leiGuuNOZB/DtvHhweF1uhWkBqT5TV286/7Nq/ZRiz6uYdM9R6g0V5wrV2yRqHO5PcV/kT+BLh0ggUO50Tla9Pxdlhe4J68VZDHlxc1G1NN6q9AxuZ3hsgdlqiUcu5Hs3fQBbJsuMnEFjLgWKp9HCpKp5LU/zp+2haDxM04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707182722; c=relaxed/simple;
	bh=ejoUMW0p93f8a8rEmbA8hkkIVSABQixghjSO176xasw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=adMqw1INCS/eTPpL5tawicqD+/i36Udi2hG5EtJf7lRIElu8muhH8GvOyhD1+bDU9QAAARosfnh4wgq5o2ibxv64f5rQJXRQETxOTjwFUW8xK42i0g4Lp20NejfvDy9PFWfiljhs2YgDMYv1r5KmcGhCU7nEi55PTDSAFBh+9cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fywgBDTf; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6df2b2d1aso6007096276.1
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 17:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707182719; x=1707787519; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RCU7ZRz3FCY6pjF8OPKhDv/ngvtLwKliCs4bBQl+Zb4=;
        b=fywgBDTfAq4nVIGl9Xnl6O5WqoV5QjA590XIMTsVJgYDCtC5Dl37scfeNs0+p11d1T
         BZhX4pqbt57QtFp5g4Y/SLqaoh3xT+uVccNPjs+lo4z3NASTznUjFfpmKuLXZUSsQ5/K
         hIXrVNuoVjjWGWMAMyjyIwRyJxrYY7M62P58bCqReks5CDrK4Zx1DDx0Z+y/g1HfBlkZ
         8vvp4uvmh1YmxDCP66nNZQvy4nut15i47eJ3PZGkHI0E6By2bnva13f9EimVjKJopLFL
         VkgpEC2EwFBwsIzOWePrkNpIqPT/C2HfCuulgQWQrL6XNKN5bYyNzVBv/viG4gdX3jm3
         /Ctg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707182719; x=1707787519;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RCU7ZRz3FCY6pjF8OPKhDv/ngvtLwKliCs4bBQl+Zb4=;
        b=HH3DoxyaO3H9vjGE7OukveN+8IekO2K9dm9/t53J/IhkCvueLIfnpH6a0Mt7ChyhTG
         rraGXHxwJ4j4EYPhP1AgyKoIvuCde9MUOGsqCrlRJWbi88HuOVXYYSUM6ruwv47MsrQV
         mfcN9Ako4HkPKol62pUstZXM4o1tUoiPpUQ5q302YhDZ/i1fX88CeOTF7wWN9pRtJqx3
         ZnMAzk01h/HDG+JEKcwkaL4WZOgJEWobQtT3cMAjWNEEhO/e9t9x7FyJt5379nNHOcW0
         kALcG9FRcU7wbMjNHmwumHdLU9WGrUNj6LIvOvuZJRkj+m0lq8NZlwb9y94h6dpyrE5l
         D0hg==
X-Gm-Message-State: AOJu0YxrozZqEtPc6qNTQZNPuqmIJw+deNyc1SfGOz0WjN7jhex1vJ5I
	iy1tcXEAd8glZmkGgPOMJ+8ArNzmipeP5ICokXlh5deYQ0FP86ZPxkJE0oB0b90LuVpJk4sc9ik
	K+Q==
X-Google-Smtp-Source: AGHT+IH4RTPToC/fdDT260b36GmINeDEMQ2U6LxkzDJ69GgXY7geRggjbYjoc2xeHrl9AwMIvYeYUyKnuIA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:168f:b0:dc2:46cd:eee9 with SMTP id
 bx15-20020a056902168f00b00dc246cdeee9mr12210ybb.4.1707182719377; Mon, 05 Feb
 2024 17:25:19 -0800 (PST)
Date: Mon, 5 Feb 2024 17:25:17 -0800
In-Reply-To: <68ab2979f1982bdd0306e24f1e355ad322c7aa1c.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <20230911021637.1941096-3-stevensd@google.com>
 <68ab2979f1982bdd0306e24f1e355ad322c7aa1c.camel@redhat.com>
Message-ID: <ZcGKfQVGrUaqmGwW@google.com>
Subject: Re: [PATCH v9 2/6] KVM: mmu: Introduce __kvm_follow_pfn function
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: David Stevens <stevensd@chromium.org>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 03, 2023, Maxim Levitsky wrote:
> =D0=A3 =D0=BF=D0=BD, 2023-09-11 =D1=83 11:16 +0900, David Stevens =D0=BF=
=D0=B8=D1=88=D0=B5:
> > From: David Stevens <stevensd@chromium.org>
> >=20
> > Introduce __kvm_follow_pfn, which will replace __gfn_to_pfn_memslot.
> > __kvm_follow_pfn refactors the old API's arguments into a struct and,
> > where possible, combines the boolean arguments into a single flags
> > argument.
> >=20
> > Signed-off-by: David Stevens <stevensd@chromium.org>
> > ---
> >  include/linux/kvm_host.h |  16 ++++
> >  virt/kvm/kvm_main.c      | 171 ++++++++++++++++++++++-----------------
> >  virt/kvm/kvm_mm.h        |   3 +-
> >  virt/kvm/pfncache.c      |  10 ++-
> >  4 files changed, 123 insertions(+), 77 deletions(-)
> >=20
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index fb6c6109fdca..c2e0ddf14dba 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -97,6 +97,7 @@
> >  #define KVM_PFN_ERR_HWPOISON	(KVM_PFN_ERR_MASK + 1)
> >  #define KVM_PFN_ERR_RO_FAULT	(KVM_PFN_ERR_MASK + 2)
> >  #define KVM_PFN_ERR_SIGPENDING	(KVM_PFN_ERR_MASK + 3)
> > +#define KVM_PFN_ERR_NEEDS_IO	(KVM_PFN_ERR_MASK + 4)
> > =20
> >  /*
> >   * error pfns indicate that the gfn is in slot but faild to
> > @@ -1177,6 +1178,21 @@ unsigned long gfn_to_hva_memslot_prot(struct kvm=
_memory_slot *slot, gfn_t gfn,
> >  void kvm_release_page_clean(struct page *page);
> >  void kvm_release_page_dirty(struct page *page);
> > =20
> > +struct kvm_follow_pfn {
> > +	const struct kvm_memory_slot *slot;
> > +	gfn_t gfn;
> > +	unsigned int flags;
> It might be useful for the future readers to have a note about which valu=
es
> the flags can take.  (e.g one of the 'FOLL_* flags).

+1.  It doesn't have to (probably shouldn't?) say _which_ FOLL_* flags are =
supported
(I forget if there was going to be a restriction).  Just a comment explaini=
ng that
it's used to pass various FOLL_* flags.

> > +	bool atomic;
>=20
> I wish we had FOLL_ATOMIC, because there is a slight usability regression=
 in
> regard to the fact, that now some of the flags are here and in the 'atomi=
c'
> variable.
>=20
>=20
> > +	/* Try to create a writable mapping even for a read fault */
> > +	bool try_map_writable;
> > +
> > +	/* Outputs of __kvm_follow_pfn */
> > +	hva_t hva;
> > +	bool writable;
> > +};
>=20
>=20
> Another small usability note. I feel like the name 'follow_pfn' is not th=
e
> best name for this.
>=20
> I think ultimately it comes from 'follow_pte()' and even that name IMHO i=
s
> incorrect.  the 'follow_pte' should be called 'lookup_kernel_pte', becaus=
e that
> is what it does - it finds a pointer to pte of hva in its process's kerne=
l
> page tables.

Yeah, I 100% agree follow_pte() is a bad name (I suggested kvm_follow_pfn()=
), but
for me, this falls into the "if you can't beat 'em, join 'em" scenario.  It=
's kinda
like the XKCD comic about 14 standards; coming up with a new name because t=
he
existing one sucks doesn't make the world any better, it's just one more le=
ss
than perfect name for developers to remember :-)

> IMHO, the kvm_follow_pfn struct should be called something like
> gfn_to_pfn_params, because it specifies on how to convert gfn to pfn (or
> create the pfn if the page was swapped out).

Again, I don't disagree in a vacuum, but I want the name of the struct to b=
e
tightly coupled to the API, e.g. so that it's super obvious where in KVM's =
flows
the struct is used, at the expense of making it less obviously how exactly =
said
flow uses the struct.

> Same note applies to '__kvm_follow_pfn()'
>=20
> If you really want to keep the original name though, I won't argue over t=
his.
>=20
> > +
> > +kvm_pfn_t __kvm_follow_pfn(struct kvm_follow_pfn *foll);
> > +
> >  kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
> >  kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault=
,
> >  		      bool *writable);
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index ee6090ecb1fe..9b33a59c6d65 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2512,8 +2512,7 @@ static inline int check_user_page_hwpoison(unsign=
ed long addr)
> >   * true indicates success, otherwise false is returned.  It's also the
> >   * only part that runs if we can in atomic context.
> >   */
> > -static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
> > -			    bool *writable, kvm_pfn_t *pfn)
> > +static bool hva_to_pfn_fast(struct kvm_follow_pfn *foll, kvm_pfn_t *pf=
n)
> >  {
> >  	struct page *page[1];
> > =20
> > @@ -2522,14 +2521,12 @@ static bool hva_to_pfn_fast(unsigned long addr,=
 bool write_fault,
> >  	 * or the caller allows to map a writable pfn for a read fault
> >  	 * request.
> >  	 */
> > -	if (!(write_fault || writable))
> > +	if (!((foll->flags & FOLL_WRITE) || foll->try_map_writable))
> >  		return false;
>=20
> A small note: the 'foll' variable and the FOLL_* flags have different
> meaning: foll is the pointer to a new 'struct kvm_follow_pfn' while FOLL_=
 is
> from the folio API, I think.
>=20
> Maybe we should rename the 'foll' to something, like 'args' or something =
like
> that?

Hmm, I was going for something similar to "struct kvm_page_fault *fault" (t=
his
was another suggestion of mine).  I don't love args, mainly because the usa=
ge
isn't tied back to the struct name, e.g. deep in hva_to_pfn_remapped() and =
friends,
"args" starts to lose context/meaning.

Looking at this with fresh eyes, I still like "foll", though I agree it's f=
ar
from ideal.  Maybe an acronym?  "kfp" isn't used in the kernel, AFAICT.  I'=
d vote
for "foll" over "kfp", but I'm ok with either (or whatever, so long as the =
name
is tied back to the struct in some way, i.e. not super generic).

> > -	/* map read fault as writable if possible */
> > -	if (unlikely(!write_fault) && writable) {
> > +	if (foll->flags & FOLL_WRITE) {
> > +		foll->writable =3D true;
> > +	} else if (foll->try_map_writable) {
> >  		struct page *wpage;
> > =20
> > -		if (get_user_page_fast_only(addr, FOLL_WRITE, &wpage)) {
> > -			*writable =3D true;
> > +		/* map read fault as writable if possible */
> > +		if (get_user_page_fast_only(foll->hva, FOLL_WRITE, &wpage)) {
> > +			foll->writable =3D true;
> >  			put_page(page);
> >  			page =3D wpage;
>=20
> Regardless of this patch, I am wondering, what was the reason to first ma=
p the
> page in the same way as requested and then try to map it as writable.
>=20
> Since the vast majority of the guest pages are likely to be writable, isn=
't
> it better to first opportunistically map them as writable and if that fai=
ls,
> then try to map readonly?

KVM actually does do that.  hva_to_pfn_fast() tries to map WRITABLE, and th=
en
only falls back to the slow path if that fails.

As for why KVM doesn't "try" to faultin the hva as writable, that would bre=
ak
CoW and probably KSM as well.  I.e. if KVM _asked_ for a writable mapping i=
nstead
of opportunistically seeing if the primary MMU created a writable mapping.

