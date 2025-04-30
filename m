Return-Path: <kvm+bounces-44885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 73CC6AA485F
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 12:32:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1C854E538E
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 10:31:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D6DD259CBB;
	Wed, 30 Apr 2025 10:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="aOVwPP7O"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15F62580D5;
	Wed, 30 Apr 2025 10:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746009004; cv=none; b=jydQvbe14ztPhObD+3usM1ljqPE6co+dIAzf786qrb2Ycw1ShRsbg2hTYVvFR/+77ewPcLKlFISBvIHEWoleJ/ZGLqDy7OXRxBxI3839Pi0eak/5apb0hayV/2zXWug1KfKPW5eXxvUhCjxDyblvFksRjO4Bk6RjS28keR2m3Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746009004; c=relaxed/simple;
	bh=MAE9f1a8znhsgmjczgjHcCGcpadDQnbRn9xuQ+IxlCU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NagvHcl4aTupJ4dE2asT1v0Izk8O/vKk8qoh4wR15c9YoaZOvhsccjyMhdgO3FOL5GkYh9AQ3lSc6mReXDJJDOvhhgvE5jz7jDXwogXT2tNLMkUqbsBcxKfpWX/ILDgSOYbcbzftaPB0IfRfNuxQrqUAthu4PaKFcd29jsNLKH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=aOVwPP7O; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uA4hT-008vCi-Ee; Wed, 30 Apr 2025 12:29:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=P0KVKoqq56G7B/JYTEokhLyObIUsyyvZ16dMXwpB2zo=; b=aOVwPP7OUx3KgXBVklCghQwJJO
	D1tKdzi71G8B4mEolMukLeJhoRoMlkxY23V642siab0d5JFuzheHrnw35eehlhMAFXt9iFgaIZpbB
	KX3oVVWhzW7/8o/RdDIHmiu5uTq7ADKFwm9ZsKu63e2QejwwPjzjfLqM0CARTW8ARe0Y4GrjHYz3n
	2qhm6cOUATu9YZ7P7O9LFbvSDgh9+uxMZBUjvNlgm7Ccni3Hpnn//juqKyIxzxoG3sYiG8U5Ll2O3
	L/TWAboV8fmSVoORbncBHeHiUCCNt1h6YYROs+0x1XuV7jIXFFt+FbKqEyC9XHFHpuAhLfP8cplTk
	gMcvVwdA==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uA4hS-0004Gm-CU; Wed, 30 Apr 2025 12:29:58 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uA4hG-000n2Y-2B; Wed, 30 Apr 2025 12:29:46 +0200
Message-ID: <1b24198d-2e74-43b5-96be-bdf72274f712@rbox.co>
Date: Wed, 30 Apr 2025 12:29:44 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 2/4] vsock/virtio: Reduce indentation in
 virtio_transport_wait_close()
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250430-vsock-linger-v3-0-ddbe73b53457@rbox.co>
 <20250430-vsock-linger-v3-2-ddbe73b53457@rbox.co>
 <dlk4swnprv52exa3xs5omo76ir7e3x5u7bwlkkuecmrrn2cznm@smxggyqjhgke>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <dlk4swnprv52exa3xs5omo76ir7e3x5u7bwlkkuecmrrn2cznm@smxggyqjhgke>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/30/25 11:28, Stefano Garzarella wrote:
> On Wed, Apr 30, 2025 at 11:10:28AM +0200, Michal Luczaj wrote:
>> Flatten the function. Remove the nested block by inverting the condition:
>> return early on !timeout.
> 
> IIUC we are removing this function in the next commit, so we can skip 
> this patch IMO. I suggested this change, if we didn't move the code in 
> the core.
Right, I remember your suggestion. Sorry, I'm still a bit uncertain as to
what should and shouldn't be done in a single commit.

Michal


