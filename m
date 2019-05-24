Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 069AC29125
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 08:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388888AbfEXGnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 02:43:22 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36354 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388600AbfEXGnW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 02:43:22 -0400
Received: by mail-pg1-f193.google.com with SMTP id a3so4495726pgb.3
        for <kvm@vger.kernel.org>; Thu, 23 May 2019 23:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vLgUtLgd34YoqqCTxqxpLbSxwvGV3M2LzlOeHp/1Cec=;
        b=N5cq2X5sCawY7Z9049rLPwU2gWCT9rIbtsT0Gz4DPk13eQy0LpN2Tna59vDAwMCKzz
         yntDPC/U/AQk4gBrEMzkYjB7r5K+SY6B47c8qwbFaxDoj1bmL8XacFpGy0WTlr8q7xNO
         SuryBhMNYUt/Ak5gHuag3fv9upiLR/uTCvmuKpm4e1XxqFEnAXoJst7wRjvlw1rHW/JW
         3WuI/9UfWTZq9oC3gtgoTqofkQjoiCbCPcagQyPFlsjvgHy7ND/g9q5OZB8HZ6MXXBZC
         XG1XChwOHdsCuhnpSUrbwPVGVmLJKrxvYh8WofIgx35W/kgfETXtzT1hWmmhxl3oHJ/e
         9hlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=vLgUtLgd34YoqqCTxqxpLbSxwvGV3M2LzlOeHp/1Cec=;
        b=c5tnk8roL57ic8Ivzm8Rx/4SBtbJLq/ZWrvkWW+XBcSW3QEClmBO+o2eD1lYgY+eJ9
         7Ul8rz3JZUiIGL+dqvo5YLew6cBXe/cHl+RH6W6tIXN6HmB92VqLchW78g0jW325q+wk
         TcosCc49sqqUtWwv6OnF6w6Rszre+NESaEZgFMUC3ioAzg5xXBb3V+TQbjMf0/dJ8l8e
         dNJX76bADt0vF20Ux9x+4rX880dO/j95yaJ0CM4MaqiD1yQtwa4vwiEo2tt0hQ/Z1KJx
         SgquLcbqtRZDBBecU5x/x9iM2lGRCpbBHbNeA5sVon+EYhADsUr8mTOCCWARkiFxE7rX
         yKaQ==
X-Gm-Message-State: APjAAAU6SbzFCeEsPas/PF1gB66bdBNQq1xa60DteXUH5UXn/ZAqoSRi
        zsAau/nMkQr93UBLw64uPLTswQ==
X-Google-Smtp-Source: APXvYqxqG0xxpSvgFOlx2V/WqlpEOtxoiKjPS2ntAlHEUsHs+ZwOtWxQSUfVvqJLa+cBrl/pKYMGJg==
X-Received: by 2002:a63:5c1b:: with SMTP id q27mr104461120pgb.127.1558680200104;
        Thu, 23 May 2019 23:43:20 -0700 (PDT)
Received: from [10.61.2.175] ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id n27sm2608734pfb.129.2019.05.23.23.43.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 23:43:19 -0700 (PDT)
Subject: Re: [PATCH] mm: add account_locked_vm utility function
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     akpm@linux-foundation.org, Alan Tull <atull@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christoph Lameter <cl@linux.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Moritz Fischer <mdf@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Steve Sistare <steven.sistare@oracle.com>,
        Wu Hao <hao.wu@intel.com>, linux-mm@kvack.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-fpga@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190503201629.20512-1-daniel.m.jordan@oracle.com>
 <4b42057f-b998-f87c-4e0f-a91abcb366f9@ozlabs.ru>
 <20190520153020.mzvjsjwefwxz6cau@ca-dmjordan1.us.oracle.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
Openpgp: preference=signencrypt
Autocrypt: addr=aik@ozlabs.ru; keydata=
 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
