Return-Path: <kvm+bounces-70577-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uaR2NnRoiWks8gQAu9opvQ
	(envelope-from <kvm+bounces-70577-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 05:54:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3404F10BA34
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 05:54:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ED4E93007AF9
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 04:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8FD9274B48;
	Mon,  9 Feb 2026 04:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SDXu/U7C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21BD18027
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 04:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770612844; cv=none; b=Ue9HIPzRgT/pJimG6pClagZif/Pv5+Y3c5fLUv6mPal3CaT44nqKfwqqmKbTvICFA3+5OKbpealEU+z84b+BFFrzTXYB7jJJCzL2BTQmULuDkaBjL82o8cK3YHgA1B/y12zup7qBCx8M2/yMsfDYo/4EGMn96fNfhDYZ3QEsFuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770612844; c=relaxed/simple;
	bh=cCFkYheNxAxgc5CJUbpteAClEGaMPe+rxZYxXsdsxoA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aUbrjYr31G1gZbKo/Q0ODnaNO19l+hFML6brfXqNiFn0n8hBaw3OqdRf/7T6f8F3mV6Ylbb/9iv6AFPrOYyL89ce3BznLP9SJnC+MdLfkVAATGPlivaBGzGZ5o3GnZazBAISjDTYSIsLxkdlMab4j0DR+zupZ8Xh5s+B3T1IFPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SDXu/U7C; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a79998d35aso29211015ad.0
        for <kvm@vger.kernel.org>; Sun, 08 Feb 2026 20:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770612843; x=1771217643; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0QomsFYmffLkEMnxqCyMdufykr7r2CW8GT+jtuC4I9Q=;
        b=SDXu/U7CAMYd9jT+J5lUajmOFVSEehXWzJQN33/zIfg9KFHV0j1cLhrB2BvA51lG+C
         DQRMayzVw6woggW4ikaJYemnJRsnjUWVfatrXRir4eNbRJPphBIew9T2gYUtxnnDsrn9
         ktf5SgdEG36G7qZYK+XA2C9Wd72WHFmXgi8+zFfB+dcx+1QWEKJsmE5nnsEYRrgUMmLe
         Mmy0dwDc3Ptxb+qNRLAOZ7QSjmUbXv9IiGn8qgqZsCH8PquO6wFgUOetf3BCRZz0rjac
         u8PHR06yDCLSxko92xK8zChXkTCcw4hA0dizmugHexktjHKJkYK6APTW+P7KjuP3QNyj
         kKUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770612843; x=1771217643;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0QomsFYmffLkEMnxqCyMdufykr7r2CW8GT+jtuC4I9Q=;
        b=dHPCiQHriJM6eqNjIx6aCceQP3CJEy4LWE4D+cXx/Qi8ZptazQSU1IQi0w6esvI0Xm
         l7vCU8MJOOFT5aXbTDWnPGItXpZxOrtKKXeg1ItOEjBxoriT1+QzX5KvviLOlMAS3PAt
         jCJOqZQKRH/8fo2maE/rvqb457XUqxpr0Wb6ssHnba88i6TCbHEG0zCV7Tcj7qHMQAtZ
         awwybcuJ8zuN41rJ0tIzFEkPA2FWsLvr9OSBLZI2znKgga0V+CuhlUIhuQZg3S14Z1V2
         LAxhNIIjxL3P7q/cc/fNtJwpSPQIQLKbeirB0rePmsOxR12FzQ7qrA/DBr6hOIHYJMTK
         bYBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlvByvehK8SOCvPgBfD8y0aOm1AVBjmLtnwchP61UfcUVoSf7GAA13mY5yBoC+0Nr4e/A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTvl0c8M0QT06VPaSQeBhss2vpHn2CTv1GFTdznJOgOBgfk5it
	m0o3T1fpbPAfKwZIf9zSEI5WIz6oJPTntWssltfCbl0xKsreZmBg6A8oO5w8Bn2IGNq31CBC9EW
	NQDElCuw=
X-Gm-Gg: AZuq6aIhcZaVbCRMtbvX9NmR9a0U9gwEJqpNy70/l715yfFqvuXW/gzbrplztpIYxUL
	h92M7ujRdUoPr8WlgICBTeDkuwSKfgrKokuF1XncYBP/i6CnYLHGOSyvF+3vBvBp/e0jmlUrABe
	KbniMgB9gg+inH3SdO97kfhOD36djVeS54WCRWOW8uufsQNlWC29XkJfFziVpqsZjdOWHsldnOf
	200/60n9o6ljUxVCM2FZW/x4ff85UGVPaGa3oeegPx4gR0JkIRTIoBqmYmA1NjzGthgIOzzkvYF
	qRgnf1plcAwLyYyLKOOSWgtrjG0RsqmjPJDE5i9B0s78JSgZAXUDMp9hDs3Vv8S49nRXZZ7Axo6
	kSVkJvqGHLSQwYltdhMTm9IwPiZICt+0F71PSZZ0WvcbnLIj6tgNnsQo9ZHE+krsGU2RJugOQJx
	FMjYl5WLW3+XMeZh5D7TpnlfT27DLPZpnqIod2U6VMXXkLqu/KIajPGn12ZXW5nuw=
X-Received: by 2002:a17:903:19c8:b0:2aa:dd98:197e with SMTP id d9443c01a7336-2aadd981a09mr37260045ad.51.1770612843118;
        Sun, 08 Feb 2026 20:54:03 -0800 (PST)
Received: from ?IPV6:2001:8003:e109:dd00:9c4:a3d:914:f9b? ([2001:8003:e109:dd00:9c4:a3d:914:f9b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3549c09ff2fsm12553540a91.2.2026.02.08.20.53.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Feb 2026 20:54:02 -0800 (PST)
Message-ID: <3391dea7-05c3-4e9a-8ce6-b013b3615406@linaro.org>
Date: Mon, 9 Feb 2026 14:53:55 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/12] target/arm: extract helper-sme.h from helper.h
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: anjo@rev.ng, Jim MacArthur <jim.macarthur@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org, qemu-arm@nongnu.org
References: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
 <20260206042150.912578-6-pierrick.bouvier@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
Content-Language: en-US
In-Reply-To: <20260206042150.912578-6-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70577-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[richard.henderson@linaro.org,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linaro.org:email,linaro.org:dkim,linaro.org:mid]
X-Rspamd-Queue-Id: 3404F10BA34
X-Rspamd-Action: no action

On 2/6/26 14:21, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/helper-sme.h                            | 14 ++++++++++++++
>   target/arm/helper.h                                |  4 ----
>   target/arm/tcg/{helper-sme.h => helper-sme-defs.h} |  0
>   target/arm/tcg/sme_helper.c                        |  3 +++
>   target/arm/tcg/translate-a64.c                     |  1 +
>   target/arm/tcg/translate-sme.c                     |  1 +
>   target/arm/tcg/translate-sve.c                     |  1 +
>   target/arm/tcg/vec_helper.c                        |  1 +
>   8 files changed, 21 insertions(+), 4 deletions(-)
>   create mode 100644 target/arm/helper-sme.h
>   rename target/arm/tcg/{helper-sme.h => helper-sme-defs.h} (100%)

  Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

