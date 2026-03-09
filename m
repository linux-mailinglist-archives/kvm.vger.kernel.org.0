Return-Path: <kvm+bounces-73348-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4KG0BdYOr2njNAIAu9opvQ
	(envelope-from <kvm+bounces-73348-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 19:17:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7281123E7BD
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 19:17:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BB30C3067058
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 18:13:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B19BD3101AD;
	Mon,  9 Mar 2026 18:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JxK5BG21"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBEC28CF6F
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 18:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773079977; cv=none; b=ex3Df8/RJxtejv7JaR7uiYhFB5LcfqJhPwlP00mFCr/spZN9n8yDASX/LNrZZHb41eEN1xnGcd3djC+whJU0E0Ua681roQhVM8CzYoiVgi2myflhVs7x1LgUP5dqy4aQsbTnI04dRsxq2rqaN12BTveFW+M57npY+URNdeo6Z5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773079977; c=relaxed/simple;
	bh=jZ8RFb1pUh/uZ/6xdeWlmKGCh3dtCwk63rEcegJXoHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EUTJxYK75VbwthmYLMV1tcm/0JYxUHRqGdT/cRDEOJEe1HbT83lownKsqGJeuSN0qJSd9BUGwxTx+XtmqwWpDIvEPMtjiwKh0LXj9QObhSvyzoVcIrIKq8LXwJxuX0Gz9Ks5AMjjwXxlCyAA5aGFIG0aSudbs1RlaFGH6Ns1Jdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JxK5BG21; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8cd847b4b23so158360285a.0
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 11:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1773079976; x=1773684776; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TSgcsDOULrbpLNw5NSsQKmQvmKzE9KsxsxkqM+QyGJM=;
        b=JxK5BG21juYW8feLi448dFQaA9dQXrK0icrVY7FSIlcamp7A7ET/eQmZgzFLqbPYej
         iUcSWAkl4yC0kqAdtCO+WZ1MT3mczlau1laNT8ixZ87iDATEBSxP2WAJUHUKTNTyaqjc
         MxSkFNSYjWzIrsDLQweJfPu4Zxe9DNd+CfwBEO/RawuJehEM9DUf4+E4NcxNhyIBdr6T
         RGGsPnMZSGjSEGIbnWOrCoZHCShNxBSU2TLbiND2D9rPXYMiZ7/YyxBLkny70cpiX5hb
         R2A+RttPS+PsgBjVlsAIhIZ1jlx876kExbdmeVe5W3rwV9ZcwmQPo1zIduDU16IEEO+6
         Mobw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773079976; x=1773684776;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TSgcsDOULrbpLNw5NSsQKmQvmKzE9KsxsxkqM+QyGJM=;
        b=C+WlKWNTzuVujhZm7TR9B1Gtgnz9oMqN81jI/jamVZ8l5PegePQPruPxwpqLoi5pHt
         GjwiSbuQFstMQqoCwwwDRvygbiuxRPsQawb7MH74V6Ig0lzzQACtE7GvX+IhdShIbpIb
         GS/W07lR6Q9gJ1tLNJAhmjeLzTbNzSSoDDIGFY29ybntgo0lx1WNWgL9vx3mbMSVzSDE
         VpZkdkBXUR7SbAMEVgEEUCTWTqhaRLIqYBW0MAWXAUCtd1+7qpOl+NzTzflZW6ciaPKh
         FjUlfCkR2vu55cYTf5gPFWtz3tSzby3M8gApqek86hr4M5LkgXwTq+H5ls1eU+uHj4zW
         BNiA==
X-Forwarded-Encrypted: i=1; AJvYcCVccflUUsA8FNnsLC/C4iDt6HgW9l0bTdDdW6Z8E2lEE+qfJS91mKvlN2MXscDG7Iemsrc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmzKp1M9XVtnkQUnxnbMXnO0+daT3KNwr4c6rri7dYQCP7gWlN
	knyWf9qUaRgSAhN0dBcaVUAHQFeNLTkyWgtEML8QIu5n6Q7JbfSQUxh9JZv8K1b56JKfNINJpe8
	baRjo
X-Gm-Gg: ATEYQzwVcL+wIQ82/T3SjL0nl9+4iRFt8of0ija7vpckvjzl3ExEocdX3az7p1dDmU7
	pMWoci35udNjLeuLUfGWRCIs5Qg42uvZBogiC/ZGLl2Io1u1g3MR32EG118quVCnYSTXB3WvuBX
	2uy1IvuKDvINl5fEiDF6mRJT/q9/AaR3MTCWWhuy1XTttCUP6dflkhFhLCia1YLLCE2SqXmt1Z2
	dEG9hGjNFIQtboaWU5Qra+AO9VCL+Avli+jmI8YVvFaAYBFRb+TtkXYu941mbQoJftMC3/UFRIu
	A06qCwq5kBK8IvvzDuBka7PTTxh2csxHBe3e96JUKIU1elUUVcgvr5q5Atz/ybHk7VpUzBUVWoB
	PXSqx+GBHpbr9KO0YouNoBnFuh9HeoKZVpspMi1L5xpkvI4laWKEg6a7xvYdQXdpk5ps2qUugQD
	SymBuNhQ8cBw5/zu6IiEEHCZZYT2tHBsSzx4cIRQ7GEbefFyVSJI1mGbH6srVPdypbhl2l
X-Received: by 2002:a05:620a:4409:b0:8cd:92e7:718a with SMTP id af79cd13be357-8cd92e7790amr160047385a.38.1773079975531;
        Mon, 09 Mar 2026 11:12:55 -0700 (PDT)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cd6f49649esm719044285a.12.2026.03.09.11.12.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 11:12:55 -0700 (PDT)
Message-ID: <1f89ed58-280b-4d09-a12a-93c4dfae8691@linaro.org>
Date: Mon, 9 Mar 2026 11:12:54 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] accel: Build stubs once
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20260309174941.67624-1-philmd@linaro.org>
 <20260309174941.67624-3-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Autocrypt: addr=pierrick.bouvier@linaro.org; keydata=
 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
 ZtfdHNZotF092MIH0IQC3poExQpV/WBYFAI=
In-Reply-To: <20260309174941.67624-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7281123E7BD
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-73348-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,linaro.org:dkim,linaro.org:email,linaro.org:mid]
X-Rspamd-Action: no action

On 3/9/26 10:49 AM, Philippe Mathieu-Daudé wrote:
> Move stubs to the global stub_ss[] source set. These files
> are now built once for all binaries, instead of one time
> per system binary.
> 
> Inspired-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
>   accel/stubs/meson.build | 21 ++++++++++-----------
>   1 file changed, 10 insertions(+), 11 deletions(-)
> 

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>

