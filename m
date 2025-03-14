Return-Path: <kvm+bounces-41035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D58EA60D60
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 10:33:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 245D319C6574
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 09:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C877D1DDC14;
	Fri, 14 Mar 2025 09:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PWlmhW9N"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C93126BF9
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 09:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741944796; cv=none; b=mg94SkITaqmhhXwGLWi6ErWokIXlLRXZv5WjQ75JO3xRKRNXdj/tP7DHHsxF0dPi1aXTNagRCU4agKNCDbWTjXrszrmODj8XgKdZOO4LqyDx2s0Rd/8mh3vSzUZxIhk4q5uWiHDeW6zxq1FVBLT6LqdcBilL9O/fWeTw8hLzaPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741944796; c=relaxed/simple;
	bh=jRvSQnR5WlpmJDJ5I3vj9NBji+NiyQe734v/9qpFQIA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K33ayyg17p6yhxxdN1F/DkxCdtErEmkkNfL/iTeogsj/nZ4KG4xudmXa3tBA0fOoeICUB2r8+2BGItYQ1fYdY+t2iJc5Yq82sojvrtUKyWoCpl8H8VY/XdbwpTW7Zc9qS1T8E+ARSgBeUX8PKeQXLNjkCZsZnV9doDuju+osMOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PWlmhW9N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741944793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kr+GM52HOX7QpsfoABLNv8i9AtL+eNgSpKohidSEYe8=;
	b=PWlmhW9NDh041NZwIHxG54HCHW6yztcEOo8T8fU0YtQ8brCyjhR5ln3zxWGFGtlpG8ztFK
	8+2i/f3QnKIoJqjjDmKJMamRkW2Q8S884Nb0r13NeBKk2xKU33CrPt9GIu5FvbNkGM87nG
	LAw4CP5Xp+QIEHyePL7eiWpMhV9rbvw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-107-Z42SFHSnPUeb2b8j8fircA-1; Fri, 14 Mar 2025 05:33:11 -0400
X-MC-Unique: Z42SFHSnPUeb2b8j8fircA-1
X-Mimecast-MFC-AGG-ID: Z42SFHSnPUeb2b8j8fircA_1741944791
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43ceb011ea5so10987535e9.2
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 02:33:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741944790; x=1742549590;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kr+GM52HOX7QpsfoABLNv8i9AtL+eNgSpKohidSEYe8=;
        b=FWzPoQ5wb0qL3I9GqhczCHHx9u42O2x9aHRvOfu9z5pl6TpNlzUTCsXRTyLnrl1auI
         hykcMW0IPOAr0PuLCN/5xjOYFb9utLVwgEkHlzN9779LidLjPxD5hYVyFYkoV4ie4QRq
         IHdtaiWwB4B8BGNOKXfc78bLWg+T8vsVOWmiU3ilq6Mn7jpBwmad2oACLhv1piipnUEf
         7Ot20GmBsO2OkOA7Qpog00DJkVe0ouAgNc3qtT9yFlWZUpaXYjjsjJg7zpGlZlyOXRwq
         /KBSd4Y9JEvUVQYRm4Pf248t8W+9BC07YbkL5RRpt+NNz5GUGr9gsP5R3m9mNlrdL2RC
         TRGg==
X-Forwarded-Encrypted: i=1; AJvYcCXSQuzaHvqu0lBza9Fsw04M9ODEUqirwyCrl5xmgprHr3pwnbTT/DiLQmHZybP9qsfdeR8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCNu6HMfk9ZgNZOUtBWnTdOEuxQjK6uBGOSYEfLBDJlzFSw6/1
	LgPqLV+gu/noEeGQrwkOMlfgToMjoVXeceI5txMce/5qo4PDYxEbrlwtogq863wImBPF8+FxS0m
	yiTGZBlQq/Cp57Ur99HvkwrAX+Iu/K1rDYjFcm3r1lGBMygZwOw==
X-Gm-Gg: ASbGncvlnsKxHT58fFvs5+5QYvZK+6OFTIdxKs5RpQe+Z+vvVNNIR6YrPpkdf59p13v
	8c4ysPaa+BIdg26Wy4/R5CCMU1BThIi+2unZ3FfGxrWf/30RvQCYAcUOB3HCh+/ivK5fGHoYCZ+
	c5SvkW0VLHFFg6XK8ujcKkZp1O9sAM5tH200h5Alf6MAVVlK3BJHg0Xzrmkd3dzaaj02e7ehkui
	IxlJHs3f58sHkxnqMVwYKohu/bkbhAJPH1Z1g6MUEduOKRxnCf6yRhC56HFGrKpwUBu8eIGrRlp
	RpQWBo+ntlWpQNncbDjULaPUsUE9FA0avzAR2MvaMGtQtFcjO3Cdo70R9mjri7TL2VOT9jkEhn5
	NkgD49e1g5QEoF2/bMhRCrqKdv61iAJLvaLsE7G5XSGA=
X-Received: by 2002:a05:600c:510c:b0:43a:b8eb:9e5f with SMTP id 5b1f17b1804b1-43d1ec90beamr23184125e9.3.1741944790582;
        Fri, 14 Mar 2025 02:33:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxZxe66PEHA3sRublZ+jKCA2QM/pZrwH4q+h0r2rqv07VI5Vyt2jEI2LSjNPPj9D5cOHGJUg==
