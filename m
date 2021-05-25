Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D090639095F
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 21:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhEYTDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 15:03:50 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:34962 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbhEYTDu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 15:03:50 -0400
Received: from [192.168.1.18] ([86.243.172.93])
        by mwinf5d64 with ME
        id 972H2500921Fzsu0372JbJ; Tue, 25 May 2021 21:02:19 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 25 May 2021 21:02:19 +0200
X-ME-IP: 86.243.172.93
Subject: Re: [PATCH -next v2] samples: vfio-mdev: fix error handing in
 mdpy_fb_probe()
To:     Alex Williamson <alex.williamson@redhat.com>,
        Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Gerd Hoffmann <kraxel@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>
References: <20210520133641.1421378-1-weiyongjun1@huawei.com>
 <20210524134938.0d736615@x1.home.shazbot.org>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <1de50564-b251-2eb7-9bcc-4ce347a85bcb@wanadoo.fr>
Date:   Tue, 25 May 2021 21:02:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210524134938.0d736615@x1.home.shazbot.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Le 24/05/2021 à 21:49, Alex Williamson a écrit :
> On Thu, 20 May 2021 13:36:41 +0000
> Wei Yongjun <weiyongjun1@huawei.com> wrote:
> 
>> Fix to return a negative error code from the framebuffer_alloc() error
>> handling case instead of 0, also release regions in some error handing
>> cases.
>>
>> Fixes: cacade1946a4 ("sample: vfio mdev display - guest driver")
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
>> ---
>> v1 -> v2: add missing regions release.
>> ---
>>   samples/vfio-mdev/mdpy-fb.c | 13 +++++++++----
>>   1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
>> index 21dbf63d6e41..9ec93d90e8a5 100644
>> --- a/samples/vfio-mdev/mdpy-fb.c
>> +++ b/samples/vfio-mdev/mdpy-fb.c
>> @@ -117,22 +117,27 @@ static int mdpy_fb_probe(struct pci_dev *pdev,
>>   	if (format != DRM_FORMAT_XRGB8888) {
>>   		pci_err(pdev, "format mismatch (0x%x != 0x%x)\n",
>>   			format, DRM_FORMAT_XRGB8888);
>> -		return -EINVAL;
>> +		ret = -EINVAL;
>> +		goto err_release_regions;
>>   	}
>>   	if (width < 100	 || width > 10000) {
>>   		pci_err(pdev, "width (%d) out of range\n", width);
>> -		return -EINVAL;
>> +		ret = -EINVAL;
>> +		goto err_release_regions;
>>   	}
>>   	if (height < 100 || height > 10000) {
>>   		pci_err(pdev, "height (%d) out of range\n", height);
>> -		return -EINVAL;
>> +		ret = -EINVAL;
>> +		goto err_release_regions;
>>   	}
>>   	pci_info(pdev, "mdpy found: %dx%d framebuffer\n",
>>   		 width, height);
>>   
>>   	info = framebuffer_alloc(sizeof(struct mdpy_fb_par), &pdev->dev);
>> -	if (!info)
>> +	if (!info) {
>> +		ret = -ENOMEM;
>>   		goto err_release_regions;
>> +	}
>>   	pci_set_drvdata(pdev, info);
>>   	par = info->par;
>>   
>>
> 
> Thanks for adding the extra error cases.  Applied to vfio for-linus
> branch for v5.13.  Thanks,
> 
> Alex
> 
> 

Hi,
doesn't the initial pci_enable_device also requires a corresponding 
pci_disable_device, both in the error handling path, and in the remove 
function?

just my 2c,

CJ

