Return-Path: <kvm+bounces-10620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FEB586DFB9
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 11:57:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 936021C224AE
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 10:57:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A39F6BFC9;
	Fri,  1 Mar 2024 10:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IjJspZR6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF526313B
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 10:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709290644; cv=none; b=RR2pBLoMdywEmXwsOlnnguT5Kb904eHC3MXNLy52x8CK8sHOfns04T4x8KvNOSFSmFtt6ZLPm6hYb7QsHDMcwZ8YDpEO8Gy5TC6H+P5hIvAXpSnRceixfHbBWyAX6HupYFiBxv+pFhJaDisw+hZzQuv0GZg9tort0GKfxczzXtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709290644; c=relaxed/simple;
	bh=rRd8uWwX/b7Jpv8ssx2B4Vqm0Ikga5riTA/kuvfXqt8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o7e2YAXvUGKXbsIpl+EZ99eydO4AHrKztBo0VYBNJkyQLKPUO1eq9rVXX/sV8s451KdB5W1InKkPiyn6mLx+YYtRqhJym3cX3TjTm5F2vs2w6I94+omSY2eY/DGvFz0vi7eJHPe57LvonRbKHZ3GJ/J1jl8lYW3wFCcRf/+oj/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IjJspZR6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709290641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dP5AIMOMk0h8z/W7wIEWvlucRYlBl59bb3JXCokMLMI=;
	b=IjJspZR6oEt46EybH9488vxZqKtU56PaIcbPhPY6TilRJ5tSmNx0bsfiDMt76CxKS8pA4X
	xjeX8bOpNJfoBuYTtkWF4MxEo4YsN2CVD1PAIMbVoAZPb6uzXjPjUfoZmYLrKPSEyRF4tt
	nVeH10JSKLia7Nw5Jwf3nd8jxb/yyfg=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-KXHYsMqOPpqKlyton77KHg-1; Fri, 01 Mar 2024 05:57:20 -0500
X-MC-Unique: KXHYsMqOPpqKlyton77KHg-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2d309ea6d84so10817111fa.1
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 02:57:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709290639; x=1709895439;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dP5AIMOMk0h8z/W7wIEWvlucRYlBl59bb3JXCokMLMI=;
        b=K2ZL86+TJehunMrC7fBlhlAkm+GikkdFq/xa+TEsraZfq19Qc1a3Y6c83aeASAy/F/
         4MFRsYzoEZ/2+dGPJUl9hAvGZUMu6PerG2WnxYvC5pnbbO0RQ0Ox36pNN37Xv39QOHUa
         JvkgyTeRrNXHwFQgOn+CpW+BWBFGNTWyVV/d0+zacJmG0/sFxDa2ReChJ0Z9V7qqm6Vw
         xjguoOXPjQAvjfKC67DAAZxGzmlTUCOF+SfnmBjVql6j2KDgTneBIyGelbw7k9rd03Pl
         gMAoDrbYEGGCzslUHzfLXMp3+4xirp1Z9IusOlF8+qk6K9H3f3z6gwIqvwk+9qylb8HV
         DxUg==
X-Forwarded-Encrypted: i=1; AJvYcCUpY2ubaraNIMwmxGuKFBIvAsVwJb+gpTQj/xk0UzkSMRjuUz2niB0K6FxGgn4vSlifxhelwwWHpqkKI6BRc+WmSwI4
X-Gm-Message-State: AOJu0YwJbZ4XUbtIzrCLgaFww8YVURvuoLe4rzOmrM29gNt2wa88EupP
	7afPTYDYiZyUQEi++h484FvidkItqdFIZtmxQJNNIB6ixXyHMEREhah80GSq9HH45IkmGjAsyK6
	lDtWBOsCukaFMACL0x02hxQAqISnTTaZOwgAtAgEvrMSlRTarsA==
X-Received: by 2002:a05:651c:3c2:b0:2d2:eb57:3ac8 with SMTP id f2-20020a05651c03c200b002d2eb573ac8mr749883ljp.34.1709290638920;
        Fri, 01 Mar 2024 02:57:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEzT0D2jIJHklDubgIiJtWZUt6TSaFZFaFsjIhHJHFwapKmha9BlJFym0nzngluJJehFQUG6Q==
