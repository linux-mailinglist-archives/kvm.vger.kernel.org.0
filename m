Return-Path: <kvm+bounces-42279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCA47A770EE
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 00:38:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93D311696FF
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 22:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACF4D21C19E;
	Mon, 31 Mar 2025 22:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="upVcGcSc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AECA2147E8
	for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 22:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743460699; cv=none; b=KJRDqg9YM9obTdI/pke/iqRmbzBuPE8O9kZhGd+/0f/ghzKImbClXtZbHJHFyqxRt3D7TCILfrDRrn9WT/JDw6ffFBJv9bm2KNPdMK/owQaQJOX7oSdXqWcWZ7suJHVuDupIVabOwAxOulsEi9Xivl8pHiHDC+OJcSqN+3FRjT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743460699; c=relaxed/simple;
	bh=KoMgcSuixbnp66xJFAkSbOizvJgxGclUCe10AWlP7xo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eeyqQAXxI9rjHVk1XR3vvGjYNnkk9A51ZtaAzP30NgKl9cLsCon02W7xOBZxZDtwsXl2Xp8sTAW8jBbycgwmOn428cJhdl/4oPTD1JqjzmP3KmygEJbRl8SkHVjHUW2mf0+sTc3kKx6XLOgo2ivz8aVePeiz6DYYuswM5wPFBio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=upVcGcSc; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-72bb9725de1so1343986a34.2
        for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 15:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743460694; x=1744065494; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JFmeFNv5b+sarSdFqM1KTgUiqCF+rgnpm9YmSX1XlyA=;
        b=upVcGcSc37Dgk4T02UWs7J/ZjouM0MJM2EYtX7GRD26UMO2eyAAbwYG384O0x8UTBN
         HGyv735wCP2otOtFHOSXLk0cclWUE+8xl0vqMei1PmVSk7VQPCd63Vqxx/qrdi7bRZ7/
         NDf2jof/JMpDd9wmzBSg6k2mQtBNo6ICjAQMkdA6gmVdDt35GxwS8qjzvKNnYBXsoOtb
         cr2HFXdI2F4C5f4+gFn+inqgKoS1I2qhLDctn50gruGZ9xdovAxVzVCQAw5FtpQ/4Q00
         R41bpWyqxkKba7D9kPSyay7WzrX43mKuIrs7rRhx9so45TshDFqP3EkCTCQroEI5Xafj
         gWHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743460694; x=1744065494;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JFmeFNv5b+sarSdFqM1KTgUiqCF+rgnpm9YmSX1XlyA=;
        b=DDRABNjtzo80nSS5pFj2rob5aWEhCspftMc55DvZ8txH7Ga/blAZSZicbwVKygEdmJ
         S8BJzegIaVSJPmEZVtmClIV+K7cv3/qpMfmyiujCtK0VjdDO9uIOESShRGeuGoEAjXhp
         4HClSYa8FjhnNbiVi88FBf6/bMF6gE+kla7mBB7BH59bG8eeTOv4dAm0xdXvX1HLK7+w
         +GbMORnh1+UWcavdXAv2Q0likYW8IANQ7LLKqBDMlzwH0lmS7VfTBSaVGH/EBd3JlwiH
         CMDdt1a//MHIae2cjDfHwVQ4vbZCZR7Vwmi8uDyaqhP+Zb7XiOrr6BF0RZN9XLVgBZBa
         NgSg==
X-Forwarded-Encrypted: i=1; AJvYcCXd3kIKTZUmd93+rHXBpHV7ohXMLgdiWgfKkvDBjYOdLZXcrFEw5nN1UoHKLE56xwvy/Qg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjoHyH+5PWhKT0lBPHj8ocLeT9pPaIME3nZ/en/AI23p/jV9nO
	vmyqmHZQ+JjCP274ELngzQL+ir5VqLI7YaCq7Azu0217DPqoekkrcrNl5/Ybrtc=
