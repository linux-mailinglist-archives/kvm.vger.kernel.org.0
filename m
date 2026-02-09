Return-Path: <kvm+bounces-70579-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eGw3Fv9riWkZ8wQAu9opvQ
	(envelope-from <kvm+bounces-70579-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 06:09:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BFF9510BB6D
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 06:09:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E8E3030073DD
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 05:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 251202D6E72;
	Mon,  9 Feb 2026 05:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lCbXX3xj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1951DF73A
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 05:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770613751; cv=none; b=pbWLimmZsap6FCKrCejuu6GKi6CzBClG1yIkHzkW/iNUZwXyIj9oykqDzOestxQB9foUWPXX1L6EHNcGFHCmphWGhWOeWoTv7RI3J0l/M1grwhBIV05Jz/PklndKIMaLpz0SA7VnjxBaa+63FLAZz5y3dc2FhMSYAChXKYOVPUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770613751; c=relaxed/simple;
	bh=PnKiSNoU+cIb+gHGU6Yld/WoAAo/GxYgHZiheYHg6f0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pCZFWiNXn3yipcxuKKKMfXxG9qD9ohFn9HBIr823hVbVsRevMuljyfiyjVIevJacV66Mfv+23kd/NEcQu6VvtsO5x5BXfbg4+LorwvugJGS3RrnHahmRThBquvmTbyPwOiIFzWDRGyLSkSuQ5slkjkCbbSBAzuC1o6PHSKsJxBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lCbXX3xj; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-81e821c3d4eso3455386b3a.3
        for <kvm@vger.kernel.org>; Sun, 08 Feb 2026 21:09:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770613750; x=1771218550; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H9/1jawVuRkI1L+N0DjtmxsYJhIanQWdbekURSZOiDw=;
        b=lCbXX3xjt4YcB/S/qMPCjS9DD0EolyVBpqVQ2az1cmVlMPp5fiyenf+KC6u37vGbt+
         Le8XxUObmljgWSzNdwUpOhOlokR8XX2QiQ3XEarzZ8t5U+S4eRnXGw1fSCjNc0h41yUa
         LQ/K8sNpkUne+OQaJ5dj1ghiCvk3av+cVGCTgz5xM+jHpUEuC+81WzUq05/VIZNROcl/
         z8srWKRLippiEUOoOJMMkx/keI6YWvpWNSkUAHfl7hB5JhN4I69dYixjHD7E4gLoCaK+
         LMQCy3+DE8qBhUYRKrfxGCOWO0aV0kQHFp84W+xNhsap3SMXZJzwTW97AYUlcq+XnocT
         Tv5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770613750; x=1771218550;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H9/1jawVuRkI1L+N0DjtmxsYJhIanQWdbekURSZOiDw=;
        b=jc+WZ0DhZ0BHlWNMhH4hnveX69PXyMtGsBYI9IH+EjyPt6HwEw51cN4/ipHYs/0ZbV
         Kuj5Hc9oPa3T+1LQRhnDtdj1ZOtt1kM8szCzE8t1Z2W7u7oPTJo1Ue4SSiF/oP1EizdM
         BK5QlNndiDwDNeD3OLgwdUuTbjNtcoAtETt/FoFnRiP1gUXGywbBHG8/UncJ3eDSeqcM
         etmxBoU/OjgILgD8eRBmaWY/jizAuxkVZ4F1JNlBQd+dr3TqqtN7HOObedoeITtmUUin
         lw9FiUJc8BV0j3fRYHUsUBzfrIHEkaGm85Xzm1xTr4Lj7WBmQKtlXCLYC4kckmpoOCiF
         MjhA==
X-Forwarded-Encrypted: i=1; AJvYcCWwjqrSzAjXjMh0FGDy6TbZztEjD1xM+1FzHSsp2d1nnNHbps6seA5V3g9qowCCBkV6H60=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMOvNe6NFBrjU6G+/AJabRH7ohjw6U9zmOw5XSYKySuHmdCwyw
	N/hdq4p7P8mhUpFth6BQjKqyVoKsFgW65ztd0FoZ7n1OtRmoOpAIbNbAjLP8yiNnmVw=
X-Gm-Gg: AZuq6aKty9eCSc98so2nj0ymrFGfGtD3VOoPXkwU05Nw7+xTZlq11H1jLsdmrJcBMAF
	7s1yLGfDwAlKvMxHbzZlzVIEDaqTxMnXfIhc6YZhzJqTgfIY0zdWlt9KgLliLq35fqvJoj4+273
	ZO1iiVS61Vu/5ul6lGLE8j4QKf0RyaERZj/k8NDhNOLjAz2Q4ej4DBqCq6olh+Z/dMtL/rcCBgI
	DH32QwrnMXKhKw1gZQ9XrU1O0mllleTYRjPFsCBbBASaSPxs2Et7YSnr40LiCSthFn2Xum95Ab+
	oEKancOVn5XfGelMjDDON6JsV4z81JjRSmRU9UvEtUEY7yNx4TAjYiT5CKpLr/dTBK9LSohWDro
	l9TZ7O89zsCwl9qtVzlUx01i77NvCt1S8egMxCHasNGxvzcStLfyQNuDuQZBkqWeile18hen86i
	Vid3kQ7bj/rxRAdLJSZXHo+r9c721WeKQsP+dn/f0+XUiVxNrnH1Gn5s39PFOVwJ8=
X-Received: by 2002:a05:6a00:f0d:b0:81f:31c3:2e34 with SMTP id d2e1a72fcca58-8244162fa69mr10269391b3a.25.1770613750478;
        Sun, 08 Feb 2026 21:09:10 -0800 (PST)
Received: from ?IPV6:2001:8003:e109:dd00:9c4:a3d:914:f9b? ([2001:8003:e109:dd00:9c4:a3d:914:f9b])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6dcb5e5f98sm9324749a12.17.2026.02.08.21.09.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Feb 2026 21:09:10 -0800 (PST)
Message-ID: <8f64a18c-b2ca-4665-898b-917031c53cbf@linaro.org>
Date: Mon, 9 Feb 2026 15:09:01 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/12] target/arm: move exec/helper-* plumbery to
 helper.h
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: anjo@rev.ng, Jim MacArthur <jim.macarthur@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org, qemu-arm@nongnu.org
References: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
 <20260206042150.912578-8-pierrick.bouvier@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
