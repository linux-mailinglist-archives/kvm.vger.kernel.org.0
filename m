Return-Path: <kvm+bounces-35014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 853FDA08C04
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 10:31:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 870B6188DC16
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 09:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF80420B21E;
	Fri, 10 Jan 2025 09:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="W10UwH6h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C028C20B1EC
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 09:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736501335; cv=none; b=RAdK8ZXi830dboNYT9JAOqoYPQqMjr/HoDV5WXdPE2CS0XqqWujFch71Ou6UsYo01ungwrUFIYMuwO7a5rz0ura9PVbGYZWe4Z7mKIF5gcG0G4qel1ln9Ol0GzOX7clI89F/7D2F/Go6UiAAKFHieEbJMg3dFmtGLIRU3Qj33Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736501335; c=relaxed/simple;
	bh=GWGuc3VMdr5N9fv2KHCFN5USR+3NK9F0l8JRZS0PRfE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TBsCaKJjkE1HHUO0N3CF/qxb0LZs5Fw2CpWfZ9ut+/kcwjvIcVy0cAztrJ8G4Yr2PPnf/W9Hewpm+B9tjJuGs1s+IKml7JgGCAQI9hwCscnEbMV+ZW26awwhgFxvcIBf+QbgygRAd5tYdySDn+b2qWBmVW2EzFDDtiaAO1cKfP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=W10UwH6h; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21644aca3a0so38898565ad.3
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 01:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1736501332; x=1737106132; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=igRjP8Z8IeTK8JEZO8XtaE1DaoQy9k12HA0KbHTX3XM=;
        b=W10UwH6hhB491Ig8wawPXAGEtrvHrsYtOB5aK6Vm9VEk0ketzi+m9fs0oIwvcPscjJ
         kVnug2qJfIgPZTXRTpV+5m5dbBY8oo1ARQrzx80+n9eDjCW9078AljHrD74+VAUS5yOj
         9FQpqK1SLS1gkb3HDYGZ+VT01MbItAgcgvX7o4hMqqsoLH7d4S7DssCXp0va/fWvAqbA
         5KdLi4EEzQwUYbz6Pu8U7Q6K5nyjLMlwoOACKjznM84I36emEl34uzJ+fZ0oot0db0R6
         O15SAeWRieCUWMTGg7DJnYzS9y2857GF2Zyt3xfhMwmmrGABb4e9/g3F1BNVib2ZQYmd
         OvRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736501332; x=1737106132;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=igRjP8Z8IeTK8JEZO8XtaE1DaoQy9k12HA0KbHTX3XM=;
        b=xL1k11qn50itlxaVcvYC3EAqkPVe69jaHFEXlyP/5CfchAMCFhVZ1xeOr6NJkOY4Vx
         0G38S5QBjaSjZJiuMk0SqGI3qnSiZjoZXCh8puwKIjGrpjHVrWeIFlXSChpjAjOrSkek
         lsguNnOajeellNh3z9Hqrbm0CNwwkAwe6G3+PEuedxfd6dJ1tUuwa+zH5b6x41hxJI8V
         MBZIncMAgeRkO0JR5y4UYEln0NO15oO/gMoN2tZcPUShYS0HYV4CnTi771egPq/0DVW5
         ecKIc8oXZMCsQzoO0LtkF5TmxIaqqig0cS0AX6uE44R9KqrivKs7P4b4iIHa4xWuSt5z
         A2jg==
X-Forwarded-Encrypted: i=1; AJvYcCVCagetOjNjEXE5dx7+LLI/eUmb2SDBN/nK6qrx5S0EB2Ritufd3VKP3TuLvzUcO7q5DSE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEjGeYPiw5bDqtUULmrmeDbOS73F4kS2zb3RJPVI78wvozK73k
	+UkBhPgHYaBTMA9vcLOhZOgPHLjbOx1+oJ2vsqHcB++nWjfz+pVCZoVjC42MW9w=
X-Gm-Gg: ASbGnctD9W3cMKiVhgkbCLmcoAPbhiPOJQ+GfDIO3qUjFfd02IpsWDTWyyuLgmomXAm
	ePiA28hZbpFaN5Vzc2E2SvEIdYn4v4BpEwmYB6OQK5888EqTpkrBVZDemThUIWeE1N3O79wo0kG
	c5PyziXHN2LvGLnczFdH6ksI4gj0wKzwmn9wbrZLIh/OF7vjwwuP4/pn1DBOz0g2HwlB4buEUZb
	sNy7rxgCd3ExXzicEEfgZcGIVFRKq1crR1O353W+i6YEcuf3hexoAv7V8AkomopPfA=
X-Google-Smtp-Source: AGHT+IEbncdNgeHV3NRD5L3UNOBwnx4pcPRNgcfCcKKAqBupE3LuCLH6YhUM6tqENcH7rFNBH/3/jQ==
X-Received: by 2002:a17:902:dac6:b0:216:4a8a:2665 with SMTP id d9443c01a7336-21a84012a17mr153359295ad.50.1736501332180;
        Fri, 10 Jan 2025 01:28:52 -0800 (PST)
