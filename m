Return-Path: <kvm+bounces-32925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B92659E1EB0
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 15:08:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79D44283E26
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 14:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 765DD1F4297;
	Tue,  3 Dec 2024 14:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bA82blMl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04C81F4289
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 14:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733234890; cv=none; b=S1v901A6LXCJWpy4KWlz47mgW7hnUDHqmWo1dVYdBjkBmhHEMSq2YlTUv8zPmqPXYXPR4ogpOB2BfW5ZP10TUmcQSrKNw83l2PqQJR3fQ/16v5wOHqbZV0qzfgZFZc8lp6/vVvzuYB8gFTfN8kQvX+pcWqhFHyP3LOD7iB5XjNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733234890; c=relaxed/simple;
	bh=uVRcyVKfRXam3qy/wpCW1/XY6LtZ5ibJPJtWicYVchU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=spLcIKwiBqF3gbKGO2/pOFm1va6X+w3Sz6hmJaKe4ibwPnlK4+pl/mRlgMVKtiGriRtzy0oIYB7mZaQskAbOxU/kCPdva3IU0PyKWVnlBYCPE8bRv50JEvZ2J6m3LPnkssfWF8iO5PNfm6SaUQqrCrHQtmEjEx0DfB8/6YoEQCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bA82blMl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733234887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rQlKhIjktQisMCSLTubj7AX53kolWko2uaY5lKb28A4=;
	b=bA82blMlzeZjlzEmG8l6F33zGRAbY5EyySWmsHAwKLY9RSFwLtNQ7O//Ii2CNI3juy0URv
	Zwx5OTQdLDuqahYj8a0Fr6Zvq5gu7ITo1xwEiBkPEWg5hfgTUPmY01+TF5bv5WKz8cLGvS
	XMM8W5ubIgmuojoYH378tdeLjoP8LrA=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-YsrVvxn_Nf64O3FS9zyCgw-1; Tue, 03 Dec 2024 09:08:06 -0500
X-MC-Unique: YsrVvxn_Nf64O3FS9zyCgw-1
X-Mimecast-MFC-AGG-ID: YsrVvxn_Nf64O3FS9zyCgw
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-53df70e05b7so3878374e87.1
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 06:08:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733234885; x=1733839685;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rQlKhIjktQisMCSLTubj7AX53kolWko2uaY5lKb28A4=;
        b=tN85b2rswzyUNLd2mwzTr2ZmLg2n6+CoP/jfBLX7Snr8hssBJonoz5LSvtQQlf+btN
         LKrKcPgrM64c8Pb6UTJpSoJghwkBuYOzeMXm6iRhgHtkwPfBNthFXDILFwxPRugVTU8D
         n2Y39Z3lrY9BAxTVKSOijKrrQncSyif7Ih+KGXadeS7pFre3EHrck6854qN1/qE9PsSE
         govTSzQX+woAIxTjkAR4TgU7SP4uUTGAPgmqGNWMtDHTkmiczA/3q7hX6H9afoEeqwpn
         Ys/DyybNwPvAgPhIsMjwoqWvP+2YyCgjdJEb+YyZWKPNWkYEZXBVF1sTcpj5j/Bttuj5
         vKKw==
X-Forwarded-Encrypted: i=1; AJvYcCXscI31LpEJ/ayvOIF3XDEkKNGru0v96/+iGjtPY2kirGphZ3bZne7QX1G9jzyYSpTXarw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtO50m2kPeX1vXhjTeUhPZvAx2MM2i28bF7lYv7ZsUeaKnl4VI
	NSMTtK/oYdyvIvGhNAVkj64bPV60fm1uaVfh8KiKIbf7oq6g3DYgyhifD38Bz+Fd9iFFl4frdP4
	mT+9s213vt1IkCjp084FmHA28/en5n5zIQWNsMMjNfOpRsoJ8IPSPLeED8vIu
X-Gm-Gg: ASbGncstxFmeOxA76PjEI0nGwPV+EiUzwjrjcYiJ3nhXQwSOemENJdEfB39GopMDHfK
	o1H/6DyUxEgCYcIVG+Y0ld4x8eIfjE/L9R2r5t8a0V0DHib/nvdWeAWmWK7xodVHoDnlHnDL/RW
	EmcuAsytDoHNP00B2o7H7SIunIekVOmZj5XWvCuK9JT9mG9SQAbUNu/c8EX2pwO14Urso6xSW3B
	GwZQOiVD4pPGMmUiz5C54g/flsoIaZd+AUNw53+awTNH3MWT/jeP6+8OxPjkOsWQRfrRQaAEViR
	8trMcElivZ3VindnqF94E3A9pRqJt8ynVg5nrAeTzfOYeedcBHOz5j4r+1QoGKqS9QQVMUw2Dol
	DgA==
X-Received: by 2002:a05:6512:1384:b0:53d:dcfe:3252 with SMTP id 2adb3069b0e04-53e129ff3abmr1811447e87.23.1733234884504;
        Tue, 03 Dec 2024 06:08:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE0Y6fMLCBrrALi4s1t2Q1RJwq+7dGUtdswkgE0z+RA6PJAIXFweR6z/INeel9u/Z5zwJ5Nwg==
X-Received: by 2002:a05:6512:1384:b0:53d:dcfe:3252 with SMTP id 2adb3069b0e04-53e129ff3abmr1811372e87.23.1733234883877;
        Tue, 03 Dec 2024 06:08:03 -0800 (PST)
