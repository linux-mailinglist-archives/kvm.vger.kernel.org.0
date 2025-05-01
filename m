Return-Path: <kvm+bounces-45163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A425AA636A
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 21:07:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5426D1BA43BF
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 19:07:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED13E224B15;
	Thu,  1 May 2025 19:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UAkFS4US"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5432236FA
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 19:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746126419; cv=none; b=kH1MWr8hIQYu+/BUclIV71eldC4/Mr0wzCei8UqxLPDs4nGAf9gT/dk1h9NEXKu7pNHtpYyknNCuE9nqO9MO46yO3zWwC5cg/3chEYDAQIAihV6673cJqIzQS0oz3Wu0algs1H5yEHdzdaEsmGBqacYX73XGMc74C2vcN7Zivw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746126419; c=relaxed/simple;
	bh=o2UiIhJ0YmpT551cu+k01yKzB2+9wjqyl8sxLcUd18I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PcGsvvScitE1b/wo5b+McY+kTxUKUGWgJ5KVrHNwaD23SpFucvBJvd/iCBNNvYOLjP/XbBomgUvxnfXnZx8Hq9Eu3KVIACQQl4py85+x07vaOuH8riv13tfiI7lsmFVLBHiUFs6FkJkel63AkxCxNBDK2on5PMiydP5ERHHZsY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UAkFS4US; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3d91db4f0c3so6963435ab.3
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 12:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746126415; x=1746731215; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6Pr0ZTtrxxWlbqRuc7hGMdv9IMHjrV4fkbELicrr/5Y=;
        b=UAkFS4US3/PCaMaj2xcDOPs7gpo/2Xf3pVySzOGaS17GkLwb//Ueqh9X/id2d1HxOG
         iWm6OdP7c4MxpTntzYsGdUR0ECcC4kTY1TXnZuHZdyb0HN1n2RW4KATEbCqx+K0TMF2D
         6sxQZa7hANZ+QzdyYqUb04RTXPmB9DEmQk24fco2++fQNEDNSv5Q7G8icG2e5ZT5CTuC
         98lOxS6RqvvGYQ9ZKyHnGQTrvRMVVfBtcvGmlK+iPstS7Yn29VjADh0LPofpe+JCrkjC
         zJDBhDR9HZZJkBtXWQKjI986yKG2up0fGproL1cOENzz+XG7EnPlFX0PhG2nkoVUmECk
         S4Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746126415; x=1746731215;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Pr0ZTtrxxWlbqRuc7hGMdv9IMHjrV4fkbELicrr/5Y=;
        b=kYRvAhcnJsbf8wnKGfxPQdos4Ib5bRYECj0FjiWotLkdHay4w8xGJyZXeB91uNTInb
         iXJQ/13MV4/gPeAKp0PhuMAa5v2NhKleXQCRCTDyZQekJfJqf2dJz1X/BOgnhN/BQ7F+
         X4bP9HU03S+vifUi+J9K15Vhdl8hg8WLmTqdnMWNaXc9pis6jbMJKLQAJDhrb3UM1nVb
         LIasvaMMSPkBK+By/tD5C6iq+/tOYMqqDou33wJReW8vb9jTl65oiKvNW8QMSAsSeXBc
         Zi+hvxAyL4Mv3ON4mcnRQjHtYdoVxdmIyONxXWNVQ8kbg6/obyXXajzCadzqTY7JRcAu
         rERg==
X-Forwarded-Encrypted: i=1; AJvYcCV3w0K2pYx2Qc04fxMa5MCARSlCyzdzeBdPL0q8b2EQ4JmTbV4JhW2gMJUrv1B8/+FPNqU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYU3Z7JZg2Q2dSfZiyt1Y3s5DAO03rh7WzZecuuhULguJj9IFZ
	DZ/uY3EPiwGkKZhwCTsfS0gvlqiyf6kc7w/eot816JJfgBG+LW55Gqu66k3R+/c=
X-Gm-Gg: ASbGnctHWKAx+viQin2MofDz44Rqss8iaQbo/eMUir6yoZUIr39srforJe9FtWwuamk
	Fv7b9hSAtCcxtIekLydRbYILQCtdnpkyVRhx4Yvwib1K3Lo/bo1EfIIDIiIQAqRhHVytI89Ub8A
	medcY+gBEzsz4gGZsJBG8E61ThbXGkoG5OJzjAGW8pUFhu8s4Jd9zcsaJAcWUrhiXSnd0fWyylv
	fp6NJTK5k5KK1jkPqEN2nnD3SSYIR1zYeaNSF5SuULt+FTjb29at7ZR0OPUKVNRPL9OMErsMwCH
	loqUffT3sjSoTFwIeY2TTFZ/nUVmTIiJusukFE75yfkKiSVO6baOhO9yS3C2HcAZ5oCRUfbndg4
	ZXXqdtqjWDRA8Lw==
X-Google-Smtp-Source: AGHT+IFWe47sTKQaDKHadNBexo5LU2njaufHJh/pzZ8fp/gyYC1c73rGYd7uWAJ2tQ0v6YOC57URfA==
X-Received: by 2002:a05:6e02:1fef:b0:3d9:64e7:959f with SMTP id e9e14a558f8ab-3d97c2607demr498335ab.21.1746126415659;
        Thu, 01 May 2025 12:06:55 -0700 (PDT)
Received: from [192.168.69.244] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88aa5896asm355173.86.2025.05.01.12.06.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 12:06:55 -0700 (PDT)
Message-ID: <39751e9c-ab4c-4daf-bbb0-d9ed01943370@linaro.org>
Date: Thu, 1 May 2025 21:06:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/33] target/arm/cpu: remove TARGET_AARCH64 in
 arm_cpu_finalize_features
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng, kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-11-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250501062344.2526061-11-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/5/25 08:23, Pierrick Bouvier wrote:
> Need to stub cpu64 finalize functions.
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/cpu.c         |  2 --
>   target/arm/cpu32-stubs.c | 26 ++++++++++++++++++++++++++
>   target/arm/meson.build   | 11 +++++++----
>   3 files changed, 33 insertions(+), 6 deletions(-)
>   create mode 100644 target/arm/cpu32-stubs.c

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


