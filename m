Return-Path: <kvm+bounces-22526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71CB093FE68
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 21:38:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5445B232AC
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 19:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C36921891D2;
	Mon, 29 Jul 2024 19:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="qd54Sj4a"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C4D187875;
	Mon, 29 Jul 2024 19:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722281909; cv=none; b=AIyOThAw2jmI6jjLrtAnwiKytY4bWQqyfUkeTtMpEEha1jkrdJWT5gC4RARcfRcsxbflDRw0IN2UUbR38o8feL/84Kbp/AcXfywnfEPCsmsVK+B5SDIz5u6kUcesWZLEpzqWD0/1n33ABM2VFhMT4D1iFb/gYTI5CIgcr6BIWn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722281909; c=relaxed/simple;
	bh=lHHV4zTdD1q9DpwHuQPQl8xYs1VEWH9oBF9zLkwshz0=;
	h=Message-ID:Date:MIME-Version:In-Reply-To:To:CC:From:Subject:
	 Content-Type; b=SAZ8Z+hfwiSS9sjUMIpfkCOUrMnjuhgKy7IVWfwJe/IbxQOruKsmSI6pN6XzSoGC1hsyoHB6PU6tgeITewJmdvfzXdEocD7SSqnfoPScfxp0qN7Eof/AvpCX3FUIFJB3Az8nSg6vfEBaJS030C6KO8pY2M80DGO+k/Qto5lTVnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=qd54Sj4a; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 7D394120002;
	Mon, 29 Jul 2024 22:38:15 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 7D394120002
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1722281895;
	bh=H1PeoFKA7L/nSsyhmpS5lW2+TNHnStcFo/+/1oEAYSI=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type:From;
	b=qd54Sj4azVTvA9atmOWvIcm56eAhS6YREDBOdAoHqZYn5jOVpe4fxCDlVFS/2dpdM
	 bKvvRFCuTrG3H40adyR7UDD7iaCY/Yl+kkW+DVS2sYeRhBc8+TyNTchyJE4By3HCrc
	 NzGBnt8CZL1fKBewQE20O72+CA7LVGBugYe890LQKxx4P5yuuoA8e/hgrgCpXcmawT
	 7BEXcb4dsVwnYG4fcmgFLHbTWHScAhKsIVeaNqxMZRK/0hsf8iuHEbgVfc7D7fC75d
	 s7FetSoG0flc2ej61nNwRv/7s92fhD9HOclXL4TudK1Ta9wAOjE2WxA9KG4ecug9BT
	 PIOfCOmmypSJg==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Mon, 29 Jul 2024 22:38:15 +0300 (MSK)
Received: from [172.28.128.200] (100.64.160.123) by
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Mon, 29 Jul 2024 22:38:13 +0300
Message-ID: <d1126dd8-cc6c-be20-7b55-83a0517d14d0@salutedevices.com>
Date: Mon, 29 Jul 2024 22:25:55 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <20240710212555.1617795-2-amery.hung@bytedance.com>
To: <stefanha@redhat.com>, <sgarzare@redhat.com>, <mst@redhat.com>,
	<jasowang@redhat.com>, <xuanzhuo@linux.alibaba.com>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<kys@microsoft.com>, <haiyangz@microsoft.com>, <wei.liu@kernel.org>,
	<decui@microsoft.com>, <bryantan@vmware.com>, <vdasa@vmware.com>,
	<pv-drivers@vmware.com>
CC: <dan.carpenter@linaro.org>, <simon.horman@corigine.com>,
	<oxffffaa@gmail.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<bpf@vger.kernel.org>, <bobby.eshleman@bytedance.com>,
	<jiang.wang@bytedance.com>, <amery.hung@bytedance.com>,
	<ameryhung@gmail.com>, <xiyou.wangcong@gmail.com>, <kernel@sberdevices.ru>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
Subject: [RFC PATCH net-next v6 01/14] af_vsock: generalize
 vsock_dgram_recvmsg() to all transports
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 186779 [Jul 29 2024]
X-KSMG-AntiSpam-Version: 6.1.0.4
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 24 0.3.24 186c4d603b899ccfd4883d230c53f273b80e467f, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;100.64.160.123:7.1.2;salutedevices.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;smtp.sberdevices.ru:5.0.1,7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/07/29 16:49:00 #26175127
X-KSMG-AntiVirus-Status: Clean, skipped

