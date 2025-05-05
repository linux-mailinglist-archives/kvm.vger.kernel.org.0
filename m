Return-Path: <kvm+bounces-45445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43613AA9BC3
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 20:43:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB39417C104
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7359D26F452;
	Mon,  5 May 2025 18:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="W9W0WRu7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4701B0F31
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 18:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746470613; cv=none; b=tX15rY6jGvIO8bvOTUckx2332i3/k94WCeiPt+7evuXLGs2/MgrCeXjrgiFAlS0T8inCTekcB3HRBhbWgc8aXBtZT3XuRjzrLkQWrM8/Hv1Db6ZJPZadt+VhBCmCmVCgUdI3vNHJZCzbUw/CJGulA3/k/dnkUDYlMJqryfS0oLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746470613; c=relaxed/simple;
	bh=Q4xfvkKncVFBK0wHveZLgx6LGjFLgGAxBtkxExkZYGY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ftn814EGtH3cJvBOA1xK64jy6y6Z+mFoMOYYSqfx3AjyHI3S33g0KW8fsu/uoB3uUrHlQd4qpunHo/sEGM3jdC+vB0Thc7/O5QhQTQiRBdL/MsUjLQKcDtiZdNbEhF6I9LrQ/n5P/flms3CfGzfQeC5kDl2Cd67KWQKMgRjl6RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=W9W0WRu7; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b1fcb97d209so1378110a12.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 11:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746470611; x=1747075411; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+V/yckTEt3Of60Tx9qYZWVyVlI2Maq0VpPJSJte1eI8=;
        b=W9W0WRu7RYrUGmGKBuW+nF+eEoEM3mw+/Kl5iEXHdajxcXD+z6a2GgKTVswzGsx3JA
         mVjndszDzU83pWxfO/djhbOllF1M1q4onHXpWQngzxzTXILZsUkmhU5oZ+Y0j0VDfEd1
         ClhZFMzyjd9oIAi1xULilkAS1MbFofCwkcyn7T4npsY7P0F85T/2oJ8ya7lgQHdAmlNn
         HjAqAKYHDbuedJkmWEbhgLFdYN2TFcPjAnr87Wxe0y12+Cf8ULEpnfmwr5oixdWTRV2L
         kQBz9pqgcoJRpzjghKdBU2rjPNXMkw9Jt51oa1mliTG6g9jeF4ut2gwk4O46eeHDdTTW
         5YhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746470611; x=1747075411;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+V/yckTEt3Of60Tx9qYZWVyVlI2Maq0VpPJSJte1eI8=;
        b=JNygcUDlF/c0OQ0RiEsbuAd852wKkK/2RF1E+Vk6UM0U8L0A7UxeFriYdct0yDrOfy
         y5VQoI1jECHP3Ze7jp2ctlKxlND0lGyGmVCGeZ1mnMQhrv4fQ9RfmcMPnfwk3BlO2VGD
         ATm6zcRnhiBYNy++jnGpLEfINqKo2dpnjuMbDmYITB4XT6sn6qeMOMh0Pue2XxyVHIJK
         CdYHBXERZaRZ+y2o7kpbfPcl7s70wfyC3UZZAk0gfhLRmvcSuLmZGiKaUhDInKNp3RuV
         TfNscLibxdIe512xWfmPGaUj1nZKK6wNvh92kCAkapoZNP2Nz90ctOxu4voFpkbzCf+v
         MpiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWP2nKZLiGMi157Fix7w+8Er42H0NKI6lyxir0N9/pvpeN9eZO4fmZmBhl5u2OApG8pjCQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwC2q+yLMSGwXGs21ZcTnAkmhcDcF7wtrd7x+1n4HKBXkp7Zs1z
	qnkG1S1/sgla1/o7XF9EV0g90qh82S42Cb9sk4spqQ85B/VCn5mIlDM/G/u1+nQ=
X-Gm-Gg: ASbGnctsNOfmODXHDngpdud7Gk17d08Mlh/1CMzHh0ODRxB1PXOUS9xB4HMuTVIDHd4
	eoGpi0yhrgKXF11wYBoaFP0S2WLzDdfEB0KQEyO+LGy0DSp2OyPwYlRxuOGJcycJPkT0Ji6b7X4
	w6ID8CZo20bFKKQlTPJPCnGKpBum19mbrr8gqnw/ggsXDB70Hp5t4AXz5Tq6bNRN1Sijtsf8dOZ
	Om2mydGTTQAv4VV9s88mL/TfP6RCK38Q9L6p1zfl3NL/Sn999ZLmcroHtfLhEqPgRGqBlfn73HY
	R+3QLxYkAss0Gm5H7Trm0Q/p6nzQyJj5/iRrhlj877G4OaBuXjEDUInP1f43J8PQUvyx3JIZ1PI
	W4Vnrkt0=
X-Google-Smtp-Source: AGHT+IF2+Z8KaYO4OS/kgD6+IOcvIP8nAKXcU3gY90DE6aQn/DUfu/Od7V5lrZ6DteiM9KOSigti3A==
X-Received: by 2002:a17:90b:2f45:b0:2fa:1d9f:c80 with SMTP id 98e67ed59e1d1-30a7bb49ab9mr788615a91.17.1746470611247;
        Mon, 05 May 2025 11:43:31 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a3480f0aasm13392418a91.35.2025.05.05.11.43.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 11:43:30 -0700 (PDT)
Message-ID: <2c005b5f-1308-4c7e-9b0c-9640aef294e9@linaro.org>
Date: Mon, 5 May 2025 11:43:28 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 43/48] target/arm/tcg/iwmmxt_helper: compile file twice
 (system, user)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-44-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250505015223.3895275-44-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/25 18:52, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/tcg/iwmmxt_helper.c | 4 +++-
>   target/arm/tcg/meson.build     | 3 ++-
>   2 files changed, 5 insertions(+), 2 deletions(-)

It appears iwmmxt_helper.c could be built once, like crypto_helper.c.


r~


