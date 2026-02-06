Return-Path: <kvm+bounces-70422-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qKblDLuYhWmUDwQAu9opvQ
	(envelope-from <kvm+bounces-70422-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 08:31:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A170FFAFEB
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 08:31:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B20A0304567F
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 07:27:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A56432FA10;
	Fri,  6 Feb 2026 07:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WD0aV9S0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41CE30BF77
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 07:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770362824; cv=none; b=fR0VZb9+jhPzvKoHzR/38sKLFnB65v9PkIMjkKyYEE/3Ehl2u3cJakfqOUj/l/4YT9eZFIWZOD+71YYID9sZQlShKCDdeyPVRxjRfzFE62vV0euVTxY5ybE1E/uu5WwYx9OWoGq76DvaqGhfaQn4m0OEfebgE0xc4kQVMAsF87I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770362824; c=relaxed/simple;
	bh=oCFhrZuxKrtd/A7foSyYpAmuPvnq4d4c84xdXM7gRYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UNsZ6qk0Gv+4AIl0q85eoSea9rjtW/BscAQ41Taj8Yw9R5SYGURyGC2i56gZNfm24l6wQprOBDveIi/ci39MzzBcpmbFRaggkM95O6aOO3fI5CpdjaZwxX9KCW+GM+d0hSg6i58kENhrMUu73i3NxAA/RZwXsl7fRWCS4C/hM2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WD0aV9S0; arc=none smtp.client-ip=209.85.210.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-81f4ba336b4so1503723b3a.1
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 23:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770362824; x=1770967624; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Esn80IcBye1lZWW7gqCmY3N+KkEqhxRG4dc5qwdW4Hc=;
        b=WD0aV9S0tNkMR+Yr5Kmga2SPdHsrCAuS6LbLRq0xSaUX+nwvj1t6gmKtXxUlolvInV
         FtHdB2MrywmbFlqB3/S8YMR973H5daYApuraJ72xQFUB/D7r+S9pR21BaVXQOX0Qy/kF
         6BdCQrnoTo5XlZOdnsSOV2CjIxy24qrrg22/yA0c/ZmwXhtmHJiLJjr+suYLJK0sI0KC
         YizbWDJAIk6JXBd5SQ/T64M3IsiMJW4ngMWLKj/WI6bzOGChRIdtTgbi2nm1lJ+/vacX
         05Z8Qhv3hORVLDW77h/26GITJ6gq2Gae+K+Sw9rax+cDhOZWVv8VK9uxl7Ff64s7ncVU
         TSow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770362824; x=1770967624;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Esn80IcBye1lZWW7gqCmY3N+KkEqhxRG4dc5qwdW4Hc=;
        b=bLhORc4bg7uRqocTnxsDx5MbpeOHIGhdqlwIRQptSPVx98pujVIR1S6DzT7vJta7Pd
         b3vOtUo0ZdMADY532nsFMF8Cy2QlcoFS4ga/PAdM6gGRyNTGBpIYaYSu/HEjH3eJhJMv
         +lk5J5ntSlLhIr1hxuAIJwrVQhqBHL9MZim6F/XLcYPCepfUp5I7LAhZxmL4EBnkBoZH
         2KuJJMgMB8RZwEB5OiCeQc+WM/VXX1sU/j7jJx4clZ0s4uUmIt6vmt/Coa+SkLZId401
         eiXdeAXGl7w7rlmyEycjMFbshwkOwYzOpuwFAqf3zJHoeLFBHTIEKJcZaHuFQ4qKryi8
         brOg==
X-Forwarded-Encrypted: i=1; AJvYcCVSKxwlDYEhv//Sn6JYbrLcY2stLcwyF7F2DzClmbrUFBCw9NaeU95KnaULzjcnU0JumC8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIYJ6WHiSA20iaRl62JGGYxAAqxVRK7c19EyEEjjKTTLmdZ71e
	rzyQrYFGydlms1OpnaXbTq7vTLeuVWaN232bWN9fdwstbr/XgLyFFEkWoQVY9hYKpZI=
X-Gm-Gg: AZuq6aJ+mExYcdbK67kL1Jah9ff84D1FTIMUAy98+8jB2QeVZBjug5v7uW4KRxotrvc
	J64oB6iLdevvDM0F6c0tHQ4n6dbDug3OJVgBwHAihL2AgmzutFJjJlpoaqL3w88WZ/AJXg3vbiH
	jRY0bAIlmCpz6Shb9/ooqRpOE2tSDuEgouFQ2tPic8Ni+JSndbXlaAUJMbwoQ3MMevzGHDzYkWS
	czcDIF2EbdhyVAhGkB4i3eVa+N3L89Oae57ZS6BxRSYyAg4dOJhApO/M8baZVxR6SXF6Kzc0tnO
	DUnPHh+Bc1MmXZJvE3FakuuTHmC3ZMmZ1h9Y54TRd4S/va1UQVWqnhTdOunkxOr/l9JldGwd6gd
	uBvu6L3ORrsm69G/ILYh/4rOoQ0PeKPpT9YsJxnSWXpahoFkX4BHykTtgUyWd+NQNPGt55aQs1C
	VUMP/vHvesBmcebP10xK6I0VoO2Yf7OiqHJocDel522q9qmOINhXlhxIWe
X-Received: by 2002:a05:6a00:1253:b0:81f:997e:59a0 with SMTP id d2e1a72fcca58-8244176e218mr1649354b3a.64.1770362824013;
        Thu, 05 Feb 2026 23:27:04 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82441882481sm1339129b3a.35.2026.02.05.23.27.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Feb 2026 23:27:03 -0800 (PST)
Message-ID: <934c333d-c081-46d0-9058-cc7eda075d1b@linaro.org>
Date: Thu, 5 Feb 2026 23:27:03 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/12] target/arm/tcg/translate.h: replace target_long
 with int64_t
