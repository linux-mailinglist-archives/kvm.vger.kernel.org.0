Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F34B69592E
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 07:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbjBNG21 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 01:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbjBNG20 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 01:28:26 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF1216339;
        Mon, 13 Feb 2023 22:28:24 -0800 (PST)
Received: from kwepemi100025.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PGB6y3j7FzJsQd;
        Tue, 14 Feb 2023 14:26:18 +0800 (CST)
Received: from [10.174.148.223] (10.174.148.223) by
 kwepemi100025.china.huawei.com (7.221.188.158) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Tue, 14 Feb 2023 14:27:27 +0800
Message-ID: <35b94992-0c6b-a190-1fce-5dda9c8dcf4b@huawei.com>
Date:   Tue, 14 Feb 2023 14:27:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] vhost-vdpa: cleanup memory maps when closing vdpa fds
To:     Jason Wang <jasowang@redhat.com>, <mst@redhat.com>
CC:     <arei.gonglei@huawei.com>, <yechuan@huawei.com>,
        <huangzhichao@huawei.com>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
References: <20230131145310.2069-1-longpeng2@huawei.com>
 <db99245c-606a-2f24-52fe-836a6972437f@redhat.com>
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
In-Reply-To: <db99245c-606a-2f24-52fe-836a6972437f@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi100025.china.huawei.com (7.221.188.158)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/2/14 14:16, Jason Wang 写道:
> 
> 在 2023/1/31 22:53, Longpeng(Mike) 写道:
>> From: Longpeng <longpeng2@huawei.com>
>>
>> We must cleanup all memory maps when closing the vdpa fds, otherwise
>> some critical resources (e.g. memory, iommu map) will leaked if the
>> userspace exits unexpectedly (e.g. kill -9).
> 
> 
> Sounds like a bug of the kernel, should we fix there?
> 

For example, the iommu map is setup when QEMU calls VHOST_IOTLB_UPDATE 
ioctl and it'll be freed if QEMU calls VHOST_IOTLB_INVALIDATE ioctl.

So maybe we release these resources in vdpa framework in kernel is a 
suitable choice?

By the way, Jason, can you reproduce the problem in your machine?

> Thanks
> 
> 
>>
>> Signed-off-by: Longpeng <longpeng2@huawei.com>
>> ---
>>   drivers/vhost/vdpa.c | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> index a527eeeac637..37477cffa5aa 100644
>> --- a/drivers/vhost/vdpa.c
>> +++ b/drivers/vhost/vdpa.c
>> @@ -823,6 +823,18 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v,
>>           vhost_vdpa_remove_as(v, asid);
>>   }
>> +static void vhost_vdpa_clean_map(struct vhost_vdpa *v)
>> +{
>> +    struct vhost_vdpa_as *as;
>> +    u32 asid;
>> +
>> +    for (asid = 0; asid < v->vdpa->nas; asid++) {
>> +        as = asid_to_as(v, asid);
>> +        if (as)
>> +            vhost_vdpa_unmap(v, &as->iotlb, 0ULL, 0ULL - 1);
>> +    }
>> +}
>> +
>>   static int vhost_vdpa_va_map(struct vhost_vdpa *v,
>>                    struct vhost_iotlb *iotlb,
>>                    u64 iova, u64 size, u64 uaddr, u32 perm)
>> @@ -1247,6 +1259,7 @@ static int vhost_vdpa_release(struct inode 
>> *inode, struct file *filep)
>>       vhost_vdpa_clean_irq(v);
>>       vhost_vdpa_reset(v);
>>       vhost_dev_stop(&v->vdev);
>> +    vhost_vdpa_clean_map(v);
>>       vhost_vdpa_free_domain(v);
>>       vhost_vdpa_config_put(v);
>>       vhost_vdpa_cleanup(v);
> 
> .
