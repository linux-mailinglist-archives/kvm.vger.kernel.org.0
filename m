Return-Path: <kvm+bounces-47317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 052E5AC005D
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 01:07:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1F3F17C8D0
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 23:07:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF2E623C4FD;
	Wed, 21 May 2025 23:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="Dm2CmnsS"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F9323A99D;
	Wed, 21 May 2025 23:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747868826; cv=none; b=EN7h3mKXQpsuG4VWTDbr6blfDQsoRO1m+Pkr8OTHe5tglpq9zf1xfNYCyO1QcOx3eLLSzKJt17/DYto4D3AcCf2cADBOPWW7s6fc2fmpOWeU24hXemRz28YhnPUwz7iYIWeN2I5GouXAuDUtq+d2/MpBr5oXcBNCDyYDSoZpw1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747868826; c=relaxed/simple;
	bh=lVmO56p+uZGIerCgdjVgF1P4OcseONdcg4PDITx4ViY=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=p4mL6BbNpaREmSyKFRgxdD4Uxv7zv22Xz5cQTPiGhjq951ZVdOXBvd/JyRImjD9XyOmCdZZghILMn4RR6KUJ0eCIz+Z5HGpDmLOtyD6gQews9KN+pOXA7ZGqxB/c3rJM71Kd9Tja7HbUPRVKVXdw/DCzq+vC/iTB6Yg3dfu4VMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=Dm2CmnsS; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uHsWL-004HcE-TF; Thu, 22 May 2025 01:06:45 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
	Cc:To:Subject:From:MIME-Version:Date:Message-ID;
	bh=eT/TvbyrfUHVMgG9STixlXp9Jk4uKrQGdUU0vHKW7lA=; b=Dm2CmnsSNwS7RAPtj91Q+z5zcY
	igvIEnbFzYXTy0yrhVYvt8sCQ6R+8rSVbHj/t9Cnez7SLLPo0Elkql8cLlNTX5UE/nxtSzhgHMt84
	UGX3X5T4TqaBHoH68pX6ToSDapkk5VFCcCIVdI92dR4+idwAiU0Om2pBYEP436NvkPk+w0xwj685F
	DKQ2ZsGij97YFfOCFhWGX/SkCpRsIIjHyrBLzdSeeGVlwOnGEvvPKtmrqLRzell2EE3pzvUR9ARGN
	+8gWRbGXOqxMzt5m26BC+oYEADptm7zjyX7jOnS1sd3nA0VYRV3koWTgqpEFVn6h5aEXT1sES/1/T
	EMWd3L1A==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uHsWK-0005RK-IG; Thu, 22 May 2025 01:06:44 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uHsW1-002T7Y-Fq; Thu, 22 May 2025 01:06:25 +0200
Message-ID: <bc18e277-ef88-49e2-9e51-982752253325@rbox.co>
Date: Thu, 22 May 2025 01:06:24 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Michal Luczaj <mhal@rbox.co>
Subject: Re: [PATCH net-next v5 3/5] vsock/test: Introduce vsock_wait_sent()
 helper
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250521-vsock-linger-v5-0-94827860d1d6@rbox.co>
 <20250521-vsock-linger-v5-3-94827860d1d6@rbox.co>
 <kva35i6sjyxuugywlanlnkbdunbyauadgnciteakxu2jsb2kl7@24fgdq2glxk6>
Content-Language: pl-PL, en-GB
In-Reply-To: <kva35i6sjyxuugywlanlnkbdunbyauadgnciteakxu2jsb2kl7@24fgdq2glxk6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/25 17:01, Stefano Garzarella wrote:
> On Wed, May 21, 2025 at 12:55:21AM +0200, Michal Luczaj wrote:
>> ...
>> +/* Wait until transport reports no data left to be sent.
>> + * Return non-zero if transport does not implement the unsent_bytes() callback.
>> + */
>> +int vsock_wait_sent(int fd)
> 
> nit: I just see we use `bool` in the test to store the result of this 
> function, so maybe we can return `bool` directl from here...
> 
> (not a strong opinion, it's fine also this).

Yeah, why not, let's do bool.

Thanks,
Michal


