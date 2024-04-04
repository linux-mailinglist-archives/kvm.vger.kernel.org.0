Return-Path: <kvm+bounces-13573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEF13898B60
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 17:44:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7EF08B20CC2
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 15:44:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 562F312AAF8;
	Thu,  4 Apr 2024 15:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F9sQt9QK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77CE12AAE4
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 15:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712245466; cv=none; b=l9arBS5aTrZiPy7SOBdGkkvkIVIt39z0vHsnn8a8SCt6Gv0wvYLz54D7EprVQaIi6ySSVAkUzlhCnueijd/A4A9gP03hY8ojknCncrmEqK/WGIUw7CFSR5hvtuOlZyZ3hEpkX1vdNwSfXTuTLpM+M09xNAav6UUom7TrRftW40w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712245466; c=relaxed/simple;
	bh=vUEXAE1ExZO22iPT/l5kPykxw4x6Cg0n7E0NIdHXubk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u0D65s40RJp3cqyI2jUPnPs4kj6iRecjH/qEmrDtUv9a1ocihoTbDG3NsSZDMwkBCOhy6RKlzIdM5lCeQ4XptJ14CrK4nAtPeBNjw0W1eB0BFMNV+V77oxWIn4BZHcSug50BURaD8QiF9/5aNFNNyndn5XESZnl1w+0CZKsI3ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F9sQt9QK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712245462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vSFCbNcwIq07vP682jf5aQYwrzaaEsHEuv2Mm/EFPIc=;
	b=F9sQt9QKMLl/Be3qaqQP8vaECFdDzkj2BEe6HPntESXizsuiF8DB7aNg04Z4gfAFcpiJ/F
	mVh67mdufk/oRVD8FxXWs1qMnPOE+jOG4Gv5VnKQK9CBlxG0Oq5kvdz5YPz8tiLFypXrOX
	QyE02UsxjQYdPsyxNftty9gKAyFk7b4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-55-YMU_zOQZPPOSc1k_sIVmSw-1; Thu, 04 Apr 2024 11:44:21 -0400
X-MC-Unique: YMU_zOQZPPOSc1k_sIVmSw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-343678d2d26so620477f8f.0
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 08:44:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712245460; x=1712850260;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vSFCbNcwIq07vP682jf5aQYwrzaaEsHEuv2Mm/EFPIc=;
        b=G+w8HFcmAG5oh1ULZD8j5bCd9gWv4Jzr6eeVhf8txnlVUD8723D+ChkBH3zqDQS7DM
         kGZJkVh7TBmLKNhRTV/V4DIz4jpnl34HDyjLJkN6+mBuPYzkI5g5SjhgG8+oVmT+9f+/
         d+zveIwvaV41PYr2LgNtpp7221oN4UnAjh2DsV4W+OnqmNR0NghEwvREBIOIxbPYdo+6
         X7EvqegGTdeeVKSVzDywyZMnmuNCgYyTs7ktHaKElVKOCWCOQOK8sbr0/osP9g+YOHHV
         uqC0X7j+S04lny89SWT8MXpoygWNkI7jbhYfhYueM1POi8rVvffyfRmyvEcXVliskHFz
         ma4w==
X-Forwarded-Encrypted: i=1; AJvYcCUGhhNj3jtPlHr8WF2aghi/zFiKusXk4XGbqIxW7IL4sBzpkqhiSaQPuWX+Of/+udjkSTmyIcCAkh2wzX3hg1ey67CN
X-Gm-Message-State: AOJu0YyMHanDPiTZEFkyPBlSgAhKv9/wHVJ9rZ195EZ0JWFtwmKaZz97
	aRxw7BWss0YQwhUsKKdB3/ONnx1VHaFLW5XATxZGzE/uwqhlZhtxdAYUjv5nmerJfJ9OAb30lpW
	zSTegH3nLyMID/RA4fqzFdQmQd2/PrUXeb7xEJOBxjSNMYGbaXw==
