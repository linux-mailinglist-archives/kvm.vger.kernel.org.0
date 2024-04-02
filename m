Return-Path: <kvm+bounces-13390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AFBB895BC4
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 20:31:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E7ED1C227B5
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 18:31:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CE4715B12C;
	Tue,  2 Apr 2024 18:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gueSDceB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725A560264
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 18:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712082703; cv=none; b=J0a7xdQewsvON4tSKT3C7DJnAYshA2OeBj6OJ/+f1ht1WTHjkfrNY4WIKQOMtUFpKZhSQNcT71xkBG93zrCNWSgnVHYm1iwm8Ok/JFYYI3FUquJcsYvSuQa1Nu1OKAJ9NOtOdbfzk39S976YdVDPI5UZpafrLMry9VGp1Ci7OWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712082703; c=relaxed/simple;
	bh=qDApzRLT64Qi6pbqkdTWjmJkL9+/WQNfFdxV94XLxFk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iyxJQMXUQ0PIbfz6u9RNlUgf0gRyiuEdI3H9Wvip/34RPKbGzhJFY805gWKxUf2TUC54VDsNLxQ3n0YcYs/l/e+uE4aHWhKlx9FFpUcaigtsuPG3sMFvoroiM5Z8QZc42F10CiEaltl9cRc1XA1Ns5yNQ4Q5KA866/6vtSlacIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gueSDceB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712082700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lMrQ/HyPcTUexiexGuHGYoI8R6rk48hQ9GiX28Xmjeo=;
	b=gueSDceBOKrXll08xBP7p1ZoAY4dQKfSrd3zJ9fahLT1NrZA0YCgbnus2Wm/KgUL2zJ5ze
	j6VRVfNd1WhoYoipzU/wRS5ncTLXnVS9WzeimD4h+e6FGixSrPFP6Ow907ENU+76/nBEWI
	x7jmUH93f/yRaePIALXFVyaHXqquKjk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-207-wwT_nVEDOR2ctAJo7GZSYw-1; Tue, 02 Apr 2024 14:31:38 -0400
X-MC-Unique: wwT_nVEDOR2ctAJo7GZSYw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33ed44854ddso2947881f8f.2
        for <kvm@vger.kernel.org>; Tue, 02 Apr 2024 11:31:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712082697; x=1712687497;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lMrQ/HyPcTUexiexGuHGYoI8R6rk48hQ9GiX28Xmjeo=;
        b=ZLdNgSFgTkQPuhyFAeKwfsg1JM58BKV5cpLD8MlnDP+YclhyLQ+6gbPuoF76vfdf4s
         F4BYYXnCQgHS4qbMImw6u7MXXW7KvfJb7QwZppowUhrtAcwWOzOWEhrzkQlt5vnec/ay
         ivrEC6zj19kVvtO+nnHDhkh3pWKTMdtXpn9mp3U0sv+/zoApqExz+HEhCkDDPfbVHmX/
         JWvS//8jEUwpeyH64y5/CbEmE7THNKXRpeuAxCIefdlTTMUBBxqaXXlL7RAXq36tL07C
         YhyZ+NsU2/12Lkytty0U0a1MgY2iQIYQ2cJkuYVyO7JLxC12AduwpxWUcBvk3z+Ttq1B
         Cbrg==
X-Forwarded-Encrypted: i=1; AJvYcCX4a5Nj4K6WnbnAfRCeNhN95KJ4g75eXXITnLGPnwt+3RbvdDZnwlIDpLEFafzBgmwVT6syijiSDYcg1bipOlt+jvdT
X-Gm-Message-State: AOJu0YxFyRZSJYT1syaOumCTGo+HAqtOVz3P0o4vP6EBjznNj+hn5jDE
	YMdpMUBix0/8/2IbOggFMLktsjO4QF0wOGGfpgjZFHQpxwNtgSOvzmZtwKOfQeLK2t3X0Xj9w8O
	SnSApaV3eBOCtDG9bARjorNeujyG1bU7dR0o8C7I7GwaLvQtXGg==