Received: from [157.82.203.37] ([157.82.203.37])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f22d5fcsm10340475ad.176.2025.01.10.01.28.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2025 01:28:51 -0800 (PST)
Message-ID: <0bcbbc09-e4dd-4e16-ac1a-c9d3f368c145@daynix.com>
Date: Fri, 10 Jan 2025 18:28:46 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/6] virtio_net: Add functions for hashing
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
References: <20250109-rss-v6-0-b1c90ad708f6@daynix.com>
 <20250109-rss-v6-1-b1c90ad708f6@daynix.com>
 <677fd98d89df1_362bc12942f@willemb.c.googlers.com.notmuch>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <677fd98d89df1_362bc12942f@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/01/09 23:13, Willem de Bruijn wrote:
> Akihiko Odaki wrote:
>> They are useful to implement VIRTIO_NET_F_RSS and
>> VIRTIO_NET_F_HASH_REPORT.
> 
> Toeplitz potentially has users beyond virtio. I wonder if we should
> from the start implement this as net/core/rss.c.

Or in lib/toeplitz.c just as like lib/siphash.c. I just chose the 
easiest option to implement everything in include/linux/virtio_net.h.

> 
>   
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>> ---
>>   include/linux/virtio_net.h | 188 +++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 188 insertions(+)
>>
>> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
>> index 02a9f4dc594d..3b25ca75710b 100644
>> --- a/include/linux/virtio_net.h
>> +++ b/include/linux/virtio_net.h
>> @@ -9,6 +9,194 @@
>>   #include <uapi/linux/tcp.h>
>>   #include <uapi/linux/virtio_net.h>
>>   
>> +struct virtio_net_hash {
>> +	u32 value;
>> +	u16 report;
>> +};
>> +
>> +struct virtio_net_toeplitz_state {
>> +	u32 hash;
>> +	const u32 *key;
>> +};
>> +
>> +#define VIRTIO_NET_SUPPORTED_HASH_TYPES (VIRTIO_NET_RSS_HASH_TYPE_IPv4 | \
>> +					 VIRTIO_NET_RSS_HASH_TYPE_TCPv4 | \
>> +					 VIRTIO_NET_RSS_HASH_TYPE_UDPv4 | \
>> +					 VIRTIO_NET_RSS_HASH_TYPE_IPv6 | \
>> +					 VIRTIO_NET_RSS_HASH_TYPE_TCPv6 | \
>> +					 VIRTIO_NET_RSS_HASH_TYPE_UDPv6)
>> +
>> +#define VIRTIO_NET_RSS_MAX_KEY_SIZE 40
>> +
>> +static inline void virtio_net_toeplitz_convert_key(u32 *input, size_t len)
>> +{
>> +	while (len >= sizeof(*input)) {
>> +		*input = be32_to_cpu((__force __be32)*input);
>> +		input++;
>> +		len -= sizeof(*input);
>> +	}
>> +}
>> +
>> +static inline void virtio_net_toeplitz_calc(struct virtio_net_toeplitz_state *state,
>> +					    const __be32 *input, size_t len)
>> +{
>> +	while (len >= sizeof(*input)) {
>> +		for (u32 map = be32_to_cpu(*input); map; map &= (map - 1)) {
>> +			u32 i = ffs(map);
>> +
>> +			state->hash ^= state->key[0] << (32 - i) |
>> +				       (u32)((u64)state->key[1] >> i);
>> +		}
>> +
>> +		state->key++;
>> +		input++;
>> +		len -= sizeof(*input);
>> +	}
>> +}
> 
> Have you verified that this algorithm matches a known toeplitz
> implementation. And computes the expected values for the test
> inputs in
> 
> https://learn.microsoft.com/en-us/windows-hardware/drivers/network/verifying-the-rss-hash-calculation

Yes.

> 
> We have a toeplitz implementation in
> tools/testing/selftests/net/toeplitz.c that can also be used as
> reference.
 > >> +
>> +static inline u8 virtio_net_hash_key_length(u32 types)
>> +{
>> +	size_t len = 0;
>> +
>> +	if (types & VIRTIO_NET_HASH_REPORT_IPv4)
>> +		len = max(len,
>> +			  sizeof(struct flow_dissector_key_ipv4_addrs));
>> +
>> +	if (types &
>> +	    (VIRTIO_NET_HASH_REPORT_TCPv4 | VIRTIO_NET_HASH_REPORT_UDPv4))
>> +		len = max(len,
>> +			  sizeof(struct flow_dissector_key_ipv4_addrs) +
>> +			  sizeof(struct flow_dissector_key_ports));
>> +
>> +	if (types & VIRTIO_NET_HASH_REPORT_IPv6)
>> +		len = max(len,
>> +			  sizeof(struct flow_dissector_key_ipv6_addrs));
>> +
>> +	if (types &
>> +	    (VIRTIO_NET_HASH_REPORT_TCPv6 | VIRTIO_NET_HASH_REPORT_UDPv6))
>> +		len = max(len,
>> +			  sizeof(struct flow_dissector_key_ipv6_addrs) +
>> +			  sizeof(struct flow_dissector_key_ports));
>> +
>> +	return len + 4;
> 
> Avoid magic constants. Please use sizeof or something else to signal
> what this 4 derives from.

