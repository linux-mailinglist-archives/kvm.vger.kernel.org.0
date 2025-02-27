Return-Path: <kvm+bounces-39631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CA05A489BF
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 21:22:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D40E33B72F7
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 20:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7860270EB3;
	Thu, 27 Feb 2025 20:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="DJiw+M/C"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868F526FDBA
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 20:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740687749; cv=none; b=Sz03cNQfvnDY5/28wMNaPlN2hwxWR69K3uQHgHdFqckcMNezL2PL5D4b2ePUDnS35ZhH07jbwL9KfgqyImL3Ecno6uGS+m/p8LBCGU4bLifwCO6PR5LJdgLP/3f75Pw2xt6esKykhN6ERmrlg5ZD2/mqHjj5fOv3VkTNX3lysCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740687749; c=relaxed/simple;
	bh=4JO84e2/jyvgpbFbferhNXNJSfOzWDotZb4WwEXenb8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q61anSvlDJJX9dg7Hu4HWTzSKn4aulZ/PhYXSxp9EL2pVtaBmdgY/h9kVIB9MddYzBpiN57H6KEc4p7AeiIR9ZtDXR8KD18ca56Dk1S6TuCWLbuYOdy0RwH36aduf4XqksWTbwwnKqaAFBc4DEmHk10vp+p30W5VC1WYdsPmMi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=DJiw+M/C; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id EE20A3F171
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 20:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1740687738;
	bh=SiQZ4Rq+0GqJoxx2KQxyIG0Xut74ShpYg+ijgenLnUA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=DJiw+M/CxLKhynFB8DTFH1WZJmvu5NImLHgNrZeCj2oyaWrnhHH88bEdrhXAxIGsn
	 cAfbUhsKRC+mi+Y+3PXryvAohOwd6ntLyPZlMbKX1wVzFIkmq+uBzyzOz8aQTAcko6
	 kDMPzTv9FIWZK7R/VEa4Z0c+0rgw1TlT70SDL6BK+X0FxYeCoXJEgbOa42wnLNWMV4
	 sTOPT/qdaOEVW1jhcP5SM8MLF69AS4V21JZDMBKGP7WTCOxuKMb2jlOATYljWhyS1X
	 KwHSEolV9KYe5W+Gtk9kGaMIwjHV31xJkHQ5i8qN+IlANWQu7Gj18TygY3ArXcs9K0
	 ruOmbl0tbu+hA==
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5daa661ec3dso1610651a12.3
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 12:22:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740687738; x=1741292538;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SiQZ4Rq+0GqJoxx2KQxyIG0Xut74ShpYg+ijgenLnUA=;
        b=oB/ZdW3nGsxm7wi7wPDNKv1XwgaPNaWonnAjec929DlgPsOswdTNc/DO8nSIvOedmE
         v3DvggEA2kaFNp7I+nCWFEUUkKN6u81dSPy5B3nUwLOHs+xaUBYk0xO6hz0trdDQ9QL8
         lHFaMBGDs3TCgmrYB7jGjCWZZeKj07zObxBUSqswN2hwurJMiSQaGGvZEWGvsUY52fSJ
         vf2HrNH9VRgB5NveF8/NAqTGJZ1UxyaOTCuUkEHaswzkxi9RoBLMSsI/eEMvl5f7DvJD
         S1rVyF/awRr37iidKGdcvA3QAPNpqgRkQuQ7CoA6tgx6++NRpo5Ks2iqK83FMNLKSeOU
         JoNQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+VQCASQiw/EqExDnNn74D1QrXth/8GyVLHn3NK7yiKGAfoR7QOnNdFQEgfG58l62UFqk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwfbDIORs8b+RyF3Fwnqd8KDIBKEsGbpiY14fou6Rr5r282j6b
	S7Baa+vaNNi0OAitzBpsLuHnMuJch/+hgvl4TkH4ZOAk9lzyVq3X72qP7SNAGOABQG9UnJYuecK
	5JSlQwThvjAfWIR7qslHcinCtTjDFwhsviNykTyEQKg0LVBLvrWP1lEMMszvpONGJpmrMOfVS+8
	lWzpLYqWX4K88UI4nGMZyrGIAQi1j4o3MXOfgfER76
X-Gm-Gg: ASbGnctbA/xOLjfq9gmFtJeF46Dffot2AUv59W2Zi1ckJvFFas/K6TEH9Xbv8L49CC6
	LUoLLhdIaRUAkqcn82GK+WSkoZ1LQfh5qc2QAqAB39ZFpaK5JopBH498QLl/oHm7IxJelDRg=
