Return-Path: <kvm+bounces-36175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C50AAA1847D
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 19:08:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 52D4D7A51DD
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 18:07:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5068F1F7092;
	Tue, 21 Jan 2025 18:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="lZhE2ZM5"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3D21F0E36;
	Tue, 21 Jan 2025 18:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482816; cv=none; b=OWgffXbOHUnYi5/8/wV4/VjmQKXb3fBD3eOdctyRV5LZPGLFQPG8TfHJYqbxrqmlA4u/w7+p+bejhgjv99FCPVXnifE10HQfRGYt9MheJUnIsr7/ZXLJ/bP6cIv3C4x6kSkS+KMFKTqbJdEbHbFfDmOo6IPbxd0kk8SqxOyVBnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482816; c=relaxed/simple;
	bh=yzMp9OHuDafOKBn9rcCV9TmT/23Cxa4L5N2agXVJ7RY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TN7HUBTQDVX0OCWMTE0KHnAYUXauN+ZhDDEd2C2rOssn7qUKmwyNMnU1F6EGjeH8XCa9QS1DOagu7W2Rk1RCwtrlTcTjLch2Jej3oBJyBPtmRmGEGA7jwbjRXFifsrTNGeNvN47ahDBxOECCcDFiiVKvocP4aikQgTcE7g7wneQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=lZhE2ZM5; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1taIeA-001Ctx-TD; Tue, 21 Jan 2025 19:06:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=B0NkyGC4wYzCqVt2GL2dQ8Knz8FG3vRNUr8ob8BqF5k=; b=lZhE2ZM5ebUs7A8nmbHRIqXRl8
	MUCnJTfK17MbN21CUElCkz+PNZr31HSVtBnHd1eMmgeeSikqNLHxtf/3jU0zTXjlGBKVQmfENidkm
	9PX2cX02Cwhpt+nUurU1kGffhyKp1uR3yOaAHgPLf2hEcMWUlWLGwIhYIC34lrJH1g71frVxPG4ko
	PwefQEVtEe/Hsg9wcV025DbgJjKWY6KwaHMKzoyDUOMOFKsEcLJrvGeJEcjtCyKWPWslQlw3TprVT
	WpR6AFtLuPmZhYXl+ifjoto4O8sbMlJxi6mqs1FD5AfKJA6Nl6cfWV9os9vsBqklX4Mazlll4RrjA
	GQ3R5rpw==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1taIe9-0006xt-CE; Tue, 21 Jan 2025 19:06:41 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1taIe0-006jVZ-TF; Tue, 21 Jan 2025 19:06:32 +0100
Message-ID: <2bdfe259-e182-4846-b501-a33096cc74f1@rbox.co>
Date: Tue, 21 Jan 2025 19:06:31 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 1/2] vsock/virtio: discard packets if the transport
 changes
To: Luigi Leonardi <leonardi@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>, netdev@vger.kernel.org,
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>,
 linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Wongi Lee <qwerty@theori.io>,
 "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>,
 Jason Wang <jasowang@redhat.com>,
 Bobby Eshleman <bobby.eshleman@bytedance.com>,
 virtualization@lists.linux.dev, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, bpf@vger.kernel.org, Jakub Kicinski
 <kuba@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
 Hyunwoo Kim <v4bel@theori.io>, kvm@vger.kernel.org
References: <20250108180617.154053-1-sgarzare@redhat.com>
 <20250108180617.154053-2-sgarzare@redhat.com>
 <2b3062e3-bdaa-4c94-a3c0-2930595b9670@rbox.co>
 <blvbtr3c7uxtbspbfwrobfk7qdukz6nst2bnomoxbltst2yhkm@47k6evsdceeg>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <blvbtr3c7uxtbspbfwrobfk7qdukz6nst2bnomoxbltst2yhkm@47k6evsdceeg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/21/25 18:30, Luigi Leonardi wrote:
> On Thu, Jan 09, 2025 at 02:34:28PM +0100, Michal Luczaj wrote:
>> FWIW, I've tried simplifying Hyunwoo's repro to toy with some tests. 
>> Ended
>> up with
>>
>> ```
>>from threading import *
>>from socket import *
>>from signal import *
>>
>> def listener(tid):
>> 	while True:
>> 		s = socket(AF_VSOCK, SOCK_SEQPACKET)
>> 		s.bind((1, 1234))
>> 		s.listen()
>> 		pthread_kill(tid, SIGUSR1)
>>
>> signal(SIGUSR1, lambda *args: None)
>> Thread(target=listener, args=[get_ident()]).start()
>>
>> while True:
>> 	c = socket(AF_VSOCK, SOCK_SEQPACKET)
>> 	c.connect_ex((1, 1234))
>> 	c.connect_ex((42, 1234))
>> ```
>>
>> which gives me splats with or without this patch.
>>
>> That said, when I apply this patch, but drop the `sk->sk_state !=
>> TCP_LISTEN &&`: no more splats.
>>
> Hi Michal,
> 
> I think it would be nice to have this test in the vsock test suite.  
> WDYT? If you don't have any plans to port this to C, I can take care of 
> it :)

Sure, go ahead, but note that this is just a (probably suboptimal) Python
version of Hyunwoo's C repro[1].

[1]: https://lore.kernel.org/netdev/Z2LvdTTQR7dBmPb5@v4bel-B760M-AORUS-ELITE-AX/