Received: from ?IPV6:2003:cb:c746:1b00:fd9e:c26c:c552:1de7? (p200300cbc7461b00fd9ec26cc5521de7.dip0.t-ipconnect.de. [2003:cb:c746:1b00:fd9e:c26c:c552:1de7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-385df9ef1d6sm12403562f8f.102.2024.12.03.06.08.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 06:08:03 -0800 (PST)
Message-ID: <753a033c-7341-4a3a-8546-c31a50d35aff@redhat.com>
Date: Tue, 3 Dec 2024 15:08:00 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/7] hugetlbfs memory HW error fixes
To: William Roche <william.roche@oracle.com>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241125142718.3373203-1-william.roche@oracle.com>
 <48b09647-d2ba-43e5-8e73-16fb4ace6da5@oracle.com>
 <874e2625-b5e7-4247-994a-9b341abbdceb@redhat.com>
 <e09204a4-1570-4d39-afc7-e839a0a492d8@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <e09204a4-1570-4d39-afc7-e839a0a492d8@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 03.12.24 01:15, William Roche wrote:
> On 12/2/24 17:00, David Hildenbrand wrote:
>> On 02.12.24 16:41, William Roche wrote:
>>> Hello David,
>>
>> Hi,
>>
>> sorry for reviewing yet, I was rather sick the last 1.5 weeks.
> 
> I hope you get well soon!

Getting there, thanks! :)

> 
>>> I've finally tested many page mapping possibilities and tried to
>>> identify the error injection reaction on these pages to see if mmap()
>>> can be used to recover the impacted area.
>>> I'm using the latest upstream kernel I have for that:
>>> 6.12.0-rc7.master.20241117.ol9.x86_64
>>> But I also got similar results with a kernel not supporting
>>> MADV_DONTNEED, for example: 5.15.0-301.163.5.2.el9uek.x86_64
>>>
>>>
>>> Let's start with mapping a file without modifying the mapped area:
>>> In this case we should have a clean page cache mapped in the process.
>>> If an error is injected on this page, the kernel doesn't even inform the
>>> process about the error as the page is replaced (no matter if the
>>> mapping was shared of not).
>>>
>>> The kernel indicates this situation with the following messages:
>>>
>>> [10759.371701] Injecting memory failure at pfn 0x10d88e
>>> [10759.374922] Memory failure: 0x10d88e: corrupted page was clean:
>>> dropped without side effects
>>> [10759.377525] Memory failure: 0x10d88e: recovery action for clean LRU
>>> page: Recovered
>>
>> Right. The reason here is that we can simply allocate a new page and
>> load data from disk. No corruption.
>>
>>>
>>>
>>> Now when the page content is modified, in the case of standard page
>>> size, we need to consider a MAP_PRIVATE or MAP_SHARED
>>> - in the case of a MAP_PRIVATE page, this page is corrupted and the
>>> modified data are lost, the kernel will use the SIGBUS mechanism to
>>> inform this process if needed.
>>>      But remapping the area sweeps away the poisoned page, and allows the
>>> process to use the area.
>>>
>>> - In the case of a MAP_SHARED page, if the content hasn't been sync'ed
>>> with the file backend, we also loose the modified data, and the kernel
>>> can also raise SIGBUS.
>>>      Remapping the area recreates a page cache from the "on disk" file
>>> content, clearing the error.
>>
>> In a mmap(MAP_SHARED, fd) region that will also require fallocate IIUC.
> 
> I would have expected the same thing, but what I noticed is that in the
> case of !hugetlb, even poisoned shared memory seem to be recovered with:
> mmap(location, size, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_FIXED, fd, 0)


Let me take a look at your tool below if I can find an explanation of 
what is happening, because it's weird :)

[...]

> 
> At the end of this email, I included the source code of a simplistic
> test case that shows that the page is replaced in the case of standard
> page size.
> 
> The idea of this test is simple:
> 
> 1/ Create a local FILE with:
> # dd if=/dev/zero of=./FILE bs=4k count=2
> 2+0 records in
> 2+0 records out
> 8192 bytes (8.2 kB, 8.0 KiB) copied, 0.000337674 s, 24.3 MB/s
> 
> 2/ As root run:
> # ./poisonedShared4k
> Mapping 8192 bytes from file FILE
> Reading and writing the first 2 pages content:
> Read: Read: Wrote: Initial mem page 0
> Wrote: Initial mem page 1
> Data pages at 0x7f71a19d6000  physically 0x124fb0000
> Data pages at 0x7f71a19d7000  physically 0x128ce4000
> Poisoning 4k at 0x7f71a19d6000
> Signal 7 received
> 	code 4		Signal code
> 	addr 0x7f71a19d6000	Memory location
> 	si_addr_lsb 12
> siglongjmp used
> Remapping the poisoned page
> Reading and writing the first 2 pages content:
> Read: Read: Initial mem page 1
> Wrote: Rewrite mem page 0
> Wrote: Rewrite mem page 1
> Data pages at 0x7f71a19d6000  physically 0x10c367000
> Data pages at 0x7f71a19d7000  physically 0x128ce4000
> 
> 
>    ---
> 
> As we can see, this process:
> - maps the FILE,
> - tries to read and write the beginning of the first 2 pages
> - gives their physical addresses
> - poison the first page with a madvise(MADV_HWPOISON) call
> - shows the SIGBUS signal received and recovers from it
> - simply remaps the same page from the file
> - tries again to read and write the beginning of the first 2 pages
> - gives their physical addresses
> 


Turns out the code will try to truncate the pagecache page using 
mapping->a_ops->error_remove_folio().

That, however, is only implemented on *some* filesystems.

Most prominently, it is not implemented on shmem as well.


So if you run your test with shmem (e.g., /tmp/FILE), it doesn't work.

Using fallocate+MADV_DONTNEED seems to work on shmem.

-- 
Cheers,

David / dhildenb


