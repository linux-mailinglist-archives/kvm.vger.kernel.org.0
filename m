Return-Path: <kvm+bounces-39859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D055DA4B7DC
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 07:20:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F07CC16A773
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 06:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A0371E7C05;
	Mon,  3 Mar 2025 06:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="n4GHLkjH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAC21E0B91
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 06:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740982842; cv=none; b=XpupQF2RkCuZf1UQ21FGgBUHdkAiCMWXwoFuENj7e7GMimufBAt5sFP3/9qfMs6CDufyBGoeuTChcndEOy83fU2x/0WSwX5yngCebtfBi+adUejhmChrhi1dv0S0oVaVv59igfAzawcZoMMnONZcxfrcsx5yKmbdS3rgg6yywjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740982842; c=relaxed/simple;
	bh=xnkf9dHEY/bxJnJp3UuspjIPE+0ejwYLRa1u2I2pWLw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F26KNtzuGRKublzNkVW4Z6oj9bbo3MW3VQBd1NscwFGLbKGBKObJAJGJmJkvY/eUg0buP1yU5NVatOVLKYn7KpVw/iRzCoOV21sD/yUYR01xkM8ciIyH46wA/CtDJ25fj4SdSfaYBg9XoTU/k0KPaiF/IsYiRw6Qu5stnV6LQDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=n4GHLkjH; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-22185cddbffso83992725ad.1
        for <kvm@vger.kernel.org>; Sun, 02 Mar 2025 22:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1740982840; x=1741587640; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dyr2GA3li0orAMv11T62PbEJr2SsMfqcDoVbAywiFjQ=;
        b=n4GHLkjHDB19+s2CbedRjrcjp3Cnndf7K9chgfbcrOk5G748SCu80SjY9wpDEI5sI7
         Zg20PPbKFJqNI7ezc/NtdeoxeM4XqKewFfQwHlRdFCkHSV2tVP9a/huDBA4TMQvDMc2p
         imbs5qZ+s+bsTiq70qf5Z78pZlLzd9+zY8L3f9GMHlqf6wholg71sPtsfwOLNdyO+po7
         OABDt0UAozddrEPAe2fEgg4LdCFiAITPd5QpgaqQKINIPXpfOvLEeRlHWR8K6ko9vYgW
         8LxitVKYYPB6fN66UamaS5nPf+qCqyGm7YeCvYFeCvH8zl3aaQ32p+NvJRqnhj2CWvwb
         ngYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740982840; x=1741587640;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dyr2GA3li0orAMv11T62PbEJr2SsMfqcDoVbAywiFjQ=;
        b=GSaoYEeMbgIFGPnbf3MCiXyxmWns/RmOFSHRLsCC/vvP+78onEkZ1jgTpQo/iVk9DA
         Fu7gn+Fv1nyX3QhZBvq23/AldsEdRXm6Ws/8Ry5sz38gaW34o6H+vkkRkjqtlcsd7MEC
         RgneiMk2Yp9ebsp5DZXFYPbBVW4kaX41c4Eo/LfyrLIIkxq6xmOGY7pyy5VHXWNbztzO
         OM1qH4gvQrp1ZhGAMaw1IcEfjYSyxRQJNtfntzT4688j2liQNTM9hFadzmiSiBTDNOow
         Dhu6XgoOOEsFtQgB54b3bOekQG4MjbV/YroX0a7Cw3JUSD5UR8MKp4B6eQVg+gBPK4B3
         QE/g==
X-Forwarded-Encrypted: i=1; AJvYcCWcmzYkJpg4WuT4tb6EGd/ljtuoDcHJXScLVkh3YnLo72AjEExLqcgTGTrpNKpfTd40eMg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yws8KmeA813BIOl7uJJyLBRC66oyw+ojDDdsV/ozz8IuF1aFYlB
	Xk3Bv8nGzMfEF2jH/Tuk1GQGQcSLSd9nhSgclKVM46vVd1F5Mj7MtA7e5hGIbfo=
X-Gm-Gg: ASbGncv2vDTn/KWge9iiQFruCt9BliGQil7lJ4Dl4EVp/XvszjrPuhakDSjoyRb0QGS
	4WUTTBGYfyS6vQMfr+6DD/Af+IuOjOPExWPMA7t8tBk/KXSADwwJ0J2plDiMqZvvJclMF7w73pz
	tDBGoyRjVLIZ04DBUkHU5rUvY0ZRnQb3gCPNUO6rY+V0WvGtGEx+WxvUbjtoWKl2nMqJ7zxhgJY
	SQqTDYr3Nv+WL0b9e4E2n4cTSUvlSVc+3WTZEIvAmz/SvH8S/suK3QLEMsZwCQzWATZxUkVGxiH
	FqK6SR7Vy3fXuUWYsGlwlu0sFL+0h8VO3xqbZOKfZbnGGr7duSWUnHbzvA==
