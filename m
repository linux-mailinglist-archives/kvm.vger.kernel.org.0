Return-Path: <kvm+bounces-64875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B26AC8EB78
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 15:11:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7503E3AD3D9
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 14:11:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1F02332914;
	Thu, 27 Nov 2025 14:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K9NUfQJz";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xthc4qiL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1D2221D9E
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 14:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764252666; cv=none; b=dy0finLTXWOMQfR07WrzFOEJVIULS/IUHeV402jAQB1nAGm1HZ1Bn+UQd7VpM4f4C4vIw4xr1Vh2madZyvulayBemc5GVLrxsl1J8SRDGOWfnshWNV8GuNet8IvVOpAFBSSJTW4oFwjOl8BYUrdl2V+HD5cPo9lUHYwBYw/UHqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764252666; c=relaxed/simple;
	bh=2RVh9tE5pYxS6ovcyK+Et0Fi45QfZBrWmtYdpxtheco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KUNZtZ88lUyKGFRuXrTz6kLR5K+XmEUO2NgXVgcTQ/insVAVyH5U9IC06YmSHLmwIzqLto/DX37hgbCzF1zKIZoAsnOtnF0m0SegVX9HecD0nNsqkOUKgXQQV2UbIrDi9RyXVA/5ChJEKjcCo4z8deZUZA1eE1WY272Iqa2Q4MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K9NUfQJz; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xthc4qiL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764252662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XR64ry2ScNCGM4bs1WMW5J43Vq5AKcKTg9WAzYYBca8=;
	b=K9NUfQJzBGLkhVJ5AvexvTFrzetrp8x8cchsqX/8/M/zgeqjDNTuppIzUu/EB3WyHHj2ZM
	jUKLwPRLCCdxPcSbinK5HwurrwWfAFBIiHsVJgWhy++YZDl4h508dasEMe6AKcHYBoMlz8
	fAy4jCg54cuYn7+dFWxPVKgJFZv2o+c=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-hU3wJDstOkyX6h3DuuJngw-1; Thu, 27 Nov 2025 09:11:01 -0500
X-MC-Unique: hU3wJDstOkyX6h3DuuJngw-1
X-Mimecast-MFC-AGG-ID: hU3wJDstOkyX6h3DuuJngw_1764252660
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-88050bdc2abso22448906d6.2
        for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 06:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764252660; x=1764857460; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XR64ry2ScNCGM4bs1WMW5J43Vq5AKcKTg9WAzYYBca8=;
        b=Xthc4qiLmJ/TJudULPOMWQESsp4ttDUTwrl8c3gDYtkf4hEvwQL7UkOEh4WI3moKrv
         /q8g/6K3BVgKNq6hFk7ZYxg5v6CIdZ/eYkJrfAdnXI21WxCL4ZWYxyWb1z464VEqWh2h
         t3xeG7ETesPe1/4235D7nTy8gvmwwbcw6nzFpsOyOMa9DURPCbiu5yX44dtacb5qkD0i
         KiZh7ROSvzo7OS4Z0z20T60TFe/juk77WHE+HYKWKC35IEDzxDPLDmFIcQNVgDkB0C1F
         mYYZQaNsk+KZvUhYxcoNlveRz+driGOk4YaBUfKzFQCsTVt+RhUfFPYSrJlW0CDSJT5W
         a+bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764252660; x=1764857460;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XR64ry2ScNCGM4bs1WMW5J43Vq5AKcKTg9WAzYYBca8=;
        b=Z9Vpdk9QE5+gujQGJGu7DOtoUsfNQV7ch6mVVfV/a6J19fiVbDGdvB+UfOYBE5Encj
         MEL7TO6+sf28XA+ODJJDNVt2J3iH7HR38zP6f/2fT9Dm/HnD1dK2qq/fYUxw6lM2bvuM
         4OTIy2J8FpKiy3HhYRtiTeALqwMMgrrT8hs2Q9rVIkgCXJWdFNUewn43SjUgcz3Yr05Q
         7luWXNTt2qSpB0r2bRL8v/foKMltc2vgAgDyojow0fzDH++gQCSBC14aO4Q/vvYhwKJV
         GWTg4M0VfDe7a8talIEl6NRXFVlY8p6J4ZrEyx5wAPEkMe+wUe1H6Ivtc8VhO2/uWYQ5
         mUsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXonxbdcOFeefZc5yQn2VviQji9bEp7V/Z8E8J1rfi+EUgmYPlN3F6fH2EdAzZAro3onJQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCdo04g03esH97UAO4AuJvKu79EqgpvdLhidpR47zbCJTfpaiT
	hjHiaMGycKkKg5BJeoEO+igAPyueCgcPEKbQSPLTY6Sc0o7/HI/SCxxZ4sMakx/DVgsFDRAQRIQ
	lH7gZHyLI7iDUm1JmKnFw+jZGk/dS8+IIH1EAvPWdXhSCmKiw58xQhw==
X-Gm-Gg: ASbGncsmLkVVmD39RQG7zjH5WH/p/JbnBB3HyQBjJ6RyR0a1TFep+cluXCpTeuc86Nt
	ya6ao1wGHqy4zx72iBS0rfhmozxCaUB7QkFskpR+Dztvd8eecGsrf/T+kKvyAk6ebsWqycbc7sy
	S/6IPNr7Ljbrsg6iU4BP2zYVGLFmv1aEJ9/BlcSiJmFTn8KGY7sFmtkfLt3kkOOyXwsJa1CIq2c
	VjUGceo1JJbhr0nwV5gottYDOXDuV86OGmTqu+zKbtUeWXr38Kpg9mD9zxvs97NWAhkbX5Kp/ns
	fgqaIaDXv31hwqkrhCCbkhfx/F2E33BzZ9iu6K88i8ESy3RMzId4p2ZLRY9KQPHR4wgkISWcn/1
	qVGM=
