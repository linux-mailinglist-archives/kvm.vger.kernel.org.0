Return-Path: <kvm+bounces-6191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BB7F82D413
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 07:07:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 501121F21504
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 06:07:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 418B63C0E;
	Mon, 15 Jan 2024 06:07:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B266823BF;
	Mon, 15 Jan 2024 06:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: b6efbbf3342945eeb8cd3bce98c8798a-20240115
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:15b0c6fb-d15b-4e9a-b893-df26ffdc9a02,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-5
X-CID-INFO: VERSION:1.1.35,REQID:15b0c6fb-d15b-4e9a-b893-df26ffdc9a02,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:5d391d7,CLOUDID:6057da82-8d4f-477b-89d2-1e3bdbef96d1,B
	ulkID:2401122330500VLWRBFO,BulkQuantity:4,Recheck:0,SF:44|64|66|24|17|19|1
	02,TC:nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,Bulk:40,QS:nil,BEC:nil,COL
	:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: b6efbbf3342945eeb8cd3bce98c8798a-20240115
Received: from mail.kylinos.cn [(39.156.73.10)] by mailgw
	(envelope-from <chentao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 982530335; Mon, 15 Jan 2024 14:07:09 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id B3869E000EB9;
	Mon, 15 Jan 2024 14:07:09 +0800 (CST)
X-ns-mid: postfix-65A4CB8D-608913184
Received: from [172.20.15.234] (unknown [172.20.15.234])
	by mail.kylinos.cn (NSMail) with ESMTPA id 6CC8DE000EB9;
	Mon, 15 Jan 2024 14:07:09 +0800 (CST)
Message-ID: <9e917782-03cd-493e-b6f1-c6170a265a38@kylinos.cn>
Date: Mon, 15 Jan 2024 14:07:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio: Fix NULL pointer dereference in
 vfio_pci_bus_notifier
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240112062221.135681-1-chentao@kylinos.cn>
 <20240112083026.7fd01b41.alex.williamson@redhat.com>
From: Kunwu Chan <chentao@kylinos.cn>
In-Reply-To: <20240112083026.7fd01b41.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/1/12 23:30, Alex Williamson wrote:
> On Fri, 12 Jan 2024 14:22:21 +0800
> Kunwu Chan <chentao@kylinos.cn> wrote:
> 
>> kasprintf() returns a pointer to dynamically allocated memory
>> which can be NULL upon failure. Ensure the allocation was successful
>> by checking the pointer validity.
>>
>> Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
>> ---
>>   drivers/vfio/pci/vfio_pci_core.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index 1cbc990d42e0..74e5b89a3a0c 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -2047,6 +2047,8 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
>>   			 pci_name(pdev));
>>   		pdev->driver_override = kasprintf(GFP_KERNEL, "%s",
>>   						  vdev->vdev.ops->name);
>> +		if (!pdev->driver_override)
>> +			return -ENOMEM;
>>   	} else if (action == BUS_NOTIFY_BOUND_DRIVER &&
>>   		   pdev->is_virtfn && physfn == vdev->pdev) {
>>   		struct pci_driver *drv = pci_dev_driver(pdev);
> 
> This is a blocking notifier callback, so errno isn't a proper return
> value, nor does it accomplish anything.  We're into the realm of
> worrying about small allocation failures here, which I understand
> essentially cannot happen, but about the best we could do at this
> point would be to WARN_ON if we weren't able to allocate an override.
Thanks for your reply.
I'll update v2 patch use WARN_ON to print some callstack msgs when we 
weren't able to allocate an override.

These msgs could reduce some of the worries and help us to find what happed.

> Thanks,
> 
> Alex
> 
-- 
Thanks,
   Kunwu


