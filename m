Return-Path: <kvm+bounces-57252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE7F2B521B7
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 22:23:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 290BD3B1328
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 20:23:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63CD72EFDA2;
	Wed, 10 Sep 2025 20:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="FaVafSnw"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEF12459DC;
	Wed, 10 Sep 2025 20:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757535776; cv=none; b=nk8ejiLnH+O/qFjrtyBE2bYe4dJhDTffhHaZ/NQKV59ID3T3oZ9ybxATI7wu1URNfdp/1xaSpB6eRddJvoXZ3vekl4ieT9BMPYv2Xfklb36Ai8fgqpPQrEhNTDB/cn9d1ADWU9PRtSaLZ5uwOvFR3HNHwB6E+9tQVu/Ma7IizVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757535776; c=relaxed/simple;
	bh=YwO4gMk2mnlMzohuneCtT2WGU12Kui0FL8bRdjGl9hg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NiuWgVuDynKA0gqKO0KKaM4QCupHZ0wAhEtL0UsvbY1g5djRJV3N8vBWxNgWbCxpTI3hVjR0HFa1ZlD9cWJdyNIW1WKG2lbmJZrBlMpdx2E6pVyZOAw8rjdy5RIedtC/ATvG3oj9wtLIYyuCV7QeS8Elbgie2HhMIVqSzfxZVz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=FaVafSnw; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [192.168.178.143] (p5dc883a3.dip0.t-ipconnect.de [93.200.131.163])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 58AKMmqA009423
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 22:22:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1757535769;
	bh=YwO4gMk2mnlMzohuneCtT2WGU12Kui0FL8bRdjGl9hg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FaVafSnw8qOG0/JKXegDUcD4QkFqElFRSK7CBcF3cpFiqxRWzXe2V9ydLznh+ZtEn
	 qL+3u1YvG+eV3pyGQ+3lrGtODn6NsL+30ltjZWbzV3BuN1glvMcYKAuWJnTRlfFqZv
	 9qCV/AmOvM39dgeLa+VqqZCIMsM/P/0AN9wZdVMA=
Message-ID: <2ce87e4c-43f4-4931-846b-10ddff4a64dc@tu-dortmund.de>
Date: Wed, 10 Sep 2025 22:22:48 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 4/4] netdev queue flow control for vhost_net
To: Jason Wang <jasowang@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: mst@redhat.com, eperezma@redhat.com, stephen@networkplumber.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org,
        Tim Gebauer <tim.gebauer@tu-dortmund.de>
References: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
 <20250902080957.47265-5-simon.schippers@tu-dortmund.de>
 <willemdebruijn.kernel.251eacee11eca@gmail.com>
 <CACGkMEshZGJfh+Og_xrPeZYoWkBAcvqW8e93_DCr7ix4oOaP8Q@mail.gmail.com>
 <willemdebruijn.kernel.372e97487ad8b@gmail.com>
 <CACGkMEtv+TKu+yBc_+WQsUj3UKqrRPvOVMGFDr7mB3zPHsW=wQ@mail.gmail.com>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <CACGkMEtv+TKu+yBc_+WQsUj3UKqrRPvOVMGFDr7mB3zPHsW=wQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Jason Wang wrote:
