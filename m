Return-Path: <kvm+bounces-36625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A240A1CE6D
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 21:34:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E1DF166904
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 20:34:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 702D1155333;
	Sun, 26 Jan 2025 20:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YApzhjKx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0781C25A658
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 20:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737923668; cv=none; b=rPr1y5lzy9++Z9tugvO3vQnhiRAiyvqKEl8dNhl7C+TM3aZrraYNYmrE8KwiFHNxuv65WyKevdQZBA4AvF0NMddiqEF5IQtFpuNKNs6VJd+OhVUJ/4I8mRGFGkyYqq0xGof3RObIca+0GkUbN0GoDeyZODFM5KSqAnES+ozEqIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737923668; c=relaxed/simple;
	bh=ZKQEHoxvv28E9LhzG+YzpV4mqt9iOz55mb/lJXgbuBA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lWpAaNWW0FpPGTtpEi1iuvRiez3X3wztw4D8v3Bn+/D+N02b2slw52SfQkss90+q8+SxsGqVt+uszNhb2F2gp0IbhHofGMm0gY+Rc/eul+T9pfY0boP2cQO5LaTmddcKgvC0Zk0+q872jYd/FIiqtLPS7Q8298RePAag6+fcCaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YApzhjKx; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2ef714374c0so5750049a91.0
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 12:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737923666; x=1738528466; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HV0rFwm2c/DiJ3VIFDuxU64dDw12Xibjr9C6hrIuIZM=;
        b=YApzhjKxJ8pz2dKjYj2zwaTZTcqPPMefsBzXjnu+Y61cxkyiLrh/XTvaZk6jWgUVnw
         E41MFgLuxamE6XumWEtH8oohjVF8QQXTjaRwe6aVRWLifZBeZFV2zrzII8J1903rn9lb
         R0vdDZOoZjDs0G9sdwW6AUfWfVcdeSOgynsi3ZnIbzneW8J6rUw8FerO3JYryt5sd5uO
         BuNENpjhRaS7EV4vuC7jN58kY1TtVzOe+XJzL0+XNwr2TRpcJj5yXfDtnMIBXF0/kpNr
         NZCT0f03J9EJNU6XQ5ncdkXgDaNY/s/DXvfccvuE3hcKgZgoBQGzk8FLPhgrxuH2mB4z
         7T5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737923666; x=1738528466;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HV0rFwm2c/DiJ3VIFDuxU64dDw12Xibjr9C6hrIuIZM=;
        b=ImjxK5VFlS9jPHciJoIPVVSU+cn+HQFAWGSMkssTqrvK0bcyd+43exuviL12TTL/7Y
         sB+6fO18p4R/Sv8IC6T3jIW9ryWaoSiuLw0C55cAwYE1LuB96mxnLYEAAmeYs0hsu4Y8
         gllAN9FMzdWkgXyA5A6zf8OeKzV2bXbwDO//LtCD42UJzDGp8q9UYanS68TVnLvQhKTJ
         8YNFNCkvQGNY7quZ8JO59Nft6pSbxncjvJcgnZHnHioi6L9nwqAHW/l5lonvKC6kekOy
         Xw57fQtUua5ga16d8JlvCWR79j9o93uW4U5j1tagNyw6K8iYihK4AXNBP8IGzU+5cRbT
         H20g==
X-Forwarded-Encrypted: i=1; AJvYcCUQ+/BEkfGmUDVFbYmvmpftAhlv5VbpK7IndBo7oS9UMRueuGWmOKtoDRuAw/3ge+J8n+s=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywo+723feB4PEuuuTTSAjucLPljLurljtaQwJuHyQ+BF11ETaro
	SBREtyNKSTMgeSDS8jQMhLG5XfcPREJmYkWTn8klWTsWEKaISwW+RNIKQ2iuK3Q=
X-Gm-Gg: ASbGncvqI4xudmOd3pt9VKh9jIqB5wQJZ70TPrF/njXoAFJKihx3CUn6l+RP9eAzx38
	YApF31HkHLvc61n2SCv4yT45r5ybTTSiX1EsdeV2ywlXUlMaeXaueUdNJUh4sjDcn0IPr9ZVFLt
	k477Q44haYOTWAlSutxxoLkKhwEHbfOWwS4XiWBmVhJevUqwR7bQSuN5ifakyFQtOzKV5h5CEne
	TnRwTUodhRKUXEeOoI4OrZWlDQ9OrgqF5OXWMFw+Ne/varj0ZjFXpyq4RewbEkspAA3oi9Wec7e
	cCgQnQmKpdhVUz0NKzLt7Tw5Lhn56IZbExZQIeeGeoAzDsk=
X-Google-Smtp-Source: AGHT+IEnuvCpks4R8m2CWUAxXqy7OUK3I7qmzF32T6Ls9afPXbIvlOOo7wFmoCIeuE1afURwxObJ8g==
X-Received: by 2002:a17:90b:5488:b0:2ee:7e53:bfae with SMTP id 98e67ed59e1d1-2f7f177c6b3mr23097382a91.10.1737923666307;
        Sun, 26 Jan 2025 12:34:26 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffaf8b27sm5519409a91.37.2025.01.26.12.34.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 12:34:25 -0800 (PST)
Message-ID: <2641e9da-db13-490e-9bae-64ecde1f9352@linaro.org>
Date: Sun, 26 Jan 2025 12:34:24 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/20] accel/tcg: Restrict 'icount_align_option' global to
 TCG
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, David Hildenbrand <david@redhat.com>,
 qemu-s390x@nongnu.org, xen-devel@lists.xenproject.org
References: <20250123234415.59850-1-philmd@linaro.org>
 <20250123234415.59850-10-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250123234415.59850-10-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/23/25 15:44, Philippe Mathieu-Daudé wrote:
> Since commit 740b1759734 ("cpu-timers, icount: new modules")
> we don't need to expose icount_align_option to all the
> system code, we can restrict it to TCG. Since it is used as
> a boolean, declare it as 'bool' type.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   accel/tcg/internal-common.h | 2 ++
>   include/system/cpus.h       | 2 --
>   accel/tcg/icount-common.c   | 2 ++
>   system/globals.c            | 1 -
>   4 files changed, 4 insertions(+), 3 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

