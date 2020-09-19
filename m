Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3805C270A1C
	for <lists+kvm@lfdr.de>; Sat, 19 Sep 2020 04:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgISCkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 22:40:02 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13317 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbgISCkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Sep 2020 22:40:02 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 076EFCC9CB3F25A70EFE;
        Sat, 19 Sep 2020 10:40:01 +0800 (CST)
Received: from [10.174.185.226] (10.174.185.226) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 10:39:55 +0800
Subject: Re: [PATCH 2/2] vfio/pci: Remove bardirty from vfio_pci_device
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wanghaibin.wang@huawei.com>
References: <20200917033128.872-1-yuzenghui@huawei.com>
 <20200917033128.872-2-yuzenghui@huawei.com>
 <20200917133537.17af2ef3.cohuck@redhat.com> <20200917160742.4e4d6efd@x1.home>
 <3b5214f9-9e17-2bcd-1b92-57bacc1c1b31@huawei.com>
 <20200918201128.16cf0a1c@x1.home>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <254ac8bf-e912-0d01-0295-8bb54f7a88bf@huawei.com>
Date:   Sat, 19 Sep 2020 10:39:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200918201128.16cf0a1c@x1.home>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/9/19 10:11, Alex Williamson wrote:
> On Sat, 19 Sep 2020 09:54:00 +0800
> Zenghui Yu <yuzenghui@huawei.com> wrote:
> 
>> Hi Alex,
>>
>> On 2020/9/18 6:07, Alex Williamson wrote:
>>> On Thu, 17 Sep 2020 13:35:37 +0200
>>> Cornelia Huck <cohuck@redhat.com> wrote:
>>>    
>>>> On Thu, 17 Sep 2020 11:31:28 +0800
>>>> Zenghui Yu <yuzenghui@huawei.com> wrote:
>>>>   
>>>>> It isn't clear what purpose the @bardirty serves. It might be used to avoid
>>>>> the unnecessary vfio_bar_fixup() invoking on a user-space BAR read, which
>>>>> is not required when bardirty is unset.
>>>>>
>>>>> The variable was introduced in commit 89e1f7d4c66d ("vfio: Add PCI device
>>>>> driver") but never actually used, so it shouldn't be that important. Remove
>>>>> it.
>>>>>
>>>>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>>>>> ---
>>>>>    drivers/vfio/pci/vfio_pci_config.c  | 7 -------
>>>>>    drivers/vfio/pci/vfio_pci_private.h | 1 -
>>>>>    2 files changed, 8 deletions(-)
>>>>
>>>> Yes, it seems to have been write-only all the time.
>>>
>>> I suspect the intent was that vfio_bar_fixup() could test
>>> vdev->bardirty to avoid doing work if no BARs had been written since
>>> they were last read.  As it is now we regenerate vconfig for all the
>>> BARs every time any offset of any of them are read.  BARs aren't
>>> re-read regularly and config space is not a performance path,
>>
>> Yes, it seems that Qemu itself emulates all BAR registers and will read
>> the BAR from the kernel side only at initialization time.
>>
>>> but maybe
>>> we should instead test if we see any regressions from returning without
>>> doing any work in vfio_bar_fixup() if vdev->bardirty is false.  Thanks,
>>
>> I will test it with the following diff. Please let me know which way do
>> you prefer.
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_config.c
>> b/drivers/vfio/pci/vfio_pci_config.c
>> index d98843feddce..77c419d536d0 100644
>> --- a/drivers/vfio/pci/vfio_pci_config.c
>> +++ b/drivers/vfio/pci/vfio_pci_config.c
>> @@ -515,7 +515,7 @@ static int vfio_basic_config_read(struct
>> vfio_pci_device *vdev, int pos,
>>                                     int count, struct perm_bits *perm,
>>                                     int offset, __le32 *val)
>>    {
>> -       if (is_bar(offset)) /* pos == offset for basic config */
>> +       if (is_bar(offset) && vdev->bardirty) /* pos == offset for basic
>> config */
>>                   vfio_bar_fixup(vdev);
>>
>>           count = vfio_default_config_read(vdev, pos, count, perm,
>> offset, val);
> 
> 
> There's only one caller currently, but I'd think it cleaner to put this
> in vfio_bar_fixup(), ie. return immediately if !bardirty.  Thanks,

OK, I'll do that in the v2.


Thanks,
Zenghui
