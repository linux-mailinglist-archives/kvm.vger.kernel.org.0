Return-Path: <kvm+bounces-68752-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cAyHEFUVcWmodQAAu9opvQ
	(envelope-from <kvm+bounces-68752-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 19:05:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B6FA75B007
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 19:05:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3F01EA87BDA
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 16:44:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BD2E333448;
	Wed, 21 Jan 2026 16:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YfOxEdLr";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="uHfRFTih"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57DB31ED76
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 16:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769013164; cv=none; b=sARJQLDey1YJhShwpBXh7FZBV0J3DbtSTgSkEHPmoeqryUV4dQsHepQZBOw9nyNnIWCu1XLQBKe16aIjGdakL0hbHQIvT6NPoYZK5v5M8xMXJ+AznDKuJJMUXWvYUrdqQv0U5mpl7nbGks60hALHZ6GJXGTGplDoD7vbCQuTiuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769013164; c=relaxed/simple;
	bh=FoyiK1L3Q2N5n/FjMNfanm0zKz84UsrOOXkZRg0Kqz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D+cDHrieA/DtS8vbX24o+ZTY0zyK8HkR4MF3xRIiXiJ7qMRHS8jlgkcqoeBKMcNXvmmU9lPyHw2daWX1/o31z0N/CMq287WmahMqCfdaVljxPAL1yxY/Xzq6K+2e8beVdAvmGRlL4v2z69OToBqrUzf2wjpNlwQz8OIf3RWXt3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YfOxEdLr; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=uHfRFTih; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769013161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nW2BnBCkF2OGoFoub+qogRSB+R7/eG5W/AiAxbiNHik=;
	b=YfOxEdLrzGHpTeog8pXvSFEY2dGp5/5QO+o3lIshkGSWsop7XUoceIq79xPp9WlbiLYm5T
	j+8oKKKVJfDgfXKLB53ompC92xLOgf8c1dXDjbohxSnqzr17Ik273EuHg53wj3KJ0PmNlA
	dLdWZtqRGTPVMExacqO0BTfSvVZA5IM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-lNKOHUcVMtaYUtgqlBj8qQ-1; Wed, 21 Jan 2026 11:32:39 -0500
X-MC-Unique: lNKOHUcVMtaYUtgqlBj8qQ-1
X-Mimecast-MFC-AGG-ID: lNKOHUcVMtaYUtgqlBj8qQ_1769013158
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43284f60a8aso5675312f8f.3
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 08:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769013158; x=1769617958; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nW2BnBCkF2OGoFoub+qogRSB+R7/eG5W/AiAxbiNHik=;
        b=uHfRFTihlUj88DkU8QbU/t8ym6xQefp4tJmsMBv4J2mwvKhiUOosOMowjxEtB64lDb
         dQ10DgBKOZ/8BUYVATZs98y3HsBL9hbuhkqrtB07Wy6w7AK9ANhnPmbw+m3YoKcTEczL
         Zkrn7TR6yJFLEBjqvcQouoggTrm7Dr0886+wW3UfhjW+WWSAFXt7sxU8yXmuKABceJpW
         5i0XHX5Tb80353AgakZuIQETHb2A8mPxUUVjVp5PVnnZLJq2BE4WEUgCCCqxrDZA0Eer
         rRUAFLURHKpW6pSPs8+07mM6SH9EtOZk5WYFUmGjEPw7rK75bXbtihxOQtDdyU5JaRze
         bt6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769013158; x=1769617958;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nW2BnBCkF2OGoFoub+qogRSB+R7/eG5W/AiAxbiNHik=;
        b=bxIMgu+1cpClKQAnv80rFWzyVU8kom9NbY9Ca10RsmhcrA9MaVugxn+lLA+gijb/Iw
         9xxem/lduZ0hlVvwh6dWoiszsCPpj7QpCwyPTE7d2X/VjlbEgeJpCppu/XY5a1JC6Utm
         0O7U2QGzmhSWjLQ+F43MDAOBl/lNn2Yi1KUPDQ7lV7ZDhv0t2rxL1vPFSeP2wzM7QCLd
         lDkYVlODQkpiVpLdNJ4C3eqrov6P+yfxbm07mLHM5bozkncRey2PewPJnIUrskMP9zZj
         PoOf25y53XfWlaIFwr8wczA6ZkKTN7a+qyoWZD3bfwkVsdzMxFU8PAASJ8sSpz8bV8vF
         nvXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWeEQgB5PNl3x24TmnkPUGEXCLunZFO+O3tg9E1wS6wUIsK8wtLaeJZh2PM28zEYISYZDM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCzBgwrL2SLSgOcZvlBNQsSZbpMPLX4WvFfU4v/IfS13yvKGZc
	k9xRwnUPg3veo6rbX7Tg7MqDqojneWeuBMUudVxEv00mpRyKBUccb7MeU5QHVzNT53VHmE7rkr4
	NRiT0XBi85ijojXOBsfvCrK4JXwELnJFbQxB1+lc3B4y3lOQ34J1gmg==
X-Gm-Gg: AZuq6aIKR47ezYa62iLOMlUxtrE0x+Wjy3y0d4s5pPuZdYN7dgZS5vieypw6Y9s7vdv
	z0aG4sbbL7GARcP1ydaxaSMSi/l341Gv6hUIemcM4xa8A5WOr3JxdvdJXpJMufLry6zrzC4JLwh
	dWHiZWGw2vZde3BLpsGiuQZDbS5tzyLq+28y0IkL5NXl9JsLVA86Of7mml8Er92Lhg/+qeH/mq2
	v7tBU0pC3yqzyTNi1U3S0ZD+4FHDP+Hl/70VHQVEhGz8c4VW4Y/+cLhxlBRYq+IUWCbCBCWO46Q
	fWf19tbHxo0e0X0urEYuRdcBvTvMGW1lR4je2Hi2BoAIEhtOb3ad731jvRi0WAU1nFSt96lUAc1
	MVJV+XFREjPlb
X-Received: by 2002:a05:6000:2082:b0:435:693e:c03e with SMTP id ffacd0b85a97d-4356998afa2mr25422046f8f.19.1769013158388;
        Wed, 21 Jan 2026 08:32:38 -0800 (PST)
X-Received: by 2002:a05:6000:2082:b0:435:693e:c03e with SMTP id ffacd0b85a97d-4356998afa2mr25421964f8f.19.1769013157874;
        Wed, 21 Jan 2026 08:32:37 -0800 (PST)
Received: from [192.168.88.32] ([216.128.11.175])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356996cf58sm38575864f8f.22.2026.01.21.08.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 08:32:36 -0800 (PST)
Message-ID: <4997118e-471c-45fe-bc1f-8f6140199db5@redhat.com>
Date: Wed, 21 Jan 2026 17:32:34 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v15 01/12] vsock: add netns to vsock core
To: Stefano Garzarella <sgarzare@redhat.com>,
 Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, "K. Y. Srinivasan"
 <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
 Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
 Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa
 <vishnu.dasa@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Shuah Khan <shuah@kernel.org>,
 Long Li <longli@microsoft.com>, Jonathan Corbet <corbet@lwn.net>,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kselftest@vger.kernel.org, berrange@redhat.com,
 Sargun Dhillon <sargun@sargun.me>, linux-doc@vger.kernel.org,
 Bobby Eshleman <bobbyeshleman@meta.com>
