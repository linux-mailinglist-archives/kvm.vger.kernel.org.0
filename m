Return-Path: <kvm+bounces-53505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C90BB12A01
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 12:09:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A29E14E8405
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 10:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D808233722;
	Sat, 26 Jul 2025 10:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="PU3YGlNB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E02231853
	for <kvm@vger.kernel.org>; Sat, 26 Jul 2025 10:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753524554; cv=none; b=Ue+G5cxNWdBHLYdnsYt+rXDEbHGYUQTrWKje8wspwqH7EdfW3qOJM9rKGda5ZHi5DIumAz6zuBMU71ZWbA49nqQyfuw0XwjPrny97kaBHZJ96p/ZKU26EaHYAB3G9PykbgO9/sQ/y/a2T+RHjM1pr1TnMV9vL+Si7fSnk9Cpnxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753524554; c=relaxed/simple;
	bh=DyCbdcECU2WAKLBi58ndrvS3xi7zOjpla3Uq997d50I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pihu7dSCH2NnFAseB4XO30Nje37BuUju3c8slOqOWBJD4U3/LPRZ+54H7AF8CCIaufnJpayShG00QL25FBvxVHBbWUja3ZxN+2CdgGlKoV6ydZdUZ5QTnCihbLBRG5tkxQz9UywSsXZaE1ejyISKY0N1awQfhWdZ+l9ztoKzQbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=PU3YGlNB; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-234b9dfb842so26063485ad.1
        for <kvm@vger.kernel.org>; Sat, 26 Jul 2025 03:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1753524550; x=1754129350; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uI61kTu3Z9HBCe9N6Mig2mBJLeRxGnBOwpeOs/JzM68=;
        b=PU3YGlNB8vCDr3ndeq0YZ8guk2I1yfR0U+Drh0An+XcITZs1ejZ8PbH/noQcnJOOct
         xMZe4vhERfD4NfWrnRK8Z3FSxK3TRD/JtbSPuDxcdhLeg1IxN0Ac5DGBHa0OyNJWwV/S
         RPmRaY5H9TTVaF8lO9Gs7yOQzlTB23LwScNi7Qh5epeiqSBgcYpsFtvAXfvklurENEyU
         9jQXD+ZAV0kXw/Drm1efeQRezqnLattgrxARF5P3Lz+Qpr5SfV2+Eso4/cQ0UISRF/Pp
         1xs6lIUOQfDU6GeDI+8lXpAvWJaz64VtK2n1sXAtlhq7kDZHx6rgWNJX5SZ2cPKgM+DG
         Cg2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753524550; x=1754129350;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uI61kTu3Z9HBCe9N6Mig2mBJLeRxGnBOwpeOs/JzM68=;
        b=I666KI4fllIG4Jlmj+r4mj0/KIqYa/fxnzom5GBiWMcHig9cthYQ2izV3uqbpwE46u
         K4/TN3VV5eXQGTAT6GbKu11xatd+BxhSOcWqUkykG3jmVEiGznXHglphijg+BV8JaAeE
         jAETeZNV8C7Q7OhIZoTqlXQMZQ1Bky797EbpHuneeG0bxFYn4tEA9Fsy78WQBewcrY2H
         CNq3dXdU7LFwv7vLKzJQu8D8NJqQM/ovDyDDWG0YiRqVy6euCV2NsHx3EVcIR0vrCiIN
         CULs0ThbydZkC8eJlv57NlgdThgDjiMv+xg2665lgArsKSEkMFnrK9VBynU/Puvq1Ngj
         MfrA==
X-Forwarded-Encrypted: i=1; AJvYcCVH2SSOQt3C1ts8G4a2F9QCqLKYds2t8p4MOjo7VYTAyIs6Oq2BQuTqHnBoyqJWY2GtV+Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyTVqYxYN3XLDbTsk4bsJ/6sKbKulFOr40ppDAPIpRjdSks7NI
	gXy6kLv70vLdwZEoxioEc+fuUzeg6Ubeur6DAMO4DIbtfAb+YETvUryMpTcoJAH/CudDVhMfX5u
	6X6oYno5Rb7/4YTws5h1xTtrQifYv+ZJ/TEEO68DAJ14oN1c=
X-Gm-Gg: ASbGncvhRJC77EinXY5MTYHMnefv8h1m4vgYLl3B30RZRMmZjbnuCGZAyMB20gCVhVr
	I7Hm19gYhj/Mon/4tBteF4jjyAzDlSDMfjbCo3Baf4Ie1QZl/YiR/ni16ZoUMvGi9e1DfPxMk91
	+DPKxNFRKk5e/R0sKP9JLtKYTR5+Ik9z+jSe7Ois6JDfLAPXDpTvMCk7+gCXdvrURKVLFzlyM/w
	IgFu8SFuOvhIX9bnvsw+KQbHcHRVOFPQwPeYUn6ETW0NWY+KLuCKu7iDrs9D6zOZeKOwp26HVrA
	pA1D2TfNbIG3WulHhTsmMCGpv7LXnUBrTYbw96ay+awXQ9tx4qyXJGYUvitQTpoWGWrPqO3iN2Q
	On5olPtw9TdLyQL1S2bYinH85lhNdDMjMDiAhzOZxUcJGVPQx+NVjgm330uX0
