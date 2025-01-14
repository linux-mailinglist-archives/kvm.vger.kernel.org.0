Return-Path: <kvm+bounces-35340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F294A0FD34
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 01:10:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 72E401888DA8
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 00:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91A1CF9D9;
	Tue, 14 Jan 2025 00:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="K6PlnWJ9"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4C017C91;
	Tue, 14 Jan 2025 00:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736813399; cv=none; b=B8LpQu/DvatSZKOngrYxOmdzxBk8MT4607KnLDlGROuGpfLOuSZTaOYtv0tnTyUfP9g6SBlwl2GNvZUqsFk0lBUtC7ZW26gm9UGKNcwUxgG9vL61VR/l+LonrU5xfxpdBI6d8PcSTjaJglYDj0vnS8BtJ2XB/zfUWYJzkDbt/nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736813399; c=relaxed/simple;
	bh=OsKFXtMineW8sNVrB+luwXdbjpxNtb5UUqOWpJzquZs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a232ziLqUv/R3a10GhW0bd2wCAYgLcuZmIptR0897UjH9lotOiGalvftsqViles+41qm7emLrBASpP7H8PTbuKTfEROEVKsXvrbkCRb14rktYY4ExccDRFOCiGReKzvMaxJJktJACip0nvxvdz9TAaxlcYI/5mt3B46Eyvl/yiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=K6PlnWJ9; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1tXUV0-00FOKw-Tk; Tue, 14 Jan 2025 01:09:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=ItYetxWsSzgRvLHc8dKmyCADQfPIZfMQ4g/EMKUfjZA=; b=K6PlnWJ9JeqtlI+A2SE03zEl5v
	t0nhZB9327vqImvtuPI90q8kXl3d74poC3e/F3u7e+OIz2gZ38jkJlSBDpHQz4K2MvLP51v95AbtX
	WZqKZrqBjmk/Fe1arTJCLNAoMjcSkIDU0h53HoVNldRtaHcQ+7OaKXmoLyM8jVyYsPOmEPLpvt6Dn
	aFnPE1jYDUK04SeFQbc+8UK5WMn+jTB2XEUxgHyWSp+zxdCfVsTGB3CZjQDFi+73Dlb1Y4OBEaqZJ
	kXBunvm2DK1lqTBFIoQGGazJKgzMubUR9lTSP8HLwlV0v2DCUcKd/+/xnSjdMeVaQWabfhJcZM6wn
	zQJgWm4A==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1tXUUx-0005Z5-Fa; Tue, 14 Jan 2025 01:09:37 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1tXUUn-00GzIz-OP; Tue, 14 Jan 2025 01:09:25 +0100
Message-ID: <7de34054-10cf-45d0-a869-adebb77ad913@rbox.co>
Date: Tue, 14 Jan 2025 01:09:24 +0100
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
From: Michal Luczaj <mhal@rbox.co>
Content-Language: pl-PL, en-GB
In-Reply-To: <5nkibw33isxiw57jmoaadizo3m2p76ve6zioumlu2z2nh5lwck@xodwiv56zrou>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/13/25 16:01, Stefano Garzarella wrote:
> On Mon, Jan 13, 2025 at 02:51:58PM +0100, Michal Luczaj wrote:
>> On 1/13/25 12:05, Stefano Garzarella wrote:
>>> ...
>>> An alternative approach, which would perhaps allow us to avoid all this,
>>> is to re-insert the socket in the unbound list after calling release()
>>> when we deassign the transport.
>>>
>>> WDYT?
>>
>> If we can't keep the old state (sk_state, transport, etc) on failed
>> re-connect() then reverting back to initial state sounds, uhh, like an
>> option :) I'm not sure how well this aligns with (user's expectations of)
>> good ol' socket API, but maybe that train has already left.
> 
> We really want to behave as similar as possible with the other sockets,
> like AF_INET, so I would try to continue toward that train.

I was worried that such connect()/transport error handling may have some
user visible side effects, but I guess I was wrong. I mean you can still
reach a sk_state=TCP_LISTEN with a transport assigned[1], but perhaps
that's a different issue.

I've tried your suggestion on top of this series. Passes the tests.

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index fa9d1b49599b..4718fe86689d 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -492,6 +492,10 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 		vsk->transport->release(vsk);
 		vsock_deassign_transport(vsk);
 
+		vsock_addr_unbind(&vsk->local_addr);
+		vsock_addr_unbind(&vsk->remote_addr);
+		vsock_insert_unbound(vsk);
+
 		/* transport's release() and destruct() can touch some socket
 		 * state, since we are reassigning the socket to a new transport
 		 * during vsock_connect(), let's reset these fields to have a

>> Another possibility would be to simply brick the socket on failed (re)connect.
> 
> I see, though, this is not the behavior of AF_INET for example, right?

Right.

> Do you have time to investigate/fix this problem?
> If not, I'll try to look into it in the next few days, maybe next week.

I'm happy to help, but it's not like I have any better ideas.

Michal

[1]: E.g. this way:
```
from socket import *

MAX_PORT_RETRIES = 24 # net/vmw_vsock/af_vsock.c
VMADDR_CID_LOCAL = 1
VMADDR_PORT_ANY = -1
hold = []

def take_port(port):
	s = socket(AF_VSOCK, SOCK_SEQPACKET)
	s.bind((VMADDR_CID_LOCAL, port))
	hold.append(s)
	return s

s = take_port(VMADDR_PORT_ANY)
_, port = s.getsockname()
for _ in range(MAX_PORT_RETRIES):
	port += 1
	take_port(port);

s = socket(AF_VSOCK, SOCK_SEQPACKET)
err = s.connect_ex((VMADDR_CID_LOCAL, port))
assert err != 0
print("ok, connect failed; transport set")

s.bind((VMADDR_CID_LOCAL, port+1))
s.listen(16)
```


