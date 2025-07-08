Return-Path: <kvm+bounces-51795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38ED1AFD26C
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 18:46:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C10C1169AD0
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 16:43:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6724E2E54B5;
	Tue,  8 Jul 2025 16:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SKl9JPb3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19908F5B
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 16:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993006; cv=none; b=J6BEHo+Ll9UsADxQhiUn6tE96uWLHskyfAy1mduNZ/8do/SVIBuSTRc2dP2P8KMcB2eQdNcjTZV5trguPTX/eBsUHBma5Uvf2LSICMql9eLcuqvo9OZAbzHDNUkCV1geTluM9U+dIQQmBn4Ttvz29r2cqGtfpdVRyM5K7KI+I4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993006; c=relaxed/simple;
	bh=zQQQOEa5mGNWa7KTGLmTSEf3V/CaEx2+ad3NkwQOBVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qlz1/qDv0HU0Goocvt5+DzsWoEovaFdRK5wGRVJSS+VqLTLRu3cmHlZZ1ERxfe4wbiduEFkmLnZPazTEXFio+wW4/av0RqjYJ2OPjv7iZCA6wFg/qZ6svlznRQq7r24Q25sohO+orRVkexg5/N2K0YPLBZJJAmSaauMRvbUgGq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SKl9JPb3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751993003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mRu3ITxR3iyfhxILJrwVnHOIYgR/CWymufaJy1Cpzno=;
	b=SKl9JPb39uEDA2I3EKz7zSgU4JGx2mhgPxKg2Lr4Z01pQE5MZ9mJMjuLFlnTsTC6/X/z3X
	utLmi9hLMBYP5uTHzve8rVM+rDzgtqnLy1YCO2qLkloc6hexXds3JbpYKc8UYrom6+O+ir
	cGPNmaum0Wo1XVifa+HS/7X9SRHwyJE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-JfuK92_BOWyLEPwoB1r5aw-1; Tue, 08 Jul 2025 12:43:21 -0400
X-MC-Unique: JfuK92_BOWyLEPwoB1r5aw-1
X-Mimecast-MFC-AGG-ID: JfuK92_BOWyLEPwoB1r5aw_1751993000
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-450d6768d4dso26387345e9.2
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 09:43:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751993000; x=1752597800;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mRu3ITxR3iyfhxILJrwVnHOIYgR/CWymufaJy1Cpzno=;
        b=rjXSwJyfubfuCosE0uYzhfd5q0RDSMjyQm5doU1/0QGXjzyFdXPyKiCFgxF/KjbA6c
         R/ECxTZwA2y+l1eRiJ07GQOG3NGrvqPbg3H8CJbaFIi81xTj7jpXX6z4SztarxUxIVNv
         pM2t3jrPktSzNrT8v86gZbwC0UlTdLyf/PQ/qh2aztKR9m56Zjy4rRQpb/j52HMqDsRc
         jkJYRWaIF1OsVK/YyMkDgItD4/31tMcM/XMErkOV0lekGUp6sJc+pi8yONT2MpqO+tVY
         v8y2TylRn3p1sqL7ItRYsuVSGmn+aBctI1M2LxNLC4OlrrJEFcSk+37SJuqH+1X7eDOG
         cC9w==
X-Forwarded-Encrypted: i=1; AJvYcCV6wJPwI0syhR06Xt8t2Rn6iLnIDwI0Awii9ap96cJQowTzT9xIm2PiKaM3yF9r6FEiLys=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2RGWyZh2yfeEc4D9+hdnhYKSTgxmuhhqRV2R9BeiTPXEXm2u9
	nxTYz5425cg8O3LSbYXrA/gy6Uklc21S6qPOxjqj+iwx6wJzFlr9i2p1PzUV7SuJ7CE3arDJFw7
	S409YwoXKa6vw57rxYLeqbjMy8eBvqbK0tY+80U3k4k2oL9MKSX5AjA==
