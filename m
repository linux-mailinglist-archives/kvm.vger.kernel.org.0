Return-Path: <kvm+bounces-67676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 653F7D1009C
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 23:14:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B2B7A302D8AE
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 22:14:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C79F42D46C0;
	Sun, 11 Jan 2026 22:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="C8lsg9Ft"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41A2289358
	for <kvm@vger.kernel.org>; Sun, 11 Jan 2026 22:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768169684; cv=none; b=Iq8lX2g5hJ0/IXHfVbqRqdYH939wrPUaVdg6xVLLdViEfjgHYQXAz5LPFFOt1se0dK/Oi5IxyGGVOzIzxxBHe4o63p8kEXmZPNW7mwhMbrkVW9V9so0UmGgtbcrtwyf0gPE+8RuiQaguBwFgtH+6Z3sfBZaQWfZbvP7aC18mS4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768169684; c=relaxed/simple;
	bh=rHiryJM7d29n7Ir5Iumqlnov61xpCgGo0ADph/D20A8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m0mdCrK7s82MkMwldfdkKznYXUCKww/bRWpCn8Etuic/D0ZqXD9BFlE+wbARl8qtCBl4eI6bZeRXSKHgy1DRCTjprjZO38zdoy1cXmLcitIokWyJBOLLejl7CHaNbZqYSPNTqiwehH3rtAruGcfDL+aqzf4c1o3+N+LDQttPLrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=C8lsg9Ft; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8c0d16bb24dso553019685a.0
        for <kvm@vger.kernel.org>; Sun, 11 Jan 2026 14:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768169681; x=1768774481; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rHiryJM7d29n7Ir5Iumqlnov61xpCgGo0ADph/D20A8=;
        b=C8lsg9FtfxlbBLSrRiLLwdQs5WXWbqMBmOC6bccWYim5M7OkJbiaI0+bf0HzTDNnTl
         cPqu4Zm1ZjBcErgLSNGrlnHW9qvRcbN2qblkBdnm0Js+Y4MrhpDOX+INQUFc01Vpax52
         XeefgViK/WjC/9Pkw0oj8QJjfgm3Ku4qePg77VeF6DVVDB2zasQTiAMPSGYYxs/gpWUZ
         w3BQQqA1Q8358cM7qUYI2f7vY2aQ47ZcoDVYv3VZ0VEQ77myUpUFaRRHeLY046jQ5UL7
         AnVK0jsZanVV18m5N1daj7/rQqcU/8BZ9eZNC3Ng7CCFzTo6lyKLGlUhynxoHu+lF8ek
         SKKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768169681; x=1768774481;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rHiryJM7d29n7Ir5Iumqlnov61xpCgGo0ADph/D20A8=;
        b=TIpdUBa+6VP0E04UUu6lfvZ39PYvw6k7oKXJ6GKxLL9JkBq+px1si/u3ogxA78TH+C
         XkAFWo+BVANx7Yw9eW16oDxY7Vl9L1nYzAnTWxDewV+0bhM6Sje8gmh4a1G50tkC63CN
         wP3f538CqS4WDAsnlJWZcXZE4G6pqun24ALK1UbiUKyh/LOWJIQ/1wnXkFiFpVbimBMY
         lOkegkijF1j5WCXb6QKw+PzeYqb+2umoHWCq5Sk/rtehkPj2mKDBvAa5UMYnrh1NFkhm
         UJWXwctzthZ8LQXEBEq8g9Fjv6quZkgZp2j0fRDdIDAJ4Fu2xLxvYlPic/lgyOVz87d/
         7LxQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1PmB/+gH0ft2292sIF7+n1A4quhY7qoBX0lznI0oG9NFgl8Kv+u5pPQttQG8EQgv0yjU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAQ0F1CqX3pN/3iXPF/FLCbk6mz40vp3oqwMc81iLKo4HFxw80
	eYWkTufoKt+ge8eJBiislTHg99Tm8IVwFq6V2fy7b+OToRZ3rvN+YVl8mvrK/XyRyAM=
X-Gm-Gg: AY/fxX6ZkV3VDb7lm9tD7vcSaOJXzQAP8YElyhO99HKBQK9UZA0AuBX7DNZXEjmiQ3j
	xEyciWjyG3NU7NK2Igtyv4VZHxx5nggeHaIyhGv1koa31ONWAjvapq12B2kI96464NMjb8RO9Y/
	0iDUihuAKbKCngcIHN3CF4LaDMOJSR77G+iOiDF3vVqIm1IqYqkIF5nyZ0DCEoOjpQIv9WvWbyV
	uoqIipphM37gDjC1gAikRknPXKnm+Gdtldpfgwz6Qs7ooyDeIKTa0zM9AuyZksHcAvk87FU7jli
	4UIsFhwxcUspAyVx3zMYbnPFOLpc+q7xCVcn/V7KZFf8EWxCfG51YUxEIaYIUGeF86436NMkQs8
	3Y+uzdmQ+gXwhfUSVpwcYyWkpDiBEkm1WAIR9LgrKJLfm95BOycPo8iUsirc674Xr1+riZVBhRp
	SAX1xq/8S8JuAMGmPe1NCdNTYonqDb4foRgOU7jKbi2s+JcfQzkuk7ZA6b3yYVOhGRZ+WaQmz55
	qXEmbwqYiyqaf3o
X-Google-Smtp-Source: AGHT+IHNj93eZH1ynTU8daiu8l11Esrxq9PJGGVD0zEpnE5HUdS0s6ZkqCQ6JfdxMxeReo3KOm+E4w==
X-Received: by 2002:a05:620a:1710:b0:8a0:fb41:7f3c with SMTP id af79cd13be357-8c389383f76mr2218905785a.27.1768169681510;
        Sun, 11 Jan 2026 14:14:41 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c38a9244bdsm1117335285a.3.2026.01.11.14.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 14:14:40 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vf3ho-00000003Kpj-0I67;
	Sun, 11 Jan 2026 18:14:40 -0400
Date: Sun, 11 Jan 2026 18:14:40 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	David Matlack <dmatlack@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>
Subject: Re: [PATCH 0/3] iommu/vt-d: Add support to hitless replace IOMMU
 domain
Message-ID: <20260111221440.GA745888@ziepe.ca>
References: <20260107201800.2486137-1-skhawaja@google.com>
 <20260107202812.GD340082@ziepe.ca>
 <20260107204607.GE340082@ziepe.ca>
 <CAAywjhTEyOUmxWeCX6GwCBSnMf-p18Ksu2TUYeQ57K8H4RW-9w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAywjhTEyOUmxWeCX6GwCBSnMf-p18Ksu2TUYeQ57K8H4RW-9w@mail.gmail.com>

> Thank you for the feedback. I will prepare a v2 series addressing these points.

I think there are so many problems here you should talk to Kevin and
Baolu to come up with some plan. A single series is not going to be
able to do all of this.

Jason

