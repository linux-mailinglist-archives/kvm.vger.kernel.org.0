Return-Path: <kvm+bounces-37429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BB9DA2A1AB
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 07:59:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC0D13A856C
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 06:58:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE9D72253E1;
	Thu,  6 Feb 2025 06:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="vmnDxC7G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5FC2248AD
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 06:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738825124; cv=none; b=jJE2+0GhfkrAD3HDKCCgh9szyqZyrTsVKuRv1+aDV8OpOiF5DmRMSAlC45hFgpgDR31MY0IJWO2R2CX3pX1gax6X0s/5paDTdWbEUbrkyIcpEEmWmpjXYfL+45AJ8lfnfYaHOEaRAxoJ1UprvY/rTQYmDmtOC2TgErluqiMzLQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738825124; c=relaxed/simple;
	bh=og3Aq1IjApPzY4pBlRJEpp2monYtKZMRFoZcCbo2WO8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tlkJBtsQuERap5q+LikrULbXOvEmAuklf0cI23njRik0jNmvwa2V+ZvEsDCI2IHR9elg0+Tyow7+Sx8HNbZeUcLqLD6eGa1pfBzNcAIK8iVOLZuMubs8OB3bX4LWh0fXb8QLp8oYc8DispNsHvRmlhcglCZfX5LQ05c045Gtozk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=vmnDxC7G; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2164b662090so11591965ad.1
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 22:58:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1738825121; x=1739429921; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MfkFHRY4BuNO95W0YyldJMDcWeJ1g/mRAGw+u9+CPB0=;
        b=vmnDxC7Gxchxw1LtQ3i7bSdlDrG0ebeWraoMP4rauxsI9uiJ5x+WxrDyHSIEWhrb0p
         wjraVaFlMkv16b6IYjG27lol78/n506Ws//dWuJ4sPiUyma+6x3CiRJVc7ZjhHFeEneU
         yA5j0VaFe53ATkXIMJJ8zr1nAuQT1R2TpUOwnainI2C6d7kh4p4AmArZOLGoJ197SCFs
         ngwx3rOENpKJlGX2wy8DLXNzl8vDSmoNgSBWiI3zfDp7FyKrxW9qDdhRXo4i61+y8DFm
         kkfGhfHGGr3rrXObj5zbMB/3FQTxXVU397KqaGCwtPQKG0Qcs+9FdemWZTsf+yuamk0/
         Hpgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738825121; x=1739429921;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MfkFHRY4BuNO95W0YyldJMDcWeJ1g/mRAGw+u9+CPB0=;
        b=icY4h+zK2MTtvDK1TAEM5m3V+j/7XHUcY7BLQZhv3bLFYyune1Srgycp31adnVkup0
         22e2W1eM1KCLPEla6gwYuJouz/x4zk20rHU65QZxzsEiYC66oUzHOd6WIFRWnER5pM1a
         N1YghAZQ3a6glEzPyMAZyxfbMMRy7MSod6GqX/uz5gEbW1p9RPWElWqU0gh/YI+y2ZvC
         lY/Gjx03FVJqdk8DOaJBdIPVSz0J9qLXaUj23jsZ5qDgd1ISlwsI1h/VMb+FEq765XHL
         TAgFU8Wd6fb2/JoiG+MW6aHtkwaiy5NPg/mqQmEnomd3fVEndBjh3bJ1YfTW6U6OCBVg
         VCaA==
X-Forwarded-Encrypted: i=1; AJvYcCU3SZNNNJCdWugYgn8YgcE54GACz4fO7xq2iSILeY2SsRmMz6iDag/v5YaC4qfHNXFSHRE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMFdj+MtkDGINKDRTh1KyvuXYuXErdSSqWZKCqX5M0T4tgDB1x
	UdPEY7p9ZVP8BYyBjlKjwqre0Auw08MUxd8OGkUkzAuwiw7E4n1m6LTn+TNUZrw=
X-Gm-Gg: ASbGncvKyy+Ubd4jxuQqMKeTypThPGG5VhQLz/SVYMg02oEZWu6hUTVe9dKq+p0odhM
	AzD3tdkGhhAyiLfZZ8AnkOC7onYC7ZXDaeR4cuubxujx4AyIWo6r3u3CpN6bCv0+O2X1R0c6B1t
	AJ/6dvBVpbDGQEp6WoAymeCMsJ4XGedKOBl5U85u8yUSipFDFZsZXZUOpVJZPMfBwI357BevaRp
	e+gjM85UITsob79q79xtPv1Te9Pg4oEpoAwH4/lIYYRIiSDbcaV9h4jxaCGtD7cwylYoJlTNZM/
	WiiqdWCxr3baVK5uFfhA5o29yvhE
X-Google-Smtp-Source: AGHT+IHSHvbDEBE36nUTLqiZtQMOf3j/rI2OoIwM0kMRTh5vyxMjVD4DwGY5i/68BnM7I5tCX5GUew==
X-Received: by 2002:a05:6a21:1805:b0:1ed:a6d7:3c07 with SMTP id adf61e73a8af0-1ede881f0b3mr9719443637.4.1738825121065;
        Wed, 05 Feb 2025 22:58:41 -0800 (PST)
Received: from [157.82.207.107] ([157.82.207.107])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73048ad292dsm590546b3a.61.2025.02.05.22.58.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2025 22:58:40 -0800 (PST)
Message-ID: <1c2a1bd6-9ce9-47d8-b89d-1a647575ce07@daynix.com>
Date: Thu, 6 Feb 2025 15:58:34 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v5 5/7] tun: Extract the vnet handling code
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
 Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com,
 devel@daynix.com
References: <20250205-tun-v5-0-15d0b32e87fa@daynix.com>
 <20250205-tun-v5-5-15d0b32e87fa@daynix.com>
 <67a3d44d44f12_170d392947c@willemb.c.googlers.com.notmuch>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <67a3d44d44f12_170d392947c@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/02/06 6:12, Willem de Bruijn wrote:
> Akihiko Odaki wrote:
>> The vnet handling code will be reused by tap.
>>
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>> ---
>>   MAINTAINERS            |   2 +-
>>   drivers/net/tun.c      | 179 +----------------------------------------------
>>   drivers/net/tun_vnet.h | 184 +++++++++++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 187 insertions(+), 178 deletions(-)
> 
>> -static inline bool tun_legacy_is_little_endian(unsigned int flags)
>> -{
>> -	return !(IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE) &&
>> -		 (flags & TUN_VNET_BE)) &&
>> -		virtio_legacy_is_little_endian();
>> -}
> 
>> +static inline bool tun_vnet_legacy_is_little_endian(unsigned int flags)
>> +{
>> +	return !(IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE) &&
>> +		 (flags & TUN_VNET_BE)) &&
>> +		virtio_legacy_is_little_endian();
>> +}
> 
> In general LGTM. But why did you rename functions while moving them?
> Please add an explanation in the commit message for any non obvious
> changes like that.

I renamed them to clarify they are in a distinct, decoupled part of 
code. It was obvious in the previous version as they are static 
functions contained in a translation unit, but now they are part of a 
header file so I'm clarifying that with this rename. I will add this 
explanation to the commit message.

