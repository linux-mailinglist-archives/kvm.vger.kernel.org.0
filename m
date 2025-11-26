Return-Path: <kvm+bounces-64637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id B1B5DC88EF9
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 10:26:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0DAED355C20
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 09:25:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3995431B838;
	Wed, 26 Nov 2025 09:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="aASOKI8k"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927BB31AF3F;
	Wed, 26 Nov 2025 09:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764149094; cv=none; b=esB7ZJUjR7WOdw9EMa/nbA5wExMWcePemP8oQaupAilnSjiIJMx1igk4+GcHt1+1bIWe+wYGsfJCEzmfGdqGly+8szPTMSaeqPEN0J+4bWorN31KyOZqHSEN2bx1voFafaaiSZP9mBQ3kS8p6vnQJGCS5DG9AWpukGHLSvix724=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764149094; c=relaxed/simple;
	bh=7VTWCzte1EfKGKmLVq1yaZwVoVRWDe1aGMmitEojN7M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iSuAmQqKSz/XaRgMit++efXmM5lXFhJiLtHUvV7PVObERIrL1g1RApIlnWDnLaJrP8E+ClOgud+XAkzUnylIVEUQ/NOm9/164ajZhqRqAdKi1sJsfAMan2z8YqyI0bHZ4jI7BHqxAHlo+p/Eq5DZB7YCI0rfTFqeIDloQsfQprM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=aASOKI8k; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [129.217.186.248] ([129.217.186.248])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 5AQ9OhSB003998
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 10:24:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1764149083;
	bh=7VTWCzte1EfKGKmLVq1yaZwVoVRWDe1aGMmitEojN7M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aASOKI8kUL2H9I+qMmTsEud3+WUWpK7Ir9IKspC1KOdkD/FxWUsqCPamTD7SILa49
	 fnM//TGAQXNPKrxiq0bVC+jEtyGWnyBH4VBwSajHO6ovInJklAVuA/S+jSl8IlG1jN
	 A96YYepdNeyqsGuhzmo9EbHHG9sb5LsVdN5SogDM=
Message-ID: <2bc56d3e-f4da-41d5-ab63-29c63525eb30@tu-dortmund.de>
Date: Wed, 26 Nov 2025 10:24:42 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH net-next v6 0/8] tun/tap & vhost-net: netdev queue flow
 control to avoid ptr_ring tail drop
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, willemdebruijn.kernel@gmail.com,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, eperezma@redhat.com,
        jon@nutanix.com, tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
References: <20251120152914.1127975-1-simon.schippers@tu-dortmund.de>
 <CACGkMEuboys8sCJFUTGxHUeouPFnVqVLGQBefvmxYDe4ooLfLg@mail.gmail.com>
 <b9fff8e1-fb96-4b1f-9767-9d89adf31060@tu-dortmund.de>
 <20251126021327-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <20251126021327-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/26/25 08:15, Michael S. Tsirkin wrote:
> On Fri, Nov 21, 2025 at 10:22:54AM +0100, Simon Schippers wrote:
>> I agree, but I really would like to reduce the buffer bloat caused by the
>> default 500 TUN / 1000 TAP packet queue without losing performance.
> 
> that default is part of the userspace API and can't be changed.
> just change whatever userspace is creating your device.
> 

Yes, but I’m thinking about introducing a new interface flag like
IFF_BQL. However, as noted earlier, there are significant implementation
challenges.

I think there can be advantages to something like VPN's on mobile
devices where the throughput varies between a few Mbit/s (small TUN/TAP
queue is fine) and multiple Gbit/s (need a bigger queue).