Content-Language: en-US
In-Reply-To: <20260206042150.912578-8-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70579-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[richard.henderson@linaro.org,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linaro.org:email,linaro.org:dkim,linaro.org:mid]
X-Rspamd-Queue-Id: BFF9510BB6D
X-Rspamd-Action: no action

On 2/6/26 14:21, Pierrick Bouvier wrote:
> Since we cleaned helper.h, we can continue further and remove
> all exec/helper-* inclusion. This way, all helpers use the same pattern,
> and helper include details are limited to those headers.
> 
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/helper.h                        | 13 ++++++++++++-
>   target/arm/tcg/{helper.h => helper-defs.h} |  0
>   target/arm/tcg/translate.h                 |  2 +-
>   target/arm/debug_helper.c                  |  4 +---
>   target/arm/helper.c                        |  5 +++--
>   target/arm/tcg/arith_helper.c              |  4 +---
>   target/arm/tcg/crypto_helper.c             |  4 +---
>   target/arm/tcg/helper-a64.c                |  2 +-
>   target/arm/tcg/hflags.c                    |  4 +---
>   target/arm/tcg/m_helper.c                  |  2 +-
>   target/arm/tcg/mte_helper.c                |  2 +-
>   target/arm/tcg/mve_helper.c                |  2 +-
>   target/arm/tcg/neon_helper.c               |  4 +---
>   target/arm/tcg/op_helper.c                 |  2 +-
>   target/arm/tcg/pauth_helper.c              |  2 +-
>   target/arm/tcg/psci.c                      |  2 +-
>   target/arm/tcg/sme_helper.c                |  2 +-
>   target/arm/tcg/sve_helper.c                |  2 +-
>   target/arm/tcg/tlb_helper.c                |  4 +---
>   target/arm/tcg/translate.c                 |  6 +-----
>   target/arm/tcg/vec_helper.c                |  2 +-
>   target/arm/tcg/vfp_helper.c                |  4 +---
>   22 files changed, 34 insertions(+), 40 deletions(-)
>   rename target/arm/tcg/{helper.h => helper-defs.h} (100%)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

