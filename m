Return-Path: <kvm+bounces-40741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0880A5B924
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 07:20:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88A383A5A89
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 06:20:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E64B21A45D;
	Tue, 11 Mar 2025 06:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="r0pVdBqS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EEF51E4928
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 06:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741673995; cv=none; b=X46ZyZ0cbgX/azN1yf0343UlYA+jUyoKzxhoNrwEi6J/X7fIVn6qxoQ+DnNFP25Q28bIpr8c+Guhj7i7R19u2yBrrDc5tPsqzpooOVyqS8YLHtMsmOwQ+DFq2VaNChTcGsCptl8UUAbQC6zz/dv6UHB0MHZUc99SeAifIXSuNhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741673995; c=relaxed/simple;
	bh=ZP4EaVCBU43ETX1tsWfetopJ677SR8acZVhOJLrcrw0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XWZh5loYjQPxUju5NmAYBM3zaCLyEaBZycwsYoD/sOjkXJeXkiEqk5r+M914t1aQ8P16EoCuZBU6czij2k12BeONEMPEJMQXIJVRlzO5PmbtFiT/w+b/ooqybjrKZq4235P8G8upAgl9rmsh2hz6EKMAHJPF/ZJYCBLInRYOLDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=r0pVdBqS; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22548a28d0cso2255275ad.3
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 23:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741673992; x=1742278792; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EbcW5/eDAGhdpWi7HyX3jjOdHbLTgrUim/DP0OQGuWo=;
        b=r0pVdBqSlYlaLTahjdTPd8TF3QsBOiOSOqTWeNjGAMKFcI3nXQfondYE+kch38jYSL
         5YwEt4prOcOBGftjrZ1F72y8/J6hrFawCMkGNOP7+u7cJYnWCiXuiIRC2SESSFSS8CHA
         FpBomgMo+qnJRoTHuw9co+mDt0+ce85cp3ZT6HRywW3SPQ4o/xiUA36SkNWtxvrAuT1w
         WQGmmF9NVuhUaZJNg8ARmVSDem38gWxRzgcUhPrBP2GNGfHzkT7cU3GnW9wdecY583rN
         TaB0euWxhno9HQIRt0XJG3o75zVFGnVvvndOBG4FGmbz/S++SRb1q0Bsu7843OPZgFzX
         zPsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741673992; x=1742278792;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EbcW5/eDAGhdpWi7HyX3jjOdHbLTgrUim/DP0OQGuWo=;
        b=m+tN4zAhbGeyGkwvjv2oDd3N9Hxm3ybV/Jl8t8gWgNAq9owBui8yUyVuaW4EoaBGBB
         mcv7Ieict1R/NiLwnR6FbX7kzbiOKZ+HnDYMNHCTbgSNY7nsllAB6FEfdjq5MP7PU3eX
         MNrS8JiGkbtpqB5ZXUTLnJ2w+9cOsVnVQLiz+vEJVwZlnNunuZXSkI2nHa1/fwhN96gH
         xGsyfqgA78+GGjcdtknV9QbGCvTAsq1EjpTMw5Yu5XXSG02oQGtqas3jMfflqrHVGfT/
         0MsFwnmYdc5433hi7pO78YhJr0aeXRmTpg8KKiQzYIgO+Hph6hgU1nPe7/N5r2Wozi0w
         tz7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVwdRkl2WANDPJ7u/VVpopR6H3Z16xCaF9M87EZUDYIQ1okonsnM4j9q9HmQOGKll9AiqI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxK+ZAO1aFRKG4PNhAMg1FhudDL2CIbbDPj9ktLx6smQ7wCJTIA
	j55CLfjColAaaCMut0p+7qQeTFQCushJpLjnYNu+5zn1ElOGvJJNs/Vg8Lc4/k0=
