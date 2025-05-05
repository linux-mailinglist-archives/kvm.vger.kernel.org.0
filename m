Return-Path: <kvm+bounces-45412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A2E5AA9151
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 12:45:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DED3F174DEE
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 10:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7CE91F4177;
	Mon,  5 May 2025 10:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RNDtgz/i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2FE170A0B
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 10:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746441907; cv=none; b=CJ3NDbje9UtlgIKi3xwQzpjIOX1wAROpln8mb6OQZPNdPqt9lqZ8h9U79AEgabbFgs1hpHW9qgY+iSZ2zW4oIunLrlzq5ilTwyBfOWwMAB38TxeL24iLaJF0UuYTX+zfXzpRrqYiuDVLQpi54TLJOUyNvPMh84D5pEPmCuhylD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746441907; c=relaxed/simple;
	bh=iUpbdycxc9hC0HaBAIiMbpfqufaLfSWIOXVjl14ln4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MPFhONbH+yzqmnusXexAWtia6XA6DyI7MKcMQGpb86yxkEVeVSU4seN25FTunaC60ZTn1qmAKJ+XoJ6G8cHQBOhosRL4D1qBvJCTokfb5KD31/4AwUIFZcNSVGUcfQvs0mNfbQDvXXLidBM06q/7v2FXuOhevl0xtGAyeefhCAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RNDtgz/i; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43cfba466b2so34600875e9.3
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 03:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746441904; x=1747046704; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G/Cs1RSBUq2rji5ltplqN53a1rlV5nJ16F1SyWjYlF0=;
        b=RNDtgz/iMdjQ44bK4ualO6FpTdwgY5AhoipUR0sbg7Nryl+WCyG8UTXz+rw+zMNtrM
         qzCUAdppXXl55weUOlk0dR2iqn4e7fWN0B6TTVqPNCsPYgpHIqIXeKYatwpzCw220qiN
         +rTv1eT/Tcn+wIwPhlwag6HcX1HF4m68bI0yCGi/h94UsgiMxmXYLb4zrV5diIW5BgP5
         5ij1C/u1v7L/nGOLTfRba4jP42OenltSdrvptpkmdbNwK9oeS4qkS4Dyn36hshDEVW2D
         667RCofkW5v191nLxrSaahnA+VKpgKGLrsgKwritNVeUHjTgfBFDS3Po/grkhiI3MFcm
         YnkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746441904; x=1747046704;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G/Cs1RSBUq2rji5ltplqN53a1rlV5nJ16F1SyWjYlF0=;
        b=V6oc6g2U2kx3cVIuCVs/FU4q+wxLuURfdBQsG9+4rYfQM1mMnIH5q3O85O+SJXMSUm
         ZJPAs2/DXDQwh1QILT5nbAQlpc1trjhRcuhDhLy0AoxIWU7jlINbU1SvIKi2vIGuMaeE
         kq3RCr1DrSGM29MTGr8dvyKrpXFFhu+Iv4gsEUiM7eBggtlVJOi0hUc/9rd+kWvPlN2N
         at7KIBwdrSUcaTtEarMTxv8ItnF2SuhfAv5++Mt5jNfagy085R8AQvGwKaYzx4Y0k9Nd
         5nzrNrNy1JHWZSBbY5hwbWJ4Dx1u32+IPctCE4jFoz8H956WzB9FWrdAuwsabzQiCn1V
         pBnw==
X-Forwarded-Encrypted: i=1; AJvYcCXcusM01Kkzy4jn8FPy4hMysG9QUTNdt50CqBgcAzSi4KsreW21wulUz3leMZkOzR82kJA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJtiFlh7+tLdeDx49ltNRU+d7OBoxyoc6Awi7lSiBfmPZJsxmT
	iUKF7g7Z0fRb6uTnentMrGHiwb2EblLR7fOgNNTCEZkym9Z+Xzryk/vuHLJPPUg=
X-Gm-Gg: ASbGnct+AJ7XeExWMlzQhpiERjcoaWLHxu4zUco+qNv7DX7fJAVFJh5ND/IxvPzRcZM
	fNRoc3jKBVne3EP0S3jUMk3rlA/ddrfZl47aQyHkT8CC95uHopVIv9DL2Ai+JGwfDwEBPuYYAcZ
	dxntOWIidPeZ1hx+fQzYQYJSJzPb7Bj76VZfpKtRG1w4Jp3hNtrvNDN2u0Pd3BYYhn2fO07/EK0
	E7taroD43P4nckVz47gUN3jRBc6p2qnQpzWKe2n/U5SiKayesgUhMki05ga7bOjrOyiOROQW86B
	BMJh4D4XF7QTsHjAIqydvgoSOA84b5oTy8fMveiTxbrj884VGhWPkZtsPgDxXT/NLoa5kADGiMb
	UHBuaG7bIaj+TQKGX82L48C6V72E4TISDkg==
X-Google-Smtp-Source: AGHT+IFtgkvljn/LkdGPid9VuERQ3zMCyCG7gCBmTMCWKhbiDFjLcP/CnujP0cpUmTX1PJ7YhzH3jg==
X-Received: by 2002:a05:600c:1e1c:b0:43d:b85:1831 with SMTP id 5b1f17b1804b1-441c47d3b12mr68549295e9.0.1746441904183;
        Mon, 05 May 2025 03:45:04 -0700 (PDT)
Received: from [10.194.152.213] (219.red-95-127-56.dynamicip.rima-tde.net. [95.127.56.219])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099ae7a46sm9856690f8f.44.2025.05.05.03.45.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 03:45:03 -0700 (PDT)
Message-ID: <dc27e3f6-ceac-4e05-9652-28634d4fe73c@linaro.org>
Date: Mon, 5 May 2025 12:44:59 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/48] target/arm: Replace target_ulong -> uint64_t for
 HWBreakpoint
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-2-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250505015223.3895275-2-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/5/25 03:51, Pierrick Bouvier wrote:
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> 
> CPUARMState::pc is of type uint64_t.

Richard made a comment on this description:
https://lore.kernel.org/qemu-devel/655c920b-8204-456f-91a3-85129c5e3b06@linaro.org/

> 
> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/internals.h   | 6 +++---
>   target/arm/hyp_gdbstub.c | 6 +++---
>   2 files changed, 6 insertions(+), 6 deletions(-)


