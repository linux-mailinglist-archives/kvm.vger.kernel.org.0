Return-Path: <kvm+bounces-63401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AB65C65945
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 18:44:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 84E184ECA92
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 17:41:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 871AB30CDB0;
	Mon, 17 Nov 2025 17:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="WP1euryQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9802D12EF
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 17:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763401281; cv=none; b=GpI7XzxGfgp6ZgJPgkHtkmo3iz/YyCG3p7oAMSlJMDYL4YYfM8aaJD567+Ou4mcNZTByY1HDPse0FBb8vhjv3CQnvZbW0qf7yfGJWY2K68dzpIPbNp7jqXzPRgFrp4N+SG0KIj9hP1lWrbaaN/0C/hW/zU1n4GMCMV/hi5hsDio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763401281; c=relaxed/simple;
	bh=IB90dBi/qsmk4ecg4IHoAXNcO0NnDhaIxyKcqoIR5yE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ofpr/5DpIgSmNUWIUMLLXVI6ZT2/w+BQHr0ynPWJdtxGhQ5zpvfEyaL5RBdfTnmB5HZ3co78MEsylLkYDYtBOAhdihh0UaoAjyR3EfEzRzP3idIO5hzCCrqnC/WWG8Uhn2l+1gxYuy2LgqNAcS1/0RNu8kKOA7FLYGeFxHxWOIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=WP1euryQ; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8b2dcdde65bso308976585a.0
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 09:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763401279; x=1764006079; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1qJkF7xzNvfW27lcwrRkU63X6JYTODC8vdP0RYsotYs=;
        b=WP1euryQStUrZY4RonhrlsSOVI27gePQEgXXfN3xF5qOvb4WpXT6Thg176lEVV5/dq
         b+2oguahxeV+/sFnFgQ+5DbUxOWBedFHs8zas/Iz+P5iYizV6uwWUUJDABLA14HQMLHC
         xtFqrb2Tt0VKxnDAU74Dxkw8XIL5ruNezCDs2JbVU6O9T5h/F4cEUJGdpzP3podUb6BG
         +V4zB2egOBdZUTPmzQmHsQoVbW0Yoi7qq6weBuxI8CW29iOgizLzFnqQWEEnP5JAqdwG
         F7XmAABJnM3ICzehmXs/1ifO1+bol7H3WcviMRl5arL8Y5VWbYu077hBoG8/roxwneBc
         CEAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763401279; x=1764006079;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1qJkF7xzNvfW27lcwrRkU63X6JYTODC8vdP0RYsotYs=;
        b=wLavlOKQ4YoswKJ+km4Cy3aGb01sITMPWHgwfgQZYqmRQHzrLwbu1/YtAzbkV0cCmT
         G8RBYJdvTE8ML1+GaElxUbWPhRy09LRZl56U/ihSRnqrgpYmeD8GD1OIS6nqF6yPAL9m
         RBsAUHUIL9YAteaOsWnIsKBjRNmSU7ifeYa9WP5+bY4eHoCaJMwPysRr1mO0T8d6HsY2
         dN9vLzIfSlH+N09Wm8GHj/vxKABVytsczxZEzwrE4clIYgKYt1H0Z8QHil+dTxO1lZZR
         6VhcI1heB9ZaGbueOwmBnBItp178f1IV66Wl4FC/y8z1aEL9Cg5/WYS9qK6bZcSb4jij
         uo7w==
X-Forwarded-Encrypted: i=1; AJvYcCWS43NW/+rHZ8KaHnRc7od8muJ9g7kbjetVTcoUyrjI6JWRHCp8DKPs3lNEUEfw/qZkDSw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzyia17ytgU+LPaCl46phZRylBRskk0yAsweHtpjBvCYDbmM9Ss
	fGMk3e5HtS6vazM6dt3IfjZRV+T3wx0F0PlZ7HYpTpJvOMetrxgT6ZrgMpiaCfnpqREs0LYfn/n
	/zRozIB+5rA==
