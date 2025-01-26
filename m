Return-Path: <kvm+bounces-36629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F505A1CE7C
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 21:40:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C29B67A32FF
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 20:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2ACA1607B4;
	Sun, 26 Jan 2025 20:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aSdrjNFt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7565125A658
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 20:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737924039; cv=none; b=bJ8CLxIqSdYILe2T97CbPIW25VWCOBncn/81g7y6/5B+xQkU+dvQNAsDrsXEkGYyH9T2G7rr4TmXAm6+XAIRQNhkuX4lyvYYS1QfM/tKxRmcu0UaQyr7CsV4tFr0Oxi/TCsonpmACbj/ed5S7tUq7F8QZ8M4uIS+d+VS4+j89TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737924039; c=relaxed/simple;
	bh=go0P+0aj59dO2lGgVV8gqtdbRwW75c4k3OhXmhMuWRc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SvDzva19GJ7J5GUKN+VqZQqZ3sUpPMqYyv00sEDtWzivk3lmYnD9Zn7E7oFp2NL5pxILJhe7cpFe1OsxOa6X6XLGsFqhd9XnQGHKaFXnHgZOJjEJdJ6cIAtdRJIvwaEFbHhL7Kv8he/Bq3Y3SsJ1MPINIh3dsqtKxefv2+esN24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aSdrjNFt; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2ee86a1a92dso5222076a91.1
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 12:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737924037; x=1738528837; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8IakMPE25WQo15H6bcZ/5DvSR8Tj+5m00/ec4213Klk=;
        b=aSdrjNFtS5kr5UHtQXUb/nd8CrwXj4NRUnnfJpFacuzNqtg5l98rWelPZW61hyT85w
         hgoWqGhy4XJRfW6wyI1sDEZbLzfJh7fLKYPu8j95pKgp86lGP9FsCqtsvS5eYOBeHYXP
         U3KkIT/1RhkmsYnwxwQHN37LgwYf4wq+0YSEk71Sb8/R+faMYDOBqAcXQVHx7+CoaEhp
         ytrStqV6LSpQuksemxagfZ/PKcEPdGndmyNYenKNRbYVXfOR7KZO0GaHHd34A/Veh/3H
         TuskSVIlfwIUAuBYpnGVy01XBSypdHc+w11IYRcj/0iBvY3rD5PLpkBLOLO43cLTB+P4
         xVNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737924037; x=1738528837;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8IakMPE25WQo15H6bcZ/5DvSR8Tj+5m00/ec4213Klk=;
        b=EPihkces6wo2IZcipfXUlnANBw9OE7a9Pi9OvWipMk03mG3b4k5KonM7sbYXHLpQ3B
         GnvLD/MPOeIorFv0MB9BiSydqqHRYTwBpeLQMvIZj91Pq/0drQSgTowqGbdhEaHyjwTQ
         X0WOnsEwFkhJj/J7HnCA06mp+qUv4+WSagAXg9GKe3NHMiJL68KMGMb/tIQ99Yinr+Ad
         4PcSePBFCRMQQM+RyuQAneWcEhZFCpufF+GRMHDMekUIdZNNeoukiJ/5EY7yXgYVuRvx
         c8cPSZmYZJQzIZcrbFFE0JqIT6SMbfEws5flKvnas91jJSeIt2MW3FQ10UF1Kc4JZLX3
         wW1Q==
X-Forwarded-Encrypted: i=1; AJvYcCX2mGOnhlpPk7sTNxPDIAAunTmUdwWt/pJBVmF9fg4iGsFsRcHrfnVnOmUX7xUVL8cVOMc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAOPSIc78ptN1ys5MbzduJ6V8NxLFT0TLJA58CKVw49bCJ+GMT
	duBdEdHSYdPgCjbyTtp9yDHW5fo0AfzI5FsP2pcSRIgHRVA5Tr8kFSHzb0jnNOw=
X-Gm-Gg: ASbGncuMPptsR1nxXPwbYDHJYHYUo9BtQMZtxuZiUcsjgnZrVAdvFtDWdiK3iZSvN34
	XDUX2CvFgLhgoK1OiIqCpFxDlu5QBl2uBHMjJdXPzYfRFwAN6+GC2hlMYvaZ60/fBF/z6oc2Y1f
	FAPYGaW/55zxtp5cmuwVtde1XTYZUXVYlF+T2+HbO0+Zk4pi1VgJQzmnLeFibsJxVz+KnXl/PMh
	gXWPYlGyJemrtDCDgsw/cx0w6xAhFWyk3fkVjrD3jXSCr/qplWVO6Wul+mEvIBYooPRKbgwk7AO
	V/F3GO1X8u/XLTnq6ggGyOjDyS13wRV7v2uRmE6o1k3U+Co=
X-Google-Smtp-Source: AGHT+IHFyv2iybW4GBn6ydLEZa4E4dxLUY4YPXTswHBeV0LQk9iq0lO2cyUKBRO3s8sCKps06u6bpg==
X-Received: by 2002:a17:90b:2c85:b0:2ee:4b8f:a5b1 with SMTP id 98e67ed59e1d1-2f782d30ecamr56371023a91.24.1737924036671;
        Sun, 26 Jan 2025 12:40:36 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffa44cc3sm5572845a91.10.2025.01.26.12.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 12:40:36 -0800 (PST)
Message-ID: <41f18203-efc6-43d5-90fa-ea20416ec01c@linaro.org>
Date: Sun, 26 Jan 2025 12:40:34 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/20] accel/accel-cpu-target.h: Include missing 'cpu.h'
 header
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, David Hildenbrand <david@redhat.com>,
 qemu-s390x@nongnu.org, xen-devel@lists.xenproject.org
References: <20250123234415.59850-1-philmd@linaro.org>
 <20250123234415.59850-13-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250123234415.59850-13-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/23/25 15:44, Philippe Mathieu-Daudé wrote:
> CPU_RESOLVING_TYPE is declared per target in "cpu.h". Include
> it (along with "qom/object.h") to avoid when moving code around:
> 
>    include/accel/accel-cpu-target.h:26:50: error: expected ')'
>       26 | DECLARE_CLASS_CHECKERS(AccelCPUClass, ACCEL_CPU, TYPE_ACCEL_CPU)
>          |                                                  ^
>    include/accel/accel-cpu-target.h:23:33: note: expanded from macro 'TYPE_ACCEL_CPU'
>       23 | #define TYPE_ACCEL_CPU "accel-" CPU_RESOLVING_TYPE
>          |                                 ^
>    include/accel/accel-cpu-target.h:26:1: note: to match this '('
>       26 | DECLARE_CLASS_CHECKERS(AccelCPUClass, ACCEL_CPU, TYPE_ACCEL_CPU)
>          | ^
>    include/qom/object.h:196:14: note: expanded from macro 'DECLARE_CLASS_CHECKERS'
>      196 |     { return OBJECT_GET_CLASS(ClassType, obj, TYPENAME); } \
>          |              ^
>    include/qom/object.h:558:5: note: expanded from macro 'OBJECT_GET_CLASS'
>      558 |     OBJECT_CLASS_CHECK(class, object_get_class(OBJECT(obj)), name)
>          |     ^
>    include/qom/object.h:544:74: note: expanded from macro 'OBJECT_CLASS_CHECK'
>      544 |     ((class_type *)object_class_dynamic_cast_assert(OBJECT_CLASS(class), (name), \
>          |                                                                          ^
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   include/accel/accel-cpu-target.h | 3 +++
>   1 file changed, 3 insertions(+)

Acked-by: Richard Henderson <richard.henderson@linaro.org>

r~

