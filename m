Return-Path: <kvm+bounces-12304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8F448811EB
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 13:57:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D6B01C22561
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 12:56:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E93864085F;
	Wed, 20 Mar 2024 12:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CjTFYatb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4975C405D8
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 12:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710939410; cv=none; b=OlDh0NunjD7isolTeFcGEQq5FWdDnTjNFAUVTf2+Qaw+Mg1TO5mfsBUStqEREwW0Q+tfUCwgQOmUZaYyhghYj80QRbhp5rsfta+KOXg4kwKFvRDs51e7em0Fh24ziWjk4gLE1ULsnEgmur+qO/QDDBFVSyqlJ4vGFd0SojzxNMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710939410; c=relaxed/simple;
	bh=7WP3NZz8W6CSQJs6grw4TUgcjKkadfqoNi0otcPZi/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZSb4Ak7Mr34lMnQhHbYTDpMYVH18bsrLen8CusCQu3BwBbhoB9d1KYgXHFPRmv8pksOsYmww2RUzNGRKysdgktOnAIHlYC95gu1ii4Zl2H5j3/3UHSdLJKUg1OI64M7IyhbXXENeyzbkijN1ci358C7iExGo+wq/64QCOzLv/Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CjTFYatb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710939407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sOwLWwmW+09zjoUctb0Q1gWWyhKm3u3MXRqyHpzNzbs=;
	b=CjTFYatbTqabIX930DMOWZe/EOKlXeTaC9iRDojvSE9oBMls6XQXtxZZvvT0HXj7V5HYJB
	2fwosY5ma6AAMtzuWv/iSWQcmhWUy4FT1199Gg+dV4T20rvXqbopoin/PxanhGL88W5tjd
	mi1dP6ogv+79S4bMRdjVq12g6XKP/8c=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-n0qJcl06PcC_2tgTRGEs9g-1; Wed, 20 Mar 2024 08:56:45 -0400
X-MC-Unique: n0qJcl06PcC_2tgTRGEs9g-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2d5a70f5422so18375081fa.3
        for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 05:56:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710939404; x=1711544204;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sOwLWwmW+09zjoUctb0Q1gWWyhKm3u3MXRqyHpzNzbs=;
        b=tXndTr6Qa7sskCtMOdxa8A/EKopNwlWyUfGcU+Ugj9qZYMmrONAFvQ+ertOpBz+YuO
         No77G2+ujotDRIek3Ba1rFf/WRsm16rWjDI8HXf0Yi/GFXT2kXMuI28tXnqmxyeNW/VE
         ISKA/fMxVsYOy6KdeqREK81L1Wh0TZRpo7JVJ8dquORTUvbZ8GBlybs1t5lMZYLnPqCs
         +34Gx+xD8IMueV56aCaYryyqucQxUGmM7Tq9c+kY1S50BlFw19nb6swuHHMCNkmdngAQ
         p7X2VJsHfLDFOe8mfq4ekXHRBM8ICzaWBIxeNPL9+3PmzcY6ZqG5hcbs41id/ORYLPbs
         kFNA==
X-Gm-Message-State: AOJu0YwFM1BT0IJFW+RK84kjVL5HxvtJdRXUhOx34BI+RT2tzsue/GHo
	RrrLSL0CGMh/CRVBUqcns1iRlC7UIQajaWfStXHCZND2ZNSU5FLe96XI7mcksLrmfrbDyfi2oAV
	a+3hGvUZrLO14GRGaqtyprm8yZzTMbwpm/R273+k4KnNegYZ/JA==
X-Received: by 2002:a2e:b8cb:0:b0:2d3:f81b:7f9 with SMTP id s11-20020a2eb8cb000000b002d3f81b07f9mr1667772ljp.21.1710939403773;
        Wed, 20 Mar 2024 05:56:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE1AakMEqzqn7RrrEePI/PeRoZn/DKMttlKGHpvkcB4m4BTSecu9Be0929CsuBDHTm60DhzCQ==
