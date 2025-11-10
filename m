Return-Path: <kvm+bounces-62573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6E7FC489B2
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:39:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3C7C3A528E
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:33:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 841C7320CAD;
	Mon, 10 Nov 2025 18:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YtBPmCex"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com [209.85.210.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E23329E67
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 18:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799490; cv=none; b=MiiB0wAbOlrHqsFwKujKvGEns7MAPtchFKZRvWNoBNHVH3o7yW7hG3atVTydk1kL/S0Nhb+uXXod0xFRDRIUMthEL+HgX/Nmc4NvfUd0EB3f+CwAN9anDSMT4KuOeOSsLJ4gKbQSdp7BDt82xPh4gnMm1phT0ldxXzkdOLl3zpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799490; c=relaxed/simple;
	bh=i8D9N9aLAsadVZHepgTj562n2Zw46983WgY7g2rbvIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=np9qY1zfq6mjRa7C7q2eo7NvApJD4mPRttQObo0FgZC8gnFOe6bvNZXwCzJYDv9Vpp2d4iuFs18BkiiL5+kuMk4bZI8JYPKcJ8ppjU29/IbWGkmbwvAhImLTKsthc/i8+XPYSEc5c4nDW1s+mlK8Zz/XjQ2CkAx1/4CNaFBkkG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YtBPmCex; arc=none smtp.client-ip=209.85.210.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f194.google.com with SMTP id d2e1a72fcca58-7aace33b75bso3467201b3a.1
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 10:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762799488; x=1763404288; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dkImWwluqLl0unbtLxukS5JCZezOTWf1LR3pf4bVlHk=;
        b=YtBPmCex13dPhukcgtxdx4mSFbonOENUxmKyac/aFXflunnyRzSBaS/MoSr0R+fw+w
         4oEZjz0u8yzd2CK9/lb6U+bOjlqVYn9RDkjuNP+Ua+hP1IB57Q131h5W9IDBlocJqHaX
         u+yVcBLDLurW9jphdcSg4vxRvAcYexxtL1QrGlZYtZXNAMfH4IyZQHTH7kGUsdlbh/Rs
         y9urE/9yAxHeMJt9E/22MauwYS6s2pCx0oBciWFC50anLX6DA2T+UtlU1MEtKCLUIec7
         pL2dA2pAdcT7AL4xTfU1TIkX/Orf4PTXSMVmc+yLw1xF+P4wjudo7hExLGeDFPAOWR2D
         lIjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762799488; x=1763404288;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dkImWwluqLl0unbtLxukS5JCZezOTWf1LR3pf4bVlHk=;
        b=slcPns/zWCb77qfUllvt3FWtjNX/TT/9ju3dpcj2/KTM5cA7ym4IdZkvBMdghkllhX
         6XLR1dys/A3T3Up+knpk1/5b3195C06Kn9f7FmltLRo+5u8tvXkCKoWZGsbJnzmXOfe0
         Q/pzPcPTnJy4CQjk5T9a3xtzHa+xoFlnVjiR8tDnUiW/CV3n/dUgr2xCcvPWQ9xybODN
         8Eek4Y68w1d7iduuLjpmekvdM1AebmSARwXwARSdQlAVQqw0Ygw/gTo4cuBhQC8J2Xgw
         sNosfELSIMMhMO7i1H00DE7UWsxEhGhUgiyuCFtzTRXrHbb8GJ8dERlMe5VO0iq7hH4d
         jZUA==
X-Forwarded-Encrypted: i=1; AJvYcCWXLmIHiv6+kVpqzRX6z4mvyOMHeOB1dJnzLGyLthRrAXjXCmPb9AJEnCF2tCoeNm5ekiY=@vger.kernel.org
X-Gm-Message-State: AOJu0YysKbyntUW8f2hie73Jvv3TOeycIDoNhDD4gTFG8Yo2AoNNm1Rz
	O7exWq1biY21x8dH3/lVdUNgekXc+8xa4D1DSyf+IBDWOSh0lLNO+mDdUrwJz++RUg==
