Return-Path: <kvm+bounces-67455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E5E15D05962
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 19:36:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 29FFB305245E
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 18:33:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCEE531A07C;
	Thu,  8 Jan 2026 18:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="mdplkM00"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06A63128BE
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 18:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767897224; cv=none; b=PWOplzMDtaFxFyLY6LouO9Yd+K9F4yFJ2BMmMROIhJ2/thb17QJchSvvZq+c6vxFLZPTFnfXufxtfhSMtpYCoDnvluhpwY1Fe3KRF9IRCFXSg34zctai6UKQ5b/oL7ynkWH6aOxD7p4b9t2pJZ1FDmvyKEO3Vt0g/6bDj/YSki4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767897224; c=relaxed/simple;
	bh=friVe+ZjDGl0vJha3E5L94T8EUtcvl8xY3GpjIuxSMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vfm2zwDpHn6b0dmz5nnN3jzU1U1lo45jO7VaGnr7HDlB7zHre3uywk/g5CTq1Kae1zINkN8EqhS7lq5MwMpOdM/bGtRmcMyawkUUpuD6LDJqNPUrNx/GQxeljBSO4iJnZMns1s30NEvOrG5+ivp6cQ4HOrR+x6icP9cV0l2eqXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=mdplkM00; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8b25dd7ab33so264089485a.1
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 10:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1767897221; x=1768502021; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VeDbCR7Lw3XLjb0kHArZW/oJZIOc8ufadN9fvBnzpPw=;
        b=mdplkM00FTtzMNdw4W2AhXt1dihAiMJcdr80l2u3xXrtq3Y4CchWzA5BaxDdIOnqvY
         K4hFFDpqQ24zbZTGxM/h10hEKD76drJH80UZDwueq3aMhRvqZojt/NGa2noknnH2AKcM
         2mwlIZqzjdH3K61O/z8S+42uXAG8aXOI0Q0LBAq+7up9Cf5qrsRqE3QPmP2MnSoOi06G
         90QsytLCcTOQHKlHu7qVtShpakHPkvRFDqKgfr1vU1AXYj1X0l+Oqn2Sj/8P7ycyLggo
         prymzqAdno/8te1S5QGeqp2O+SGBwTgK7u8asJj5lDObmZDYHkUulToO3wfy6A0ITz0G
         LDtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767897221; x=1768502021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VeDbCR7Lw3XLjb0kHArZW/oJZIOc8ufadN9fvBnzpPw=;
        b=X6c0JAj5cVHiSwESQl3m72wAnUdV/sxOr7vTMeHmPntKf++Olrl4OvcheQq442s9k0
         qitAe3tH6X/y0ysWHe0i43qFQMS3ZdykqqBQ7NIRJkwrdgp6LkK9YEtdPFEVgYGAOcok
         NXuwSSo+6PkCz6/1d+q4kkt9QbCodog3pQX60P6BmmMTA0CVOWmL//g0MImzGIs8ZEbQ
         yoJpaMlvQG+nfuJE/yZaIvWsQxzYXVjh0R6ja7278pvXe3AvE6DpyaJlz14e8GsGA3tf
         guIJ+L6D6GFPOhysOaJtQKvNCDJ0MvA98PRMte0zO9ix+SISuP7135erGjYDC+m7hBzj
         q2FA==
X-Forwarded-Encrypted: i=1; AJvYcCWY5stiYPOlLApf9VfB2VbVQp/ftT69f/LBgxSm2THFRzHVWcGn4P4qjEkehmdobIQZPQE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwoERm5VxVpGWkj8xyGMq9RAgsv8p4Fd3KUurvXdrKyuFAMQbfb
	aWYwbqN+v5d5OU1VA9e4zHv6uVDX7yAjZSxWQwv4ReOG8x8XxE9y1uGKq83zCUft7aE=
