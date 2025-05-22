Return-Path: <kvm+bounces-47418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1540AC16D1
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 00:30:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11647506607
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 22:30:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56B5227E7FE;
	Thu, 22 May 2025 22:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="u1MWOB5X"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB57279330;
	Thu, 22 May 2025 22:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747953019; cv=none; b=B23+Vy/saP+ERD9HzJN1BCh7nyJHpkKJtlIK8ADa+1jhsqxRAs4fTbuAHOrRcWLeRRppFngESIuO2TlmPq3thAl5EoqM/ceIGr00a7PHgM7XASoYgWeu5tHUKmNdB8BQyd46OuYs/gy5NSli+wR2G3h5djk1HEd/8/vaasCt0IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747953019; c=relaxed/simple;
	bh=6nlrUA/fMTKOObBYQK+Gk7I0UmQ0/p3SwQAXUH/DDgo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=i8hSCaRYNmBuNZv0nOJIo/ZzXE5cwCXuA7r9eHxvwNTrDEbzoh2ToVzahdSxkz8Lgxqe76MVYbIbtettgUV9KHovah53oS7KupCoJPGnmuGolye2AkL7JhZcXvkDO5uNVvyX7VokRLoq0hJxtjqzxsUXH8WwJjVYZQRl6viSQWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=u1MWOB5X; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uIEQS-007GOP-4r; Fri, 23 May 2025 00:30:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
	Cc:To:Subject:From:MIME-Version:Date:Message-ID;
	bh=aGuZyX3fslrEUusqSYEFKL1p6x06fg8Wgbqcbb2KmYE=; b=u1MWOB5XWOn6QImSwmqJF4Utap
	WRmuDzFaLw8ppqdg8znfYdo4n1/qc7bGnEDjfEqOzwvcCHzUWespFsxLqs3/liNG5xlmN11sGSFsI
	klX80AXVXd9P9GWrRXuCGA/Hp/7OUN4HCeO/q/BuoDnDozy1d5Q4QMDNg9rxequ+Pll8eJkLrMV4N
	lK4UkRXYIptC3Gy75UreI8kl45hggwfp9kUvjdd7G2JKRcWKENjcGSjZvk9hY73/Mlo56Z/GHCLpy
	kBKz66JXRn5UcYd08yMJjYDqHUNa6/3rntgksf7/zACbM3SEkou0r61KNB8Th7ZSpaAfrwpGTVhl3
	3hnBloWg==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uIEQQ-000437-T4; Fri, 23 May 2025 00:30:07 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uIEQC-009KRJ-Dv; Fri, 23 May 2025 00:29:52 +0200
Message-ID: <6d6b2f04-fc4b-436c-a963-f4f8977bed37@rbox.co>
Date: Fri, 23 May 2025 00:29:51 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Michal Luczaj <mhal@rbox.co>
Subject: Re: [PATCH net-next v6 0/5] vsock: SOCK_LINGER rework
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250522-vsock-linger-v6-0-2ad00b0e447e@rbox.co>
 <kqm3bdj66qkziz27xsy6k6rnyminleqvebgqoudmufa424jlzm@khnzut7q4nqq>
Content-Language: pl-PL, en-GB
In-Reply-To: <kqm3bdj66qkziz27xsy6k6rnyminleqvebgqoudmufa424jlzm@khnzut7q4nqq>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/22/25 10:08, Stefano Garzarella wrote:
> On Thu, May 22, 2025 at 01:18:20AM +0200, Michal Luczaj wrote:
>> Change vsock's lingerning to wait on close() until all data is sent, i.e.
>> until workers picked all the packets for processing.
> 
> Thanks for the series and the patience :-)
> 
> LGTM! There should be my R-b for all patches.

I think it went smoothly, thanks for the reviews :)

Michal