X-Gm-Gg: ASbGncsGZwEAOakn8sGVgNcPsNHHXCmfovcQKO69fKeM0uR24oVLqMz3v5fS0sx/+D2
	lXZOpqffFsQCo4aGAtJNTX2JXJ1f4dI+vXVPWR0rRmipg9hEt19+6NftH0VeCXr+nt2HBbD70WJ
	mnLQTgwUeThsndH0sR4fACrmwLpwepc9HfMfxTO083HV+142/Lc7QSsgK8R4RnIFdsyowkbgDw/
	GkFFZ6OdWZig+aCQGlq7CkVT0hERfpmGyxlewvktjEArro/rRyG+sOk1BEsZYmFglByH11MwDQH
	rWeccNIjGTLT9XHGn4XEOm7HYxj3wmAL84bQ5XseyJWWnuN4fYp6cPOWnw==
X-Google-Smtp-Source: AGHT+IEO1Addst46ofGtxfDAcyJAfRa7cWyZNqzRhdZXtyiIrODFKfx6qBjS5jqvhrfaOM+pKspNkg==
X-Received: by 2002:a17:902:e802:b0:223:26da:4b6f with SMTP id d9443c01a7336-22428895abfmr268969215ad.14.1741673992501;
        Mon, 10 Mar 2025 23:19:52 -0700 (PDT)
Received: from [157.82.205.237] ([157.82.205.237])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410a7f5dasm89029115ad.137.2025.03.10.23.19.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 23:19:52 -0700 (PDT)
Message-ID: <217fb3ef-336d-4141-b47e-3236f2c22ec3@daynix.com>
Date: Tue, 11 Mar 2025 15:19:47 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v9 5/6] selftest: tun: Add tests for virtio-net
 hashing
To: Jason Wang <jasowang@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org,
 Yuri Benditovich <yuri.benditovich@daynix.com>,
 Andrew Melnychenko <andrew@daynix.com>,
 Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com,
 Lei Yang <leiyang@redhat.com>, Simon Horman <horms@kernel.org>
References: <20250307-rss-v9-0-df76624025eb@daynix.com>
 <20250307-rss-v9-5-df76624025eb@daynix.com>
 <CACGkMEuTwd4+DP1Cb+ZgJtxTiJj4N_NMPHiKusd8a4Tn3+B_3A@mail.gmail.com>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <CACGkMEuTwd4+DP1Cb+ZgJtxTiJj4N_NMPHiKusd8a4Tn3+B_3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025/03/10 13:03, Jason Wang wrote:
> On Fri, Mar 7, 2025 at 7:02 PM Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>
>> The added tests confirm tun can perform RSS and hash reporting, and
>> reject invalid configurations for them.
> 
> Let's be more verbose here. E.g what's the network topology used here.

The network topology doesn't matter because this only tests the rx of 
one device.

I can still add more details; it tests all supported hash types, and 
tests both the queue selection and reported hash values.

And this message is wrong in terms that it does not test validation of 
configuration so it also needs correction.

> 
>>
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>> Tested-by: Lei Yang <leiyang@redhat.com>
>> ---
>>   tools/testing/selftests/net/Makefile |   2 +-
>>   tools/testing/selftests/net/tun.c    | 584 ++++++++++++++++++++++++++++++++++-
>>   2 files changed, 576 insertions(+), 10 deletions(-)
>>
>> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
>> index 73ee88d6b043004be23b444de667a1d99a6045de..9772f691a9a011d99212df32463cdb930cf0a1a0 100644
>> --- a/tools/testing/selftests/net/Makefile
>> +++ b/tools/testing/selftests/net/Makefile
>> @@ -123,6 +123,6 @@ $(OUTPUT)/reuseport_bpf_numa: LDLIBS += -lnuma
>>   $(OUTPUT)/tcp_mmap: LDLIBS += -lpthread -lcrypto
>>   $(OUTPUT)/tcp_inq: LDLIBS += -lpthread
>>   $(OUTPUT)/bind_bhash: LDLIBS += -lpthread
>> -$(OUTPUT)/io_uring_zerocopy_tx: CFLAGS += -I../../../include/
>> +$(OUTPUT)/io_uring_zerocopy_tx $(OUTPUT)/tun: CFLAGS += -I../../../include/
>>
>>   include bpf.mk
>> diff --git a/tools/testing/selftests/net/tun.c b/tools/testing/selftests/net/tun.c
>> index 463dd98f2b80b1bdcb398cee43c834e7dc5cf784..acadeea7194eaea9416a605b47f99f7a5f1f80cd 100644
>> --- a/tools/testing/selftests/net/tun.c
>> +++ b/tools/testing/selftests/net/tun.c
>> @@ -2,21 +2,38 @@
>>
>>   #define _GNU_SOURCE
>>
>> +#include <endian.h>
>>   #include <errno.h>
>>   #include <fcntl.h>
>> +#include <sched.h>
> 
> Is this needed?

