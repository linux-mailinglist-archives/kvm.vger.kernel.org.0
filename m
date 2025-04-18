Return-Path: <kvm+bounces-43666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E6DBCA9393A
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 17:13:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F8C11B630A5
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 15:13:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40B0C210180;
	Fri, 18 Apr 2025 15:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="osrLzAj7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A52205AAB
	for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 15:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744989203; cv=none; b=JqUWH4ghlZ3JdH2idRuabg88+EsMJMHE49lGrY/RKTunOWNVwED4WhAgHEwkQ9VV78/o2S/lmIT1NCa1/EZagG7R3RE30JxRrTWaeFNPcmiCKVCX+tR1Z2xRGVHI94z4lio/bI6L0QRqhQBvMOtpJNomu78K64Pw10ZiJDiODvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744989203; c=relaxed/simple;
	bh=2GJosY4++6FLu2OJtBI5wrnLMJOu/3uGwzB0weChq0s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Sn1uZmkZhHX2phBREmm+x6uQg1Ibj0V75MLxLZCR1mTZjQ7bw7qIate+9dOdc7vPz5nV9MsaU3u7j4vEGfbBrctFfRvVR/fikbxeL+3rhiNS/+FM2DZIa0UjlyHKKWpPfmdpjiV8/D0KW5jd0vSS4gMC2jcco3gSORrsYziIlxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=osrLzAj7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3011bee1751so1757026a91.1
        for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 08:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744989199; x=1745593999; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z6Q9vUMWWn2x7ZhmSrldIht7Msa4XrsX7WVAx7KYTNE=;
        b=osrLzAj7fVh0acCiMf3ao9VUwTbrFF/vPnUyG06DLHyDFBA0ViC+tpHneiz+WOfOOT
         Cw33+59hvSGX7dEKg6xAqN1l9zkT2/vyW7oztNtL+nnHSCTrSUktcHB/IALjs/3WMv9O
         cPyFk1OKgQssCfwZTYBcpA8tNZDNAExUyrX/p24bk86d8RBsud2pEUHsYM+UGzd0W2yo
         g+1ZfFWLZkbZ/rMwBZHjocgSFHjv+EnlnrHxQMklpqKqLCrrg0L9crYUm4E8oVOxgIcf
         XbpXB8djC/O0yYMR+HZiAHeN0WE7imzJUpsUms8XQ58RdjLHm/5cCw3gNIYesDhAvCki
         +wag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744989199; x=1745593999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z6Q9vUMWWn2x7ZhmSrldIht7Msa4XrsX7WVAx7KYTNE=;
        b=ZdJxIZiqb/7hKsfcIBEL0qkRFzOeK9rnh78dPnQf4HC3UW5MgTrLqj9VOFjcJjSGEJ
         yvZJcqQ5wICT6SNI4rs2oFV8nRZUUG5OWv7yQ8fwwDt5q52yW5q1uxIAwbVwNf3hcGir
         ycGvewKGzbsuHsiB8bU06lYF/LXVj2PWcXapib24PwsR2WA7xfhvv9/HEyM2nNV5pNjO
         QHOUz6ZVDlsgXbYA0pKiMX/Sk2ZD812kNQ/BTcpUpprNHO1gjACE6zc5M1beu4CPHDNY
         EbLYgh2UDJqxCYiDFKp99DGm1ScryFUM5y7IxaOLm91YGJE8bCSXX6F951ynnL5exNWv
         I8tw==
X-Gm-Message-State: AOJu0YyXVghQ7T70fBJIGP8EO/3oGgTRcumOkNd+dKCnQWqx7lCpo2py
	1YsymDXLfgVil4msivbhl6ACckDZ590OOMbEsqh8nZC+jSeBI+U4fEMqVusLfchWM8RU1xFqs1k
	tWQ==
X-Google-Smtp-Source: AGHT+IFx4xCyquKRTfdq9Eq5qlCDjjfv+7cohJJwUWjdOUc5pLcG5bTTrpKtJ9MYC4u3/yNkWK0N+tmsBMs=
X-Received: from pjv12.prod.google.com ([2002:a17:90b:564c:b0:2f4:465d:5c61])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5184:b0:301:1d03:93cd
 with SMTP id 98e67ed59e1d1-3087bbbcd83mr5332278a91.24.1744989199239; Fri, 18
 Apr 2025 08:13:19 -0700 (PDT)
