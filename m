Return-Path: <kvm+bounces-67722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 127F5D1237F
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 12:17:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AFAD3303C627
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 11:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ABAA3563F4;
	Mon, 12 Jan 2026 11:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="bqLa8KtJ"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4943E33D4F7;
	Mon, 12 Jan 2026 11:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768216643; cv=none; b=SnM31xz/hxRLPuJ/cqYPumIqbiuiSoO96yeA4ag/WeId42ftZ7iwqVz31qcB3hQme3a2bPBjShAjC6rR/qX8VSqY52vwF1RUZfHqjMHmKG5fftJvVc3shbpb/uNz5KU4Hs6nboi4T1rXUZfPz2euRaguV02gHSMv2eb5v0gOT5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768216643; c=relaxed/simple;
	bh=6w36q0S7h5FQl6P+ukHc78eeysTP0ZXNt9moyYUdFqY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l86e1eFF2/r4NGsMWhy7qME0BJk2ButQK8UVIpt4u6AEs38zmCUg27nQa7xyyEhM3Zywybbr35bEODwpZK8WmH09wdyTRpmliMMVaq5iXco60ePPqRQ5EucpkxGAQVVVg33Xe2ZG91Tr92wOcZTONYXM/BxuFg7o2d0TwrukohQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=bqLa8KtJ; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [192.168.178.143] (p5dc880d2.dip0.t-ipconnect.de [93.200.128.210])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 60CBHCmB015260
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 12 Jan 2026 12:17:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1768216633;
	bh=6w36q0S7h5FQl6P+ukHc78eeysTP0ZXNt9moyYUdFqY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bqLa8KtJWaxLkC+ngqFWEnUtQLkeSs7vxDQRI2J0cVN1cSQAcWEPow8EDBy4jMn9e
	 xs2OOSQ3WJM9MDVl3DLfVaZJ7rezlVFpC3KH8pby4fiVBnDAfc3GTbQ+onZvjx1jH2
	 QNaOeRxHnzJSKo2lMepuvOQqqVCByPhEzVh14R78=
Message-ID: <55bcb1ec-bdbb-44aa-8fa0-470916e986aa@tu-dortmund.de>
Date: Mon, 12 Jan 2026 12:17:12 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH net-next v7 9/9] tun/tap & vhost-net: avoid ptr_ring tail-drop
 when qdisc is present
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, willemdebruijn.kernel@gmail.com,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, eperezma@redhat.com,
        leiyang@redhat.com, stephen@networkplumber.org, jon@nutanix.com,
        tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
 <20260107210448.37851-10-simon.schippers@tu-dortmund.de>
 <CACGkMEuQikCsHn9cdhVxxHbjKAyW288SPNxAyXQ7FWNxd7Qenw@mail.gmail.com>
 <bd41afae-cf1e-46ab-8948-4c7fa280b20f@tu-dortmund.de>
 <CACGkMEs8VHGjiLqn=-Gt5=WPMzqAXNM2GcK73dLarP9CQw3+rw@mail.gmail.com>
 <900c364b-f5ca-4458-a711-bf3e0433b537@tu-dortmund.de>
 <20260111233129-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <20260111233129-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/12/26 05:33, Michael S. Tsirkin wrote:
> On Fri, Jan 09, 2026 at 11:14:54AM +0100, Simon Schippers wrote:
>> Am I not allowed to stop the queue and then return NETDEV_TX_BUSY?
> 
> We jump through a lot of hoops in virtio_net to avoid using
> NETDEV_TX_BUSY because that bypasses all the net/ cleverness.
> Given your patches aim to improve precisely ring full,
> I would say stopping proactively before NETDEV_TX_BUSY
> should be a priority.
> 

I already proactively stop here with the approach you proposed in
the v6.
Or am I missing something (apart from the xdp path)?

And yes I also dislike returning NETDEV_TX_BUSY but I do not see how
this can be prevented with lltx enabled.

