Return-Path: <kvm+bounces-51475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7026AF71BD
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:10:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 182B856103C
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:07:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38F132E2EFD;
	Thu,  3 Jul 2025 11:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ypKv4c1s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF22A246798
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540810; cv=none; b=lEE+CVXVpOW3A/C9x3+BU72fkz5RfUOqE/EaSY8yI45myVz7qClNLxi8zkZCNLOEQ00VZs/ybcYCAMNTA0ABM0cpXq1uhnVPPyL6r2t7VlQfRe1h4X/FttmgbiVjBpqCdwimPwvC5CMlh9Yo3MPXSx5Wm71vKEhEkzvFAJCrtGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540810; c=relaxed/simple;
	bh=j0xn+hMMzuwzIxDYA8R3Julms3gcOCroj61y1cJcCno=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mnaGDEX5ZwAZKxH5ZUETr2zebN4IPVZD+GtySyiqpLrCoi19VfonPJtTJUTW+OLOfse6ovbaa5GQgqkYexqWFS47KLh2jOOS83P1Qx1rVY+x/cvf9IIVm1RTv22Ptjm8Mpsivtde39v8gPiQqLebSuezG/i3h4txAKly8dG04Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ypKv4c1s; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-450ce671a08so36108455e9.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540807; x=1752145607; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SY3bbRxwwhqkW5iC4r3Kz/+8BMlWUXcP8I5mFKx4az8=;
        b=ypKv4c1snUHD4IyuwNtoCAYBy6csq5ADdnRsNH4THF9KejomR3taOrbpuAUPM+rBDT
         oAoTCTUCpNybLavzvNYFxR9vUd1iSnkFqb8Goo/P90dHY7Z6QKFsW7F3YYyr0yO89XI6
         ZliuZSHLzLnCfRdEFQ0g3L/LVBKPAD3zpxEKwfiz4o/TN4rZmO8aS5V+Ki2uaUXrUS5F
         IP2ScGcCmY9XEaJL9B6RUf7SGcgiWPK87HUhy1egzzdGhu8gK19Tst+FafB7dOh+4tI2
         WG/uO/8oqmCOjv3SxRcGNV1zERzVUhtwLJCgNCM3InPW9xJ3mUebw+FeQuBVATbDLJ7P
         wg5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540807; x=1752145607;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SY3bbRxwwhqkW5iC4r3Kz/+8BMlWUXcP8I5mFKx4az8=;
        b=slzD7d0yZwcEdy2kIeTYzWFc/H1Gukz4RFGK9qi3j4Cucnx3y8Riumae0p1zQZL/Ku
         DDpopwwjkqc+9+thWhg5CujcXlvI7Gf/44XagcuNER+r3DmJbptMYyiAYGm8Mzm45tTG
         IcKeHz08HDifcSmO4iHH2qmPnnSbieM+fheYUzNYwlbNPTNU/N77Z7D7SDxhWOLveHhi
         pPWK23oLYaa/BK+gAVOp+oMFlp8Jb/ugok0og1WTWSJlKuXOTpxB4fQ9odtbhtFL7sJG
         Xp7FmQ63t0gKW8GVSqvG5WuqnbdvXlMNpH/tvN7r7IWtIIg1bpCDldP4ut/kI9XVv1Pa
         DS7g==
X-Forwarded-Encrypted: i=1; AJvYcCXBslPpP66M0CHeXKZdMLer8rKgIvIzWdWRTBWaecOTlORFACLc0uD2afSnrpFp6cHd1VU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4nCPY2wg+nyrm+fMaMpwkti/V3Y4SCsvnGEjtPbIh+JHQDvcY
	CGtCXDBsUBO/Q/gUh8EJMC5jlKK8k6us+O7HqKEd3isKnIBsaARc0uRnopG6XP7StkY=
X-Gm-Gg: ASbGncs5ZxLQo/4e7TaBmZIt9pzr9DcLg6mQ/e/YfM5qGzMgKnY7iU0cLKf1TPOdpTL
	owVN974tpiY/r6/7iSiuAU5uqhegJDBKoAPlFx3941IZ+SpsPsGunwYHPZbzL+PpiHR/uXRwlM8
	dZ3PH9w/hsmDMG49cjL+Sas3UZPEnYrtHSJiTsGX3A2AGi7IKZbvWjTMWSaOYV+6vDqR2099pta
	Xa+kM6ZveIusy1iydKKCZOOT/XnoUz1SOOWjH32+Mbn2X+fyHtwSzjSxzAtfoOD0c/pPDvlor64
	stRS53aPgKsRmKqieIiBJG9v66r6A51WFBlqJROINsAGl5A+JQ5SgU1xnOsyDYsoK+JC6bSOvDV
	U
X-Google-Smtp-Source: AGHT+IHjgZAPP08KCJfBUi9HGXkOD5sakqCz6orLObgGHxB3KaUuSEYVzqSR4uUZvniC5txn6nd8BQ==
X-Received: by 2002:a05:600c:3504:b0:442:f4a3:8c5c with SMTP id 5b1f17b1804b1-454a36e483bmr72402135e9.10.1751540806936;
        Thu, 03 Jul 2025 04:06:46 -0700 (PDT)
Received: from [10.79.43.25] ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a99a35f9sm23533485e9.27.2025.07.03.04.06.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 04:06:46 -0700 (PDT)
Message-ID: <deacf2fe-a84f-44aa-a612-7985ea9339ba@linaro.org>
Date: Thu, 3 Jul 2025 13:06:45 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/69] accel: Preparatory cleanups for split-accel
To: qemu-devel@nongnu.org, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>, kvm@vger.kernel.org,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/7/25 12:54, Philippe Mathieu-Daudé wrote:
> Missing review: 23-24, 27

> Few changes needed before being able to add the
> split acceleration:
> 
> - few method docstring added
> - remove pointless stubs
> - propagate soon required AccelState argument
> - try to reduce current_accel() uses
> - move declarations AccelClass <-> AccelOpsClass
> - display model name in 'info cpus'
> - add 'info accel' command to QMP/HMP
> - make accel_create_vcpu_thread() more generic
> - introduce hwaccel_enabled()
> 
> I plan to send a PR once fully reviewed (v5 likely final, 69 is a good number).
> 
> Regards,
> 
> Phil.

Series also pushed as the following tag:
https://gitlab.com/philmd/qemu/-/tags/20250703105540.67664-1-philmd@linaro.org

