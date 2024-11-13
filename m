Return-Path: <kvm+bounces-31723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1E659C6DDA
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 12:28:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A17BD28506E
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 11:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 848AC1FF611;
	Wed, 13 Nov 2024 11:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A10VmPMm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D521FF035
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 11:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731497280; cv=none; b=ZUIz+of5YYtXehHn2vvV30wJuLrFY2G42nlfnjS2Ee+HZ3vKgeRmBNopkwNwsSxqG2+9R9l0L/x4CTsrM1rzjxxScgSFourpgvf1C8oyxhFkTKv27xDzT2ZigB1hsltFMmmtqqnx0y7z8U3twEoFU2+5B0U7FI33X4N2i1su+q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731497280; c=relaxed/simple;
	bh=VC+8UdVEnsMth/FIx1dbomAP9wadR6AjGniU48P6j+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G4qJd2i7KLGGHKLc+iqB/zqS4XhcWHB51wt0GXGg+pHBOlzrzProerPyA/Mgdv2DO/WLyRKx3baEQDpV+qqypm1dHBoKc7DX9u4i1zEeVIWDNnxz9wMA5JMuLZsoJvsBTmGdM5Yzm3+EF7qSCbCmwvLdCog9IhAbtimnvEBhG34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A10VmPMm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731497277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jKjCQkphQmFo+ScqcVseRncxjnhuRXf+9pZ1ptYICpU=;
	b=A10VmPMmwiCAI3Vz4ADruc1bZ8TD/tTk0JHAT5vN0Bn4ly3php7AHx0fbNw3KISR0d9aOd
	fdmTN6w/balbaWteygYeV6VxtdgF4TIX93nlxZoDuZwMkmR2GE92grOQgE4B1VCmrDYHJz
	5UuwJbro6hOFwoeAgGOqGml5AnZiWok=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-99-kJgvyxjdPqC1BGVk9loH_w-1; Wed, 13 Nov 2024 06:27:56 -0500
X-MC-Unique: kJgvyxjdPqC1BGVk9loH_w-1
X-Mimecast-MFC-AGG-ID: kJgvyxjdPqC1BGVk9loH_w
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4314f023f55so50402755e9.2
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 03:27:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731497275; x=1732102075;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jKjCQkphQmFo+ScqcVseRncxjnhuRXf+9pZ1ptYICpU=;
        b=trj3Bpjbg+LO/N8HxIJ4/2tEl0Ld4dWR9mYMGMu4sdojX5T6gzZwsm2vkPabpajUvx
         K8j744Ey42QI8EdmlCpf4VKnd6qMw9BBSjcTxCBbT6oBu0AxCML14z89lBmxkYIcbIDA
         JFTxSaqqW8xHaasxqtt2oCR4HmW6Xi6WtNWTwi3RLuNoKF9FVDIkY7+6dpBLX9Pcx9oN
         zUabC6vFz6m3ai36H/+f/Z0ZOeAa+OoVDeCsHsKSpyOcvgO9mZh8aONTcDoGAHhh14LI
         LNaGXLhurXXzdwDkr8ZBPw8Ggd0mPMmutoOwK+GoL4AiVTx6DIGq5e0KEkfZWz03i+P5
         Vohg==
X-Forwarded-Encrypted: i=1; AJvYcCWx1GW3bd7x4yUl2BebKSzYbgefQcHcIThCTmUGsA9B+mO9CUnUvWHPGqZSKBhW/8AueOM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzX2eQxWheUuKgYQmpq0qkhUL4+CHmTC/lpOiVbiB7CWA7PtGqK
	Woigc2oKqMsrJaG1HVb7PSEYgvVjI5Uln+zzaTz0AGvv79SjDrtFM9dQDCKM/Yh+ojcd0/SsQkx
	KrObBtWP7iNzw5h4KLoarGvEdbrR9PL0YvOJPLDSsxbBKNGqfNA==
X-Received: by 2002:a05:600c:35cc:b0:430:5356:ac8e with SMTP id 5b1f17b1804b1-432b74fcb49mr169394575e9.5.1731497274818;
        Wed, 13 Nov 2024 03:27:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGlZiH7H1WOOf1drhTdYK7lR0xwkTBxGft1Ue4jpn4askc7OCbMThxEK0JL9VykUTzfvwV7WA==
X-Received: by 2002:a05:600c:35cc:b0:430:5356:ac8e with SMTP id 5b1f17b1804b1-432b74fcb49mr169394325e9.5.1731497274371;
        Wed, 13 Nov 2024 03:27:54 -0800 (PST)
