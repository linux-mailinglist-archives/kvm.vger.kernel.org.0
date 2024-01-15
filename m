Return-Path: <kvm+bounces-6193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E29482D41A
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 07:09:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85DB51C210FA
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 06:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A58E3C1D;
	Mon, 15 Jan 2024 06:08:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E708523C9;
	Mon, 15 Jan 2024 06:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: c819a6a9dd5b4ea4a0338b9af8a220bd-20240115
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:da766e3f-bb81-409e-8a90-63581af6cbea,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-9,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:1
X-CID-INFO: VERSION:1.1.35,REQID:da766e3f-bb81-409e-8a90-63581af6cbea,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-9,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:1
X-CID-META: VersionHash:5d391d7,CLOUDID:a056418e-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:240112233534SC8MATGQ,BulkQuantity:5,Recheck:0,SF:17|19|42|74|64|66|2
	4|102,TC:nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,Bulk:40,QS:nil,BEC:nil,
	COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_FSI,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-UUID: c819a6a9dd5b4ea4a0338b9af8a220bd-20240115
Received: from mail.kylinos.cn [(39.156.73.10)] by mailgw
	(envelope-from <chentao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1677585220; Mon, 15 Jan 2024 14:08:41 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 4D48CE000EB9;
	Mon, 15 Jan 2024 14:08:40 +0800 (CST)
X-ns-mid: postfix-65A4CBE8-226863207
Received: from [172.20.15.234] (unknown [172.20.15.234])
	by mail.kylinos.cn (NSMail) with ESMTPA id 22C68E000EB9;
	Mon, 15 Jan 2024 14:08:39 +0800 (CST)
Message-ID: <0063df77-aede-4365-819e-5ec8eb6c5b3f@kylinos.cn>
Date: Mon, 15 Jan 2024 14:08:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio/platform: Remove unnecessary free in
 vfio_set_trigger
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
Cc: eric.auger@redhat.com, a.motakis@virtualopensystems.com,
 b.reynal@virtualopensystems.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240112064107.137384-1-chentao@kylinos.cn>
 <20240112083447.750ad1c6.alex.williamson@redhat.com>
From: Kunwu Chan <chentao@kylinos.cn>
In-Reply-To: <20240112083447.750ad1c6.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/1/12 23:34, Alex Williamson wrote:
> On Fri, 12 Jan 2024 14:41:07 +0800
> Kunwu Chan <chentao@kylinos.cn> wrote:
> 
>> commit 57f972e2b341 ("vfio/platform: trigger an interrupt via eventfd")
>> add 'name' as member for vfio_platform_irq,it's initialed by kasprintf,
>> so there is no need to free it before initializing.
> 
> What?!  Just look at the call path where vfio_set_trigger() is called
> with a valid fd and existing trigger.  This change would leak irq->name
> as it's reallocated via kasprintf().  Thanks,
> 
> Alex
>   
>> Fixes: 57f972e2b341 ("vfio/platform: trigger an interrupt via eventfd")
>> Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
>> ---
>>   drivers/vfio/platform/vfio_platform_irq.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
>> index 61a1bfb68ac7..5e3fd1926366 100644
>> --- a/drivers/vfio/platform/vfio_platform_irq.c
>> +++ b/drivers/vfio/platform/vfio_platform_irq.c
>> @@ -179,7 +179,6 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
>>   	if (irq->trigger) {
>>   		irq_clear_status_flags(irq->hwirq, IRQ_NOAUTOEN);
>>   		free_irq(irq->hwirq, irq);
>> -		kfree(irq->name);
>>   		eventfd_ctx_put(irq->trigger);
>>   		irq->trigger = NULL;
>>   	}
> 
Thanks for your reply.

It's my bad.I misunderstood. Sorry to bother you.
-- 
Thanks,
   Kunwu


