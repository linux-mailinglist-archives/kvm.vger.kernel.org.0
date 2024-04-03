Return-Path: <kvm+bounces-13500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00C58897AF9
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 23:44:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 540A8B27591
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 21:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10BB7156880;
	Wed,  3 Apr 2024 21:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IPTADyD+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5582B156677
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 21:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712180642; cv=none; b=UVB5KRHd8F/zHELMi8nuMzI4rGzX2+1DEMpIzwnN6Nt156UL+lmyXWjcuY3tueSGlaqzMOanXE0FZEaLcNQrn7tcjeQYtEZQy+FEYyqucU+duMhTSIbUHeTJWSu4BHBAajLOGFNwoqEfd53pyqRgyxPfAAWJm0LlCjFee/31uB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712180642; c=relaxed/simple;
	bh=ixtQYXBShbBMtdvtoLxpRU9Dd+YhiX6dI/WSVrySfHk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N8pF7mKbXmhMkfZEDYBulhApGU3H7nfhV+d1aYwjJRRmjcYtEsN9eS0cpasbjQJ7MDRs4WiYCAhaCSjpVs7P+O58PQDr0rhQQ6GNxUflFvBNV0lbYQPsZVNPDVjKf3zzN5C5xOtNbFlGlSaWD+MM0T8WyEIo97sg8XMiN49OOBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IPTADyD+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712180639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DR1VRM2YOLBnde8LCoWidizffjEaSuWiF6q/aH62up0=;
	b=IPTADyD+T3qhGXrll82iY2k7P0bltsCwdSt5iwK7+831dqfrKmjyqOsKd6Vcwm9ivIB7AF
	ANorhklIXMBbMxj9iAyctxfV5VMX77aBmbjpY1uEriVWRdTQ2uSF3UF+QOEPgHL+jEWK3h
	Erh8/g9NvZZ3pSxxew7EN9MzqOzGx8g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-yUJvakW4Oq-Lb1KIBBhraw-1; Wed, 03 Apr 2024 17:43:58 -0400
X-MC-Unique: yUJvakW4Oq-Lb1KIBBhraw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3435b7d66c3so119884f8f.3
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 14:43:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712180637; x=1712785437;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DR1VRM2YOLBnde8LCoWidizffjEaSuWiF6q/aH62up0=;
        b=bGSzft9+EMWOXliQVLhlUclzM9TrZ2V2DClX/X3Mzcs6CmY+STPP6oG6VzZNHY3xER
         yOafFTPaLqGtulXEgwpbPeeXjysktlcwh1BzaEpna3WObmbS70oxdl9WgXF+GteARUBb
         e/vhkAg2TRXSGMYNYnKBZdKOmcVzaYjhx3H3Dv0LXMLnYSvdFgGbzZL3dcHv3NI4D2DZ
         GBwJWapzFBcP4U+oux21LZKYZyAMEEbKFzacA6rcw1WhfXlRSMEFs/m+qLnh8zqOHhSJ
         EeDR1ooFI8KgWr5KndS4jnwS+4wWXvpwMLuS66xg8dexkbcS0a4Hw5nJZzXBurN/U+mS
         UJlQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/WXl+3o+VCG+LsioP/y4u5grmk0HSp80+X2qRJHgzazbesFFkgpfP4Y+bG9xmCGP3hVCU2+BAqq8AtKOYJZelLSmv
X-Gm-Message-State: AOJu0Yzdqi9iAPC3iwlIqDzE80jsv60/Gkp/bMGvFueABNAVowvbb8Rs
	A43YEhR60+pcJS3JH12qfFfFPAnFpa0ClKbydqg7LhtN/XjgDwtbF9Zqp0hilDHeXzTLAFl2mpW
	0vvlNpcdDfvrCl3iR8VlqcLGEre8AJJsJTJp8QQxMEuEl+i2EEQ==
X-Received: by 2002:adf:f144:0:b0:343:7ed6:765b with SMTP id y4-20020adff144000000b003437ed6765bmr526506wro.39.1712180636800;
        Wed, 03 Apr 2024 14:43:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEHkVb9dPN0yoYxl+zKx5sanHKInoYLHxJUWewvF9xtngGG9bq+hOUHhyqEPvoJcncER6AOzA==
X-Received: by 2002:adf:f144:0:b0:343:7ed6:765b with SMTP id y4-20020adff144000000b003437ed6765bmr526495wro.39.1712180636347;
        Wed, 03 Apr 2024 14:43:56 -0700 (PDT)
