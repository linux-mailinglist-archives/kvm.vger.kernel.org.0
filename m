Return-Path: <kvm+bounces-46326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F8ECAB5164
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:13:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E013F7B7C19
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:09:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68251250BF9;
	Tue, 13 May 2025 10:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ecuwczp1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD004242D95
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747130871; cv=none; b=NMn1/TIaDd0VtYD5AzHTffDjwnwJtjjJ883ikPHomYaIgSJ4PuA0AfuIN0R6/vktqYgRqy0l2b6NvvbmU95Rk5pQbrbu7nmXYUjawyDp32JiT0TcVJYYCNelUZvw9D4Azm1x7a/rXOZ4mJ9ngmXlSXJuhQuT97LAvdUKicN6P5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747130871; c=relaxed/simple;
	bh=kqKafGbIZsYKk8Zhbxbx0TD1p6gu+vnuK9h1UF++ZhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=APDEvsHdV+jimWMhIHDGrZUg7RM2F+yerJZvmit/UIZHsR586pkEg2ZvuDUS9ivM8o34z7Ls8lXxtJU1pLeTTwY7yXMmVXGUJydVz/fEtyEm6cjyBnKNg2r5ty7Fq+X1pHXiXJFHlOz/Xcs8qGb2WSbQ9vPtSJ+JwhomFzkx6sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ecuwczp1; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3a1d8c09674so2868568f8f.1
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 03:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747130867; x=1747735667; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q5InSWHz49sEJKfoQ2QNQ6ZQPGuqc5C2fmBxgyhIp60=;
        b=Ecuwczp1uYQ7mPZzzTs8sBuuRf4e22xUiW+Tz8M7iZS/x68s90lpmIzArzAkB9344X
         Z/4vpbWErQCol+nhWQv+sm8sStr5RKY92wjNFBWUIXwuqhMFuwzVtuUB5zd4N6azTkQB
         k+8oehoPorkSWrQ7EGXL+Y5P0wwwvDkJ5XnagD2/AYtIndQKLNOPigJTAkxf5dGuiHuW
         28nfrBW63MX/098O/XnDOOKM9IgGS7w2xpZsGUQETudot6TLI5h+8u050jlALl135ua/
         Ts2h144/PP7+6PmDa4ktoRGa2unMN1gUOZTthrQsJQ05/GzMmabYsOoI1pb4Q9htyoQO
         mDMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747130867; x=1747735667;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q5InSWHz49sEJKfoQ2QNQ6ZQPGuqc5C2fmBxgyhIp60=;
        b=KKAz6p7YlTn4dChWlLhhc5fCDAoBoyrMSOkkk8qCQZ+V0SITtqH5/bNrbWf4IdG2Hi
         Yl5YB/zPb0ywy91kYNbIxAASV1tXGOmBl35kk55zfrtsEpIdJ6iE2dHNl+jumsFEtoUp
         mDZSHUtAE3QphdjMzd+19HaSunDr7NhWaAX6YLRIW7uP+JQS6Ei4pguJ08Hznhjb1qEw
         uOT1Nal1ksUhccs2jYVIZragCrCp+nE2WJ+9Gsn3Rn4SNELPzIIdKkJ2jQ2expE3A/d1
         pGJNgDw59d2O4ItWB1DOvjY8cVJop/Og5kQzhi9kaKRR0MOs6f5/sSxABscxS8KjIaC3
         ljag==
X-Gm-Message-State: AOJu0YwxO4OodABmLO46y2GxuASAPd4N7AEeot/7IiXT4bnAhmi/D3Qd
	yHowXtPkUfB2n6vpcJZpNEvYSGojGF07nZL6di2HIbpFXk9YfDMZ5aTQyJMpB/c=
X-Gm-Gg: ASbGncuapKYfJ/t/aFoMBOiATziSHknYvghGmnPVJmAbDRTiu6WCIVr4QNJoFsrD46l
	x04BuRozWo4unFaNnObRXk/jLHa3IlZKoD47FD8jjD9ir/8vCFto/m3/YnfVmqda8jzRBK1kwbo
	G1YZJSBdkF74eENSOUVPpSMo83aLUzDtnJnniBaTR2yqaV+pcQNaaCyspcR6C8dzCDcbHPoXSp3
	YN9IZBGLqjpwt76cXe9Y6fmN1V+fXDknb8Arz/L+Lxc4EJkYTo0Nox8Slq8o7U0lCRV2S1dHSYj
	C9TLltT1CRaF//2YYM6tZDjyRaVnRDvEh7ZkI4+UC1jZvhoR3xjAlCpOPwWHBs1nieAm0WYjZcp
	x4DaHln1yEiNa5oCj9g==
X-Google-Smtp-Source: AGHT+IEOnwxZ1JusNsoCvG1vd1NMxSbChqXI542igsHv2GaoEABqup6FroB8iwhfyjOBtmplA56SdQ==
X-Received: by 2002:adf:b34a:0:b0:3a0:b8b0:440e with SMTP id ffacd0b85a97d-3a1f6482d4amr9896034f8f.45.1747130866873;
        Tue, 13 May 2025 03:07:46 -0700 (PDT)
Received: from [10.61.1.197] (110.8.30.213.rev.vodafone.pt. [213.30.8.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f57dde27sm15954772f8f.17.2025.05.13.03.07.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 03:07:46 -0700 (PDT)
Message-ID: <f5c8fc6d-35a0-41a7-864e-ae89713f8f9b@linaro.org>
Date: Tue, 13 May 2025 11:07:45 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 26/48] target/arm/arch_dump: compile file once (system)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, alex.bennee@linaro.org, anjo@rev.ng,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
 <20250512180502.2395029-27-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250512180502.2395029-27-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/5/25 20:04, Pierrick Bouvier wrote:
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/meson.build | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


