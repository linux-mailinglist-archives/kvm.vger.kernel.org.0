Return-Path: <kvm+bounces-46251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FF8BAB4343
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:32:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8C6A57A12CA
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:26:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F194729AAF2;
	Mon, 12 May 2025 18:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZHfDUIw8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95030297120
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073450; cv=none; b=U7J5RQyvW5BbLGTZZN/H2mAIRfYoLdsiAQ+V71t8J2+4SIIZplB17PyPFQmIdt8yTgc0HpkbV667FXmeN+FPg6OXnJmjktcCl2TDn3YlYv7gaoeA4XyUEbFAR06S8oi9wkUUIz1+5+4v4U4q/Xq84k458dxK462Gjg9UUnasXpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073450; c=relaxed/simple;
	bh=/EyFyBwy8+t304OhEdTGDpk9RgJvtUYC/go+GIWHH+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cVMH2EfIDOF30UbndEGd0rLYRwXrXM8tEuG0xcjdccIkkeS6KPNj59nK36+VLtPvhaHMRCvoHUzBVNCLw7XOQqsbj8dQP4sDcoxkrNgYDQTZabc3Sqy/ybFvsh5CFc6d7jnbIX7DizqNaHSB4ixVbt9PlOjxFQ0gygqjnkj60TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZHfDUIw8; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b1f7357b5b6so3003397a12.0
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073448; x=1747678248; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ih1/WMG/Bvz6RkifhE4YJa1IDYAyJ8Bjd0bveBKxKIM=;
        b=ZHfDUIw80LrsC2OXhj1FfxoEtcnM97pnOQ6ilvEDglBJNaHvb3MI+k5gQpMJUmKyW8
         WdOVkp5F/K7stdUHnCGJ00WzbTNrziZ4KuJOuTbn1Qw35uzkMnheNWkglHeja5R4bXIR
         oTc2haV9KCRcm7/c8cWGNi/5l3o0vjDRFyXIgwHGCOX1iJWW9b3fTI01Dh0ShYq3OSIW
         c2oXEF4RorwDC5HnWoHz/lU5FlNhn3zxMBUGPr801XLWbKPkMPKTZfmi6ycdtcDO+pbM
         HLshwu5WA7vSpnBnqyzaBoY18fpuxU+MeYddF97FL4xLidxOykhBckdN6IYihHUfAdeA
         HXrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073448; x=1747678248;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ih1/WMG/Bvz6RkifhE4YJa1IDYAyJ8Bjd0bveBKxKIM=;
        b=d+5IFz8xB1gwjJMzLC2MM9Tu/a505I1o8e4cXW0bDO5AkzGpJ2pVmlqdDtghLBio2/
         1EfJHI1zMgf3DI56uNAOeOjrUOI/ZbuT+qFc0MohAaL4kQH1yDuUtWO1ZDfLQAPZ7guo
         LQ+2AuAr6fM+lvorIXikQhmr508ngWTohhzPbaIYYPjO3R3CSKwbaWUj0c0Qs+RA/zTJ
         5fimbZRhltHt0+6SLw20HqnJ4TXeNiPWW5mMLZJyhg0V4J1Y9cvRo1eSFbJQ8eFhO/Rj
         TwX9nxCZ/+D7x3GFXMpWkwahMUtuNOIYa2YaQgdx7EUyGCaoldFoG0mxa1KSgJBfE8/T
         HoKA==
X-Forwarded-Encrypted: i=1; AJvYcCWO9CNuEpivV3zTzyS67f/T7yjI9dW+jDyn/Qxn7Z/AxvWkR5WyBuUx+7II1hzONPDiyUA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwM8Ha5rtHmqmdRdhsmTiPzYDJliW0zBIBgVrVX+/aDKieaO3dD
	ohp/cjhlqgNE5vhvnsOR/0r/4Yt+Os5Riw3kYXQuZ9oeoLjNtu3Ry7MI/JEKxmA=
X-Gm-Gg: ASbGncutyXHEJK78BlekHGaXQe5V+PP+seERjtctPjUi/Y3gfjSzZ6tGMik4JLkRBNT
	YOwBUpBBt83pPEcTlEpcoIiAYYRWUWEojw5Jjo1wQDbIis0iqmFVDT9aI/upsB5M/tY09Lqojfn
	ya5l4hW9rH06eDaOY6LCWcbbMxffNE9JuzzqGFypAb5aDyidUZzd1cRalLMOxfZt13mg3JjsAu5
	G8qOoaNoyvDjFOJ+Jx/4bXRcGJeOHwPgWB3Uz82JAO02v4XbjcDDVGM+F5X8MgUBINL3MOItJuB
	8x87FIkR+8s9j11Mpuw1KnO6sfPqoHCIfemQxutMWPJFJRqqZky6KpFe/Fkdr37j
X-Google-Smtp-Source: AGHT+IF7cjh160/3os9miThpQ3cQjhGE0+bC4mKm0ylUowD5kJcPEGlWgg7VcP5nTdLVEsStyUuIzw==
X-Received: by 2002:a17:903:2f89:b0:224:1eaa:5de1 with SMTP id d9443c01a7336-22fc8b51ac5mr168985615ad.18.1747073447682;
        Mon, 12 May 2025 11:10:47 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc829f354sm65646295ad.213.2025.05.12.11.10.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 May 2025 11:10:47 -0700 (PDT)
Message-ID: <4bc309ba-ecd1-4a4f-a717-d9ca71b77333@linaro.org>
Date: Mon, 12 May 2025 11:10:46 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/49] single-binary: compile target/arm twice
Content-Language: en-US
To: Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org, qemu-arm@nongnu.org, anjo@rev.ng,
 Richard Henderson <richard.henderson@linaro.org>, alex.bennee@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
 <CAFEAcA_NgJw=eu+M5WJty0gsq240b8gK3-ZcJ1znwYZz5WC=wA@mail.gmail.com>
 <726ecb14-fa2e-4692-93a2-5e6cc277c0c2@linaro.org>
 <CAFEAcA_WtAAba9QBS_zOPUPtjdeDv+0mDJiTEepHS2+61aZERA@mail.gmail.com>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <CAFEAcA_WtAAba9QBS_zOPUPtjdeDv+0mDJiTEepHS2+61aZERA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/12/25 10:05 AM, Peter Maydell wrote:
> 
> I had a go, but it seems to depend on some other patch
> or series that isn't in upstream git yet. Specifically,
> the changes to include/system/hvf.h assume it has an
> include of "cpu.h": you can see it in the context in
> patch 2:
> https://lore.kernel.org/qemu-devel/20250507234241.957746-3-pierrick.bouvier@linaro.org/
> but that include isn't there in upstream git yet, so the
> patches touching that file eventually fail to apply cleanly.
> I assume that's "accel/hvf: Include missing 'hw/core/cpu.h' header",
> but is there anything else this series was based on?
>

Sorry about that, and wasting your time.
I rebased, checked patches apply, built, and sent v8:
https://lore.kernel.org/qemu-devel/20250512180502.2395029-1-pierrick.bouvier@linaro.org/T/#mc1b30cb98e11932458c1566ebe50a4efbc10473e

Regards,
Pierrick

> thanks
> -- PMM