Received: from ?IPV6:2003:cb:c73b:3100:2d28:e0b7:1254:b2f6? (p200300cbc73b31002d28e0b71254b2f6.dip0.t-ipconnect.de. [2003:cb:c73b:3100:2d28:e0b7:1254:b2f6])
        by smtp.gmail.com with ESMTPSA id ee6-20020a056000210600b00343826878e8sm3895991wrb.38.2024.04.03.14.43.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Apr 2024 14:43:55 -0700 (PDT)
Message-ID: <ca1f320b-dc06-48e0-b4f5-ce860a72f0e2@redhat.com>
Date: Wed, 3 Apr 2024 23:43:55 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] KVM: x86/mmu: Rework marking folios
 dirty/accessed
To: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 David Stevens <stevensd@chromium.org>, Matthew Wilcox <willy@infradead.org>
References: <20240320005024.3216282-1-seanjc@google.com>
 <4d04b010-98f3-4eae-b320-a7dd6104b0bf@redhat.com>
 <CALzav=eLH+V_5Y6ZWsRkmnbEb6fxPa55B7xyWxP3o6qsrs_nHA@mail.gmail.com>
 <a2fff462-dfe6-4979-a7b2-131c6e0b5017@redhat.com>
 <ZgygGmaEuddZGKyX@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ZgygGmaEuddZGKyX@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 03.04.24 02:17, Sean Christopherson wrote:
> On Tue, Apr 02, 2024, David Hildenbrand wrote:
>> On 02.04.24 19:38, David Matlack wrote:
>>> On Wed, Mar 20, 2024 at 5:56 AM David Hildenbrand <david@redhat.com> wrote:
>>>> Secondary page tables are different to ordinary GUP, and KVM ends up
>>>> using GUP to some degree to simulate HW access; regarding NUMA-hinting,
>>>> KVM already revealed to be very different to all other GUP users. [1]
>>>>
>>>> And I recall that at some point I raised that we might want to have a
>>>> dedicate interface for these "mmu-notifier" based page table
>>>> synchonization mechanism.
>>>>
>>>> But KVM ends up setting folio dirty/access flags itself, like other GUP
>>>> users. I do wonder if secondary page tables should be messing with folio
>>>> flags *at all*, and if there would be ways to to it differently using PTEs.
>>>>
>>>> We make sure to synchronize the secondary page tables to the process
>>>> page tables using MMU notifiers: when we write-protect/unmap a PTE, we
>>>> write-protect/unmap the SPTE. Yet, we handle accessed/dirty completely
>>>> different.
>>>
>>> Accessed bits have the test/clear young MMU-notifiers. But I agree
>>> there aren't any notifiers for dirty tracking.
>>
>> Yes, and I am questioning if the "test" part should exist -- or if having a
>> spte in the secondary MMU should require the access bit to be set (derived
>> from the primary MMU). (again, my explanation about fake HW page table
>> walkers)
>>
>> There might be a good reason to do it like that nowadays, so I'm only
>> raising it as something I was wondering. Likely, frequent clearing of the
>> access bit would result in many PTEs in the secondary MMU getting
>> invalidated, requiring a new GUP-fast lookup where we would set the access
>> bit in the primary MMU PTE. But I'm not an expert on the implications with
>> MMU notifiers and access bit clearing.
> 
> Ya.  KVM already does something similar this for dirty logging, where SPTEs are
> write-protected, i.e. generate faults to track dirty status.  But KVM x86 has a
> lot of code to mitigates the resulting pain, e.g. has a lockless fast-path to
> make the SPTE writable and propagate the dirty status to bitmaps, and userspace
> is heavily/carefully optimized to balance harvesting/clearing dirty status against
> guest activity.
> 
> In general, assumptions that core MM makes about the cost of PTE modifications
> tend to fall apart for KVM.  Much of that comes down to mmu_notifiers invalidations
> being an imperfect boundary between the primary MMU and secondary MMUs.  E.g.
> any prot changes (NUMA balancing in particular) can have disastrous impact on KVM
> guests because those changes invalidate secondary MMUs at PMD granularity, and
> effective force KVM to do a remote TLB for every PMD that is affected, whereas
> the primary is able to batch TLB flushes until the entire VMA is processed.
> 
> So yeah, forcing KVM to zap and re-fault SPTEs in order to do page aging would be
> comically slow for KVM guests without a crazy amount of optimization.

Right, so access bits are certainly special. Fortunately, they are not 
as important to get right as dirty bits.

