Return-Path: <kvm+bounces-67640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D68AAD0C23C
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 21:08:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0A322305EF8D
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 20:06:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EA3936657E;
	Fri,  9 Jan 2026 20:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MH0DShUk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B042DC34B
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 20:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767989188; cv=pass; b=pnj4Fy7uO2MVAszegbbGO7JA99PJYwuZbpftTcq5eT7SC5OZ4tLGmwAyiQveXiaojWkGOVwYbXFGDa5NHI8zO7JQvqE+8S8PRFi7tnW961u8paFS0nAYhh99ArCkwBHW76pUK0BiqAEHto5DPeYwVZBj2JoV6X/tCxkxAOQgqlM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767989188; c=relaxed/simple;
	bh=lnIUJQkxS9Pwv0vAZpiGY6C+0KRrIsW0ImsiyQtadNs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oNhlc1LZSlEJ970gU35TszwnlJv9jHUidOws5CzcYov3hXYTapBqKcekKURi+QTQOd55vSjt3O8+OaUAu9igEMAnuEBtNqXKoUfbFoV1YHLDVPvkha8vgFjCmvnweHE9nqqqGTKUHTv+Hv5uOvdO63CGkqDS1JcFf4q6rDr0Q0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MH0DShUk; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ee147baf7bso16601cf.1
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 12:06:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767989186; cv=none;
        d=google.com; s=arc-20240605;
        b=T30pPpAFZF7JP/aUMNrEqrtLuI53bG3zIw44Y4TO2NuX2IvvRM+VC09xSaDa+98sd2
         mDlFbQF/d0ZU1g8xZevdXz4LBzMU8mghFFoO+WBr5VEfNiVNa/xzyC/A3jwS8jchuX8F
         e5586O4NUbmnp5ru47VNY2jkvm9q9ytFX5eb+x2xNIDqVa60PK/2M/0FTlDLO7/+csdt
         FkGE9+TaRBAIhuRV8gBzAPP85Xdq1icpArtHZV1/dQ5XIiLg+vzMss3FXFJpVFO5c0VZ
         4rGi9EwEowRspB1hqVauhtrabgdKAcuB3YVOkoUe01OsEcx4wa9u5C80p7elJYDMTQKg
         gWSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3v9Ac84hXSFfPtALk5IIwgHNdB2cCIMVGKjZbTXyYLE=;
        fh=qbRXptn2WH8skCOjUEeOsKCSGV/z08NzKtt6wWlpO04=;
        b=PxUlF1Xc1+4B3hT5V46fFQ8j7FpLDUtEtNRYqxana+fy5MlrfMHH8j8d7OKZkSAWFa
         krQLpc1ewaGnvp4eOqUnDe4WWBB8eUg1A5nF4S8IcrHFIvUWQGdCBmwC525JWy3xCKy6
         E5c6hJZ2fSnsP1ECX7mTdDyF574am6IRiKBD+90npm2HnScs/TqaYt6WB5lFUfAZz9h7
         hdKShF3Wuk6aTFiCDlDZe7DTOjvt9j7KzE/0ujNPIDt2lt/F+jbA12qvUqPrO8c9kO6V
         STnK0OpiJB7Lgk06qX5En308da1XKR1oVZ2fZ+nHVJvRTpXQWfLCBBJ4x6kBsNIP5iSx
         bq4Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767989186; x=1768593986; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3v9Ac84hXSFfPtALk5IIwgHNdB2cCIMVGKjZbTXyYLE=;
        b=MH0DShUkKdltwr507ftvTYed0K7XwUj06CSBVS/0vb2BoptD7Js4OeEIEfe0sFcola
         O2YO4sTuUAxomoKZeTJbBofUlNQK6hD2c1K3a2lpioxg1QvKknzfzFCEOCXdYDD6h3lz
         s2gjyAS0ctMPUrczymCsCwZDK5DwKkSzPFXPEM2vPWBXdODTDUt6W+osqJxT0U7ijdcj
         KwYdFp5ePh4fCsgIfkrQVI5nkmQ2ldGlE19nemujeZUwEFJJZQLSgI3g3FHXYH9iTFmq
         DvyzmyupsWba36Pu120G6Ayv2AdCKyMKyNG1aQCw0HbV5nArrDhoj6AygEiXmiYHSEW7
         iKuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767989186; x=1768593986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3v9Ac84hXSFfPtALk5IIwgHNdB2cCIMVGKjZbTXyYLE=;
        b=XsYsuEccMIMj3zCICSJ+MtIAlmHYf563L7YqyppH6EcoO/wyLv8ZdjRh+ryPlsT++d
         s2d2o/43bYHml/xnaOihoLyMelKlwfLQDw2zr22yDYU80G5oIY/3ZFemdK/nRN6n9dMo
         z4ldd5dCHZ5appY/90VEqGxjDA9DubwCQVGISmMMrGvODixhA666Q3G9gZseD5JvqwqD
         PUt9CfzdsLe/2wnD/L7ZU6N7BtudrBAuu4hWPW4ZWPPfpOCP1M6G2LPu7h6tmiBA9xaE
         MqlMgDpnNdOzRHZdlQE4ggIF0WWPGtSqmt3Lq8/o4ea7qalCt5w1pAC318N26CQ7vGpW
         QbbA==
