Return-Path: <kvm+bounces-70182-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8JKrCA4ng2kxigMAu9opvQ
	(envelope-from <kvm+bounces-70182-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 12:01:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B8197E4D91
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 12:01:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D9E39300E616
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 11:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F03A3E8C71;
	Wed,  4 Feb 2026 11:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e0PzF0jD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="kCAK0TxH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340B53D7D83
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 11:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770202886; cv=none; b=QoD4Tt5KOtuAUIh8cw7KVQx0q6Zmm4x4RLNAo5Lo02u6MWlZmRAouzwKjwK9rDM4rkwI3lpUJr1dnjFv/sX/NocG1qJ4X5D0p4xMS3vSCTvG2/OV3NSlZqR9vf0IVZTNDXZ6Zoqi4J9CwNj6lP4i3vgSHWGkMs6I0r63y57Ow1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770202886; c=relaxed/simple;
	bh=67Mdw5mkVMzQmZvgPdQ0iTGKtl8bJrraMJNE2XpXV50=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M8QX/22n3F9QqJkedk8a4Q0eSRdaRwe1OPVTrKogiXDeXNO27hBSfPCgGuFM0E6T2y2n/C2luk45qRsJcS8W8/IBTE+tcmwmGL32doeOX/qluBuGKBGNxQR2zOaCHqZgwOrHvGF7iWUxmL+XRD15DyomWzgS2d5meTctm6IPTbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e0PzF0jD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=kCAK0TxH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770202885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9LzQq34rqf4wVt2xmbpyvK/KfxuQ6p8j981mEiYdQIQ=;
	b=e0PzF0jDj6A/m/HxPyN5l60X1/7ZM2KHrwNVJb01Yq6XaIeNyV6s8zMf5sDMN1Gu8MBIMu
	H0J1En95tnhtA1dYmaSe3zAfbNtYlINTPLXFPzXbcb0Tv+1idrtpVIpMD5Ba5BdYRy2nzQ
	8hsY3RE3EsLV7tmuNNzj4F7CW7tWS+8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-WAofU2lGMUSGaVxaVxtASQ-1; Wed, 04 Feb 2026 06:01:24 -0500
X-MC-Unique: WAofU2lGMUSGaVxaVxtASQ-1
X-Mimecast-MFC-AGG-ID: WAofU2lGMUSGaVxaVxtASQ_1770202883
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-482ef3af991so4094445e9.0
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 03:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770202883; x=1770807683; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=9LzQq34rqf4wVt2xmbpyvK/KfxuQ6p8j981mEiYdQIQ=;
        b=kCAK0TxHMkzcSXIZv/XGh0TWMgcdwxSK/7eGyVzao5YiYtEQ90aKBuwz2RvUGd4ZYv
         vdushtQ9TaVyZkmnjeoq39kQkzq72oJEcTisvUQW3X06SR7VX7h92Ng8MK9qmgPCfWF+
         CeIih8g3aXr9fV6PhE61TerlWr3uQeRWNRWRWBamjKW9tT7F5QaE83wR7Ti6wfgG/O/5
         TnEoM6qiC4Cv89Ls0nD19mKv2z6FlsLHRCuj+EV8nBIVFQ4xG7nGOj7DfCcwVOFsqQdn
         diJ2XNgGXhcJRfQ8Mp+yNp1bnJLWHZ0n1M/EDZFTLeouPTivY3dSfdyzeBG4tt+xZ0PM
         DstA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770202883; x=1770807683;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9LzQq34rqf4wVt2xmbpyvK/KfxuQ6p8j981mEiYdQIQ=;
        b=TVwTpfezY9F3Nx0WcN2DcFMTRFYuExwIzrr7HPMmkel0b5lEQNqD6XI1jiQLjLZiU3
         VjIdIB5ZrXL5Tio+rGT3Kz5aIN2y0n7Krx9acSMsdHqnE5g1h/WPtNhs2pkjdAfsrQRP
         wFDvphbFAg3Bh1+QFDrGntw6F4rW0ePFd87dXJW4s8rBxK1Ugl+MSPhXdQXGmePnUZzG
         6JVbQkHLlLf3DfYFGXRL3ekcIB1sjkOxZfwrSs55SAry/43wt66IN8viyLMWnIIduNGf
         vxZWJ8eMT5W3lyGJ7FQlA/2fd7A/koOlF/Qm7hcsEZ2ZWeRq4Ju56prRMMyxH4+LCuTM
         YKYQ==
X-Gm-Message-State: AOJu0Yz3JlnOOyO4MJXTsYuWR7g43NG4DL2mUtiWO8XTSyG4e+F5v6OO
	+Siutt2LGvgLSNUKBazG6tq3GswghRXZjUj3lC8ljQwvFZD5k3Y+NwPLNSL9NHGU3LIlMlSxcpL
	BYHWeRTLI3A8qTJKiY0xOtYPgSeob/AWcbT3MiH0j+ATUzQk2CIJWhA==
X-Gm-Gg: AZuq6aJQwI//yReXL4FBjk/Yxrgg+msmUGYa/gj/dd/rCuVPuAZvaSrySJR7Jf1gnAS
	ZaSn9vhiIiRKlZgn+Zr1Tg7tmxh8m9JTt7mgOl8/akiaA7yyqprywT3zsKRk0U1sYdrbUVNECzT
	rP9KVz5P/TDeL2f6gMvVe5hF4VbFa+K+QDMudTkrXjCs/VYOr7b10jlvhof2VGJsLs3kI8J2Cro
	5Z/eGExXjBWp8BjD/MQ6Xy0HDEl+ITD55XFpqr+cxJ+Bjbnmw/frU/ATBhdxFsKvWvHznW6euAG
	ElbMd0IDb30AKHRRjlO0KR4D8nKvkT4Um/vOgLyYPvShcM9hbPLlCs6s5oTW4KC1RN9wbuQYQXX
	DgbcqRo7iXPJxFa/iKQdk4fZ9XoiXPGj2TolI17GaUe+J9u+G
X-Received: by 2002:a05:600c:5643:b0:47e:e452:ec12 with SMTP id 5b1f17b1804b1-48305171930mr53020615e9.15.1770202882686;
        Wed, 04 Feb 2026 03:01:22 -0800 (PST)
X-Received: by 2002:a05:600c:5643:b0:47e:e452:ec12 with SMTP id 5b1f17b1804b1-48305171930mr53020215e9.15.1770202882213;
        Wed, 04 Feb 2026 03:01:22 -0800 (PST)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4830ec42833sm28680595e9.1.2026.02.04.03.01.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Feb 2026 03:01:21 -0800 (PST)
Message-ID: <6de8c68b-f10f-4c95-8652-d1774a4a2f34@redhat.com>
Date: Wed, 4 Feb 2026 12:01:20 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/10] memory: drop
 RamDiscardListener::double_discard_supported
To: marcandre.lureau@redhat.com, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Alex Williamson <alex@shazbot.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Ben Chaney <bchaney@akamai.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>,
 Fabiano Rosas <farosas@suse.de>, Peter Xu <peterx@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Mark Kanda <mark.kanda@oracle.com>
References: <20260204100708.724800-1-marcandre.lureau@redhat.com>
 <20260204100708.724800-3-marcandre.lureau@redhat.com>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20260204100708.724800-3-marcandre.lureau@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_FROM(0.00)[bounces-70182-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clg@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B8197E4D91
X-Rspamd-Action: no action

On 2/4/26 11:06, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> This was never turned off, effectively some dead code.
> 
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> ---
>   include/system/memory.h       | 12 +-----------
>   hw/vfio/listener.c            |  2 +-
>   hw/virtio/virtio-mem.c        | 22 ++--------------------
>   system/ram-block-attributes.c | 23 +----------------------
>   4 files changed, 5 insertions(+), 54 deletions(-)


Reviewed-by: Cédric Le Goater <clg@redhat.com

Thanks,

C.