X-Received: by 2002:adf:b1da:0:b0:33e:ce15:85bb with SMTP id r26-20020adfb1da000000b0033ece1585bbmr7829889wra.59.1712082697498;
        Tue, 02 Apr 2024 11:31:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGILf5QxxKk9M6qng8emj8A3NI6qmWp3gBoZ7tdLmpspbS+wR+DOTTBPlsXkp7h+/Apayhn3A==
X-Received: by 2002:adf:b1da:0:b0:33e:ce15:85bb with SMTP id r26-20020adfb1da000000b0033ece1585bbmr7829869wra.59.1712082696983;
        Tue, 02 Apr 2024 11:31:36 -0700 (PDT)
Received: from ?IPV6:2003:cb:c732:e600:4982:2903:710f:f20a? (p200300cbc732e60049822903710ff20a.dip0.t-ipconnect.de. [2003:cb:c732:e600:4982:2903:710f:f20a])
        by smtp.gmail.com with ESMTPSA id bq24-20020a5d5a18000000b0033e45930f35sm15122595wrb.6.2024.04.02.11.31.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Apr 2024 11:31:36 -0700 (PDT)
Message-ID: <a2fff462-dfe6-4979-a7b2-131c6e0b5017@redhat.com>
Date: Tue, 2 Apr 2024 20:31:35 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] KVM: x86/mmu: Rework marking folios
 dirty/accessed
To: David Matlack <dmatlack@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, David Stevens <stevensd@chromium.org>,
 Matthew Wilcox <willy@infradead.org>
References: <20240320005024.3216282-1-seanjc@google.com>
 <4d04b010-98f3-4eae-b320-a7dd6104b0bf@redhat.com>
 <CALzav=eLH+V_5Y6ZWsRkmnbEb6fxPa55B7xyWxP3o6qsrs_nHA@mail.gmail.com>
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CALzav=eLH+V_5Y6ZWsRkmnbEb6fxPa55B7xyWxP3o6qsrs_nHA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 02.04.24 19:38, David Matlack wrote:
> On Wed, Mar 20, 2024 at 5:56 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 20.03.24 01:50, Sean Christopherson wrote:
>>> Rework KVM to mark folios dirty when creating shadow/secondary PTEs (SPTEs),
>>> i.e. when creating mappings for KVM guests, instead of when zapping or
>>> modifying SPTEs, e.g. when dropping mappings.
>>>
>>> The motivation is twofold:
>>>
>>>     1. Marking folios dirty and accessed when zapping can be extremely
>>>        expensive and wasteful, e.g. if KVM shattered a 1GiB hugepage into
>>>        512*512 4KiB SPTEs for dirty logging, then KVM marks the huge folio
>>>        dirty and accessed for all 512*512 SPTEs.
>>>
>>>     2. x86 diverges from literally every other architecture, which updates
>>>        folios when mappings are created.  AFAIK, x86 is unique in that it's
>>>        the only KVM arch that prefetches PTEs, so it's not quite an apples-
>>>        to-apples comparison, but I don't see any reason for the dirty logic
>>>        in particular to be different.
>>>
>>
>> Already sorry for the lengthy reply.
>>
>>
>> On "ordinary" process page tables on x86, it behaves as follows:
>>
>> 1) A page might be mapped writable but the PTE might not be dirty. Once
>>      written to, HW will set the PTE dirty bit.
>>
>> 2) A page might be mapped but the PTE might not be young. Once accessed,
>>      HW will set the PTE young bit.
>>
>> 3) When zapping a page (zap_present_folio_ptes), we transfer the dirty
>>      PTE bit to the folio (folio_mark_dirty()), and the young PTE bit to
>>      the folio (folio_mark_accessed()). The latter is done conditionally
>>      only (vma_has_recency()).
>>
>> BUT, when zapping an anon folio, we don't do that, because there zapping
>> implies "gone for good" and not "content must go to a file".
>>
>> 4) When temporarily unmapping a folio for migration/swapout, we
>>      primarily only move the dirty PTE bit to the folio.
>>
>>
>> GUP is different, because the PTEs might change after we pinned the page
>> and wrote to it. We don't modify the PTEs and expect the GUP user to do
>> the right thing (set dirty/accessed). For example,
>> unpin_user_pages_dirty_lock() would mark the page dirty when unpinning,
>> where the PTE might long be gone.
>>
>> So GUP does not really behave like HW access.
>>
>>
>> Secondary page tables are different to ordinary GUP, and KVM ends up
>> using GUP to some degree to simulate HW access; regarding NUMA-hinting,
>> KVM already revealed to be very different to all other GUP users. [1]
>>
>> And I recall that at some point I raised that we might want to have a
>> dedicate interface for these "mmu-notifier" based page table
>> synchonization mechanism.
>>
>> But KVM ends up setting folio dirty/access flags itself, like other GUP
>> users. I do wonder if secondary page tables should be messing with folio
>> flags *at all*, and if there would be ways to to it differently using PTEs.
>>
>> We make sure to synchronize the secondary page tables to the process
>> page tables using MMU notifiers: when we write-protect/unmap a PTE, we
>> write-protect/unmap the SPTE. Yet, we handle accessed/dirty completely
>> different.
> 
> Accessed bits have the test/clear young MMU-notifiers. But I agree
> there aren't any notifiers for dirty tracking.
> 

