Return-Path: <kvm+bounces-67548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 902ABD085F2
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 10:58:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E21FA3019DE3
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 09:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A3C2336ED2;
	Fri,  9 Jan 2026 09:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="hxFCMl+I"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A563358BA;
	Fri,  9 Jan 2026 09:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767952649; cv=none; b=Yu7jGWW1wqd6j8VnOfBnQu3cdQ/Vjmut/Nhci517/yp5mDD9lJvM6EqjsJxzbXeEgm9V+90jsHynL89n5pg5VATK+1JHCu6QX3OdelY8fm1y4pufXnRT757Nt7NfjJknToJr25WJOW99qRagZd7kAbPtEIGp+Hjv8CgUjakzJgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767952649; c=relaxed/simple;
	bh=M1qmy86SHZvWLo4r8+7G1n+HTnEPqHQke1+1swI55bA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qCQusGPimo1sEf1VE7EKBVZLXrbJWxhpNxfKLIQLG5aG0pnCYrzB4nKrrgRIRehqrM8qSADVWFPgQbyA603hAbsr34JefbqnwmJC9sixcqqlzqKvrxXxcATXy/aHzeGRVDyVkb+rjnFeW2zHxXsnEy0w6yX180QSPjPUOnnYlgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=hxFCMl+I; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [129.217.186.165] ([129.217.186.165])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 6099vHq4004261
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 9 Jan 2026 10:57:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1767952639;
	bh=M1qmy86SHZvWLo4r8+7G1n+HTnEPqHQke1+1swI55bA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hxFCMl+IlmnD5oQ1CQu1M4EaVYRTK+qhszYZagf+xK+38mY4iJQ0P0OkWJ81GZ1dV
	 yjKcWyle3X1gtoOEdG22WTNAR3o9C1gfYJqH5QeaGI1sNqCI7DNsdlc/kemMw6flBX
	 RdUqsKUJJEcwUAj3H1sOzr7yKRxgq7gB9h2pxnAQ=
Message-ID: <0ae9071b-6d76-4336-8aee-d0338eecc6f5@tu-dortmund.de>
Date: Fri, 9 Jan 2026 10:57:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH net-next v7 7/9] vhost-net: vhost-net: replace rx_ring with
 tun/tap ring wrappers
To: Jason Wang <jasowang@redhat.com>
Cc: willemdebruijn.kernel@gmail.com, andrew+netdev@lunn.ch,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, eperezma@redhat.com,
        leiyang@redhat.com, stephen@networkplumber.org, jon@nutanix.com,
        tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
 <20260107210448.37851-8-simon.schippers@tu-dortmund.de>
 <CACGkMEtndGm+GX+3Kn5AWTkEc+PK0Fo1=VSZzhgBQoYRQbicQw@mail.gmail.com>
 <5961e982-9c52-4e7a-b1ca-caaf4c4d0291@tu-dortmund.de>
 <CACGkMEsKFcsumyNU6vVgBE4LjYWNb2XQNaThwd9H5eZ+RjSwfQ@mail.gmail.com>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <CACGkMEsKFcsumyNU6vVgBE4LjYWNb2XQNaThwd9H5eZ+RjSwfQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/9/26 07:04, Jason Wang wrote:
> On Thu, Jan 8, 2026 at 3:48 PM Simon Schippers
> <simon.schippers@tu-dortmund.de> wrote:
>>
>> On 1/8/26 05:38, Jason Wang wrote:
>>> On Thu, Jan 8, 2026 at 5:06 AM Simon Schippers
>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>
>>>> Replace the direct use of ptr_ring in the vhost-net virtqueue with
>>>> tun/tap ring wrapper helpers. Instead of storing an rx_ring pointer,
>>>> the virtqueue now stores the interface type (IF_TUN, IF_TAP, or IF_NONE)
>>>> and dispatches to the corresponding tun/tap helpers for ring
>>>> produce, consume, and unconsume operations.
>>>>
>>>> Routing ring operations through the tun/tap helpers enables netdev
>>>> queue wakeups, which are required for upcoming netdev queue flow
>>>> control support shared by tun/tap and vhost-net.
>>>>
>>>> No functional change is intended beyond switching to the wrapper
>>>> helpers.
>>>>
>>>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>>>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>>>> Co-developed by: Jon Kohler <jon@nutanix.com>
>>>> Signed-off-by: Jon Kohler <jon@nutanix.com>
>>>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
>>>> ---
>>>>  drivers/vhost/net.c | 92 +++++++++++++++++++++++++++++----------------
>>>>  1 file changed, 60 insertions(+), 32 deletions(-)
>>>>
>>>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
>>>> index 7f886d3dba7d..215556f7cd40 100644
>>>> --- a/drivers/vhost/net.c
>>>> +++ b/drivers/vhost/net.c
>>>> @@ -90,6 +90,12 @@ enum {
>>>>         VHOST_NET_VQ_MAX = 2,
>>>>  };
>>>>
>>>> +enum if_type {
>>>> +       IF_NONE = 0,
>>>> +       IF_TUN = 1,
>>>> +       IF_TAP = 2,
>>>> +};
>>>
>>> This looks not elegant, can we simply export objects we want to use to
>>> vhost like get_tap_socket()?
>>
>> No, we cannot do that. We would need access to both the ptr_ring and the
>> net_device. However, the net_device is protected by an RCU lock.
>>
>> That is why {tun,tap}_ring_consume_batched() are used:
>> they take the appropriate locks and handle waking the queue.
> 
> How about introducing a callback in the ptr_ring itself, so vhost_net
> only need to know about the ptr_ring?

That would be great, but I'm not sure whether this should be the
responsibility of the ptr_ring.

If the ptr_ring were to keep track of the netdev queue, it could handle
all the management itself - stopping the queue when full and waking it
again once space becomes available.

What would be your idea for implementing this?

> 
> Thanks
> 
>>
>>>
>>> Thanks
>>>
>>
> 

