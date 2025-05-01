Return-Path: <kvm+bounces-45124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91E47AA60B6
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:25:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D6659C51E5
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:24:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 183DB201276;
	Thu,  1 May 2025 15:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uXVYEOgi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB59333C9
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746113097; cv=none; b=MYZiAo+lvPNksOfa5qId0gZKIRf3kx7Rqxjo4eXQeMH2msl0bb2PNqqVUZohhRVOx8wW6FUSaxm2LcEwCfjMiMmeE/QN92sWpwEs/gb4/yOYxtcK/veTIvc8DRH9qDzFrtDLEcNQCz8wdn59Jp4a9rapAP3shRm310DanFtGx24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746113097; c=relaxed/simple;
	bh=pIuU8e85zKyHS2R42xKTO/ep+7If31s5dSrXcgFKXtU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uvzXT2ffTJ1C+KWYJaBERe/dehUceET0iREYnEvKGVbes/izza9kHxO/j8mHjpn3OxXKpFe6Qy5MXqprCJsglIyolilCHu7SKdFqBn0tvJasjBqPI+rYf0bCp5YlydytX3re7STr1sn3+a+K1cguVIhNH44iPP/+5O8G4hhmiMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uXVYEOgi; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-736a7e126c7so1020833b3a.3
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 08:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746113095; x=1746717895; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0vHjLZIKMAcpSYJ5CKGfm251JpODp3KFOdq9sZMqTe4=;
        b=uXVYEOgiLLN000SOGYAr9IH4Wi0FGTV7HETCCgPAldgQMWOxInRFX1TFGHh2/NGvXL
         AqlLfFYW3YzW+Y1rb0zvRK/fvhWnJUCiCKFbLf2x3S2mTax4WoY4FnV3S3BBqrvRxHUY
         4VSyQWIx2QCBKiSrKTZ7UEWFcZo6Segy7XDiI6Pz+THzaBexUq1zKCBF22QneIFydxvY
         ph+/l5UJN6anr/XKlSB2cP2DJZS9I3v/d7+FFAn9EcR7v+RqA30EGiPHwi4yy5gLttc/
         XR9vsBEJjaPnirGMofqTUWDs7F+0UcC49KvOuAC1Oc81h9jlGofwvfing3ngpIbGWjc+
         j8RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746113095; x=1746717895;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0vHjLZIKMAcpSYJ5CKGfm251JpODp3KFOdq9sZMqTe4=;
        b=t7alJ91ksOgII/YPgidaytrfDxQjtLGdeRzVsAO5b9EjiBR9lFszq8k3J2lsYptfrE
         BHBEUvXUba8aHOWcnlrMUWvVAMDerCF2ZnYzShy8I16bR9DKmSLd/pNUeUZHxcAVyDDD
         Yqal+seHG+JCg5KUAAQyCdjDo/l+X7l4VBu16PcsByzsT1BpKmLB26upumO0fcN493+e
         qZuHdJgbQk/YdUqVdn6iFklUn4JT67/wW67N2rkKuwqRI1sYYt0tI5/EgyW5Lyzf5Ubt
         zfMmKoaPge3RUxT94hMsm7bFfdEbK6Z6DyIOhUttTyltfnVpkiOzehSdqb31K2T3LmR3
         5sdA==
X-Forwarded-Encrypted: i=1; AJvYcCVoPU6GjYgWlJxQos4uZaTH0WqjzNT9j+Oj2JtcTKBET8Uok6tHqYrJ7t0DrLRHwr6Le68=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEQva6xzI84TANYIHeaybd0H4AhyKZFlIF9+l8PTUR+hGlRnh4
	OYWbPCeRD8hgESyg+833j+7xIhvL6E9cJV5C8+VI6oEEB9+++IPkPdW7GUo926M=
X-Gm-Gg: ASbGnctYc6wbadxv4xUwooqSygnc1k0CeYdlQFmVScZue7BCeaMR6xQB41k+BHUX7Gh
	o2X5pH3E+zlpVhLF8J3e3+W1+VTk/QYEwjh+jZNdmTl9iRdB4UyqFKEKqj2sQTHWZntO0Yfv3sF
	hyl69xPBeYPVgNqppjd4Z+jghe1WQGjo9FjM2YV43Eq9qFeoEievuBCFnv3yEdieRzS+Rtb9oWz
	21+iwLOx6wPL5Ma1B3kQbDMW6cxcBcAW6fsXJFP9WTlw2xiRE1hQfH2GBjtut38l0wbHkXcU0jH
	s7YCFEalNhP0fyCK+CSUz4NNVBXkLHMAbQ3454gzoCVkuKRvM4YpH9toqg0nRSQ4
X-Google-Smtp-Source: AGHT+IExeTBVUyRMlLYCEVZym1i0z0bgdXtdjFqSFp4tC+pPFl63Tb4G9p16DCpNKUe4ciqiRFLCCw==
X-Received: by 2002:a05:6a00:2181:b0:736:5438:ccc with SMTP id d2e1a72fcca58-7403a77bbf0mr8990694b3a.9.1746113095022;
        Thu, 01 May 2025 08:24:55 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fe765sm940821b3a.108.2025.05.01.08.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 08:24:54 -0700 (PDT)
Message-ID: <00710aa1-2a44-4778-83da-05cc125506e1@linaro.org>
Date: Thu, 1 May 2025 08:24:53 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/33] target/arm/helper: extract common helpers
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-16-pierrick.bouvier@linaro.org>
 <8f480fa1-609f-4b90-b6e7-02a76d2767d2@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Language: en-US
In-Reply-To: <8f480fa1-609f-4b90-b6e7-02a76d2767d2@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/1/25 8:06 AM, Richard Henderson wrote:
> On 4/30/25 23:23, Pierrick Bouvier wrote:
>> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
>> ---
>>    target/arm/helper.h     | 1152 +-------------------------------------
>>    target/arm/tcg/helper.h | 1153 +++++++++++++++++++++++++++++++++++++++
>>    2 files changed, 1155 insertions(+), 1150 deletions(-)
>>    create mode 100644 target/arm/tcg/helper.h
> 
> Why?
>

It allows later commits to include only the "new" tcg/helper.h, and thus 
preventing to pull aarch64 helpers (+ target/arm/helper.h contains a 
ifdef TARGET_AARCH64).

As well, for work on target/arm/tcg/, we'll need to have aarch64 helpers 
splitted from common ones.

Makes more sense?

> r~


