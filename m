Return-Path: <kvm+bounces-50302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CFCE3AE3D89
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:58:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50CAD164A6B
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 10:58:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1306523D288;
	Mon, 23 Jun 2025 10:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RgkiEuOu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B72B1A08AF
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 10:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750676325; cv=none; b=pZT7bwR9hZMEMj52tPfp/OH3XDLkkmowziCPCEexkf242LG+OZ4d+rlToBIDOG5Pn03EBE6fYsanKS33MNqC5lx+LNAFcp43idgNmroN08cmPBAJLr1/HAj/tRhzsc4WOBskGWKWG6TqDu3JsXHSeT9AEwi6c6tAnznx73FoDz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750676325; c=relaxed/simple;
	bh=7z/LoiUZ4ckAuHWelqzbV13t1/gO/DQPymPaZ9atChc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B26CRk6nyGjXjimo6yXrWiKIlpU8rJOCKafI8JES7tVC3P+IgEE2r9dvU/L3bgRmZyUC1vgazax1DOxTDB7eq/jy9WVya1/I8+xrVveBkEsOgvWgaoFkupkaGIFnYtsZKKgAYxw2CboyrRo7K1yVTGLE6R+S3V1eysDs8s/a2bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RgkiEuOu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750676322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OcWuVqlYqc8Fv7LscejW/AotfZkWXZJQvOx/NWErPRU=;
	b=RgkiEuOufHyxnyEAjj4zHA0RkJbD935Wd0e7LLDvEtYmyXcAJyHfyRoYG+c4J2Be2vWqDV
	HpMpH/KsPDSRnfB0CUTKMNo07ymRLUjNu9ZirCg/LrrPx45p1yqLyjCbLQca/03zXOuP/c
	MgpXHulzOSnLU0kJDs9xPh9cI5pEvKI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-Bv7cgnTPP5y9S3Gg3XMrjA-1; Mon, 23 Jun 2025 06:58:41 -0400
X-MC-Unique: Bv7cgnTPP5y9S3Gg3XMrjA-1
X-Mimecast-MFC-AGG-ID: Bv7cgnTPP5y9S3Gg3XMrjA_1750676320
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a4ff581df3so1942076f8f.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 03:58:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750676320; x=1751281120;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OcWuVqlYqc8Fv7LscejW/AotfZkWXZJQvOx/NWErPRU=;
        b=i8ZaT4xBPFWr+db9xB/0w9OLi94RoU+GvED2EnYJX5+ECUqFSk3yHlffAhmgs+QDBP
         wR+yeUrH6bIwZG2VuGm3jATOI/RVqYDQ/NgfTLhBRoXzpplc1mKpa16qqqPKQEh+hZja
         7iVrhQKmC41DOXyJ8HJsCheJQr1F2vTnKb01H8G/M9qKsBJrC2/Ko2FWdA37xqm0aTz5
         ecNOeW8KAOKq2z4hZuIU/RRtzJ6fsOLaYoN7ak7HWxcAt2imWbqJ320peu3mNh347ipJ
         1m+AQ9zFyJvx6cQMCYxUeVT+Vg9X6o8dOjbGZ7FQue1uWazYPlSQhyW3cSxIqt4evBYW
         kCzw==
X-Forwarded-Encrypted: i=1; AJvYcCW8sDVbdTtoiBOOyaMAVQa+d1GWZaSSOFYM5OkHI7oZ1P2AVLV7F85slodsmryDNYOCR+0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFee6PHnz/rmqz8NE1aqqwWMQAhdz/2Gztyi/G149OpdvbYtUO
	urj8jlYSyZvb19DChWOVfHQFqCfYZxZE/B0UShfzPKH/Upnuj/BcG7z1gSfcGBXpxgdpyf6onfx
	z5gWFF7GlXD/tLqIsSQEMa3OHU78+Yq5LcTtmK1Y12SQ/Rr+9W7TXOw==
