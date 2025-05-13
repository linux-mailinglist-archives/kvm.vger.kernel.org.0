Return-Path: <kvm+bounces-46317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66D71AB5095
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 11:59:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E333A162F5B
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 09:59:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 717701B4159;
	Tue, 13 May 2025 09:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GjNI5x03"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5661F5852
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 09:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747130331; cv=none; b=JyIzfcWBQpQhZarQclhd1rLgcgj9/dRj2iJeVsbSnTw77seWOvo1a3USYR+94XFy6cYTxtBgxkmhXM73yvQhitBA39YY+y16j1om2htqlYWOI3ZX+5cXjATnRy57fM2wYMJ+xant+WM6cZcXE0KZQE5kycJ76wXKH5IJtFtId0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747130331; c=relaxed/simple;
	bh=wc3uF9Woah9KvNr8h4zYoQ1rGluk/HV5lzyPMvgDojo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rL2PqLkbYWrQBeUm7EIxZugaPJ4FV9Igu/WqN1PW5kRmAaQ0X6kyuKjW9sGQ54a+W0ePLRmtVGMoXfBL9D2+y/FMvfh58CDP0EYlOSSlm0AQEmy1MuMRtmNsHRjJQP4aPONJgfiGDNGq1eRX+cItx+lRNxh097I2oLD7K1iQQpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GjNI5x03; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3a0b6773f8dso4464967f8f.1
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 02:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747130328; x=1747735128; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hWwzifUQhEG9S2dfaswiId+/tUog3ILaSkr5hNhPhRk=;
        b=GjNI5x03gIZ7IBKypVNNgrJAnnBqsv0yN021fn/VG3WMtVRQafDizBWEAYqio9XUlv
         qmQGbCqGYcRdutV+GSXf9uOrL1PZQzpaHG6klwypjW9vY3KmHVpJ65QREUPWKKa1K+aO
         gvw1+4QNPC0lQnsQoHDdE6V8bz090bPEEkrrmxx0bsjBbTRN9mgtnKkWcHtZVufx3a+f
         YazS+yMVwBsJKjUoFdNojfgMDJ/jZRztz5A5hsUOyz1MAMMx+eIz3pPKinosNJN/XLDM
         YwFNq11B0NCgoLwG1ictZHEDnsv+MbTiKP/aXWOwHqLxdHHrBkIu631wkzQisbtqQ81N
         ig7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747130328; x=1747735128;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hWwzifUQhEG9S2dfaswiId+/tUog3ILaSkr5hNhPhRk=;
        b=LQK31mxopNGTehTGikobwCgdjAbeoHqGVJf6KmbTn62zhmA4jo6V0zqYrQAS4+SuEk
         8i2iOXBEmTBmwmblZyNZ40FBqKNkzlF7ghI9de0thcCh18vwrL9Vqbf3peQWZZPO7aiL
         K5f6qpwdNtP+YVKQmrVB1fY9beuumvPOkqWNy+ig+FoyHNSbVNXqRy/Lwq14sKBPkBdZ
         pBK7UfFDivx/L3trHqwhkGbVRDnIH9Irp/xKkoJdskvrfFdwdhKC79T0QwvmjDkCeiLj
         kqR3w7XwdP8PvToRSPqXUb032EFpRPkVrQR3lq31J5Brqv8zcvz0BJzAKFSJgajUfG2A
         OZ5Q==
X-Gm-Message-State: AOJu0YwFq7Aw9OoWnfhaxCfrFlE/0NLLDVu3mmipyHHSVtFJYYFfaLS2
	87OzBaiXa67fOw8+nGWC0ZHTfNOKpE4TrXgVEvs7E/XoaMbePVMAMscMenrlzdA=
X-Gm-Gg: ASbGnctd1aRo0XBFMip530JFKdRvE4APd7DwPAc4nivfC5A47w9kHVt+Icc3O9NAaup
	rnkgsed71nwKWuvKCOKcSFXJsnNLb9srhRnZnN3LNy3BS0gyBH6ZX2w7j/NnfzLH/nZBS92NUHZ
	WjfNGsJ+3Z10WEPnl19Mn6YFcaYeO7OKq6x16G+I5tFjsD/N2FC1RY6PlUnQUQOFOA/Eoks7zTZ
	n/G24TpfywJngebs4+ktiBW2gDfK61uMzUc4DOzYMTDLf2paiL1SY4P5qfIm3r/sow0TkQE0i4Z
	AA4jrGX4Vd9YzBDRyf4vGEVJdvcamn8nzsK7j4bF1sieKGcP6ZLt2nDpcsi6Qwcl3k4poFLtM4v
	68I6mvSLL8xsp
X-Google-Smtp-Source: AGHT+IHcU+q59/zdO9DEwOlbB2zFdxDyUb6T9cpL38qnSxJsCqK48oFjYOiXwo545smirO9ocba2jw==
X-Received: by 2002:a05:6000:40df:b0:3a0:8383:ef19 with SMTP id ffacd0b85a97d-3a1f64ac258mr12823489f8f.51.1747130327914;
        Tue, 13 May 2025 02:58:47 -0700 (PDT)
Received: from [10.61.1.197] (110.8.30.213.rev.vodafone.pt. [213.30.8.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f57ee95asm15731410f8f.11.2025.05.13.02.58.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 02:58:47 -0700 (PDT)
Message-ID: <05211729-41d1-4509-9312-8f60ca2a2cce@linaro.org>
Date: Tue, 13 May 2025 10:58:46 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/48] target/arm: move kvm stubs and remove CONFIG_KVM
 from kvm_arm.h
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, alex.bennee@linaro.org, anjo@rev.ng,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
 <20250512180502.2395029-5-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250512180502.2395029-5-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/5/25 20:04, Pierrick Bouvier wrote:
> Add a forward decl for struct kvm_vcpu_init to avoid pulling all kvm
> headers.
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/kvm_arm.h  | 83 +------------------------------------------
>   target/arm/kvm-stub.c | 77 +++++++++++++++++++++++++++++++++++++++
>   2 files changed, 78 insertions(+), 82 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