X-Received: by 2002:a05:651c:3c2:b0:2d2:eb57:3ac8 with SMTP id f2-20020a05651c03c200b002d2eb573ac8mr749868ljp.34.1709290638433;
        Fri, 01 Mar 2024 02:57:18 -0800 (PST)
Received: from ?IPV6:2003:cb:c713:3200:77d:8652:169f:b5f7? (p200300cbc7133200077d8652169fb5f7.dip0.t-ipconnect.de. [2003:cb:c713:3200:77d:8652:169f:b5f7])
        by smtp.gmail.com with ESMTPSA id v12-20020a05600c444c00b00412b9e4af05sm5160814wmn.0.2024.03.01.02.57.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 02:57:17 -0800 (PST)
Message-ID: <97d53a8b-1b8c-47a7-977f-4fc4977ef236@redhat.com>
Date: Fri, 1 Mar 2024 11:57:16 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio/type1: unpin PageReserved page
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Yisheng Xie <ethan.xys@linux.alibaba.com>, akpm@linux-foundation.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20240226160106.24222-1-ethan.xys@linux.alibaba.com>
 <20240226091438.1fc37957.alex.williamson@redhat.com>
 <e10ace3f-78d3-4843-8028-a0e1cd107c15@linux.alibaba.com>
 <20240226103238.75ad4b24.alex.williamson@redhat.com>
 <abb00aef-378c-481a-a885-327a99aa7b09@redhat.com>
 <20240227132556.17e87767.alex.williamson@redhat.com>
 <20240229150406.4d41db01.alex.williamson@redhat.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240229150406.4d41db01.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 29.02.24 23:04, Alex Williamson wrote:
