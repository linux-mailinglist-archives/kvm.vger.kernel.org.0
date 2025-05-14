Return-Path: <kvm+bounces-46416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3B30AB62CA
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 08:12:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E85EB7B08FE
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 06:11:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F33EE1F9F47;
	Wed, 14 May 2025 06:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="a25gBO47"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F8717BD9
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 06:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747203168; cv=none; b=KUr/IVV78MpF1V+6TPjVKlz6uXDlddmRONgCVNGdp/yl8sit6hXMwOoSCgAGzJdjDghdGW7KbjJfoCx8aIm62FGBe+Uo6FW6bgr+zfcnCqHjYseT/SOrnnrO6E2rKtJN1O/ndiWfjb5nhBNyU5EkycNj4MFh5hcry2vs+MjHHpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747203168; c=relaxed/simple;
	bh=PV8p2pfmkvi5Csj/Kln7AzWFF2zZ7rC6KbWxc6D8AmQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kd6EO1Zz2+1dj11b3DSpX+8rWVtdauzls2Qjdcbh+2jGp9x248qbGOWEaP1KWCGNTw2IKQlKAKMkEjWaMwkjHIR2Lb6oYCj8KO4YzGoYOMATQeiQiEXWDmOlapGIc0MgDr/Yn2aztRUEcHtl/EoHQppq+P6d2A8soMdamrgg5As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=a25gBO47; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a1b8e8b2b2so3436214f8f.2
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 23:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747203164; x=1747807964; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pJP3i5Ja4tsH+USF3De857L3YIRU0Q0edmiA4knXpsM=;
        b=a25gBO4735UV2HzKZoUOVEeXt7RG1ZfpHBLxg9smbT+wrpZEBcb9QljT+hzMVKK4iV
         SSa3LC3UrT7rs3mTdRfiaGVwm31+gH+os1hwRs0YE+lhP0y9JALMksCMTaopQONYD+3x
         0oPyuyQ7WOijHoz391KN/onuCa0ziWDK4Kqy2P4oPxLC8tRNePh0KFzypCdtbx5C8Tcy
         wkmh8URR5YXzmOr1J2rRHOMtxnv0+jQlMxt3oTvfMH4nbTfMElTmpp3MeNsXojkcUGYc
         P06D2jfTJA8EzXo5u2rhIuC4t7iM/L+Ay8MDFqq2BRNlbSaS3O564WO107xXe5GpQyQ5
         JkMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747203164; x=1747807964;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pJP3i5Ja4tsH+USF3De857L3YIRU0Q0edmiA4knXpsM=;
        b=m7L3Z5BrpeGYiOnBl4Tem4hLbGoSKKCcHpL4mupImoY5ONc7YiKcBfghPD//EVxZSC
         g5nXlEgDSKandqSEMFdZ5ZJ056LCeEA7amdURQeAAKZOwIo2Zndz8SdENk+XMK4LppFa
         GoblysbFTRN12+6+9PJpCPVuAzrWRYbOH55Im2inreu5xm8wCB4VzX4CiAZBKO5U7/ld
         BBlsKmQC4kiLKhbqWN53rJ9MrmeTVauIcuhtxc5cJFCZG4elzlIuuekYm/kckNmmim9y
         hLtx3CG0q4sCaqQohgc/LohQcOAdO2yUsY+Z38Ua7Rpun6kSIdesmsOnPIfZr3upgbNP
         SH4A==
X-Gm-Message-State: AOJu0YxcCw8WfoGQ+h7FHVhiLa7hensmVFjl04dhamtAGW9SEuu7IRKR
	wVeabSuk1FfBv6Nv1ZEhOfCGu9tr/x8Lf+w5K8hrjsAm+nKZFXoxZISatirhsjk=
X-Gm-Gg: ASbGncsl17RHSptIHftgFxUJB0RW+6gkFzzR1Iav9mBQNzd/joqF+RLCJ8/tXQNCwyA
	r7Ytf7fPLy/ouxrFzNmqkT/ONZDQsvasFi743/uktli76nwXTF4d6syZymq+jdBz3gbH9NlInud
	UVEhjzXHmpqRzHYGd6SewOULmN9NmrkgrcGYzveXTLRVd+svauWXGzuzuroG71XiM0wVnjn5Em/
	BcOIP1wJvd8YaFycOzursFlJCJ+9of8xZBuREimZRYWMvXTp0m5mk7ZzzS1gE9+0HT7Ar5VzWRi
	/ImpAfXwNS2HlXDhb26lvwcA5E3bxKNVcIhT9flbZNoSXSxKL6+k/5GXZMVGJiVWvv6CxgM7Jj8
	QtEmEfQVVt9/wjkQSt4QoQbR0ZYY=
X-Google-Smtp-Source: AGHT+IFzSspgMHWhdre95XZ6yQu1fgkJ9p1RBBf5WV6Mv83GrLrzzzr2HXymO3TbBPUm9gEG14WDGw==
X-Received: by 2002:a05:6000:3103:b0:3a1:f537:9064 with SMTP id ffacd0b85a97d-3a3496c0063mr1511833f8f.25.1747203164593;
        Tue, 13 May 2025 23:12:44 -0700 (PDT)
Received: from [10.61.1.204] (110.8.30.213.rev.vodafone.pt. [213.30.8.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f57dde0esm18762430f8f.18.2025.05.13.23.12.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 23:12:44 -0700 (PDT)
Message-ID: <2be48d40-809b-4c3a-b528-e712bb6ed1fd@linaro.org>
Date: Wed, 14 May 2025 07:12:42 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 30/48] target/arm/ptw: replace TARGET_AARCH64 by
 CONFIG_ATOMIC64 from arm_casq_ptw
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, alex.bennee@linaro.org, anjo@rev.ng,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
 <20250512180502.2395029-31-pierrick.bouvier@linaro.org>
 <91cd9b9a-8c67-47d3-8b19-ebaf0b4fab5d@linaro.org>
 <39c6f5ab-6e45-491d-a0e8-07408e29e2f8@linaro.org>
 <cb2798a2-e673-427c-a83f-2afbac59751b@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <cb2798a2-e673-427c-a83f-2afbac59751b@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/13/25 18:12, Philippe Mathieu-Daudé wrote:
> On 13/5/25 19:03, Richard Henderson wrote:
>> On 5/13/25 03:41, Philippe Mathieu-Daudé wrote:
>>> +    /* AArch32 does not have FEAT_HADFS */
>>> +    assert(cpu_isar_feature(aa64_hafs, env_archcpu(env)));
>>
>> Why?  This is checked in the setting of param.{ha,hd}.
>> See aa{32,64}_va_parameters.
> 
> I suppose the "AArch32 does not have FEAT_HADFS" is misleading then.

It isn't -- aa32_va_parameters does not set param.{ha,hd}.


r~

