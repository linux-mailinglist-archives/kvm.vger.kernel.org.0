Return-Path: <kvm+bounces-20079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2957910758
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:03:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFA821C20CB7
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 14:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D2791B013F;
	Thu, 20 Jun 2024 14:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iVSkomcz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0721F1AD4B9
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 14:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718892081; cv=none; b=E69+oFyUi1cRZYVJSdOqLvU/OFuxlOapwjyuSN+PXJCVUWwPVYi5wY0J1beCiwocQDlubcBua9L9z9mSadpSB8rEWcuOn645AThjuCinwiEjjTEDqJLoekHuXIgpL/YSb5y0jwrPcMeg2yAVGA0wvJsDFx6c4fqTq754hDYLOU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718892081; c=relaxed/simple;
	bh=vb/tyqWoN1MW5NlK+ZcXRUCc87YzAWuAsmCMis8FO90=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C9Vf+2qNtQ/KURIcO/KGSFNWit44A0Dtjpe04Cp2m0PjTwKyWEvwqmvz5b1L+B01zFSPEoXEDes26/OsPHs1VEf6VtH17twihz0kmbKhkBxPOGbgaa58xw7jEPNuGHF0KzLGVdAd68XL5O2Iod14SUdIWLT+KS30gZBi/Y9YwoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iVSkomcz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718892078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=H+/uFiCGrKYOr8f3Xm2xUT28S49p5SQ4fyxld7R6VYc=;
	b=iVSkomczGXpTbAuazRWBy71pJYePNpqMq4IvQ2+BhLqajY1cXo/AhRd1VK0horkjjXrhUd
	8tRDkOFuyhLCjkgjRujxKAx5oNJQtiyxT2m0/utMO0ahKd+DKceY10v0B5Ng37iJNVjUG7
	1o8M8xInsw68vqhPOhFrxuWyDuz1Gao=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-irBuIlgEMBSLFkbipx5UvA-1; Thu, 20 Jun 2024 10:01:17 -0400
X-MC-Unique: irBuIlgEMBSLFkbipx5UvA-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-52c983f4285so765005e87.2
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 07:01:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718892072; x=1719496872;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=H+/uFiCGrKYOr8f3Xm2xUT28S49p5SQ4fyxld7R6VYc=;
        b=HZqAxUrGthmpfaUCHuCzyZduLSk1KQX74KsQu0m7fN6iFBsa6uLHv7LawUpwmK4t2K
         v/ijnBIXgLnplkwWvMl6fmOBdZjXd+hmL1rraXxdPXLFBQ0vKCsFxZH3ql64AwpZazbN
         R6nphHLNjaDELh0FfQrvqSpvnE8iYXXDvtf55abetTxXMIjZcI8d/4Ph4WZmFwrJ9ESq
         JjDdwZKNHTYXLfDWx+bQkV7viHrLm0e0X2oi83g0iSNyOrYoXrnRo/7gs5P8CWbZBkpL
         gfN7Zb6cXlQ5uhJUtZGr+eotiYA7OfZW6TDO7RXWG2IGjjc7nO4blO8WYnerXleNgJXn
         5HRA==
X-Forwarded-Encrypted: i=1; AJvYcCXmOrrZ50kh21c4UNrdSaaCwaWdzX/6OAidOKANavxCyBclmFRztBn4gKMLb/PNH1e5qoerv4ekldhcJI6Um9ohxG35
X-Gm-Message-State: AOJu0Yz0EZV6HDAFbBtYXpsLD6qfmxOlHfFx5wGK30FCUsDnV8vUlZl0
	SA8WqVYTyU6l2L/3RwsDzzdVWET5TE+FsKk788VCH/KNnn/Ig9AaLEz9BpuGXuXtVrHOX7mKdIr
	ZvFUAaVj3cFXpP//5O4GOGxrypD8jNKMyDRODFICu5pLQjjq8vQ==
X-Received: by 2002:a05:6512:348c:b0:52c:8c5b:b7d8 with SMTP id 2adb3069b0e04-52ccaa60842mr3095388e87.30.1718892072245;
        Thu, 20 Jun 2024 07:01:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJYjbE9xh8gzOPded+ami9ji3Kn9OHGGwuOWKeuzEOUKBoz3fjdadzXWT0QtMsnTT8F0tbiA==
