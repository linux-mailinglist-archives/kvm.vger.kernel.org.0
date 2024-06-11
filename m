Return-Path: <kvm+bounces-19330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 58003903E77
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 16:14:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D70661F22114
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 14:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57E8F17D898;
	Tue, 11 Jun 2024 14:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gFXu5flx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45E61DDF4
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 14:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718115235; cv=none; b=J5Eww4VYM9qztjRdOVCTczYlxoYqWdYj+q7Ptktzc06bo5dWXQ/kd8jRWP4fh4ViAUYcAihtd2otCANB2LZDHeB2Hl8aSTdNZKMucHNfJLt/DubOZaSrLu0WIaUxDpbnjGL0LkCbSnF8W0TXiemc6u5tnYsFVNZiElL/UeXj/vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718115235; c=relaxed/simple;
	bh=RqoA37Wm/G0g/nh1x0+bScUd0Ez9JSWjHWXlfGYzcd4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HxnIvlmaqE5EvpSBhwfC76VJpsuebjr0BCNI/WNDJ+AevUCrD15HRcqUL4PgE+iZ+UACPM5AhIciOrzJiqyBMbOlR8a4irOJL2B0WE3BfzVpInZlXJ0rHtypiqtRkqS/fdP99Z7B+PgML9/kwVo31DfcrSJsm664NRQFoVbu0hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gFXu5flx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718115232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7sloenpTUt5UiTHeg1NwBdLjgttO8uUTVm+8jIdq0Uk=;
	b=gFXu5flxhjN0zrrtRHAYEGlJZDaFD6oghG0rQtd2WR56jIQgOMIxJ124THGJ2jZMTAFK4F
	+HQCMyx9o4/ja6FS9a1kv1+X4IETrY5TLOeOaCkHiglNs6uGY6n57j9T2vPTkQGmGYzVjL
	Wcswbun+wAv5Tio/Ykkzyana5yPISBA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-55-Clf-uos3NyWrVruS5AKDJg-1; Tue, 11 Jun 2024 10:13:51 -0400
X-MC-Unique: Clf-uos3NyWrVruS5AKDJg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42153125d3eso41702925e9.2
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 07:13:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718115230; x=1718720030;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7sloenpTUt5UiTHeg1NwBdLjgttO8uUTVm+8jIdq0Uk=;
        b=kljjbvYRxYOX3XdvhiYL8BhwVYqgyGXwBJFwBOAFQxbr7oh483auPrP/sSaddffGHl
         a/frtwsAY2t7z5btWAehvBgtl3KJBubOKzKPQBg+IHXGDWYwgy6/LacS5FEgxpvLoZgU
         H8uHir/pohvAnIO+FkKY3TG65Nada6RRgI6uvNWm1Hd84YdZGVp67Wn+RqE6Ch59+1Cy
         BBCxf8SXSZI+fuu7fgvvVjBhxKwET0EDmmh3HiQZiIcrS4m8PHIMSe2YWkTRuMK0p/vy
         dgVmYHD+z1WmG4PXahdu3QZi+MJRdRA2nT4fNkHgLzGisnFD7tlvF2kZPQX4aH+Zk0e9
         d3Lg==
X-Forwarded-Encrypted: i=1; AJvYcCUzghyyMaEPFNeVGO+je3IhgVedGFRuxViclD3KWBNmChwu9fopagzSf2xY5wVZ/lsUtH5zk7qISjKdKmCUenKUjWsL
X-Gm-Message-State: AOJu0YwDqlw7MCW7rnFC+/xiQTcHLcblnPu5pZ9QkSZ71QpITOxnk+xU
	wM0NfK8989kDu2UTnFAj+lzm5IzbvJZTmAXjOrKNYUJozI/sN4TZzRsD4amtWmjaPx+gbg8oNRR
	XN8bYeB331vUGojRIdiKiuPBNsHXnmWrZGJFq4zxDBZ9DGXA3DQ==
X-Received: by 2002:a05:600c:4ec6:b0:421:79e2:c957 with SMTP id 5b1f17b1804b1-42179e2cb97mr77064245e9.19.1718115230227;
        Tue, 11 Jun 2024 07:13:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+yDv6SEaGs144m4MZGLIljvBMqLW7Mgr4+YPMshl3pOttWYqhAIXQwz7Jl3W+m8GncwPmRA==
X-Received: by 2002:a05:600c:4ec6:b0:421:79e2:c957 with SMTP id 5b1f17b1804b1-42179e2cb97mr77063805e9.19.1718115229555;
        Tue, 11 Jun 2024 07:13:49 -0700 (PDT)