Received: from ?IPV6:2003:cb:c708:1500:d584:7ad8:d3f7:5539? (p200300cbc7081500d5847ad8d3f75539.dip0.t-ipconnect.de. [2003:cb:c708:1500:d584:7ad8:d3f7:5539])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432d55520e5sm20682465e9.41.2024.11.13.03.27.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2024 03:27:53 -0800 (PST)
Message-ID: <9e5e9bc1-dfd9-490a-bbcd-044d2971df5f@redhat.com>
Date: Wed, 13 Nov 2024 12:27:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 00/10] mm: Introduce and use folio_owner_ops
To: Matthew Wilcox <willy@infradead.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Fuad Tabba <tabba@google.com>,
 linux-mm@kvack.org, kvm@vger.kernel.org, nouveau@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, rppt@kernel.org, jglisse@redhat.com,
 akpm@linux-foundation.org, muchun.song@linux.dev, simona@ffwll.ch,
 airlied@gmail.com, pbonzini@redhat.com, seanjc@google.com,
 jhubbard@nvidia.com, ackerleytng@google.com, vannapurve@google.com,
 mail@maciej.szmigiero.name, kirill.shutemov@linux.intel.com,
 quic_eberman@quicinc.com, maz@kernel.org, will@kernel.org,
 qperret@google.com, keirf@google.com, roypat@amazon.co.uk
References: <20241108162040.159038-1-tabba@google.com>
 <20241108170501.GI539304@nvidia.com>
 <9dc212ac-c4c3-40f2-9feb-a8bcf71a1246@redhat.com>
 <CA+EHjTy3kNdg7pfN9HufgibE7qY1S+WdMZfRFRiF5sHtMzo64w@mail.gmail.com>
 <ZzLnFh1_4yYao_Yz@casper.infradead.org>
 <e82d7a46-8749-429c-82fa-0c996c858f4a@redhat.com>
 <20241112135348.GA28228@nvidia.com>
 <430b6a38-facf-4127-b1ef-5cfe7c495d63@redhat.com>
 <ZzQxuAiJLbqm5xGO@casper.infradead.org>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ZzQxuAiJLbqm5xGO@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13.11.24 05:57, Matthew Wilcox wrote:
> On Tue, Nov 12, 2024 at 03:22:46PM +0100, David Hildenbrand wrote:
>> On 12.11.24 14:53, Jason Gunthorpe wrote:
>>> On Tue, Nov 12, 2024 at 10:10:06AM +0100, David Hildenbrand wrote:
>>>> On 12.11.24 06:26, Matthew Wilcox wrote:
>>>>> I don't want you to respin.  I think this is a bad idea.
>>>>
>>>> I'm hoping you'll find some more time to explain what exactly you don't
>>>> like, because this series only refactors what we already have.
>>>>
>>>> I enjoy seeing the special casing (especially hugetlb) gone from mm/swap.c.
> 
> I don't.  The list of 'if's is better than the indirect function call.
> That's terribly expensive, and the way we reuse the lru.next field
> is fragile.  Not to mention that it introduces a new thing for the
> hardening people to fret over.

Right, indirect calls are nasty and probably more fragile/insecure, but this is
really what ZONE_DEVICE is already using internally ... but I agree that is
less desirable to abstract that.

[...]

>> We'll need some reliable way to identify these folios that need care.
>> guest_memfd will be using folio->mapcount for now, so for now we couldn't
>> set a page type like hugetlb does.
> 
> If hugetlb can set lru.next at a certain point, then guestmemfd could
> set a page type at a similar point, no?

The main problem is that we will have to set it on small folios that can be
mapped to user space. As long as mapcount overlays page_type, that's
... not going to work.

We won't be truncating+freeing the folio as long as it is mapped to user space,
though. So one workaround would be to set the page type only as long as it
isn't mapped to user space.

Won't win a beauty price, but could be one workaround until we decoupled
the type from the mapcount.

[...]

> 
>> guest_memfd and hugetlb would be operating on folios (at least for now),
>> which contain the refcount,lru,private, ... so nothing special there.
>>
>> Once we actually decoupled "struct folio" from "struct page", we *might*
>> have to play less tricks, because we could just have a callback pointer
>> there. But well, maybe we also want to save some space in there.
>>
>> Do we want dedicated memdescs for hugetlb/guest_memfd that extend folios in
>> the future? I don't know, maybe.
> 
> I've certainly considered going so far as a per-fs folio.  So we'd
> have an ext4_folio, an btrfs_folio, an iomap_folio, etc.  That'd let us
> get rid of folio->private, but I'm not sure that C's type system can
> really handle this nicely.  Maybe in a Rust world ;-)

:)

> 
> What I'm thinking about is that I'd really like to be able to declare
> that all the functions in ext4_aops only accept pointers to ext4_folio,
> so ext4_dirty_folio() can't be called with pointers to _any_ folio,
> but specifically folios which were previously allocated for ext4.

Yes, that sounds reasonable. hugetlb definetly might be another such candidate.

> 
> I don't know if Rust lets you do something like that.
> 
>> I'm currently wondering if we can use folio->private for the time being.
>> Either
>>
>> (a) If folio->private is still set once the refcount drops to 0, it
>> indicates that there is a freeing callback/owner_ops. We'll have to make
>> hugetlb not use folio->private and convert others to clear folio->private
>> before freeing.
>>
>> (b) Use bitX of folio->private to indicate that this has "owner_ops"
>> meaning. We'll have to make hugetlb not use folio->private and make others
>> not use bitX. Might be harder and overkill, because right now we only really
>> need the callback when refcount==0.
>>
>> (c) Use some other indication that folio->private contains folio_ops.
> 
> I really don't want to use folio_ops / folio_owner_ops.

