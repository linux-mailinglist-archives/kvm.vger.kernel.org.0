Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A189327226F
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 13:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgIUL2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 07:28:34 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13794 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726341AbgIUL2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 07:28:33 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 012EF6E65A88CFDEF61C;
        Mon, 21 Sep 2020 19:28:32 +0800 (CST)
Received: from [10.174.185.226] (10.174.185.226) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Mon, 21 Sep 2020 19:28:25 +0800
Subject: Re: [PATCH v2 2/2] vfio/pci: Don't regenerate vconfig for all BARs if
 !bardirty
To:     Cornelia Huck <cohuck@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alex.williamson@redhat.com>, <wanghaibin.wang@huawei.com>
References: <20200921045116.258-1-yuzenghui@huawei.com>
 <20200921045116.258-2-yuzenghui@huawei.com>
 <20200921122134.5c7794f3.cohuck@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <8cc2acc1-6eaa-8ed0-db78-7ff5dc36828d@huawei.com>
Date:   Mon, 21 Sep 2020 19:28:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200921122134.5c7794f3.cohuck@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Cornelia,

On 2020/9/21 18:21, Cornelia Huck wrote:
> On Mon, 21 Sep 2020 12:51:16 +0800
> Zenghui Yu <yuzenghui@huawei.com> wrote:
> 
>> Now we regenerate vconfig for all the BARs via vfio_bar_fixup(), every time
>> any offset of any of them are read. Though BARs aren't re-read regularly,
>> the regeneration can be avoid if no BARs had been written since they were
> 
> s/avoid/avoided/
> 
>> last read, in which case the vdev->bardirty is false.
> 
> s/the//
> 
>>
>> Let's predicate the vfio_bar_fixup() on the bardirty so that it can return
>> immediately if !bardirty.
> 
> Maybe
> 
> "Let's return immediately in vfio_bar_fixup() if bardirty is false." ?

Yes.

>>
>> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>> ---
>> * From v1:
>>    - Per Alex's suggestion, let vfio_bar_fixup() test vdev->bardirty to
>>      avoid doing work if bardirty is false, instead of removing it entirely.
>>    - Rewrite the commit message.
>>
>>   drivers/vfio/pci/vfio_pci_config.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
>> index d98843feddce..5e02ba07e8e8 100644
>> --- a/drivers/vfio/pci/vfio_pci_config.c
>> +++ b/drivers/vfio/pci/vfio_pci_config.c
>> @@ -467,6 +467,9 @@ static void vfio_bar_fixup(struct vfio_pci_device *vdev)
>>   	__le32 *vbar;
>>   	u64 mask;
>>
>> +	if (!vdev->bardirty)
> 
> Finally, bardirty can actually affect something :)
> 
>> +		return;
>> +
>>   	vbar = (__le32 *)&vdev->vconfig[PCI_BASE_ADDRESS_0];
>>   
>>   	for (i = 0; i < PCI_STD_NUM_BARS; i++, vbar++) {
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

Thanks for you review! I think Alex can help fix the commit message when
applying? Otherwise I can send a v3.


Thanks,
Zenghui
