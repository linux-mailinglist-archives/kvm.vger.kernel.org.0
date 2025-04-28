Return-Path: <kvm+bounces-44579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B8662A9F3D0
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 16:50:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2537017FDCE
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 14:50:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E5FC26FDBF;
	Mon, 28 Apr 2025 14:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e1A9Ms5J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1155026562C
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 14:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745851826; cv=none; b=oNhBWZJeeVGZgDuHGjz9Hlf4m3wUsyGt9ZGqhxyYmgXNxGT3/jSS/oHBfIFS/uMIDbFh7jlnw2lk+pUju/NMz9y0sKd1mjHKE2yHNSmQRvtsrmPgy1GP8C2Nj9LHjypyybZJalJGBzp2c3CKxC6WDvvNWxS7ZIkSI8GjR2naFvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745851826; c=relaxed/simple;
	bh=/QzN4Vr/NcaXAsSbQScZ6XL3r5+GmaNle2Xta12UJfg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OmSm8qPuaMXdKyV3JTFf8Gyj6H/y3oV6SvT9nQdErCiNgn/Nmb1bsQYCvroRF80tDGLInyLz8aGV9lEXwyJlEmpCPHcDPncQLPB7yg6dlx46BXaQCVOechCW7nJYrOAFLXD86xK45AirEHdiKe/jv/DF+s+f1EiVWgyFGJX92eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e1A9Ms5J; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-af972dd0cd6so2805733a12.1
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 07:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745851823; x=1746456623; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tlkIIua290wjyF4yv5seaaLpfJU0PyT90x6Uavs/1R8=;
        b=e1A9Ms5JZeun7I1pVycPcG4H96CIsfBs4gcBg4Kf8An0UIM5d3srOrJd3WW3IFCrAX
         hXQBzjZgPAkGwSFDxQOPcx00++5hSVZA0cMjA5M29SZZEwu7z1uVSa5aXfIO6G1t1BCI
         6S7vpdD8kod2y2pLb6z+nL4BP8CpSZhEo2Zw4KCeN/rxQzhGZC2MglU8aoJze+48dFKL
         UMauftybdAQ1mzaS+7LvEMNhohe7sMPcCTfXwT21pYrEhKihXcAW6OUpx1pwCGPSm4Uj
         CS9tVStwDk10qqPP49BIup5GiCgnN+Z/sSc/C/es9Q43cI/+RSt0I7n3hj6xbpQfqux4
         CFbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745851823; x=1746456623;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tlkIIua290wjyF4yv5seaaLpfJU0PyT90x6Uavs/1R8=;
        b=cqEEm0HBAJbC1c6lNqu43AvNtT9tQ/66OxK6MwGmDJkBYnLv6JITaeCGrLh2fZLpZ6
         POqI8NL2X6XhqQDCTrCUxwZn0SsafbjMq1wZdRRoSolGKQnmbteCDh1Pl5aenDrlc3hN
         u5e3+CxJUxaIPYnPKLZWb2D+CUNzI71ETSENnRJ6ef2pArzwCI+6r13TCQOa5TyIhxvu
         zP/fyfbOCUKj2dagFtTyZcyqxtCilQJ+lVwnPibCen4xcBK7L2lliI2xQxddnoEX1Aus
         ToTdOc4Wvh7fhj/lHLb4pQsrdtmQeklJzjckaVTivywnUjFumeA2N1y1k7lTD7TjSlxU
         SbqQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4K+jQq05r8LodPc3mJbdRGjf+LsUgGorgAyJb/ig3RQEe3PQZZ7qpR7LgT3dNKSJYKXI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTeOuhtyyu5bSyQ8Tut9Vx3Le+y26JVOyL5VvXbPJDqFSdxDtE
	ffaauRPDoe+OuMnBI0t05NFOiOn5eLelqPD4MU5HfUdypENPsZlOJbwz4MsmL159HMfXJHpWu18
	/8A==
X-Google-Smtp-Source: AGHT+IGQjBWCOydWNE/ttxALHJHboxteEbJ/N0QmJX6WBLFIUaxsEbVZDdieG5LwZ6lGMEcgL1Mtm1LEsuc=
X-Received: from pgbcp12.prod.google.com ([2002:a05:6a02:400c:b0:b0d:b491:d415])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:32a9:b0:1f5:77ed:40b9
 with SMTP id adf61e73a8af0-2045b9f4009mr20352644637.40.1745851823200; Mon, 28
 Apr 2025 07:50:23 -0700 (PDT)
Date: Mon, 28 Apr 2025 07:50:21 -0700
In-Reply-To: <aA7aozbc1grlevOm@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250426001056.1025157-1-seanjc@google.com> <aA7aozbc1grlevOm@yzhao56-desk.sh.intel.com>
Message-ID: <aA-VrWyCkFuMWsaN@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Prevent installing hugepages when mem
 attributes are changing
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 28, 2025, Yan Zhao wrote:
> On Fri, Apr 25, 2025 at 05:10:56PM -0700, Sean Christopherson wrote:
> > @@ -7686,6 +7707,37 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
> >  	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
> >  		return false;
> >  
> > +	if (WARN_ON_ONCE(range->end <= range->start))
> > +		return false;
> > +
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
> > +		gfn_t end = gfn_round_for_level(range->end - 1, level);
> > +		gfn_t nr_pages = KVM_PAGES_PER_HPAGE(level);
> > +
> > +		if ((start != range->start || start + nr_pages > range->end) &&
> > +		    start >= slot->base_gfn &&
> > +		    start + nr_pages <= slot->base_gfn + slot->npages &&
> > +		    !hugepage_test_mixed(slot, start, level))
> Instead of checking mixed flag in disallow_lpage, could we check disallow_lpage
> directly?
> 
> So, if mixed flag is not set but disallow_lpage is 1, there's no need to update
> the invalidate range.
> 
> > +			kvm_mmu_invalidate_range_add(kvm, start, start + nr_pages);
> > +
> > +		if (end == start)
> > +			continue;
> > +
> > +		if ((end + nr_pages) <= (slot->base_gfn + slot->npages) &&
> > +		    !hugepage_test_mixed(slot, end, level))
> if ((end + nr_pages > range->end) &&
>     ((end + nr_pages) <= (slot->base_gfn + slot->npages)) &&
>     !lpage_info_slot(gfn, slot, level)->disallow_lpage)
> 
> ?

No, disallow_lpage is used by write-tracking and shadow paging to prevent creating
huge pages for a write-protected gfn.  mmu_lock is dropped after the pre_set_range
call to kvm_handle_gfn_range(), and so disallow_lpage could go to zero if the last
shadow page for the affected range is zapped.  In practice, KVM isn't going to be
doing write-tracking or shadow paging for CoCo VMs, so there's no missed optimization
on that front.

And if disallow_lpage is non-zero due to a misaligned memslot base/size, then the
start/end checks will skip this level anyways.