X-Gm-Gg: ASbGnctuB4HETzH6Me29If6H111115bo7+qdQ9KZ2f/TYoaQFArv+RL961628LmGnVP
	rVZ7WBBFvt/I2+vz0khh4H0I4mlv6QuwWzs3bN1GvV5Ql/McEssbbM8qhBluEj6zqx6RnyS/2BA
	3oZMQOKGcVftazkhIjTckYkl+PBnxxuaz+XSWzy0+FNxZ3Sug115IgH4s23JIMdplGey4jmkrC5
	fQBiKyQ+JjGdncPaLYFouOjuk2A//1Mgr+zgYZ6UeAd4dli867C/on3YYsRcCWTEXWiOYOibHPB
	9bGifQvDu8CWVe1ZqOcajSvRVfAw7Eb5hFRGCEihicfvElccCncpZJfIczA6kcF8wcaEeRXoHk8
	8TDgbzOjpZ9rpXLQBQGOpjs+EGk0Gr7rf5H1xXJs5Fy0M+vAfYnQMYOEMAv34Q4dqanl26KSPQ1
	HVON2niD12Jsdzaitaz2AIvBDgKZvg0iZQ5LzQpOO94Ku3yKEVqdm6
X-Google-Smtp-Source: AGHT+IGPKH4HGma3csbhveaZs1CSn5I7IWsl1AfR4TdBdcD+Q3vsS74qUZmAzKx4Z9+oS1kcs0NffA==
X-Received: by 2002:a17:90a:ec84:b0:340:b86b:39c7 with SMTP id 98e67ed59e1d1-3436cb91cdbmr12817773a91.11.1762799488208;
        Mon, 10 Nov 2025 10:31:28 -0800 (PST)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3436b9fa1c2sm8526715a91.14.2025.11.10.10.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 10:31:27 -0800 (PST)
Date: Mon, 10 Nov 2025 18:31:23 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>,
	kvm@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH 02/12] vfio: selftests: Allow passing multiple BDFs on
 the command line
Message-ID: <aRIve-gvdjg-npxO@google.com>
References: <20251008232531.1152035-1-dmatlack@google.com>
 <20251008232531.1152035-3-dmatlack@google.com>
 <CAJHc60yVqHHVjX2_oGVUBfBatFom-7-d3q9_uwgHy=-dSS4xNg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60yVqHHVjX2_oGVUBfBatFom-7-d3q9_uwgHy=-dSS4xNg@mail.gmail.com>

On 2025-11-10 09:15 AM, Raghavendra Rao Ananta wrote:
> On Thu, Oct 9, 2025 at 4:56 AM David Matlack <dmatlack@google.com> wrote:
> > -const char *vfio_selftests_get_bdf(int *argc, char *argv[])
> > +static char **vfio_selftests_get_bdfs_cmdline(int *argc, char *argv[], int *nr_bdfs)
> >  {
> > -       char *bdf;
> > +       int i;
> > +
> > +       for (i = *argc - 1; i > 0 && is_bdf(argv[i]); i--)
> > +               continue;
> > +
> > +       i++;
> > +       *nr_bdfs = *argc - i;
> > +       *argc -= *nr_bdfs;
> Just curious, why update 'argc' (I know we had this before as well)?

The idea is to parse out the BDFs from the command line, and then let
the test parse the rest of the command line. So we modify argc to remove
the BDFs from the command line, so the test doesn't try to use them for
something else.

> > +static char **vfio_selftests_get_bdfs_env(int *argc, char *argv[], int *nr_bdfs)
> > +{
> > +       static char *bdf;
> >
> >         bdf = getenv("VFIO_SELFTESTS_BDF");
> > -       if (bdf) {
> > -               VFIO_ASSERT_TRUE(is_bdf(bdf), "Invalid BDF: %s\n", bdf);
> > -               return bdf;
> > -       }
> > +       if (!bdf)
> > +               return NULL;
> > +
> > +       *nr_bdfs = 1;
> > +       VFIO_ASSERT_TRUE(is_bdf(bdf), "Invalid BDF: %s\n", bdf);
> > +
> > +       return &bdf;
> > +}
> nit: Since vfio_selftests_get_bdfs_env() still returns a single BDF,
> perhaps add a comment, as it contradicts the plurality in the
> function's name?

Good point. I'll drop the plurality and make this function only return a
single BDF.