X-Gm-Gg: ASbGnct5mFfOxKi6UTGRNICYchoPgpXiZg5mPDgYHFTveTd5dU9fxcORXpW4B/7RSMM
	nvN/uMIDt2I6E9IOvmmOLI7xtBTS4BNI45TqtpuRz3Agss26g/l+xpFnZRKRb3Vis8eNCJ8iqHz
	eQXU0moNRW2u1shyVR5boEJzeTivikLJxBsSM16EzwHow+C3wHJaoEHzBEgCIhDKy7/2aRqpDPa
	5JIfFxpRwCVXsV/DEqaVJ75fo/URRUOdKwWELl22pPxQV4Jz7ff3GLJtMQPAqd9IPl7U5n432/o
	KgYZJrk0CLBZISjyNg764gqUf02lAOqbdU8Epc5K0OecmYDE1inzZ3vn8IGoFLWUugirPw==
X-Received: by 2002:a05:6000:2087:b0:3a4:ee3f:8e1e with SMTP id ffacd0b85a97d-3b4964e5281mr14417951f8f.39.1751993000351;
        Tue, 08 Jul 2025 09:43:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEoaIacReEb0vPyg2KsNrIYN4x3Ccy8WpA/YPm0UdY/EajOw0cVDGdH65ySWm0a4fAJVxH+hQ==
X-Received: by 2002:a05:6000:2087:b0:3a4:ee3f:8e1e with SMTP id ffacd0b85a97d-3b4964e5281mr14417934f8f.39.1751992999900;
        Tue, 08 Jul 2025 09:43:19 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2717:8910:b663:3b86:247e:dba2? ([2a0d:3344:2717:8910:b663:3b86:247e:dba2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b472446fddsm13597522f8f.66.2025.07.08.09.43.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 09:43:19 -0700 (PDT)
Message-ID: <27d6b80a-3153-4523-9ccf-0471a85cb245@redhat.com>
Date: Tue, 8 Jul 2025 18:43:17 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 net-next 0/9] virtio: introduce GSO over UDP tunnel
To: "Michael S. Tsirkin" <mst@redhat.com>, Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, Jason Wang <jasowang@redhat.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Yuri Benditovich <yuri.benditovich@daynix.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>, Jonathan Corbet <corbet@lwn.net>,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org
References: <cover.1751874094.git.pabeni@redhat.com>
 <20250708105816-mutt-send-email-mst@kernel.org>
 <20250708082404.21d1fe61@kernel.org>
 <20250708120014-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250708120014-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/8/25 6:00 PM, Michael S. Tsirkin wrote:
> On Tue, Jul 08, 2025 at 08:24:04AM -0700, Jakub Kicinski wrote:
>> On Tue, 8 Jul 2025 11:01:30 -0400 Michael S. Tsirkin wrote:
>>>> git@github.com:pabeni/linux-devel.git virtio_udp_tunnel_07_07_2025
>>>>
>>>> The first 5 patches in this series, that is, the virtio features
>>>> extension bits are also available at [2]:
>>>>
>>>> git@github.com:pabeni/linux-devel.git virtio_features_extension_07_07_2025
>>>>
>>>> Ideally the virtio features extension bit should go via the virtio tree
>>>> and the virtio_net/tun patches via the net-next tree. The latter have
>>>> a dependency in the first and will cause conflicts if merged via the
>>>> virtio tree, both when applied and at merge window time - inside Linus
>>>> tree.
>>>>
>>>> To avoid such conflicts and duplicate commits I think the net-next
>>>> could pull from [1], while the virtio tree could pull from [2].  
>>>
>>> Or I could just merge all of this in my tree, if that's ok
>>> with others?
>>
>> No strong preference here. My first choice would be a branch based
>> on v6.16-rc5 so we can all pull in and resolve the conflicts that
>> already exist. But I haven't looked how bad the conflicts would 
>> be for virtio if we did that. On net-next side they look manageable.
> 
> OK, let's do it the way Paolo wants then.

I actually messed a bit with my proposal, as I forgot I need to use a
common ancestor for the branches I shared.

git@github.com:pabeni/linux-devel.git virtio_features_extension_07_07_2025

is based on current net-next and pulling from such tag will take a lot
of unwanted stuff into the vhost tree.

@Michael: AFAICS the current vhost devel tree is based on top of
v6.15-rc7, am I correct?

/P


