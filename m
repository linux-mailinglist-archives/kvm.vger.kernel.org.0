Return-Path: <kvm+bounces-35560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB4A0A126EF
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 16:10:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A4D23A1F09
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 15:10:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37FAC143871;
	Wed, 15 Jan 2025 15:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b="AwXNj19h"
X-Original-To: kvm@vger.kernel.org
Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E085F14A605
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 15:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.40.203.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736953806; cv=none; b=SSAFZn+FYecQy7jFiFxlhg1OzE+FNqqctxj+x/SCKjYgIwetz2L320T7kICxf2ZxYDp6kka52VGyWeCGS1TD+vDRUWoOYJaKM1endM1OFOpQag9KLIoi+2uW+nt7PhWAlOxF0sBFSCCUq9S9t9iqMhTJFwvJf4NWFaP58ExTngA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736953806; c=relaxed/simple;
	bh=6XhhXqhcVssh3cjK6A1p3fdKdh8S0ukNKjQu+rfwMJs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qDncRkEktwKEr0i77g02AxoREZhu33TYEpZuLYZy7RXP393IezuBSa0LKKwZaMwcF43wwUibEOKV008LKgDPBoPOejGJ6ToZAXIi/BGcOhklWexXSmowHAuCsqmCVgkySwdbc3tQpa3JCE20LOcfMqG/MiyNvuyL1qZGqWlkZTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codethink.co.uk; spf=pass smtp.mailfrom=codethink.co.uk; dkim=pass (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b=AwXNj19h; arc=none smtp.client-ip=188.40.203.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codethink.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codethink.co.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap4-20230908; h=Sender:Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=DkjE96czU4TMVOiXa/WdjTw79QTVIDfjRS/7gx9UJkA=; b=AwXNj19hE4XqvfN4uaiCENRnnM
	YxNuqXxmRRubgmRvf2SkdxjIbBfjh92xEAXvMi/mjYsUdwvCWjWNT22XYpWczAMgymBEsjnrsOeeA
	VYhu8472EoBpNU83OlLk5M4g6SHWf8oS95llR/g/QAT35LxDGXjfh5seZ8PZHqarBI8rfeUZnmxTy
	KRaB5AIVixKNVBxixMyDzwvNY2aquODKi2wkCLphA6drDYax/XLFWvnPor+TsZxnkEaVE95okvNna
	CCMWTJgA8MSwkrGCNvSIwxiAsuyRhaa9IU2048yHndcOAmE+l8RcfbxdHCGnktIRbmw2EBWxS0Y7F
	dGFUODCw==;
Received: from [63.135.74.212] (helo=[192.168.1.184])
	by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1tY51r-000hmj-Ff; Wed, 15 Jan 2025 15:09:59 +0000
Message-ID: <01e504c1-58d3-4652-9366-1f518b7bd86e@codethink.co.uk>
Date: Wed, 15 Jan 2025 15:09:58 +0000
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
Content-Language: en-GB
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
In-Reply-To: <20250115-73a1112ddbc729143d052afb@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: ben.dooks@codethink.co.uk

On 15/01/2025 14:24, Andrew Jones wrote:
> On Wed, Jan 15, 2025 at 10:11:25AM +0000, Ben Dooks wrote:
>> When running on a big endian host, the virtio mmio-modern.c correctly
>> sets all reads to return little endian values. However the header uses
>> a 4 byte char for the magic value, which is always going to be in the
>> correct endian regardless of host endian.
>>
>> To make the simplest change, simply avoid endian convresion of the
>> read of the magic value. This fixes the following bug from the guest:
>>
>> [    0.592838] virtio-mmio 10020000.virtio: Wrong magic value 0x76697274!
>>
>> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
>> ---
>>   virtio/mmio-modern.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/virtio/mmio-modern.c b/virtio/mmio-modern.c
>> index 6c0bb38..fd9c0cb 100644
>> --- a/virtio/mmio-modern.c
>> +++ b/virtio/mmio-modern.c
>> @@ -66,7 +66,10 @@ static void virtio_mmio_config_in(struct kvm_cpu *vcpu,
>>   		return;
>>   	}
>>   
>> -	*data = cpu_to_le32(val);
>> +	if (addr != VIRTIO_MMIO_MAGIC_VALUE)
>> +		*data = cpu_to_le32(val);
>> +	else
>> +		*data = val;
>>   }
>>   
>>   static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
>> -- 
>> 2.37.2.352.g3c44437643
>>
> 
> I think vendor_id should also have the same issue, but drivers don't
> notice because they all use VIRTIO_DEV_ANY_ID. So how about the
> change below instead?
> 
> Thanks,
> drew
> 
> diff --git a/include/kvm/virtio-mmio.h b/include/kvm/virtio-mmio.h
> index b428b8d32f48..133817c1dc44 100644
> --- a/include/kvm/virtio-mmio.h
> +++ b/include/kvm/virtio-mmio.h
> @@ -18,7 +18,7 @@ struct virtio_mmio_ioevent_param {
>   };
> 
>   struct virtio_mmio_hdr {
> -       char    magic[4];
> +       u32     magic;
>          u32     version;
>          u32     device_id;
>          u32     vendor_id;
> diff --git a/virtio/mmio.c b/virtio/mmio.c
> index fae73b52dae0..782268e8f842 100644
> --- a/virtio/mmio.c
> +++ b/virtio/mmio.c
> @@ -6,6 +6,7 @@
>   #include "kvm/irq.h"
>   #include "kvm/fdt.h"
> 
> +#include <linux/byteorder.h>
>   #include <linux/virtio_mmio.h>
>   #include <string.h>
> 
> @@ -168,10 +169,10 @@ int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>                  return r;
> 
>          vmmio->hdr = (struct virtio_mmio_hdr) {
> -               .magic          = {'v', 'i', 'r', 't'},
> +               .magic          = le32_to_cpu(0x74726976), /* 'virt' */


just doing the change of magic type and then doing
	.magic = 0x74726976;

should work, as then magic is in host order amd will get converted
to le32 in the IO code. Don't think vendor_id suffers as it was
converted from string to hex.

>                  .version        = legacy ? 1 : 2,
>                  .device_id      = subsys_id,
> -               .vendor_id      = 0x4d564b4c , /* 'LKVM' */
> +               .vendor_id      = le32_to_cpu(0x4d564b4c), /* 'LKVM' */
>                  .queue_num_max  = 256,
>          };
> 


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

https://www.codethink.co.uk/privacy.html

