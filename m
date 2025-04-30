Return-Path: <kvm+bounces-44966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A25BAA53E6
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 20:42:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE1293BCF16
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADBBC27464A;
	Wed, 30 Apr 2025 18:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dDdcSVpv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4512126D4D4
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 18:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746038467; cv=none; b=VjhFNZ/kJOFgXS45w4EShMD7r3CxwNPpmsY73695mLfc8ECcLdcj2dFHOhTPAG3P+LRXdO1hcDrfc7vsjNP6TjrGSsUA9NwF9UCbVUURyBJLz0HunexvObKWRAjupOAFBfsqTp5xAYZNPWH+aENFS2ZYIeOSvOH8iGThQOzcQQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746038467; c=relaxed/simple;
	bh=NzU1015m7MfBXD+9ndn1hZv7frqH58fctnk0ZS7H3Fo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y82ut6Jx4TqAoAomqZYw9/EPDAIniSiWMOd1Ifa8qpC0Zd8asfoXaLVmU0Dvgl2mNaA+UrBAWQpAxdhO1muc5bwR+RPqo9BqU+Oy1YlRi9O8RKT4mLQ/DHfkSQIh05UZ2Kyc1XbxoXzc32GUMhPTcFstLnPAUK1hFwldjrHhJ2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dDdcSVpv; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-7fd35b301bdso230449a12.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 11:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746038465; x=1746643265; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mzSKvNAqsUnH5ctO4BhCeoMH5BT8Wk4EgybesA/rLfc=;
        b=dDdcSVpviNwLzpJBKdHjjcmg/wVbYEndXszvXQAJy9e/Lbct8ZvNGoJUioKx9ATe61
         f/8AEqVet6sHpPT0NBNy7jyg61JdEtmTej8UtSIX1dOtu0VeACLC2YfO8zpWyYFWoQU5
         6DAMTs+Fz8Jii+V2W5L2qTEFj0i3CwMZBDA1L5+3cQ63uCUG5w1Iv6WP2hOVVVvtaodM
         gkDSPZHtHvK4IM47FLj4myXhP3pYvZOX0aLyZ04u1yq5NwJEvNIZcsA6AXPBeFLADqph
         WypMFM5iUstzqZPnzyGXrPL8FWS9TdRMeErcUGpLMSYOZUJvPmUM/PKfzAilDHKvtfQz
         EQsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746038465; x=1746643265;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mzSKvNAqsUnH5ctO4BhCeoMH5BT8Wk4EgybesA/rLfc=;
        b=h4pYDB+idxuOza2N6ZJdVMgYaA6TWVJKbe+qikQ6Rr7xwev48/uy4IXOZR721DDvVM
         oalYA58aFyt8pDtNPcN70ZcBs8nPv+/PjPeH+bPOnElO5tT3UOD6+N3NgLkI8UUKkKGh
         5n/Wsbjpxj5tFPS4yfJxICz1d+KWAjd2u9hRHE9ECwrmVHJX3MsvCtKStiH4m2G9B60n
         LgWMhiSXHnzGzYh92A//Fw4ZiTw16PXvPxl998pHpYZb58hBSGOP18janMmMA6z18uK3
         p32RxXXXjseRQauFi2odOktQ8ffZMa6HGKykTojncGeU3p6aIVco2N0MRVDP2SIwcfZV
         55IQ==
X-Forwarded-Encrypted: i=1; AJvYcCUE6CgSA+VAR+Ke3JLHLQJPlvr3W/Qs43S2sluG5lDF9ozx1Hb6BBogCEx4fd0sUU24Vi0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMrS5YZ6nKAuGEbrT3hSQaOJbjupgZrMdU/cHT+saS3CwW36YF
	UuyE1/gMwTHbWihSLT0RZb2KGXO8d72SB+B4a3kcVev5l6Ba8IlW5gO9HUMHfP8=
X-Gm-Gg: ASbGnctNgDM8A9Ia3f9Li88qXul+EGSm+MQVCAAqgdD4ZMv/ZnKykGwNl5BOX7v3FVo
	ac6FO3Hnsbl6vXtAlWyJno+vEB6qtQ0UbGW1DMDwyaij8WAq44MwqDeECMeAWsjGpyiASm1/THh
	Cj3C+j1gYJe8a0c/gviRDPxi8s2gds6kk49LuXYD1qyxZcNyoPfGk2yOa6mB86XORrBMBaf1v6O
	PsXOnaD6p/5e892yE2rmqbdHxwCYXLPCY3/4saNuFRx3dmXl2ttaPZ3P/x4REr5EF2Adprs+WFq
	zoYzyC/80PABgjvaBEo6sDSJ1XDqHFggs48V2sf43EEJNLF8vSo2Q8zNYEizmOnHvsUmM+flqJg
	ug49Dq64=
X-Google-Smtp-Source: AGHT+IHkVhvhoqpOiueBFVAVKu1bI6pPByHvnXhSTgpQBKrZ/5Kcp+BpBsGGNCJZP+3+hpNcQ9Z3wQ==
X-Received: by 2002:a05:6a20:c704:b0:1f5:790c:94a with SMTP id adf61e73a8af0-20aa30d3d00mr6118919637.25.1746038465521;
        Wed, 30 Apr 2025 11:41:05 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740399415bcsm2026012b3a.73.2025.04.30.11.41.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 11:41:05 -0700 (PDT)
Message-ID: <9e612606-c7ba-4f81-bbff-9653aca9742c@linaro.org>
Date: Wed, 30 Apr 2025 11:41:03 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/12] target/arm/cpu: move arm_cpu_kvm_set_irq to
 kvm.c
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org, anjo@rev.ng
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
 <20250430145838.1790471-7-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250430145838.1790471-7-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 07:58, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/kvm_arm.h  |  2 ++
>   target/arm/cpu.c      | 31 -------------------------------
>   target/arm/kvm-stub.c |  5 +++++
>   target/arm/kvm.c      | 29 +++++++++++++++++++++++++++++
>   4 files changed, 36 insertions(+), 31 deletions(-)

Nice.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