X-Gm-Gg: ASbGncuqPhji7Hs1MIVXFWrP5TuSp09kGQ0HsuYUWM7XIAC46STCrpEZl6a6NcEzxfj
	kpV6Z37X3iIcShnO2icdtgFbpAfVJkppK6uPvZMemHsdje3YrKtp8TZYSceI/HPwckN1LZX6JYc
	YHebp0RMfiYrx4aIoQKA4cuTatj0c4NQktSllQGnNgIcDmyDJJddVCCbAgOq4182Okm3Sq4/C4O
	cGGkvn53fCTjIdUbCjxWX1VvvyoJT+I9ohEKoDzqFNQ4j3DbudNYjMxRJEk1OaJtcvbTZGhsq15
	pqREGv/jafyRVuFCYePvPAIqE3x/qRKYiapOoAio2t+YMwOzmmXuFt954An90b/PBPzBLgis7nO
	XpQxaJtmPPaVSDT9Wli+z/Ytb863rK4kTDNU6l3r/eDsXMiY8Z/28Z1TUZExmATLghhhSH1O8ve
	6UT1As3bfIRoNtFrqO9nF8pFMcZpo3OaQ28V6+y9YA/PL7HnGO3JfGT3QlrQyZbCkrr+M=
X-Google-Smtp-Source: AGHT+IHUC2kQJmZzWtfj8JN4lQU2Yv/bM99hDpBURjfV9QCaErsZnrfxPgnm1j7nzf/zhiOEyak+vg==
X-Received: by 2002:a05:620a:4484:b0:8b2:f182:6941 with SMTP id af79cd13be357-8b2f1826c89mr417050685a.57.1763401278929;
        Mon, 17 Nov 2025 09:41:18 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2aeeb541esm1003670385a.18.2025.11.17.09.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 09:41:18 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vL3E5-000000005dU-3LHI;
	Mon, 17 Nov 2025 13:41:17 -0400
Date: Mon, 17 Nov 2025 13:41:17 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Winiarski, Michal" <michal.winiarski@intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	"De Marchi, Lucas" <lucas.demarchi@intel.com>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	"Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	"intel-xe@lists.freedesktop.org" <intel-xe@lists.freedesktop.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Brost, Matthew" <matthew.brost@intel.com>,
	"Wajdeczko, Michal" <Michal.Wajdeczko@intel.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	"Laguna, Lukasz" <lukasz.laguna@intel.com>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 28/28] vfio/xe: Add device specific vfio_pci driver
 variant for Intel graphics
Message-ID: <20251117174117.GD17968@ziepe.ca>
References: <20251111010439.347045-1-michal.winiarski@intel.com>
 <20251111010439.347045-29-michal.winiarski@intel.com>
 <BN9PR11MB527638018267BA3AF8CD49678CCFA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <7ig24norebemzdih64rcpvdj22xee23ha7bndiltkgjlpmoau2@25usxq7teedz>
 <DM4PR11MB52784CBB6C5AF6F19E373A278CCFA@DM4PR11MB5278.namprd11.prod.outlook.com>
 <ndd4kt4elbm7ixzyouhorgatjwv73ldyjo6bmrbipxvaqzccjs@ssavf6b5ric3>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ndd4kt4elbm7ixzyouhorgatjwv73ldyjo6bmrbipxvaqzccjs@ssavf6b5ric3>

On Wed, Nov 12, 2025 at 02:46:08PM +0100, Winiarski, Michal wrote:
> > > I agree that it should be done in the core eventually.
> > > I didn't view it as something blocking next revision, as the discussion
> > > was in the context of converting every driver, which is something that
> > > probably shouldn't be done as part of this series.
> > 
> > well it doesn't make much sense to push a new driver specific
> > implementation when the core approach is preferred.
> 
> This would generally mean that accepting any new VFIO driver variant
> would be blocked until core approach materializes.
> 
> Jason, can you confirm that this is indeed what you have in mind?
> Just to determine how urgent the core-side changes are, and whether
> there's anything we can do to help with that.

A core approach would be nice, but I also haven't looked at what it
would be like.

I think if you post a small series trying to build one and convert
some of the existing drivers it would be sufficient to let this go
ahead.

Jason

