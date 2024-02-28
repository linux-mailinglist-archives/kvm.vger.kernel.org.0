Return-Path: <kvm+bounces-10231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F256686ADD1
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 12:44:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F1131C23422
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 11:44:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0372515A49E;
	Wed, 28 Feb 2024 11:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ddF/8lUI"
X-Original-To: kvm@vger.kernel.org
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB6E130AF5;
	Wed, 28 Feb 2024 11:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709120120; cv=none; b=lixZrgKtp53AB9sncWwKejFJ8p/YAFLw55mQdkb4UuAZjHOSMGEdlXmJ9fYdW8zw7Ot4vpDZ02lk4PGeQ6oBIzLFimdrJMgUtAlWKulxiD7r/cushV+th8eHg5YbjcCBD6S1yLvrsPNiMfAcUfIDslKztTZsQLqbD3XXUVRRUOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709120120; c=relaxed/simple;
	bh=yc21hha3keyHdTXvtCFq7xYC/BdcAS1u/CZfz2Bpq5E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IOiEjRiDnmcBfcwU6CF12q7EyL62ouV0/SzWw2c/fpgEJAgJF4TkvxZOS2m/Ah6nHSFoxpSUyYLq4Yx1mluYDx4nfR8qmIvEKcx+7lyshlko1ULMhdXzKTSq94Yqvz6bi2waUB5jgzzhSol9Q0iCtTzIQ8iBfdJdvdFN7t7T1No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ddF/8lUI; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1709120114; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ZHu3CCtC5tTmDrHwG9sD4yIzMC6+Q14Tg7eRIc+2je8=;
	b=ddF/8lUIR4YxEAqD7PNcXr3HFghq5YCFZXMiOZchFcIEFbTYbSu2sTXywTaHyOyW22JbpK/6HcJteBzVCOlVx4dgaRgqWRoJKOBJtEQxy9IqK/A3vZX45/R8mELhq7uoS6eTOsYU/NpI3X9JVL15JRK1bxLZVwhftdjZMwmqrIQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=ethan.xys@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0W1PkVY5_1709120113;
Received: from 30.221.98.53(mailfrom:ethan.xys@linux.alibaba.com fp:SMTPD_---0W1PkVY5_1709120113)
          by smtp.aliyun-inc.com;
          Wed, 28 Feb 2024 19:35:14 +0800
Message-ID: <4ec89335-917a-4ea5-b38b-5cea6476d9a1@linux.alibaba.com>
Date: Wed, 28 Feb 2024 19:35:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio/type1: unpin PageReserved page
To: David Hildenbrand <david@redhat.com>,
 Alex Williamson <alex.williamson@redhat.com>, akpm@linux-foundation.org
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20240226160106.24222-1-ethan.xys@linux.alibaba.com>
 <20240226091438.1fc37957.alex.williamson@redhat.com>
 <e10ace3f-78d3-4843-8028-a0e1cd107c15@linux.alibaba.com>
 <20240226103238.75ad4b24.alex.williamson@redhat.com>
 <abb00aef-378c-481a-a885-327a99aa7b09@redhat.com>
From: Yisheng Xie <ethan.xys@linux.alibaba.com>
In-Reply-To: <abb00aef-378c-481a-a885-327a99aa7b09@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2024/2/27 18:27, David Hildenbrand 写道:
> On 26.02.24 18:32, Alex Williamson wrote:
>> On Tue, 27 Feb 2024 01:14:54 +0800
>> Yisheng Xie <ethan.xys@linux.alibaba.com> wrote:
>>
>>> 在 2024/2/27 00:14, Alex Williamson 写道:
>>>> On Tue, 27 Feb 2024 00:01:06 +0800
>>>> Yisheng Xie<ethan.xys@linux.alibaba.com>  wrote:
>>>>> We meet a warning as following:
>>>>>    WARNING: CPU: 99 PID: 1766859 at mm/gup.c:209 
>>>>> try_grab_page.part.0+0xe8/0x1b0
>>>>>    CPU: 99 PID: 1766859 Comm: qemu-kvm Kdump: loaded Tainted: GOE  
>>>>> 5.10.134-008.2.x86_64 #1
>>>> ^^^^^^^^
>>>>
>>>> Does this issue reproduce on mainline?  Thanks,
>>>
>>> I have check the code of mainline, the logical seems the same as my
>>> version.
>>>
>>> so I think it can reproduce if i understand correctly.
>>
>> I obviously can't speak to what's in your 5.10.134-008.2 kernel, but I
>> do know there's a very similar issue resolved in v6.0 mainline and
>> included in v5.10.146 of the stable tree.  Please test.  Thanks,
>
> This commit, to be precise:
>
> commit 873aefb376bbc0ed1dd2381ea1d6ec88106fdbd4
> Author: Alex Williamson <alex.williamson@redhat.com>
> Date:   Mon Aug 29 21:05:40 2022 -0600
>
>     vfio/type1: Unpin zero pages
>         There's currently a reference count leak on the zero page.  We 
> increment
>     the reference via pin_user_pages_remote(), but the page is later 
> handled
>     as an invalid/reserved page, therefore it's not accounted against the
>     user and not unpinned by our put_pfn().
>         Introducing special zero page handling in put_pfn() would 
> resolve the
>     leak, but without accounting of the zero page, a single user could
>     still create enough mappings to generate a reference count overflow.
>         The zero page is always resident, so for our purposes there's 
> no reason
>     to keep it pinned.  Therefore, add a loop to walk pages returned from
>     pin_user_pages_remote() and unpin any zero pages.
>
>
> BUT
>
> in the meantime, we also have
>
> commit c8070b78751955e59b42457b974bea4a4fe00187
> Author: David Howells <dhowells@redhat.com>
> Date:   Fri May 26 22:41:40 2023 +0100
>
>     mm: Don't pin ZERO_PAGE in pin_user_pages()
>         Make pin_user_pages*() leave a ZERO_PAGE unpinned if it 
> extracts a pointer
>     to it from the page tables and make unpin_user_page*() 
> correspondingly
>     ignore a ZERO_PAGE when unpinning.  We don't want to risk 
> overrunning a
>     zero page's refcount as we're only allowed ~2 million pins on it -
>     something that userspace can conceivably trigger.
>         Add a pair of functions to test whether a page or a folio is a 
> ZERO_PAGE.
>
>
> So the unpin_user_page_* won't do anything with the shared zeropage.
>
> (likely, we could revert 873aefb376bbc0ed1dd2381ea1d6ec88106fdbd4)

Thanks for your detail info. BTW, do we need handle all of the 
pagereserved page?


