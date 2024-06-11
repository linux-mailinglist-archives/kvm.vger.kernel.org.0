Return-Path: <kvm+bounces-19332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F2255903FC5
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 17:10:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 718181F26B73
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 15:10:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5C6F2110F;
	Tue, 11 Jun 2024 15:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hp2paLtp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758DB2628D
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 15:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718118648; cv=none; b=i/g3RC4qCO0MPv+SlGNm0GmY9uo46MnkTE7XSX8oz5gZuE/9kbooOdwzQWJPDXii08P1MbI9i1ZK/lZ4lNzMApwZPFWCQtJ5f5LR/4aV8Kl3uadEn0dfiERVzbzIHRP0MgSJYOSMyRlTSJVd2aszOX2lOsHpN+qQ8Vi7OB/6dY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718118648; c=relaxed/simple;
	bh=briBpK83cDGPp7/CKKBn6E63aO3fFCh3IZvqZzqE4OM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DJyPCN1i4YNx2Vl/mPj5/s6duTd1XdddtSUHYSW+j6QI5B15cx4BnyyTMJCF3X8Awjw7Sebj/E0V7KHetxzXhXqDmQOeeXDswjdws0HxBzlmjeYk6mPWwhkWpimJtfPz0BTcLZ+26TWFvAAFYyaQxi6kfjDi2pvcVi3sUzFKiB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hp2paLtp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718118646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4vdM7TamML/kX4VK5+rE3ksUPBMgTbRQXL+B9FDVFAs=;
	b=Hp2paLtpyOgJOpcYFYMmijM7SNoR79tgkCgc1WrKPlmsRITTL/PCBzWd14/+bYSsNEtL3B
	ATf0KUjgfl0UjGjDHB9sVWRv5Di1B5RqwpF/yFOq70HNsnRtThEoxhJFg5wj20ZHQ3ItCR
	9b9W3Eopky3zaM9KpmNCvpnPoxglDQs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-peVQHfQZOTqgSmMU55y4cw-1; Tue, 11 Jun 2024 11:10:44 -0400
X-MC-Unique: peVQHfQZOTqgSmMU55y4cw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-421f43ddc2aso13850015e9.1
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 08:10:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718118643; x=1718723443;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4vdM7TamML/kX4VK5+rE3ksUPBMgTbRQXL+B9FDVFAs=;
        b=ubO24+p6iDL7dakNc1vN1r3zNPYfIn54XZ0YbdAKXgszSpl2E2WQBYbKZKSo237r+f
         cKrRlQX5y9B8O4WeVeGJm4mSatjEKVmX/1rKekknYZJSQmwO7RKIXgJs1e+gS8l0oLxC
         7icq6wE3MzRGhkvBOnaM04FljxNtqbRPd7BgYpXSawQTzKgLAetWf4Rsn5yOBt1AeW+D
         Iar83ND/pnxZkpCA68sLKO6qKvjrChu/XPElBTl+9uyU8Is+l79b4+s9bR44nqVha51I
         DYneRX+qIsk279Ef1UPqI3gY0FIvz5DRY64RsKqH5I52KcMkXHsKuqstRl1K6YK/5IhW
         7U/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXl7dDq28Kl8JIKKFrUbMXXL8HAY+32ZcWN1Wh1bFUHquhOuXLt3znwbANfxJ84B9UtpqO7I6+bgdDy2bM+npCNmwKC
X-Gm-Message-State: AOJu0YyL1Aa3hpgjWI2P+kEXBnJRT9zeK3MyfCqbYaSLofKnleqLuZ08
	2b0kSlY45zxA99h0CoHvGbmd2RBA0YSni7qtZiysWcR9qvLL24pzWXx4V3YSYCYxakQTVL1xIsB
	vRXTvsLW15xN/TOsy/i9oYnpyDiC68abxCVUvHu3Wq/WjlJFlQg==
X-Received: by 2002:a05:600c:1e16:b0:418:c2af:ab83 with SMTP id 5b1f17b1804b1-42164a4deadmr109221135e9.36.1718118642725;
        Tue, 11 Jun 2024 08:10:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+vuPs87Vn6YkMZLYM0+8+aIz9Dp/EsB0J5TZgJ4aICLMtEzQoNtuhITD+34Ng/NE0wnofjw==
