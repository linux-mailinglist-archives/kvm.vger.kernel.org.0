Return-Path: <kvm+bounces-65089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E54FC9AB6E
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 09:37:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3B43B4E22D4
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 08:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A87D306485;
	Tue,  2 Dec 2025 08:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fc/pvP7/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6A23054F2
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 08:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764664629; cv=none; b=NrvbvYMiFU7Brjxukjl1a+OCPIWlFjBMI95ODwSMZbc6zfdcx2N1RP5EH4SdpyT0qoQBJWJSr/0TAnNyuCNd6oETJOAxb149RLBebIklO82AIeSI0t1JegdWr3zUcSjSdCa/rOoQIUFb320MFvEz490t4qZocipw1/intFPyATY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764664629; c=relaxed/simple;
	bh=ljPIFfOFsoD0IY+vD8iQiUhW6H9eT1RLD0DfmAdK6+0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=TwTH40RwAKSSjqPoEFLrASx0CuEYylcPFClgC2kSphbYhL6lsaOx3FjpFL38/v9DSP2xJPR1fdJeKSxGNr41rAiGF6TcvHeWdjX17nEWzEc3seeAEy0OvPVui17lAGcgliiMoQkNoaMRoAIaaLv7KW5OwRLDt98iaDDWx4C+4mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fc/pvP7/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764664625;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FhxQP8uDcgw+uSq85Q9qXw4+E7SaR3rSwXRIV3Ffat8=;
	b=fc/pvP7/dgCeEcGjfHTaRONHGbXaeBn5FNCDyZC8chCiZYlgaTDTtUhtcLRpjP7b3k6saU
	iYEZmVNDjfQpP3U1cYrwZoTNHkLuw7atVPnSr8A+k3jmaRB8vwxjJT5zLD5ZuJLwbsV7rU
	eyYYrDrOc2XXCzJm3aQFb9ENu9nAWtY=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-44T1Lbp0PbqMKVCgbYyNDg-1; Tue, 02 Dec 2025 03:36:55 -0500
X-MC-Unique: 44T1Lbp0PbqMKVCgbYyNDg-1
X-Mimecast-MFC-AGG-ID: 44T1Lbp0PbqMKVCgbYyNDg_1764664614
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8b225760181so589139085a.2
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 00:36:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764664614; x=1765269414;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:reply-to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FhxQP8uDcgw+uSq85Q9qXw4+E7SaR3rSwXRIV3Ffat8=;
        b=ThQ15VJixLV6Xr6DFJ/D2RsCs+8CiOpjL7dPDAiRHd1/wanSgLJGx/BrCAB0fF4kPw
         5e2iuTXqBWS2iN0GP4raNM6CofsuEYg6j3zRJAgQwLAI1sK6EBiDHGjevjmR+fB+KdPm
         irTy0R+UZfAgN7oSAG4vUCIwqcSZWZOlYhJ1JQYLL9Oybq6LIwkaryXNslilLDQi0BBL
         XIHj2ZBklx8n4cnPL9vFECY/SnKhk0kjJZqrHhSUr2MBARnIHfKVLg77hXy1k2xJOswJ
         P6yaVBCEnonCdFZQ3P1p8qDuQTMcGnzlV1I84pFs0hq4Naki1p8o+gTLjersSWx8PiZ5
         79jg==
X-Forwarded-Encrypted: i=1; AJvYcCUgfQYUVHFoEcFnxZDhvOnefVVsXy5WoXN0ju6gsBKo+prtR3fr8x5+5eNK4R0y09PBkuM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyODKkzjUItTCZ/Fp727kBfA/LGSSixoMUYkuLTztwH0qTAxWT
	mYhjKxrV1AeIdQsNNSqiePFuO6iCDzQGtn5oR5Zn4tGcWCyoxDUHuwF8MjeJaz8fS0XHBES1hS0
	PVCGKGbXbrKpqm6fYj0kfq8mqUMf3uO8N9TBkmlJZpLOggqNrU9NQXjeLVjGdaA==
X-Gm-Gg: ASbGncsMLfpRoR3M/kcxZmVrJg27fwaxcdlkKWkBQLpsMBOkwkwFoBdor/5gA50CAsA
	b7DS7tQZeHzJkCQUjw1Xs3OysOc4CR/3JoniTG0Ta+F9oPZipH0+XHp9L12AS4vAzKRqJveu44K
	Y2NmEaq1gIMrfUfezgsQ2NqXYbXp3cbj5JcfqhPSm5CaaDRPiMJFvVlSymx/mxIFL0cf5oZC7bf
	9ALNmlT6Rjp7ifyAcrEXwOVu3YwcTUZBEgMmbkrPSOaJOTH446THbOymBbAUiXi8P+7eZTomTeS
	5V+o0QhNZhh9q1ClzYj/luGQtSGnAJBfjw5qpRtQVu19bu7j82aMRABOJ91B2uEGddQXBdBfv0P
	KJ+JQfKJ2tiz9W/BNpl/9r7LB/T0MjMvBhoXD94lvcxCSjBQOozWWeoTPqg==
X-Received: by 2002:a05:620a:3188:b0:8b2:a0cd:90f1 with SMTP id af79cd13be357-8b4ebdad2d8mr4544476285a.61.1764664614327;
        Tue, 02 Dec 2025 00:36:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGd9tm/hSDq7CPEdeY5DUJhc1/EEJO8Va3XfuxS5ihcgleQQ+YC8AQSXG14NIQ79+naXx2fkA==
X-Received: by 2002:a05:620a:3188:b0:8b2:a0cd:90f1 with SMTP id af79cd13be357-8b4ebdad2d8mr4544473885a.61.1764664613886;
        Tue, 02 Dec 2025 00:36:53 -0800 (PST)
Received: from ?IPV6:2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e? ([2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b529993978sm1036295885a.5.2025.12.02.00.36.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 00:36:53 -0800 (PST)
Message-ID: <afd45a76-b215-40e2-b7d3-457bf7e0b2b4@redhat.com>
Date: Tue, 2 Dec 2025 09:36:51 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Eric Auger <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 05/10] arm64: micro-bench: fix timer IRQ
Reply-To: eric.auger@redhat.com
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-6-joey.gouly@arm.com>
Content-Language: en-US
In-Reply-To: <20250925141958.468311-6-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/25/25 4:19 PM, Joey Gouly wrote:
> Enable the correct (hvtimer) IRQ when at EL2.
>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arm/micro-bench.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 22408955..f47c5fc1 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -42,7 +42,7 @@ static void gic_irq_handler(struct pt_regs *regs)
>  	irq_received = true;
>  	gic_write_eoir(irqstat);
>  
> -	if (irqstat == TIMER_VTIMER_IRQ) {
> +	if (irqstat == TIMER_VTIMER_IRQ || irqstat == TIMER_HVTIMER_IRQ) {
>  		write_sysreg((ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE),
>  			     cntv_ctl_el0);
>  		isb();
> @@ -215,7 +215,11 @@ static bool timer_prep(void)
>  	install_irq_handler(EL1H_IRQ, gic_irq_handler);
>  	local_irq_enable();
>  
> -	gic_enable_irq(TIMER_VTIMER_IRQ);
> +	if (current_level() == CurrentEL_EL1)
> +		gic_enable_irq(TIMER_VTIMER_IRQ);
> +	else
> +		gic_enable_irq(TIMER_HVTIMER_IRQ);
> +
>  	write_sysreg(ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
>  	isb();
>  


