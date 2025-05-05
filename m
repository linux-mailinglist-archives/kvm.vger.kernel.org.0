Return-Path: <kvm+bounces-45463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BDA3AA9CB3
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 21:37:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B05B83BCA38
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 19:37:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A02431DE3A6;
	Mon,  5 May 2025 19:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Fwb+2Il4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2A019CC22
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 19:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746473849; cv=none; b=QlsQvbdF2ndGl6n/kc7VZfGtIkQcp5HTW4TOHPQAHWwnYbbQWy7r8Qf4N/ho3ha/2BihkWvUso/wBnXQsz8A7MN9nqneeBUBFaw/wMnij9GYyIdB3Mj/kir3xhfJWhcsUkCI24XGcthCJEabMmp53NGcH+BipSNBVNv9/+ywuhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746473849; c=relaxed/simple;
	bh=kzlUp6F3gy8Pll5sG15LgrULG3PnmRXIGWJggZ9Zf4A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g1s7iNggyWbPZa7pJwuxKbb9h2Zn00poV7XRYirLnk09KtKbvouVpNEWloNQkiFZirGMGHF0QP3JIyHasopxgEhFAmTSerCNTWLn1zQpIixLjHUMv3Pf6IStLIxnIPvYoOpsxWWEn3kWM4uXSA5Cqme1d/SvinUIKR+R7wXJB5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Fwb+2Il4; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22c3407a87aso72066995ad.3
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 12:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746473847; x=1747078647; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sUKHExp9NbjWGb75YRQTnjHWCM1CTVch8pViq7ExJHs=;
        b=Fwb+2Il49lyydoYmZtYsQcfeMmYzcRo1vBZe/u4SJHJpt3KE7EAyYN1V62vrsw/mJy
         70ArK8YxEmYO+T0OZOLzAj+g5BHjESwebVwJmczSWWIQ2MIThI/GnPF2svCJ1BFgqfEI
         QL0GD8tJTpwcVTdKhbgk877kVgfaTVl3gTawq3mpfip2Ofa6Bpe3xvC2fnTTEfQF7nS+
         GuG1Cbo7N73sxX1d9T/P6s8qlANTTZjoyyyNlG8AXGhgQVFVcnQy4+hqdjd+wUn8yzBY
         lefmehnlFvPgTwa+yBmmNh9Nd8kRxH/iqmUv0et5ctN520pVihRxWD7O+A3oSZecj0UO
         1r2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746473847; x=1747078647;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sUKHExp9NbjWGb75YRQTnjHWCM1CTVch8pViq7ExJHs=;
        b=a9UDKcRtL7hP4etky/6o3tg9XGe11bcRWPAJMgJEc66axlCZc5xnBVrCZR1jGIZEyq
         uOLhoqk2r5nCshAvCvfpz1tMuEfSOyrpXmXicdPnf0RWh3hEjWOkIkkmoD5yux6WwY6f
         Uqd1jkvvmc8NcgFUHLXY6+7dUZl+vxOA8Pm8hyUmWKGkvAK3Ar/f7tG5gJLU879yDxXf
         ybdHsyDftHafHiHI4PyhDkLZGT1MQ4gc4VdxN5lrnoN3Xd+cOAnxOdfIhX0KdC6whhgg
         KCr1fQbTtrJ151vXGEFEc9EqTnLW9Mr1qLzxMtKvCFOxmC80ahm+XWIMB5kIMa2teLMO
         KZ/A==
X-Forwarded-Encrypted: i=1; AJvYcCXqWjoAyBhILC5cVZaci5EPZquGVu61BUixK5WTNOo61jHvw6JIRU37aSS4hJtrLcg2jwQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJYC9SXTanrfr17Og6TuHvq/JloQ6veE4SgQmfzUQiRS7Pp9kN
	BZxfnAW82ngGIB3gmL/QO33GURBtR27haKE6gIK4WoFbVu6YGU0LGIOfaAUmj/Y=
X-Gm-Gg: ASbGnctH9EW2kY0tfnMG/TMIGvvTELIpheUiVflVN/2QDybBxz+lDDhGyveLdYY7FUM
	x19tFQnAuJEC0wNw1k8PU5/JZ1hjEK4CVqz3YXSpRp0l7WEiBBWE2zDB73tqwZQDAJ/yUD9FnV4
	Drt48V2bikB5CC0owxITwcXtnM4+ljVf4ZwVlBsqLwrEeD6dh2sLZEoDzPzegeXL7GmbpalVUdJ
	gvE045UOMHWKfT8JRgTMgOxTA3hmiuW/SfGuTqUMU8IqjXA6vSXhlHp7NIW29ijzRf5XgEEEKCh
	EJE/w6QcLFw0mq3cglxHVtnHQOdTlIAzdsqJdeRIULRq9dQG0z+JMnV2eONRCS4XFTaUOSboRvS
	GQ6ELazWEpITkBGC5gA==
X-Google-Smtp-Source: AGHT+IFHLGCTkJAIaTz0cBKQi5KISLaAoM4Rjvto0c/ddqPAd97jaswHhD+/NkXo6Xt1EUBJR2FFEA==
X-Received: by 2002:a17:903:41c4:b0:223:52fc:a15a with SMTP id d9443c01a7336-22e1eaab925mr125088655ad.33.1746473847458;
        Mon, 05 May 2025 12:37:27 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590a136esm7258019b3a.167.2025.05.05.12.37.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 12:37:26 -0700 (PDT)
Message-ID: <bd48b05e-34cf-442b-a645-e955d82e6732@linaro.org>
Date: Mon, 5 May 2025 12:37:25 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 47/48] target/arm/tcg/arith_helper: compile file twice
 (system, user)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-48-pierrick.bouvier@linaro.org>
 <e8eee40f-3785-4816-b96a-af022b3031b1@linaro.org>
 <85513f8e-232c-4d66-ad03-15c4f697dbae@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <85513f8e-232c-4d66-ad03-15c4f697dbae@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/5/25 12:33, Pierrick Bouvier wrote:
> On 5/5/25 11:54 AM, Richard Henderson wrote:
>> On 5/4/25 18:52, Pierrick Bouvier wrote:
>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>> ---
>>>    target/arm/tcg/arith_helper.c | 4 +++-
>>>    target/arm/tcg/meson.build    | 3 ++-
>>>    2 files changed, 5 insertions(+), 2 deletions(-)
>>
>> This one doesn't use CPUARMState, so we can probably drop the cpu.h include, and thus
>> always build once.
>>
> 
> Done.

Thanks.  Preemptive

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~


