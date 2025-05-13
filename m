Return-Path: <kvm+bounces-46337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 624BEAB52F7
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:42:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65F2D17E7EC
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8DB523C4EA;
	Tue, 13 May 2025 10:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FcVLZj12"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D7D1CDFCE
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747132909; cv=none; b=N/hxwkp/HBenDH7AQ2TcfjCeEpuHal59cNuZUKW2E8uQeh5Zy4SHR9Ci2SYNYhNE/as5/WNNlPCVBWcupVylq52KpFC8CGZbDfNo/zNHWDAi5zxMB3Uz78AtJOO1JSNeXmnR02ku5fS1kWabOcNt7tnnAiIlVez1TAA84BbcLlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747132909; c=relaxed/simple;
	bh=PR4gB99rDEA/zHaM/MuyvyXo5ickm6JQu/LW/AUtpWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fi54+w5R16UsRnsI9uaokUGd/YD9HVnfHE4aChY5KEr31uJNDx7Wi8qv1wkjTU9b9zhLXB4uC9cnpHRadEfrIN9TmXP/TZyxLtMs5DbicjE4VT/hId/k5uvw6yjXNUgZRBYbaaTmzvLdSDulLIzupgtSpybRVcuSI7UkaJDrpDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FcVLZj12; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a0b9625735so2855407f8f.2
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 03:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747132905; x=1747737705; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FZfg5AI2wrxSnX+jqnGfkFMNeBi5XS88rO/72M9QLbw=;
        b=FcVLZj12S1c3ojZRDqIOO2M8BUE2BWp4pjXg9Du+ybI6q/mqPPwCGACn+0IN6YWaRP
         21X7kgQdvQbi67LltOG0GQHtfuJHGZSzvgRptLu/Wrd7vH3sObxNy7fFJDB2jI6qDa8b
         4iLcitZ2RbQvcT8suK6OHujIcB4uL074MBKiajIP8gBdtMtTnPJhwijMSdmf1ae0awy4
         geNP3oMReoQxAk+H6QKIJ1PSLNkTflJxyw9h1WP+YYj4JyIEtrDpQuEk8htcanEBmxGS
         T8lXBVPQQs+yJphOMRy/f7dXd8dgC4hUj1ETEgUg/CZx6PY8mG67gEPM9mHLx/hH7Aea
         qi0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747132905; x=1747737705;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FZfg5AI2wrxSnX+jqnGfkFMNeBi5XS88rO/72M9QLbw=;
        b=QNlB0ESpHkgEu8RwwiA+3OIwCMqer18QElbuLDrxUE/jTZ/z3GV+qsb04HmrjQ4YbG
         Z6DhKSbTdh3YFxtr8C/1wRAsjTHLRrCTJnCDcUQfkqVeqOdXne0CuMqg06lUzxtMpx2h
         0DD1Z4vfOQt4o+LeaOtSybQ0PFxtA2n9Nki3Zo9occg2ZJcDFu9/S0SEuLmO435GxrDr
         ENGIUpIpC3G+u7Azet7p6tYlZQRQxuP8crS+kji767BGZdooH/5zpnb0+QKvD46uDbs2
         GcCzsggTeQ2jrG1g2MjJ4L/xrHBovO8QNLl4Uzd3t7zvvCTaiGjaYiNWndb7tyJrimBW
         2IEA==
X-Gm-Message-State: AOJu0YzfNj05sfjFUQQ6sApQgdzLIL8Ms7pkoKH2WfFPvhrBD6R3trhK
	ArHAGZ7yriuCnpeOAzEm1s08bTMdOkmsjsKI08YI0rG7wNu0mg8lbEb4xFYayc8=
X-Gm-Gg: ASbGncvz1ndzEj4Ltgu9KJ1Mpr8whPS06Za3MODIervXW/C/7XGyf3OkW1VNiXAu1rM
	GLEj2miVA6DM2yhmbN/0iyaRuepNbdQfV4tjjJb4F7VpxFBnF0kvNUYEyiTqGyjs7F43tUphbjV
	ChwlQBHpZkA8mTYkmna9k8kxDXzA4kbBd/p2Y7Eo/Wa/vXVeDXJrGDxiQsqPo1twK/wHcN1WL0H
	1ksJpMZeseGRXsxhY3g2xhvTwuJ9pGwMt5XubDUiC5QgoNVKjc+CK+i2p/v/ghj+lTAV0IwoioC
	1eohnSJoWaJcONNTH6srluMU5e4SWJ/dHYhJt8qflw3jpcVNu3B8zdb5MkPKa+MhfBqNmLdiBxQ
	90Sp0p6H+t9+QrgpVCwtYmO+L12Dp
X-Google-Smtp-Source: AGHT+IHtjDxcFamTEzcXxzi/hHZllWxOf6YDpL1W23amCk7IKRTeNkY7wBHcB/icbLzMl2A/GC0boA==
X-Received: by 2002:a5d:64ce:0:b0:3a0:b8b0:441a with SMTP id ffacd0b85a97d-3a1f643ba6bmr12118934f8f.25.1747132905377;
        Tue, 13 May 2025 03:41:45 -0700 (PDT)
Received: from [10.61.1.197] (110.8.30.213.rev.vodafone.pt. [213.30.8.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f5a2ca31sm15841490f8f.65.2025.05.13.03.41.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 03:41:44 -0700 (PDT)
Message-ID: <91cd9b9a-8c67-47d3-8b19-ebaf0b4fab5d@linaro.org>
Date: Tue, 13 May 2025 11:41:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 30/48] target/arm/ptw: replace TARGET_AARCH64 by
 CONFIG_ATOMIC64 from arm_casq_ptw
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, alex.bennee@linaro.org, anjo@rev.ng,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
 <20250512180502.2395029-31-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250512180502.2395029-31-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/5/25 20:04, Pierrick Bouvier wrote:
> This function needs 64 bit compare exchange, so we hide implementation
> for hosts not supporting it (some 32 bit target, which don't run 64 bit
> guests anyway).
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/ptw.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/target/arm/ptw.c b/target/arm/ptw.c
> index 68ec3f5e755..44170d831cc 100644
> --- a/target/arm/ptw.c
> +++ b/target/arm/ptw.c
> @@ -737,7 +737,7 @@ static uint64_t arm_casq_ptw(CPUARMState *env, uint64_t old_val,
>                                uint64_t new_val, S1Translate *ptw,
>                                ARMMMUFaultInfo *fi)
>   {
> -#if defined(TARGET_AARCH64) && defined(CONFIG_TCG)
> +#if defined(CONFIG_ATOMIC64) && defined(CONFIG_TCG)
>       uint64_t cur_val;
>       void *host = ptw->out_host;
>   

I'd feel safer squashing:

-- >8 --
@@ -743,2 +743,5 @@ static uint64_t arm_casq_ptw(CPUARMState *env, 
uint64_t old_val,

+    /* AArch32 does not have FEAT_HADFS */
+    assert(cpu_isar_feature(aa64_hafs, env_archcpu(env)));
+
      if (unlikely(!host)) {
@@ -854,3 +857,3 @@ static uint64_t arm_casq_ptw(CPUARMState *env, 
uint64_t old_val,
  #else
-    /* AArch32 does not have FEAT_HADFS; non-TCG guests only use 
debug-mode. */
+    /* non-TCG guests only use debug-mode. */
      g_assert_not_reached();
---

With that:
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


