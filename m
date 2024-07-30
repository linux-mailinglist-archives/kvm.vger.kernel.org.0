Return-Path: <kvm+bounces-22581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CA9F940796
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 07:28:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A06151C22950
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 05:28:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5385E1684B4;
	Tue, 30 Jul 2024 05:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="tkJgpyGF"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D550153BF7;
	Tue, 30 Jul 2024 05:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.18.73.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722316917; cv=none; b=Cmwo9W6CuwohuyjEhacRAJaTVc7ublQtQYM3E82fdgDAAJ8y3aaAIOrm8CXdoprn6XSTiB2hDTValKIg6KAexmVRBOCsEEdmtpkwBf1SRgvAfYgXTIGamr0z6OTHsIpPoMPxeiY3PGpNrTl+IS+4p5isDkqQa1CI+Wg+w+ikEQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722316917; c=relaxed/simple;
	bh=Kk9Q3R4jaeKgwoXtf8T50QoXGM27YdMm/UT0HVVSXvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=PYJx1cuCPsPKrOmB7XvuI3IMps1og80hyHTzQBO5zpOgrYIxIwyGlD8RAa5uwvWD1mPGuiUsEWSRxsNJatqdl6nC0UXTeuL9mxQF6zG/x9Qh+j4NLs5iYFQ+v405m5XK5TwXCPOu8GOM618GxvXGX0A6E4/a1gw5NjKaomdJuRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=tkJgpyGF; arc=none smtp.client-ip=37.18.73.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Received: from p-infra-ksmg-sc-msk01.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id D1ADB10000E;
	Tue, 30 Jul 2024 08:21:43 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru D1ADB10000E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1722316903;
	bh=HltX1eHB+gX6/FvTdK5jTFQKH3MsCpYQvWl2DuJkA3Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=tkJgpyGF5AdvkBtheLV/1Gjn0MDuaK6RvazH8JrIxxpEoJCweReC3PILvSx+RLq81
	 brNejISPFG39LPM71bNMpQUu4BZesh/aPcNb8P1dc9jlP6FNIVu3bnLf0ltlLW+XQR
	 yV9do1oOhbYketRJVq4Y36RauYBqx1KjOjzaNq+foklJ6lX57RsdOb5zAAMd1vWBPP
	 8MlE6YoOJUqiwpZsO+WwdUXdStuombWNhNpmvKdrGCow7gqMQI1tz1xvDUsP6dVgUv
	 HlNd+kpk/gWN2KHG0V4Nq2L+kZExhnqEh1I3F39jCx/I68RJBFqVveyLO2px8lMchW
	 S4WuwJRTEP7fA==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Tue, 30 Jul 2024 08:21:43 +0300 (MSK)
Received: from [172.28.128.200] (100.64.160.123) by
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Tue, 30 Jul 2024 08:21:42 +0300
Message-ID: <41421bd7-e6e1-db2d-6a43-06d6a44cfeb8@salutedevices.com>
Date: Tue, 30 Jul 2024 08:09:23 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH net-next v6 07/14] virtio/vsock: add common datagram
 send path
Content-Language: en-US
To: Amery Hung <ameryhung@gmail.com>
CC: <stefanha@redhat.com>, <sgarzare@redhat.com>, <mst@redhat.com>,
	<jasowang@redhat.com>, <xuanzhuo@linux.alibaba.com>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<kys@microsoft.com>, <haiyangz@microsoft.com>, <wei.liu@kernel.org>,
	<decui@microsoft.com>, <bryantan@vmware.com>, <vdasa@vmware.com>,
	<pv-drivers@vmware.com>, <dan.carpenter@linaro.org>,
	<simon.horman@corigine.com>, <oxffffaa@gmail.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<bpf@vger.kernel.org>, <bobby.eshleman@bytedance.com>,
	<jiang.wang@bytedance.com>, <amery.hung@bytedance.com>,
	<xiyou.wangcong@gmail.com>, <kernel@sberdevices.ru>
References: <20240710212555.1617795-8-amery.hung@bytedance.com>
 <e1647f5f-5056-5cf0-e81c-5ef71fd6efd0@salutedevices.com>
 <CAMB2axMXzcxrFr+zWV6CFJxDrKwH+U85F7dkeXfJjAO10EmSAg@mail.gmail.com>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <CAMB2axMXzcxrFr+zWV6CFJxDrKwH+U85F7dkeXfJjAO10EmSAg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 186782 [Jul 29 2024]
X-KSMG-AntiSpam-Version: 6.1.0.4
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 24 0.3.24 186c4d603b899ccfd4883d230c53f273b80e467f, {Tracking_from_domain_doesnt_match_to}, 100.64.160.123:7.1.2;salutedevices.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;smtp.sberdevices.ru:5.0.1,7.1.1;127.0.0.199:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/07/30 01:23:00 #26176971
X-KSMG-AntiVirus-Status: Clean, skipped



