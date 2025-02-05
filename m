Return-Path: <kvm+bounces-37359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3204A29425
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 16:21:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D60316BEA6
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 15:17:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C44B1DB363;
	Wed,  5 Feb 2025 15:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y5L0KZP1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E3D158D96
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 15:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768515; cv=none; b=Z/N7d+n/R3HAjnGAdMhGJlVSaI5/uZRmyITxjzF96A/gV0zeEo20O5VTxghkgTy2f+COXlMtbeWGzZorCcUtSjVh2qjukqUu3zxBsYiACO+u0V9339BA4E5oL8xFPNXhQ6z4zVDQYHcB+5qbD6yVlMUIC3nDuPMyvXnuP8otAtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768515; c=relaxed/simple;
	bh=4szL1eJgPRArjYOVHDwKE/JvLZRZfgR79x/numwtyM4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hVBhJ0G9Sl9X5CM6SHqtFvXlkDcSpb2+bg7O4JrYXvBsiLiQUpsczGN1Msqt5liVSRJn7mx6JnK3dBdAg3rqnKl9ZV/Pfkpfq0b/8C+/WpHAkPlmB/ZxuS5Z6Krvf48+ZrbPro5icqz2bwsFg8NG08MnXQ6KbravcKv6M016ZUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y5L0KZP1; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21f022fc6a3so23589195ad.1
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 07:15:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738768513; x=1739373313; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RjqsFlgPguDEnBdcgetC9zWFV3PjaxpPC075lKRZgFw=;
        b=Y5L0KZP1UO6rB9GAHvnNcHiDP/hI1qsv4laQaR1ijSOSeZ+m+LlNJcr0OKnjTJZwhY
         QJzhygz2wyqdrwWMpvSwT4FRdIwnirmI6qJSrOJDcaVyehr54atLs2NTCAx2r75nCYZl
         UjiaYqGAK6IX899BY/VVI5M3tiyhdO+o1qagP3bmj7lPkML3qYdHZkdRPBFKChNJaCgU
         ZLUtykGwweQQzuYP8nf2Hez7qFOcCf5atnOehG32qQVI+ghC1oAhGEb4tOSFRF4exkom
         XYKvrkp33kHnXXoTu3TCa4kGQ5xpoosTluQ2Mrb3yext99/mpLd19K7TJXrBF6HQWLy5
         gL0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738768513; x=1739373313;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RjqsFlgPguDEnBdcgetC9zWFV3PjaxpPC075lKRZgFw=;
        b=nvCtyWki3ugWbH+qOTMVr6cKmL+yBi1zJvO+TxCtVF4nZVZtgN8lUEoTA4aDqaWEYB
         Oa5cywR3KsBGjjXtGh7PGoDx7/UVi+sSN8wjbxF2x2HuUe2xAbLtSzRbKTb1vE6EmvSz
         Ylh4E5SMox9EHA5za982zox9i43jb4RzS9/XRnVIT8/s1hr+W/UY4VTOKvE6HZVLg941
         kR47anZ1WZzFBxC9ZUmP+XI3Mhs3vyFB/rLmnwCbrPDY4mqklTz1VAEgW38k9TUJk/py
         VgMo8uBnUpyvm/1w42wSSEl2yfVPsnpXZkHWJzC/tZCO21cNIsizT9nev71QS5pRNXzr
         R+NA==
X-Forwarded-Encrypted: i=1; AJvYcCUYuZDdQACxHWJilVV3BEAmTsz5CEyERDe2SOL8qkpoM+1j6ljoTkXR2aoxtFzlZOH8L2U=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywcy1ZAOKMXVne9PQsGQQ8snTm75ig8mFlQpsvnTQ9x6674k7HQ
	w0WTc2AMF43hIKGbkI1yp4copgzyZBVLYEOvjgDU+wo3dPfU0gP8QlKh60M9+Aog4S00Lry0y+B
	CyQ==
X-Google-Smtp-Source: AGHT+IFHs7tj+Q54d64NDKOfhfMfAS91bOZEx/8/ugogv1Ut4aJidKZIV/qdikwiSwu5m+q7+e5T4vD0P74=
X-Received: from plgi6.prod.google.com ([2002:a17:902:cf06:b0:21c:144d:411b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:daca:b0:215:758c:52e8
 with SMTP id d9443c01a7336-21f17a774a7mr66004375ad.12.1738768512794; Wed, 05
 Feb 2025 07:15:12 -0800 (PST)
Date: Wed, 5 Feb 2025 07:15:11 -0800
In-Reply-To: <1969aa1a-e092-4a48-b4a0-9a50ec2ef3b6@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1738274758.git.ashish.kalra@amd.com> <afc1fb55dfcb1bccd8ee6730282b78a7e2f77a46.1738274758.git.ashish.kalra@amd.com>
 <Z5wr5h03oLEA5WBn@google.com> <1969aa1a-e092-4a48-b4a0-9a50ec2ef3b6@amd.com>
Message-ID: <Z6OAf02sRJTZkl5K@google.com>
Subject: Re: [PATCH v2 4/4] iommu/amd: Enable Host SNP support after enabling
 IOMMU SNP support
From: Sean Christopherson <seanjc@google.com>
To: Vasant Hegde <vasant.hegde@amd.com>
Cc: Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, joro@8bytes.org, 
	suravee.suthikulpanit@amd.com, will@kernel.org, robin.murphy@arm.com, 
	michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org, 
	kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-coco@lists.linux.dev, iommu@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 05, 2025, Vasant Hegde wrote:
> On 1/31/2025 7:18 AM, Sean Christopherson wrote:
> > On Fri, Jan 31, 2025, Ashish Kalra wrote:
> >> @@ -3426,18 +3431,23 @@ void __init amd_iommu_detect(void)
> >>  	int ret;
> >>  
> >>  	if (no_iommu || (iommu_detected && !gart_iommu_aperture))
> >> -		return;
> >> +		goto disable_snp;
> >>  
> >>  	if (!amd_iommu_sme_check())
> >> -		return;
> >> +		goto disable_snp;
> >>  
> >>  	ret = iommu_go_to_state(IOMMU_IVRS_DETECTED);
> >>  	if (ret)
> >> -		return;
> >> +		goto disable_snp;
> > 
> > This handles initial failure, but it won't handle the case where amd_iommu_prepare()
> > fails, as the iommu_go_to_state() call from amd_iommu_enable() will get
> > short-circuited.  I don't see any pleasant options.  Maybe this?
> > 
> > diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> > index c5cd92edada0..436e47f13f8f 100644
> > --- a/drivers/iommu/amd/init.c
> > +++ b/drivers/iommu/amd/init.c
> > @@ -3318,6 +3318,8 @@ static int __init iommu_go_to_state(enum iommu_init_state state)
> >                 ret = state_next();
> >         }
> >  
> > +       if (ret && !amd_iommu_snp_en && cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> 
> I think we should clear when `amd_iommu_snp_en` is true.

That doesn't address the case where amd_iommu_prepare() fails, because amd_iommu_snp_en
will be %false (it's init value) and the RMP will be uninitialized, i.e.
CC_ATTR_HOST_SEV_SNP will be incorrectly left set.

And conversely, IMO clearing CC_ATTR_HOST_SEV_SNP after initializing the IOMMU
and RMP is wrong as well.  Such a host is probably hosted regardless, but from
the CPU's perspective, SNP is supported and enabled.

> May be below check is enough?
> 
> 	if (ret && amd_iommu_snp_en)