X-Received: by 2002:a2e:b8cb:0:b0:2d3:f81b:7f9 with SMTP id s11-20020a2eb8cb000000b002d3f81b07f9mr1667749ljp.21.1710939403238;
        Wed, 20 Mar 2024 05:56:43 -0700 (PDT)
Received: from ?IPV6:2003:cb:c709:c400:9a2:3872:9372:fbc? (p200300cbc709c40009a2387293720fbc.dip0.t-ipconnect.de. [2003:cb:c709:c400:9a2:3872:9372:fbc])
        by smtp.gmail.com with ESMTPSA id p5-20020a05600c468500b004132ae838absm2186167wmo.43.2024.03.20.05.56.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Mar 2024 05:56:42 -0700 (PDT)
Message-ID: <4d04b010-98f3-4eae-b320-a7dd6104b0bf@redhat.com>
Date: Wed, 20 Mar 2024 13:56:41 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] KVM: x86/mmu: Rework marking folios
 dirty/accessed
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>,
 Matthew Wilcox <willy@infradead.org>
References: <20240320005024.3216282-1-seanjc@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240320005024.3216282-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.03.24 01:50, Sean Christopherson wrote:
> Rework KVM to mark folios dirty when creating shadow/secondary PTEs (SPTEs),
> i.e. when creating mappings for KVM guests, instead of when zapping or
> modifying SPTEs, e.g. when dropping mappings.
> 
> The motivation is twofold:
> 
>    1. Marking folios dirty and accessed when zapping can be extremely
>       expensive and wasteful, e.g. if KVM shattered a 1GiB hugepage into
>       512*512 4KiB SPTEs for dirty logging, then KVM marks the huge folio
>       dirty and accessed for all 512*512 SPTEs.
> 
>    2. x86 diverges from literally every other architecture, which updates
>       folios when mappings are created.  AFAIK, x86 is unique in that it's
>       the only KVM arch that prefetches PTEs, so it's not quite an apples-
>       to-apples comparison, but I don't see any reason for the dirty logic
>       in particular to be different.
> 

Already sorry for the lengthy reply.


On "ordinary" process page tables on x86, it behaves as follows:

1) A page might be mapped writable but the PTE might not be dirty. Once
    written to, HW will set the PTE dirty bit.

2) A page might be mapped but the PTE might not be young. Once accessed,
    HW will set the PTE young bit.

3) When zapping a page (zap_present_folio_ptes), we transfer the dirty
    PTE bit to the folio (folio_mark_dirty()), and the young PTE bit to
    the folio (folio_mark_accessed()). The latter is done conditionally
    only (vma_has_recency()).

BUT, when zapping an anon folio, we don't do that, because there zapping 
implies "gone for good" and not "content must go to a file".

4) When temporarily unmapping a folio for migration/swapout, we
    primarily only move the dirty PTE bit to the folio.


GUP is different, because the PTEs might change after we pinned the page 
and wrote to it. We don't modify the PTEs and expect the GUP user to do 
the right thing (set dirty/accessed). For example, 
unpin_user_pages_dirty_lock() would mark the page dirty when unpinning, 
where the PTE might long be gone.

So GUP does not really behave like HW access.


Secondary page tables are different to ordinary GUP, and KVM ends up 
using GUP to some degree to simulate HW access; regarding NUMA-hinting, 
KVM already revealed to be very different to all other GUP users. [1]

And I recall that at some point I raised that we might want to have a 
dedicate interface for these "mmu-notifier" based page table 
synchonization mechanism.

But KVM ends up setting folio dirty/access flags itself, like other GUP 
users. I do wonder if secondary page tables should be messing with folio 
flags *at all*, and if there would be ways to to it differently using PTEs.

We make sure to synchronize the secondary page tables to the process 
page tables using MMU notifiers: when we write-protect/unmap a PTE, we 
write-protect/unmap the SPTE. Yet, we handle accessed/dirty completely 
different.