X-Google-Smtp-Source: AGHT+IEieq/BD1K+cE8LpIHguGq+X9OAmHwKGwyKh2uFq+hVqj0tth75vrcZnQUypyq8Bcdl5DillA==
X-Received: by 2002:aa7:8207:0:b0:734:26c6:26d3 with SMTP id d2e1a72fcca58-7349d1ec1a1mr23805966b3a.5.1740982838260;
        Sun, 02 Mar 2025 22:20:38 -0800 (PST)
Received: from [157.82.207.107] ([157.82.207.107])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736614c13dcsm414807b3a.42.2025.03.02.22.20.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 22:20:37 -0800 (PST)
Message-ID: <0ec77558-bdfb-4471-a44b-0a37a9422f72@daynix.com>
Date: Mon, 3 Mar 2025 15:20:33 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v7 5/6] selftest: tun: Add tests for virtio-net
 hashing
To: Jakub Kicinski <kuba@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Jason Wang <jasowang@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org,
 Yuri Benditovich <yuri.benditovich@daynix.com>,
 Andrew Melnychenko <andrew@daynix.com>,
 Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com,
 Lei Yang <leiyang@redhat.com>
References: <20250228-rss-v7-0-844205cbbdd6@daynix.com>
 <20250228-rss-v7-5-844205cbbdd6@daynix.com>
 <20250228062947.7864a59c@kernel.org>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <20250228062947.7864a59c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/02/28 23:29, Jakub Kicinski wrote:
> On Fri, 28 Feb 2025 16:58:51 +0900 Akihiko Odaki wrote:
>> The added tests confirm tun can perform RSS and hash reporting, and
>> reject invalid configurations for them.
> 
> The tests may benefit from using FIXTURE_VARIANT(), up to you.

I took a look at it after seeing your suggestion, but it is 
unfortunately not straightfoward to use FIXTURE_VARIANT() for them
so I'll leave it as is. The problem is that a packet for each test has a 
different type and requires different functions to construct.

Tests added in "[PATCH net-next v7 4/6] selftest: tun: Test vnet ioctls 
without device" are easier to adopt FIXTURE_VARIANT(), but one 
exceptional test case, which is for TUNGETVNETHASHCAP, does not fit well 
so I also keep the current form.

Thank you for your suggestion anyway.

> 
> The IPv4 tests fail reliably on a VM with a debug kernel
> (kernel/configs/debug.config included in the config):
> 
> # 5.90 [+0.00] ok 14 tun_vnet_hash.unclassified
> # 5.90 [+0.00] #  RUN           tun_vnet_hash.ipv4 ...
> # 6.18 [+0.28] # tun.c:669:ipv4:Expected 0 (0) != tun_vnet_hash_check(self->source_fd, self->dest_fds, &packet, sizeof(packet), 0, VIRTIO_NET_HASH_REPORT_IPv4, 0x6e45d952) (0)
> # 15.09 [+8.92] # ipv4: Test failed
> # 15.10 [+0.00] #          FAIL  tun_vnet_hash.ipv4
> # 15.10 [+0.00] not ok 15 tun_vnet_hash.ipv4
> # 15.10 [+0.00] #  RUN           tun_vnet_hash.tcpv4 ...
> # 15.36 [+0.26] # tun.c:689:tcpv4:Expected 0 (0) != tun_vnet_hash_check(self->source_fd, self->dest_fds, &packet, sizeof(packet), VIRTIO_NET_HDR_F_DATA_VALID, VIRTIO_NET_HASH_REPORT_TCPv4, 0xfb63539a) (0)
> # 24.76 [+9.40] # tcpv4: Test failed
> # 24.76 [+0.00] #          FAIL  tun_vnet_hash.tcpv4
> # 24.76 [+0.00] not ok 16 tun_vnet_hash.tcpv4
> # 24.77 [+0.00] #  RUN           tun_vnet_hash.udpv4 ...
> # 25.05 [+0.28] # tun.c:710:udpv4:Expected 0 (0) != tun_vnet_hash_check(self->source_fd, self->dest_fds, &packet, sizeof(packet), VIRTIO_NET_HDR_F_DATA_VALID, VIRTIO_NET_HASH_REPORT_UDPv4, 0xfb63539a) (0)
> # 32.11 [+7.06] # udpv4: Test failed
> # 32.11 [+0.00] #          FAIL  tun_vnet_hash.udpv4
> # 32.11 [+0.00] not ok 17 tun_vnet_hash.udpv4

I cannot reproduce the failure. What commit did you apply this patch 
series on? What architecture did the kernel run on?

