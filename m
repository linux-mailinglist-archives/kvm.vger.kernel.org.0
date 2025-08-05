Return-Path: <kvm+bounces-53966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 50D6DB1AF98
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 09:47:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ECFD8189DCA5
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 07:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D74E5243956;
	Tue,  5 Aug 2025 07:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DxyG/Idw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59D1235BE8
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 07:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754380047; cv=none; b=SiYtUGb6VPVeN3AefKandO01vkEGfSx8hW1Ti1JKDbF6dq9tu3WztLDBpUgIsAoqJX36YxCZjmZxjZPEogyJhT3gT981jn/JTD2WyPuqk10/hyBWyiS17xJntF7KwmrEw6wMGk22QSfZJD2d4PvMD6zKYnzF1qcDN1M/l9WDpwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754380047; c=relaxed/simple;
	bh=QdoM5jijl3U+bzt98WBSeNJn3NvpJT7uEM7WhHOfV2I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ESXui1vY7phtHRkw9x4P5gTjlZKVbWXT8I1i0gW8Uoqrt6RbzGB/1dBJFrfeq/F4AqzPloDnlW/7Oz3c7KsGPv46beXT6/Afwh2v4HLf5UURevBFSMdIea9uLmxQZwO763Mv6n+o7BCRdCQZCL3pVedH+6mKtbqaNH8ZE/iIJJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DxyG/Idw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754380044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4FVZZvLwQ+yV12DH+flnf1KHJLBs63H0OjRwDryvigc=;
	b=DxyG/IdwHL+yA3StnxDXol0/vwaBq6PDe8Zslby3+hNkbnyVEm6AFc5xfVpKIHaGZYbbXO
	MwNbMxWfEtCkoC5/Kjel+aBN7UfpayhozUsuWzC5ufl7Gg9CJsGtFcI5Znws5RXPRdP8Uo
	C15OenqTNeJLnlliG5y3/OpD9dIx+4o=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-zA1V28o4O5W02UcFrLQOBQ-1; Tue, 05 Aug 2025 03:47:22 -0400
X-MC-Unique: zA1V28o4O5W02UcFrLQOBQ-1
X-Mimecast-MFC-AGG-ID: zA1V28o4O5W02UcFrLQOBQ_1754380041
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-459de0d5fb1so11717775e9.0
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 00:47:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754380041; x=1754984841;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4FVZZvLwQ+yV12DH+flnf1KHJLBs63H0OjRwDryvigc=;
        b=EIEGWpASClU7BRAXckfRRS9S2WJM33CmykUKRjyPXxyl7k9j2kQdmIBW0I0jIbLD9A
         5mD/y5/VTHoGZqm9R38EsrAFIujdj/EvpOs3H/srSUexvyLQFBQRmXxYDzsqMx11H6aM
         ZN41o4H34woJSGfywXDgYMZWG2tJZzoEXZqEN1txuId+yw21Y6RvaMcwfFc5Yhny62HP
         7eff0K8cnyH0a4YLFe11YcKWs9KZCGqIB+2qSmOK3gRP+T21eRaqtfDPqYd6cKFvGWNe
         yD5twVgGRCgVmb9zP2pwtrUXKwaQszw0FtihMj84FSd/lKY9TCuZ30ZW7l+IGdq5YK0F
         HwGg==
X-Gm-Message-State: AOJu0YxOwH5qRSoNk7gpK39pGrHhxh7HXlye0Nd50VCi2MilIVhOKg3q
	d/ki8H9zzQqhCNb2YZm4pAbNh9a3EMrD5ukySe05g/PuZ+kVZAl6UyCR7DNkOzmDKvcdjRCxbju
	YYzIU1kv5JVgBXAH6ohEolY5wge1peBTcJQx/gipklJXpWFo92s7O6Fezu1GOmQ==
X-Gm-Gg: ASbGncsHa6bCeW7gdiWU8L1kww+QTJdL3GK++8cqWfZ7rwWbH+T1FMg9t2wnE/k0gGy
	2kNTojhFV9O6W8Nv27Li1g/z4sqXlNiPLJmGIXvnwxtvZG6NBIa4TYjAMktlcjm8tR1oBcYZn6L
	ev8qHqdHGjC5eDuod1EDLTj5gydMFsnS0uShuKUa45lESmzocA0D1F3FtTMYLjz3rWpqJd0bg+4
	3G1fMXahx1v7/g81ei85EMWS95MbiRjXUDo04cSVL3BLYHAIQAjoMKSEnNaMMHindQBgzY5MlSw
	MN2a/suvI4b2wjSxlhqutsx7uVV3iVTi/nnrT/QB44sjlyg1RugLrZNF/WZMdfQUWb+ZHaK2BZY
	p+TPV6PnwsNeNB51VGqHvtt6gJF9qH7LtK8/CFurU9pm7hZlQPOIazdrmeIU7WgvSIeQ=
X-Received: by 2002:a05:600c:1c12:b0:43c:ec0a:ddfd with SMTP id 5b1f17b1804b1-459e0f02dcbmr17622805e9.6.1754380041269;
        Tue, 05 Aug 2025 00:47:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHN1EeqY4x3j3RAtBvMc8UHTVzni5qYf4SXtqWIha76OhHDzRFGx3XTSbRwyXKYIlqHtsxFQg==