On 30.07.2024 01:51, Amery Hung wrote:
> On Mon, Jul 29, 2024 at 1:12 PM Arseniy Krasnov
> <avkrasnov@salutedevices.com> wrote:
>>
>> Hi,
>>
>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>> index a1c76836d798..46cd1807f8e3 100644
>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>> @@ -1040,13 +1040,98 @@ int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
>>>  }
>>>  EXPORT_SYMBOL_GPL(virtio_transport_shutdown);
>>>
>>> +static int virtio_transport_dgram_send_pkt_info(struct vsock_sock *vsk,
>>> +                                             struct virtio_vsock_pkt_info *info)
>>> +{
>>> +     u32 src_cid, src_port, dst_cid, dst_port;
>>> +     const struct vsock_transport *transport;
>>> +     const struct virtio_transport *t_ops;
>>> +     struct sock *sk = sk_vsock(vsk);
>>> +     struct virtio_vsock_hdr *hdr;
>>> +     struct sk_buff *skb;
>>> +     void *payload;
>>> +     int noblock = 0;
>>> +     int err;
>>> +
>>> +     info->type = virtio_transport_get_type(sk_vsock(vsk));
>>> +
>>> +     if (info->pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
>>> +             return -EMSGSIZE;
>>
>> Small suggestion, i think we can check for packet length earlier ? Before
>> info->type = ...
> 
> Certainly.
> 
>>
>>> +
>>> +     transport = vsock_dgram_lookup_transport(info->remote_cid, info->remote_flags);
>>> +     t_ops = container_of(transport, struct virtio_transport, transport);
>>> +     if (unlikely(!t_ops))
>>> +             return -EFAULT;
>>> +
>>> +     if (info->msg)
>>> +             noblock = info->msg->msg_flags & MSG_DONTWAIT;
>>> +
>>> +     /* Use sock_alloc_send_skb to throttle by sk_sndbuf. This helps avoid
>>> +      * triggering the OOM.
>>> +      */
>>> +     skb = sock_alloc_send_skb(sk, info->pkt_len + VIRTIO_VSOCK_SKB_HEADROOM,
>>> +                               noblock, &err);
>>> +     if (!skb)
>>> +             return err;
>>> +
>>> +     skb_reserve(skb, VIRTIO_VSOCK_SKB_HEADROOM);
>>> +
>>> +     src_cid = t_ops->transport.get_local_cid();
>>> +     src_port = vsk->local_addr.svm_port;
>>> +     dst_cid = info->remote_cid;
>>> +     dst_port = info->remote_port;
>>> +
>>> +     hdr = virtio_vsock_hdr(skb);
>>> +     hdr->type       = cpu_to_le16(info->type);
>>> +     hdr->op         = cpu_to_le16(info->op);
>>> +     hdr->src_cid    = cpu_to_le64(src_cid);
>>> +     hdr->dst_cid    = cpu_to_le64(dst_cid);
>>> +     hdr->src_port   = cpu_to_le32(src_port);
>>> +     hdr->dst_port   = cpu_to_le32(dst_port);
>>> +     hdr->flags      = cpu_to_le32(info->flags);
>>> +     hdr->len        = cpu_to_le32(info->pkt_len);
>>
>> There is function 'virtio_transport_init_hdr()' in this file, may be reuse it ?
> 
> Will do.
> 
>>
>>> +
>>> +     if (info->msg && info->pkt_len > 0) {
>>
>> If pkt_len is 0, do we really need to send such packets ? Because for connectible
>> sockets, we ignore empty OP_RW packets.
> 
> Thanks for pointing this out. I think virtio dgram should also follow that.
> 
>>
>>> +             payload = skb_put(skb, info->pkt_len);
>>> +             err = memcpy_from_msg(payload, info->msg, info->pkt_len);
>>> +             if (err)
>>> +                     goto out;
>>> +     }
>>> +
>>> +     trace_virtio_transport_alloc_pkt(src_cid, src_port,
>>> +                                      dst_cid, dst_port,
>>> +                                      info->pkt_len,
>>> +                                      info->type,
>>> +                                      info->op,
>>> +                                      info->flags,
>>> +                                      false);
>>
>> ^^^ For SOCK_DGRAM, include/trace/events/vsock_virtio_transport_common.h also should
>> be updated?
> 
> Can you elaborate what needs to be changed?

Sure, there are:

TRACE_DEFINE_ENUM(VIRTIO_VSOCK_TYPE_STREAM);
TRACE_DEFINE_ENUM(VIRTIO_VSOCK_TYPE_SEQPACKET);

#define show_type(val) \
	__print_symbolic(val, \
			 { VIRTIO_VSOCK_TYPE_STREAM, "STREAM" }, \
			 { VIRTIO_VSOCK_TYPE_SEQPACKET, "SEQPACKET" })

I guess SOCK_DGRAM handling should be added to print type of socket.

Thanks, Arseniy

> 
> Thank you,
> Amery
> 
>>
>>> +
>>> +     return t_ops->send_pkt(skb);
>>> +out:
>>> +     kfree_skb(skb);
>>> +     return err;
>>> +}
>>> +
>>>  int
>>>  virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
>>>                              struct sockaddr_vm *remote_addr,
>>>                              struct msghdr *msg,
>>>                              size_t dgram_len)
>>>  {
>>> -     return -EOPNOTSUPP;
>>> +     /* Here we are only using the info struct to retain style uniformity
>>> +      * and to ease future refactoring and merging.
>>> +      */
>>> +     struct virtio_vsock_pkt_info info = {
>>> +             .op = VIRTIO_VSOCK_OP_RW,
>>> +             .remote_cid = remote_addr->svm_cid,
>>> +             .remote_port = remote_addr->svm_port,
>>> +             .remote_flags = remote_addr->svm_flags,
>>> +             .msg = msg,
>>> +             .vsk = vsk,
>>> +             .pkt_len = dgram_len,
>>> +     };
>>> +
>>> +     return virtio_transport_dgram_send_pkt_info(vsk, &info);
>>>  }
>>>  EXPORT_SYMBOL_GPL(virtio_transport_dgram_enqueue);
>>>
>>> --
>>> 2.20.1
>>
>> Thanks, Arseniy

