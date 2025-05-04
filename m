Return-Path: <kvm+bounces-45335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38222AA876D
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 17:52:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92C663B4531
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 15:51:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B35D1D79A5;
	Sun,  4 May 2025 15:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S7DErkwm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDDF1FAA
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 15:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746373928; cv=none; b=CTKhEjXsH8wfXluJTMrB5d/gk1it+IR7VfDXvUBd31mdDxwmvG7IXN/gbR2Tpg6ofgykDjLEioLKlcCz7x2QVmm8L/PwwdLBpNxzaA9wznFLf5/SPIw3lMm72z0Z7QStYeShzvFEpx2zfMJmzu27f172vPu0eN0OqvqYzZ8M/b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746373928; c=relaxed/simple;
	bh=NyQPP4WDXqeaEGRZ8aMEXjUCeupY+egWw6WVEiNVpmc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hteFWANQBKxFpqJbQkM9JeIF+677Ksn5heXjvsNGDlwVEVnYPLGz0xe5Kz4WDPtW4Jsf4BeLY9fWT+izVpwF9P2tF+V27o5XOasShMG7RmeNiPKdJzACNXqOQZDKp9JWsPVp7sve11G8niApmDgxmkw4jA/C7v1jc6beiL5RyJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=S7DErkwm; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7376dd56eccso4112290b3a.0
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 08:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746373926; x=1746978726; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FzJ7KBiUM62Kou2rvlVI27PREsZpJnLCrsZBTZ6Q1cs=;
        b=S7DErkwmnfM/i8cL8OoiSKVpc9VARHL/sGAnD1xj8TRxv7XXveGzdv1sixkuVwhck2
         2HBNW3jVShD7AoER8E3Tch5eQh6lrfLrp8eKI9KTqOTskmllxEh6fOP7cTbwGEMQmS++
         MFrn+79+Ze3g/v8b0WtjWC425lUg1ZBRNJpy1QR9Eln15w5Vg15Vrp67hKNVPebZDUDG
         rgwzXXbzxd0AMlbaifoGA/5C90Ks+ULbzdyvTI+f4XxIev2rbKCIYLmKnJeXi0xNjfWQ
         cPqc6QtWm0D7Sgwgtlosy7B/zI+oFUb+wyV6VEs+WLmAaCCs5q8yZuRG3IQ2omR4NvNH
         N5cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746373926; x=1746978726;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FzJ7KBiUM62Kou2rvlVI27PREsZpJnLCrsZBTZ6Q1cs=;
        b=uukkLcFLUD1vQytwRM4w1JF0y52nXmBuHiNroKZe+LqI+y/m9rwr+NXDEd5G+iqTvv
         Y4agecfccRvKORq0ruK/pbFzUsu8ok/psqQ/gS7uSefzxJUE3JmQC3sfhN9J0Mb0HGY+
         E63TOfmWi32HebH91h1LY91V8iSR/UXn89iFyjJjTD+OW9DYoIJJIH0xQpSmmkqA1Ycm
         vrO8DHDr98b0gYLlNWdwjzofYr6uT57FTo/5h6iD37DmYYfPj4SMmtbf1gFxop5m8Ur9
         yfxkOk/4QhBYv+luTGr3Weihmry68nU53HzjIYU7EW6+9mZ3Gz2Dnillo6ouYRZgc8sm
         HZeg==
X-Forwarded-Encrypted: i=1; AJvYcCUkELPjgU6jPnhFMjAstocgTXIm0q4FfyJNWOnnK5G7U1JrzL17hoYydlAe+WFkqIRnT4Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7TnLstSq1XWTL4rfWNS//ZUp0/fzs3qMDo2UEtTQDl/FuHqZ2
	zcms1/54Fa9Cj0yuy2L6GBUPqJwjZYn1FIdi0fHXKWX/fFKhAIcJB4CS3rfRUnc=
X-Gm-Gg: ASbGncuj+hcR2Zm6l9ENEqfI5kizF2xhotjxRdYJdAr/1hOnx4WAIfPXfp0YEo/Mwin
	vNmTs3aakdmfKIy/+UV72gWB1lsjukX8CIUxltfP9iT6gH61myXWithe8kNlKsXseuz93sh2xk1
	oIRSLrQzRlBCeuY/zmH2PDX8LG8erfmCUsAd6KnxHsGNy+0g4z5CFGfwnNq6CVFA6FyOZ9GonDz
	hP1jYctg8a052Hw6II1ruQwz40HT9VSrREUuST1r7CkOt8bQURCdk8DOlzFr5mJ73CssoCYnqMe
	BseVmQRcogNtHjyAOS+cOFRJbDx+PUvR6Ni05IvvkQhyOaX2j/t49Og8aCwswe366CscdNR8Bse
	WIm2IJJg=
X-Google-Smtp-Source: AGHT+IFVnnGElWZWktJSHhHrK1YBadBJiOCAhPHj3KmwBboK7qXHH78eZTQ8uPZhXv/BS1Ff8Cq9qA==
X-Received: by 2002:a05:6a00:1c9d:b0:736:a8db:93b4 with SMTP id d2e1a72fcca58-7406f092fe6mr6000996b3a.2.1746373926019;
        Sun, 04 May 2025 08:52:06 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74059020dd4sm5003693b3a.117.2025.05.04.08.52.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 May 2025 08:52:05 -0700 (PDT)
Message-ID: <866305e9-1751-4264-a984-7379bce6358d@linaro.org>
Date: Sun, 4 May 2025 08:52:03 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 30/33] target/arm/ptw: remove TARGET_AARCH64 from
 arm_casq_ptw
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-31-pierrick.bouvier@linaro.org>
 <a6fdb501-438e-4591-b166-87c8dbd14887@linaro.org>
 <3ba2f0d8-ce65-48a5-a662-f2350903a5c6@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <3ba2f0d8-ce65-48a5-a662-f2350903a5c6@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/3/25 15:48, Pierrick Bouvier wrote:
> On 5/1/25 9:24 AM, Richard Henderson wrote:
>> Are we still able to build qemu-system-arm on a 32-bit host with these changes?  It may be
>> tricky to check, because the two easiest 32-bit hosts (i686, armv7) also happen to have a
>> 64-bit cmpxchg.  I think "make docker-test-build@debian-mipsel-cross" will be the right 
>> test.
> 
> By the way, I'm usually using debian-s390x-cross for testing a HOST_BIG_ENDIAN build. Is 
> that the best choice available?

Yes.

r~

