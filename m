Return-Path: <kvm+bounces-45292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A934AA8344
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 00:48:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAF7F17D83C
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 22:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79E1C1C75E2;
	Sat,  3 May 2025 22:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ymlYWyzY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046B7EEA9
	for <kvm@vger.kernel.org>; Sat,  3 May 2025 22:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746312511; cv=none; b=ih+LuERp0kqVx58OFN/rGDJEtGxY2N6sYh5kF524ZCtdwkkVRcwRX1ZFMXnfGXCbbatirIlhE3gW/N8vvJOr7tqMstuipAss2aus085+bV9c5Id13U/uUnWIXVTDBUsR1+pH2TDPWPHy911uLscQY2c16wqn2iqvs9FgSjSbR18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746312511; c=relaxed/simple;
	bh=fzk3IZQ/VfA4kRZvEkIG7LE+tqyC04GJggPTThX/QZ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K1IUmfFZm0fn15t1d7l97slFgPn2jZbtlt5iwI6kBKGGiCpF24qzSEOdbEfJmJE9fdLgIMl+z8uLURIsy5jBVm5ehP0S34rbSs5SL7SRYgZSL8N4feWZ5RPk4RGSx0o77wvdDZKxrnCct9ReWScW0iS5bNy6xZ3NNqsx2Z5XJZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ymlYWyzY; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-736bfa487c3so2978657b3a.1
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 15:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746312509; x=1746917309; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nVS+KycHkuPP8W6uz8n8fLyf7XH6tEMps1l1FLxvTZI=;
        b=ymlYWyzYUAqGJZg5oxoPTZblYDo977nLdxAP9SXe0zWJq+dbFjFHw/f/U5D0f4kwPL
         FTgSaEvr1avFUgqEget0Wzcif0B46caHboQjOy3EDwNE/Dxgdr+HX3AiweEPpZpQitn2
         aOXhE638LsYwMdVWfHlrE60GnfrfcCDhddXZqSy+CwjYFX6gF7enAsUxHmU+Yk8zFU8q
         4dEmaAdCaZcmcUHUjUXrb+h3HAR38FMvJ0jOExlDrJ0uq84DOntbkntlomcLNFJt6EmP
         DOH0JREjXTVcNKKrvC+iPDCU3f9Daxc4oIFAVYEQfs0cRMZZeRCszc6KVs4CGs8zueD4
         K1jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746312509; x=1746917309;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nVS+KycHkuPP8W6uz8n8fLyf7XH6tEMps1l1FLxvTZI=;
        b=oGukNAxkBl89YaEWUcSJe8plkkTLQkOTsE1rIQVqPOoX+gd6IHDZHmkv8TtdL7/BRq
         cExNTIm8IXwHMX+5xtbKpSOku5gLRJhDwld2g48BElQvQX/uqDlinZLAL0JYObFQtrKE
         XC4J9NCsbzEZQ95k6AAWttEPqRP+NUs55MiAcuXhnon17yWZ5J5TZp7ZRbNzYNCE1+1Q
         hgl/GeBuxcR98MlNBa88rvU4aUsJ4UfD1Q1hmPeraanLNog4xbAHAp+cKaZZX0BFpDB6
         i2SJ0lcrj32+sZCIRjqNSRH9tfdx65b9wu9kXzpnwoq4IggQi8hwc1+RSqPR6+9t3+nq
         gBXg==
X-Forwarded-Encrypted: i=1; AJvYcCU5O+v95HnDnSYCH7qwPAIGJbsppHwdychK0I6Od3k1+GaJky/D3pw8u0YN75O/4u8BwEI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOPTd/w/Oa09WX0mqE6g1EgTZunN8kmjsXBklgdvpsYyhNttq/
	J+jJJ+zNMMNC/ULJ5q0PJA2LH8CNya6MX3m4QmcAZ1jWJxBP5exQE/MgQS2WAVA=
X-Gm-Gg: ASbGncsOx4JVvCCUVsYkM3Iy40ieb28C5sYE11vpQNJTRoO/FSBTp2ikcAvLkbVY2MB
	0X6wHoUHoc7hPtF5409q06sa2coLypCWRji5fwOgu4mXh9pJn/Gclnpn1nx2+UnkbDZwwHYrg9i
	M92nhHc18lObZX3Oh2eol1hriYZieRiOU6r1kXsMbWZSSq6LouJ178zotTWk4bRBzAwIbOX2Gxf
	lNu+ijx/ghWrPt8S1AGS8HWzHjBzyk4+Xj9K+elNj5O7LacPlPrvwmoC89uJcZhD0BksZA3mN8g
	IvIIGHYW7aWsYAyUGy9yuouokiMafXLR5+3NEeQARVU8qR18XPjA6g==
X-Google-Smtp-Source: AGHT+IEssVPbixRlA3/C3mZ239uDlY27+FZE+4B5eGQOr+ig8PfKullwsS+MJlf9YXhuC/SqJrnbIQ==
X-Received: by 2002:aa7:8b4a:0:b0:736:62a8:e52d with SMTP id d2e1a72fcca58-7406f0df3f2mr2759191b3a.12.1746312509170;
        Sat, 03 May 2025 15:48:29 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058db8f34sm3888793b3a.37.2025.05.03.15.48.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 May 2025 15:48:28 -0700 (PDT)
Message-ID: <3ba2f0d8-ce65-48a5-a662-f2350903a5c6@linaro.org>
Date: Sat, 3 May 2025 15:48:28 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 30/33] target/arm/ptw: remove TARGET_AARCH64 from
 arm_casq_ptw
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-31-pierrick.bouvier@linaro.org>
 <a6fdb501-438e-4591-b166-87c8dbd14887@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <a6fdb501-438e-4591-b166-87c8dbd14887@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/1/25 9:24 AM, Richard Henderson wrote:
> Are we still able to build qemu-system-arm on a 32-bit host with these changes?  It may be
> tricky to check, because the two easiest 32-bit hosts (i686, armv7) also happen to have a
> 64-bit cmpxchg.  I think "make docker-test-build@debian-mipsel-cross" will be the right test.

By the way, I'm usually using debian-s390x-cross for testing a 
HOST_BIG_ENDIAN build. Is that the best choice available?

