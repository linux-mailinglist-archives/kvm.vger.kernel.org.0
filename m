Return-Path: <kvm+bounces-45442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F77DAA9BA6
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 20:39:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CE0B27A33C1
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F391226D4CD;
	Mon,  5 May 2025 18:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C6uTJ/5i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B94EBA49
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 18:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746470333; cv=none; b=AAgSJXSnWin3nw+uptIcx6xKJmYRt1/e1zfV6gjL25vOPA09HU0agkSiFBYu7KyYPdkMqiLE3oRjcuNFfFnCGTX9CLShvxuFRh/i6bPXBh6XFfoCaeFcvRbyn/5qq/IXxs8T6Py4u4BOaGM7OU11O1Tb5Xkd4NW/E1f0g0llfgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746470333; c=relaxed/simple;
	bh=l0bhEN4UL5Yxs9fYhpfOJTP0CtMCtEbRH7kbhr0xq78=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R8zHL9580axX5GcuDZE3os+CO8QHEWHQ39l1vJ4QElmSWLHlwOAMB+7hJ2Di1glbWqtO8/0NWTztbn2aN8tIjRKEfneZ7i4PyHhIel6bA33WZ0JLUx3Cpyam2UkwOSh3kE1z2T0NYUoJhrQy2XOxYX/jXDUzTOneESsjutXw3Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=C6uTJ/5i; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7399838db7fso4984858b3a.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 11:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746470331; x=1747075131; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nKyzw7dqii7wjo8QpjXm87u+f1HmCj0oWFjoWrILNos=;
        b=C6uTJ/5iqj4f7/lUkaYYZrtQ8cDyQEJHHsgPzrpsHFrA12Rj1J9hzf3mRNy/Va/LLL
         9jSpO3sDDjRBeiotnijI6xwFCsp9T4zltt6Cjt3wuxh9pfPhykl7bryJOFtny/MsjzF6
         PXJXeT4hipkdRAdxRwB794Ql9XMbFsQv7O4fYQ614e9zDsSQd3pwKLHQNhdAVEqfMy3i
         S6FEF2T1gEQyxVf9ndyXrK5RLUjy+9YuaE5+Plyi8h9dKtdg6PvjBp/p+jbtrsON+edW
         E1TULCe9wBUfO36JBKhM4BRbyHRuAduNFo9ou/o4wQErBue4tCoyOg0rXiX01OBfXR0p
         ltXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746470331; x=1747075131;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nKyzw7dqii7wjo8QpjXm87u+f1HmCj0oWFjoWrILNos=;
        b=UrBWd4y0i8eDdpVgYmPq0qHLKYznpumHcd8Nv0xx1QqfZJjs5OSX8KsDTlv67G3CiB
         GwctslmgDTogeI0PcoliYexqKrCt9/5ZvOD+O60xPvlO6Kr6W2xa2/IrG9TRFXsQBnQ6
         Wme1wilvzmQmFAHNYgQGzq7HSMAMvYu1KP+pUKW1F4IvPxxDVqAQ/4peTjFIpq9k3NuO
         usDasbyab7PzjVraw1m3SM5Ya1NrkqSKWiblsHuw6IuO8ELZbZa0U9OTb4x2KNLTN7QN
         SNogrpA5mmX2lBpcGhlEEsL4e+o5AYUqrrYQlauHUlOv1DC5lVBOCdkt+kfwFTU6pKq8
         CVHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQqLAmUhFKSWpUE+Ab1gIyHIfDZZyjc9CkbMeg05GKOjcLrwidAayh3+0ADdkIgEcp8aA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnBYl6029sOeFIEeBRLlgOJ7zub9/2CL4oJ3WylAf81VIf+kvz
	Lk7WKZc3UcBBgN547DnXTaboPMJuJGsP2UAjWKHpiN5prnvqviBGEJlasB8zC1k=
X-Gm-Gg: ASbGncuNZRbg+L83a/LAvyDYqcslBuazOmNRik18fS4B4bBVqhFJMaAA19W84B0H+iX
	NMstLdsV/OzWNGm9ffdyep806KjGDV9f0hBm0yO7eCb5wLvChNUUbN9vodo8OLkgG+fB9CGGrdb
	PRP2YViXiLxC1e/VfXS5JfKHt48zl58Z4lnl4KdQw+RswEE6XswHk8tMdoSDW2tZwC711ZiyE9s
	8ZV9/FJw9EpZFl0Kbya7uKKnopKZMkWNVP41ywvgfTIspbN+ururvt6lcqZ/EYbp0BUmMKj5LLF
	Z2atdHg2vPXX1uWq5KqYrLaGfvmne7chpzt1C8dnZcIn6jP9z+nwfcBiGPTj7CNWgEstSPc2OqF
	WmdU2Xwo=
X-Google-Smtp-Source: AGHT+IGAAUCgJ+qHs+CPl3wY0lI93EZysTDceyPncdEvx0HUi2ww0QZf26oq01DkkIYwwBVPPIR4oA==
X-Received: by 2002:a05:6a00:3908:b0:732:706c:c4ff with SMTP id d2e1a72fcca58-74090f149f9mr821065b3a.7.1746470330721;
        Mon, 05 May 2025 11:38:50 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7405905d029sm7366657b3a.134.2025.05.05.11.38.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 11:38:50 -0700 (PDT)
Message-ID: <79916f8d-2793-40a7-b769-ee109c52ef63@linaro.org>
Date: Mon, 5 May 2025 11:38:48 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 41/48] target/arm/tcg/crypto_helper: compile file twice
 (system, user)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-42-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250505015223.3895275-42-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/25 18:52, Pierrick Bouvier wrote:
> --- a/target/arm/tcg/meson.build
> +++ b/target/arm/tcg/meson.build
> @@ -30,7 +30,6 @@ arm_ss.add(files(
>     'translate-mve.c',
>     'translate-neon.c',
>     'translate-vfp.c',
> -  'crypto_helper.c',
>     'hflags.c',
>     'iwmmxt_helper.c',
>     'm_helper.c',
> @@ -63,3 +62,10 @@ arm_system_ss.add(files(
>   
>   arm_system_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('cpu-v7m.c'))
>   arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files('cpu-v7m.c'))
> +
> +arm_common_system_ss.add(files(
> +  'crypto_helper.c',
> +))
> +arm_user_ss.add(files(
> +  'crypto_helper.c',
> +))

Could this use arm_common_ss?  I don't see anything that needs to be built user/system in 
this file...


r~

