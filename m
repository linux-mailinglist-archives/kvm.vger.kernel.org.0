Return-Path: <kvm+bounces-33227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D7969E783A
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 19:40:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D2B281886B40
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 18:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5AA01DA631;
	Fri,  6 Dec 2024 18:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="o62otV5b"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB5D1D515D;
	Fri,  6 Dec 2024 18:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733510393; cv=none; b=oLW7mgt30PZMnfx0O3vHW1q+j0slB68I4qCNgXa5FKMrtjbBCrIH9nfu7zPwnzx5THX5weDk7G5LNgQzVTxmtujD5ZiLrbvswZJpXZLn4qIfy7o1bPklcaiTvXv5FF4WDaJ8DIzDjlGflfKAw95VFRMwy3rB44aNaSKGEnTAH48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733510393; c=relaxed/simple;
	bh=E2wWjI99kdWUXdSegLXUSROKPLL4L2v5K+qdOzZZzGw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lXe7nYfcVmlaHEp081pvuAUi+YPpaEjXGHfGmKNEVophFK5efT9+HzTNcbu2hwUTRwyNfygszW7eQSmfWvxkGTyi4AvYxyKl3OzYiP/hiMf3NdWg+2UPKuPVRtAF3Z+6L48/wz366/XNyEFZ0garJR2HgYFnhydwwlyZ2wRCJJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=o62otV5b; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1tJdEo-004PKx-SK; Fri, 06 Dec 2024 19:39:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=+NIUr4L2/mU5OspHum2ca0kQMsGCg5gpDhpnV9PRV+M=; b=o62otV5bl0SQMLz+SN+ibPxsqd
	kjTHf9j6JhCKoTGv1TbGQBT+UAPymNXJMjClPAQu/33v4bjmxsdMqBGfiov0L//2uJ0mt/9bCKsYw
	ntV5Oq08QTShWIZ4diA2FeMm01JeP0ij+VzlTLa5mUN13bJp826ljtSinv+UWXODwDGsZXnY2J0fB
	ZdZmF2z0c7UHwWaeCzuO8by/x7rwnALpmStpGPtEmprHSEUIl49UdpHUBRClXGBlDQ3tQMHt1LLV3
	XGz9TQuQLrgmQg5hvM31GZctuFq8pewOKUdKr3x4psyoUUJRHnYcLyZLV3po45DDtphFilp5+Emh/
	pStHfjtw==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1tJdEi-0008Vd-IT; Fri, 06 Dec 2024 19:39:32 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1tJdEd-008J3Y-58; Fri, 06 Dec 2024 19:39:27 +0100
Message-ID: <3f1054f1-bb3a-4345-a58d-272704c76f4c@rbox.co>
Date: Fri, 6 Dec 2024 19:39:25 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2 0/3] virtio/vsock: Fix memory leaks
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
References: <20241107-vsock-mem-leaks-v2-0-4e21bfcfc818@rbox.co>
 <7wixs5lrstuggf2xwgu6qva2t6atqnthcxycg6mpfpx52gl6fq@qmwb6gtgpad2>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <7wixs5lrstuggf2xwgu6qva2t6atqnthcxycg6mpfpx52gl6fq@qmwb6gtgpad2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 11:31, Stefano Garzarella wrote:
> Hi Michal,
> 
> On Thu, Nov 07, 2024 at 09:46:11PM +0100, Michal Luczaj wrote:
>> Short series fixing some memory leaks that I've stumbled upon while 
>> toying
>> with the selftests.
> 
> Are these tests already upstream?
> I would like to add them to my suite, can you tell me how to run them?

CC got accidentally stripped, sorry.
Long story short: https://lore.kernel.org/netdev/20241206-test-vsock-leaks-v1-0-c31e8c875797@rbox.co/

Thanks,
Michal


