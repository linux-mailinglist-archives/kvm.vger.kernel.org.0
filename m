Return-Path: <kvm+bounces-37228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F7B7A271D4
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 13:32:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 404D41882684
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 12:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFB41211476;
	Tue,  4 Feb 2025 12:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gpf4dkAg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DD520DD64
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 12:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738672167; cv=none; b=YQbAI3fxg/WFCKtS74x8RNcWv824QCHlWgbG1ZwODgrG8PX3zldI577DaHsTyEp6yPpR1NQi/6qrH4F84QCClczSLkRtejNIsZtYa4nf+xshAgK6mJMCGCuhRQ5U8EswUP9/eBFi7BbmEjRnTTNMdHgZ0nUXpJ8iuyaasb5oCf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738672167; c=relaxed/simple;
	bh=u6K1gc6fqbQ9CyQmR1XZtEDc+/599QHfU81+5JM+XJg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HO2UXXKixT2WEWKD3OVMBN6sSHKSa66ru7pM9HHTn+NLRDGXhORzYngvVsn/FRJhe8UPlG2QeMlpm7boCR5Dvj3Qzf5fipxYkMzPF9f8FRvKMgD1zlB4+yLwcATt8epvup1ZcBJ1WTXLLkHQyrcstmsJDLnKrDBbcuaZmSHKV0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gpf4dkAg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738672164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SVt11t4VdzXmaGrVYonLKU4tNbyq45g4LumiKNuZLV8=;
	b=gpf4dkAgfZJjGroqrLhLo3yFumiFQAk31z5ESXLMhDdRsT+lQuGavqltxlpN/7zOUmC8nh
	aTwS84LAU+1deAaNSOI9AuQ2yVC1ACrk8zt+e2NXiwMKgha1x6qno/cGPZp+dWxl/+QdRm
	nlNcTk6Bf1bHEzcw+QtC4YaaxFYDY2o=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-IdOVfQW5OPuenZ0uZJVa2A-1; Tue, 04 Feb 2025 07:29:22 -0500
X-MC-Unique: IdOVfQW5OPuenZ0uZJVa2A-1
X-Mimecast-MFC-AGG-ID: IdOVfQW5OPuenZ0uZJVa2A
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4361d4e8359so38993155e9.3
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 04:29:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738672161; x=1739276961;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SVt11t4VdzXmaGrVYonLKU4tNbyq45g4LumiKNuZLV8=;
        b=WoOpWNihgxO5z9FBWuHMGZESdz7LvpqnubgEdUuquxAPm4YwikNEnsbnczOdLTZVxc
         ygQjAzH4MDgt/mQFZFsnTpYSTxrBdBcVwsLIgYzCibLHzZTHRXLhjbyUE9ccqMgKMQ9i
         G1FqiUvJBv52gCKDN4L1TAahNafIEJ1iqXlFFxIEtAOc9yYivZX9bQPo6Npn4VwvgFAx
         zPMV9WPefgSLsmY0LjbvTY+MWzpl9dSZzwZSmx5iNfGoZBubrB6wHYFnkJTWLQCjxivJ
         GqrWnPOrmN21qyMDcUjLPPv8Je036cW7nHzGzAXoFuf4h3uEqh6eYf8MaoiRRdurZTRm
         Qr8g==
X-Forwarded-Encrypted: i=1; AJvYcCXpyrmli3jPssBnJ5QDQKXGRB3BLSixn5005tjeKqnrQb8MgaCMrthdhNsJtmzzCkylprw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyviwmqCdx91pMqKfdyBDbSdG274fHImOaIL3ZrhB8OdHJZJsv2
	xcuZbuN4M8qJgaXgHe+xUY9L/MRsw1NueqQvMhY8D1wsdVz8IOPJjPfxeAMYjvolw7axyRw0Kv0
	sdvNw9THDTSTmubFPuYkPHtgKTRH2R7I+yNOmZYwzaX3Vx2wQ4A==
X-Gm-Gg: ASbGnctY3BG8zZoe63jLz3OPsR1G5IWr3VYRhQsFU8bvLDBDbhQvhPYDM0HMVm0oqR5
	/Gby0lNwiWemyWrYi4kGy7Ea771YJ1cFx/t503EZrqhSEWtkHX86hKX7fb+X9s5JLZZAD49m2N/
	kJTt/T83pjH4vjB5MIMq5pfAX7oMhrtl5hk8RqEoOJm1dO8CHeWpk14aJgROs0M3oG03sQK8CxN
	yrA6dyc/w7JAV2tmjojcaPE1Cd8rMduB3XwjucbtjPISmey/BThE/DX3XRO04IJ40qO3MV7Ce1h
	zwsvbA3T55ZuXZbDYhZMdut82Fx2daEIMYg=
X-Received: by 2002:a05:600c:5248:b0:435:32e:8270 with SMTP id 5b1f17b1804b1-438dc3cac3cmr242156335e9.14.1738672161579;
        Tue, 04 Feb 2025 04:29:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF6sf3mUWx9f6oCktAawZ1NkGZse1Cb+QiEWr0dnqS8PjvhkiCOef50Jj0CTOWCanLTCjNSYQ==
X-Received: by 2002:a05:600c:5248:b0:435:32e:8270 with SMTP id 5b1f17b1804b1-438dc3cac3cmr242156005e9.14.1738672161191;
        Tue, 04 Feb 2025 04:29:21 -0800 (PST)
Received: from [192.168.88.253] (146-241-41-201.dyn.eolo.it. [146.241.41.201])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438dcc8a59dsm228847985e9.40.2025.02.04.04.29.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2025 04:29:20 -0800 (PST)
Message-ID: <c8dd0458-b0a9-4342-a022-487e73542381@redhat.com>
Date: Tue, 4 Feb 2025 13:29:18 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 2/6] selftests: ncdevmem: Implement devmem TCP
 TX
To: Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, virtualization@lists.linux.dev,
 linux-kselftest@vger.kernel.org
Cc: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Neal Cardwell <ncardwell@google.com>, David Ahern <dsahern@kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>,
 sdf@fomichev.me, asml.silence@gmail.com, dw@davidwei.uk,
 Jamal Hadi Salim <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>,
 Pedro Tammela <pctammela@mojatatu.com>,
 Samiullah Khawaja <skhawaja@google.com>
References: <20250203223916.1064540-1-almasrymina@google.com>
 <20250203223916.1064540-3-almasrymina@google.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250203223916.1064540-3-almasrymina@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/3/25 11:39 PM, Mina Almasry wrote:
> Add support for devmem TX in ncdevmem.
> 
> This is a combination of the ncdevmem from the devmem TCP series RFCv1
> which included the TX path, and work by Stan to include the netlink API
> and refactored on top of his generic memory_provider support.
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>

Usually the self-tests are included towards the end of the series, to
help reviewers building-up on previous patches knowledge.

>  .../selftests/drivers/net/hw/ncdevmem.c       | 300 +++++++++++++++++-
>  1 file changed, 289 insertions(+), 11 deletions(-)

Why devmem.py is not touched? AFAICS the test currently run ncdevmem
only in server (rx) mode, so the tx path is not actually exercised ?!?

/P