References: <20260116-vsock-vmtest-v15-0-bbfd1a668548@meta.com>
 <20260116-vsock-vmtest-v15-1-bbfd1a668548@meta.com>
 <aXDYfYy3f1NQm5A0@sgarzare-redhat>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <aXDYfYy3f1NQm5A0@sgarzare-redhat>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68752-lists,kvm=lfdr.de];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[redhat.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[31];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pabeni@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: B6FA75B007
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 1/21/26 3:48 PM, Stefano Garzarella wrote:
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>> index a8d0afde7f85..b6e3bfe365a1 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -8253,6 +8253,20 @@ Kernel parameters
>> 			            them quite hard to use for exploits but
>> 			            might break your system.
>>
>> +	vsock_init_ns_mode=
>> +			[KNL,NET] Set the vsock namespace mode for the init
>> +			(root) network namespace.
>> +
>> +			global      [default] The init namespace operates in
>> +			            global mode where CIDs are system-wide and
>> +			            sockets can communicate across global
>> +			            namespaces.
>> +
>> +			local       The init namespace operates in local mode
>> +			            where CIDs are private to the namespace and
>> +			            sockets can only communicate within the same
>> +			            namespace.
>> +
> 
> My comment on v14 was more to start a discussion :-) sorry to not be 
> clear.
> 
> I briefly discussed it with Paolo in chat to better understand our 
> policy between cmdline parameters and module parameters, and it seems 
> that both are discouraged.

Double checking the git log it looks like __setup() usage is less
constrained/restricted than what I thought.

> So he asked me if we have a use case for this, and thinking about it, I 
> don't have one at the moment. Also, if a user decides to set all netns 
> to local, whether init_net is local or global doesn't really matter, 
> right?
> 
> So perhaps before adding this, we should have a real use case.
> Perhaps more than this feature, I would add a way to change the default 
> of all netns (including init_net) from global to local. But we can do 
> that later, since all netns have a way to understand what mode they are 
> in, so we don't break anything and the user has to explicitly change it, 
> knowing that they are breaking compatibility with pre-netns support.\

Lacking a clear use-case for vsock_init_ns_mode I tend to think it would
be better to postpone its introduction. It should be easier to add it
later than vice-versa.

If there is a clear/well defined/known use-case, I guess the series can
go as-is.

/P