X-Gm-Gg: AY/fxX6+IypNFbov5nedELb4BTFNZksf5O2pchT/wmtRwvz+6Hqa1gi8F24Zoathcca
	HVG+5BF7OFbSq0YNt0kOuHP1nZckI3aByeZrcFW7fPB9bSiBroW7yIcymKQlBNt133u5PO+1OxH
	XaCbaGa7OdnZgWrTAfQ7Tc9ZfRJq8rr+yl7iw71VjjGuW9Da2D4OyQ+UgsUkhxT5AJNCoLJgxQr
	8dckCAisbaS2UfRRpfVmQgFsEpJf8dbN0mYLcEaHMyWeUFNHPt9wvty4oNNOWK1SnKLFzQ1UJzR
	VNGy3OtVqGHmGHWhoZP6czG/oqJ0KNV4fYLtFusu4nkAk4fcSpvh+QBr31PXJWbbFvblyeAGmwD
	DleVgTSdIkqFtS4ic2DsF2c7FiW3AY7KRXw1uEsRsW2a5HIeRqx0by8JtNgYt8PNir9OzoBRXi3
	5+4kxbMwycDQc/JcCxSEdgtLLXKo53uyU37cwu+M1U4NAS6JEIt1sItA/QUj7dbSjFtro=
X-Google-Smtp-Source: AGHT+IFvxaAGa9/1YlHwiUC0+rcyB8Si3/CdOHpRzOHE2IQYwWhD7wqizXJ2yXbaQu7l341Mgk8JvQ==
X-Received: by 2002:a05:620a:7001:b0:8b2:2607:83d5 with SMTP id af79cd13be357-8c3893fa385mr961645785a.75.1767897221473;
        Thu, 08 Jan 2026 10:33:41 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f51cdcesm640455285a.26.2026.01.08.10.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 10:33:40 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vdupH-00000002n7A-3fMQ;
	Thu, 08 Jan 2026 14:33:39 -0400
Date: Thu, 8 Jan 2026 14:33:39 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Alex Mastro <amastro@fb.com>,
	Shuah Khan <shuah@kernel.org>, Peter Xu <peterx@redhat.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] vfio: selftests: Add vfio_dma_mapping_mmio_test
Message-ID: <20260108183339.GF545276@ziepe.ca>
References: <20260107-scratch-amastro-vfio-dma-mapping-mmio-test-v1-1-0cec5e9ec89b@fb.com>
 <aV7yIchrL3mzNyFO@google.com>
 <20260108005406.GA545276@ziepe.ca>
 <aV8ZRoDjKzjZaw5r@devgpu015.cco6.facebook.com>
 <20260108141044.GC545276@ziepe.ca>
 <20260108084514.1d5e3ee3@shazbot.org>
 <CALzav=eRa49+2wSqrDL1gSw8MpMwXVxb9bx4hvGU0x_bOXypuw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=eRa49+2wSqrDL1gSw8MpMwXVxb9bx4hvGU0x_bOXypuw@mail.gmail.com>

On Thu, Jan 08, 2026 at 10:24:19AM -0800, David Matlack wrote:
> > > Oh, I was thinking about a compatability only flow only in the type 1
> > > emulation that internally magically converts a VMA to a dmabuf, but I
> > > haven't written anything.. It is a bit tricky and the type 1 emulation
> > > has not been as popular as I expected??
> >
> > In part because of this gap, I'd guess.  Thanks,
> 
> Lack of huge mappings in the IOMMU when using VFIO_TYPE1_IOMMU is
> another gap I'm aware of.
> vfio_dma_mapping_test.vfio_type1_iommu_anonymous_hugetlb_1gb.dma_map_unmap
> fails when IOMMUFD_VFIO_CONTAINER is enabled.

What is this? I'm not aware of it..

> Is the plan to address all the gaps so IOMMUFD_VFIO_CONTAINER can be
> made the default and the type1 code can be dropped from the upstream
> kernel?

This was a dream for sure, distros can decide if they want to continue
to support both or have an option to do just one.

Jason