X-Received: by 2002:a05:600c:1c12:b0:43c:ec0a:ddfd with SMTP id 5b1f17b1804b1-459e0f02dcbmr17622545e9.6.1754380040792;
        Tue, 05 Aug 2025 00:47:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:b200:607d:d3d2:3271:1be0? (p200300d82f2bb200607dd3d232711be0.dip0.t-ipconnect.de. [2003:d8:2f2b:b200:607d:d3d2:3271:1be0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e2a28bfasm12176375e9.21.2025.08.05.00.47.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 00:47:20 -0700 (PDT)
Message-ID: <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
Date: Tue, 5 Aug 2025 09:47:18 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
To: Alex Williamson <alex.williamson@redhat.com>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "lizhe.67@bytedance.com" <lizhe.67@bytedance.com>,
 Jason Gunthorpe <jgg@nvidia.com>
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
 <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250804185306.6b048e7c.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.08.25 02:53, Alex Williamson wrote:
> On Mon, 4 Aug 2025 16:55:09 -0700
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> On Mon, 4 Aug 2025 at 15:22, Alex Williamson <alex.williamson@redhat.com> wrote:
>>>
>>> Li Zhe (6):
>>>        mm: introduce num_pages_contiguous()
>>
>> WHY?
>>
>> There is exactly *ONE* user, why the heck do we introduce this
>> completely pointless "helper" function, and put it in a core header
>> file like it was worth it?
> 
> There was discussion here[1] where David Hildenbrand and Jason
> Gunthorpe suggested this should be in common code and I believe there
> was some intent that this would get reused.  I took this as
> endorsement from mm folks.  This can certainly be pulled back into
> subsystem code.

Yeah, we ended up here after trying to go the folio-way first, but then
realizing that code that called GUP shouldn't have to worry about
folios, just to detect consecutive pages+PFNs.

I think this helper will can come in handy even in folio context.
I recall pointing Joanne at it in different fuse context.

> 
>> And it's not like that code is some kind of work of art that we want
>> to expose everybody to *anyway*. It's written in a particularly stupid
>> way that means that it's *way* more expensive than it needs to be.
>>
>> And then it's made "inline" despite the code generation being
>> horrible, which makes it all entirely pointless.
>>
>> Yes, I'm grumpy. This pull request came in late, I'm already
>> traveling, and then I look at it and it just makes me *angry* at how
>> bad that code is, and how annoying it is.
> 
> Sorry, I usually try to get in later during the first week to let the
> dust settle a bit from the bigger subsystems, I guess I'm running a
> little behind this cycle.  We'll get it fixed and I'll resend.  Thanks,
> 
> Alex
> 
>> My builds are already slower than usual because they happen on my
>> laptop while traveling, I do *not* need to see this kind of absolutely
>> disgusting code that does stupid things that make the build even
>> slower.
>>
>> So I refuse to pull this kind of crap.
>>
>> If you insist on making my build slower and exposing these kinds of
>> helper functions, they had better be *good* helper functions.
>>
>> Hint: absolutely nobody cares about "the pages crossed a sparsemem
>> border. If your driver cares about the number of contiguous pages, it
>> might as well say "yeah, they are contiguous, but they are in
>> different sparsemem chunks, so we'll break here too".

The concern is rather false positives, meaning, you want consecutive
PFNs (just like within a folio), but -- because the stars aligned --
you get consecutive "struct page" that do not translate to consecutive PFNs.

So that's why the nth page stuff is not optional in the current
implementation as far as I can tell.

And because that nth_page stuff is so tricky and everyone gets it wrong
all the time, I am actually in favor of having such a helper around. not
buried in some subsystem.

>>
>> And at that point all you care about is 'struct page' being
>> contiguous, instead of doing that disgusting 'nth_page'.

I think stopping when we hit the end of a memory section in case of
!CONFIG_SPARSEMEM_VMEMMAP could be done and documented.

It's just that ... code gets more complicated: we end up really only
optimizing for the unloved child sparsemem withoutCONFIG_SPARSEMEM_VMEMMAP:


diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0d4ee569aa6b6..f080fa5a68d4a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1773,6 +1773,9 @@ static inline unsigned long page_to_section(const struct page *page)
   * the memory model, this can mean that the addresses of the "struct page"s
   * are not contiguous.
   *
+ * On sparsemem configs without CONFIG_SPARSEMEM_VMEMMAP, we will stop once we
+ * hit a memory section boundary.
+ *
   * @pages: an array of page pointers
   * @nr_pages: length of the array
   */
@@ -1781,8 +1784,16 @@ static inline unsigned long num_pages_contiguous(struct page **pages,
  {
         size_t i;
  
+       if (IS_ENABLED(CONFIG_SPARSEMEM) &&
+           !IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP)) {
+               const unsigned long pfn = page_to_pfn(pages[0]);
+
+               nr_pages = min_t(size_t, nr_pages,
+                                PAGES_PER_SECTION - (pfn & PAGES_PER_SECTION));
+       }
+
         for (i = 1; i < nr_pages; i++)
-               if (pages[i] != nth_page(pages[0], i))
+               if (pages[i] != pages[i - 1] + 1)
                         break;
  

Whether that helper should live in mm/utils.c is a valid point the bigger it gets.

>>
>> And then - since there is only *one* single user - you don't put it in
>> the most central header file that EVERYBODY ELSE cares about.
>>
>> And you absolutely don't do it if it generates garbage code for no good reason!

I understand the hate for nth_page in this context.

But I rather hate it *completely* because people get it wrong all of the time.

In any case, enjoy you travel Linus.

-- 
Cheers,

David / dhildenb


