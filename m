Return-Path: <kvm+bounces-45167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C135AA6419
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 21:29:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23D011BC2E5E
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 19:29:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D0F3224B15;
	Thu,  1 May 2025 19:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iiv0cEMP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8E3367
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 19:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746127758; cv=none; b=FFj2ZNsCSy1gR0NKe1Cpaxvz1iIy6/1egNiV/KeMZFMB28BNpDPMcle3W4cPHtVCS9Tjpex8MKKR1L5ji+aAua931qyp86r/1N54X1jeIVd7ocnaIEec08HynfMlPke6vH1KTeopezvQFZeBLatT3Qk9Fl+it0+eGz2rd8ud6DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746127758; c=relaxed/simple;
	bh=t+wiF48LIL5vAlGLUOg8mvPTIrGQ0dU/5sMdUrqByVk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r0mD5DaztAKVXFU0PopbvOjVyjpS0p+X7GnSovReBPsfYDTNT9RSh8WyXk7U1UyaM4LOD/d5NQ0HbDCJI/GLG2j6NRH9falsk5yondSTreEJhn14QYeQ8DOBana4R2WzDlkiNTiDNxOCKtNm/LCEqDgN+0lVIV5roUZgulVAa+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iiv0cEMP; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3d938fcb70cso4583515ab.0
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 12:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746127755; x=1746732555; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cOHSlVnVUYbsq+LzS7RdKhTmiXHT7BnynLD9UnP6g6Q=;
        b=iiv0cEMPzVmz4zQWOMFqVv9hTbTMhsk1U5kh0jd6gwLVuW26QoUaYBtdcI3ObHaBrP
         LCD969z6GJ9CDalxEnBytC3PZOnv2KWYGusuj4IS7KbIbItQ+Sq0RT0e9bMLJxMUBI8S
         F9QwH/+t8PI20+PbDGgcxYXWmI1/+WPbePeytsI4e3xKYX/wpfZAswgUhGdMCa+9VfPf
         BC4TqwdThb+e5O/jyuX2GE9yBSQz22awkAInT3amw/t4E+XsJGeP9PQI7LE9KPV5ygg0
         woanl1r8TLx1zJKBkn9SD3d7h4VGRb/QPJjYQ186Hx3nwCOupz7geg6278YvidoX5FiZ
         gYxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746127755; x=1746732555;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cOHSlVnVUYbsq+LzS7RdKhTmiXHT7BnynLD9UnP6g6Q=;
        b=H9t/mQY9NOm57WbUuHTtMcnfdffvhmmXQCFVakyXZ/9muVfWBaEZugzaXPoYtN3JI7
         iHgLvaaG/BAtWNczNYgxIWmNsnalgJiB0AQfQxcgIpsXLaU/0O5mQP8kKknB9ykt5fpC
         bbcuUnj1J7aIHXd/mnMdFLEishfq/KHAE8l7xV2lbSsSJNa9hMT/bBcEtHJELtKnoecF
         g9K+D9qTsudGo8CWGYY4z+8LVWJwvGw7zl5yiZBHYy2gAyJSi11uub0Kr61QWZ0R5I20
         L/L4qNZyAVm/4/gsjTJ4c77YsK5VZKrqRUfi1wN6hAzglqC+ey1m8H8QMENokto7EVRZ
         KDkw==
X-Forwarded-Encrypted: i=1; AJvYcCV5GYlhpdd6VxHCPbW34XYRnG/UtuVKmmTxKluryqI52i9aw6w6NT399hJumRvXyBctT+A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBLVoIiGr2GFwKje00C+yDNuXeoz4AVBToQ6ZmUl9Q+wHREHA8
	xCGy9SkXkJVjd7d02yOz09duIfHwxgSl0YEzmy1SKCv2v8jmEdpl6JHWS5Hg1sk=
X-Gm-Gg: ASbGncsUICgvPvM+006X3TJQu0eFCRbNQ6XOidL3tUmBESwOBDkGFnF2nADYeFDD3H6
	CdtDdT+7SEhva/o9rzzMcBBVqtf5LsklLljGK2x+OYh46re3vO/LqYjTVTEuwZuyrR90krJkCG6
	Qui5nev0fs36Sl+h5JZ+deMVjqH1ciQVUGi41lR6bdqdsiVhU8KMtQNb49HiJXi+kSLALXKaDmO
	PIorjI8WfL2iCNLyXAPKLDS47ScfRrzjMyMgx6bmC6Lfs3bHPLqpjB3++WOwVm/NQhthlegAYM4
	1sF5A+TdqSL3uy6YutOly+GnJns8/YC39XPDJCZlfiYXDD0zoixGUVSXlTxf8qnXeiBoc2vQJVR
	fHabjSH7mtFY7UA==
X-Google-Smtp-Source: AGHT+IGmmsBx1v0Mc9NmngwCAaVLMxSI/zjfAdzKAyEaHpmHH+kM83IMv5j4FaPz2DvLozh56NJhYg==
X-Received: by 2002:a05:6e02:1a85:b0:3d5:81aa:4d0a with SMTP id e9e14a558f8ab-3d97c1705e6mr1486405ab.6.1746127754958;
        Thu, 01 May 2025 12:29:14 -0700 (PDT)
Received: from [192.168.69.244] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88a8da518sm12648173.16.2025.05.01.12.29.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 12:29:14 -0700 (PDT)
Message-ID: <e9c82559-77b3-4e5c-bcd1-05e39c8c7dea@linaro.org>
Date: Thu, 1 May 2025 21:29:11 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 21/33] target/arm/helper: expose aarch64 cpu
 registration
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng, kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-22-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250501062344.2526061-22-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/5/25 08:23, Pierrick Bouvier wrote:
> associated define_arm_cp_regs are guarded by
> "cpu_isar_feature(aa64_*)", so it's safe to expose that code for arm
> target (32 bit).
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/helper.c | 7 -------
>   1 file changed, 7 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


