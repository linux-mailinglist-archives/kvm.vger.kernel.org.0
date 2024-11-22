Return-Path: <kvm+bounces-32388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57B849D6674
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2024 00:55:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0D6028220B
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 23:55:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C4B81C8FCE;
	Fri, 22 Nov 2024 23:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nE9586F9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B9818A951
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 23:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732319718; cv=none; b=UalfCOrjtv5K5+dSd6JIDlQdnZc7MFOVuz++stwrExhmUMvtEz9M+fmT0BYUKTMd7XaxWPhH6x94Set+byCCI2zplE1MpBIzPm+cGQfPAoPHNmTnvXZcODP+cwtTxFLoNZ+hb9eSFNDauCW06/mT03ckF7laZackgpEPWlqTTjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732319718; c=relaxed/simple;
	bh=pw3x9hAD0WOo8HOdzrqXesKQo4X2cv674KdS2DipRYY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OhwBV8Pk+XRq1II5ft4jk65VhPoi7mXqpfDhAndcZrj1DS11rpO8q2BcbI952LEkaz/4l2vV87taD+88uylFFT3m44bIrXCxHm2jpsDPsDkA4aEDXGANMAaOlm5MeMQ+KybQ5J4iJ/Tcwp1Vf4oxlxoKOHpOw1NOYlFkrkH3H+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nE9586F9; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7ee07d0f395so2661605a12.3
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 15:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732319716; x=1732924516; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0XJL5sSAhrBfkMi6De35B2rgA/UViYzgkz5Ikuv0m9M=;
        b=nE9586F9U0scqT13I+rkRbtuweIyjhoitfqBagO3Ly4Y8OsfwPFuiwVc94KAjjsVor
         t0nDFYqucJYnIxjUlaixn4/NaI7IebeflVUJCpvG3iUMgygcziehcSOECcbw+aN4NylQ
         4lyG1F1QRubj0pBvJagR4/r2kHJhqLMoixpXbdA/NpFxD7Z9EpvwnkMnTSZoFUsZAaZc
         3jVXHSP74MWbGSD1NQhyA0Vqd4HJU3Zt8dMuUSMGpWM20Fmsegx15o7egMY6BZskE5tZ
         QuT2GW54EX3mWuJi4bb+pqraXPaFag1dLL5rDDPC5Aiw/ueTiXXjM+WuxifgxiGa2KWu
         zMpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732319716; x=1732924516;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0XJL5sSAhrBfkMi6De35B2rgA/UViYzgkz5Ikuv0m9M=;
        b=CXAgUOT0kEqkWOoWI/E4tAGFPjdWOMPl1OE5TFpDstWfOoWQS2tcJ/MgBivybHzepg
         Dp6aOeuySITnRA2AdeFoKodcyGuFmCyYA09u6pHrt2bWT11DVnroTiNqXeqDWXuQpS71
         Ey9G++UMLPf0qe3437/KIiZ0+RCFQ0SFCAwH4xdk8FhL6wQar6hGsx33gA6MqZwlJYS1
         X4opT2eVAJgK5JSRgPll3Ct9e0QQiA1wtNMR2MnIEDdOOk4Opla2zvIceWciwlNn7V+m
         VgOOSNZO+s7svWXkI95LKrWO4Ayt6A172vAVmQQ06Vc5NcfU7R4P9oQCsSBsdi8mco/+
         nH+A==
X-Forwarded-Encrypted: i=1; AJvYcCU6g1s9rU96Wl44Sx0UFSIvuC+0mXldzgZEsJcchluLjvfvAFzs3YZcejyDs8kl56qjqOo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzR07SiADRh+V2aHXZMLYCnu9UtbuK3hVXXcvhQuQBn2YaZVIID
	yqljtlH4wYAE1nlSLNCMB+XiJLYiGfRL6Co5ayU7+Xm440qUp0KF0N5y/d/DcZqUNMzrwei0Bsk
	UMA==