X-Forwarded-Encrypted: i=1; AJvYcCXJHRJ7/NOMWlIAeixdsCuq5gn83CeCtdC5wuu7w++d0d8ZvK5yt/H894TiXV+9anD7EiA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbKlEd7hIXDvllTQca3077Q6oSyeSgULemhgTrg5DZMu48xHVa
	gvEStt+OmhitwUd5jijNpkqXdtDHUY1ku8ewesXK1ZKgj1/IPTN/UThgDDt6XvraEAOwsEVDfxQ
	GE96Mr/oEmMNmwNNfjqmqFets7zXDkxzoM0puXIeu
X-Gm-Gg: AY/fxX5u/HmMooPwiBtDLVVk+m+j5J67IROvhSo37K52HWrfZv7Z4yYA8dufwsRPoMo
	GSoKqS9wbg6LO4ovOZGgtVzCChiVeK6n7jq0FzcERr0+rzEP9G21UjNFIHrADimjBRRKvA7HtTj
	chrJQ0JPXcJ1carzLpZlVvfXb2fOSjK0ZEfvbA1bZVxOnv3sHmASfVTRhgTMeAemHI9+dFBGFGx
	xNqFZYeLUYiqrra2BNKH5hoPNrv/xfm2uztDQ/QtCHA91Umn14ioC/NPNXYQL3PUeSxpzIYsdVs
	e9T+0fGPSl4ofPqkz4p3nORIpec=
X-Received: by 2002:a05:622a:1482:b0:4ff:c103:49f1 with SMTP id
 d75a77b69052e-501182d936amr2352541cf.6.1767989185723; Fri, 09 Jan 2026
 12:06:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107201800.2486137-1-skhawaja@google.com> <20260107202812.GD340082@ziepe.ca>
 <20260107204607.GE340082@ziepe.ca>
In-Reply-To: <20260107204607.GE340082@ziepe.ca>
From: Samiullah Khawaja <skhawaja@google.com>
Date: Fri, 9 Jan 2026 12:06:13 -0800
X-Gm-Features: AZwV_QjV34fhG0Fu3VYkE_TAOZmadp8pGOc9Pcce_ry5TSbSRKbYuzuTqpawuWI
Message-ID: <CAAywjhTEyOUmxWeCX6GwCBSnMf-p18Ksu2TUYeQ57K8H4RW-9w@mail.gmail.com>
Subject: Re: [PATCH 0/3] iommu/vt-d: Add support to hitless replace IOMMU domain
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, David Matlack <dmatlack@google.com>, 
	Robin Murphy <robin.murphy@arm.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Kevin Tian <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Parav Pandit <parav@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 7, 2026 at 12:46=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca> wrot=
e:
>
> On Wed, Jan 07, 2026 at 04:28:12PM -0400, Jason Gunthorpe wrote:
> > On Wed, Jan 07, 2026 at 08:17:57PM +0000, Samiullah Khawaja wrote:
> > > Intel IOMMU Driver already supports replacing IOMMU domain hitlessly =
in
> > > scalable mode.
> >
> > It does? We were just talking about how it doesn't work because it
> > makes the PASID entry non-present while loading the new domain.
>
> If you tried your tests in scalable mode they are probably only
> working because the HW is holding the entry in cache while the CPU is
> completely mangling it:
>
> int intel_pasid_replace_first_level(struct intel_iommu *iommu,
>                                     struct device *dev, phys_addr_t fsptp=
tr,
>                                     u32 pasid, u16 did, u16 old_did,
>                                     int flags)
> {
> [..]
>         *pte =3D new_pte;
>
> That just doesn't work for "replace", it isn't hitless unless the
> entry stays in the cache. Since your test effectively will hold the
> context entry in the cache while testing for "hitless" it doesn't
> really test if it is really working without races..

Ah.. you are absolutely correct. This will not work if the entries are
not cached.
>
> All of this needs to be reworked to always use the stack to build the
> entry, like the replace path does, and have a ARM-like algorithm to
> update the live memory in just the right order to guarentee the HW
> does not see a corrupted entry.

Agreed. I will go through the VTD specs and also the ARM driver to
determine the right order to set this up.
>
> It is a little bit tricky, but it should start with reworking
> everything to consistently use the stack to create the new entry and
> calling a centralized function to set the new entry to the live
> memory. This replace/not replace split should be purged completely.
>
> Some discussion is here
>
> https://lore.kernel.org/all/20260106142301.GS125261@ziepe.ca/
>
> It also needs to be very careful that the invalidation is doing both
> the old and new context entry concurrently while it is being replaced.

Yes, let me follow the discussion over there closely.
>
> For instance the placement of cache_tag_assign_domain() looks wrong to
> me, it can't be *after* the HW has been programmed to use the new tags
> :\
>
> I also didn't note where the currently active cache_tag is removed
> from the linked list during attach, is that another bug?

You are correct, the placement of cache_tag_assign_domain is wrong.
The removal of the currently active cache tag is done in
dmar_domain_attach_device, but I will re-evaluate the placement of
both in the v2.
>
> In short, this needs alot of work to actually properly implement
> hitless replace the way ARM can. Fortunately I think it is mostly
> mechanical and should be fairly straightfoward. Refer to the ARM
> driver and try to structure vtd to have the same essential flow..

Thank you for the feedback. I will prepare a v2 series addressing these poi=
nts.
>
> Jason