> On Tue, 27 Feb 2024 13:25:56 -0700
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
>> On Tue, 27 Feb 2024 11:27:08 +0100
>> David Hildenbrand <david@redhat.com> wrote:
>>
>>> On 26.02.24 18:32, Alex Williamson wrote:
>>>> On Tue, 27 Feb 2024 01:14:54 +0800
>>>> Yisheng Xie <ethan.xys@linux.alibaba.com> wrote:
>>>>      
>>>>> 在 2024/2/27 00:14, Alex Williamson 写道:
>>>>>> On Tue, 27 Feb 2024 00:01:06 +0800
>>>>>> Yisheng Xie<ethan.xys@linux.alibaba.com>  wrote:
>>>>>>        
>>>>>>> We meet a warning as following:
>>>>>>>     WARNING: CPU: 99 PID: 1766859 at mm/gup.c:209 try_grab_page.part.0+0xe8/0x1b0
>>>>>>>     CPU: 99 PID: 1766859 Comm: qemu-kvm Kdump: loaded Tainted: GOE  5.10.134-008.2.x86_64 #1
>>>>>>                                                                       ^^^^^^^^
>>>>>>
>>>>>> Does this issue reproduce on mainline?  Thanks,
>>>>>
>>>>> I have check the code of mainline, the logical seems the same as my
>>>>> version.
>>>>>
>>>>> so I think it can reproduce if i understand correctly.
>>>>
>>>> I obviously can't speak to what's in your 5.10.134-008.2 kernel, but I
>>>> do know there's a very similar issue resolved in v6.0 mainline and
>>>> included in v5.10.146 of the stable tree.  Please test.  Thanks,
>>>
>>> This commit, to be precise:
>>>
>>> commit 873aefb376bbc0ed1dd2381ea1d6ec88106fdbd4
>>> Author: Alex Williamson <alex.williamson@redhat.com>
>>> Date:   Mon Aug 29 21:05:40 2022 -0600
>>>
>>>       vfio/type1: Unpin zero pages
>>>       
>>>       There's currently a reference count leak on the zero page.  We increment
>>>       the reference via pin_user_pages_remote(), but the page is later handled
>>>       as an invalid/reserved page, therefore it's not accounted against the
>>>       user and not unpinned by our put_pfn().
>>>       
>>>       Introducing special zero page handling in put_pfn() would resolve the
>>>       leak, but without accounting of the zero page, a single user could
>>>       still create enough mappings to generate a reference count overflow.
>>>       
>>>       The zero page is always resident, so for our purposes there's no reason
>>>       to keep it pinned.  Therefore, add a loop to walk pages returned from
>>>       pin_user_pages_remote() and unpin any zero pages.
>>>
>>>
>>> BUT
>>>
>>> in the meantime, we also have
>>>
>>> commit c8070b78751955e59b42457b974bea4a4fe00187
>>> Author: David Howells <dhowells@redhat.com>
>>> Date:   Fri May 26 22:41:40 2023 +0100
>>>
>>>       mm: Don't pin ZERO_PAGE in pin_user_pages()
>>>       
>>>       Make pin_user_pages*() leave a ZERO_PAGE unpinned if it extracts a pointer
>>>       to it from the page tables and make unpin_user_page*() correspondingly
>>>       ignore a ZERO_PAGE when unpinning.  We don't want to risk overrunning a
>>>       zero page's refcount as we're only allowed ~2 million pins on it -
>>>       something that userspace can conceivably trigger.
>>>       
>>>       Add a pair of functions to test whether a page or a folio is a ZERO_PAGE.
>>>
>>>
>>> So the unpin_user_page_* won't do anything with the shared zeropage.
>>>
>>> (likely, we could revert 873aefb376bbc0ed1dd2381ea1d6ec88106fdbd4)
>>
>>
>> Yes, according to the commit log it seems like the unpin is now just
>> wasted work since v6.5.  Thanks!
> 
> I dusted off an old unit test for mapping the zeropage through vfio and
> started working on posting a revert for 873aefb376bb but I actually
> found that this appears to be resolved even before c8070b787519.  I
> bisected it to:
> 
> commit 84209e87c6963f928194a890399e24e8ad299db1
> Author: David Hildenbrand <david@redhat.com>
> Date:   Wed Nov 16 11:26:48 2022 +0100
> 
>      mm/gup: reliable R/O long-term pinning in COW mappings
>      
>      We already support reliable R/O pinning of anonymous memory.
>      However, assume we end up pinning (R/O long-term) a pagecache page
>      or the shared zeropage inside a writable private ("COW") mapping.
>      The next write access will trigger a write-fault and replace the
>      pinned page by an exclusive anonymous page in the process page
>      tables to break COW: the pinned page no longer corresponds to the
>      page mapped into the process' page table.
>      Now that FAULT_FLAG_UNSHARE can break COW on anything mapped into a
>      COW mapping, let's properly break COW first before R/O long-term
>      pinning something that's not an exclusive anon page inside a COW
>      mapping. FAULT_FLAG_UNSHARE will break COW and map an exclusive
>      anon page instead that can get pinned safely.
>      
>      With this change, we can stop using FOLL_FORCE|FOLL_WRITE for
>      reliable R/O long-term pinning in COW mappings.
> 
> [...]
> 
>      Note 3: For users that use FOLL_LONGTERM right now without
>      FOLL_WRITE, such as VFIO, we'd now no longer pin the shared
>      zeropage. Instead, we'd populate exclusive anon pages that we can
>      pin. There was a concern that this could affect the memlock limit
>      of existing setups.
> 
>      For example, a VM running with VFIO could run into the memlock
>      limit and fail to run. However, we essentially had the same
>      behavior already in commit 17839856fd58 ("gup: document and work
>      around "COW can break either way" issue") which got merged into
>      some enterprise distros, and there were not any such complaints. So
>      most probably, we're fine.
> 

Oh, I almost forgot about that one :)

Indeed, 84209e87c696 was v6.2 and c8070b787519 was v6.5.

... and c8070b787519 was primarily concerned about !FOLL_LONGTERM usage, 
so that makes sense that they would still run into zeropages.

For vfio, 84209e87c696 did the trick.

-- 
Cheers,

David / dhildenb


