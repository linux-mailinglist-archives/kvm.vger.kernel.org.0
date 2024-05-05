Return-Path: <kvm+bounces-16598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E4618BC368
	for <lists+kvm@lfdr.de>; Sun,  5 May 2024 22:04:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 60AE8B215C9
	for <lists+kvm@lfdr.de>; Sun,  5 May 2024 20:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CDE86DCE8;
	Sun,  5 May 2024 20:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="QZVeGXm2"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0834322611;
	Sun,  5 May 2024 20:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714939477; cv=none; b=g2AlhNeGWKdEKOBY0g/PMAP07suj5eNMKQ6mbqkJ5oWWztT1OD4yEJllAhtbYq1u55gAXlzqeyHuxDRBFWgQT2LGKk8a892TsAPE3ht+aWFBl4YVhO9e8vQVKt2Cmiiz+JOhKNqdviQMTUgupeaKWpaj1NqyOIka9jEgVUugDQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714939477; c=relaxed/simple;
	bh=Pi2/TNVByX0JP5w+l9K3hAIMKCPKrqUeoG/wzKmCyy8=;
	h=Message-ID:Date:MIME-Version:In-Reply-To:To:CC:From:Subject:
	 Content-Type; b=BUt1+DY0QUDlwjWwDZ80Wvexjg01U0Ozd2gXFuITbuZzKJUvHaz4hNOgPhTZthfLjV2qE0+dMmYVrHielVzvyu0Bp+lzgw3jzHyNrNFQvwFa70QLeGDvL6kOmQxxRifjbFi3lBvb/1W6oBwaUNn1mx9couW1m1yYIhTvr9aazck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=QZVeGXm2; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 71468120004;
	Sun,  5 May 2024 23:04:24 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 71468120004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1714939464;
	bh=baxPYAOBKBIEZGlkQCQ94G4LWTk3/f2RFWo2CGnbI50=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type:From;
	b=QZVeGXm2O0TvVnYhTRgVcbUbOlA10QH3bYpOUDTG6g3ocuKRiTu/Cak1yHQ4IkB0M
	 Swu+zNMXwo5hrIv7NjSLcwEwSmzDWOOZHgi8gMiKEWiPOqGVXMJyhRohreoLZ9lwP3
	 dkZEFig6YIuH95ABNnmpvVkWWp3tBs5xUavLMTMZxkm3aelrbMMWGC3cbu9lm31aHn
	 rNzFrX2NBMyKjUAFbClx0JOEbFfuLZhbXEPksySpQRTaf8ozhAtH38IQpAvD3gWQkb
	 OEY2VcPaYL5hkLYHGpsoxVFrCGuGwMk/SK8srzcJ9ynuwu8sI5vPFaafEjF9T4JKkV
	 0BNR+8cZm5AtQ==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Sun,  5 May 2024 23:04:24 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Sun, 5 May 2024 23:04:23 +0300
Message-ID: <d0550fea-58b6-3aa5-a8ac-27308183d6f8@salutedevices.com>
Date: Sun, 5 May 2024 22:53:39 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <20240422100010-mutt-send-email-mst@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, Jeongjun Park <aha310510@gmail.com>, Jason Wang
	<jasowang@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, LKML
	<linux-kernel@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com>,
	<syzkaller-bugs@googlegroups.com>, Krasnov Arseniy <oxffffaa@gmail.com>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
Subject: Re: [PATCH virt] virt: fix uninit-value in vhost_vsock_dev_open
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 185060 [May 05 2024]
X-KSMG-AntiSpam-Version: 6.1.0.4
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 19 0.3.19 07c7fa124d1a1dc9662cdc5aace418c06ae99d2b, {Tracking_from_domain_doesnt_match_to}, salutedevices.com:7.1.1;100.64.160.123:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;smtp.sberdevices.ru:7.1.1,5.0.1;127.0.0.199:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/05/05 18:13:00 #25098537
X-KSMG-AntiVirus-Status: Clean, skipped

> But now that it's explained, the bugfix as proposed is incomplete:
> userspace can set features twice and the second time will leak
> old VIRTIO_VSOCK_F_SEQPACKET bit value.
> 
> And I am pretty sure the Fixes tag is wrong.
> 
> So I wrote this, but I actually don't have a set for
> seqpacket to test this. Arseny could you help test maybe?
> Thanks!

Hi! Sorry for late reply! Just run vsock test suite with this patch -
seems everything is ok!

> 
> 
> commit bcc17a060d93b198d8a17a9b87b593f41337ee28
> Author: Michael S. Tsirkin <mst@redhat.com>
> Date:   Mon Apr 22 10:03:13 2024 -0400
> 
> vhost/vsock: always initialize seqpacket_allow
> 
> There are two issues around seqpacket_allow:
> 1. seqpacket_allow is not initialized when socket is
> created. Thus if features are never set, it will be
> read uninitialized.
> 2. if VIRTIO_VSOCK_F_SEQPACKET is set and then cleared,
> then seqpacket_allow will not be cleared appropriately
> (existing apps I know about don't usually do this but
> it's legal and there's no way to be sure no one relies
> on this).
> 
> To fix:
>     - initialize seqpacket_allow after allocation
>     - set it unconditionally in set_features
> 
> Reported-by: syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com
> Reported-by: Jeongjun Park <aha310510@gmail.com>
> Fixes: ced7b713711f ("vhost/vsock: support SEQPACKET for transport").
> Cc: Arseny Krasnov <arseny.krasnov@kaspersky.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Arseniy Krasnov <avkrasnov@salutedevices.com>

> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index ec20ecff85c7..bf664ec9341b 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -667,6 +667,7 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
>  	}
>  
>  	vsock->guest_cid = 0; /* no CID assigned yet */
> +	vsock->seqpacket_allow = false;
>  
>  	atomic_set(&vsock->queued_replies, 0);
>  
> @@ -810,8 +811,7 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
>  			goto err;
>  	}
>  
> -	if (features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
> -		vsock->seqpacket_allow = true;
> +	vsock->seqpacket_allow = features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET);
>  
>  	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
>  		vq = &vsock->vqs[i];



