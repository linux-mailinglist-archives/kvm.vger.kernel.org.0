Return-Path: <kvm+bounces-26173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F47797260D
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 02:08:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C65728324B
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 00:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10D754A01;
	Tue, 10 Sep 2024 00:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L3uxbiYI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15FC1859
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 00:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725926905; cv=none; b=uFsYVDOyAHeyKYBUdZkYAa+YnK6yKwXOF6nMdkiwa3zogQTUTP2WtdopbhnyT5B9VdEPV1ZaGGau2F/BviuHhBxUMzFuOc8X6JAPgJjBzazaLJ82z2KSzfT9kwyyMxf9ZETK30dSrKQGF+3Gu5FSx2h5CRagIJPkmt4Q2ucD3cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725926905; c=relaxed/simple;
	bh=Do2fCornus2k7XFLKiGW+Kh3SphMXE9ozbe7zCoiQuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pzypmod2bc/8rT6g7SOLXq9f4UqgKVX2k4fk7Ewfl3v1GelaNL5oyZbVcDzIlrAtK9VwQbtS4OtrAxBxH84y/49HGYokWC49EbnMUNn4mo5TUvpQcyckt6bAowpqga1Gt05RpF0Decdqlp/EhAkIsiafQJct1VoLYrM4EzsCvds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L3uxbiYI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725926902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nS90PBsQLo/NAADX0RLPD+B7rTpNZ5FJaTlKjF8OXUU=;
	b=L3uxbiYIsAJaCg4EWsOmjRioxJpvgccM77IkHsUe5xZbF/kCfog8k9VO/EXzZDa6y2ENKH
	1sWg3wGb604hs7NCRptA8yCNjDIAI4vbx8rYd5xf/Sz4sAEv+k3UBlgTMios5ZAjsf7tHr
	dxeNxDd2UGIDep0cZsD1G2ZwI1sxcpo=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-1iAS_DayNrClpeD8v6p7Ug-1; Mon, 09 Sep 2024 20:08:21 -0400
X-MC-Unique: 1iAS_DayNrClpeD8v6p7Ug-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6bf6bcee8ccso81687326d6.0
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 17:08:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725926901; x=1726531701;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nS90PBsQLo/NAADX0RLPD+B7rTpNZ5FJaTlKjF8OXUU=;
        b=PTD844GHzAStloTCvoHGlg3qLu1cj4I0Qx+SbMn37NdTohLCwTUXnDwNPzNGfP71h3
         NwCmzPDp24iZ4yqW3oYc8xBzNpSxTdvaDTAarNRamrtGs5QHB8XKzjmUHj203QjmoWzm
         mOUFhKeVQ4Va6B6IbJxLQW7HpHKs0BH223attHToMUVdnliDQJPwZeJpgw30s8Z/3bAr
         3U6KUsIVDZPgKJ2m4Qi8e8HbNWLPd6NnB2oNCzwDCUDcJqT+aJVZPSlxyYJgoR7MLPsh
         BGMnkPel+/gUdc9yRx2G+sMhVv9oS6K5VqfP6MzfhLSPL0IRik+HZJPst6f6AhzmW2EK
         rIag==
X-Forwarded-Encrypted: i=1; AJvYcCUZsuBTJZN6A+Zf/lVb/Ta/p2+OmQ9PP95bvZ7GhrY7oen2qjFFZmxOkxpDc3nSWa1xkrg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjEjJ8Bl8haNFybHuS4nO2ZA3U80bS+R4ManKEqXt3sRsW+57L
	VQHwj1lcS834LYXfZ9oY70FOq1Q+/eJoqXSUm61nyo0cUElcCQMHGO5mLOSfQcYjixHsT2LodFS
	F+SgGPl0YMVJIf34NKpQaRro6gTsWHMt2b7MfgMQ5l7Sk+dfVLA==
X-Received: by 2002:a05:6214:2dc2:b0:6c5:53b8:c8b1 with SMTP id 6a1803df08f44-6c553b8c8e3mr29372096d6.13.1725926900639;
        Mon, 09 Sep 2024 17:08:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4mcc+7qwVSx7ydxnAtNmRQVI9fbDsEeVC4thly4922XNAYI8zD2xHJ+6aII9StNVEuLJ8dw==
X-Received: by 2002:a05:6214:2dc2:b0:6c5:53b8:c8b1 with SMTP id 6a1803df08f44-6c553b8c8e3mr29371626d6.13.1725926900246;
        Mon, 09 Sep 2024 17:08:20 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c53432968esm25143526d6.23.2024.09.09.17.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 17:08:19 -0700 (PDT)