X-Received: by 2002:a05:6512:348c:b0:52c:8c5b:b7d8 with SMTP id 2adb3069b0e04-52ccaa60842mr3095368e87.30.1718892071716;
        Thu, 20 Jun 2024 07:01:11 -0700 (PDT)
Received: from ?IPV6:2003:cb:c719:5b00:61af:900f:3aef:3af3? (p200300cbc7195b0061af900f3aef3af3.dip0.t-ipconnect.de. [2003:cb:c719:5b00:61af:900f:3aef:3af3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4247d212254sm26724175e9.45.2024.06.20.07.01.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jun 2024 07:01:11 -0700 (PDT)
Message-ID: <6d7b180a-9f80-43a4-a4cc-fd79a45d7571@redhat.com>
Date: Thu, 20 Jun 2024 16:01:08 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/5] mm/gup: Introduce exclusive GUP pinning
To: Jason Gunthorpe <jgg@nvidia.com>, Fuad Tabba <tabba@google.com>
Cc: Christoph Hellwig <hch@infradead.org>, John Hubbard
 <jhubbard@nvidia.com>, Elliot Berman <quic_eberman@quicinc.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, maz@kernel.org, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 pbonzini@redhat.com
References: <20240618-exclusive-gup-v1-0-30472a19c5d1@quicinc.com>
 <7fb8cc2c-916a-43e1-9edf-23ed35e42f51@nvidia.com>
 <14bd145a-039f-4fb9-8598-384d6a051737@redhat.com>
 <CA+EHjTxWWEHfjZ9LJqZy+VCk43qd3SMKiPF7uvAwmDdPeVhrvQ@mail.gmail.com>
 <20240619115135.GE2494510@nvidia.com> <ZnOsAEV3GycCcqSX@infradead.org>
 <CA+EHjTxaCxibvGOMPk9Oj5TfQV3J3ZLwXk83oVHuwf8H0Q47sA@mail.gmail.com>
 <20240620135540.GG2494510@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240620135540.GG2494510@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 20.06.24 15:55, Jason Gunthorpe wrote:
> On Thu, Jun 20, 2024 at 09:32:11AM +0100, Fuad Tabba wrote:
>> Hi,
>>
>> On Thu, Jun 20, 2024 at 5:11 AM Christoph Hellwig <hch@infradead.org> wrote:
>>>
>>> On Wed, Jun 19, 2024 at 08:51:35AM -0300, Jason Gunthorpe wrote:
>>>> If you can't agree with the guest_memfd people on how to get there
>>>> then maybe you need a guest_memfd2 for this slightly different special
>>>> stuff instead of intruding on the core mm so much. (though that would
>>>> be sad)
>>>
>>> Or we're just not going to support it at all.  It's not like supporting
>>> this weird usage model is a must-have for Linux to start with.
>>
>> Sorry, but could you please clarify to me what usage model you're
>> referring to exactly, and why you think it's weird? It's just that we
>> have covered a few things in this thread, and to me it's not clear if
>> you're referring to protected VMs sharing memory, or being able to
>> (conditionally) map a VM's memory that's backed by guest_memfd(), or
>> if it's the Exclusive pin.
> 
> Personally I think mapping memory under guest_memfd is pretty weird.
> 
> I don't really understand why you end up with something different than
> normal CC. Normal CC has memory that the VMM can access and memory it
> cannot access. guest_memory is supposed to hold the memory the VMM cannot
> reach, right?
> 
> So how does normal CC handle memory switching between private and
> shared and why doesn't that work for pKVM? I think the normal CC path
> effectively discards the memory content on these switches and is
> slow. Are you trying to make the switch content preserving and faster?
> 
> If yes, why? What is wrong with the normal CC model of slow and
> non-preserving shared memory?

I'll leave the !huge page part to Fuad.

Regarding huge pages: assume the huge page (e.g., 1 GiB hugetlb) is 
shared, now the VM requests to make one subpage private. How to handle 
that without eventually running into a double memory-allocation? (in the 
worst case, allocating a 1GiB huge page for shared and for private memory).

In the world of RT, you want your VM to be consistently backed by 
huge/gigantic mappings, not some weird mixture -- so I've been told by 
our RT team.

(there are more issues with huge pages in the style hugetlb, where we 
actually want to preallocate all pages and not rely on dynamic 
allocation at runtime when we convert back and forth between shared and 
private)

-- 
Cheers,

David / dhildenb