Message-ID: <de375582-2c35-8e8a-4737-c816052a8e58@ozlabs.ru>
Date:   Fri, 24 May 2019 16:43:10 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190520153020.mzvjsjwefwxz6cau@ca-dmjordan1.us.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 21/05/2019 01:30, Daniel Jordan wrote:
> On Mon, May 20, 2019 at 04:19:34PM +1000, Alexey Kardashevskiy wrote:
>> On 04/05/2019 06:16, Daniel Jordan wrote:
>>> locked_vm accounting is done roughly the same way in five places, so
>>> unify them in a helper.  Standardize the debug prints, which vary
>>> slightly.
>>
>> And I rather liked that prints were different and tell precisely which
>> one of three each printk is.
> 
> I'm not following.  One of three...callsites?  But there were five callsites.


Well, 3 of them are mine, I was referring to them :)


> Anyway, I added a _RET_IP_ to the debug print so you can differentiate.


I did not know that existed, cool!


> 
>> I commented below but in general this seems working.
>>
>> Tested-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> 
> Thanks!  And for the review as well.
> 
>>> diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
>>> index 6b64e45a5269..d39a1b830d82 100644
>>> --- a/drivers/vfio/vfio_iommu_spapr_tce.c
>>> +++ b/drivers/vfio/vfio_iommu_spapr_tce.c
>>> @@ -34,49 +35,13 @@
>>>  static void tce_iommu_detach_group(void *iommu_data,
>>>  		struct iommu_group *iommu_group);
>>>  
>>> -static long try_increment_locked_vm(struct mm_struct *mm, long npages)
>>> +static int tce_account_locked_vm(struct mm_struct *mm, unsigned long npages,
>>> +				 bool inc)
>>>  {
>>> -	long ret = 0, locked, lock_limit;
>>> -
>>>  	if (WARN_ON_ONCE(!mm))
>>>  		return -EPERM;
>>
>>
>> If this WARN_ON is the only reason for having tce_account_locked_vm()
>> instead of calling account_locked_vm() directly, you can then ditch the
>> check as I have never ever seen this triggered.
> 
> Great, will do.
> 
>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>> index d0f731c9920a..15ac76171ccd 100644
>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>> @@ -273,25 +273,14 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
>>>  		return -ESRCH; /* process exited */
>>>  
>>>  	ret = down_write_killable(&mm->mmap_sem);
>>> -	if (!ret) {
>>> -		if (npage > 0) {
>>> -			if (!dma->lock_cap) {
>>> -				unsigned long limit;
>>> -
>>> -				limit = task_rlimit(dma->task,
>>> -						RLIMIT_MEMLOCK) >> PAGE_SHIFT;
>>> -
>>> -				if (mm->locked_vm + npage > limit)
>>> -					ret = -ENOMEM;
>>> -			}
>>> -		}
>>> +	if (ret)
>>> +		goto out;
>>
>>
>> A single "goto" to jump just 3 lines below seems unnecessary.
> 
> No strong preference here, I'll take out the goto.
> 
>>> +int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
>>> +			struct task_struct *task, bool bypass_rlim)
>>> +{
>>> +	unsigned long locked_vm, limit;
>>> +	int ret = 0;
>>> +
>>> +	locked_vm = mm->locked_vm;
>>> +	if (inc) {
>>> +		if (!bypass_rlim) {
>>> +			limit = task_rlimit(task, RLIMIT_MEMLOCK) >> PAGE_SHIFT;
>>> +			if (locked_vm + pages > limit) {
>>> +				ret = -ENOMEM;
>>> +				goto out;
>>> +			}
>>> +		}
>>
>> Nit:
>>
>> if (!ret)
>>
>> and then you don't need "goto out".
> 
> Ok, sure.
> 
>>> +		mm->locked_vm = locked_vm + pages;
>>> +	} else {
>>> +		WARN_ON_ONCE(pages > locked_vm);
>>> +		mm->locked_vm = locked_vm - pages;
>>
>>
>> Can go negative here. Not a huge deal but inaccurate imo.
> 
> I hear you, but setting a negative value to zero, as we had done previously,
> doesn't make much sense to me.


Ok then. I have not seen these WARN_ON for a very long time anyway.


-- 
Alexey
