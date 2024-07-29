Return-Path: <kvm+bounces-22481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD81F93ECFC
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 07:24:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95D50281410
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 05:24:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE14C83A0E;
	Mon, 29 Jul 2024 05:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="lhh6ZIfY"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE33D163;
	Mon, 29 Jul 2024 05:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.18.73.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722230676; cv=none; b=GJOxlxgWuzwx2NgHSSpvZAPEkGsn8fwn7WSuUDXbSfGbK0DCu5dBybvaPWwpiB4GiHfAJrMU87aB7auCwTk6HLAx8WkQPJQsivbpX9jec9HlB6MiPBJdmbP8PDoNU44SH+lzZc70qTfDP7Czg6EdxJhd3fVRrmhpF/p6xHyjHeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722230676; c=relaxed/simple;
	bh=JHHSsVN1xckOuK6pCyADpkc+mUFv/GHr9pBfvGYfRpY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=IxPBgNxALOLRjDfEw10UlIMrrATvWWSJ014Odf0hcKNqwWF9ILiQ5dJteq4W+Cjs51iaH2e6mNHMqncjInNrLNSy+WTsSWQmEizswfAqE1C+lv2CPYnRcJarjRNfDRD55vTehX8WyEhrbo1m/CiHcGYX0Uf7hA6pxKdIfQ/ec34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=lhh6ZIfY; arc=none smtp.client-ip=37.18.73.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Received: from p-infra-ksmg-sc-msk01.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 6494F10000C;
	Mon, 29 Jul 2024 08:24:26 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 6494F10000C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1722230666;
	bh=qeeVtJlCf5axENU0rub/loEi8Dfa3CRnEYUqvntC4d8=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=lhh6ZIfYMkAUa9e0lQ9lHRz5ow8UhMx6FgI4iDaJJC8qm+Zp53iDU8fDwjdlOZnwD
	 PSnNpSpc8NY4lMgkrNAqC0d/rkt2gaM39dHPh4v+CFe1BtwZ/vktlKQNfm95yWYLAM
	 I8RHz4rf1jwqFiMSFBB+E7KZ874/tkKWMjT8r1Xt0E5pSp26lRMmSKRlrP8r+BrqcN
	 ZtCF+FKdxymMYKTBCM1UX7PbLD0X3AIzXG5OaIiz5vE3osgzdKZ4Bi/SLxvllk8iV1
	 rI8xJ7uKopKYQp37dMxdY2umKIdH4HO2q6mGG+zpwZ1naJsykHXzBgvgsA7pwZa83D
	 f/d+GeWUBr9og==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Mon, 29 Jul 2024 08:24:26 +0300 (MSK)
Received: from [172.28.192.160] (100.64.160.123) by
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Mon, 29 Jul 2024 08:24:24 +0300
Message-ID: <7416dd44-4f89-bd97-4925-1aa5a2588e76@salutedevices.com>
Date: Mon, 29 Jul 2024 08:12:07 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH net-next v6 03/14] af_vsock: support multi-transport
 datagrams
Content-Language: en-US
To: Amery Hung <ameryhung@gmail.com>
CC: <stefanha@redhat.com>, <sgarzare@redhat.com>, <mst@redhat.com>,
	<jasowang@redhat.com>, <xuanzhuo@linux.alibaba.com>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<kys@microsoft.com>, <haiyangz@microsoft.com>, <wei.liu@kernel.org>,
	<decui@microsoft.com>, <bryantan@vmware.com>, <vdasa@vmware.com>,
	<pv-drivers@vmware.com>, <dan.carpenter@linaro.org>,
	<simon.horman@corigine.com>, <oxffffaa@gmail.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<bpf@vger.kernel.org>, <bobby.eshleman@bytedance.com>,
	<jiang.wang@bytedance.com>, <amery.hung@bytedance.com>,
	<xiyou.wangcong@gmail.com>, <kernel@sberdevices.ru>
References: <20240710212555.1617795-4-amery.hung@bytedance.com>
 <ce580c81-36a1-8b3b-b73f-1d88c5ec72b6@salutedevices.com>
 <CAMB2axNUbWD9=Xg8TkB8XBmjuNw9f==Njzvh4-OP8kNw40O0Lw@mail.gmail.com>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <CAMB2axNUbWD9=Xg8TkB8XBmjuNw9f==Njzvh4-OP8kNw40O0Lw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 186756 [Jul 28 2024]
X-KSMG-AntiSpam-Version: 6.1.0.4
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 24 0.3.24 186c4d603b899ccfd4883d230c53f273b80e467f, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;smtp.sberdevices.ru:5.0.1,7.1.1;salutedevices.com:7.1.1;127.0.0.199:7.1.2;100.64.160.123:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/07/29 03:24:00 #26172608
X-KSMG-AntiVirus-Status: Clean, skipped



On 29.07.2024 00:53, Amery Hung wrote:
> On Sun, Jul 28, 2024 at 1:40 PM Arseniy Krasnov
> <avkrasnov@salutedevices.com> wrote:
>>
>> Hi Amery
>>
>>>  /* Transport features flags */
>>>  /* Transport provides host->guest communication */
>>> -#define VSOCK_TRANSPORT_F_H2G                0x00000001
>>> +#define VSOCK_TRANSPORT_F_H2G                        0x00000001
>>>  /* Transport provides guest->host communication */
>>> -#define VSOCK_TRANSPORT_F_G2H                0x00000002
>>> -/* Transport provides DGRAM communication */
>>> -#define VSOCK_TRANSPORT_F_DGRAM              0x00000004
>>> +#define VSOCK_TRANSPORT_F_G2H                        0x00000002
>>> +/* Transport provides fallback for DGRAM communication */
>>> +#define VSOCK_TRANSPORT_F_DGRAM_FALLBACK     0x00000004
>>>  /* Transport provides local (loopback) communication */
>>> -#define VSOCK_TRANSPORT_F_LOCAL              0x00000008
>>> +#define VSOCK_TRANSPORT_F_LOCAL                      0x00000008
>>
>> ^^^ This is refactoring ?
>>
> 
> This part contains no functional change.

Ah I see, sorry )

Thanks, Arseniy

> 
> Since virtio dgram uses transport_h2g/g2h instead of transport_dgram
> (renamed totransport_dgam_fallback to in this patch) of VMCI, we
> rename the flags here to describe the transport in a more accurate
> way.
> 
> For a datagram vsock, during socket creation, if VMCI is present,
> transport_dgram will be registered as a fallback.
> 
> During vsock_dgram_sendmsg(), we will always try to resolve the
> transport to transport_h2g/g2h/local first and then fallback on
> transport_dgram.
> 
> Let me know if there is anything that is confusing here.
> 
>>
>>> +             /* During vsock_create(), the transport cannot be decided yet if
>>> +              * using virtio. While for VMCI, it is transport_dgram_fallback.
>>
>>
>> I'm not English speaker, but 'decided' -> 'detected'/'resolved' ?
>>
> 
> Not a native English speaker either, but I think resolve is also
> pretty accurate.
> 
> Thanks,
> Amery
> 
>>
>>
>> Thanks, Arseniy

