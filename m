Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB4B63CCC7
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 02:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbiK3BUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 20:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiK3BUR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 20:20:17 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553A9711AF;
        Tue, 29 Nov 2022 17:20:16 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NMLw72ZWvz15N2Y;
        Wed, 30 Nov 2022 09:19:35 +0800 (CST)
Received: from dggpemm500002.china.huawei.com (7.185.36.229) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 30 Nov 2022 09:20:14 +0800
Received: from [10.174.178.247] (10.174.178.247) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 30 Nov 2022 09:20:14 +0800
Subject: Re: [PATCH] vfio/platform: Remove the ACPI buffer memory to fix
 memory leak
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sinan Kaya <okaya@codeaurora.org>
References: <1669116598-25761-1-git-send-email-guohanjun@huawei.com>
 <20221129125238.4ecdb3f0.alex.williamson@redhat.com>
From:   Hanjun Guo <guohanjun@huawei.com>
Message-ID: <7bba3368-7191-8316-021e-5e2fc5a44020@huawei.com>
Date:   Wed, 30 Nov 2022 09:20:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20221129125238.4ecdb3f0.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.247]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/30 3:52, Alex Williamson wrote:
> On Tue, 22 Nov 2022 19:29:58 +0800
> Hanjun Guo <guohanjun@huawei.com> wrote:
> 
>> The ACPI buffer memory (buffer.pointer) returned by acpi_evaluate_object()
>> is not used after the call of _RST method, so it leads to memory leak.
>>
>> For the calling of ACPI _RST method, we don't need to pass a buffer
>> for acpi_evaluate_object(), we can just pass NULL and remove the ACPI
>> buffer memory in vfio_platform_acpi_call_reset(), then we don't need to
>> free the memory and no memory leak.
>>
>> Fixes: d30daa33ec1d ("vfio: platform: call _RST method when using ACPI")
>> Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
>> ---
>>   drivers/vfio/platform/vfio_platform_common.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
>> index 55dc4f4..1a0a238 100644
>> --- a/drivers/vfio/platform/vfio_platform_common.c
>> +++ b/drivers/vfio/platform/vfio_platform_common.c
>> @@ -72,12 +72,11 @@ static int vfio_platform_acpi_call_reset(struct vfio_platform_device *vdev,
>>   				  const char **extra_dbg)
>>   {
>>   #ifdef CONFIG_ACPI
>> -	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
>>   	struct device *dev = vdev->device;
>>   	acpi_handle handle = ACPI_HANDLE(dev);
>>   	acpi_status acpi_ret;
>>   
>> -	acpi_ret = acpi_evaluate_object(handle, "_RST", NULL, &buffer);
>> +	acpi_ret = acpi_evaluate_object(handle, "_RST", NULL, NULL);
>>   	if (ACPI_FAILURE(acpi_ret)) {
>>   		if (extra_dbg)
>>   			*extra_dbg = acpi_format_exception(acpi_ret);
> 
> An identical change was already posted and accepted into the vfio next
> branch, see:
> 
> https://lore.kernel.org/all/20221018152825.891032-1-rafaelmendsr@gmail.com/
> 
> In linux-next as:
> 
> e67e070632a6 ("vfio: platform: Do not pass return buffer to ACPI _RST method")

Thanks, I missed this patch, please drop this one.

Thanks
Hanjun
