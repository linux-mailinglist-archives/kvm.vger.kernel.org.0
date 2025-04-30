Return-Path: <kvm+bounces-44961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BEE18AA53A7
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 20:29:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 900EB9A2A2A
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 348AE265CD6;
	Wed, 30 Apr 2025 18:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="h/lUBVIS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45AD29408
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 18:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746037739; cv=none; b=TYgmWwYHQ/WEcl+uf9NiModNFK1Me2Q+CfYP80yCcgr7F0TTzejRzu3iCeLPwmJGCyxf7zYommglGXowtvk81A+DhmZZtKf3ArBgdUkM4rF4LatDG7NNXvhOsf4/Bxx6i62Qg37Fs6MXh/9kYu/cRYqcrZmPWcA5jjyYrs/tyos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746037739; c=relaxed/simple;
	bh=PLa7WMcXl0O6doc9K8BbSiUsrgIaKL39vzmD2QNP3Ic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LD80hLk3Zsk7KTG6UUGw6q7+9hTrbjpzT1jH0UO2NGPPw7gR6tWXZAdJQFNXna7AycvSEXvNwevVBlkO2g67LAzUPkYQE0xosXjpnKZ6tDNwXUhCWJNOLuneA2qvwx3nRsHlkywRva3VKPq5Y8YhbFgi1i7nxm2LLU8eNfu2KsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=h/lUBVIS; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7370a2d1981so212619b3a.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 11:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746037737; x=1746642537; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xf7StgsomvAyHveK2lC2y8EKqAE1ASvZR4bG/e1uZso=;
        b=h/lUBVISLP2ZhscJ1a3eoIaBjc4XnZsXysGCtbpIaow84RvYTTjHTeTyztZALLS1Mi
         srIu5ZYORdj648L/5imYYGX67kHJk9pPdu1aS5ZJ6e8F65CULydiePLDUHf8upF3LWJb
         rBbZCEVPjy/G7JzK9azkeBSCdEbEWwxTkvhb46ILWlRCCk5++DiGSohUqb5TzRR+fi3/
         txUp2PLmZbhGcVrVojtMsiJ8vYxWv9tcazOFXfxP3Y1qQB4p4j4zBj+dhihp6+NwNxh9
         f8X+4zDxHY7juqBjwkveWL7ddXdoH6diIONhO11KGElePS4CH/4ffvcXmbstu1fxbMl+
         Wb5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746037737; x=1746642537;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xf7StgsomvAyHveK2lC2y8EKqAE1ASvZR4bG/e1uZso=;
        b=CNbcbzLXc3Pg2rZwWs0L1W0utjQ8wI/mFimjYCGAbHxqvtVpQhszacm++1IdSdZefj
         d/meuP9meYcAON6CT8d3bR/rmDDAz0ncUPrprmYLYBmP+YZysAx8Ynrslk4d88b7bao4
         MXEzYNW2eI3pOmkhX+jmrG3Z090a0kYGXVyM43cnrOCCaMkU89A0RHISKdsrpaBjOcI0
         gP6mA1UUuUnzrwIlUn/sKzOVG8ByF+ko95VVNgWTMDyXpNegzKOD/LVBd5coCB4taY/E
         PY8pP816v5iUHbbwMZOYDQic9Njr9owTM7IFsP1EDpmLPPG5tUIiz9DVs2N4WuPxzbpA
         E65A==
X-Forwarded-Encrypted: i=1; AJvYcCXuwPzRoC8WIIql6L9Vu6hWhRgt68fRTRSfwlsUSF366KeY2sK2PkkvJJVhRZUzENOS8wE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzN1wssfQ6ak1JI4FNqsLZL2gp77XEj9CrHE/o7CPA4RWNgHmMP
	w56p8ngqYI8NWV6G4oTOg8v/FICq6jNQPtUzdKge+DdAKCYupadALSyrvYB/DRzSw4ftw5hxL8N
	Y
X-Gm-Gg: ASbGncuH1/sDI/OIWkNEIWJjsJockfdCcYbEqGoIsr+vUPlyrW1dqNWMeCXH3REMRg2
	GOE2xa5AgzHszbugGbQgZWG+HdmNM+3WpObqje7hvsNiJfnfHbadx0/Mikz2HxCZN6Ydj0CemVc
	h8kdGWyb343D6x/hmfsEOfKsRIPpErMIkiRbxXdHglpqLDwcvrn5mU9iiuikFB2+w3K0oR0/bGi
	Rq2+Diu2jHSU+ODcc6RwHZ6zE9OXW+nbwcQOvlQRcxrjqD6Zq7WEioEQFmdHReyrL1yJNM5QqND
	+Ck9jqrxYv0xF+KUjH9/3i/pr6uHPZ2vnuLk71vx1GacyU3psBvRYMXwwn+tSvaHW1V35Jc2iwo
	XQXz1UBDnR9lkVtWbKA==
X-Google-Smtp-Source: AGHT+IE4vHbPO94ar+fxRmmWot5znQkTAFs5WKYYBmdHcNgDR8Z0P7yQbM9KTvnMqybbIMnoHBwRnA==
X-Received: by 2002:a05:6a00:a1a:b0:736:5f75:4a44 with SMTP id d2e1a72fcca58-7403a836358mr4833489b3a.22.1746037736866;
        Wed, 30 Apr 2025 11:28:56 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74039a8d256sm2001099b3a.157.2025.04.30.11.28.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 11:28:56 -0700 (PDT)
Message-ID: <34184e10-5337-408a-9052-d6796ab14494@linaro.org>
Date: Wed, 30 Apr 2025 11:28:54 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/12] include/system/hvf: missing vaddr include
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org, anjo@rev.ng
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
 <20250430145838.1790471-3-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250430145838.1790471-3-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/30/25 07:58, Pierrick Bouvier wrote:
> On MacOS x86_64:
> In file included from ../target/i386/hvf/x86_task.c:13:
> /Users/runner/work/qemu/qemu/include/system/hvf.h:42:5: error: unknown type name 'vaddr'
>      vaddr pc;
>      ^
> /Users/runner/work/qemu/qemu/include/system/hvf.h:43:5: error: unknown type name 'vaddr'
>      vaddr saved_insn;
>      ^
> /Users/runner/work/qemu/qemu/include/system/hvf.h:45:5: error: type name requires a specifier or qualifier
>      QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
>      ^
> /Users/runner/work/qemu/qemu/include/system/hvf.h:45:18: error: a parameter list without types is only allowed in a function definition
>      QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
>                   ^
> /Users/runner/work/qemu/qemu/include/system/hvf.h:45:36: error: expected ';' at end of declaration list
>      QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
> 
> Reviewed-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   include/system/hvf.h | 1 +
>   1 file changed, 1 insertion(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