X-Gm-Gg: ASbGncvb/ovv96bUW7IjGJRXmII1pGOB4F1WdVVOvTNJrAt0CmkHLjSub+XPfv6/rH2
	blzN00GAkwOO1uk6WYSzL4apSsRa3c8ob+Ecwcxye/3Mm6g0GHb7sYnNY5/eoDf76Dh1QPbIC5j
	uy92V4lb8yuNqskR4bfEa+6VOeMArcut6TS+JJyKisQphdwn0T3Fvft+AgrB5SewI5Kh3h/L995
	pEabL2viU0N7gU69BilugHqNNawclqxOvqGT5Gv363ch3pzU086q41sFrcM4gBbkoJu9Lv98dqo
	RQtJOfUeetN/pKIiv7Drk+VXWG+E5ze4wB8SSuRmKUwn4SpyUHbHWzpI/z/FbGhuFgIbtOpitYY
	X8N8a5Yx3u/Tzy+gCyMqftg==
X-Google-Smtp-Source: AGHT+IFp4S0sxIEStKUL2jwfRULRLxxT9HOP1p+IccXKEUBs1mtFo8GXdZCPU0pP0z9l1XZXK8r0rg==
X-Received: by 2002:a05:6830:6105:b0:72b:9e3b:82bc with SMTP id 46e09a7af769-72c637a4ccamr6064468a34.11.1743460693940;
        Mon, 31 Mar 2025 15:38:13 -0700 (PDT)
Received: from [172.20.102.85] (syn-071-042-197-003.biz.spectrum.com. [71.42.197.3])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-72c5828ae93sm1634203a34.63.2025.03.31.15.38.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Mar 2025 15:38:13 -0700 (PDT)
Message-ID: <22353929-7c53-4c96-b751-90cbaff82d7c@linaro.org>
Date: Mon, 31 Mar 2025 17:38:10 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/29] single-binary: start make hw/arm/ common
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/25 23:58, Pierrick Bouvier wrote:
> This series focuses on removing compilation units duplication in hw/arm. We
> start with this architecture because it should not be too hard to transform it,
> and should give us some good hints on the difficulties we'll meet later.
> 
> We first start by making changes in global headers to be able to not rely on
> specific target defines. In particular, we completely remove cpu-all.h.
> We then focus on removing those defines from target/arm/cpu.h.
> 
>  From there, we modify build system to create a new hw common library (per base
> architecture, "arm" in this case), instead of compiling the same files for every
> target.
> 
> Finally, we can declare hw/arm/boot.c, and most of the boards as common as a
> first step for this part.
> 
> - Based-on:20250317183417.285700-1-pierrick.bouvier@linaro.org
> ("[PATCH v6 00/18] make system memory API available for common code")
> https://lore.kernel.org/qemu-devel/20250317183417.285700-1-pierrick.bouvier@linaro.org/
> - Based-on:20250318213209.2579218-1-richard.henderson@linaro.org
> ("[PATCH v2 00/42] accel/tcg, codebase: Build once patches")
> https://lore.kernel.org/qemu-devel/20250318213209.2579218-1-richard.henderson@linaro.org
> 
> v2:
> - rebase on top of Richard series
> - add target include in hw_common lib
> - hw_common_lib uses -DCOMPILE_SYSTEM_VS_USER introduced by Richard series
> - remove cpu-all header
> - remove BSWAP_NEEDED define
> - new tlb-flags header
> - Cleanup i386 KVM_HAVE_MCE_INJECTION definition + move KVM_HAVE_MCE_INJECTION
> - remove comment about cs_base in target/arm/cpu.h
> - updated commit message about registers visibility between aarch32/aarch64
> - tried remove ifdefs in target/arm/helper.c but this resulted in more a ugly
>    result. So just comment calls for now, as we'll clean this file later.
> - make most of the boards in hw/arm common
> 
> v3:
> - rebase on top of Richard series and master
> - BSWAP_NEEDED commit was already merged
> - Update description for commits removing kvm related headers

Thanks.  Queued to tcg-next.

r~

