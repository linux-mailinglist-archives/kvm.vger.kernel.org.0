Return-Path: <kvm+bounces-35728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E1B5A149D0
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 07:51:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F2AA16AF8F
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 06:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07DDA1F76DF;
	Fri, 17 Jan 2025 06:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="QLiKBGoQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9581F7564
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 06:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737096665; cv=none; b=qfpaiRjPOpL7DVlZxyay535Pz3RgCWvlCtarZacVClGzunF4bwHFtgfWt0ReZ0ned3hB/NBJ+4to8RMaVnfT6qYrCwvWg/z9Af8wngdqmq3t48PIWiHY4JMa8S8yyzKkpWkzZ6lsfIqSkxj9zHmpfV0qBmIbpz0SjmR2CwC1hnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737096665; c=relaxed/simple;
	bh=2u2YVfoxLd7Cvn3rxair1v5iw/Nh3ozWpr+rXKeCIOI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=izxTIijxqRIH4BVDANOR9yh71eRZYyKnML8HGVHsqQI6gtXQ99dfu6M538zEYe8iA8njX6rNmRSsuZkHoBHCdDShvchFYs5FMLLBmTy9u/APZb2xKDOtTTDx3zQ2SiX9eoDkT85+AUDuBvtVZddfUPZt+7QHs5+6r1V3LNJkKMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=QLiKBGoQ; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-21649a7bcdcso31226275ad.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 22:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1737096663; x=1737701463; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bxvFAOToWR486xbEC+Pgvw2Hl5TN/daUG+P6fxzoIwU=;
        b=QLiKBGoQt0T6tjkOmTb+aOtVzDU7f3+enxY5ZgBTnWVm3ThPt5O1mkaIPzjb7wstT3
         x8U9pZCHf+RepsooVDM0hQAhRQhoEdrOGDJNPj2zUkalprfz/eu5cMOjwttJ3jQycoLv
         BbXeo4dAx7MwEtQOIq131MmUIN+URbtM9dYBmgj5A0hQEEfo7qh0/7BYqcZY06Y7rKYB
         7yI4TmAYvsVogpELX/K4EGIRAB3Y7wQuZydBkxP5zlHdry0ys3J0dHQzK8RpAl4nJDAA
         M1jdSK2DnvVNhTC9ba6mTwDo0Dn4fdNkpjZMjyGwDqsDDdsYyN5y5UFp/WTn86WYOhAk
         oNbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737096663; x=1737701463;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bxvFAOToWR486xbEC+Pgvw2Hl5TN/daUG+P6fxzoIwU=;
        b=DI5Bs8UWaGitgzGevphp11jup4hV0QvXoZB5PDzeJqIENfZG0U1KVrrvOMw4ioM/6s
         wdxXLVEYugSIN9qv6AI0/HEYKmyxfZ9RYRQI/BGg2HUNaeHv4IVgMlGk/rXvG6CLivra
         YoyZJnyarp6CyLLyFJhn/6WTZPuuAWjAJnYPqqAo1KGPmpyTRlkcJhFylkqBDTCouQrJ
         pgFxQefpBb+q7q3jh3mt4geecbnq1oiTTJkvwcCwGscqM8q1oAkTIXuZs2faEDJmGO7r
         a9ZL2okFk0006fzvuEYEY+e3UBIUqetb8Owt6i3W/wVF1hktUDRwvnNUHZskL/SPLjxk
         Q7sQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4QIeYEwX4KEeJLHUAovGxch8ZX22jSSuIwePBiGvyGmk3rdtUEX2WVC/BdyFOJw4/F5o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5uOd2uxHnco8110uHSSTvqxj5tJlFruobl76vwT9h4Ym9+G4X
	qvSp+3V73iO7pDBjN7tKNttQi/Y2fsEmynZ5kv/qQ3Ca/kUUIEZiW2A8lnTQsCI=
X-Gm-Gg: ASbGncvKnWG/DD0lEA+QTYRgSVCi0G7ec+TrWiA3w9Ol7LIFAOab0nbEoZt48fHg7zD
	XYiOdgja+xcSr+6Cej22Y1KjOXFy4/r6t3wNjH96Ue0DzYYjxgWGsZM1yYHCekcrtUdap1sJA6j
	SgGbOEfxBuKGeqHF9n+EaKBj4+6JiLGI5OBERboLgedUSkhcKWepE6dOkGwBBP417TtZNBfJaOZ
	4DomOY4Y+IdRPrf+0fYCy4wmDmuXayljJDMYGsTWZ0kW7A+4f5mDJ1zB52Lia90rpY=
X-Google-Smtp-Source: AGHT+IHEp4jaCJNggzbZ2ij/bh9rzGAo+Mt5lP+zOwoLCq8mYHxh8b68OP5RujQgDJEqW/JvnG0eSA==
X-Received: by 2002:a05:6a00:2296:b0:72a:8b90:92e9 with SMTP id d2e1a72fcca58-72daf931244mr2463308b3a.5.1737096662981;
        Thu, 16 Jan 2025 22:51:02 -0800 (PST)
Received: from [157.82.203.37] ([157.82.203.37])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72dab7f07b9sm1110387b3a.3.2025.01.16.22.50.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 22:51:02 -0800 (PST)
Message-ID: <1a419eb7-0ca4-43ea-9420-da0c35e5f1a9@daynix.com>
Date: Fri, 17 Jan 2025 15:50:56 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v3 0/9] tun: Unify vnet implementation
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Jason Wang <jasowang@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org,
 Yuri Benditovich <yuri.benditovich@daynix.com>,
 Andrew Melnychenko <andrew@daynix.com>,
 Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com,
 devel@daynix.com
References: <20250116-tun-v3-0-c6b2871e97f7@daynix.com>
 <20250116031331-mutt-send-email-mst@kernel.org>
 <678901682ff09_3710bc2944f@willemb.c.googlers.com.notmuch>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <678901682ff09_3710bc2944f@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/01/16 21:54, Willem de Bruijn wrote:
> Michael S. Tsirkin wrote:
>> On Thu, Jan 16, 2025 at 05:08:03PM +0900, Akihiko Odaki wrote:
>>> When I implemented virtio's hash-related features to tun/tap [1],
>>> I found tun/tap does not fill the entire region reserved for the virtio
>>> header, leaving some uninitialized hole in the middle of the buffer
>>> after read()/recvmesg().
>>>
>>> This series fills the uninitialized hole. More concretely, the
>>> num_buffers field will be initialized with 1, and the other fields will
>>> be inialized with 0. Setting the num_buffers field to 1 is mandated by
>>> virtio 1.0 [2].
>>>
>>> The change to virtio header is preceded by another change that refactors
>>> tun and tap to unify their virtio-related code.
>>>
>>> [1]: https://lore.kernel.org/r/20241008-rss-v5-0-f3cf68df005d@daynix.com
>>> [2]: https://lore.kernel.org/r/20241227084256-mutt-send-email-mst@kernel.org/
>>>
>>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>>
>> Will review. But this does not look like net material to me.
>> Not really a bugfix. More like net-next.
> 
> +1. I said basically the same in v2.
> 
> Perhaps the field initialization is net material, though not
> critical until hashing is merged, so not stable.
> 
> The deduplication does not belong in net.
> 
> IMHO it should all go to net-next.

I will post the future version for net-next. I also intend to post the 
field initialization for net-next too.

