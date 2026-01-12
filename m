Return-Path: <kvm+bounces-67726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 47D19D124BB
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 12:29:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3948B3049FD5
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 11:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8A5F3563F9;
	Mon, 12 Jan 2026 11:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="Ep5g18Sw"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D398921CC55;
	Mon, 12 Jan 2026 11:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768217329; cv=none; b=jZjybnmDOnCquvYGfRGmqTubcyl7s+wWplMT3hOLnbb1wzi5uBWE/P7Al0l4Jd1ABe3RS6KVv2OPmwvyTrk9RGne80x/E4dsVo+tVcVuFdkruor40kLsJuDHBkFNNxJ/qsa4otX/TqF6xy8fgGhkom4CTza0wjy2E8gSlpxvBPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768217329; c=relaxed/simple;
	bh=1eEHbCsT+mP/hl61iZ3iyZcabrUA0wMUlwcdairvWPY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mBo63EcjeonuTAkHJGSCiG3WR04p+YkUbyUVhX8II20TWmYUjSZC8kjbCUmTUbmSHTMzC/YxAbM+q2zICA2++zy1kayNDM59sm0u3gVww6hCNwFGNHU1coXw7K1+/y8TxH7F88Q+xE5eSXjwxcaf1O9bJoZ8E3dI1BkwTWwaCs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=Ep5g18Sw; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [192.168.178.143] (p5dc880d2.dip0.t-ipconnect.de [93.200.128.210])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 60CBSbvB000121
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 12 Jan 2026 12:28:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1768217318;
	bh=1eEHbCsT+mP/hl61iZ3iyZcabrUA0wMUlwcdairvWPY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ep5g18SwhKcD7GIUmEkXVGEAAocGOvbrHX/o45JHVu/Jxz8DxN+HzR0hP5J4QKnIH
	 SpZeDaMHatM5HUdypM66MZR6gtIlXDNrcUoZdvwtHFLRfKXUBmFjEoMnVr9lHMVI87
	 JSYTowuG01MzHUb8vmG7Lb5h77xGlDJPU7oTQtCE=
Message-ID: <2e4e2944-832a-47e1-bdf9-32c636bcb6bf@tu-dortmund.de>
Date: Mon, 12 Jan 2026 12:28:37 +0100
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
 <55bcb1ec-bdbb-44aa-8fa0-470916e986aa@tu-dortmund.de>
 <20260112061831-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <20260112061831-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/12/26 12:19, Michael S. Tsirkin wrote:
> On Mon, Jan 12, 2026 at 12:17:12PM +0100, Simon Schippers wrote:
>> On 1/12/26 05:33, Michael S. Tsirkin wrote:
>>> On Fri, Jan 09, 2026 at 11:14:54AM +0100, Simon Schippers wrote:
>>>> Am I not allowed to stop the queue and then return NETDEV_TX_BUSY?
>>>
>>> We jump through a lot of hoops in virtio_net to avoid using
>>> NETDEV_TX_BUSY because that bypasses all the net/ cleverness.
>>> Given your patches aim to improve precisely ring full,
>>> I would say stopping proactively before NETDEV_TX_BUSY
>>> should be a priority.
>>>
>>
>> I already proactively stop here with the approach you proposed in
>> the v6.
>> Or am I missing something (apart from the xdp path)?
> 
> Yes, I am just answering the general question you posed.

Ah okay.

> 
>>
>> And yes I also dislike returning NETDEV_TX_BUSY but I do not see how
>> this can be prevented with lltx enabled.
> 
> Preventing NETDEV_TX_BUSY 100% of the time is not required. It's there
> to handle races.

Great to know. Thanks