Yes, and I understand your reasoning. It was one approach to work around
the page_type vs. mapcount issue and avoiding more checks on the freeing path.

If we manage to make the page type fly, the following could work and leave
the ordinary folio freeing path as fast as before (and allow me to add the
PGTY_offline handling :) ):

 From 5a55e4bcf4d6cfa64d3383a7cf6649042cedcecb Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Wed, 13 Nov 2024 12:20:58 +0100
Subject: [PATCH] tmp

Signed-off-by: David Hildenbrand <david@redhat.com>
---
  include/linux/page-flags.h | 11 +++++++++++
  mm/swap.c                  | 27 ++++++++++++++++++++++-----
  2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index e80665bc51fac..ebf89075eeb5f 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -950,6 +950,7 @@ enum pagetype {
  	PGTY_slab	= 0xf5,
  	PGTY_zsmalloc	= 0xf6,
  	PGTY_unaccepted	= 0xf7,
+	PGTY_guestmem	= 0xf8,
  
  	PGTY_mapcount_underflow = 0xff
  };
@@ -970,6 +971,16 @@ static inline bool page_has_type(const struct page *page)
  	return page_mapcount_is_type(data_race(page->page_type));
  }
  
+static inline bool folio_has_type(const struct folio *folio)
+{
+	return page_has_type(&folio->page);
+}
+
+static inline int folio_get_type(const struct folio *folio)
+{
+	return folio->page.page_type >> 24;
+}
+
  #define FOLIO_TYPE_OPS(lname, fname)					\
  static __always_inline bool folio_test_##fname(const struct folio *folio) \
  {									\
diff --git a/mm/swap.c b/mm/swap.c
index 10decd9dffa17..bf4efc7bba18a 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -94,6 +94,22 @@ static void page_cache_release(struct folio *folio)
  		unlock_page_lruvec_irqrestore(lruvec, flags);
  }
  
+static void free_typed_folio(struct folio *folio)
+{
+	switch (folio_get_type(folio)) {
+	case PGTY_hugetlb:
+		free_huge_folio(folio);
+		return;
+	case PGTY_offline:
+		/* Nothing to do, it's offline. */
+		return;
+	case PGTY_guestmem:
+		// free_guestmem_folio(folio);
+	default:
+		WARN_ON_ONCE(1);
+	}
+}
+
  void __folio_put(struct folio *folio)
  {
  	if (unlikely(folio_is_zone_device(folio))) {
@@ -101,8 +117,8 @@ void __folio_put(struct folio *folio)
  		return;
  	}
  
-	if (folio_test_hugetlb(folio)) {
-		free_huge_folio(folio);
+	if (unlikely(folio_has_type(folio))) {
+		free_typed_folio(folio);
  		return;
  	}
  
@@ -934,15 +950,16 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
  		if (!folio_ref_sub_and_test(folio, nr_refs))
  			continue;
  
-		/* hugetlb has its own memcg */
-		if (folio_test_hugetlb(folio)) {
+		if (unlikely(folio_has_type(folio))) {
+			/* typed folios have their own memcg, if any */
  			if (lruvec) {
  				unlock_page_lruvec_irqrestore(lruvec, flags);
  				lruvec = NULL;
  			}
-			free_huge_folio(folio);
+			free_typed_folio(folio);
  			continue;
  		}
+
  		folio_unqueue_deferred_split(folio);
  		__page_cache_release(folio, &lruvec, &flags);
  
-- 
2.47.0



I read
> https://lore.kernel.org/all/CAGtprH_JP2w-4rq02h_Ugvq5KuHX7TUvegOS7xUs_iy5hriE7g@mail.gmail.com/
> and I still don't understand what you're trying to do.

It's a bunch of related issues (e.g., one idea is also having another "global" pool
of large pages that are not owned by hugetlb), but the biggest thing we want to sort
out is the following:

We allocated a large folio from somewhere (hugetlb, another global pool). We might
have to split this folio internally in some cases (for example, because we need
precise per-page refcounts/mapcounts) and we:

(a) Really have to return the whole re-collapsed folio to the original allocator.

(b) Might have to clean up some stuff (e.g., restore original page type) before handing
the folio back to the original allocator.

(c) Want to re-collapse (parts of?) the folio when we don't need the split anymore.


Re-collapsing is one problem because of possible GUP pins (for parts that were
exposed to user space) and speculative references.

As an example during (a): we might have truncated the whole split thing, but some
reference on a split folio prevents us from re-collapsing the whole thing
synchronously during truncation. As soon as that last reference is put,
we can collapse the thing and return it to the original allocator.

Similar during (c), just that we want to "freeze" all refcounts as the last
references are put, so we can just collapse it once we are notified that
it is now possible -- and that no other speculative references can show up as
the refcount is 0.

> 
> Would it work to use aops->free_folio() to notify you when the folio is
> being removed from the address space?

We really have to know when the last reference is gone, and intercept that
to cleanup and prepare the large folio to go back to its original allocator.

As always, thanks for taking your time and the detailed response Willy!

-- 
Cheers,

David / dhildenb


