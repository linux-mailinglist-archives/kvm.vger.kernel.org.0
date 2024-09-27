Return-Path: <kvm+bounces-27602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 99D2D987CFE
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 04:23:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 502391F23EE7
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 02:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B1A416DEAC;
	Fri, 27 Sep 2024 02:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="dQxZMayw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D95EAC6
	for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 02:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727403786; cv=none; b=o5T4xrc5gWd9lNijPXDd5nBF/E+/GB02Qb1Wvk4utR2nivFWnSmmgovOr0HDAw6cxLm5hiqmw07GlT/C9YsNojHXFRmmyTV+NYw0AlpmVDmziQmyd0OHLv7UXJqC30MBK9r/mSaVQ3Crr3mI/U5fdga77FjsS6c6t1xAFRZIOyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727403786; c=relaxed/simple;
	bh=V5nTFEg40BS9fpyNzgTctWWGF7NZtj92BLrRC7NQ+HU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lIAvoYNE1pYaoEIGCgN6MGYeADKTTA9/LpUNvojooLn9jOgaqtB8AuS/olhTGgzqVCX/aoa3wUQy/esC/Up4dnmsz8Olm+LfHjF/EDsuMoNfhB09R8mBzGcdrRIdAQmRC28aaJQTk/AvukDJIvhodyt4YR8ncNUEI6kz3+CbH7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=dQxZMayw; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-7d50e865b7aso1176260a12.0
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 19:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1727403784; x=1728008584; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fm6FdUgor1DMp4AzKUDxfLdY/zKgjnsnnCTT3QZsc5c=;
        b=dQxZMaywWfRVNSvsij2ddn5q1q3tEa2PKca/DKE35Xn8Kwh9VAwLuw+Sna8VhaD95U
         vZQ8QEN1TXntbkxRvpab8otxeOB3U70/jJ4ikIYF+NY5CriZ+C5M4SESdvDZCOi2/3nJ
         L65mW331pF8ED7xRIMZZvNLan3wnMFE+MDUw9Mp7D5ECuiNoSNBwSKV4/tn2+PLjQOcA
         dOeCYby1SIZeHjRHtfgVvvdQXRljBcf4K74O25zKCpLaZfckDvoIcvkih+gKFS9Nhnq3
         Qt/XGUVsaHxxXj2SKfkvfYeVPce8B14NLR8saB2OzBpjFOWE+BvS3YBKkdlpXxg1z3k2
         1C9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727403784; x=1728008584;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fm6FdUgor1DMp4AzKUDxfLdY/zKgjnsnnCTT3QZsc5c=;
        b=c8klzkT8UnOla4/lJtAL2zyye2XEeUqnoPt87rWdh736sw9AWPHEwMsMXKcqhYdZdu
         uBqPU+M8a2/RN/c5FAJimpVl0rRH9EDP90fBzwTqn02unUFdTvLUkwzX1sZbMiXs2K7t
         6gW58p6H056QKzZ0/Ei3zE938/Y8TzopBPLyWz6Ur+Nbi3ylkCIDprPhzSp8bm9db0Vb
         4FX8MjW1Q97clpG2LfkwRR2uWaMGiDRn+X2U6wEB0YfAXE8K5hX+uQcNc8ioV88jagP7
         Vvv2/tdw5u0hM8v1boIogXKMmVQf4BCef8I9VMhm+eidFZ6oo7IpHphb4Mkh4hQ3SPRk
         9r1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVKQ7/teT6UD4OwM9983H08Efa5zOZqMaZKooXDSNtpRagFfU4Yc9uPvJ+6xg17frMevFI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxdTdFcFmTu8MsZaJCrURUSkFzVWLm6+y1NjM+Xl26K8ldlYhE
	xW33OsrMMGX37kGtRAjmbiizSrZtzNRqE5U4pOoEn8MEDP8TI6drigrq3K2uMys=
X-Google-Smtp-Source: AGHT+IE8eclHHp/rZtYVB0h05WFJYdKId7bC7EfQYU296diw2AVIsMjGQmM4ppAbwhdAEFSQulsWLQ==
X-Received: by 2002:a05:6a20:db0d:b0:1cf:3d14:6921 with SMTP id adf61e73a8af0-1d4fa78b468mr2830052637.35.1727403784277;
        Thu, 26 Sep 2024 19:23:04 -0700 (PDT)
Received: from [157.82.207.107] ([157.82.207.107])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b264bc443sm570468b3a.70.2024.09.26.19.23.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2024 19:23:03 -0700 (PDT)
Message-ID: <66438fad-d697-4b34-89de-528bd5e081b5@daynix.com>
Date: Fri, 27 Sep 2024 11:22:59 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 7/9] tun: Introduce virtio-net RSS
To: Simon Horman <horms@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Jason Wang <jasowang@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org,
 Yuri Benditovich <yuri.benditovich@daynix.com>,
 Andrew Melnychenko <andrew@daynix.com>,
 Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com
References: <20240924-rss-v4-0-84e932ec0e6c@daynix.com>
 <20240924-rss-v4-7-84e932ec0e6c@daynix.com>
 <20240924130550.GJ4029621@kernel.org>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <20240924130550.GJ4029621@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/09/24 22:05, Simon Horman wrote:
> On Tue, Sep 24, 2024 at 11:01:12AM +0200, Akihiko Odaki wrote:
>> RSS is a receive steering algorithm that can be negotiated to use with
>> virtio_net. Conventionally the hash calculation was done by the VMM.
>> However, computing the hash after the queue was chosen defeats the
>> purpose of RSS.
>>
>> Another approach is to use eBPF steering program. This approach has
>> another downside: it cannot report the calculated hash due to the
>> restrictive nature of eBPF steering program.
>>
>> Introduce the code to perform RSS to the kernel in order to overcome
>> thse challenges. An alternative solution is to extend the eBPF steering
>> program so that it will be able to report to the userspace, but I didn't
>> opt for it because extending the current mechanism of eBPF steering
>> program as is because it relies on legacy context rewriting, and
>> introducing kfunc-based eBPF will result in non-UAPI dependency while
>> the other relevant virtualization APIs such as KVM and vhost_net are
>> UAPIs.
>>
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> 
> ...
> 
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> 
> ...
> 
>> @@ -333,8 +336,10 @@ static long tun_set_vnet_be(struct tun_struct *tun, int __user *argp)
>>   		return -EFAULT;
>>   
>>   	if (be) {
>> +		struct tun_vnet_hash_container *vnet_hash = rtnl_dereference(tun->vnet_hash);
>> +
>>   		if (!(tun->flags & TUN_VNET_LE) &&
>> -		    (tun->vnet_hash.flags & TUN_VNET_HASH_REPORT))
>> +		    vnet_hash && (vnet_hash->flags & TUN_VNET_HASH_REPORT))
> 
> Hi Odaki-san,
> 
> I am wondering if the above should this be vnet_hash->common.flags?
> I am seeing this:
> 
> ../drivers/net/tun.c:342:44: error: ‘struct tun_vnet_hash_container’ has no member named ‘flags’
>    342 |                     vnet_hash && (vnet_hash->flags & TUN_VNET_HASH_REPORT))
> 
> ...

You are right. I couldn't notice this error because I was testing 
without CONFIG_TUN_VNET_CROSS_LE; I'll test with the configuration and 
submit a new version with fix.

Regards,
Akihiko Odaki

