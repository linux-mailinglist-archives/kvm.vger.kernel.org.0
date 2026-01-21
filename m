Return-Path: <kvm+bounces-68700-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oMn+D4OhcGlyYgAAu9opvQ
	(envelope-from <kvm+bounces-68700-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 10:50:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E639F54B62
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 10:50:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E29C25AA048
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 09:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FB64478848;
	Wed, 21 Jan 2026 09:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U37TlUUr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFC144B66B
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 09:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768988364; cv=none; b=BXq0NSWWon1NG1T4ta/8XedpIA913Q9856QpWmqvTjGA1YiUv4JEs3pqgpN/2i+pxwERgybG5RRL6Y71xsqxKo+DLF8gnSsh31fq/X8lTTvVrS9F567gYDyxCfEXHSD3A/FqYcJr7E0sWqSqa4YuL6w2zVYGPxNfPtQDmLYn+7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768988364; c=relaxed/simple;
	bh=6TUgpJxKh+r42S1F4Wrkpyb8Ir4NoTjV1eG8SILKXOk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LjXX+mVwU3I8EevVBhbrpsi5pybgV8BO2VIlOvpQB5pl4g5OyMPL/CCnj8wFhU8TmD5mlL6s0RBNcMUNLSqEowBVwijVckOYBcP7N8e7JNVNwhuA/WDwVwdTNjVxhAi85iNUgVuxNowpNLG9PZhOVirOLEAQwSpy+YDicVBdRoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U37TlUUr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768988361;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t2/xT8iPwxVBhXyFiskTxjU+UnFqiORTdZoi4L7IpKI=;
	b=U37TlUUrrP15/sjXyEj2btYruaUPaIGK5UARPapHFfHXp52gxzO1r0sm41eVJiLLkCw49I
	6ggUWFF35VsPYhVgGzxmnEM6Mgf+XpIGF6NOGyQnzC3UZy4W8tlo1d2IGEHbEwgRiknA1n
	mtQ56c/S6dpqTqTdV9p8n5PE7SyJP8I=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-5GD_mVDiOZ66-gezBLPSZQ-1; Wed, 21 Jan 2026 04:39:20 -0500
X-MC-Unique: 5GD_mVDiOZ66-gezBLPSZQ-1
X-Mimecast-MFC-AGG-ID: 5GD_mVDiOZ66-gezBLPSZQ_1768988359
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47d3c9b8c56so72917955e9.0
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 01:39:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768988359; x=1769593159;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t2/xT8iPwxVBhXyFiskTxjU+UnFqiORTdZoi4L7IpKI=;
        b=Faq4t2q5tVNpw5w8N4SYuq1J3ldTdRAxnU5X5lSJUHPeLDP2EwVVK2SaJ1ozY8pRIL
         GkOHJKCKcxB+ZCBfWBYIou/HC1hIdEwk+fpUpuesIAUZeEnKGIdUeb04iOOZQLfcjnn5
         t+JMQv23tidYqvB96tugJdCswfuWqMFGfcAutGqeSVu8hDJAnR9ljwgrJwy9Y4zN59T8
         H2eJfDl+S64NohA4F21m2QF5IlVnZdViv8tGPgqozkE2zQeuj6L529/HK2HH6DGhIRpy
         LWbLY+n2US9MDwhwhC3wjrPfJo3Y41zK/JhrVqC4GZB7nefh7VXRH4y9xBDx1yjNoNUZ
         KwPA==
X-Forwarded-Encrypted: i=1; AJvYcCWpb4hoJinpDIXBOeuigJA+UWKDEcMbHXqA3VwNPL3xOoR9N34llMmd7CwJRkSLVlr6a7g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+Ax4fqBpSf34c6Ebmq3V5fVvEpVaIeqQw5jdYTueKGiAF/YlF
	vdWt5jl4a+RzsAiCsxEcVdBAUT000daGui3jjdQjm1C+/T2nSAoFDhaKK9QUEK6TWqz+/cO+wSi
	xqnJIm1accRJoEiqpBxFks/ANep1p01MlTN/GWEkEenap2XImRpRABg==
X-Gm-Gg: AZuq6aL9YVB5BESG8eAT2mkXPDWrJA+78atFqQP/xc1wqMxGR9FyhitqXQI8sLv6/vu
	WwFiBoKqKSn3ff+3IQx0c4BAzipm2JN2Qn6gt8yU6FrFGyFOvgm7B+hMaNwBgA4hzj6YzP8SO0X
	pDBAgmNkZc5NP5XlbeApKUt26Q9uwyotXuVYIZ4h+rOOixbWh4mxLclJH4loXEad+o7BsCOB9sS
	vhmKEnmAyM5XwCJ/i/5LdJuz26rEjVU1fkfCKxusfn0rJcVk25hT7QEb8JjGE0f5KEZOA9IDqyS
	/KjddkYUIFI6fMvlNQPBZwodBixUmTlnPyx8CeokL4ZUiuyuQffLONfGSEulk6ngi3XAv/+tupq
	+gS+lSsk3wy2VcvrJPOU16luzUdvCu9xfoCmAJcwYLeThurRfViK2fYGeQg==
X-Received: by 2002:a05:600c:37c8:b0:47e:e87f:4bba with SMTP id 5b1f17b1804b1-4801eb0e1cfmr211975295e9.29.1768988358820;
        Wed, 21 Jan 2026 01:39:18 -0800 (PST)
X-Received: by 2002:a05:600c:37c8:b0:47e:e87f:4bba with SMTP id 5b1f17b1804b1-4801eb0e1cfmr211974895e9.29.1768988358401;
        Wed, 21 Jan 2026 01:39:18 -0800 (PST)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804245245esm20022655e9.0.2026.01.21.01.39.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 01:39:17 -0800 (PST)
Message-ID: <5fbdeab4-d8b2-487f-89e6-fb00037e5773@redhat.com>
Date: Wed, 21 Jan 2026 10:39:16 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 0/2] arm: add kvm-psci-version vcpu property
Content-Language: en-US
To: Sebastian Ott <sebott@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20251202160853.22560-1-sebott@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20251202160853.22560-1-sebott@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68700-lists,kvm=lfdr.de];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	DKIM_TRACE(0.00)[redhat.com:+];
	REPLYTO_DOM_EQ_TO_DOM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	HAS_REPLYTO(0.00)[eric.auger@redhat.com];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	RCVD_COUNT_FIVE(0.00)[6];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[eric.auger@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: E639F54B62
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Sebastian,

On 12/2/25 5:08 PM, Sebastian Ott wrote:
> This series adds a vcpu knob to request a specific PSCI version
> from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.
>
> The use case for this is to support migration between host kernels
> that differ in their default (a.k.a. most recent) PSCI version.
>
> Note: in order to support PSCI v0.1 we need to drop vcpu
> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
> Alternatively we could limit support to versions >=0.2 .
>
> Changes since V3 [3]:
> * changed variable name as requested by Eric
> * added R-B
> Changes since V2 [2]:
> * fix kvm_get_psci_version() when the prop is not specified - thanks Eric!
> * removed the assertion in kvm_get_psci_version() so that this also works
>   with a future kernel/psci version
> * added R-B
> Changes since V1 [1]:
> * incorporated feedback from Peter and Eric
>
> [1] https://lore.kernel.org/kvmarm/20250911144923.24259-1-sebott@redhat.com/
> [2] https://lore.kernel.org/kvmarm/20251030165905.73295-1-sebott@redhat.com/
> [3] https://lore.kernel.org/kvmarm/20251112181357.38999-1-sebott@redhat.com/
>
> Sebastian Ott (2):
>   target/arm/kvm: add constants for new PSCI versions
>   target/arm/kvm: add kvm-psci-version vcpu property
>
>  docs/system/arm/cpu-features.rst |  5 +++
>  target/arm/cpu.h                 |  6 +++
>  target/arm/kvm-consts.h          |  2 +
>  target/arm/kvm.c                 | 64 +++++++++++++++++++++++++++++++-
>  4 files changed, 76 insertions(+), 1 deletion(-)
>
Feel free to add my
Tested-by: Eric Auger <eric.auger@redhat.com>

I was able to migrate from a host featuring "KVM: arm64: Add support for
PSCI v1.2 and v1.3" to an "old" one that doesn't using
,kvm-psci-version=1.1

Thanks

Eric