Date: Mon, 9 Sep 2024 20:08:16 -0400
From: Peter Xu <peterx@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yan Zhao <yan.y.zhao@intel.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>, Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 07/19] mm/fork: Accept huge pfnmap entries
Message-ID: <Zt-N8MB93XSqFZO_@x1n>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <20240826204353.2228736-8-peterx@redhat.com>
 <ZtVwLntpS0eJubFq@yzhao56-desk.sh.intel.com>
 <Ztd-WkEoFJGZ34xj@x1n>
 <20240909152546.4ef47308e560ce120156bc35@linux-foundation.org>
 <Zt96CoGoMsq7icy7@x1n>
 <20240909161539.aa685e3eb44cdc786b8c05d2@linux-foundation.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240909161539.aa685e3eb44cdc786b8c05d2@linux-foundation.org>

On Mon, Sep 09, 2024 at 04:15:39PM -0700, Andrew Morton wrote:
> On Mon, 9 Sep 2024 18:43:22 -0400 Peter Xu <peterx@redhat.com> wrote:
> 
> > > > > Do we need the logic to clear dirty bit in the child as that in
> > > > > __copy_present_ptes()?  (and also for the pmd's case).
> > > > > 
> > > > > e.g.
> > > > > if (vma->vm_flags & VM_SHARED)
> > > > > 	pud = pud_mkclean(pud);
> > > > 
> > > > Yeah, good question.  I remember I thought about that when initially
> > > > working on these lines, but I forgot the details, or maybe I simply tried
> > > > to stick with the current code base, as the dirty bit used to be kept even
> > > > in the child here.
> > > > 
> > > > I'd expect there's only performance differences, but still sounds like I'd
> > > > better leave that to whoever knows the best on the implications, then draft
> > > > it as a separate patch but only when needed.
> > > 
> > > Sorry, but this vaguensss simply leaves me with nowhere to go.
> > > 
> > > I'll drop the series - let's revisit after -rc1 please.
> > 
> > Andrew, would you please explain why it needs to be dropped?
> > 
> > I meant in the reply that I think we should leave that as is, and I think
> > so far nobody in real life should care much on this bit, so I think it's
> > fine to leave the dirty bit as-is.
> > 
> > I still think whoever has a better use of the dirty bit and would like to
> > change the behavior should find the use case and work on top, but only if
> > necessary.
> 
> Well.  "I'd expect there's only performance differences" means to me
> "there might be correctness issues, I don't know".  Is it or is it not
> merely a performance thing?

There should have no correctness issue pending.  It can only be about
performance, and AFAIU what this patch does is exactly the way where it
shouldn't ever change performance either, as it didn't change how dirty bit
was processed (just like before this patch), not to mention correctness (in
regards to dirty bits).

I can provide some more details.

Here the question we're discussing is "whether we should clear the dirty
bit in the child for a pgtable entry when it's VM_SHARED".  Yan observed
that we don't do the same thing for pte/pmd/pud, which is true.

Before this patch:

  - For pte:     we clear dirty bit if VM_SHARED in child when copy
  - For pmd/pud: we never clear dirty bit in the child when copy

The behavior of clearing dirty bit for VM_SHARED in child for pte level
originates to the 1st commit that git history starts.  So we always do so
for 19 years.

That makes sense to me, because clearing dirty bit in pte normally requires
a SetDirty on the folio, e.g. in unmap path:

        if (pte_dirty(pteval))
                folio_mark_dirty(folio);

Hence cleared dirty bit in the child should avoid some extra overheads when
the pte maps a file cache, so clean pte can at least help us to avoid calls
into e.g. mapping's dirty_folio() functions (in which it should normally
check folio_test_set_dirty() again anyway, and parent pte still have the
dirty bit set so we won't miss setting folio dirty):

folio_mark_dirty():
        if (folio_test_reclaim(folio))
                folio_clear_reclaim(folio);
        return mapping->a_ops->dirty_folio(mapping, folio);

However there's the other side of thing where when the dirty bit is missing
I _think_ it also means when the child writes to the cleaned pte, it'll
require (e.g. on hardware accelerated archs) MMU setting dirty bit which is
slower than if we don't clear the dirty bit... and on software emulated
dirty bits it could even require a page fault, IIUC.

In short, personally I don't know what's the best to do, on keep / remove
the dirty bit even if it's safe either way: there are pros and cons on
different decisions.

That's why I said I'm not sure which is the best way.  I had a feeling that
most of the people didn't even notice this, and we kept running this code
for the past 19 years just all fine..

OTOH, we don't do the same for pmds/puds (in which case we persist dirty
bits always in child), and I didn't check whether it's intended, or why.
It'll have similar reasoning as above discussion on pte, or even more I
overlooked.

So again, the safest approach here is in terms of dirty bit we keep what we
do as before.  And that's what this patch does as of now.

IOW, if I'll need a repost, I'll repost exactly the same thing (with the
fixup I sent later, which is already in mm-unstable).

Thanks,

-- 
Peter Xu