> 
>>> Are there any cases where the primary MMU transfers the PTE dirty bit
>>> to the folio _other_ than zapping (which already has an MMU-notifier
>>> to KVM). If not then there might not be any reason to add a new
>>> notifier. Instead the contract should just be that secondary MMUs must
>>> also transfer their dirty bits to folios in sync (or before) the
>>> primary MMU zaps its PTE.
>>
>> Grepping for pte_mkclean(), there might be some cases. Many cases use MMU
>> notifier, because they either clear the PTE or also remove write
>> permissions.
>>
>> But these is madvise_free_pte_range() and
>> clean_record_shared_mapping_range()...->clean_record_pte(), that might only
>> clear the dirty bit without clearing/changing permissions and consequently
>> not calling MMU notifiers.
> 
> Heh, I was staring at these earlier today.  They all are wrapped with
> mmu_notifier_invalidate_range_{start,end}(), and KVM's hyper aggressive response
> to mmu_notifier invalidations ensure all KVM SPTEs get dropped.
> 
>> Getting a writable PTE without the dirty bit set should be possible.
>>
>> So I am questioning whether having a writable PTE in the secondary MMU with
>> a clean PTE in the primary MMU should be valid to exist. It can exist today,
>> and I am not sure if that's the right approach.
> 
> I came to the same conclusion (that it can exist today).  Without (sane) FOLL_TOUCH,
> KVM could retrieve the new PTE (W=1,D=0) after an mmu_notifier invaliation, and
> thus end up with a writable SPTE that isn't dirty in core MM.
> 
> For MADV_FREE, I don't see how KVM's current behavior of marking the folio dirty
> at zap time changes anything.  Ah, try_to_unmap_one() checks folio_test_dirty()
> *after* invoking mmu_notifier_invalidate_range_start(), which ensures that KVM's
> dirty status is propagated to the folio, and thus try_to_unmap_one() keeps the
> folio.

Right, we have to check if it has been re-dirtied. And any unexpected 
reference (i.e., GUP) could dirty it.

> 
> Aha!  But try_to_unmap_one() also checks that refcount==mapcount+1, i.e. will
> also keep the folio if it has been GUP'd.  And __remove_mapping() explicitly states
> that it needs to play nice with a GUP'd page being marked dirty before the
> reference is dropped.

> 
> 	 * Must be careful with the order of the tests. When someone has
> 	 * a ref to the folio, it may be possible that they dirty it then
> 	 * drop the reference. So if the dirty flag is tested before the
> 	 * refcount here, then the following race may occur:
> 
> So while it's totally possible for KVM to get a W=1,D=0 PTE, if I'm reading the
> code correctly it's safe/legal so long as KVM either (a) marks the folio dirty
> while holding a reference or (b) marks the folio dirty before returning from its
> mmu_notifier_invalidate_range_start() hook, *AND* obviously if KVM drops its
> mappings in response to mmu_notifier_invalidate_range_start().
> 

Yes, I agree that it should work in the context of vmscan. But (b) is 
certainly a bit harder to swallow than "ordinary" (a) :)

As raised, if having a writable SPTE would imply having a writable+dirty 
PTE, then KVM MMU code wouldn't have to worry about syncing any dirty 
bits ever back to core-mm, so patch #2 would not be required. ... well, 
it would be replaces by an MMU notifier that notifies about clearing the 
PTE dirty bit :)

... because, then, there is also a subtle difference between 
folio_set_dirty() and folio_mark_dirty(), and I am still confused about 
the difference and not competent enough to explain the difference ... 
and KVM always does the former, while zapping code of pagecache folios 
does the latter ... hm

Related note: IIRC, we usually expect most anon folios to be dirty.

kvm_set_pfn_dirty()->kvm_set_page_dirty() does an unconditional 
SetPageDirty()->folio_set_dirty(). Doing a test-before-set might 
frequently avoid atomic ops.

>>>> I once had the following idea, but I am not sure about all implications,
>>>> just wanted to raise it because it matches the topic here:
>>>>
>>>> Secondary page tables kind-of behave like "HW" access. If there is a
>>>> write access, we would expect the original PTE to become dirty, not the
>>>> mapped folio.
>>>
>>> Propagating SPTE dirty bits to folios indirectly via the primary MMU
>>> PTEs won't work for guest_memfd where there is no primary MMU PTE. In
>>> order to avoid having two different ways to propagate SPTE dirty bits,
>>> KVM should probably be responsible for updating the folio directly.
>>>
>>
>> But who really cares about access/dirty bits for guest_memfd?
>>
>> guest_memfd already wants to disable/bypass all of core-MM, so different
>> rules are to be expected. This discussion is all about integration with
>> core-MM that relies on correct dirty bits, which does not really apply to
>> guest_memfd.
> 
> +1, this is one of many reasons I don't want to support swap/relcaim for guest_memfd.
> The instant guest_memfd gets involved with anything LRU related, the interactions
> and complexity skyrockets.

Agreed ... but it's unfortunate :/

-- 
Cheers,

David / dhildenb