> On Wed, Sep 3, 2025 at 9:52 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
>>
>> Jason Wang wrote:
>>> On Wed, Sep 3, 2025 at 5:31 AM Willem de Bruijn
>>> <willemdebruijn.kernel@gmail.com> wrote:
>>>>
>>>> Simon Schippers wrote:
>>>>> Stopping the queue is done in tun_net_xmit.
>>>>>
>>>>> Waking the queue is done by calling one of the helpers,
>>>>> tun_wake_netdev_queue and tap_wake_netdev_queue. For that, in
>>>>> get_wake_netdev_queue, the correct method is determined and saved in the
>>>>> function pointer wake_netdev_queue of the vhost_net_virtqueue. Then, each
>>>>> time after consuming a batch in vhost_net_buf_produce, wake_netdev_queue
>>>>> is called.
>>>>>
>>>>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>>>>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>>>>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
>>>>> ---
>>>>>  drivers/net/tap.c      |  6 ++++++
>>>>>  drivers/net/tun.c      |  6 ++++++
>>>>>  drivers/vhost/net.c    | 34 ++++++++++++++++++++++++++++------
>>>>>  include/linux/if_tap.h |  2 ++
>>>>>  include/linux/if_tun.h |  3 +++
>>>>>  5 files changed, 45 insertions(+), 6 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
>>>>> index 4d874672bcd7..0bad9e3d59af 100644
>>>>> --- a/drivers/net/tap.c
>>>>> +++ b/drivers/net/tap.c
>>>>> @@ -1198,6 +1198,12 @@ struct socket *tap_get_socket(struct file *file)
>>>>>  }
>>>>>  EXPORT_SYMBOL_GPL(tap_get_socket);
>>>>>
>>>>> +void tap_wake_netdev_queue(struct file *file)
>>>>> +{
>>>>> +     wake_netdev_queue(file->private_data);
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(tap_wake_netdev_queue);
>>>>> +
>>>>>  struct ptr_ring *tap_get_ptr_ring(struct file *file)
>>>>>  {
>>>>>       struct tap_queue *q;
>>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>>>> index 735498e221d8..e85589b596ac 100644
>>>>> --- a/drivers/net/tun.c
>>>>> +++ b/drivers/net/tun.c
>>>>> @@ -3739,6 +3739,12 @@ struct socket *tun_get_socket(struct file *file)
>>>>>  }
>>>>>  EXPORT_SYMBOL_GPL(tun_get_socket);
>>>>>
>>>>> +void tun_wake_netdev_queue(struct file *file)
>>>>> +{
>>>>> +     wake_netdev_queue(file->private_data);
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(tun_wake_netdev_queue);
>>>>
>>>> Having multiple functions with the same name is tad annoying from a
>>>> cscape PoV, better to call the internal functions
>>>> __tun_wake_netdev_queue, etc.
>>>>
>>>>> +
>>>>>  struct ptr_ring *tun_get_tx_ring(struct file *file)
>>>>>  {
>>>>>       struct tun_file *tfile;
>>>>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
>>>>> index 6edac0c1ba9b..e837d3a334f1 100644
>>>>> --- a/drivers/vhost/net.c
>>>>> +++ b/drivers/vhost/net.c
>>>>> @@ -130,6 +130,7 @@ struct vhost_net_virtqueue {
>>>>>       struct vhost_net_buf rxq;
>>>>>       /* Batched XDP buffs */
>>>>>       struct xdp_buff *xdp;
>>>>> +     void (*wake_netdev_queue)(struct file *f);
>>>>
>>>> Indirect function calls are expensive post spectre. Probably
>>>> preferable to just have a branch.
>>>>
>>>> A branch in `file->f_op != &tun_fops` would be expensive still as it
>>>> may touch a cold cacheline.
>>>>
>>>> How about adding a bit in struct ptr_ring itself. Pahole shows plenty
>>>> of holes. Jason, WDYT?
>>>>
>>>
>>> I'm not sure I get the idea, did you mean a bit for classifying TUN
>>> and TAP? If this is, I'm not sure it's a good idea as ptr_ring should
>>> have no knowledge of its user.
>>
>> That is what I meant.
>>
>>> Consider there were still indirect calls to sock->ops, maybe we can
>>> start from the branch.
>>
>> What do you mean?
>>
>> Tangential: if indirect calls really are needed in a hot path, e.g.,
>> to maintain this isolation of ptr_ring from its users, then
>> INDIRECT_CALL wrappers can be used to avoid the cost.
>>
>> That too effectively breaks the isolation between caller and callee.
>> But only for the most important N callers that are listed in the
>> INDIRECT_CALL_? wrapper.
> 
> Yes, I mean we can try to store the flag for example vhost_virtqueue struct.
> 
> Thanks
> 

I would just save the flag in the vhost_virtqueue struct as:

enum if_type {IF_NONE = 0, TUN, TAP} type;

Is this how you would implement it?


Apart from that, I found that vhost_net would eventually not wake anymore.
This results in a dead interface. I rewrote my implementation to tackle
this issue apart from the other requested changes. I will test it, run
pktgen benchmarks, and then post a v5, but this will probably take me more
time.

Thanks!

