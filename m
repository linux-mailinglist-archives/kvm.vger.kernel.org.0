Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E261A7882
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 12:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438449AbgDNKff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 06:35:35 -0400
Received: from foss.arm.com ([217.140.110.172]:52704 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438411AbgDNKe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 06:34:28 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 934D41FB;
        Tue, 14 Apr 2020 03:26:51 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C394B3F6C4;
        Tue, 14 Apr 2020 03:26:50 -0700 (PDT)
Subject: Re: [PATCH v3 kvmtool 14/32] virtio: Don't ignore initialization
 failures
To:     =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>,
        kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
 <20200326152438.6218-15-alexandru.elisei@arm.com>
 <9cb9e14b-ab07-48ec-819f-11fe727c88b1@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <7a7a8443-4122-4f35-bdb1-cf1326aa2ac7@arm.com>
Date:   Tue, 14 Apr 2020 11:27:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <9cb9e14b-ab07-48ec-819f-11fe727c88b1@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 3/30/20 10:30 AM, André Przywara wrote:
> Hi,
>
> On 26/03/2020 15:24, Alexandru Elisei wrote:
>> Don't ignore an error in the bus specific initialization function in
>> virtio_init; don't ignore the result of virtio_init; and don't return 0
>> in virtio_blk__init and virtio_scsi__init when we encounter an error.
>> Hopefully this will save some developer's time debugging faulty virtio
>> devices in a guest.
>>
>> To take advantage of the cleanup function virtio_blk__exit, we have
>> moved appending the new device to the list before the call to
>> virtio_init.
>>
>> To safeguard against this in the future, virtio_init has been annoted
>> with the compiler attribute warn_unused_result.
> This is a good idea, but actually triggers an unrelated, long standing
> bug in vesa.c (on x86):
> hw/vesa.c: In function ‘vesa__init’:
> hw/vesa.c:77:3: error: ignoring return value of ‘ERR_PTR’, declared with
> attribute warn_unused_result [-Werror=unused-result]
>    ERR_PTR(-errno);
>    ^
> cc1: all warnings being treated as errors
>
> So could you add the missing "return" statement in that line, to fix
> that bug?
> I see that this gets rectified two patches later, but for the sake of
> bisect-ability it would be good to keep this compilable all the way through.

You're right, I'll fix it here.

>
>> diff --git a/virtio/net.c b/virtio/net.c
>> index 091406912a24..425c13ba1136 100644
>> --- a/virtio/net.c
>> +++ b/virtio/net.c
>> @@ -910,7 +910,7 @@ done:
>>  
>>  static int virtio_net__init_one(struct virtio_net_params *params)
>>  {
>> -	int i, err;
>> +	int i, r;
>>  	struct net_dev *ndev;
>>  	struct virtio_ops *ops;
>>  	enum virtio_trans trans = VIRTIO_DEFAULT_TRANS(params->kvm);
>> @@ -920,10 +920,8 @@ static int virtio_net__init_one(struct virtio_net_params *params)
>>  		return -ENOMEM;
>>  
>>  	ops = malloc(sizeof(*ops));
>> -	if (ops == NULL) {
>> -		err = -ENOMEM;
>> -		goto err_free_ndev;
>> -	}
>> +	if (ops == NULL)
>> +		return -ENOMEM;
>>  
>>  	list_add_tail(&ndev->list, &ndevs);
> As mentioned in the reply to the v2 version, I think this is still
> leaking memory here.

Yes, the leak is there. I didn't realize that virtio_net__exit doesn't do any
free'ing at all.

I find it a bit strange that we copy net_dev_virtio_ops for each device instance.
I suspect that passing the pointer to the static struct to virtio_init would have
been enough (this is what blk does), but I might be missing something. I don't
want to introduce a regression, so I'll keep the memory allocation and free it on
error.

Thanks,
Alex
