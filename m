Return-Path: <kvm+bounces-7453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 527248420DA
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 11:12:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2266B2FBB4
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 10:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AEFC6A33A;
	Tue, 30 Jan 2024 10:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jFGdm0U0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB64A6A336
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 10:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706608827; cv=none; b=SK16WB2pY6daAERUiMjQGRTs1706cUkdpB0+JsqgEXicUbNOPrzqVuNPReMfPpLBcRo8/mgxgTRH/B+7myaVDyUXRZZtgBd3WlX+blFZoRRuU9XPEyXqRzQgyUXkb1Vaj8iSBCeS4UqLg8FPgCsgZ32d0a0l2Z+Xq/46j7MqKMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706608827; c=relaxed/simple;
	bh=vjHubOVf2birD6IAmObs/Ld/o7Qr07HFdNWfUVbjSeY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JTx2+uf2CZnEHUfUwxi6a5r8gplEIiOtF16dca+fYpV0tdBgYhhhyH8l1tfnZSCie5/00GmVfmtpEcuU48wteOMD1VBlhlyWgeaOg4V1dILfEROzjUEHpE5pix8ETO6P1L+ykRy6vwS9pxHrXaipz0Qc/5MshCSHNNj8N6V6AMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jFGdm0U0; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6de28744a46so815655b3a.3
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 02:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706608825; x=1707213625; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N6rrp1PZTWCFekP68QS7wfkG/TDpiqFhA7xNmGuR1oM=;
        b=jFGdm0U0udA2ns7xhPIhJR3dMCYfYehv+90Oao0UT9zYekiy/QZlwd0hklQHpQ5B6V
         q9MGje4MSJr9tW2wox2CWeLOXf0LVzKuwnUDFsfH9owBIajYkmJcpshySpjQObpSCWwl
         z8+U7L5RCZMBYwcvbAwfVDnJgVxEm4APJnrmxI5u3gWn3Ot5UQ1Yxp/exAnYCJoxSLt0
         hg6aHahdDRu3wlgnvb7dsMEwCrxstb2XqzbtZxt77IiUiTuA7baLhPKwkxxWZicdB9xO
         0mvwT/vXf2SnZ7kkEh4aogNfwy+KpT3g7afHou5fUM4jjOYBE8X7PFK+TDuQGSZmFYSL
         sfGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706608825; x=1707213625;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N6rrp1PZTWCFekP68QS7wfkG/TDpiqFhA7xNmGuR1oM=;
        b=nM3WDxEPbrENmKps4koKLwceorq8335cXQBjMS+k4fmI/pRtGbMPbgRp3engma44HB
         qwLRZ74/Z7XlwKcqJ3pgtSuC5W4BJAi24mGheThqdHOhFGLDDx65mDDFpZxeljGDofsn
         Zg185At+g6uP6KOBxCK/LschBYz9pmW91DHvE0i44QoEH5MbpIxN0i6kgiEkTHHPH5PP
         22aIFRFtkMV6J6+tVGQ7saiwZOtRPBxT/Mtd1hRhT7NvYRU4VX5Ig7Ce85MbfLDjdN5r
         QtqTh7yvKcA4RHrkhjBAmCxVPTC6XyPbeNeTEYQetWwgGmxsWKrOOwz1+7XsTRC/2XbC
         vckQ==
X-Gm-Message-State: AOJu0Yzo7cprXa1RhIABZ56HAQJYrm0svSaiLfCwfsrTq09bG9dR5u9/
	oeB5ZjkVHXJes81lDLI1LdBtQ1+Q3Y7ZBloYYhYAcIHFeZlkOa0+mY6kmwkn38s=
X-Google-Smtp-Source: AGHT+IEWBMyhl5lfi+g5ZJxpiEt85fcuC07bbj6Fs0uTefrP5NszaFZgkNvm/scKOXmd+fbtEsBhJQ==
X-Received: by 2002:a05:6a00:4fcb:b0:6dd:8743:9e03 with SMTP id le11-20020a056a004fcb00b006dd87439e03mr4125687pfb.34.1706608824927;
        Tue, 30 Jan 2024 02:00:24 -0800 (PST)
Received: from [192.168.0.103] ([103.210.27.218])
        by smtp.gmail.com with ESMTPSA id gu7-20020a056a004e4700b006db105027basm7382769pfb.50.2024.01.30.02.00.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jan 2024 02:00:24 -0800 (PST)
Message-ID: <40b11cae-39cb-4254-95c9-27d4a2a13ff0@linaro.org>
Date: Tue, 30 Jan 2024 20:00:20 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/29] target/hexagon: Prefer fast cpu_env() over
 slower CPU QOM cast macro
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 qemu-ppc@nongnu.org, qemu-arm@nongnu.org, Brian Cain <bcain@quicinc.com>
References: <20240129164514.73104-1-philmd@linaro.org>
 <20240129164514.73104-12-philmd@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20240129164514.73104-12-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/30/24 02:44, Philippe Mathieu-Daudé wrote:
> Mechanical patch produced running the command documented
> in scripts/coccinelle/cpu_env.cocci_template header.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   target/hexagon/cpu.c     | 25 ++++++-------------------
>   target/hexagon/gdbstub.c |  6 ++----
>   2 files changed, 8 insertions(+), 23 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