X-Google-Smtp-Source: AGHT+IELmYFHxYVfYrq5YGLn/0N+oWNvd8W1zdiwji+uYYwHfaPfGMVNHe2y7x4hk8WK544QZR9KmfZ8+YE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a65:568b:0:b0:7ea:68ab:6465 with SMTP id
 41be03b00d2f7-7fbcccf5e73mr2487a12.9.1732319715941; Fri, 22 Nov 2024 15:55:15
 -0800 (PST)
Date: Fri, 22 Nov 2024 15:55:14 -0800
In-Reply-To: <30d0cef5-82d5-4325-b149-0e99833b8785@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241115202028.1585487-1-rick.p.edgecombe@intel.com>
 <20241115202028.1585487-2-rick.p.edgecombe@intel.com> <30d0cef5-82d5-4325-b149-0e99833b8785@intel.com>
Message-ID: <Z0EZ4gt2J8hVJz4x@google.com>
Subject: Re: [RFC PATCH 1/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX KeyID management
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org, pbonzini@redhat.com, 
	isaku.yamahata@gmail.com, kai.huang@intel.com, linux-kernel@vger.kernel.org, 
	tony.lindgren@linux.intel.com, xiaoyao.li@intel.com, yan.y.zhao@intel.com, 
	x86@kernel.org, adrian.hunter@intel.com, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 22, 2024, Dave Hansen wrote:
> On 11/15/24 12:20, Rick Edgecombe wrote:
> > +struct tdx_td {
> > +	hpa_t tdr;
> > +	hpa_t *tdcs;
> > +};
> 
> This is a step in the right direction because it gives the wrappers some
> more type safety.
> 
> But an hpa_t is _barely_ better than a u64.  If the 'tdr' is a page,
> then it needs to be _stored_ as a page:
> 
> 	struct page *tdr_page;
> 
> Also, please don't forget to spell these things out:
> 
> 	/* TD root structure: */
> 	struct page *tdr_page;
> 
> And the tdcs is an array of pages, right?  So it should be:
> 
> 	struct page **tdcs_pages;
> 
> Or heck, I _think_ it can theoretically be defined as a variable-length
> array:
> 
> 	struct page *tdcs_pages[];
> 
> and use the helpers that we have for that.
> 
> Putting it all together, you would have this:
> 
> struct tdx_td {
> 	/* TD root structure: */
> 	struct page *tdr_page;
> 
> 	int tdcs_nr_pages;
> 	/* TD control structure: */
> 	struct page *tdcs_pages[];
> };
> 
> That's *MUCH* harder to misuse.  It's 100% obvious that you have a
> single page, plus a variable-length array of pages.  This is all from
> just looking at the structure definition.

I don't know the full context, but working with "struct page" is a pain when every
user just wants the physical address.  KVM SVM had a few cases where pointers were
tracked as "struct page", and it was generally unpleasant to read and work with.

I also don't like conflating the kernel's "struct page" with the architecture's
definition of a 4KiB page.

> You know that 'tdr' is not just some random physical address.  It's a
> whole physical page.  It's page-aligned.  It was allocated, from the
> allocator.  It doesn't point to special memory.

Oh, but it does point to special memory.  If it *didn't* point at special memory
that is completely opaque and untouchable, then KVM could use a struct overlay,
which would give contextual information and some amount of type safety.  E.g.
an equivalent without TDX is "struct vmcs *".

Rather than "struct page", what if we add an address_space (in the Sparse sense),
and a typedef for a TDX pages?  Maybe __firmware?  E.g.

  # define __firmware	__attribute__((noderef, address_space(__firmware)))

  typedef u64 __firmware *tdx_page_t;

That doesn't give as much compile-time safety, but in some ways it provides more
type safety since KVM (or whatever else cares) would need to make an explicit and
ugly cast to misuse the pointer.

> Ditto for "hpa_t *tdcs".  It's not obvious from the data structure that
> it's an array or if it's an array how it got allocated or how large it is.