X-Received: by 2002:a05:6214:5b0a:b0:87b:f43b:89bf with SMTP id 6a1803df08f44-8863aff433bmr130936896d6.65.1764252660236;
        Thu, 27 Nov 2025 06:11:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHVVojIJxBSUg6Ma99iaPFcSP2N+G6I7KWSD+e0Pql+38krJCo4yqt0i+13ziPHCggkJGRQFQ==
X-Received: by 2002:a05:6214:5b0a:b0:87b:f43b:89bf with SMTP id 6a1803df08f44-8863aff433bmr130936256d6.65.1764252659699;
        Thu, 27 Nov 2025 06:10:59 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88652b8fcb2sm9879206d6.52.2025.11.27.06.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 06:10:59 -0800 (PST)
Date: Thu, 27 Nov 2025 09:10:56 -0500
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: Re: [PATCH v2 3/5] mm: introduce VM_FAULT_UFFD_MINOR fault reason
Message-ID: <aShb8J18BaRrsA-u@x1.local>
References: <20251125183840.2368510-1-rppt@kernel.org>
 <20251125183840.2368510-4-rppt@kernel.org>
 <aSYBrH_xfMfs6yDW@x1.local>
 <aSgzcpFP1qBda5ef@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aSgzcpFP1qBda5ef@kernel.org>

On Thu, Nov 27, 2025 at 01:18:10PM +0200, Mike Rapoport wrote:
> On Tue, Nov 25, 2025 at 02:21:16PM -0500, Peter Xu wrote:
> > Hi, Mike,
> > 
> > On Tue, Nov 25, 2025 at 08:38:38PM +0200, Mike Rapoport wrote:
> > > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > > 
> > > When a VMA is registered with userfaulfd in minor mode, its ->fault()
> > > method should check if a folio exists in the page cache and if yes
> > > ->fault() should call handle_userfault(VM_UFFD_MISSING).
> > 
> > s/MISSING/MINOR/
> 
> Thanks, fixed. 
> 
> > > new VM_FAULT_UFFD_MINOR there instead.
> > 
> > Personally I'd keep the fault path as simple as possible, because that's
> > the more frequently used path (rather than when userfaultfd is armed). I
> > also see it slightly a pity that even with flags introduced, it only solves
> > the MINOR problem, not MISSING.
> 
> With David's suggestion the likely path remains unchanged.

It is not about the likely, it's about introducing flags into core path
that makes the core path harder to follow, when it's not strictly required.

Meanwhile, personally I'm also not sure if we should have "unlikely" here..
My gut feeling is in reality we will only have two major use cases:

  (a) when userfaultfd minor isn't in the picture

  (b) when userfaultfd minor registered and actively being used (e.g. in a
      postcopy process)

Then without likely, IIUC the hardware should optimize path selected hence
both a+b performs almost equally well.

My guessing is after adding unlikely, (a) works well, but (b) works badly.
We may need to measure it, IIUC it's part of the reason why we sometimes do
not encourage "likely/unlikely".  But that's only my guess, some numbers
would be more helpful.

One thing we can try is if we add "unlikely" then compare a sequential
MINOR fault trapping on shmem and measure the time it takes, we need to
better make sure we don't regress perf there.  I wonder if James / Axel
would care about it - QEMU doesn't yet support minor, but will soon, and we
will also prefer better perf since the start.

> 
> As for MISSING, let's take it baby steps. We have enough space in
> vm_fault_reason for UFFD_MISSING if we'd want to pull handle_userfault()
> from shmem and hugetlb.

Yep.

>  
> > If it's me, I'd simply export handle_userfault()..  I confess I still don't
> > know why exporting it is a problem, but maybe I missed something.
> 
> It's not only about export, it's also about not requiring ->fault()
> methods for pte-mapped memory call handle_userfault().

I also don't see it a problem.. as what shmem used to do.  Maybe it's a
personal preference?  If so, I don't have a strong opinion.

Just to mention, if we want, I think we have at least one more option to do
the same thing, but without even introducing a new flag to ->fault()
retval.

That is, when we have get_folio() around, we can essentially do two faults
in sequence, one lighter then the real one, only for minor vmas, something
like (I didn't think deeper, so only a rough idea shown):

__do_fault():
  if (uffd_minor(vma)) {
    ...
    folio = vma->get_folio(...);
    if (folio)
       return handle_userfault(vmf, VM_UFFD_MINOR);
    // fallthrough, which imply a cache miss
  }
  ret = vma->vm_ops->fault(vmf);
  ...

The risk of above is also perf-wise, but it's another angle where it might
slow down page cache miss case where MINOR is registered only (hence, when
cache missing we'll need to call both get_folio() and fault() now).
However that's likely a less critical case than the unlikely, and I'm also
guessing due to the shared code of get_folio() / fault(), codes will be
preheated and it may not be measureable even if we write it like that.

Then maybe we can avoid this new flag completely but also achieve the same
goal.

Thanks,

-- 
Peter Xu