X-Received: by 2002:a05:600c:510c:b0:43a:b8eb:9e5f with SMTP id 5b1f17b1804b1-43d1ec90beamr23183865e9.3.1741944790191;
        Fri, 14 Mar 2025 02:33:10 -0700 (PDT)
Received: from ?IPV6:2003:cb:c745:2000:5e9f:9789:2c3b:8b3d? (p200300cbc74520005e9f97892c3b8b3d.dip0.t-ipconnect.de. [2003:cb:c745:2000:5e9f:9789:2c3b:8b3d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d1fe2a2c8sm11664425e9.23.2025.03.14.02.33.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Mar 2025 02:33:08 -0700 (PDT)
Message-ID: <18db10a0-bd40-4c6a-b099-236f4dcaf0cf@redhat.com>
Date: Fri, 14 Mar 2025 10:33:07 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 0/5] KVM: gmem: 2MB THP support and preparedness
 tracking changes
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: "Shah, Amit" <Amit.Shah@amd.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Roth, Michael" <Michael.Roth@amd.com>,
 "liam.merwick@oracle.com" <liam.merwick@oracle.com>,
 "seanjc@google.com" <seanjc@google.com>, "jroedel@suse.de"
 <jroedel@suse.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "Sampat, Pratik Rajesh" <PratikRajesh.Sampat@amd.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, "vbabka@suse.cz"
 <vbabka@suse.cz>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
 "Kalra, Ashish" <Ashish.Kalra@amd.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "vannapurve@google.com" <vannapurve@google.com>
References: <20241212063635.712877-1-michael.roth@amd.com>
 <11280705-bcb1-4a5e-a689-b8a5f8a0a9a6@redhat.com>
 <3bd7936624b11f755608b1c51cc1376ebf2c3a4f.camel@amd.com>
 <6e55db63-debf-41e6-941e-04690024d591@redhat.com>
 <Z9PyLE/LCrSr2jCM@yzhao56-desk.sh.intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Z9PyLE/LCrSr2jCM@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14.03.25 10:09, Yan Zhao wrote:
> On Wed, Jan 22, 2025 at 03:25:29PM +0100, David Hildenbrand wrote:
>> (split is possible if there are no unexpected folio references; private
>> pages cannot be GUP'ed, so it is feasible)
> ...
>>>> Note that I'm not quite sure about the "2MB" interface, should it be
>>>> a
>>>> "PMD-size" interface?
>>>
>>> I think Mike and I touched upon this aspect too - and I may be
>>> misremembering - Mike suggested getting 1M, 2M, and bigger page sizes
>>> in increments -- and then fitting in PMD sizes when we've had enough of
>>> those.  That is to say he didn't want to preclude it, or gate the PMD
>>> work on enabling all sizes first.
>>
>> Starting with 2M is reasonable for now. The real question is how we want to
>> deal with
> Hi David,
> 

Hi!

> I'm just trying to understand the background of in-place conversion.
> 
> Regarding to the two issues you mentioned with THP and non-in-place-conversion,
> I have some questions (still based on starting with 2M):
> 
>> (a) Not being able to allocate a 2M folio reliably
> If we start with fault in private pages from guest_memfd (not in page pool way)
> and shared pages anonymously, is it correct to say that this is only a concern
> when memory is under pressure?

Usually, fragmentation starts being a problem under memory pressure, and 
memory pressure can show up simply because the page cache makes us of as 
much memory as it wants.

As soon as we start allocating a 2 MB page for guest_memfd, to then 
split it up + free only some parts back to the buddy (on private->shared 
conversion), we create fragmentation that cannot get resolved as long as 
the remaining private pages are not freed. A new conversion from 
shared->private on the previously freed parts will allocate other 
unmovable pages (not the freed ones) and make fragmentation worse.

In-place conversion improves that quite a lot, because guest_memfd tself 
will not cause unmovable fragmentation. Of course, under memory 
pressure, when and cannot allocate a 2M page for guest_memfd, it's 
unavoidable. But then, we already had fragmentation (and did not really 
cause any new one).

We discussed in the upstream call, that if guest_memfd (primarily) only 
allocates 2M pages and frees 2M pages, it will not cause fragmentation 
itself, which is pretty nice.

> 
>> (b) Partial discarding
> For shared pages, page migration and folio split are possible for shared THP?

I assume by "shared" you mean "not guest_memfd, but some other memory we 
use as an overlay" -- so no in-place conversion.

Yes, that should be possible as long as nothing else prevents 
migration/split (e.g., longterm pinning)

> 
> For private pages, as you pointed out earlier, if we can ensure there are no
> unexpected folio references for private memory, splitting a private huge folio
> should succeed. 

Yes, and maybe (hopefully) we'll reach a point where private parts will 
not have a refcount at all (initially, frozen refcount, discussed during 
the last upstream call).

Are you concerned about the memory fragmentation after repeated
> partial conversions of private pages to and from shared?

Not only repeated, even just a single partial conversion. But of course, 
repeated partial conversions will make it worse (e.g., never getting a 
private huge page back when there was a partial conversion).

-- 
Cheers,

David / dhildenb