Date: Fri, 18 Apr 2025 08:13:17 -0700
In-Reply-To: <20250418001237.2b23j5ftoh25vhft@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <Z__AAB_EFxGFEjDR@google.com> <20250418001237.2b23j5ftoh25vhft@amd.com>
Message-ID: <aAJsDVg5RNfSpiYX@google.com>
Subject: Re: Untested fix for attributes vs. hugepage race
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 17, 2025, Michael Roth wrote:
> > +	/*
> > +	 * If the head and tail pages of the range currently allow a hugepage,
> > +	 * i.e. reside fully in the slot and don't have mixed attributes, then
> > +	 * add each corresponding hugepage range to the ongoing invalidation,
> > +	 * e.g. to prevent KVM from creating a hugepage in response to a fault
> > +	 * for a gfn whose attributes aren't changing.  Note, only the range
> > +	 * of gfns whose attributes are being modified needs to be explicitly
> > +	 * unmapped, as that will unmap any existing hugepages.
> > +	 */
> > +	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
> > +		gfn_t start = gfn_round_for_level(range->start, level);
> > +		gfn_t nr_pages = KVM_PAGES_PER_HPAGE(level);
> > +		gfn_t end = gfn_round_for_level(range->end, level);
> > +
> > +		if ((start != range->start || start + nr_pages > range->end) &&
> > +		    start >= slot->base_gfn &&
> > +		    start + nr_pages <= slot->base_gfn + slot->npages &&
> > +		    !hugepage_test_mixed(slot, start, level))
> > +			kvm_mmu_invalidate_range_add(kvm, start, start + nr_pages);
> 
> For the 'start + nr_pages > range->end' case, that seems to correspond
> to when the 'start' hugepage covers the end of the range that's being
> invalidated.

It covers the case where range->start is hugepage aligned, but the size of the
range is less than a hugepage.

> But in that case, 'start' and 'end' hugepages are one and the same,

Yes.

> so the below would also trigger,

Gah, that's a goof in the computation of "end".

> and we end up updating the range twice with the same start/end GFN of the
> same hugepage.
>
> Not a big deal, but maybe we should adjust the above logic to only cover
> the case where range->start needs to be extended. Then, if 'start' and
> 'end' hugepages are the same, we are done with that level:

FWIW, this is what I was trying to do.

> 
>     if (start < range->start &&
>         start >= slot->base_gfn &&
>         start + nr_pages <= slot->base_gfn + slot->npages &&
>         !hugepage_test_mixed(slot, start, level))
>             kvm_mmu_invalidate_range_add(kvm, start, start + nr_pages);
> 
>     if (start == end)
>         continue;
> 
> Then what remains to be determined below is whether or not range->end needs
> to be additionally extended by 'end' separate hugepage.
> 
> > +
> > +		if (end < range->end &&
> 
> This seems a little weird since end is almost by definition going to be

Not almost, it is by definition.  But as above, I botched the computation of end.

> less-than or equal-to range->end, so it's basically skipping the equal-to
> case. To avoid needing to filter than case, maybe we should change this:
> 
>   gfn_t end = gfn_round_for_level(range->end, level);
> 
> to
> 
>   gfn_t end = gfn_round_for_level(range->end - 1, level);
> 
> since range->end is non-inclusive and we only care about hugepages that
> begin before the end of the range. If we do that, then 'end < range->end'
> check will always be true and the below:
> 
> > +		if (end < range->end &&
> > +		    (end + nr_pages) <= (slot->base_gfn + slot->npages) &&
> > +		    !hugepage_test_mixed(slot, end, level))
> > +			kvm_mmu_invalidate_range_add(kvm, end, end + nr_pages);
> 
> can be simplified to:
> 
>     if (end + nr_pages <= slot->base_gfn + slot->npages &&
>         !hugepage_test_mixed(slot, end, level))
>             kvm_mmu_invalidate_range_add(kvm, end, end + nr_pages);

That all looks good to me.  And to ensure we don't go off the rails due to bad
inputs (which are supposed to be fully validated by common KVM), we could add a
WARN to detect a non-exclusive range->end.

So this?

	if (WARN_ON_ONCE(range->end <= range->start))
		return false;

	/*
	 * If the head and tail pages of the range currently allow a hugepage,
	 * i.e. reside fully in the slot and don't have mixed attributes, then
	 * add each corresponding hugepage range to the ongoing invalidation,
	 * e.g. to prevent KVM from creating a hugepage in response to a fault
	 * for a gfn whose attributes aren't changing.  Note, only the range
	 * of gfns whose attributes are being modified needs to be explicitly
	 * unmapped, as that will unmap any existing hugepages.
	 */
	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
		gfn_t start = gfn_round_for_level(range->start, level);
		gfn_t end = gfn_round_for_level(range->end - 1, level);
		gfn_t nr_pages = KVM_PAGES_PER_HPAGE(level);

		if ((start != range->start || start + nr_pages > range->end) &&
		    start >= slot->base_gfn &&
		    start + nr_pages <= slot->base_gfn + slot->npages &&
		    !hugepage_test_mixed(slot, start, level))
			kvm_mmu_invalidate_range_add(kvm, start, start + nr_pages);

		if (end == start)
			continue;

		if ((end + nr_pages) <= (slot->base_gfn + slot->npages) &&
		    !hugepage_test_mixed(slot, end, level))
			kvm_mmu_invalidate_range_add(kvm, end, end + nr_pages);
	}

