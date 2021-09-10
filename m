Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9E6406909
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 11:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbhIJJZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 05:25:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32668 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231962AbhIJJZD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Sep 2021 05:25:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631265832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vrslVFgCV0A1ASGIKU12boBiWPC4TLJ7XoCjGrBTCz8=;
        b=JJEvg2H5+TLjA9WWSA96xgLOShSki5LRRV51vAw4FkeJKk9aTbTXTBID0YKSTaMdkL8KzI
        BPtKEbJeaWWq7p6ohU2BNeRphgDq2X0pznRgjwlRUrIO/SY0O7d/DukENTt+QJWaFJ5kJA
        6DPIYQTiZsK+QmEV2eV3+QX/QzLoWik=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-JkPBiedFObK6aPvcjljA5g-1; Fri, 10 Sep 2021 05:23:51 -0400
X-MC-Unique: JkPBiedFObK6aPvcjljA5g-1
Received: by mail-wr1-f72.google.com with SMTP id r11-20020a5d4e4b000000b001575c5ed4b4so293898wrt.4
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 02:23:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=vrslVFgCV0A1ASGIKU12boBiWPC4TLJ7XoCjGrBTCz8=;
        b=Mg8PyqENr2jiXXHraK65lDvpKKI9Wc79Vb82CIetd+TOaLM3r/A0//fUBCFPNfdMyL
         XBL4MfJbpFhzTyqEc0YlRNDNNeiVA766NaMspAMEKHn26U5kvqY2au84Oo2UEXPQa0d4
         Nkc2ULNpAATvYJiSAZwhXyYpFLqt91Ldox8gymaPpRxHbdjhb6TOVZucHwsrWIyBOVHU
         Ih6mOc1IHlwfiWtJE/czMc/09CPBS1LWCxB4uiResL5K3sV1OvXi35/OjDtouS/vOEK9
         hbiAd8JjIsVcv1mZyLFgyFVEBHtq4lCZRf/WR8ptmYhprgT75XKhv2qVQaJoK1r38FC1
         Xacw==
X-Gm-Message-State: AOAM532+rBdyeDIFMkjj3zcrSNo8nqmEZkoZXQ/4POl+9nVvkS0kizui
        0l+m/4JVBk9ikH1zyKk1tOppPMxk86zRQ3ylHd4WOuVkkqPxxH6gEd8TYQx9gaOUbtfPuxk5AqE
        iX2nNIOdrD/6l
X-Received: by 2002:adf:e7ca:: with SMTP id e10mr537331wrn.97.1631265830297;
        Fri, 10 Sep 2021 02:23:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbJtumfWhoeoqWdrbbfX6WGzwZFjWqOeIuwT2t9OUhauNMdOAXqx3T37WZquMUdpxR8rvMgA==
X-Received: by 2002:adf:e7ca:: with SMTP id e10mr537307wrn.97.1631265829997;
        Fri, 10 Sep 2021 02:23:49 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c600c.dip0.t-ipconnect.de. [91.12.96.12])
        by smtp.gmail.com with ESMTPSA id p5sm4479649wrd.25.2021.09.10.02.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 02:23:49 -0700 (PDT)
Subject: Re: [PATCH RFC 6/9] s390/pci_mmio: fully validate the VMA before
 calling follow_pte()
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
References: <20210909145945.12192-1-david@redhat.com>
 <20210909145945.12192-7-david@redhat.com>
 <82d683ec361245e1879b3f14492cdd5c41957e52.camel@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <d9ec2387-2645-796e-af47-26f22516f7fa@redhat.com>
Date:   Fri, 10 Sep 2021 11:23:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <82d683ec361245e1879b3f14492cdd5c41957e52.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10.09.21 10:22, Niklas Schnelle wrote:
> On Thu, 2021-09-09 at 16:59 +0200, David Hildenbrand wrote:
>> We should not walk/touch page tables outside of VMA boundaries when
>> holding only the mmap sem in read mode. Evil user space can modify the
>> VMA layout just before this function runs and e.g., trigger races with
>> page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
>> with read mmap_sem in munmap").
>>
>> find_vma() does not check if the address is >= the VMA start address;
>> use vma_lookup() instead.
>>
>> Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   arch/s390/pci/pci_mmio.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
>> index ae683aa623ac..c5b35ea129cf 100644
>> --- a/arch/s390/pci/pci_mmio.c
>> +++ b/arch/s390/pci/pci_mmio.c
>> @@ -159,7 +159,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
>>   
>>   	mmap_read_lock(current->mm);
>>   	ret = -EINVAL;
>> -	vma = find_vma(current->mm, mmio_addr);
>> +	vma = vma_lookup(current->mm, mmio_addr);
>>   	if (!vma)
>>   		goto out_unlock_mmap;
>>   	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
>> @@ -298,7 +298,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, mmio_addr,
>>   
>>   	mmap_read_lock(current->mm);
>>   	ret = -EINVAL;
>> -	vma = find_vma(current->mm, mmio_addr);
>> +	vma = vma_lookup(current->mm, mmio_addr);
>>   	if (!vma)
>>   		goto out_unlock_mmap;
>>   	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> 
> Oh wow great find thanks! If I may say so these are not great function
> names. Looking at the code vma_lookup() is inded find_vma() plus the
> check that the looked up address is indeed inside the vma.
> 

IIRC, vma_lookup() was introduced fairly recently. Before that, this 
additional check was open coded (and still are in some instances). It's 
confusing, I agree.

> I think this is pretty independent of the rest of the patches, so do
> you want me to apply this patch independently or do you want to wait
> for the others?

Sure, please go ahead and apply independently. It'd be great if you 
could give it a quick sanity test, although I don't expect surprises -- 
unfortunately, the environment I have easily at hand is not very well 
suited (#cpu, #mem, #disk ...) for anything that exceeds basic compile 
tests (and even cross-compiling is significantly faster ...).

> 
> In any case:
> 
> Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
> 

Thanks!

-- 
Thanks,

David / dhildenb