X-Received: by 2002:a05:600c:1e16:b0:418:c2af:ab83 with SMTP id 5b1f17b1804b1-42164a4deadmr109220865e9.36.1718118642269;
        Tue, 11 Jun 2024 08:10:42 -0700 (PDT)
Received: from ?IPV6:2003:cb:c748:ba00:1c00:48ea:7b5a:c12b? (p200300cbc748ba001c0048ea7b5ac12b.dip0.t-ipconnect.de. [2003:cb:c748:ba00:1c00:48ea:7b5a:c12b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42158149008sm214019245e9.29.2024.06.11.08.10.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jun 2024 08:10:41 -0700 (PDT)
Message-ID: <89c74380-6a60-4091-ba57-93c75d9a37d7@redhat.com>
Date: Tue, 11 Jun 2024 17:10:40 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] s390/pci: Fix s390_mmio_read/write syscall page
 fault handling
To: Niklas Schnelle <schnelle@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Gerd Bayer <gbayer@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <20240529-vfio_pci_mmap-v3-0-cd217d019218@linux.ibm.com>
 <20240529-vfio_pci_mmap-v3-1-cd217d019218@linux.ibm.com>
 <98de56b1ba37f51639b9a2c15a745e19a45961a0.camel@linux.ibm.com>
 <30ecb17b7a3414aeb605c51f003582c7f2cf6444.camel@linux.ibm.com>
 <db10735e74d5a89aed73ad3268e0be40394efc31.camel@linux.ibm.com>
 <ce7b9655-aaeb-4a13-a3ac-bd4a70bbd173@redhat.com>
 <32b515269a31e177779f4d2d4fe2c05660beccc4.camel@linux.ibm.com>
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <32b515269a31e177779f4d2d4fe2c05660beccc4.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>>
>> which checks mmap_assert_write_locked().
>>
>> Setting VMA flags would be racy with the mmap lock in read mode.
>>
>>
>> remap_pfn_range() documents: "this is only safe if the mm semaphore is
>> held when called." which doesn't spell out if it needs to be held in
>> write mode (which I think it does) :)
> 
> Logically this makes sense to me. At the same time it looks like
> fixup_user_fault() expects the caller to only hold mmap_read_lock() as
> I do here. In there it even retakes mmap_read_lock(). But then wouldn't
> any fault handling by its nature need to hold the write lock?

Well, if you're calling remap_pfn_range() right now the expectation is 
that we hold it in write mode. :)

Staring at some random users, they all call it from mmap(), where you 
hold the mmap lock in write mode.


I wonder why we are not seeing that splat with vfio all of the time?

That mmap lock check was added "recently". In 1c71222e5f23 we started 
using vm_flags_set(). That (including the mmap_assert_write_locked()) 
check was added via bc292ab00f6c almost 1.5 years ago.

Maybe vfio is a bit special and was never really run with lockdep?

> 
>>
>>
>> My best guess is: if you are using remap_pfn_range() from a fault
>> handler (not during mmap time) you are doing something wrong, that's why
>> you get that report.
> 
> @Alex: I guess so far the vfio_pci_mmap_fault() handler is only ever
> triggered by "normal"/"actual" page faults where this isn't a problem?
> Or could it be a problem there too?
> 

I think we should see it there as well, unless I am missing something.

>>
>> vmf_insert_pfn() and friends might be better alternatives, that make
>> sure that the VMA already received the proper VMA flags at mmap time.
>>


There would be ways of silencing that check: for example, making sure at 
mmap time that these flags are already set, and skipping modifications 
if the flags are already set.

But, we'll run into more similar checks in x86 VM_PAT code, where we 
would do vm_flags_set(vma, VM_PAT) from track_pfn_remap. Some of that 
code really doesn't want to be called concurrently (e.g., "vma->vm_pgoff 
= pfn;").

I thought that we silenced some of these warnings in the past using 
__vm_flags_mod(). But it sounds hacky.

CCing Sureen.

-- 
Cheers,

David / dhildenb


