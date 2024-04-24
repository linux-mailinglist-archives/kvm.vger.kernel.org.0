Return-Path: <kvm+bounces-15848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ACF528B10CA
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 19:19:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 696F0286ACF
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 17:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6174D16D9A5;
	Wed, 24 Apr 2024 17:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PsCtRx8a"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBFB16D4CA;
	Wed, 24 Apr 2024 17:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713979147; cv=none; b=M+iyT5AAeA9j3LtBL9/Uq5isQrkJKW9A6ReUbJrJ/qPeGpXaNTGt8lESbr02vsScFVcbDYZ/AYte/4ai+AWW5YM1mphgKVXKd8TNrUJRJyLWQcj4ZeY6edZbbVDCOJvs0DKbaGcL7WvBl5xXJVnoC6Mh0hscQOFeSeovolLpsfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713979147; c=relaxed/simple;
	bh=fzUP5jXS3/ennNTINiF3XeycfhJxeMlYoYeWebVYLrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r5a4fP3jJK9hCxixgif+EoRnH5TXVDP1vN8c2pWbJ4d+ABDVEFUU/u9GUKzMQdVZ9kTHOEw/8Sp51TuHytdIQsUH6+J8vzYBMQhdtsSH1V+fR+8Cb3jDQE+2hPK7pTW7rEynjLX5HakiOm4c3F2X3i7iCVNj9zlbfsGAqFKx/nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PsCtRx8a; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 24 Apr 2024 10:18:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713979143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MPnSCqBZNeTYi6Yq+K5T2lPK1pkupPn4Yzg+HFxV4RA=;
	b=PsCtRx8aCSAoweOsm30ih69vNYVTRPodlMVcmiUBkctOGzu3pRGbw1sE5GGh7nsoNHVM5h
	5QOF1Z7R8cBa1l8TH1edsuJdhO/kJb3MMCiOmD1nDIQZWbQLOr280pl0WKUUtvCtbe/b/D
	kbfVKJFn8471rDFj+eFGUfHVrQqeYr8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Andrew Jones <ajones@ventanamicro.com>,
	Markus Elfring <Markus.Elfring@web.de>,
	Kunwu Chan <chentao@kylinos.cn>, linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Kunwu Chan <kunwu.chan@hotmail.com>,
	Anup Patel <anup@brainfault.org>, Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH] KVM: selftests: Add 'malloc' failure check in
 test_vmx_nested_state
Message-ID: <Zik_Aat5JJtWk0AM@linux.dev>
References: <20240423073952.2001989-1-chentao@kylinos.cn>
 <878bf83c-cd5b-48d0-8b4e-77223f1806dc@web.de>
 <ZifMAWn32tZBQHs0@google.com>
 <20240423-0db9024011213dcffe815c5c@orel>
 <ZigI48_cI7Twb9gD@google.com>
 <20240424-e31c64bda7872b0be52e4c16@orel>
 <ZikcgIhyRbz5APPZ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZikcgIhyRbz5APPZ@google.com>
X-Migadu-Flow: FLOW_OUT

Hey,

On Wed, Apr 24, 2024 at 07:51:44AM -0700, Sean Christopherson wrote:
> On Wed, Apr 24, 2024, Andrew Jones wrote:
> > On Tue, Apr 23, 2024 at 12:15:47PM -0700, Sean Christopherson wrote:
> > ...
> > > I almost wonder if we should just pick a prefix that's less obviously connected
> > > to KVM and/or selftests, but unique and short.
> > >
> > 
> > How about kvmsft_ ? It's based on the ksft_ prefix of kselftest.h. Maybe
> > it's too close to ksft though and would be confusing when using both in
> > the same test?
> 
> I would prefer something short, and for whatever reason I have a mental block
> with ksft.  I always read it as "k soft", which is completely nonsensical :-)

I despise brevity in tests, so my strong preference is to use some form
of 'namespaced' helper. Perhaps others have better memory than
I do, but I'm quick to forget the selftests library and find the more
verbose / obvious function names helpful for jogging my memory.

> > I'm not a huge fan of capital letters, but we could also do something like
> > MALLOC()/CALLOC().
> 
> Hmm, I'm not usually a fan either, but that could actually work quite well in this
> case.  It would be quite intuitive, easy to visually parse whereas tmalloc() vs
> malloc() kinda looks like a typo, and would more clearly communicate that they're
> macros.

Ooo, don't leave me out on the bikeshedding! How about TEST_MALLOC() /
TEST_CALLOC(). It is vaguely similar to TEST_ASSERT(), which I'd hope
would give the impression that an assertion is lurking below.

-- 
Thanks,
Oliver