X-Received: by 2002:adf:e702:0:b0:343:8022:dd08 with SMTP id c2-20020adfe702000000b003438022dd08mr3103484wrm.0.1712245460459;
        Thu, 04 Apr 2024 08:44:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFN2CJF3oIK4dnV/TEXgxl3MIzYjlSGFX1sv9jk5lJQFvPHeGcLCBfb34ox+kHl6yHVh+2enw==
X-Received: by 2002:adf:e702:0:b0:343:8022:dd08 with SMTP id c2-20020adfe702000000b003438022dd08mr3103464wrm.0.1712245460113;
        Thu, 04 Apr 2024 08:44:20 -0700 (PDT)
Received: from ?IPV6:2003:cb:c743:de00:7030:120f:d1c9:4c3c? (p200300cbc743de007030120fd1c94c3c.dip0.t-ipconnect.de. [2003:cb:c743:de00:7030:120f:d1c9:4c3c])
        by smtp.gmail.com with ESMTPSA id bs26-20020a056000071a00b003439b45ca08sm4625123wrb.17.2024.04.04.08.44.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 08:44:19 -0700 (PDT)
Message-ID: <42dbf562-5eab-4f82-ad77-5ee5b8c79285@redhat.com>
Date: Thu, 4 Apr 2024 17:44:18 +0200
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
 <ca1f320b-dc06-48e0-b4f5-ce860a72f0e2@redhat.com>
 <Zg3V-M3iospVUEDU@google.com>
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAhkBFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAl8Ox4kFCRKpKXgACgkQTd4Q
 9wD/g1oHcA//a6Tj7SBNjFNM1iNhWUo1lxAja0lpSodSnB2g4FCZ4R61SBR4l/psBL73xktp
 rDHrx4aSpwkRP6Epu6mLvhlfjmkRG4OynJ5HG1gfv7RJJfnUdUM1z5kdS8JBrOhMJS2c/gPf
 wv1TGRq2XdMPnfY2o0CxRqpcLkx4vBODvJGl2mQyJF/gPepdDfcT8/PY9BJ7FL6Hrq1gnAo4
 3Iv9qV0JiT2wmZciNyYQhmA1V6dyTRiQ4YAc31zOo2IM+xisPzeSHgw3ONY/XhYvfZ9r7W1l
 pNQdc2G+o4Di9NPFHQQhDw3YTRR1opJaTlRDzxYxzU6ZnUUBghxt9cwUWTpfCktkMZiPSDGd
 KgQBjnweV2jw9UOTxjb4LXqDjmSNkjDdQUOU69jGMUXgihvo4zhYcMX8F5gWdRtMR7DzW/YE
 BgVcyxNkMIXoY1aYj6npHYiNQesQlqjU6azjbH70/SXKM5tNRplgW8TNprMDuntdvV9wNkFs
 9TyM02V5aWxFfI42+aivc4KEw69SE9KXwC7FSf5wXzuTot97N9Phj/Z3+jx443jo2NR34XgF
 89cct7wJMjOF7bBefo0fPPZQuIma0Zym71cP61OP/i11ahNye6HGKfxGCOcs5wW9kRQEk8P9
 M/k2wt3mt/fCQnuP/mWutNPt95w9wSsUyATLmtNrwccz63XOwU0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAHCwXwEGAEIACYCGwwWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCXw7HsgUJEqkpoQAKCRBN3hD3AP+DWrrpD/4qS3dyVRxDcDHIlmguXjC1Q5tZTwNB
 boaBTPHSy/Nksu0eY7x6HfQJ3xajVH32Ms6t1trDQmPx2iP5+7iDsb7OKAb5eOS8h+BEBDeq
 3ecsQDv0fFJOA9ag5O3LLNk+3x3q7e0uo06XMaY7UHS341ozXUUI7wC7iKfoUTv03iO9El5f
 XpNMx/YrIMduZ2+nd9Di7o5+KIwlb2mAB9sTNHdMrXesX8eBL6T9b+MZJk+mZuPxKNVfEQMQ
 a5SxUEADIPQTPNvBewdeI80yeOCrN+Zzwy/Mrx9EPeu59Y5vSJOx/z6OUImD/GhX7Xvkt3kq
 Er5KTrJz3++B6SH9pum9PuoE/k+nntJkNMmQpR4MCBaV/J9gIOPGodDKnjdng+mXliF3Ptu6
 3oxc2RCyGzTlxyMwuc2U5Q7KtUNTdDe8T0uE+9b8BLMVQDDfJjqY0VVqSUwImzTDLX9S4g/8
 kC4HRcclk8hpyhY2jKGluZO0awwTIMgVEzmTyBphDg/Gx7dZU1Xf8HFuE+UZ5UDHDTnwgv7E
 th6RC9+WrhDNspZ9fJjKWRbveQgUFCpe1sa77LAw+XFrKmBHXp9ZVIe90RMe2tRL06BGiRZr
 jPrnvUsUUsjRoRNJjKKA/REq+sAnhkNPPZ/NNMjaZ5b8Tovi8C0tmxiCHaQYqj7G2rgnT0kt
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Zg3V-M3iospVUEDU@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.04.24 00:19, Sean Christopherson wrote:
> On Wed, Apr 03, 2024, David Hildenbrand wrote:
>> On 03.04.24 02:17, Sean Christopherson wrote:
>>> On Tue, Apr 02, 2024, David Hildenbrand wrote:
>>> Aha!  But try_to_unmap_one() also checks that refcount==mapcount+1, i.e. will
>>> also keep the folio if it has been GUP'd.  And __remove_mapping() explicitly states
>>> that it needs to play nice with a GUP'd page being marked dirty before the
>>> reference is dropped.
>>
>>>
>>> 	 * Must be careful with the order of the tests. When someone has
>>> 	 * a ref to the folio, it may be possible that they dirty it then
>>> 	 * drop the reference. So if the dirty flag is tested before the
>>> 	 * refcount here, then the following race may occur:
>>>
>>> So while it's totally possible for KVM to get a W=1,D=0 PTE, if I'm reading the
>>> code correctly it's safe/legal so long as KVM either (a) marks the folio dirty
>>> while holding a reference or (b) marks the folio dirty before returning from its
>>> mmu_notifier_invalidate_range_start() hook, *AND* obviously if KVM drops its
>>> mappings in response to mmu_notifier_invalidate_range_start().
>>>
>>
>> Yes, I agree that it should work in the context of vmscan. But (b) is
>> certainly a bit harder to swallow than "ordinary" (a) :)
> 
> Heh, all the more reason to switch KVM x86 from (b) => (a).