X-Gm-Gg: ASbGncvML8HG1w2Dd+DCxySgs7bgM1cT6cTXAibX8jQHKXUPPTVeKv2w+qIszFHUuCg
	/OZaV23CfLIToYCdtw8OoK2jGvm2YxIso23ArycB1HRC+HHd00R5EXtRPUVV10tbjeeNeb0EJHh
	Szfh8bwQdjPgHZcM7N+BgSxtLXNxbEP9iqax5LKC9p98mdMcaWZaEgmqix7LzTSDHLjQQRdbQJf
	1sFJ+jbSWtkayfn4EnAfErca+mnGNdyelmrnpsEbsliGwKNdQkY8ku+yE3mQpeQbBwrZZ9FW67n
	p4U5D8JjjnNV66nmOpGJuhDzjX1wdwHIY3sHrQu6ymmkp+DA8vY=
X-Received: by 2002:a05:6000:18ae:b0:3a5:1388:9a55 with SMTP id ffacd0b85a97d-3a6d27866c8mr8793337f8f.5.1750676319667;
        Mon, 23 Jun 2025 03:58:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEuACVKe9HFC6qufVqz8o3XpVCa/QxvhucENHMrVNmqYzlGVMUG4A86okn7ed0TQ1m9XLYpDg==
X-Received: by 2002:a05:6000:18ae:b0:3a5:1388:9a55 with SMTP id ffacd0b85a97d-3a6d27866c8mr8793314f8f.5.1750676319238;
        Mon, 23 Jun 2025 03:58:39 -0700 (PDT)
Received: from [192.168.0.115] (146-241-49-103.dyn.eolo.it. [146.241.49.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45366181aebsm58339325e9.3.2025.06.23.03.58.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 03:58:38 -0700 (PDT)
Message-ID: <61d10c9b-4f1b-46f6-9a52-1de9aa193a7b@redhat.com>
Date: Mon, 23 Jun 2025 12:58:36 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 net-next 4/9] vhost-net: allow configuring extended
 features
To: Simon Horman <horms@kernel.org>
Cc: netdev@vger.kernel.org, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, Jason Wang <jasowang@redhat.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Yuri Benditovich <yuri.benditovich@daynix.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>, Jonathan Corbet <corbet@lwn.net>,
 kvm@vger.kernel.org
References: <cover.1750436464.git.pabeni@redhat.com>
 <e195567cf1f705143477f6eee7b528ee15918873.1750436464.git.pabeni@redhat.com>
 <20250622160221.GH71935@horms.kernel.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250622160221.GH71935@horms.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/22/25 6:02 PM, Simon Horman wrote:
> On Fri, Jun 20, 2025 at 07:39:48PM +0200, Paolo Abeni wrote:
>> Use the extended feature type for 'acked_features' and implement
>> two new ioctls operation allowing the user-space to set/query an
>> unbounded amount of features.
>>
>> The actual number of processed features is limited by VIRTIO_FEATURES_MAX
>> and attempts to set features above such limit fail with
>> EOPNOTSUPP.
>>
>> Note that: the legacy ioctls implicitly truncate the negotiated
>> features to the lower 64 bits range and the 'acked_backend_features'
>> field don't need conversion, as the only negotiated feature there
>> is in the low 64 bit range.
>>
>> Acked-by: Jason Wang <jasowang@redhat.com>
>> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> 
> ...
> 
>> +	case VHOST_GET_FEATURES_ARRAY:
>> +		if (get_user(count, featurep))
>> +			return -EFAULT;
>> +
>> +		/* Copy the net features, up to the user-provided buffer size */
>> +		argp += sizeof(u64);
>> +		copied = min(count, VIRTIO_FEATURES_DWORDS);
>> +		if (copy_to_user(argp, vhost_net_features,
>> +				 copied * sizeof(u64)))
>> +			return -EFAULT;
>> +
>> +		/* Zero the trailing space provided by user-space, if any */
>> +		if (clear_user(argp, (count - copied) * sizeof(u64)))
> 
> Hi Paolo,
> 
> Smatch warns to "check for integer overflow 'count'" on the line above.
> 
> Perhaps it is wrong. Or my analyais is. But it seems to me that an overflow
> could occur if count is very large, say such that (count - copied) is more
> than 2^64 / 8.  As then (count - copied) * sizeof(u64) would overflow 64
> bits.
> 
> By the same reasoning this could overflow 32 bits on systems where an
> unsigned long, type type of the 2nd parameter of clear_user, is 32 bits.

I think you and smatch are right. I'll use size_mul() in the next
iteration. I'll wait a little more before posting it to possibly allow
for more reviews.

Thanks,

Paolo


