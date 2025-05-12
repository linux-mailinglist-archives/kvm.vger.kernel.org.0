Return-Path: <kvm+bounces-46191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6321BAB3E1E
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:54:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C29DF866EB7
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 16:53:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D41E255250;
	Mon, 12 May 2025 16:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LoMZPx2P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7511E248F7C
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 16:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747068839; cv=none; b=IOiiYHPko/uxzNVX8Y6aXR7DyIaBx4WbqgOOg/2FpskEVlzN8TQHAKKBLf+2joaq68aMxlbbcEbMAgM/8HlImsXELtRZlz4feS7OGw2P7zY4oIdeMkNwRo3fbeyowPD22vlkwEjC2JgzU3ilcHT+epSCVQIUWIVpnEDNMJQ+jPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747068839; c=relaxed/simple;
	bh=a+0XMi9yDHp7YXNTQbwG0CZj8B159y1V3ygOA1xQ2ZE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oCUdyf/dVwScy6/NkY2kmXH3Mqak60KfzjUVZCbR/hvOIzf9tDnzQrnWT0NPXGrb/avBzG/AD83Q5faQmcxkNewc5kLCz33GoflxIpzpiIJX0RsWeo4D5BuLFwmnWMbKXN8VB3GefmvJgeXifXyYeQkFVHQFtzsH+sdA9TeeaWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LoMZPx2P; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-22fb33898bbso57299245ad.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 09:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747068836; x=1747673636; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5qv97JEWqOyn2RBAQVy3o+mtOcNrHF+oRB2lO8yK+3g=;
        b=LoMZPx2PA5UNfU+xFQV/W+5UDqJHQ544XFVQQE4lwYGLluFHIi/HsvB8WaUXwAUn/P
         AodL6J5uYKIZM5jsmHb13bhvMKSwcLwdvp0x2JcsF/dXyNP72Hb5VMF33ppTTLgtQPgI
         zYjRoBWaP4iFM9QyRFwI8rSTvY1XXkItjBvSjTqzoHxsCPdriBkoXcKoJ7aTtXVK2cjh
         pl6GCECp90J5aeFgOFSxo9zEkfXVAgZ8Szmme2H44PZgkURldgx4YhTI1AYaES1NXh/w
         O55Z3EMTeIU7c1/IEPNw/pzIb2RcP70ZvHpAYYdC7Yy/c/yK3QFRvweymLNj790kpNzX
         dAXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747068837; x=1747673637;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5qv97JEWqOyn2RBAQVy3o+mtOcNrHF+oRB2lO8yK+3g=;
        b=PSZpYGpsHDwlbnSQlDJwLED9inNlruvfAjJUfZbMqVRMSHclzvfzaLJaadbAZwgBwQ
         kREN0q69jdEheKN82hZ03asxb0fb8MDa7yffa2CnVEbfzY5yXO2SrdUWSAan5FRvLG3W
         /ud8PtBtnlS1DvPRKqVW9MuWDHzECb73TwkrQMlemsvTkUkZv1huPeK3q6w5klGNwdEH
         Lp/k/vZmTktlAo8Ru4Twgn3BJl8nQFtbdac4gZdJzrFbUUC2NG+gj3dYMTrn5U9o9Iau
         7rSD2DNY05N7HgiLWvraUyGhFriJd4AgKgeJirjXT6+OC95Sk+sFtMd/5i4Hf3JTW60o
         GYtQ==
X-Forwarded-Encrypted: i=1; AJvYcCX48xGMHl57EDb8wSB3/HZzdC+yT67zRK4wiq11IFMMBcvWpso4AncntowONXzv2M9d4nU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDX5ww8pigBNsLfIRYskjhlD9JJG/wjAWPPw6I9tDj3Q8K6Cpt
	EkKGKIVEsorgZcCLmuem8iC3ysPwVsSx/MNieX0DPZ3lNFhoNpzstO8WCsJ7uNFlD5PvDFfG1Yf
	c
X-Gm-Gg: ASbGncszIB/HC0/V9NOgQnGYL1smQx+Qz86UPhr6nTncePgOA8NortNvY5RlmEwgisy
	pC0R4qoLJvQoYR06c/dsU5l831+Z+HhwSgNeoYkHg/CQtaoC1N++sKUqZUit1XIX4vNrwc+t/jg
	UWDitzAzFIMpJY6FbYWXRv9GBxnpJYs8y/GJfqiTas2ZnzCulrNFRWwCktEyZBDY9ifLPsC3AUV
	rJ54NKfBapdiBQXQLjvxf8mQBozpoewhQfGeK4XnGsAtObPcIs7DBYyShNBbRvd0YzhWnn0KrNP
	l4EsImx/H0322b60ZTDCXTC6Kj4o7GhF8lvER6F76k81TLB09UIKT161UMds7hs7YpPi1SDQzik
	=
X-Google-Smtp-Source: AGHT+IEOn8CN414mVktJ1vMBGRSWrkkrE+hsDBQ68HIHv+XPldWZKBuYvuSfuI1+1GV0jBqItHroGg==
X-Received: by 2002:a17:902:d581:b0:224:5a8:ba29 with SMTP id d9443c01a7336-22fc91a7375mr222155015ad.43.1747068836640;
        Mon, 12 May 2025 09:53:56 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc764a536sm65723905ad.66.2025.05.12.09.53.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 May 2025 09:53:56 -0700 (PDT)
Message-ID: <726ecb14-fa2e-4692-93a2-5e6cc277c0c2@linaro.org>
Date: Mon, 12 May 2025 09:53:55 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/49] single-binary: compile target/arm twice
To: Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org, qemu-arm@nongnu.org, anjo@rev.ng,
 Richard Henderson <richard.henderson@linaro.org>, alex.bennee@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
 <CAFEAcA_NgJw=eu+M5WJty0gsq240b8gK3-ZcJ1znwYZz5WC=wA@mail.gmail.com>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Language: en-US
In-Reply-To: <CAFEAcA_NgJw=eu+M5WJty0gsq240b8gK3-ZcJ1znwYZz5WC=wA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Peter,

On 5/11/25 6:40 AM, Peter Maydell wrote:
> On Thu, 8 May 2025 at 00:42, Pierrick Bouvier
> <pierrick.bouvier@linaro.org> wrote:
>>
>> More work toward single-binary.
>>
>> Some files have external dependencies for the single-binary:
>> - target/arm/gdbstub.c: gdbhelpers
>> - target/arm/arm-qmp-cmds.c: qapi
>> - target/arm/tcg/translate*: need deep cleanup in include/tcg
>> - target/arm/tcg/cpu*: need TargetInfo implemented for arm/aarch64
>> - target/arm/tcg/*-helper*: need deeper split between aarch64 and arm code
>> They will not be ported in this series.
>>
>> Built on {linux, windows, macos} x {x86_64, aarch64}
>> Fully tested on linux x {x86_64, aarch64}
>>
>> Series is now tested and fully reviewed. Thanks for pulling it.
> 
> Do you/Philippe have a plan for how you want this to go into
> the tree? I know Philippe has been taking a lot of the
> single-binary related patches. Let me know if you want me
> to pick it up via target-arm.
>

During the release code freeze, we mostly used tcg-next.
However, now everything is back to normal, we simply work upstream, with 
a simple "first pulled, first in" strategy, fixing the occasional 
conflicts on our respective sides.

So if you could pull this, that would be appreciated.
Thanks!

Pierrick

> -- PMM


