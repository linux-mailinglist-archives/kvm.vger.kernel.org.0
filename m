Return-Path: <kvm+bounces-35765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1100BA14DC9
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 11:39:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8036518842A1
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 10:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C6481FC0F5;
	Fri, 17 Jan 2025 10:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b="opAnlRzp"
X-Original-To: kvm@vger.kernel.org
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEE11F91FF
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 10:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.40.148.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737110369; cv=none; b=CLaXQkuqJnCoRCALc4omha+XXyUZvFxmH0KKJYymCJCVi8EgUwr7F6t9h+xuTBzKxdARxXOEFmMwNR6D8lAtmYjNFf8xdrXJ0SBx1ExivtNkEDa83Ls+9mG6ijflL82WzLOg+geDiW1f17QitNLVCvznyzEcWBtnhq9VGVzNhPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737110369; c=relaxed/simple;
	bh=mbtjENaIu932I2dZxMZEecTSNyXFXwtP3N06YtRjxuQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hH1rvLIj8HRfIJSp8PxTjj4/4s3A9VlLcnLwY0nfGo/qleD/Wl8TUtPsCx6k9FGO53VsHdkZvttAF6+B8fDffbyrY+a54tgz8wIjwGGAUWy5ETMoowk78uQEe2FL83397RyVTAIzk9dYyoL+/CG8u95nNahqnvm8TPJtpFG25QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codethink.co.uk; spf=pass smtp.mailfrom=codethink.co.uk; dkim=pass (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b=opAnlRzp; arc=none smtp.client-ip=78.40.148.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codethink.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codethink.co.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap5-20230908; h=Sender:Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=eJEZXV6ErJzZgAb2S4mxKqHkE7EJGWkaUmJxlxdIwMo=; b=opAnlRzp9YY03rDguvYkpVKpQ1
	dimMYiLfMteqmySR0M7LCmMkFEwwFHjbGxoTAaDK4NjWeSvpVvLYFErzQIpsq0o/IiiULK5wmXWlj
	/DTPlr/hKWZ3DDqxAaNDzfdprMwz/SwLPalzncN5Q9SABfjSGj7MKISt4POTNCtFnI6xEphhiLxgV
	l2yJFvtW9hec6aYOwMzGj9iqpPGnnCzWm0L3nqa6Df/hOwss5zZXKukq3bFhCoO/VEwKBa/aGUtSp
	SjAJqUAbAVHBXeEibHU3RqqjqN1n5ANIUa4GO2MDbHm4vsDILSDFVVyZ0rbvw6VwY+KzcFlenk+p1
	eGLynzOQ==;
Received: from [167.98.27.226] (helo=[10.35.6.157])
	by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1tYj6X-007I2a-E9; Fri, 17 Jan 2025 09:57:29 +0000
Message-ID: <2509980e-028c-4d49-bb98-a864a9176212@codethink.co.uk>
Date: Fri, 17 Jan 2025 09:57:29 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool] kvmtool: virtio: fix endian for big endian hosts
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, felix.chong@codethink.co.uk,
 lawrence.hunter@codethink.co.uk, roan.richmond@codethink.co.uk
References: <20250115101125.526492-1-ben.dooks@codethink.co.uk>
 <20250115-73a1112ddbc729143d052afb@orel>
 <01e504c1-58d3-4652-9366-1f518b7bd86e@codethink.co.uk>
 <20250116-e80c8bf6f54d88dbd6d5e7a9@orel>
Content-Language: en-GB
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
In-Reply-To: <20250116-e80c8bf6f54d88dbd6d5e7a9@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: ben.dooks@codethink.co.uk

On 16/01/2025 09:28, Andrew Jones wrote:
> On Wed, Jan 15, 2025 at 03:09:58PM +0000, Ben Dooks wrote:
>> On 15/01/2025 14:24, Andrew Jones wrote:
>>> On Wed, Jan 15, 2025 at 10:11:25AM +0000, Ben Dooks wrote:
>>>> When running on a big endian host, the virtio mmio-modern.c correctly
>>>> sets all reads to return little endian values. However the header uses
>>>> a 4 byte char for the magic value, which is always going to be in the
>>>> correct endian regardless of host endian.
>>>>
>>>> To make the simplest change, simply avoid endian convresion of the
>>>> read of the magic value. This fixes the following bug from the guest:
>>>>
>>>> [    0.592838] virtio-mmio 10020000.virtio: Wrong magic value 0x76697274!
>>>>
>>>> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
>>>> ---
>>>>    virtio/mmio-modern.c | 5 ++++-
>>>>    1 file changed, 4 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/virtio/mmio-modern.c b/virtio/mmio-modern.c
>>>> index 6c0bb38..fd9c0cb 100644
>>>> --- a/virtio/mmio-modern.c
>>>> +++ b/virtio/mmio-modern.c
>>>> @@ -66,7 +66,10 @@ static void virtio_mmio_config_in(struct kvm_cpu *vcpu,
>>>>    		return;
>>>>    	}
>>>> -	*data = cpu_to_le32(val);
>>>> +	if (addr != VIRTIO_MMIO_MAGIC_VALUE)
>>>> +		*data = cpu_to_le32(val);
>>>> +	else
>>>> +		*data = val;
>>>>    }
>>>>    static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
>>>> -- 
>>>> 2.37.2.352.g3c44437643
>>>>
>>>
>>> I think vendor_id should also have the same issue, but drivers don't
>>> notice because they all use VIRTIO_DEV_ANY_ID. So how about the
>>> change below instead?
>>>
>>> Thanks,
>>> drew
>>>
>>> diff --git a/include/kvm/virtio-mmio.h b/include/kvm/virtio-mmio.h
>>> index b428b8d32f48..133817c1dc44 100644
>>> --- a/include/kvm/virtio-mmio.h
>>> +++ b/include/kvm/virtio-mmio.h
>>> @@ -18,7 +18,7 @@ struct virtio_mmio_ioevent_param {
>>>    };
>>>
>>>    struct virtio_mmio_hdr {
>>> -       char    magic[4];
>>> +       u32     magic;
>>>           u32     version;
>>>           u32     device_id;
>>>           u32     vendor_id;
>>> diff --git a/virtio/mmio.c b/virtio/mmio.c
>>> index fae73b52dae0..782268e8f842 100644
>>> --- a/virtio/mmio.c
>>> +++ b/virtio/mmio.c
>>> @@ -6,6 +6,7 @@
>>>    #include "kvm/irq.h"
>>>    #include "kvm/fdt.h"
>>>
>>> +#include <linux/byteorder.h>
>>>    #include <linux/virtio_mmio.h>
>>>    #include <string.h>
>>>
>>> @@ -168,10 +169,10 @@ int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>>>                   return r;
>>>
>>>           vmmio->hdr = (struct virtio_mmio_hdr) {
>>> -               .magic          = {'v', 'i', 'r', 't'},
>>> +               .magic          = le32_to_cpu(0x74726976), /* 'virt' */
>>
>>
>> just doing the change of magic type and then doing
>> 	.magic = 0x74726976;
>>
>> should work, as then magic is in host order amd will get converted
>> to le32 in the IO code. Don't think vendor_id suffers as it was
>> converted from string to hex.
> 
> Oh, right. I overthought that one. I prefer the magic in hex better than
> the special casing in virtio_mmio_config_in()
> 
> Thanks,
> drew

Ok, will wait a few days to see if anyone else has a comment.

I assume you're ok with me re-doing my patch?

Thanks for the review.


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

https://www.codethink.co.uk/privacy.html