X-Google-Smtp-Source: AGHT+IH3pK9wFHIfPY4w94CT1QeavRR9MgGPuexzcHYcWfICRIAfzdUgzIf/r47ot+BKH0XypAs2XQ==
X-Received: by 2002:a17:902:e887:b0:22e:4d50:4f58 with SMTP id d9443c01a7336-23fb315a903mr72899485ad.31.1753524550460;
        Sat, 26 Jul 2025 03:09:10 -0700 (PDT)
Received: from zenbook (1-162-100-110.dynamic-ip.hinet.net. [1.162.100.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fbe4fd06csm14156495ad.85.2025.07.26.03.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jul 2025 03:09:10 -0700 (PDT)
Date: Sat, 26 Jul 2025 18:11:43 +0800
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: Marc Zyngier <maz@kernel.org>
Cc: Andre Przywara <andre.przywara@arm.com>, Will Deacon <will@kernel.org>, 
	Julien Thierry <julien.thierry.kdev@gmail.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool v2 5/6] arm64: add FEAT_E2H0 support (TBC)
Message-ID: <qm2d74s7sqxgzupnc73uuwgginuzjoqlrfzycripfpzgpvu4p7@nth2cmrodr53>
References: <20250725144100.2944226-1-andre.przywara@arm.com>
 <20250725144100.2944226-6-andre.przywara@arm.com>
 <86cy9o8bwn.wl-maz@kernel.org>
 <zbgu6irpeytcpymaxpg55tvijeppfpdpwcju275g3h6bx4u5qn@35vb5ymt55hx>
 <87jz3vtils.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jz3vtils.wl-maz@kernel.org>
X-Gm-Spam: 0
X-Gm-Phishy: 0

On Sat, Jul 26, 2025 at 10:19:11AM +0100, Marc Zyngier wrote:
> On Sat, 26 Jul 2025 10:01:25 +0100,
> Wei-Lin Chang <r09922117@csie.ntu.edu.tw> wrote:
> > 
> > Hi all,
> > 
> > On Fri, Jul 25, 2025 at 05:37:12PM +0100, Marc Zyngier wrote:
> > > Hi Andre,
> > > 
> > > Thanks for picking this. A few nits below.
> > > 
> > > On Fri, 25 Jul 2025 15:40:59 +0100,
> > > Andre Przywara <andre.przywara@arm.com> wrote:
> > > > 
> > > > From: Marc Zyngier <maz@kernel.org>
> > > > 
> > > > To reduce code complexity, KVM only supports nested virtualisation in
> > > > VHE mode. So to allow recursive nested virtualisation, and be able to
> > > > expose FEAT_NV2 to a guest, we must prevent a guest from turning off
> > > > HCR_EL2.E2H, which is covered by not advertising the FEAT_E2H0 architecture
> > > > feature.
> > > > 
> > > > To allow people to run a guest in non-VHE mode, KVM introduced the
> > > > KVM_ARM_VCPU_HAS_EL2_E2H0 feature flag, which will allow control over
> > > > HCR_EL2.E2H, but at the cost of turning off FEAT_NV2.
> > > 
> > > All of that has been captured at length in the kernel code, and I
> > > think this is "too much information" for userspace. I'd rather we
> > > stick to a pure description of what the various options mean to the
> > > user.
> > > 
> > > > Add a kvmtool command line option "--e2h0" to set that feature bit when
> > > > creating a guest, to gain non-VHE, but lose recursive nested virt.
> > > 
> > > How about:
> > > 
> > > "The --nested option allows a guest to boot at EL2 without FEAT_E2H0
> > >  (i.e. mandating VHE support). While this is great for "modern"
> > >  operating systems and hypervisors, a few legacy guests are stuck in a
> > >  distant past.
> > > 
> > >  To support those, the --e2h0 option exposes FEAT_E2H0 to the guest,
> > >  at the expense of a number of other features, such as FEAT_NV2. This
> > 
> > Just a very small thing:
> > 
> > Will only mentioning FEAT_NV2 here lead people to think that FEAT_NV is
> > still available with --e2h0?
> > Maybe s/FEAT_NV2/FEAT_NV/ makes it clearer?
> 
> Maybe. On the other hand, we never advertise the old FEAT_NV as such,
> irrespective of the state of E2H. This is indicated by
> ID_AA64MMFR4_EL1.NV_frac==0b0001 when NV is advertised. So I'm not
> sure this changes anything, really.

Right, thanks for the input. Even if the user doesn't know what's up the L1
hypervisor will when it checks ID_AA64MMFR4_EL1 :)

Thanks,
Wei-Lin Chang

> 
> Thanks,
> 
> 	M.
> 
> 
> -- 
> Jazz isn't dead. It just smells funny.

