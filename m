Return-Path: <kvm+bounces-25563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F104966A5D
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 22:22:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6AD721C21F55
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 20:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 937B61BF7F5;
	Fri, 30 Aug 2024 20:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="KxmoDGfa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D2F1B2503
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 20:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725049351; cv=none; b=C4RNCyodC7T3Uw5+MiTIsPvFEcfXmfH5VbBpw5RN1FEVTrrNfN1Cf0fK64d0lJLcltGiWimB7PNHwqZXomlTuVFR3TKZjtbhw1fQgymZHy9F9K9TlhK6SOcvnEqU2u6DbquPp4xm+WlD7YC3ZY69e9Qqe6w3+msRxY7imRmq0+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725049351; c=relaxed/simple;
	bh=69g76M+8hefwuaehmWYZbLKVNzg3ea6UZdDzVjREdlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ICXjj2+6hmhnERJ8cukGroVL8VcShe683VazecchBAMQ8pSUQmmDM2PxOabs9nHidpvxLkvcMXlgeQ0XB1mf6LXvc3fwDfu0rA88CPvaORlhfkyfFrWgJuN6hdjgg2SC0Rr6fY3gpVuMWLJE8JwdSx6/k47yR0LfVqgRYuvhhj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=KxmoDGfa; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7a812b64d1cso73706485a.0
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 13:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1725049349; x=1725654149; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JR/0i0yiNSc6+4mgZmofS3FVrEo7P/f9nDPweyfHOlc=;
        b=KxmoDGfaMw62PtUhO0NhVKQjJ5vGXWePdj51cDaiAHjpb1Wud2V56kg+JU4W3vTLlV
         hQT6+fMKtsavEgQd8MRvW76bImH51I8SCFfG+LxSVF3ktDzjQz+2IEVe3IjZvNT5eynx
         P+/sw/juP77lCTTZEY/8pWbi6tgWqw0w5OBHZqNQ5Jmg75OpoHdl9FBt7NkUdBH0rIaI
         rtPWvM9zEI6ohpjAD9ApyA8R7wm68wle1t03NzWWaMS7vCLISw2FXqKqXD3Qknr+wl+D
         S4L4v/crzti6D62Y7XulXhnURndaNtZVvdOfFAOsGf4Lc03RIdfctcEP7w/iRO82uG2c
         HMqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725049349; x=1725654149;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JR/0i0yiNSc6+4mgZmofS3FVrEo7P/f9nDPweyfHOlc=;
        b=SQcPlUInc+nZRE9BFWUok6X4Cpkr7vwtHU9qkEHqBD5YOd/HR8GIJxOQ5kWOfSaeIy
         P2uvhW4sYIdhGaNMY4W+6WZ6jut32p/QIXNUX70K+yZ6ge6NB3pqZnDeRqoIx67zmZR1
         T9Qnd0xwC1YAo0Wh+oXtM/0tdTagxCSsE6KA4cnhLmczk4aITywX66hyh0/vahan9jCP
         Y79H8PzE6FhiGVn5mhCONcCYO+MSToAsnkGnITdN3g8vTiX73SShMRyChZknQSG3CeKt
         a0sZu2jvm4yechMlSMfqHQ/aCFNT7XgWE3wnF/7+C3ChNurnU8c6qrZlKeLIc3w23/LS
         Virg==
X-Forwarded-Encrypted: i=1; AJvYcCVLj0Pimxo7apXBtBfWhrJq456xZk9OUYWfUMcaCP2RaZ+fcO21r0DkOt7vw1+NZVIw6MI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwERIS0n6ud7H4HO846vO6WDZlx0Lz4FRuQ8ZmiYr1m4E+q5sSV
	o9CkWvIQ3R6PPOc588dafRJgh6UwtbPeGxWyJF+w0C9hYzLrwhCiw857SOsx/0c=
X-Google-Smtp-Source: AGHT+IE3fznrLjug1k6BmssxKA2PoSv1rWSM5UMVETLEHHqg9/Fb0jaD+sDVJuxj/qFxWflQcys1Iw==
X-Received: by 2002:a05:620a:f06:b0:79f:57b:f633 with SMTP id af79cd13be357-7a80427797dmr757399385a.56.1725049349148;
        Fri, 30 Aug 2024 13:22:29 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45682d66c30sm17088371cf.68.2024.08.30.13.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 13:22:28 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sk88a-00Gb36-36;
	Fri, 30 Aug 2024 17:22:28 -0300
Date: Fri, 30 Aug 2024 17:22:28 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Sean Christopherson <seanjc@google.com>
Cc: James Houghton <jthoughton@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>,
	Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 02/11] KVM: x86: Relax locking for kvm_test_age_gfn
 and kvm_age_gfn
Message-ID: <20240830202228.GB3468552@ziepe.ca>
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-3-jthoughton@google.com>
 <Zr_3Vohvzt0KmFiN@google.com>
 <CADrL8HWQqVm5VbNnR6iMEZF17+nuO_Y25m6uuScCBVSE_YCTdg@mail.gmail.com>
 <ZtFA79zreVt4GBri@google.com>
 <20240830124720.GX3468552@ziepe.ca>
 <ZtH8yv5AabMEpBoj@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZtH8yv5AabMEpBoj@google.com>

On Fri, Aug 30, 2024 at 10:09:30AM -0700, Sean Christopherson wrote:
> On Fri, Aug 30, 2024, Jason Gunthorpe wrote:
> > On Thu, Aug 29, 2024 at 08:47:59PM -0700, Sean Christopherson wrote:
> > > On Thu, Aug 29, 2024, James Houghton wrote:
> > > > On Fri, Aug 16, 2024 at 6:05 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > > > +static __always_inline bool kvm_tdp_mmu_handle_gfn_lockless(
> > > > > > +             struct kvm *kvm,
> > > > > > +             struct kvm_gfn_range *range,
> > > > > > +             tdp_handler_t handler)
> > > > >
> > > > > Please burn all the Google3 from your brain, and code ;-)
> > > > 
> > > > I indented this way to avoid going past the 80 character limit. I've
> > > > adjusted it to be more like the other functions in this file.
> > > > 
> > > > Perhaps I should put `static __always_inline bool` on its own line?
> > > 
> > > Noooo. Do not wrap before the function name.  Linus has a nice explanation/rant
> > > on this[1].
> > 
> > IMHO, run clang-format on your stuff and just be happy with 99% of
> > what it spits out. Saves *so much time* and usually arguing..
> 
> Heh, nope, not bending on this one.  The time I spend far hunting for implementations
> because of wraps before the function name far exceeds the time it takes me to
> push back on these warts in review.

clangd solved that problem for me :)

Jason

