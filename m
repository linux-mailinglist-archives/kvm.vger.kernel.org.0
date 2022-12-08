Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448F3646639
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 02:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiLHBHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 20:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLHBHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 20:07:54 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13BFF66
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 17:07:53 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NSGFw1nFDzRprS;
        Thu,  8 Dec 2022 09:07:00 +0800 (CST)
Received: from [10.174.176.230] (10.174.176.230) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Dec 2022 09:07:45 +0800
Message-ID: <699c1182-62de-ca90-113c-9f4c5b44dd21@huawei.com>
Date:   Thu, 8 Dec 2022 09:07:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH] samples: vfio-mdev: Fix missing pci_disable_device() in
 mdpy_fb_probe()
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <kwankhede@nvidia.com>, <kraxel@redhat.com>, <kvm@vger.kernel.org>
References: <20221207072128.30344-1-shangxiaojing@huawei.com>
 <20221207151850.07d7a5e2.alex.williamson@redhat.com>
From:   shangxiaojing <shangxiaojing@huawei.com>
In-Reply-To: <20221207151850.07d7a5e2.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.230]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022/12/8 6:18, Alex Williamson wrote:
> On Wed, 7 Dec 2022 15:21:28 +0800
> Shang XiaoJing <shangxiaojing@huawei.com> wrote:
> 
>> Add missing pci_disable_device() in fail path of mdpy_fb_probe().
>>
>> Fixes: cacade1946a4 ("sample: vfio mdev display - guest driver")
>> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
>> ---
>>   samples/vfio-mdev/mdpy-fb.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
>> index 9ec93d90e8a5..a7b3a30058e5 100644
>> --- a/samples/vfio-mdev/mdpy-fb.c
>> +++ b/samples/vfio-mdev/mdpy-fb.c
>> @@ -109,7 +109,7 @@ static int mdpy_fb_probe(struct pci_dev *pdev,
>>   
>>   	ret = pci_request_regions(pdev, "mdpy-fb");
>>   	if (ret < 0)
>> -		return ret;
>> +		goto err_disable_dev;
>>   
>>   	pci_read_config_dword(pdev, MDPY_FORMAT_OFFSET, &format);
>>   	pci_read_config_dword(pdev, MDPY_WIDTH_OFFSET,	&width);
>> @@ -191,6 +191,9 @@ static int mdpy_fb_probe(struct pci_dev *pdev,
>>   err_release_regions:
>>   	pci_release_regions(pdev);
>>   
>> +err_disable_dev:
>> +	pci_disable_device(pdev);
>> +
>>   	return ret;
>>   }
>>   
> 
> What about the same in the .remove callback?  Seems that all but the
> framebuffer unwind is missing in the remove path.  Thanks,
> 

Right, will fix in v2.

Thanks for the review,
-- 
Shang XiaoJing