X-Received: by 2002:a05:6402:350f:b0:5e4:9348:72b4 with SMTP id 4fb4d7f45d1cf-5e4d6921bd4mr402491a12.0.1740687738515;
        Thu, 27 Feb 2025 12:22:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHjN7GoLizYN8AYUswkeK50Pl1lF2BJudLqy3J78FpZbhUAfHe4ulxGizo03P2ZzrkYYxtjIXX1SIy4cdHOVZg=
X-Received: by 2002:a05:6402:350f:b0:5e4:9348:72b4 with SMTP id
 4fb4d7f45d1cf-5e4d6921bd4mr402477a12.0.1740687738203; Thu, 27 Feb 2025
 12:22:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250218222209.1382449-1-alex.williamson@redhat.com>
 <20250218222209.1382449-7-alex.williamson@redhat.com> <Z7UOEpgH5pdTBcJP@x1.local>
 <20250218161407.6ae2b082.alex.williamson@redhat.com> <CAHTA-ua8mTgNkDs0g=_8gMyT1NkgZqCE0J7QjOU=+cmZ2xqd7Q@mail.gmail.com>
 <20250219080808.0e22215c.alex.williamson@redhat.com> <CAHTA-ubiguHnrQQH7uML30LsVc+wk-b=zTCioVTs3368eWkmeg@mail.gmail.com>
 <20250226105540.696a4b80.alex.williamson@redhat.com>
In-Reply-To: <20250226105540.696a4b80.alex.williamson@redhat.com>
From: Mitchell Augustin <mitchell.augustin@canonical.com>
Date: Thu, 27 Feb 2025 14:22:07 -0600
X-Gm-Features: AQ5f1JrZ1oPBmSEga4Ppqksx7nR2-OUM5LtfazwlWAiz0Eh4H51tt0_skrEMiXg
Message-ID: <CAHTA-ubjxqs7Rh8ERXqFXCRAm7WoMMRQftSPLmrK61jra7+gYg@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] vfio/type1: Use mapping page mask for pfnmaps
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	clg@redhat.com, jgg@nvidia.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Alex, that's super helpful and makes sense to me now!

-Mitchell

On Wed, Feb 26, 2025 at 11:55=E2=80=AFAM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Wed, 19 Feb 2025 14:32:35 -0600
> Mitchell Augustin <mitchell.augustin@canonical.com> wrote:
>
> > > Thanks for the review and testing!
> >
> > Sure thing, thanks for the patch set!
> >
> > If you happen to have a few minutes, I'm struggling to understand the
> > epfn computation and would appreciate some insight.
>
> Sorry, this slipped off my todo list for a few days.
>
> > My current understanding (very possibly incorrect):
> > - epfn is intended to be the last page frame number that can be
> > represented at the mapping level corresponding to addr_mask. (so, if
> > addr_mask =3D=3D PUD_MASK, epfn would be the highest pfn still in PUD
> > level).
>
> Actually epfn is the first pfn of the next addr_mask level page.  The
> value in the parens (*pfn | (~addr_mask >> PAGE_SHIFT)) is the last pfn
> within the same level page.  We could do it either way, it's just a
> matter of where the +1 gets added.
>
> > - ret should be =3D=3D npages if all pfns in the requested vma are with=
in
> > the memory hierarchy level denoted by addr_mask. If npages is more
> > than can be represented at that level, ret =3D=3D the max number of pag=
e
> > frames representable at addr_mask level.
>
> Yes.
>
> > - - (if the second case is true, that means we were not able to obtain
> > all requested pages due to running out of PFNs at the current mapping
> > level)
>
> vaddr_get_pfns() is called again if we haven't reached npage.
> Specifically, from vfio_pin_pages_remote() we hit the added continue
> under the !batch->size branch.  If the pfnmaps are fully PUD aligned,
> we'll call vaddr_get_pfns() once per PUD_SIZE, vfio_pin_pages_remote()
> will only return with the full requested npage value, and we'll only
> call vfio_iommu_map() once.  The latter has always been true, the
> difference is the number of times we iterate calling vaddr_get_pfns().
>
> > If the above is all correct, what is confusing me is where the "(*pfn)
> > | " comes into this equation. If epfn is meant to be the last pfn
> > representable at addr_mask level of the hierarchy, wouldn't that be
> > represented by (~pgmask >> PAGE_SHIFT) alone?
>
> (~addr_mask >> PAGE_SHIFT) gives us the last pfn relative to zero.  We
> want the last pfn relative to *pfn, therefore we OR in *pfn.  The OR
> handles any offset that *pfn might have within the addr_mask page, so
> this operation always provides the last pfn of the addr_mask page
> relative to *pfn.  +1 because we want to calculate the number of pfns
> until the next page.  Thanks,
>
> Alex
>


--=20
Mitchell Augustin
Software Engineer - Ubuntu Partner Engineering