Yes, and I am questioning if the "test" part should exist -- or if 
having a spte in the secondary MMU should require the access bit to be 
set (derived from the primary MMU). (again, my explanation about fake HW 
page table walkers)

There might be a good reason to do it like that nowadays, so I'm only 
raising it as something I was wondering. Likely, frequent clearing of 
the access bit would result in many PTEs in the secondary MMU getting 
invalidated, requiring a new GUP-fast lookup where we would set the 
access bit in the primary MMU PTE. But I'm not an expert on the 
implications with MMU notifiers and access bit clearing.

> Are there any cases where the primary MMU transfers the PTE dirty bit
> to the folio _other_ than zapping (which already has an MMU-notifier
> to KVM). If not then there might not be any reason to add a new
> notifier. Instead the contract should just be that secondary MMUs must
> also transfer their dirty bits to folios in sync (or before) the
> primary MMU zaps its PTE.

Grepping for pte_mkclean(), there might be some cases. Many cases use 
MMU notifier, because they either clear the PTE or also remove write 
permissions.

But these is madvise_free_pte_range() and 
clean_record_shared_mapping_range()...->clean_record_pte(), that might 
only clear the dirty bit without clearing/changing permissions and 
consequently not calling MMU notifiers.

Getting a writable PTE without the dirty bit set should be possible.

So I am questioning whether having a writable PTE in the secondary MMU 
with a clean PTE in the primary MMU should be valid to exist. It can 
exist today, and I am not sure if that's the right approach.

> 
>>
>>
>> I once had the following idea, but I am not sure about all implications,
>> just wanted to raise it because it matches the topic here:
>>
>> Secondary page tables kind-of behave like "HW" access. If there is a
>> write access, we would expect the original PTE to become dirty, not the
>> mapped folio.
> 
> Propagating SPTE dirty bits to folios indirectly via the primary MMU
> PTEs won't work for guest_memfd where there is no primary MMU PTE. In
> order to avoid having two different ways to propagate SPTE dirty bits,
> KVM should probably be responsible for updating the folio directly.
> 

But who really cares about access/dirty bits for guest_memfd?

guest_memfd already wants to disable/bypass all of core-MM, so different 
rules are to be expected. This discussion is all about integration with 
core-MM that relies on correct dirty bits, which does not really apply 
to guest_memfd.

-- 
Cheers,

David / dhildenb


