Return-Path: <kvm+bounces-23575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ADDE94AFA6
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 20:26:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD7C4B26711
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 18:26:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97A4A13E028;
	Wed,  7 Aug 2024 18:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="U25YeUgr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF1A63CB
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 18:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723055176; cv=none; b=r85J4RreLM3m1GFxf8XEzbNj9A7cRTaRIRDbskb86NxUTMoGihyp2J0m7WOVXIRc5NTuNCFCJA5nLjPT9katmQHjjo91HQuuxLWldPP3t6Zp7auC5zkGqx7jdSo3xpMQ6pmNaqCZIAGZn67LXzv0YocVX+04isl+OVbGQqwSygs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723055176; c=relaxed/simple;
	bh=LLEn5MDBQHmrgyVACBfMnS4xxjGfc9LgvIlsA65/wbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RQnM2bBNcMULxhQno1iA9yx11+rgJZcr7RVDnBFyI7X/4gTeuhcAp//9x0m837IqZZjAGzunWYGoedGCr64AGgcpZJV7OC8mhn6mwMdeLmMA0c+SRkNxn3OyF3+tRt3AB56GxnecdKtFRaVzSJa8WAkalCPsQ66FYM7H7vNXvKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=U25YeUgr; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-260f033fda3so133588fac.3
        for <kvm@vger.kernel.org>; Wed, 07 Aug 2024 11:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1723055174; x=1723659974; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qIRgOrphujOZNK9+4f2LlAnWUepvShfv1Q6TgIqEiJY=;
        b=U25YeUgrVPQWiF6HNsyfeZr/rCPFqUJ7IKPJII7YfwojnUDQWwJGvEtmoAV8EED88P
         q7N0sf7Eukm+5ZnhcifkiVtCU8R3MkL1huBoD/Bv5dVwBnNIaEausahv1d83yrv13EyM
         ALiLyllcGQpc53rY5KFwGVv+/nBUC1XuRTJYUz3yjYtedvVmpgtcmU6Lokj5Fb/DpgtS
         HYDPwsjITnGYFmnIwlbJvGWRBnUyRDO++CxN7pgt2/y/LeBfTjph9Nc+t6o7P5dinyJz
         foo9dfdQvFqum8wQn+QtKGcRgQ45+JBFBuiXhcTH6lAsbldgcY9+w8X2wGvnnFKCzlBH
         w+qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723055174; x=1723659974;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qIRgOrphujOZNK9+4f2LlAnWUepvShfv1Q6TgIqEiJY=;
        b=Y19Fg0JjhdiNaSQXXD0ZqF0m7awv/s0WVbU5w74kFMNx/vXOVJWbeO67nm2C+p9s+J
         pSTLzoUnGyI741/OLtrBYB8++obRA2GnwiKc6sXvMRcPh5jLlXWViIgy9UiRwvcXSg21
         5JiFxGG9ld39BKzcjZ63DnUIUTAMN28kADqUIPDaPc/ArMZ+BvDQMtIvBnJeU5FAhQEf
         LceOD+VcIZhQjgsOBEWUQCarV5VhsfAB7MRTRm5ksx1a/P15GYYxJuu12aZgaDFvDAq6
         KEPVsx4tRHS8Jpk8PntFACPWU9N+JKkaF68FX2cJu/Bc74VGX4+gWxFLD90Gwz6JTE/2
         h+ng==
X-Forwarded-Encrypted: i=1; AJvYcCVy8a5HuVLWLE8LUd6dI/CNzCpFPGaUL9OvX9BnTcJFzqqXMHnYCsJtj37UHx4/b1W3AAyKvWyLzVFYATBsAuTa/tsS
X-Gm-Message-State: AOJu0Yyql6aE1Wxlxa03Ct/ifclBA8EUVHDqAu5jNxjkMmWf7PUAFiP+
	/W4Dsz6mQSLo/d02KUVgj/JCzUYrWzXwsHkKNyV1+FkXcxBi7PpVBYH0KQUNjxY=
X-Google-Smtp-Source: AGHT+IF4dmL7QQFh54XoTTYzluGtiIHPWtm1r4ZnSMjpESeur6JHnnxQaalp3hZhfOljJo1uPFxdYA==
X-Received: by 2002:a05:6870:4693:b0:260:e6a6:396c with SMTP id 586e51a60fabf-26891d5aebfmr23740831fac.30.1723055173896;
        Wed, 07 Aug 2024 11:26:13 -0700 (PDT)
Received: from ziepe.ca ([128.77.69.90])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a3786bbcffsm82167785a.99.2024.08.07.11.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 11:26:13 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sblMR-003SUs-9y;
	Wed, 07 Aug 2024 15:26:11 -0300
Date: Wed, 7 Aug 2024 15:26:11 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@redhat.com>,
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
	Sean Christopherson <seanjc@google.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>,
	Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 05/11] mm: Add fast_only bool to test_young and
 clear_young MMU notifiers
Message-ID: <20240807182611.GH8473@ziepe.ca>
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-6-jthoughton@google.com>
 <37ae59f2-777a-4a58-ae58-4a20066364dd@redhat.com>
 <CADrL8HUmQWDc-75p=Z2KZzHkyWCCh8xnX=+ZXm5MZ-drALjKTA@mail.gmail.com>
 <20240806172349.GQ676757@ziepe.ca>
 <CADrL8HXFK=1cUS+0Z5k048U4rzpTNL634f57VtJ7TD_umrbNiA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADrL8HXFK=1cUS+0Z5k048U4rzpTNL634f57VtJ7TD_umrbNiA@mail.gmail.com>

On Wed, Aug 07, 2024 at 08:02:26AM -0700, James Houghton wrote:
> On Tue, Aug 6, 2024 at 10:23 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Thu, Aug 01, 2024 at 04:13:40PM -0700, James Houghton wrote:
> > > --- a/include/linux/mmu_notifier.h
> > > +++ b/include/linux/mmu_notifier.h
> > > @@ -106,6 +106,18 @@ struct mmu_notifier_ops {
> > >          * clear_young is a lightweight version of clear_flush_young. Like the
> > >          * latter, it is supposed to test-and-clear the young/accessed bitflag
> > >          * in the secondary pte, but it may omit flushing the secondary tlb.
> > > +        *
> > > +        * The fast_only parameter indicates that this call should not block,
> > > +        * and this function should not cause other MMU notifier calls to
> > > +        * block. Usually this means that the implementation should be
> > > +        * lockless.
> > > +        *
> > > +        * When called with fast_only, this notifier will be a no-op unless
> > > +        * has_fast_aging is set on the struct mmu_notifier.
> >
> > If you add a has_fast_aging I wonder if it is better to introduce new
> > ops instead? The semantics are a bit easier to explain that way
> 
> v5 implemented these with a new op[1]. *Just* having the new op is
> kind of problematic -- we have yet another op to do something very
> similar to what already exists. We are left with two options:
> consolidate everything into a single notifier[2] or add a new
> parameter to test/clear_young()[3]. The latter, implemented in this
> v6, is somewhat simpler to implement (fewer LoC, reduces some
> duplication in KVM), though it does indeed make the explanation for
> test/clear_young() slightly more complex. I don't feel very strongly,
> but unless you do, I think I just ought to stick with how the v6 does
> it. :)

If it does makes the code simpler then it is probably the better choice

Jason

