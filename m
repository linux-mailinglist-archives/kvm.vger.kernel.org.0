Return-Path: <kvm+bounces-23408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E87F394966E
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 19:10:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F03828C4AC
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 17:10:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACB2713A256;
	Tue,  6 Aug 2024 17:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="kgmgoWKk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D5944C81
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 17:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722964055; cv=none; b=HhiTsVs/3elcm3ZwrWl/jOJq1QPYs8qcyBsIhLUJZguxz2XGaZKejqm+uFBjFro2ueHkk+QL29oFlDt66LYWWjEjcEPtvV8j0pq8JgFRw6xY1K0Zgu8rmWvOvgXxEZVeJadf4r2eMxm8lcmAc9maXDwHAEP0of9eOWJXjBp8YrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722964055; c=relaxed/simple;
	bh=D0EqhIxhvx7GmkVlV4RcZGqzvhiaGUxstiP57vQqX30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fz9D6l8XE5fOH1ueBONhwd4FDJOK7iG8JRvOLdxgaCG415P/+7qqE5k/xLgCq2qnIft910b+EMKETjKFEUMOIP2vtljA6Jne80BQ1XcXUZnNlnSriqazvqPM8EOcHx9bTl7R9ss3gUIM/12s0BLhZEbnYwOIbT4Mg9tlsDlbPeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=kgmgoWKk; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7a1d3e93cceso4201185a.1
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 10:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1722964053; x=1723568853; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Swgs6PeNGxaDxA9jd1fMMQ1ghP/MGLEuaiS0iU4GSE=;
        b=kgmgoWKkL53ggFboHSRou8KhnV2+SxAaAKG7pKOSwN4XvHajpUq99VJRteiQK9V3XE
         e8688kuspD4GynRB3+BMgufKqYxv/3sLVoYVL2wB9yG8/f1ezSciOaxsIhdsQL0AQxi0
         Iq7qcSzlW0Qof2Xntx0G/dMfjwfj/7sRZF73mYIKmznkU1lfKfLTqBkLDXniLtLnEpOG
         JZiAFusQbj+1q+fhf8hPKKvn1unsb7cnnRcRbfnvnfjPfVveJqg6iWy3q3RGEqs7di2C
         5aEgFxPz1sQc/38C5L96evGb0e/ueA2ivn/ikoeZLwSfwE9cNbR5paXYdDFusfNFIRwp
         XeFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722964053; x=1723568853;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Swgs6PeNGxaDxA9jd1fMMQ1ghP/MGLEuaiS0iU4GSE=;
        b=HIMyAg1YIs5fmslrdCEzgLcYr6yGUswGw4ZSgpFASV8SPTklNcaYcLI7/sRbF7DN/D
         dFaPWRM1tp9+SzGi/OgRQ74oMtzAg9yzRsXz4COZYfm/Rp4hmGShmPBeuf8dZLqVWYcu
         xiXyYeaCMbzp2JwNDMuoBM+KlEUc2ah8RBy3MQC83cs77c1od13YnbotwRCGfYvGutjf
         fAVLyS+PxZnwWGenvTiItfkNTRtQOuQVB/Qj05pn9B3GJ1SJqNt6GRL8CsIcUFQSOaIr
         J8HcXORV3X6V/WOf7p8QAvJwYFJY1YyFa6+xKJuA9atXVYg1sQhbaAMEtO7ZLE6mZY9j
         yWWw==
X-Forwarded-Encrypted: i=1; AJvYcCVcNpulo+F399EYiFtElwKpv7c601sp48WOkhWTct6JqPoVQdSEIVvAEfF0IpUFvN1lwsgpfwlwSTyYQCLlApoeV4ml
X-Gm-Message-State: AOJu0Yx5emS2yXYSoeecNJF07+DiuhV4ej1SmpWwuu51crx84sujxpvu
	hrvZ1WxO69wCT67ogYRVijN+JxXJoRmF9wRxc2ZWTC+jjmWgUWjI3wCtaRef+iQ=
X-Google-Smtp-Source: AGHT+IE59/is4StpB7Tpyg09/2EfkSpUVm6PoV2DEu7YBZ8kFMTSfo0JCdO5wu0EvIiLssU8PgNKyQ==
X-Received: by 2002:a05:620a:1aa1:b0:795:60ba:76e9 with SMTP id af79cd13be357-7a34c01dd5emr3065182485a.4.1722964053146;
        Tue, 06 Aug 2024 10:07:33 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a34f6ff716sm472395985a.64.2024.08.06.10.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 10:07:32 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sbNL7-00FOVv-95;
	Tue, 06 Aug 2024 13:47:13 -0300
Date: Tue, 6 Aug 2024 13:47:13 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Keith Busch <kbusch@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Keith Busch <kbusch@meta.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH rfc] vfio-pci: Allow write combining
Message-ID: <20240806164713.GH676757@ziepe.ca>
References: <20240731155352.3973857-1-kbusch@meta.com>
 <20240801141914.GC3030761@ziepe.ca>
 <20240801094123.4eda2e91.alex.williamson@redhat.com>
 <20240801161130.GD3030761@ziepe.ca>
 <20240801105218.7c297f9a.alex.williamson@redhat.com>
 <20240801171355.GA4830@ziepe.ca>
 <20240801113344.1d5b5bfe.alex.williamson@redhat.com>
 <ZqzsMcrEg5MCV48t@kbusch-mbp.dhcp.thefacebook.com>
 <20240802143315.GB676757@ziepe.ca>
 <BN9PR11MB52763F2A0DB607F9C2BB97928CBF2@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52763F2A0DB607F9C2BB97928CBF2@BN9PR11MB5276.namprd11.prod.outlook.com>

On Tue, Aug 06, 2024 at 07:19:18AM +0000, Tian, Kevin wrote:

> "
> Bit 3 should be set to 1b if the data is prefetchable and set to 0b
> otherwise. A Function is permitted to mark a range as prefetchable
> if there are no side effects on reads, the Function returns all bytes
> on reads regardless of the byte enables, and host bridges can
> merge processor writes into this range without causing errors.
> "
> 
> Above kind of suggests that using WC on a non-prefetchable BAR
> may cause errors then "prefetch and WC are related" does make
> some sense?

prefetch exists in the spec to support historical old pre-PCI-x
environments where a bridge does all kinds of strange things. prefetch
turns that brdige behavior on because otherwise it is non backwards
compatible.

In a modern PCIe environment the fabric is perfectly TLP preserving
and the PCI spec concept if prefetch is entirely vestigial.

There is no clean mapping of what PCI spec prefetch contemplates with
how moderns CPUs actually work. They should never be comingled.

Today we expect the driver to understand what TLPs the CPU should emit
and do the correct thing. From a Linux programming model with modern
HW we never really permit "merge process writes" or expect
"speculative reads" on anything except explicit WC mappings.

Jason

