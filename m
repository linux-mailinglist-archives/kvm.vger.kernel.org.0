Return-Path: <kvm+bounces-31182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B33B9C10AE
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 22:11:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C34522838A7
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 21:11:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68A9C21C168;
	Thu,  7 Nov 2024 21:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="HbiPvJDm"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE07821894A;
	Thu,  7 Nov 2024 21:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731013464; cv=none; b=t2Q8IyVFxBFbezgwan8YtjNUwMNv8dAReM+j0XVKrkBcJbzYeNFqTTz6Vdc4vUUqyLN6jPYXHnU0+sWiDyHirnz6vr40GothMkiiMAWYJwA6MxC5umAoglU9I6m+THItFODhS2ZVxx0jSnG0f4Rf6EltQ6SE6IeyvpJvETdZqZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731013464; c=relaxed/simple;
	bh=ufVmnnEsAVAB87xL6ShaBeZvbtdppn5u/mHuPK+Ifa4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=frTB/x/l2iCItX/678Gx7DQ+9CjmnRZnSDPaN8/gokkiUwUIdB00KnfYHx6U7YN5H0uquwaxpXuCML6gxfDxZkYvjbQhCbkvc4hwITCLG+OouYjWqAQQ4mYbO7zeHtGRcScxjqOGI5sbMJLOYxz1IgwoGKC4E5J0E4scZePR7VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=HbiPvJDm; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1t99fk-001cQe-Pq; Thu, 07 Nov 2024 22:04:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=NJ94SYpGtd1ZvFk4y4UGsZERie0zlF24MSV35QnYmNg=; b=HbiPvJDm6d1tW7GFgtiyUKbr0F
	ydenIihnYVXiRGEwXNBmBcKihFf6Yf6PLwA+SjjaG9vypr7xQmwc/TJiM8GYt2p/Krb17senHoapr
	eOMZnnb0YZNdxzEjoXy+7wFuLNxUMuYG6ncivRD3oEhMbiqKFj6vyWA8HGikK1qZz0roC9fQs8YIM
	hv9HaNv+zqhSEwPu+rs5kkE+ogXxerP4zv77+3UscJ4isuCPQY0Rxtjc+N+FlZUrqxW5wVSnQhj02
	VYgTOUMum8cyVOLs+32ZehncDPFC5E27jD7ElZFOhVAhqor2lY2rE0UpR98+67dqZqTDLgbQaV8ZO
	AzYF9rXA==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1t99fj-00043B-4N; Thu, 07 Nov 2024 22:04:07 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1t99fh-002w7Q-2g; Thu, 07 Nov 2024 22:04:05 +0100
Message-ID: <14fbd6da-9ef5-400c-9dde-afff3d2c7525@rbox.co>
Date: Thu, 7 Nov 2024 22:04:03 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 4/4] virtio/vsock: Put vsock_connected_sockets_vsk()
 to use
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Jia He <justin.he@arm.com>, Arseniy Krasnov <avkrasnov@salutedevices.com>,
 Dmitry Torokhov <dtor@vmware.com>, Andy King <acking@vmware.com>,
 George Zhang <georgezhang@vmware.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org
References: <20241106-vsock-mem-leaks-v1-0-8f4ffc3099e6@rbox.co>
 <20241106-vsock-mem-leaks-v1-4-8f4ffc3099e6@rbox.co>
 <ucfa7kvzvfvcstufnkhg3rxb4vrke7nuovqwtlw5awxrhiktqo@lc543oliswzk>
From: Michal Luczaj <mhal@rbox.co>
Content-Language: pl-PL, en-GB
In-Reply-To: <ucfa7kvzvfvcstufnkhg3rxb4vrke7nuovqwtlw5awxrhiktqo@lc543oliswzk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/7/24 11:22, Stefano Garzarella wrote:
> On Wed, Nov 06, 2024 at 06:51:21PM +0100, Michal Luczaj wrote:
>> Macro vsock_connected_sockets_vsk() has been unused since its introduction.
>> Instead of removing it, utilise it in vsock_insert_connected() where it's
>> been open-coded.
>>
>> No functional change intended.
>>
>> Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
> 
> This is not a fix, so please remove the Fixes tag, we don't need to 
> backport this patch in stable branches.
> 
> Also in this case this is not related at all with virtio transport, so 
> please remove `virtio` from the commit title.
> 
> In addition maybe you can remove this patch from this series, and send 
> it to net-next.
> ...

Right, I get it. Just to be clear: are such small (and non-functional)
cleanups welcomed coming by themselves?

Thanks,
Michal


