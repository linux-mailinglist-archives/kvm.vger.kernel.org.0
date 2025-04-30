Return-Path: <kvm+bounces-44971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A593CAA5419
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 20:50:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B2109E01F4
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52D4225DD10;
	Wed, 30 Apr 2025 18:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UzMYR4zX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAE51D7984
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 18:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746039041; cv=none; b=R/tn/kLgb3Tn165vfTOJUnPAlt4PN0m1z1/VbBbrmq0v6KE1m48NJEsN2xcU+RFmB6Vzvmzx/6ZhQ2IO7zKgts6a5HwvEAgROSEwjP6h9g09vLhkQq2QMyomesoPZHcZEv8vYpXGz+HnhiZIYW+Nc6ew6PF5EauJw9yDR7pgokk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746039041; c=relaxed/simple;
	bh=kxcQui2TsUuv+ajrRAy8NIbvBPz1PBp9QglH+YxsXIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WMlePpAdYrhJD9mkq6Va6zyOAzf3uecNcQ2NMNstQfY6+cew24m+E5mEC0/IH2EQJqX88VgVfzVBy37nFaDSJugeVXxhnN90Fg/czQ16/KSrMGhTKNQxX4d3YcopDskS/VvGcTMONUDEi3wGfNCZmMVcVNXBRZ8ftqoelFrgkgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UzMYR4zX; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7396f13b750so302643b3a.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 11:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746039039; x=1746643839; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kxcQui2TsUuv+ajrRAy8NIbvBPz1PBp9QglH+YxsXIk=;
        b=UzMYR4zXiNgX69VPRrlVQ00i71q70x4zKoEKWw23U2FbVrbToHbCOZ4/YB7hfqmf8r
         Yvomuqh9J/4WlYSr7CAzBPmoGpLKWzPmmpF0w8d9/WctIo6UL+w7+EkHKOuGxJTRolC/
         abbcmykvetpezkyQepCsMTE3rq065uonTpDCL/Ow2dRtpL0OlJ9bbg+eqt2wsUYL8uuq
         qo13IYBPtGq42LdYBzfj6U2J2s6LCFtgXCTjA4LOvrr2ewvkzn4aF6w/dErAXxmpgdjG
         PKCZ29liQKHKo6fX0BngxP8G06kicxea/BvmHKblJYYBrk2G6mQqecdSFASFZN90kmv9
         sWbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746039039; x=1746643839;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kxcQui2TsUuv+ajrRAy8NIbvBPz1PBp9QglH+YxsXIk=;
        b=WZELqPVY53ca6/25Df0xYXkooKdrGJATvXwdasvIshvlw6fU3Eeqi795Nx/zQ9vEYt
         s6jcQon1/2UOjZhxRG2AU9arrXdoKztYXLbUaI7keVHYAJOF7oK7ZsAChcbdLLKQzMu6
         Rqd/DvreMnhJs/1vqOPFLiFIwDsUORrkc3XUaN9mEudC19JvEPcZ5KwAu9BpdEGc4zD3
         HFz9cEfdIQhOk9MDR5+xqHVPDEexKi/j6Qun9hd+inhsuMloqBtN3GZZBL7CVVATiRYu
         c9XrBTOcUiShnubHPu+g/CsRXprxzLbz4cmP14jbiS2YwIDA3kTgILprnImQLdLId06b
         S8hA==
X-Forwarded-Encrypted: i=1; AJvYcCWFyTqOlDUakjAbFx+6bpEucqbO47RsOfB6uEYCdLdY55CMkN903wZeC2nJ904j4EsOSzU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUFzPpzerI7zthdGyKo5VQxg/EKF5hsX5sokK2KtZWvdpnAh2M
	HbzogXSzUmS7gOcWKwa1bD0DjqT587EAnFDC3XNxxBqC61TPJnAHTp8IsKqonH4=
X-Gm-Gg: ASbGnctE6bb4GeIyzZDlJ7u57/jBw7TZS+biPs4sx4LuNmZpn6SdIZaEyHJ4onHgHSo
	ijtWAkf6NBhGrS/N+02ZMA0w4XqeSIH/siqQOrIODpYY5B1WtNFr5AHW+bWSRNSW4C651K3a+ZH
	R8QnduCYyIa+UVfnBE+BWEvsv4aN0L3UbC609egqnPtuCXq3vt/glomCp68ShSMl9Z2ajfX1aMT
	UO2/yYm/tusWzm9GPUM+ZA4/TXAhzANNHYRp20quXa6v/myyRUUWlxJGDZ0ri1UJnK35GJIaF3V
	d3DT8il9b6cIIDFNqCyRZhkVHqnhranMwf7KF6WtZ7AuTkgjzENU0eFKn2MGl1aNrVaSwTQfIRM
	74lDyASA=
X-Google-Smtp-Source: AGHT+IHG+YHTZIvzJHIaptMbcm9aiLNqhmOhTm+WK5TjZVos2qoZOf+1YY8G4Z8bsdWit9hM/8svoQ==
X-Received: by 2002:a05:6a00:3a09:b0:736:3e50:bfec with SMTP id d2e1a72fcca58-7404777ecd5mr85495b3a.8.1746039039225;
        Wed, 30 Apr 2025 11:50:39 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74039a5bde6sm2012103b3a.127.2025.04.30.11.50.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 11:50:38 -0700 (PDT)
Message-ID: <e77b5c7d-5f6b-46e8-ad68-207ae87a07dc@linaro.org>
Date: Wed, 30 Apr 2025 11:50:37 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/12] target/arm/cpu: compile file twice (user,
 system) only
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org, anjo@rev.ng
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
 <20250430145838.1790471-12-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250430145838.1790471-12-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 07:58, Pierrick Bouvier wrote:
> +arm_common_system_ss.add(files('cpu.c'), capstone)

I wonder if we should inherit these dependencies from common_ss or system_ss?


r~

