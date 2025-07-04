Return-Path: <kvm+bounces-51558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9E2DAF8D0A
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 10:59:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CCEE3B46E97
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:33:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FA972857E9;
	Fri,  4 Jul 2025 08:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Uyg4sHmn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DF328A41C
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 08:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751617455; cv=none; b=JpiojYM4/aNMDv949rNSScSZ/0MedLoYFzRBMtQ561Z9jV3TP4itwKxI4H4c5d0vozy07RdF4xSB26TCmPmphcCNXrSg6AN2Ektxzndc2VE1lCz8nHSvwewFhI/xLeoprKEukas0W2ZusEk6kDjczSIp67bsZXmNGtPRZFoCZRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751617455; c=relaxed/simple;
	bh=3t5ghVz6DHHGFPX5js32sJ17AtW18gtbRjNssDlc9jU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GwYTW9DICgBdOwqaqhtrbPYEcDrA7FnvEkHzXsgPBMoLm/anCH5IbBpkLMuCXLzam/1ld/CcVjlUZi9Lh1bIyxjibV8H33e7yx7DJT1g3J1uWy3xLNNR4x3GT/ICCFnOhTm6M6++pyvWEV5JPM12JiiUmBZOPENW7pRAXzAO6BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Uyg4sHmn; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4539cd7990cso3935225e9.0
        for <kvm@vger.kernel.org>; Fri, 04 Jul 2025 01:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751617452; x=1752222252; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gbVbXkk5gDrDkKIlQNzN2k5Qj4CadpnxfSGFBliSJPE=;
        b=Uyg4sHmnBQODeD214bLXOdWpFGZZSr51FzxBR/7bEYuWXwbsYBvYvuIxFEymMPDKqt
         jAG+HEy8V2kYR6JKWv3YCyoPcycIPCObBgfEj9sfttFGiF/y5pZGhm1uSR74UMumVY1y
         haEFEG2oohe3oPy+uFqIIhDV9LeqA7ERCKNNbzFBmPW1/RGaLi6No/NnIPDvJ3RcvKTN
         wgPQfRAqCdJfCrtlJ207bVYqV96D0+LY0zIPRw1fX90amZz8nzevTXNLg9CADGdizxH5
         Mj+pFf9GskB/BlxK3zerR6kbLc2V+3OPn0g7lCFBwVKO654nq+iR1G05B3Q/6ePvDAN0
         X6RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751617452; x=1752222252;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gbVbXkk5gDrDkKIlQNzN2k5Qj4CadpnxfSGFBliSJPE=;
        b=symxPJcMmb44RLoRjdvROJ490FtM7Xa727z58+jBIKW6BP7J5137zF7HemI/DN9kbS
         nKe+7O9LBLv//gppIIrqT29eCWaPJqX3AWG3XWMCVGInxdtcsZu8TUgrxf0xRsSUOTpP
         q7GgRjoXk0S6B8H4l39Y5ZB9RMiVbosYmsH5mwSCXmN8yPg7/RpB2csN/uol/dEycbKt
         3Encs+gB4V1Wzp6xsV8r6QqceHZEFmJQFZ4UtDaT4AltRu7uzAcSViM1VDg5MCUvhZRR
         OAOvdf+fSblGHPHpqXCXu/HD0rP8PJ7obO66u6k5lvbo2WiV3PnAR/CexG3O7dqLutbk
         SIXw==
X-Forwarded-Encrypted: i=1; AJvYcCWvYN9Oydm/ymesn020qumOyyWWdBd/vz9lzclHulIHefCyuOPy9vnajkk/7Ti0J8MYGAM=@vger.kernel.org
X-Gm-Message-State: AOJu0YydtI4DrKnu0l4x+K2/C80bS9tnVsiwSJXZvoHFxhBKf7lUXd7X
	I4kHr3Kl/h43Jk/VhV1b634uJDulaVuf3slPODz7T3V6xNs97H0Qwz3g51cLEl6pZ00=
X-Gm-Gg: ASbGncvRV+BQax2PQHRk9NqexbnXdJrHHMJluJK+k+HYsNiDAlhbnMJ9Z7E+SFmD8Y/
	i4DsxTQba3mP6318bTCsgtIhZeEmmL0n2fMjB/g8HrtgSdn7VjR0LlTLj1LvzS8l0dv7kaj5Z7X
	WdffLA9BO/6EuPPorhJAaBA4A2M4VM48FR3HtAaUICda4eKL6jzerX4Hjt8Ne6ifAE5cbdkCPfx
	tSwxAqgxooDQCB4VOdWsbRsP5oqs4GM5g80V0MT2VKctaegGm8TEc6mAijLRyOgxdJVi68euymz
	LX3eCZWdoyoyIb9FM5P1qH8nkxk77WWjD0p2M9DgE9GyRHiIsCUkLbpdh+5lTCWg0dmo5WuHpnW
	hWtjPP8/hUvdrnCR7tbvAwNLveGsX1g==
X-Google-Smtp-Source: AGHT+IFUpR6YVd+jwwGoGAPDXDizijOZsEJuq4QgesB8hsZrhPWodKx66l1+jFS6o4KLQyfu2as9sg==
X-Received: by 2002:a05:600c:a385:b0:43d:5264:3cf0 with SMTP id 5b1f17b1804b1-454b1f63e81mr14382345e9.11.1751617451892;
        Fri, 04 Jul 2025 01:24:11 -0700 (PDT)
Received: from [192.168.69.218] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454b1893479sm19374815e9.39.2025.07.04.01.24.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jul 2025 01:24:11 -0700 (PDT)
Message-ID: <7e3cd619-e934-4c2d-8ac6-a9d9bcdc798d@linaro.org>
Date: Fri, 4 Jul 2025 10:24:10 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/39] accel/kvm: Remove kvm_init_cpu_signals() stub
To: Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>, kvm@vger.kernel.org
References: <20250703173248.44995-1-philmd@linaro.org>
 <20250703173248.44995-6-philmd@linaro.org>
 <9292a723-eb6f-4106-bbf4-e046146686e4@intel.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <9292a723-eb6f-4106-bbf4-e046146686e4@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/7/25 06:13, Xiaoyao Li wrote:
> On 7/4/2025 1:32 AM, Philippe Mathieu-Daudé wrote:
>> Since commit 57038a92bb0 ("cpus: extract out kvm-specific code
>> to accel/kvm") the kvm_init_cpu_signals() stub is not necessary.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> 
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> BTW, it seems we can further move kvm_init_cpu_signals() into
> kvm-accel-ops.c and make it internal static function?

I suppose we can if we move kvm_immediate_exit to KVM's AccelState,
but KVM code isn't really using it. We ought to move KVM specific
fields from CPUState to KVM's AccelState. Not a priority.

> 
>> ---
>>   accel/stubs/kvm-stub.c | 5 -----
>>   1 file changed, 5 deletions(-)