Content-Language: en-US
To: qemu-devel@nongnu.org
Cc: anjo@rev.ng, Richard Henderson <richard.henderson@linaro.org>,
 Jim MacArthur <jim.macarthur@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org, qemu-arm@nongnu.org
References: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
 <20260206042150.912578-13-pierrick.bouvier@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Autocrypt: addr=pierrick.bouvier@linaro.org; keydata=
 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
 ZtfdHNZotF092MIH0IQC3poExQpV/WBYFAI=
In-Reply-To: <20260206042150.912578-13-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70422-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:email,linaro.org:dkim,linaro.org:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A170FFAFEB
X-Rspamd-Action: no action

On 2/5/26 8:21 PM, Pierrick Bouvier wrote:
> target_long is used to represent a pc diff. Checked all call sites to
> make sure we were already passing signed values, so extending works as
> expected.
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/tcg/translate-a32.h |  2 +-
>   target/arm/tcg/translate.h     | 12 ++++++------
>   target/arm/tcg/translate.c     | 18 +++++++++---------
>   3 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/target/arm/tcg/translate-a32.h b/target/arm/tcg/translate-a32.h
> index 0b1fa57965c..a8df364171b 100644
> --- a/target/arm/tcg/translate-a32.h
> +++ b/target/arm/tcg/translate-a32.h
> @@ -40,7 +40,7 @@ void write_neon_element64(TCGv_i64 src, int reg, int ele, MemOp memop);
>   TCGv_i32 add_reg_for_lit(DisasContext *s, int reg, int ofs);
>   void gen_set_cpsr(TCGv_i32 var, uint32_t mask);
>   void gen_set_condexec(DisasContext *s);
> -void gen_update_pc(DisasContext *s, target_long diff);
> +void gen_update_pc(DisasContext *s, int64_t diff);
>   void gen_lookup_tb(DisasContext *s);
>   long vfp_reg_offset(bool dp, unsigned reg);
>   long neon_full_reg_offset(unsigned reg);
> diff --git a/target/arm/tcg/translate.h b/target/arm/tcg/translate.h
> index 2c8358dd7fa..1f455e4c434 100644
> --- a/target/arm/tcg/translate.h
> +++ b/target/arm/tcg/translate.h
> @@ -27,8 +27,8 @@ typedef struct DisasLabel {
>   typedef struct DisasDelayException {
>       struct DisasDelayException *next;
>       TCGLabel *lab;
> -    target_long pc_curr;
> -    target_long pc_save;
> +    int64_t pc_curr;
> +    int64_t pc_save;

An amend mistake changed my branch, so this commit was not updated 
correctly when sending the series. It has vaddr has requested on v1.

I'll update for v3.

Regards,
Pierrick