:)

> 
>> As raised, if having a writable SPTE would imply having a writable+dirty
>> PTE, then KVM MMU code wouldn't have to worry about syncing any dirty bits
>> ever back to core-mm, so patch #2 would not be required. ... well, it would
>> be replaces by an MMU notifier that notifies about clearing the PTE dirty
>> bit :)
> 
> Hmm, we essentially already have an mmu_notifier today, since secondary MMUs need
> to be invalidated before consuming dirty status.  Isn't the end result essentially
> a sane FOLL_TOUCH?

Likely. As stated in my first mail, FOLL_TOUCH is a bit of a mess right now.

Having something that makes sure the writable PTE/PMD is dirty (or 
alternatively sets it dirty), paired with MMU notifiers notifying on any 
mkclean would be one option that would leave handling how to handle 
dirtying of folios completely to the core. It would behave just like a 
CPU writing to the page table, which would set the pte dirty.

Of course, if frequent clearing of the dirty PTE/PMD bit would be a 
problem (like we discussed for the accessed bit), that would not be an 
option. But from what I recall, only clearing the PTE/PMD dirty bit is 
rather rare.

I think this GUP / GUP-user setting of folio dirty bits is a bit of a 
mess, but it seems to be working so far, so ... who am I to judge :)

-- 
Cheers,

David / dhildenb


