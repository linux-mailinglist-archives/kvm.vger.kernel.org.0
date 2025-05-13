Return-Path: <kvm+bounces-46321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 222CDAB5101
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:07:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D13513A212E
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:06:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEF9723D29F;
	Tue, 13 May 2025 10:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nEUTmke8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE7324468D
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747130642; cv=none; b=oEp70JOWrZStuaq73bZNipu3InE4pf5x5TEJ/eNCG7C7QoD1uTXFTWVin9ry+tfqFS3vuEgC1RbWv8MAx1hjRzMUUQborn7i+Es2mfYlOFYXeWyD7mJeyOU7+j2dNMiOwXKs7NyGsuqv3+yyYAVqYPnSEPfUHuZ5aLQxyD4LeP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747130642; c=relaxed/simple;
	bh=KrvA2e8SNQdufOjbZjs8x2xBdupc4x9ewEutnP8pEY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g+dJ1vJoe8wIwDTSnoUhm3vJ2a0g4n22Rdbtbvh1Y4fyeCFUQ3DSfTdUYUmX0MfpisC1I3H2zyjt9eLY0A1zoIZWOMoP5/0kTgHg7ULX6KpzFFEvfgsfrMrsFPKG4SOhJNtY0aKzXeVpU3LXFbo2go0GYUfUheg57X49nnT3TEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nEUTmke8; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43cf05f0c3eso34703925e9.0
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 03:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747130638; x=1747735438; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gHNllcDu2HQZYyj8yiOKeJzlIBkFOSv3kPJp7LTifm4=;
        b=nEUTmke8L5z1Iz2O8pru9RiUV9Q6ou0KIu0ip3uyGAVQNev79IMY+9cbpFsdiru8Ad
         Clad2JKI87ag9um68VNbsZrc/UnjR1E+uKzSMh682MLFQPBTEbr7vrBD/o9Pn6FAn7HH
         LcWD196LmFKPDoT+8Ol63DVDXpY3ejAvXCfOYsiN6Hcny1lwHHZiiLC8czFElqONCHNQ
         l5N7JpOfEULUBjvcIG518JWaf2k0jvxJoQVrprGWx5I89ZIHhnKqqjU2QKrTVCF89hR9
         fSRyYmalLspIkSlS+aLLSuAd/1mzy5H+m+vrP++fXNr98L+VeMyvRaKX4fmFLBrtO1sn
         dTlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747130638; x=1747735438;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gHNllcDu2HQZYyj8yiOKeJzlIBkFOSv3kPJp7LTifm4=;
        b=QyVJKF15n5yrgl2LU3uAerWwttwQvPt6vUZLiLiHyBShCd2zHKzy1xHUAIY768qvot
         hshmTCVJsp87DNUc23Ceth9tbQcq/PU7usKKX+NUMxRuxX6xHCg3ubsEgUrquymnIsjN
         Wg1T+0do3lnlosjrxi/N70sFJs8rAIKzRDm9c1pbcCvI7Ou5YaUp44u0Y1G6Oq7ElHL1
         y16VX188jUooEgjuQr/YvWYXG8CPZIVRX4YpwyawoW3RUeBRaoOZFf66/Z1aQaq9TQT3
         6CACPjmolpdcnAiTHP2+u1e4AkaxfyW8AAxIvfyBglTQlh8b0n8PqvzqvlggjRfzoiwo
         SBIQ==
X-Gm-Message-State: AOJu0YwrybEXybPSSfvdD4S1X0pMgnuM+znBI/BNKpd+JukJCvEJBjEm
	ugNjD/nFYFZb92NqD42mHWxc4/DrtwRpdGi04EEBbLKkGOY0R36sLZ3XFYFyPeA=
X-Gm-Gg: ASbGncvUHqTTBbPcpiVw4SsHM3i3AdF5fMT3kCGAjT0b5KtDP/PAEtFLgxKwY7JicpS
	AQb2k0ju7bCAEHEK9nTrJYI0Qg0zGlNto8UnCaTm4OdWS0/X9NSnTXFxofa28gRA3KSf0a/lhIC
	EBSIM/M6QNYPTWZfEWy3MXa1wDPQFzJzBpEFoQtBwJ++y21Lkj2ctpeq3cWD1m1y4uFrFNKC28N
	Z4O1nG5Zd4LNtb5S1n//Fmoj5PPm7lIGX0u7ZmFTyKHKxlH594oQED3FKrAvYUs444KL82PYLIU
	htUKmp8ZY7YApg3I8T5rfa+JIvjBLGUAcVwEkt0cmTmulJsVGanWXwipJVvxD/1Bqr+pnFEqyRm
	aOOHMy5vsoF+kA3gM2A==
X-Google-Smtp-Source: AGHT+IEhDYq/2I/yiB012F0CpLUUrDPMqhK0hGH6CL/pJsXqNbfYqCTrgN/8H+ya9oRU8wBIk7adBw==
X-Received: by 2002:a05:600c:a00a:b0:43d:db5:7af8 with SMTP id 5b1f17b1804b1-442d6dc7cd1mr130023615e9.21.1747130638618;
        Tue, 13 May 2025 03:03:58 -0700 (PDT)
Received: from [10.61.1.197] (110.8.30.213.rev.vodafone.pt. [213.30.8.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f58ebd6asm15839035f8f.35.2025.05.13.03.03.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 03:03:58 -0700 (PDT)
Message-ID: <6e69551d-bbef-4ce0-8eb3-d488105ca7a8@linaro.org>
Date: Tue, 13 May 2025 11:03:57 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 13/48] target/arm/helper: use vaddr instead of
 target_ulong for exception_pc_alignment
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, alex.bennee@linaro.org, anjo@rev.ng,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
 <20250512180502.2395029-14-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250512180502.2395029-14-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/5/25 20:04, Pierrick Bouvier wrote:
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/helper.h            | 2 +-
>   target/arm/tcg/tlb_helper.c    | 2 +-
>   target/arm/tcg/translate-a64.c | 2 +-
>   target/arm/tcg/translate.c     | 2 +-
>   4 files changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


