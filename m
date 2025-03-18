Return-Path: <kvm+bounces-41464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FAD6A67FF6
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 23:46:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7472E4254DE
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 22:45:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4C4F207A37;
	Tue, 18 Mar 2025 22:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="n7cCbhWA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7A21E1E13
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 22:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742337947; cv=none; b=UEyxZuCCokBArBjLF2apIx/DtCqFXO/RFKBcx+w8C1i3xqSAGyjYhOrd266XOC0jtwwP7r7mbj5rzqsK2OUgvmO0rz441QS2liD6Rh4OCkuxwyzh5K7rXVyiqE9II65FgKwpPFb+zRiKgv9aHGE8M7lrgTvnivu4BxA2BsNkKKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742337947; c=relaxed/simple;
	bh=0Ritl5CvsgIQIngXso3taiq8aNQR+f1ehPS2NueXhPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bVB52jIhuMwHpG9pQrZeCalubVYDTe+5RazwrrBD8hOFpdkKzJlnYp6HT+7pUw1saAiZVscbEm7Qu050kR4vm1M/ldgHUn03e3J07ShUmYOeWoYaa2oOZ6f7m3WXIakXLPvUR3FlqhJvzFt9rWsqH7w+Ew+Ykz9ljgzjQeXnyVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=n7cCbhWA; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-225fbdfc17dso57240575ad.3
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 15:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742337945; x=1742942745; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OYj2m8wY9HvQL8f9sPwRIBivPUDXh/Fmsum2H+ZPr40=;
        b=n7cCbhWAAdyRBKAFIqepi12Ut58y5akcuzVAnNd/6RVX01/RuNSFJGScmWD6xRUVxM
         Iewkh/Ja56ytdrYN2O8WiprZ7aYNIyHaJB/R/qJ4Xp8CAYbfq+C2bjaDXPqt0ZbylWWk
         uYGmjj2zlPCvAvJ2cp7p8g+TgJFBpNw7ufGHeptqD41o63ZvcQmOoZ3NApNi2PUXMSiJ
         dflDK3dkCpd0ahz6GLdzKiSfnYw7kdsUQwPOnQJFlMqvsogUuVDAkrTRlL2azwar77Pd
         RoBfEAKFmPhbr5ZMPYieJHP0NXFih73yLLFojVdkDqNYX7fIF/Qr67z6+cNDsiJykRzu
         O9Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742337945; x=1742942745;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OYj2m8wY9HvQL8f9sPwRIBivPUDXh/Fmsum2H+ZPr40=;
        b=b8df+sT7DK67/jgOtjsukYMAnnso1tXJ0Yqfl5xbbnRBRT82ppVmg4DVr8AT3cXeQ4
         CXK/quCOUg205KC/wuQ5uMEMW8dxZnfwMJdqMhFmAX0/ZgJ8lN6Vx5f6d8afwqKj3w1C
         IY0gSZXhJ3pkPcAF47INmNOTrSuxsr0vOHPpyHZ+BxJSWqv0CXshnGMaBVJdp1nblEl7
         QQELnkQkno3f4dFJI1wKlLF985ra+Gf3hje/bjY33JH8RFmOljs5jmWPb6QUunl6B5l4
         MyBzZk90MHY/lmLZnSlDF9wD0Zgq63BJKxEEBNswB7+EhfJqTAS06+LlXY5r3GfxuPVh
         KeVg==
X-Forwarded-Encrypted: i=1; AJvYcCV8+ueGxPNdEDGmirduyKSR/YwBEQ6ADpWu6LaeNk9DDmzi7Qh+gKnEsfaw+W5MkQYHweg=@vger.kernel.org
X-Gm-Message-State: AOJu0YybG40L80ORnH0o7iDuukwMlO/nu0TVRc9pbWQa7Jg7PygdvBfZ
	VJcO7fR22UQ3AQnQzyKu5gG3kdVRPQzfYgy3B+G21c3eYoWpDtNKFGfnwUXe0R0=
X-Gm-Gg: ASbGncuy4oIXKf7GkhyB+Yk5hZCM+kExU12vbjJy+yWLE2Gqs0uBm37PZ1jTVCi/UXM
	5V4QSQnyw0hWx+U6Y7N2cukWhZBTOsXKuzvKxzcLy9K4L4d0hVoyQGgqXDFgvJC1YcLfRlx0nYg
	K7dCTrMEqaTB9RLqx8F/G/sxsBbbhSL+wc7X7+Uu4FT2ofESCDJGomoH+An5Y3I946uiQPJGSuW
	WLJdyofeqA2NoDAEQzteHViAhgp0nY9tWcCcmea0v6/msetGcnPRJTqN5ewJuPvpjiCl/hiNYJt
	qnxsesFyhP3Zq+XUrV6oZrGHUTW3Hlad+ycajX9H++3JK2YJBXCQq+4ekPpV9uuaK3OjYU1iDhc
	lAHtvGi0z
X-Google-Smtp-Source: AGHT+IH99wFLHvDNK9DJaCFMZ+buTxPrONpqtpx2Dm9CE5AsWM3wvi5vYKeaIugwzTzbLBTrpVb69Q==
X-Received: by 2002:a05:6a21:a44:b0:1f5:873b:3d32 with SMTP id adf61e73a8af0-1fbed503e74mr557864637.39.1742337944753;
        Tue, 18 Mar 2025 15:45:44 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56ea947afsm9656324a12.71.2025.03.18.15.45.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 15:45:44 -0700 (PDT)
Message-ID: <2b438e13-b377-4b4e-a4ff-0b219d7f3964@linaro.org>
Date: Tue, 18 Mar 2025 15:45:42 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/13] target/arm/cpu: define same set of registers for
 aarch32 and aarch64
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-11-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250318045125.759259-11-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/17/25 21:51, Pierrick Bouvier wrote:
> To eliminate TARGET_AARCH64, we need to make various definitions common
> between 32 and 64 bit Arm targets.
> Added registers are used only by aarch64 code, and the only impact is on
> the size of CPUARMState, and added zarray
> (ARMVectorReg zarray[ARM_MAX_VQ * 16]) member (+64KB)
> 
> It could be eventually possible to allocate this array only for aarch64
> emulation, but I'm not sure it's worth the hassle to save a few KB per
> vcpu. Running qemu-system takes already several hundreds of MB of
> (resident) memory, and qemu-user takes dozens of MB of (resident) memory
> anyway.
> 
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/cpu.h | 6 ------
>   1 file changed, 6 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

I think this could easily squash with ARM_MAX_VQ, since the
rationale is better spelled out here.


r~

