Return-Path: <kvm+bounces-45170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 17AD3AA6423
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 21:36:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81D9C468003
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 19:36:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27EDE21E098;
	Thu,  1 May 2025 19:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QtkQQI51"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DCF20AF98
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 19:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746128169; cv=none; b=ps4IKmFEvYHCKJDQHJqdU06DwHsyOsnLn1Lh+qntHwhO926PsIxQsVPpX5O/I38dOsmsq/c0gVoUobYfSH3L4Me7T1h5FOEreWwhNZCoeo6Gnlj/885XVxbWGJL8okY2AX9E2p/WtpAXAOLk8BfZiNhuP2Y75jnJPQX0HgNFdBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746128169; c=relaxed/simple;
	bh=1LR7sf0TsW8GUyuHfWUPhnxeIXqDhWf1DcaYwQJ6+kY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lW+diXBQXVXDhH3PkP5iS45M411YwNWKUTNhQjdY2JH8j306dDjxnfrIFAdUWgdFGa9f+ZwsOrR0kXuGXDb2W3vJ3rNjUHP9xf/BiZZd4V6OuqYRN4ofwWtz4mb+5rvEy1jyv7DL8im5/0DiRrpsgvYpQQkW7lkSDuNOBDVncEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QtkQQI51; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-86135d11760so112275639f.2
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 12:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746128167; x=1746732967; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QbG8B4F3h4q3N9mXDivZajjCwAknOK7U7lhDZ++KnKE=;
        b=QtkQQI51pbhypEwS7gU86Vj1/dYBkPmh5X7LqbVa0iaoPAsTVD4zHaOVKc4CHMQe6m
         BEJ2lUlUIHiyjK7akYPl3vH3GsF+2CfglnRNVHms1rwkUixamBI2SV+xKsTvUVgJiPMy
         ln4IUjy6w/b2NaQK0DwixT9cLpE9euKi3FYYYOq/O68YlA/1X1qE+I716Z3dO77qI/Fr
         sTUoNbVH/cl3pAejefrNWjD5X66vY+dDzqzIenNXHdSSS4rDQ022iRsL3qWVNcq3sj8u
         faMmuGwSGINxCnoI6tRfoqpx76hB6t4Aka3oaQmARIoIRVTClkRb9lca3iw2R6Yv7Ax0
         0EaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746128167; x=1746732967;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QbG8B4F3h4q3N9mXDivZajjCwAknOK7U7lhDZ++KnKE=;
        b=Si5tm9w9W6wIBgijnLH7q/BKvrWJaPZRYBIKqG3axs6HLArL/QC2MBflRmTN116NlW
         c6KknJTjHCp/ML/mA5KfG0Z7qWmNzaEMc9NJLFfP8Cs8FHOAhHnNjoIAmVcH6iDkGMQj
         YVveKc0t+PFpehs1ipBBIiZKWAKUAzSHrFAQMqmE5GJ9TFK6LT2cZuV9+gt5e5xp7k6P
         d1lVhHZ8Geug5iEdCjaNStFlUmvhxVcB1wJTTwrQSwQlTg94MZUkNnJVIUAbojpX9354
         puVuNG1357PYW1o5nj6GNpAvtoEU/laYdOnIZRbYwlp0XFYz6X+2te7igXpYayUFssGX
         alYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWY+YzIUBGEnZz6vyTYN5PhupeURiHVRirM6fzP4JBsPS4H7gEKrAI1swnidlVvtWd9xOI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzC+bJsIlH1+OjfLzHZzWk/DqbHII7UbW5c8APhESGRbGLnAPZD
	AT4C2LKDqwSmb/rh89aaV928sFRVCjAF6Ymv6SAd78SY8zoDBxFdLcxXdLOj5E4=
X-Gm-Gg: ASbGncvjxax1rUF5Su1qGJ9WrvHVWeYOkn1W4AbPfxUgUYG+oME6mlumqLWckSmGHb9
	l3jBOuR/KWpcyqwn8YyA/2lAAT8tHAon/6UFScUq54LBKaK+DiGO6yvHOHbBQJS9kkS5KgfxuQd
	H1GZnMb2Mwj3peVGpFJVJjPH+9slewcKn4/8ZSCGtTlFWXYfdJ5fN1HWWsS4pitX/epulPcw+RM
	nlgJI0HDfcyV82X6naeCsVZgNs+KsvllnGMfXsYSgZhFTmTsxUNpQ5z83aTmGAK0xShyj+roMrU
	Tqj/R45JdTn0n+30uVMiFjLn2Yog+X1o+g25Xoeui8COLSwslfgETx8KX5wGYY+Tw9zh2qFzfNH
	tlx4NVrvHBVvH0w==
X-Google-Smtp-Source: AGHT+IFmEF1aOJSJyHbAQ0USlKrGSdhTT3r6lXu1PXo7h9NeRF/lMEW1uua1Y3ODC30grn2S/YfQZw==
X-Received: by 2002:a05:6602:276a:b0:864:4aa2:d796 with SMTP id ca18e2360f4ac-8669faecf3amr60612539f.8.1746128166917;
        Thu, 01 May 2025 12:36:06 -0700 (PDT)
Received: from [192.168.69.244] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-864aa2ecd8fsm22427839f.12.2025.05.01.12.36.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 12:36:06 -0700 (PDT)
Message-ID: <305ce532-c7d6-41bd-89e8-833613546de3@linaro.org>
Date: Thu, 1 May 2025 21:36:03 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 33/33] target/arm/kvm-stub: compile file once (system)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng, kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-34-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250501062344.2526061-34-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/5/25 08:23, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/meson.build | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


