Return-Path: <kvm+bounces-50359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BCB23AE46C2
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 16:31:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D24B445A62
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:19:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 591FF259CB0;
	Mon, 23 Jun 2025 14:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RzZlkPs6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD8F258CE8
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 14:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750688236; cv=none; b=CAq8EYsrsJZR8u/pDLwVnFA7mlBLxNVgKwGwazT09/bcynXssDU+1dp87w7bHpAZzvx6vKrZfk90kQgUo1lKAkrOQ5cyct4ut3QfKg+Q5i9yItVaxy0fY4DIJGbVpIvCPQQucmUOo+9E95PAakfOHBGYXtZOn7ry0JKdAQzZDbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750688236; c=relaxed/simple;
	bh=psOIpthKIFXEvKz+eESe/v9RsbHmVIfYr0L+xhkV4bQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Yhf1jtysz47hsyg2DOdHzH7Dgbf4Y16QeXbFHxj/N18gVoT5SpDh/ukdAn/mBCWjk0fOFLLNHPHV/gUNJdS74TE/ORINk3uXKtkOTC14Daku2wnFtywhSD2ijP4v7OfghX3kVBmIKkEuRggGUhrFMnw7sCSX4xicp1d/zs+nozY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RzZlkPs6; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b31c8104e84so2834713a12.0
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 07:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750688234; x=1751293034; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/46s+GlvCbW/FpTqBJh6kab5Zx7/+f0o4sOquQYXcuc=;
        b=RzZlkPs6bQ8jAtJTBdpOe+ln17ah65f8iaPU4qg8SAIYJRmx88ypst27Rz2Z18rvko
         EtjsNVRbls0pWiZeQxgLhvT4lnSdcoiIjiANABUIJ68J2it8kLzc8ElzNhlv3KoGLQi9
         q9issELj6P02kHFDYhvGopdLsHplTv6OYGwTLLNF6Yg7y30YHXw+1S8on+lKdxwvNUX6
         ftpqR91ezZW8HYWdRINSC3wQjMlfDn8FR8Y9bkhkK/nzJCjsStlpEc4h6FQnrMjD3f6G
         l007fPUTCh5JOdnwXks/riY1QyD5e1LI2PcnHzXLe+GNOJ3rx2v+dSfvsx2rbarrbExE
         iQdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750688234; x=1751293034;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/46s+GlvCbW/FpTqBJh6kab5Zx7/+f0o4sOquQYXcuc=;
        b=QKhyh23FMDdl860OnM3rfSAoIB0H9wdqZhgv1wCSn9wq+1KyDKFpvRUFA7Xv672Ox6
         Yh0Fq32YQCcUG8kLsgMdBumjHfo/f/0S2OztpOuwn4/BiNwznmJlfiLEIsv8nRlTETKD
         2PmWFpIYxd6V5Y8/0Kul6I7qFSqsWCPq5ITuQMeG021RDtZ4vnPhX9QPgNWHXOhxu368
         /aZTTLPfn7Geqv6RV6k5TPgc8Df4XUZJz2U5P6USasjGtQtJAK7zay2mgjYsxPiqdyE1
         3oG4PO/PnmD3wyZPmOknbaYZRNyLrvuKrXf4f0SbztCVwyY13QiO9r1D68HWxNEUfvzm
         sBaQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6zIqkwat5TCnbkG9PexWEDYSVslb7kGlTos99otQl3bsmg1q1ErJ8++jnA5usKiHbodY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0wo3Z7Lv5uZhKim7D9rHR7X0tgFil+eXUGSL+SgHP9P4Ah9+t
	seR/y0g/oV11zNrzK7QA2fn6I3PJ1L4glPoiPDvqgmi/e6BdoVwv75hAXawa5C0e4L3/9NJAda8
	U2xq3mQ==
X-Google-Smtp-Source: AGHT+IEcc+BoulUKgKUfUFw62H/DA9VXOW6pE6AR5ovuZ52SaTQO9EXp+m7sK9bIFuff/q9RYzOYbAXw+gw=
X-Received: from pgbcq2.prod.google.com ([2002:a05:6a02:4082:b0:b2d:aac5:e874])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:ad04:b0:220:33e9:15da
 with SMTP id adf61e73a8af0-22033e9166amr11358403637.2.1750688234034; Mon, 23
 Jun 2025 07:17:14 -0700 (PDT)
Date: Mon, 23 Jun 2025 07:17:12 -0700
In-Reply-To: <0e086840-e0e3-4710-bcf4-14e889dbb096@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250620153912.214600-1-minipli@grsecurity.net>
 <aFi9rUWBarenqfkK@intel.com> <0e086840-e0e3-4710-bcf4-14e889dbb096@grsecurity.net>
Message-ID: <aFlh2ida8zdRhQS8@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/8] x86: CET fixes and enhancements
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Chao Gao <chao.gao@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 23, 2025, Mathias Krause wrote:
> On 23.06.25 04:36, Chao Gao wrote:
> > On Fri, Jun 20, 2025 at 05:39:04PM +0200, Mathias Krause wrote:
> >> Hi,
> >>
> >> I'm playing with the CET virtualization patch set[1] and was looking at
> >> the CET tests and noticed a few obvious issues with it (flushing the
> >> wrong address) as well as some missing parts (testing far rets).
> >>
> >> [1] https://lore.kernel.org/kvm/20240219074733.122080-1-weijiang.yang@intel.com/
> > 
> > Hi Mathias,
> > 
> > Thank you.
> > 
> > I posted a series https://lore.kernel.org/kvm/20250513072250.568180-1-chao.gao@intel.com/
> > to fix issues and add nested test cases. we may consider merging them into one series. e.g.,
> 
> Oh, I completely missed that one! I only looked at the KUT git tree.
> Looks like Paolo / Sean haven't seen it yet either :/

FWIW, I've seen it, just haven't had time to actually look at it.

> But sure, happy to merge the patches! I'll apply your series locally and
> will try to put still relevant changes on top. I'll probably send out an
> updated series later this week.

