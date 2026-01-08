Return-Path: <kvm+bounces-67356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EE890D01BC6
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 10:06:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F17DB3084D67
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 08:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 748DD357A44;
	Thu,  8 Jan 2026 07:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="JIUjrlUi"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFED3570B6;
	Thu,  8 Jan 2026 07:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767858468; cv=none; b=AGqwy+VBCc1AlQRPw4IsXgozMwtYCGtY7iBt4Icy/gUUiECovizdW25hBhGyc2KRYHWAtw7O/9EPjdzo6wy7Y6IKHc53kIvR8sDwBfc5Uo6A0paAhobP0RGqWhFU64/FcBe+Es8zAC1zzetAZlmflDpFntFQQtPZnapQKAuezfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767858468; c=relaxed/simple;
	bh=D4+VOMbH/tWXjB2Stkdshvm7QnnqOOhVXzZnnttOh68=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SBhC/o2+o3BOPHgXYL6Vw0hkGHsoEkisWA8iLG52HaHnE0LGKuxCcpOhUZzlNNAy4e4awRMu2cCzoqlxFkXrTgTxtnn6c699qMESP7d1DUpKWFgG2HBnd9kztaIF8pwLlLXWfdUl2TMMZc9DV8qwEugJeYpIwF09+E/OxNpBPv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=JIUjrlUi; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [192.168.178.121] (p5dc880d2.dip0.t-ipconnect.de [93.200.128.210])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 6087lQgk005449
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 8 Jan 2026 08:47:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1767858447;
	bh=D4+VOMbH/tWXjB2Stkdshvm7QnnqOOhVXzZnnttOh68=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JIUjrlUi3NJ922vWQgcc+tOKn6Qybb2yFqs5m+kibnvBhElSVg7si8rWq+q3XFJT0
	 n5UgwNghHm5wg49SltXX5ROhtuzCmI/o7Vpf2BTRDvlVJ/Fz5YVTeDxCYMempmB3/N
	 miux8cKzIfQQYW7FQPbEJQzcmGDjnPHg5SKCJcz8=
Message-ID: <5961e982-9c52-4e7a-b1ca-caaf4c4d0291@tu-dortmund.de>
Date: Thu, 8 Jan 2026 08:47:26 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH net-next v7 7/9] vhost-net: vhost-net: replace rx_ring with
 tun/tap ring wrappers
To: Jason Wang <jasowang@redhat.com>
Cc: willemdebruijn.kernel@gmail.com, andrew+netdev@lunn.ch,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, eperezma@redhat.com,
        leiyang@redhat.com, stephen@networkplumber.org, jon@nutanix.com,
        tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
 <20260107210448.37851-8-simon.schippers@tu-dortmund.de>
 <CACGkMEtndGm+GX+3Kn5AWTkEc+PK0Fo1=VSZzhgBQoYRQbicQw@mail.gmail.com>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <CACGkMEtndGm+GX+3Kn5AWTkEc+PK0Fo1=VSZzhgBQoYRQbicQw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/8/26 05:38, Jason Wang wrote:
> On Thu, Jan 8, 2026 at 5:06 AM Simon Schippers
> <simon.schippers@tu-dortmund.de> wrote:
>>
>> Replace the direct use of ptr_ring in the vhost-net virtqueue with
>> tun/tap ring wrapper helpers. Instead of storing an rx_ring pointer,
>> the virtqueue now stores the interface type (IF_TUN, IF_TAP, or IF_NONE)
>> and dispatches to the corresponding tun/tap helpers for ring
>> produce, consume, and unconsume operations.
>>
>> Routing ring operations through the tun/tap helpers enables netdev
>> queue wakeups, which are required for upcoming netdev queue flow
>> control support shared by tun/tap and vhost-net.
>>
>> No functional change is intended beyond switching to the wrapper
>> helpers.
>>
>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>> Co-developed by: Jon Kohler <jon@nutanix.com>
>> Signed-off-by: Jon Kohler <jon@nutanix.com>
>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
>> ---
>>  drivers/vhost/net.c | 92 +++++++++++++++++++++++++++++----------------
>>  1 file changed, 60 insertions(+), 32 deletions(-)
>>
>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
>> index 7f886d3dba7d..215556f7cd40 100644
>> --- a/drivers/vhost/net.c
>> +++ b/drivers/vhost/net.c
>> @@ -90,6 +90,12 @@ enum {
>>         VHOST_NET_VQ_MAX = 2,
>>  };
>>
>> +enum if_type {
>> +       IF_NONE = 0,
>> +       IF_TUN = 1,
>> +       IF_TAP = 2,
>> +};
> 
> This looks not elegant, can we simply export objects we want to use to
> vhost like get_tap_socket()?

No, we cannot do that. We would need access to both the ptr_ring and the
net_device. However, the net_device is protected by an RCU lock.

That is why {tun,tap}_ring_consume_batched() are used:
they take the appropriate locks and handle waking the queue.

> 
> Thanks
> 

