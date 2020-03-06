Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8489F17BB7E
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 12:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgCFLUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 06:20:03 -0500
Received: from foss.arm.com ([217.140.110.172]:59840 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbgCFLUD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 06:20:03 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D031531B;
        Fri,  6 Mar 2020 03:20:02 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E81A13F6C4;
        Fri,  6 Mar 2020 03:20:01 -0800 (PST)
Subject: Re: [PATCH v2 kvmtool 15/30] virtio: Don't ignore initialization
 failures
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <20200123134805.1993-16-alexandru.elisei@arm.com>
 <20200130145120.0cad4a14@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <ad0199a8-bd18-4031-3489-eca9865b68fb@arm.com>
Date:   Fri, 6 Mar 2020 11:20:00 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200130145120.0cad4a14@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 1/30/20 2:51 PM, Andre Przywara wrote:
> On Thu, 23 Jan 2020 13:47:50 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
>> Don't ignore an error in the bus specific initialization function in
>> virtio_init; don't ignore the result of virtio_init; and don't return 0
>> in virtio_blk__init and virtio_scsi__init when we encounter an error.
>> Hopefully this will save some developer's time debugging faulty virtio
>> devices in a guest.
> Seems like the right thing to do, but I was wondering how you triggered this? AFAICS virtio_init only fails when calloc() fails or you pass an illegal transport, with the latter looking like being hard coded to one of the two supported.

I haven't triggered it. I found it by inspection. The transport-specific
initialization functions can fail for various reasons (ioport_register or
kvm__register_mmio can fail because some device emulation claimed all the MMIO
space or the MMIO space was configured incorrectly in the kvm-arch.h header file;
or memory allocation failed, etc) and this is the reason they return an int.
Because of this, virtio_init can fail and this is the reason it too returns an
int. It makes sense to check that the protocol that your device uses is actually
working.

>
> One minor thing below ...

[..]

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
> Doesn't that leave struct net_dev allocated? I am happy with removing the goto, but we should free(ndev) before we return, I think.

Nope, the cleanup routine in virtio_net__exit takes care of deallocating it (you
get there from virtio_net__init if virtio_net__init_one fails).

Thanks,
Alex
