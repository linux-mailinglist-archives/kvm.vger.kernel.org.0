Return-Path: <kvm+bounces-41771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCC5CA6D0D9
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 20:41:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B9D13AE210
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 19:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72BC019D093;
	Sun, 23 Mar 2025 19:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="III5DvxX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245974C8F
	for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 19:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742758905; cv=none; b=niEI4Uh7wzvktJl49ml93K2qk2Dd+RBdhlkuW9s98QPTZMliQLPqIDRy9UQ9rwPq17J1CgZzrO6Ejl08w8Jsp3jqDdoocNJVl2HNRue1gP9xAXiOj2ZZ2QTmgqCH/elwuzkcmicGhrJu82mqu61P0v4MI5xdD2+W8C9rYPYBg8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742758905; c=relaxed/simple;
	bh=WAGpnO3yk11KgAW2QWmgmSbdEYQJrZbR9PrcqelmIa4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i7Uwfgk0t1L8XTsTVLHDwd/L6zPxntZtjO/Sh2AbKG6sFik9oICQvhuEoRaLoHQmkD53GMgpSLgCNp9DdQVq1Q5IIGr2D2clmB+4QXfMyaE8mjx70RmzzWZEYn/l+TIZDdD8NmPa6AflTWAnIq5C6sPAkrHaMOuD2O6paTr4ZBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=III5DvxX; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-225fbdfc17dso54639635ad.3
        for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 12:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742758902; x=1743363702; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xpN0WCyhT2dzm8EtIPPU3W+5pesccd3U8/8x7J8QQvM=;
        b=III5DvxXbYxt8ScU21FsaRDjFx5V63W5N9t4Ms7oQlVCtVRhDNLznuSoGaUgjx3Z1w
         wqcYazR+7nW9BQX2XZUuHvKPqaft1/FcMPDyG/iKdSxelbmn0+YegWImV8NRJ7OJX9HE
         ZvVLcl53Ia3/7pTFQ1PXb/bQrB6uF+rL2OJKUDl3yLQ3J96avX7D3KYekcF4D6vgVtRl
         cv/cDdaznl/WfpZV8NfxSYdBwfssYTQuwN/b3ZxEwH47q4Ouf9XzVWUEiIOu4EBCJc5n
         cUrF/0D/8P/McSl0YkCWsata//wbZvJYHoeMC+ZytEnah67WZdMBHysiOCHcgy+EPHWW
         62tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742758902; x=1743363702;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xpN0WCyhT2dzm8EtIPPU3W+5pesccd3U8/8x7J8QQvM=;
        b=udxNgkPrptGhOlgNWSHMG1NiCuISDcYr+v15wNttZTALtimKOizfzObmzIcCqpx5ZP
         VxsLDBa3vJ6EqqdXhl+b452sPpuA4qIZ8rOmPcdxp5vWvC7kncFFT0U7DwkRRXtDgm5B
         ISWwP9UdG+3ZUjiFViNRvzYWVXtpwj/BUTuypjI9+roYCtq5EKPJoy5Sjdqzu+CkZJeV
         e0vQ4vS62KwjPyCXzBetd8WEEI1FrEyYXkabYsTKyFj2R7Nw4VtvvBP10ZGJRrDlwjwL
         F4VedUePbq1Kf6gSDcBERvgsKFlTkY1bJTZUg0rQw5OEtDuZ4APR12D8LuaLi8W36iJU
         5Ugw==
X-Gm-Message-State: AOJu0YxsMLGSyU7haWyi98aw5O+mgrP4kYkHsZHjwr+Q78dknFXoUTRe
	oUKZK3KY5ffz7FTzocm8lSCf8brnB7lhSkd9RIU9DbKNiz8KCQkhGvt315CXTzs=
X-Gm-Gg: ASbGncv44ORrU8GIjlEF1V7SH7U3wrAF105We1w8Ia3Rrs/rQ9uqWp6afgconyN6c83
	2g6ZKIDHYnL7WnVAeC2g8p/uPBP/etCPO7fH67qz4bQqL3LkFzY4jTuktCTECUU5tuAXNduJaLn
	q+Im4AZ1ye0RHAJG8jc/QEeHOtKOwGthOjCveCICbdgPSGqb18oIKPpqVLfAnXGOt9BJ8gUxGpW
	wI27vjNqqhTVWzZhOgrVC1SscIVs2TPWxvohgVpwCVV2sYMPYZYjNCfZ3MRNNDbNyDc+JmrEJZb
	q66JGo8wMz/ioQntuk4J5Gb4WG/M7UYZjvrr7hKMLivAdi4EmvGUYOwaSqAc2POK5e+ljDSCAS1
	fc8AygSduRvCoSbBezsE=
X-Google-Smtp-Source: AGHT+IFY6xZFysTRRyg3Adf8BTt4qkGs3hqtaQVJR7D6e7OzhF14bhxSgWzf3Sve0/kB4k/0W3qKAQ==
X-Received: by 2002:a05:6a20:1582:b0:1ee:c7c8:ca4 with SMTP id adf61e73a8af0-1fe43312759mr17078782637.36.1742758902333;
        Sun, 23 Mar 2025 12:41:42 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af8a2a25dfcsm5561281a12.58.2025.03.23.12.41.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Mar 2025 12:41:41 -0700 (PDT)
Message-ID: <23626b2e-fd77-4def-b73c-27da0fba7eaa@linaro.org>
Date: Sun, 23 Mar 2025 12:41:40 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 23/30] target/arm/cpu: remove inline stubs for aarch32
 emulation
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-24-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-24-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> Directly condition associated calls in target/arm/helper.c for now.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/cpu.h    | 8 --------
>   target/arm/helper.c | 6 ++++++
>   2 files changed, 6 insertions(+), 8 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

