Return-Path: <kvm+bounces-34930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 81C52A07BF1
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 16:28:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 293121633C9
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 15:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEFE921E08A;
	Thu,  9 Jan 2025 15:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="YsIG8cgA"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBE721CA1D;
	Thu,  9 Jan 2025 15:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736436504; cv=none; b=A11wen0Sg23cbixBkEtwVdohRtNpHxwN9yjEvIiTPtlr760cnmpm/CdKAuB2Kc7RZRxwOw90xjTK9bq6DXR9dIN59siqpXmPbfRxA5J9uNbv9jiDzul+EfhZK2V99o447zIwaomTzIjMGybzXGx8N9i6wVB9cwQPxum0cc/Hcv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736436504; c=relaxed/simple;
	bh=Spu51y9HfZuOxHXPfsEWvCmRgGJgzXcQUPYrBwwbc4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IDjF8cMKJJlUFj6MSRkdC8Hfu7k3n4cawGoN5456/Cgnra789F7Ew885djdVAL+eWxytS/2TtfKmOhUclsVEEOzRqYqSaVChtbe3CIpIml/+sgs2/fyTpZL6j1HfnmlrvjW7Jg8mI6aSvOr8PJ1mjNoGXxe56rxFVuzBXHy8CrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=YsIG8cgA; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1tVuSA-0038cU-IX; Thu, 09 Jan 2025 16:28:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=NnAJ9ysjnx9++5Tx4kBs7NCrt44ysPVsN78x25Ia93U=; b=YsIG8cgAFFi8vjxD/YzvpAyj9G
	oQlYlT08oJ3QDe3lvIYyOnGCJW8m96RaXXVSKTAZL3GfkdyVRQa2+Zzxhk1J+2B2HSLhuM9if6E1i
	Uzpya8zCKO9JlMrVpkrlgOwFkjgYEPDw05neTBPiVcOCCY1YdQsOgb3hcYj3hLBkb/z1cP5FQ4Wng
	F07tDkAFG9W5RlGoOmL+ijIUCGK2mEvdXiYG6H+ue+BymTN+IS6FOScwjVHFd9GUb6TkeMjr9cCE8
	gmari1ZpangqHiEeSU8bHfOGCd5LuvF79YLJsgXu0IVUTlp3vS6jw/Qc/IANUsQXRCRnR1h5+2WEV
	65jdyx+g==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1tVuS9-0004qn-2n; Thu, 09 Jan 2025 16:28:09 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1tVuRs-006wNO-LY; Thu, 09 Jan 2025 16:27:52 +0100
Message-ID: <05c8648c-d6ca-419b-a4ec-6b305f4ca19f@rbox.co>
Date: Thu, 9 Jan 2025 16:27:51 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 1/2] vsock/virtio: discard packets if the transport
 changes
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: netdev@vger.kernel.org, Simon Horman <horms@kernel.org>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Wongi Lee <qwerty@theori.io>, "David S. Miller" <davem@davemloft.net>,
 Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Bobby Eshleman <bobby.eshleman@bytedance.com>,
 virtualization@lists.linux.dev, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Luigi Leonardi <leonardi@redhat.com>,
 bpf@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Hyunwoo Kim <v4bel@theori.io>,
 kvm@vger.kernel.org
References: <20250108180617.154053-1-sgarzare@redhat.com>
 <20250108180617.154053-2-sgarzare@redhat.com>
 <2b3062e3-bdaa-4c94-a3c0-2930595b9670@rbox.co>
 <wix5cx7uhthr6imrpsliysktyae6xwuzpvg77uscswyqwszzfb@ms5osa4ckdcm>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <wix5cx7uhthr6imrpsliysktyae6xwuzpvg77uscswyqwszzfb@ms5osa4ckdcm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/9/25 14:42, Stefano Garzarella wrote:
> On Thu, Jan 09, 2025 at 02:34:28PM +0100, Michal Luczaj wrote:
>> ...
>> That said, when I apply this patch, but drop the `sk->sk_state !=
>> TCP_LISTEN &&`: no more splats.
> 
> We can't drop `sk->sk_state != TCP_LISTEN &&` because listener socket 
> doesn't have any transport (vsk->transport == NULL), so every connection 
> request will receive an error, so maybe this is the reason of no splats.

Bah, sorry, I didn't run the test suit.

> I'm cooking some more patches to fix Hyunwoo's scenario handling better 
> the close work when the virtio destructor is called.
> 
> I'll run your reproduces to test it, thanks for that!
> 
> Stefano
> 