> @@ -1273,11 +1273,15 @@ static int vsock_dgram_connect(struct socket *sock,
>  int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
>  			size_t len, int flags)
>  {
> +	struct vsock_skb_cb *vsock_cb;
>  #ifdef CONFIG_BPF_SYSCALL
>  	const struct proto *prot;
>  #endif
>  	struct vsock_sock *vsk;
> +	struct sk_buff *skb;
> +	size_t payload_len;
>  	struct sock *sk;
> +	int err;
>  
>  	sk = sock->sk;
>  	vsk = vsock_sk(sk);
> @@ -1288,7 +1292,43 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
>  		return prot->recvmsg(sk, msg, len, flags, NULL);
>  #endif
>  
> -	return vsk->transport->dgram_dequeue(vsk, msg, len, flags);
> +	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
> +		return -EOPNOTSUPP;
> +
> +	if (unlikely(flags & MSG_ERRQUEUE))
> +		return sock_recv_errqueue(sk, msg, len, SOL_VSOCK, 0);
> +
> +	/* Retrieve the head sk_buff from the socket's receive queue. */
> +	err = 0;
> +	skb = skb_recv_datagram(sk_vsock(vsk), flags, &err);
> +	if (!skb)
> +		return err;
> +
> +	payload_len = skb->len;
> +
> +	if (payload_len > len) {
> +		payload_len = len;
> +		msg->msg_flags |= MSG_TRUNC;
> +	}
> +
> +	/* Place the datagram payload in the user's iovec. */
> +	err = skb_copy_datagram_msg(skb, 0, msg, payload_len);
> +	if (err)
> +		goto out;
> +
> +	if (msg->msg_name) {
> +		/* Provide the address of the sender. */
> +		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
> +
> +		vsock_cb = vsock_skb_cb(skb);

May be we can declare 'vsock_cb' here ? Reducing its scope.

> +		vsock_addr_init(vm_addr, vsock_cb->src_cid, vsock_cb->src_port);
> +		msg->msg_namelen = sizeof(*vm_addr);
> +	}
> +	err = payload_len;
> +
> +out:
> +	skb_free_datagram(&vsk->sk, skb);
> +	return err;
>  }
>  EXPORT_SYMBOL_GPL(vsock_dgram_recvmsg);
>  


> --- a/net/vmw_vsock/vmci_transport.c
> +++ b/net/vmw_vsock/vmci_transport.c
> @@ -610,6 +610,7 @@ vmci_transport_datagram_create_hnd(u32 resource_id,
>  
>  static int vmci_transport_recv_dgram_cb(void *data, struct vmci_datagram *dg)
>  {
> +	struct vsock_skb_cb *vsock_cb;
>  	struct sock *sk;
>  	size_t size;
>  	struct sk_buff *skb;
> @@ -637,10 +638,14 @@ static int vmci_transport_recv_dgram_cb(void *data, struct vmci_datagram *dg)
>  	if (!skb)
>  		return VMCI_ERROR_NO_MEM;
>  
> +	vsock_cb = vsock_skb_cb(skb);
> +	vsock_cb->src_cid = dg->src.context;
> +	vsock_cb->src_port = dg->src.resource;
>  	/* sk_receive_skb() will do a sock_put(), so hold here. */
>  	sock_hold(sk);
>  	skb_put(skb, size);
>  	memcpy(skb->data, dg, size);
> +	skb_pull(skb, VMCI_DG_HEADERSIZE);

Small suggestion: here we do:

1) skb_put(skb, size of entire datagram)
2) memcpy(entire datagram)
3) skb_pull(VMCI_DG_HEADERSIZE)

If we provide only data to the upper layer, we can do:
1) skb_put(dg->payload_size)
2) memcpy(dg->payload_size)

Also (I'm no expert in VMCI), i guess using dg->payload_size is safer
to know number of data bytes, instead of using VMCI_DG_HEADERSIZE.

WDYT?

>  	sk_receive_skb(sk, skb, 0);
>  
>  	return VMCI_SUCCESS;
> @@ -1731,59 +1736,6 @@ static int vmci_transport_dgram_enqueue(
>  	return err - sizeof(*dg);
>  }
>  

Thanks