Yes, it is for unshare().

> 
>> +#include <stddef.h>
>>   #include <stdio.h>
>>   #include <stdlib.h>
>>   #include <string.h>
>>   #include <unistd.h>
>> -#include <linux/if.h>
>> +#include <net/if.h>
>> +#include <netinet/ip.h>
>> +#include <sys/ioctl.h>
>> +#include <sys/socket.h>
>> +#include <linux/compiler.h>
>> +#include <linux/icmp.h>
>> +#include <linux/if_arp.h>
>>   #include <linux/if_tun.h>
>> +#include <linux/ipv6.h>
>>   #include <linux/netlink.h>
>>   #include <linux/rtnetlink.h>
>> -#include <sys/ioctl.h>
>> -#include <sys/socket.h>
>> +#include <linux/sockios.h>
>> +#include <linux/tcp.h>
>> +#include <linux/udp.h>
>> +#include <linux/virtio_net.h>
>>
>>   #include "../kselftest_harness.h"
>>
>> +#define TUN_HWADDR_SOURCE { 0x02, 0x00, 0x00, 0x00, 0x00, 0x00 }
>> +#define TUN_HWADDR_DEST { 0x02, 0x00, 0x00, 0x00, 0x00, 0x01 }
>> +#define TUN_IPADDR_SOURCE htonl((172 << 24) | (17 << 16) | 0)
>> +#define TUN_IPADDR_DEST htonl((172 << 24) | (17 << 16) | 1)
>> +
>>   static int tun_attach(int fd, char *dev)
>>   {
>>          struct ifreq ifr;
>> @@ -39,7 +56,7 @@ static int tun_detach(int fd, char *dev)
>>          return ioctl(fd, TUNSETQUEUE, (void *) &ifr);
>>   }
>>
>> -static int tun_alloc(char *dev)
>> +static int tun_alloc(char *dev, short flags)
>>   {
>>          struct ifreq ifr;
>>          int fd, err;
>> @@ -52,7 +69,8 @@ static int tun_alloc(char *dev)
>>
>>          memset(&ifr, 0, sizeof(ifr));
>>          strcpy(ifr.ifr_name, dev);
>> -       ifr.ifr_flags = IFF_TAP | IFF_NAPI | IFF_MULTI_QUEUE;
>> +       ifr.ifr_flags = flags | IFF_TAP | IFF_NAPI | IFF_NO_PI |
>> +                       IFF_MULTI_QUEUE;
>>
>>          err = ioctl(fd, TUNSETIFF, (void *) &ifr);
>>          if (err < 0) {
>> @@ -64,6 +82,40 @@ static int tun_alloc(char *dev)
>>          return fd;
>>   }
>>
>> +static bool tun_add_to_bridge(int local_fd, const char *name)
>> +{
> 
> I wonder if a packet socket is more convenient here.

I'll try it. Thanks for suggestion.

Regards,
Akihiko Odaki

> 
> Thanks
> 


