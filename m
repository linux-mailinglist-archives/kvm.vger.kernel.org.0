Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A56389F8A
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 10:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhETIMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 04:12:23 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3601 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhETIMW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 04:12:22 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fm2Qm2VbYzQnyH;
        Thu, 20 May 2021 16:07:28 +0800 (CST)
Received: from dggeml759-chm.china.huawei.com (10.1.199.138) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 16:10:59 +0800
Received: from [10.174.178.165] (10.174.178.165) by
 dggeml759-chm.china.huawei.com (10.1.199.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 20 May 2021 16:10:58 +0800
Subject: Re: [PATCH -next] samples: vfio-mdev: fix error return code in
 mdpy_fb_probe()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Kirti Wankhede <kwankhede@nvidia.com>, <kvm@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>,
        <kraxel@redhat.com>
References: <20210519141559.3031063-1-weiyongjun1@huawei.com>
 <20210519094512.7ed3ea0f.alex.williamson@redhat.com>
 <20210520052516.GA1955@kadam>
From:   "weiyongjun (A)" <weiyongjun1@huawei.com>
Message-ID: <6518993b-8a5b-0324-f177-409b8ac6c034@huawei.com>
Date:   Thu, 20 May 2021 16:10:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210520052516.GA1955@kadam>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.165]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeml759-chm.china.huawei.com (10.1.199.138)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On Wed, May 19, 2021 at 09:45:12AM -0600, Alex Williamson wrote:
>> On Wed, 19 May 2021 14:15:59 +0000
>> Wei Yongjun <weiyongjun1@huawei.com> wrote:
>>
>>> Fix to return negative error code -ENOMEM from the error handling
>>> case instead of 0, as done elsewhere in this function.
>>>
>>> Reported-by: Hulk Robot <hulkci@huawei.com>
>>> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
>>> ---
>>>   samples/vfio-mdev/mdpy-fb.c | 4 +++-
>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
>>> index 21dbf63d6e41..d4abc0594dbd 100644
>>> --- a/samples/vfio-mdev/mdpy-fb.c
>>> +++ b/samples/vfio-mdev/mdpy-fb.c
>>> @@ -131,8 +131,10 @@ static int mdpy_fb_probe(struct pci_dev *pdev,
>>>   		 width, height);
>>>   
>>>   	info = framebuffer_alloc(sizeof(struct mdpy_fb_par), &pdev->dev);
>>> -	if (!info)
>>> +	if (!info) {
>>> +		ret = -ENOMEM;
>>>   		goto err_release_regions;
>>> +	}
>>>   	pci_set_drvdata(pdev, info);
>>>   	par = info->par;
>>>   
>>>
>> I think there's also a question of why the three 'return -EINVAL;' exit
>> paths between here and the prior call to pci_request_regions() don't
>> also take this goto.  Thanks,
>>
> Smatch catches one of these leaks...  Which is weird that it would
> ignore the other error paths.  Perhaps it was intentional?
>
> samples/vfio-mdev/mdpy-fb.c:135 mdpy_fb_probe() warn: missing error code 'ret'
> samples/vfio-mdev/mdpy-fb.c:189 mdpy_fb_probe() warn: 'pdev' not released on lines: 120.


The first one is found by coccinelle script, and I have no patterns
to catch the second one now. It seems that smatch is more clever with
this kind of issues.

Regards,

Wei Yongjun


