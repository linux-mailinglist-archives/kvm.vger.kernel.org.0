Return-Path: <kvm+bounces-22721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D6199425B4
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 07:18:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29453285829
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 05:18:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 821341B964;
	Wed, 31 Jul 2024 05:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="COsV8Egc"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7F02C18C;
	Wed, 31 Jul 2024 05:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.18.73.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722403104; cv=none; b=Vx/L6nYt3ODP9gBWzck2+2VwDlMt0JCOZly7s8qJaZZsdXzYVYiwMCsjDHX5XF0xNA8LJoQ0/y3+XTtt7mATbEd6xgeX29ujhSbCgRWWthgOeY8tzaI8ovdEFOlmZXUaV53uz9haepL4R9mzz9sv7x5pTaeHQPwkFVJOvQnl97E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722403104; c=relaxed/simple;
	bh=d/g3cvd71cjxo4f8aYUx38es4sT0exFH+mH6E6h+fvg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=hDAkE9BTV0oxkxHpx7Ly4F0LPCSVjmn/1uPUXoUPUaFFIkRggU8qkQg6/p+35FzgcPEZSZeo8m4h95yFLr8Zfa0LkufJhyqiRb+3BI+PH80qXkeJ/+dsIWatJDRYXvMp7IyB9iXZNP4lgMgZXb1qtH/fjLNbn4J2U7EtcKp7zyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=COsV8Egc; arc=none smtp.client-ip=37.18.73.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Received: from p-infra-ksmg-sc-msk01.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id E3270100005;
	Wed, 31 Jul 2024 08:18:15 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru E3270100005
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1722403095;
	bh=ID4SggLsgqR37STZ/X3m9Sm1/hn1duaRiG2BUha9C/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=COsV8EgchkgX8CqDAGhjv58AgSpmh0ur+Ivh5zG0mVrxtBAHquYnbr6XYpmIV0H3X
	 iiVNYtPV5d85aMD+G54sVIElxqd0asQJ4CgVbwgUBCYqqagpcq1QIEPJgcnizLRh3+
	 7vWyUxVUviHsP5poTtHarUIEZSnWeEVv+85/DiHfNlZvP/NE43MD63naqrAlPHsWj1
	 Aek2tTtHm/qU6s474iKOWkqZ74qT9nPp1haCbZf5dPfpPHx/kWWIuYtq95zISbNNeG
	 Dz7hswKc9z7lKrc3FXu87aPkW6c/rh/EVrIr6+UgELqvsZ/v48dzofAGzEVkloiHql
	 m2Y9I4Fj0lEQg==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Wed, 31 Jul 2024 08:18:15 +0300 (MSK)
Received: from [172.28.128.200] (100.64.160.123) by
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Wed, 31 Jul 2024 08:18:14 +0300
Message-ID: <699345d9-a461-fca7-52a1-ec472753c04c@salutedevices.com>
Date: Wed, 31 Jul 2024 08:05:53 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v1] MAINTAINERS: add me as reviewer of AF_VSOCK and
 virtio-vsock
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>, Jakub Kicinski <kuba@kernel.org>
CC: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20240728183325.1295283-1-avkrasnov@salutedevices.com>
 <20240730084707.72ff802c@kernel.org>
 <20240730175120-mutt-send-email-mst@kernel.org>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <20240730175120-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 186797 [Jul 30 2024]
X-KSMG-AntiSpam-Version: 6.1.0.4
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 24 0.3.24 186c4d603b899ccfd4883d230c53f273b80e467f, {Tracking_arrow_text}, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;salutedevices.com:7.1.1;smtp.sberdevices.ru:7.1.1,5.0.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;100.64.160.123:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/07/31 01:43:00 #26186861
X-KSMG-AntiVirus-Status: Clean, skipped



On 31.07.2024 00:54, Michael S. Tsirkin wrote:
> On Tue, Jul 30, 2024 at 08:47:07AM -0700, Jakub Kicinski wrote:
>> On Sun, 28 Jul 2024 21:33:25 +0300 Arseniy Krasnov wrote:
>>> I'm working on AF_VSOCK and virtio-vsock.
>>
>> If you want to review the code perhaps you can use lore+lei
>> and filter on the paths?
>>
>> Adding people to MAINTAINERS is somewhat fraught.
> 
> Arseniy's not a newbie in vsock, but yes, I'd like to first
> see some reviews before we make this formal ;)

Ok, thanks :)

> 