Received: from ?IPV6:2003:cb:c748:ba00:1c00:48ea:7b5a:c12b? (p200300cbc748ba001c0048ea7b5ac12b.dip0.t-ipconnect.de. [2003:cb:c748:ba00:1c00:48ea:7b5a:c12b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4217d7f9a6esm112449155e9.48.2024.06.11.07.13.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jun 2024 07:13:49 -0700 (PDT)
Message-ID: <ce7b9655-aaeb-4a13-a3ac-bd4a70bbd173@redhat.com>
Date: Tue, 11 Jun 2024 16:13:47 +0200
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
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <20240529-vfio_pci_mmap-v3-0-cd217d019218@linux.ibm.com>
 <20240529-vfio_pci_mmap-v3-1-cd217d019218@linux.ibm.com>
 <98de56b1ba37f51639b9a2c15a745e19a45961a0.camel@linux.ibm.com>
 <30ecb17b7a3414aeb605c51f003582c7f2cf6444.camel@linux.ibm.com>
 <db10735e74d5a89aed73ad3268e0be40394efc31.camel@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <db10735e74d5a89aed73ad3268e0be40394efc31.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.06.24 15:23, Niklas Schnelle wrote:
> On Tue, 2024-06-11 at 14:08 +0200, Niklas Schnelle wrote:
>> On Tue, 2024-06-11 at 13:21 +0200, Niklas Schnelle wrote:
>>> On Wed, 2024-05-29 at 13:36 +0200, Niklas Schnelle wrote:
>>>> The s390 MMIO syscalls when using the classic PCI instructions do not
>>>> cause a page fault when follow_pte() fails due to the page not being
>>>> present. Besides being a general deficiency this breaks vfio-pci's mmap()
>>>> handling once VFIO_PCI_MMAP gets enabled as this lazily maps on first
>>>> access. Fix this by following a failed follow_pte() with
>>>> fixup_user_page() and retrying the follow_pte().
>>>>
>>>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>>>> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>>> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
>>>> ---
>>>>   arch/s390/pci/pci_mmio.c | 18 +++++++++++++-----
>>>>   1 file changed, 13 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
>>>> index 5398729bfe1b..80c21b1a101c 100644
>>>> --- a/arch/s390/pci/pci_mmio.c
>>>> +++ b/arch/s390/pci/pci_mmio.c
>>>> @@ -170,8 +170,12 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
>>>>   		goto out_unlock_mmap;
>>>>   
>>>>   	ret = follow_pte(vma, mmio_addr, &ptep, &ptl);
>>>> -	if (ret)
>>>> -		goto out_unlock_mmap;
>>>> +	if (ret) {
>>>> +		fixup_user_fault(current->mm, mmio_addr, FAULT_FLAG_WRITE, NULL);
>>>> +		ret = follow_pte(vma, mmio_addr, &ptep, &ptl);
>>>> +		if (ret)
>>>> +			goto out_unlock_mmap;
>>>> +	}
>>>>   
>>>>   	io_addr = (void __iomem *)((pte_pfn(*ptep) << PAGE_SHIFT) |
>>>>   			(mmio_addr & ~PAGE_MASK));
>>>> @@ -305,12 +309,16 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, mmio_addr,
>>>>   	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
>>>>   		goto out_unlock_mmap;
>>>>   	ret = -EACCES;
>>>> -	if (!(vma->vm_flags & VM_WRITE))
>>>> +	if (!(vma->vm_flags & VM_READ))
>>>>   		goto out_unlock_mmap;
>>>>   
>>>>   	ret = follow_pte(vma, mmio_addr, &ptep, &ptl);
>>>> -	if (ret)
>>>> -		goto out_unlock_mmap;
>>>> +	if (ret) {
>>>> +		fixup_user_fault(current->mm, mmio_addr, 0, NULL);
>>>> +		ret = follow_pte(vma, mmio_addr, &ptep, &ptl);
>>>> +		if (ret)
>>>> +			goto out_unlock_mmap;
>>>> +	}
>>>>   
>>>>   	io_addr = (void __iomem *)((pte_pfn(*ptep) << PAGE_SHIFT) |
>>>>   			(mmio_addr & ~PAGE_MASK));
>>>>
>>>
>>> Ughh, I think I just stumbled over a problem with this. This is a
>>> failing lock held assertion via __is_vma_write_locked() in
>>> remap_pfn_range_notrack() but I'm not sure yet what exactly causes this
>>>
>>> [   67.338855] ------------[ cut here ]------------
>>> [   67.338865] WARNING: CPU: 15 PID: 2056 at include/linux/rwsem.h:85 remap_pfn_range_notrack+0x596/0x5b0
>>> [   67.338874] Modules linked in: <--- 8< --->
>>> [   67.338931] CPU: 15 PID: 2056 Comm: vfio-test Not tainted 6.10.0-rc1-pci-pfault-00004-g193e3a513cee #5
>>> [   67.338934] Hardware name: IBM 3931 A01 701 (LPAR)
>>> [   67.338935] Krnl PSW : 0704c00180000000 000003e54c9730ea (remap_pfn_range_notrack+0x59a/0x5b0)
>>> [   67.338940]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
>>> [   67.338944] Krnl GPRS: 0000000000000100 000003655915fb78 000002d80b9a5928 000003ff7fa00000
>>> [   67.338946]            0004008000000000 0000000000004000 0000000000000711 000003ff7fa04000
>>> [   67.338948]            000002d80c533f00 000002d800000100 000002d81bbe6c28 000002d80b9a5928
>>> [   67.338950]            000003ff7fa00000 000002d80c533f00 000003e54c973120 000003655915fab0
>>> [   67.338956] Krnl Code: 000003e54c9730de: a708ffea            lhi     %r0,-22
>>>                            000003e54c9730e2: a7f4fff6            brc     15,000003e54c9730ce
>>>                           #000003e54c9730e6: af000000            mc      0,0
>>>                           >000003e54c9730ea: a7f4fd6e            brc     15,000003e54c972bc6
>>>                            000003e54c9730ee: af000000            mc      0,0
>>>                            000003e54c9730f2: af000000            mc      0,0
>>>                            000003e54c9730f6: 0707                bcr     0,%r7
>>>                            000003e54c9730f8: 0707                bcr     0,%r7
>>> [   67.339025] Call Trace:
>>> [   67.339027]  [<000003e54c9730ea>] remap_pfn_range_notrack+0x59a/0x5b0
>>> [   67.339032]  [<000003e54c973120>] remap_pfn_range+0x20/0x30
>>> [   67.339035]  [<000003e4cce5396c>] vfio_pci_mmap_fault+0xec/0x1d0 [vfio_pci_core]
>>> [   67.339043]  [<000003e54c977240>] handle_mm_fault+0x6b0/0x25a0
>>> [   67.339046]  [<000003e54c966328>] fixup_user_fault+0x138/0x310
>>> [   67.339048]  [<000003e54c63a91c>] __s390x_sys_s390_pci_mmio_read+0x28c/0x3a0
>>> [   67.339051]  [<000003e54c5e200a>] do_syscall+0xea/0x120
>>> [   67.339055]  [<000003e54d5f9954>] __do_syscall+0x94/0x140
>>> [   67.339059]  [<000003e54d611020>] system_call+0x70/0xa0
>>> [   67.339063] Last Breaking-Event-Address:
>>> [   67.339065]  [<000003e54c972bc2>] remap_pfn_range_notrack+0x72/0x5b0
>>> [   67.339067] ---[ end trace 0000000000000000 ]---
>>>
>>
>> This has me a bit confused so far as __is_vma_write_locked() checks
>> mmap_assert_write_locked(vma->vm_mm) but most other users of
>> fixup_user_fault() hold mmap_read_lock() just like this code and
>> clearly in the non page fault case we only need the read lock.

This is likely the 
vm_flags_set()->vma_start_write(vma)->__is_vma_write_locked()

which checks mmap_assert_write_locked().

Setting VMA flags would be racy with the mmap lock in read mode.


remap_pfn_range() documents: "this is only safe if the mm semaphore is 
held when called." which doesn't spell out if it needs to be held in 
write mode (which I think it does) :)


My best guess is: if you are using remap_pfn_range() from a fault 
handler (not during mmap time) you are doing something wrong, that's why 
you get that report.

vmf_insert_pfn() and friends might be better alternatives, that make 
sure that the VMA already received the proper VMA flags at mmap time.

>>
> 
> And it gets weirder, as I could have sworn that I properly tested this
> on v1, I retested with v1 (tags/sent/vfio_pci_mmap-v1 on my
> git.kernel.org/niks and based on v6.9) and there I don't get the above
> warning. I also made sure that it's not caused by my change to
> "current->mm" for v2. But I'm also not hitting the checks David moved
> into follow_pte() so yeah not sure what's going on here.


You mean the mmap_assert_locked()? Yeah, that only checks if you have it 
in read mode, but not in write mode.

-- 
Cheers,

David / dhildenb


