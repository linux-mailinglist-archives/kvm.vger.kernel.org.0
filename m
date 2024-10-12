Return-Path: <kvm+bounces-28689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CBC599B31F
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 12:42:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A0BEFB227A3
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 10:42:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D22F015574F;
	Sat, 12 Oct 2024 10:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="CJ1ch+Xs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42D715443C
	for <kvm@vger.kernel.org>; Sat, 12 Oct 2024 10:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728729760; cv=none; b=orRQ1/GvzEwztcPeWGwfnYgma0E54rrt3tnHq8Y0Kn1w/ixAPPvSSKX7JtslGzKioI/4UWybm2OpET5UghRor3c/RJdkX3xmk/kkADip1NwoMEmDqwfVlEEPZ1OqJJ89/hTP1tIDVSXjsubQvZV1Cg/m2IFtl64o1LyRuLeRdzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728729760; c=relaxed/simple;
	bh=F2Sp1fzcw8Uf/QMINhGhDYWS9F5dWa9nb4/qh8r/ALY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=HqVOzHup3PNZRtSAm2CA9qUeVQcx6ynKXPOi8i6y+PNQpL+Dgs0t9sJdIgOKphjRDsBlwt6p8Q+XVcQe64mFwzijWYFAbtu9wLsJXjDNWuYNswQZ/Z5CA4dNh/qlYL4ehmWg+rOBFmX8Jn0ynIhHOhlzgNdTKfIRsO8Bs8cVaVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=CJ1ch+Xs; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-20ca1b6a80aso12062195ad.2
        for <kvm@vger.kernel.org>; Sat, 12 Oct 2024 03:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1728729757; x=1729334557; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rnVDkA3/NaAKhKgMUHvmItPchk02Cn37cnkYPg5p2Qw=;
        b=CJ1ch+XsP3k9Bdzgi04+URwvUed22kf7IKlTv1B37FV6auETP4UlJefSeJXGYF9vSb
         BndSPWHOFR5xJEBQbpFAxbda8AOE0AO2cUs5dvj0yNA6O+i1JXchGPZMtEEcUBJ1jDpA
         9ae5pOZ4/yMrP9TjbkbPbVtkeUGQhjollE3J4wiGs9fK52X2x1+HrGucK/JOEL2JW79P
         6cInfHli9hUziadd/Wsbh4zll4iZ37mOZPwoSCDOt8srfmrJtBy+AFMV/iBVQfaWP60W
         LDAvyZwIkTLvul7Ko140liyADahfYrbPfITSn4SlImw3918FdMwtiQzT5teJi6CGysLl
         wU9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728729757; x=1729334557;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rnVDkA3/NaAKhKgMUHvmItPchk02Cn37cnkYPg5p2Qw=;
        b=eFGF6jFjh+l+rb9E1jHVmwJd2Vw0dXhjqB42yB8Sr+1TQVRwgg+1Pw7/70RaAtfO+C
         77DUzuWlcXQxjAOeLzPWvMEfqsKSu00VrVLJwh/74XXHiD0bb7IQvD6ecM0K7JOOAllX
         lff/o6o59HBl/ei9gKrwI+qF7XJ7zYQxWThMEPS0qnjhTgCftc8WO05C8yn7hdguNjZm
         8iFeIIoWKa4DvM6uqmjZoACTGq2yqNaiUfioxgwZZ7Xuwih0XmIkSWS/s0LFeseZ21U6
         0u/VOLXTcyVy5o0d/0H+FJm3XJqKj7U5jbtA3sapxfLoAtjt+uVqwr321cC2EhXgZbUr
         EX9w==
X-Forwarded-Encrypted: i=1; AJvYcCUtCgTbc78v8AtBV+e9uOeSNQ8to766fOyHSh/neS4K9qmWdrCF5dVEa7dJKdWlUetj6sw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvgQ4NlZEnpXKhLrwP8sm7dVcbgNHQagOq4S4DHAeZoNEJ7CFr
	Tnj1kEi6HYwrxm0ecjUG9K+ittwVq+LbDhQ1tjG4dPQcNQw6l0T7+/+hjWoEBQA=
X-Google-Smtp-Source: AGHT+IHAAJSka16NZVOG9ERRGT0s8XZNSpBXGOA3FY01waa9+ItcfG5gf6PTH3meZ9nN0csYqZ692Q==
X-Received: by 2002:a17:902:e5d2:b0:20c:ce9c:bbb0 with SMTP id d9443c01a7336-20cce9cbddfmr6671465ad.0.1728729757238;
        Sat, 12 Oct 2024 03:42:37 -0700 (PDT)
Received: from [157.82.207.107] ([157.82.207.107])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c33ffadsm35367635ad.266.2024.10.12.03.42.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Oct 2024 03:42:36 -0700 (PDT)
Message-ID: <30bbebd8-1692-4b62-9a1f-070f6152061c@daynix.com>
Date: Sat, 12 Oct 2024 19:42:31 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v5 01/10] virtio_net: Add functions for hashing
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Jason Wang <jasowang@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org,
 Yuri Benditovich <yuri.benditovich@daynix.com>,
 Andrew Melnychenko <andrew@daynix.com>,
 Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com
References: <20241008-rss-v5-0-f3cf68df005d@daynix.com>
 <20241008-rss-v5-1-f3cf68df005d@daynix.com>
 <67068a7261d8c_1cca3129414@willemb.c.googlers.com.notmuch>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <67068a7261d8c_1cca3129414@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/10/09 22:51, Willem de Bruijn wrote:
> Akihiko Odaki wrote:
>> They are useful to implement VIRTIO_NET_F_RSS and
>> VIRTIO_NET_F_HASH_REPORT.
>>
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>> ---
>>   include/linux/virtio_net.h | 188 +++++++++++++++++++++++++++++++++++++++++++++
> 
> No need for these to be in header files

I naively followed prior examples in this file. Do you have an 
alternative idea?

