Return-Path: <kvm+bounces-35397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11ECEA10C50
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 17:31:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25E9F1889A8C
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 16:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9129F1D5142;
	Tue, 14 Jan 2025 16:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="Zj8zAh65"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55231160884;
	Tue, 14 Jan 2025 16:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736872291; cv=none; b=Jw4Y+a4Q2gMIp7rZtBdsPpOyP3oUoaqquY/nIfiw6v6e47QC5hzbgfSxO4FbSMtIs/KlKjodThSkN2zGskrHdj3VL4R5yXzssXuu/qBgiCe7C322OOTYgDeDbdkUvgtrM7RH/LU/UOGPv7aJZQ1VGe6VGGGsjjl5dqu3hkVnuSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736872291; c=relaxed/simple;
	bh=GliCZdjc9UMRvHhc1En8aKi7hYaY/62aGAlKZEHFeoE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fdSLCJlFBuWdhuQLP6MxDdXovujoTHa6eXhf9MOAveC/DRSmR55kXDNd9Tvvm/vy064RY3TJUcG4LR37VdN0erYeVNpGyo9is4APRcJrk4blR6D3YnHe88hRFZ66oULgP6gAgvVqoZPOskf0Ya3er70vTgvzd5JvZ5BemdbU0EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=Zj8zAh65; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1tXjp3-00HICC-LA; Tue, 14 Jan 2025 17:31:21 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=uc3P+aW58p1Wgl/FgiobWz7JZg3jTcWFJd6qr34VHyM=; b=Zj8zAh65jD1PreEiamMYVyGj2V
	gVX5tchbNSM3Wv6Gbf12HUK9JCzyI2AeruIo25+HSbn3Qznzgu2mQ/0iFOtRy5SAV5/TFkMqXAQZ1
	jWyhuoFcmKk2fyu+x36pLL6N2MWU6QAYB9pipAkxN1F/c0zcLbKV60O1kqVrr42NEwXkCXEdklOY8
	kktFdnhdJqFuw+GpAIC+BMjvd19B08h220kQ4FdH7kvxA6ZlHMnKXUaToaVFB/srDG25lPBfT7p/c
	DAxbe9IyFAL4NkWOG3gsimEY0TV5O5uEgj08MQQkPdFs0VQ7LkT29uAhr7DDwa2GZ9mj1HPWGscdG
	CdAE0uvA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1tXjp2-00007d-B3; Tue, 14 Jan 2025 17:31:20 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1tXjor-003bqh-Vn; Tue, 14 Jan 2025 17:31:10 +0100
Message-ID: <fb6f876f-a4eb-4005-bd76-fff0632291b8@rbox.co>
Date: Tue, 14 Jan 2025 17:31:08 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2 1/5] vsock/virtio: discard packets if the transport
 changes
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: netdev@vger.kernel.org, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
 Luigi Leonardi <leonardi@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, Wongi Lee <qwerty@theori.io>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Eric Dumazet <edumazet@google.com>,
 kvm@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Simon Horman <horms@kernel.org>, Hyunwoo Kim <v4bel@theori.io>,
 Jakub Kicinski <kuba@kernel.org>, virtualization@lists.linux.dev,
 stable@vger.kernel.org
References: <20250110083511.30419-1-sgarzare@redhat.com>
 <20250110083511.30419-2-sgarzare@redhat.com>
 <1aa83abf-6baa-4cf1-a108-66b677bcfd93@rbox.co>
 <nedvcylhjxrkmkvgugsku2lpdjgjpo5exoke4o6clxcxh64s3i@jkjnvngazr5v>
 <CAGxU2F7BoMNi-z=SHsmCV5+99=CxHo4dxFeJnJ5=q9X=CM3QMA@mail.gmail.com>
 <cccb1a4f-5495-4db1-801e-eca211b757c3@rbox.co>
 <nzpj4hc6m4jlqhcwv6ngmozl3hcoxr6kehoia4dps7jytxf6df@iqglusiqrm5n>
 <903dd624-44e5-4792-8aac-0eaaf1e675c5@rbox.co>
 <5nkibw33isxiw57jmoaadizo3m2p76ve6zioumlu2z2nh5lwck@xodwiv56zrou>
 <7de34054-10cf-45d0-a869-adebb77ad913@rbox.co>
 <n2itoh23kikzszzgmyejfwe3mdf6fmxzwbtyo5ahtxpaco3euq@osupldmckz7p>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <n2itoh23kikzszzgmyejfwe3mdf6fmxzwbtyo5ahtxpaco3euq@osupldmckz7p>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/14/25 11:16, Stefano Garzarella wrote:
