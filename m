Return-Path: <kvm+bounces-70574-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id s9DiDetmiWm68QQAu9opvQ
	(envelope-from <kvm+bounces-70574-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 05:47:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F94410B9A1
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 05:47:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1D1C43007E33
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 04:47:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0C0B257448;
	Mon,  9 Feb 2026 04:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HcthcDr6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFC61E4AF
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 04:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770612449; cv=none; b=VwjsqZCDRP3nJ4FYbaiBLwEDkoNcottzXn88aZuLtIV1ZxPJ8etGDO+qm9XNoABuXYmh9AupnegJBxuN2iNwW94R7OrJtVRt3OFWs7IJ9gCHsjFZO+zUloIDRU7J+u/P845vqhCw1NO1yNHxMlXLDPTGYtj92htqA6EgJMWKXJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770612449; c=relaxed/simple;
	bh=hrSkF2XvQv3Vtl0V1HXRTgr77VkYQrytRTuaOiH9HHQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UpS6LHQMGWTrwugn/b8NSe4sYumc8h6oP98C+uJi57J42GAMxGotoR4Wxv3H6Di7iQt1D67Js1ueQ4nRidNdoQ+qw6sP7JikB0emsFEZ8xTRtBo2hO55wCgOMvkQfajyjyZT1w6C90zRG/ACezLoVZPZNX01Fgj+/BsqUeSWiaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HcthcDr6; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3562e858da5so403833a91.2
        for <kvm@vger.kernel.org>; Sun, 08 Feb 2026 20:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770612448; x=1771217248; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NHLA6Hqg45QzbYXkoElyh3EI5vF5e2eXE1LTa/vpB0A=;
        b=HcthcDr6yfdTbusHxb4UzCdMH0IPI5DQOkgni1Ltgex7klVq+NqJfJbD3tZ1k5V1tL
         DkBMsuZ9m1Z3LBWlQ2INKFCEiFDsWOuGTBLSleEsQJLpHYDfPKgtm0+z6+1N+sCpmQnL
         StBR/wai5irkWscDSSS+rE/Zw4qd8EZ7LIEnbgeFsMfgyw6gk2vFAWFBP9e/83AhKXNI
         XsQQEn8HzIfVFNI/JqKxbBQmYjLhD+s5n4grNxAHrcPDm7S6lKE9nmvzcSmM/XCuDvpZ
         GsDDiRh9bZ7Bhy3+TdSRnMgCTpOk1z2PYcbbfxyN9moN7YU+8fafbikj+RRXs7oAvU/J
         iYeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770612448; x=1771217248;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NHLA6Hqg45QzbYXkoElyh3EI5vF5e2eXE1LTa/vpB0A=;
        b=hA2DR7R8rK+lCP7hM1yChnXkOxPUZXdwqqIc+ah7uNXRNa+Q5ND4dikPM7GJCZGdHv
         po3glxjjoIs9yw6iS7IL/0FyB1mUGFpflFCRA7yCCbyly+E9VtGknoivP1fTdgTOzs41
         m+jwcPwTkxf10cm8zIofqCEfx6/eKIwwuoMPYuNztot+5fSY5BSQo64cBtDQaVbU/GIS
         0Vw1HSB6lW0tcuCEzVbIOYeLZgfrtA/LkNmxrtT34yMIvPGknS/tMT59T73b4CM39MUt
         xBb2EUiFDbsuQc2LkeEq6Wh1fZ1pXb2EQFDAkm2JD9DitVtnw/+AWEwoiYcWSUWdVW7P
         EHLg==
X-Forwarded-Encrypted: i=1; AJvYcCXZh5bT19BzzNmT8MR6H7sPZP13mvcS5HTCzSYI0TMQQGxnZdg4rG8Xt2Oqg1WhU8HSRgc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiBOB6QbGnjn/Ma7GFxuERaD0zPeTDVmbtdUe8Kv5mZ0HFFHFp
	m7uLeXBV7UO+pIKwkVpjodcK+KdXF2XMSfRBDO7oXisGPJRUNy2W+g/aMjtQ8n/cAgw=
X-Gm-Gg: AZuq6aKHCVfoUPjdSq3I8/d8zNnggYT1NMJ1YSKJ0pwJEcQJwiWwjg8dN5Cy61tsigW
	HjiD6VDynxnk92UjSWvzGihInbRy2U5PNAKhLEBV6sUCDXfC47/O2+TPjQi97jBw2ajAg2DbnFm
	dLZ1Iuq52I2gRGCNbhnFrETzWDHNddZYNV+8vrp1J6HwUgEozu+iX0SdSC/x+CsJpV+A/2cCy/l
	wfOtAi2g8XFCg/axwWAZUCCmPWsaCGy5NqnUOxOVIKo7ij4fEpRROZ9xD7xCma/vNSqTz6Dwdvu
	U/Y+gvosKyzNs0jev9fhc5cfZMzMYJ1D3sDuaAo2NSUWgFcuCydnSRxyfG8PYme6265BFp2J4oy
	MDPeuGQrJDD2oyecelkCSoYRR7JZzVt+IG6i/KLsXlEwjoZnHRbK5SYtEaI7/Dc6F+L6aVrYZBE
	RBsYLlD5GRPOb6AOAbQ0N39ZEdtKc/E5QzLxL7z3uPe+/jWxNqYARX04cNHGgwf2Uw2lxVz+PHQ
	A==
X-Received: by 2002:a17:90b:3a4b:b0:32e:528c:60ee with SMTP id 98e67ed59e1d1-354b3e2ee5fmr8093143a91.24.1770612448322;
        Sun, 08 Feb 2026 20:47:28 -0800 (PST)
Received: from ?IPV6:2001:8003:e109:dd00:9c4:a3d:914:f9b? ([2001:8003:e109:dd00:9c4:a3d:914:f9b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-354b1f49186sm8805732a91.5.2026.02.08.20.47.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Feb 2026 20:47:27 -0800 (PST)
Message-ID: <41c8406a-235d-4ec4-bee1-2a798f12f433@linaro.org>
Date: Mon, 9 Feb 2026 14:47:20 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/12] target/arm: extract helper-mve.h from helper.h
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: anjo@rev.ng, Jim MacArthur <jim.macarthur@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org, qemu-arm@nongnu.org
References: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
 <20260206042150.912578-3-pierrick.bouvier@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
Content-Language: en-US
In-Reply-To: <20260206042150.912578-3-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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
	TAGGED_FROM(0.00)[bounces-70574-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[richard.henderson@linaro.org,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7F94410B9A1
X-Rspamd-Action: no action

On 2/6/26 14:21, Pierrick Bouvier wrote:
> A few points to mention:
> - We mix helper prototypes and gen_helper definitions in a single header
> for convenience and to avoid headers boilerplate.
> - We rename existing tcg/helper-mve.h to helper-mve-defs.h to avoid
> conflict when including helper-mve.h.
> - We move mve helper_info definitions to tcg/mve_helper.c
> 
> We'll repeat the same for other helpers.
> This allow to get rid of TARGET_AARCH64 in target/arm/helper.h.
> 
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/helper-mve.h                            | 14 ++++++++++++++
>   target/arm/helper.h                                |  2 --
>   target/arm/tcg/{helper-mve.h => helper-mve-defs.h} |  0
>   target/arm/tcg/mve_helper.c                        |  4 ++++
>   target/arm/tcg/translate-mve.c                     |  1 +
>   target/arm/tcg/translate.c                         |  1 +
>   6 files changed, 20 insertions(+), 2 deletions(-)
>   create mode 100644 target/arm/helper-mve.h
>   rename target/arm/tcg/{helper-mve.h => helper-mve-defs.h} (100%)

  Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