I once had the following idea, but I am not sure about all implications, 
just wanted to raise it because it matches the topic here:

Secondary page tables kind-of behave like "HW" access. If there is a 
write access, we would expect the original PTE to become dirty, not the 
mapped folio.

1) When KVM wants to map a page into the secondary page table, we
    require the PTE to be young (like a HW access). The SPTE can remain
    old.

2) When KVM wants to map a page writable into the secondary page table,
    we require the PTE to be dirty (like a HW access). The SPTE can
    remain old.

3) When core MM clears the PTE dirty/young bit, we notify the secondary
    page  table to adjust: for example, if the dirty bit gets cleared,
    the page cannot be writable in the secondary MMU.

4) GUP-fast cannot set the pte dirty/young, so we would fallback to slow
    GUP, wehre we hold the PTL, and simply modify the PTE to have the
    accessed/dirty bit set.

5) Prefetching would similarly be limited to that (only prefetch if PTE
    is already dirty etc.).

6) Dirty/accessed bits not longer have to be synced from the secondary
    page table to the process page table. Because an SPTE being dirty
    implies that the PTE is dirty.


One tricky bit, why ordinary GUP modifies the folio and not the PTE, is 
concurrent HW access. For example, when we want to mark a PTE accessed, 
it could happen that HW concurrently tries marking the PTE dirty. We 
must not lose that update, so we have to guarantee an atomic update 
(maybe avoidable in some cases).

What would be the implications? We'd leave setting folio flags to the MM 
core. That also implies, that if you shutdown a VM an zap all anon 
folios, you wouldn't have to mark any folio dirty: the pte is dirty, and 
MM core can decide to ignore that flag since it will discard the page 
either way.

Downsides? Likely many I have not yet thought about (TLB flushes etc). 
Just mentioning it because in context of [1] I was wondering if 
something that uses MMU notifiers should really be messing with 
dirty/young flags :)


> I tagged this RFC as it is barely tested, and because I'm not 100% positive
> there isn't some weird edge case I'm missing, which is why I Cc'd David H.
> and Matthew.

We'd be in trouble if someone would detect that all PTEs are clean, so 
it can clear the folio dirty flag (for example, after writeback). Then, 
we would write using the SPTE and the folio+PTE would be clean. If we 
then evict the "clean" folio that is actually dirty, we would be in trouble.

Well, we would set the SPTE dirty flag I guess. But I cannot immediately 
tell if that one would be synced back to the folio? Would we have a 
mechanism in place to prevent that?

> 
> Note, I'm going to be offline from ~now until April 1st.  I rushed this out
> as it could impact David S.'s kvm_follow_pfn series[*], which is imminent.
> E.g. if KVM stops marking pages dirty and accessed everywhere, adding
> SPTE_MMU_PAGE_REFCOUNTED just to sanity check that the refcount is elevated
> seems like a poor tradeoff (medium complexity and annoying to maintain, for
> not much benefit).
> 
> Regarding David S.'s series, I wouldn't be at all opposed to going even
> further and having x86 follow all architectures by marking pages accessed
> _only_ at map time, at which point I think KVM could simply pass in FOLL_TOUCH
> as appropriate, and thus dedup a fair bit of arch code.

FOLL_TOUCH is weird (excluding weird devmap stuff):

1) For PTEs (follow_page_pte), we set the page dirty and accessed, and
    do not modify the PTE. For THP (follow_trans_huge_pmd), we set the
    PMD young/dirty and don't mess with the folio.

2) FOLL_TOUCH is not implemented for hugetlb.

3) FOLL_TOUCH is not implemented for GUP-fast.

I'd leave that alone :)


[1] 
https://lore.kernel.org/lkml/20230727212845.135673-1-david@redhat.com/T/#u
-- 
Cheers,

David / dhildenb