> On Tue, Jan 14, 2025 at 01:09:24AM +0100, Michal Luczaj wrote:
>> On 1/13/25 16:01, Stefano Garzarella wrote:
>>> On Mon, Jan 13, 2025 at 02:51:58PM +0100, Michal Luczaj wrote:
>>>> On 1/13/25 12:05, Stefano Garzarella wrote:
>>>>> ...
>>>>> An alternative approach, which would perhaps allow us to avoid all this,
>>>>> is to re-insert the socket in the unbound list after calling release()
>>>>> when we deassign the transport.
>>>>>
>>>>> WDYT?
>>>>
>>>> If we can't keep the old state (sk_state, transport, etc) on failed
>>>> re-connect() then reverting back to initial state sounds, uhh, like an
>>>> option :) I'm not sure how well this aligns with (user's expectations of)
>>>> good ol' socket API, but maybe that train has already left.
>>>
>>> We really want to behave as similar as possible with the other sockets,
>>> like AF_INET, so I would try to continue toward that train.
>>
>> I was worried that such connect()/transport error handling may have some
>> user visible side effects, but I guess I was wrong. I mean you can still
>> reach a sk_state=TCP_LISTEN with a transport assigned[1], but perhaps
>> that's a different issue.
>>
>> I've tried your suggestion on top of this series. Passes the tests.
> 
> Great, thanks!
> 
>>
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index fa9d1b49599b..4718fe86689d 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -492,6 +492,10 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
>> 		vsk->transport->release(vsk);
>> 		vsock_deassign_transport(vsk);
>>
>> +		vsock_addr_unbind(&vsk->local_addr);
>> +		vsock_addr_unbind(&vsk->remote_addr);
> 
> My only doubt is that if a user did a specific bind() before the
> connect, this way we're resetting everything, is that right?

That is right.

But we aren't changing much. Transport release already removes vsk from
vsock_bound_sockets. So even though vsk->local_addr is untouched (i.e.
vsock_addr_bound() returns `true`), vsk can't be picked by
vsock_find_bound_socket(). User can't bind() it again, either.

And when patched as above: bind() works as "expected", but socket is pretty
much useless, anyway. If I'm correct, the first failing connect() trips
virtio_transport_recv_connecting(), which sets `sk->sk_err`. I don't see it
being reset. Does the vsock suppose to keep sk_err state once set?

Currently only AF_VSOCK throws ConnectionResetError:
```
from socket import *

def test(family, addr):
	s = socket(family, SOCK_STREAM)
	assert s.connect_ex(addr) != 0

	lis = socket(family, SOCK_STREAM)
	lis.bind(addr)
	lis.listen()
	s.connect(addr)

	p, _ = lis.accept()
	p.send(b'x')
	assert s.recv(1) == b'x'

test(AF_INET, ('127.0.0.1', 2000))
test(AF_UNIX, '\0/tmp/foo')
test(AF_VSOCK, (1, 2000)) # VMADDR_CID_LOCAL
```

> Maybe we need to look better at the release, and prevent it from
> removing the socket from the lists as you suggested, maybe adding a
> function in af_vsock.c that all transports can call.

I'd be happy to submit a proper patch, but it would be helpful to decide
how close to AF_INET/AF_UNIX's behaviour is close enough. Or would you
rather have that UAF plugged first?


