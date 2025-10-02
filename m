Return-Path: <kvm+bounces-59388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 128FBBB2821
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 07:14:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 84C3D188A8B5
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 05:14:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D04482874F7;
	Thu,  2 Oct 2025 05:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tKjmGIwo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AE725DCF0
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 05:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759382038; cv=none; b=tlO+kqCAKi2/68+Wg5LvB5PwGg+/CeST5dj3QMs/NAbT2+m88r+jFPwyqLq/0SIVEwhOF7VytQL14TfNdfyakR7L0ghGknOKQ00b2oSemdxptvykaQxiXQ4nZXifjeTJ4jjub1TSO01Tcqlz0jveSNPw29KSYbWi8ANfIuz4F9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759382038; c=relaxed/simple;
	bh=+C8SUSy6jlR3e8+g7UmqQuxTPgvPCgSH4vPdyhcFMHo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RWFr3p6DKWtmjngFk8msr8PaGgAk1p7wM96DOhSSFCPTATcV6OEMyqj+NrvspUE2ei7aKdVYlevDGt7AZCDWJ6pxmycvVpZv4qZmEGGWngKoccctD/JeXZnFXQFsDcL+QuPSWJe4LmWa51U90r+FX7gn+q26fskZe3uyDV/3x2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tKjmGIwo; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3fc36b99e92so1336447f8f.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 22:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759382035; x=1759986835; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ReRBTBalpXsueh+TsF1pHYsiu5KMMWmDk/Bn5JLfYwQ=;
        b=tKjmGIwo8rO5EVvIyUNcKArAmOc/8cbMguk07PrXlQfLQgEfhVWZK4LXnlbNgDDcAz
         NqI5CgdjjgMp7XvXVSuiRqW/HiaJjqqMGBxjn6Ewyn1U6LbZNuKucQ2Ua+WmxOCaJNjI
         +vieXDlAWFyK9JablAhHzFEoP8s3JWTCjMAsRsAPHM3/JX/fTqbXG4M7lM3YwTTPfNob
         hgs9rYiwwv5e6VAUGyOzAgfrP+4Hcfxstw5Se7+VVmULVJGuer0N8ccca0Jzm0bdAwcu
         uZXaxu3MDTHAL/aeDcxsZiO4z5dL9CpP9jL21SkKfKjhl75mY3ve39NRKCLKAjx3Oyb4
         ec8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759382035; x=1759986835;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ReRBTBalpXsueh+TsF1pHYsiu5KMMWmDk/Bn5JLfYwQ=;
        b=qEn3HY+WSL8Lq2IiMcnVu68wB9t1600MVibqHMG+ZcOVMvjsVYNMAyQ3KazSHIpSNu
         3buqpfhEJXnh06nduQszuyo4SKWrzajsm8UUcOIeo0cIZ6kwr+mDTc6XOfEstJCvFrdT
         2bNAX+Rdd+bUxiDRJ9YWqKbAZWw8YySWNg1PpsdLqs+BRzpAQIuB3XVoWkNe2LevQg5w
         o2+ZLyrjt8RRmq0Ku9eTiFPSUnpH6B9lnnirVkh9zLGAbH1Rprb7DNu/E6meksSgccQY
         qJM9jZZziptpyQS9SOBOfeRU4x6Z0xhlR2/k54lbvWt6pGulLhFGoy58Ahkeb9UfWSl3
         yNjw==
X-Forwarded-Encrypted: i=1; AJvYcCVP3k3ldCJnwmP9mJnmglv7tjDvddHBVw5byQtZy8o3lFq/zfBSkssQKJt8zOReZCZ78y8=@vger.kernel.org
X-Gm-Message-State: AOJu0YylcOF6zOsYrs1NpY7ItAVoiusgHmuJrstJij2lwLYFR8wTdQD3
	zD2Q1yaxx06xpoVa+RFpO3PIjGvVoxpQtXrQHmH9qzPHtVNeiDnDpj019IQkBYN4Hzc=
X-Gm-Gg: ASbGnct//kCervA9bT0MH5KJvvca+ZvXPkKnHs4ex1rx9lOKV2fk+b0KHmKPmY2ehW+
	9VczKul/IPWbDx2Br0/gblo/LbJtJtozhHcY7z5/yB08/WxSNfQ22DBwhcKpVXQHkDv/EmwZfO9
	4yg64OJGrBhCAU1Y4htF4PIwOqmiNgJ3KtbOsgeYUDA+1VJnbkHFfFHY/BLV/NrRcn2/bPHi80t
	DXh8HQGZWPGO501Htk5DojlhlM4gzxHZUlJ+gF1rLu+8coeB1qRJDtKqpKHDm3agw1K9av+a2Zf
	0+GTuDOJ3wFjeU+OcTCffQkFpfpo48QFYk+U+4Ypj6SVaF4AVX6irSmU8D4GeQUIl+3YDOw7Ami
	naoE5FZvpJLyv31RvNzYX3j10NBzP741aG3yThzmr+vA6e+l9e9culJg/eZnu8Sag5lrig4UnKj
	pbPbOaCSRpWzp0bV+Eabw1905neqbxFAe5Rg==
X-Google-Smtp-Source: AGHT+IGu8zkDxeaLR+haP7gROe9lLguDX6Q2Ka0iyfeayjeG0zV0XhPYG/6/TcB+b7nkClimerFCGw==
X-Received: by 2002:a05:6000:22c9:b0:3fa:ebaf:4c53 with SMTP id ffacd0b85a97d-4255d2d64d2mr1205748f8f.29.1759382034588;
        Wed, 01 Oct 2025 22:13:54 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8a6b5csm1971355f8f.5.2025.10.01.22.13.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 22:13:53 -0700 (PDT)
Message-ID: <749894d1-7301-419c-8a10-3ffbada016e3@linaro.org>
Date: Thu, 2 Oct 2025 07:13:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 11/23] whpx: add arm64 support
Content-Language: en-US
To: Mohamed Mediouni <mohamed@unpredictable.fr>, qemu-devel@nongnu.org,
 Richard Henderson <richard.henderson@linaro.org>
Cc: Shannon Zhao <shannon.zhaosl@gmail.com>,
 Yanan Wang <wangyanan55@huawei.com>, Phil Dennis-Jordan
 <phil@philjordan.eu>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?=
 <marcandre.lureau@redhat.com>, Mads Ynddal <mads@ynddal.dk>,
 Cameron Esfahani <dirty@apple.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 kvm@vger.kernel.org, Igor Mammedov <imammedo@redhat.com>,
 qemu-arm@nongnu.org, Roman Bolshakov <rbolshakov@ddn.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, Alexander Graf <agraf@csgraf.de>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Eduardo Habkost <eduardo@habkost.net>, Ani Sinha <anisinha@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Peter Maydell <peter.maydell@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>
References: <20250920140124.63046-1-mohamed@unpredictable.fr>
 <20250920140124.63046-12-mohamed@unpredictable.fr>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250920140124.63046-12-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Mohamed,

On 20/9/25 16:01, Mohamed Mediouni wrote:
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> 
> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   accel/whpx/whpx-common.c    |   1 +
>   target/arm/meson.build      |   1 +
>   target/arm/whpx/meson.build |   3 +
>   target/arm/whpx/whpx-all.c  | 848 ++++++++++++++++++++++++++++++++++++
>   4 files changed, 853 insertions(+)
>   create mode 100644 target/arm/whpx/meson.build
>   create mode 100644 target/arm/whpx/whpx-all.c


> +struct whpx_reg_match {
> +    WHV_REGISTER_NAME reg;
> +    uint64_t offset;
> +};
> +
> +static const struct whpx_reg_match whpx_reg_match[] = {
> +    { WHvArm64RegisterX0,   offsetof(CPUARMState, xregs[0]) },
> +    { WHvArm64RegisterX1,   offsetof(CPUARMState, xregs[1]) },
> +    { WHvArm64RegisterX2,   offsetof(CPUARMState, xregs[2]) },
> +    { WHvArm64RegisterX3,   offsetof(CPUARMState, xregs[3]) },
> +    { WHvArm64RegisterX4,   offsetof(CPUARMState, xregs[4]) },
> +    { WHvArm64RegisterX5,   offsetof(CPUARMState, xregs[5]) },
> +    { WHvArm64RegisterX6,   offsetof(CPUARMState, xregs[6]) },
> +    { WHvArm64RegisterX7,   offsetof(CPUARMState, xregs[7]) },
> +    { WHvArm64RegisterX8,   offsetof(CPUARMState, xregs[8]) },
> +    { WHvArm64RegisterX9,   offsetof(CPUARMState, xregs[9]) },
> +    { WHvArm64RegisterX10,  offsetof(CPUARMState, xregs[10]) },
> +    { WHvArm64RegisterX11,  offsetof(CPUARMState, xregs[11]) },
> +    { WHvArm64RegisterX12,  offsetof(CPUARMState, xregs[12]) },
> +    { WHvArm64RegisterX13,  offsetof(CPUARMState, xregs[13]) },
> +    { WHvArm64RegisterX14,  offsetof(CPUARMState, xregs[14]) },
> +    { WHvArm64RegisterX15,  offsetof(CPUARMState, xregs[15]) },
> +    { WHvArm64RegisterX16,  offsetof(CPUARMState, xregs[16]) },
> +    { WHvArm64RegisterX17,  offsetof(CPUARMState, xregs[17]) },
> +    { WHvArm64RegisterX18,  offsetof(CPUARMState, xregs[18]) },
> +    { WHvArm64RegisterX19,  offsetof(CPUARMState, xregs[19]) },
> +    { WHvArm64RegisterX20,  offsetof(CPUARMState, xregs[20]) },
> +    { WHvArm64RegisterX21,  offsetof(CPUARMState, xregs[21]) },
> +    { WHvArm64RegisterX22,  offsetof(CPUARMState, xregs[22]) },
> +    { WHvArm64RegisterX23,  offsetof(CPUARMState, xregs[23]) },
> +    { WHvArm64RegisterX24,  offsetof(CPUARMState, xregs[24]) },
> +    { WHvArm64RegisterX25,  offsetof(CPUARMState, xregs[25]) },
> +    { WHvArm64RegisterX26,  offsetof(CPUARMState, xregs[26]) },
> +    { WHvArm64RegisterX27,  offsetof(CPUARMState, xregs[27]) },
> +    { WHvArm64RegisterX28,  offsetof(CPUARMState, xregs[28]) },
> +    { WHvArm64RegisterFp,  offsetof(CPUARMState, xregs[29]) },
> +    { WHvArm64RegisterLr,  offsetof(CPUARMState, xregs[30]) },
> +    { WHvArm64RegisterPc,   offsetof(CPUARMState, pc) },
> +};
> +
> +static const struct whpx_reg_match whpx_fpreg_match[] = {
> +    { WHvArm64RegisterQ0,  offsetof(CPUARMState, vfp.zregs[0]) },
> +    { WHvArm64RegisterQ1,  offsetof(CPUARMState, vfp.zregs[1]) },
> +    { WHvArm64RegisterQ2,  offsetof(CPUARMState, vfp.zregs[2]) },
> +    { WHvArm64RegisterQ3,  offsetof(CPUARMState, vfp.zregs[3]) },
> +    { WHvArm64RegisterQ4,  offsetof(CPUARMState, vfp.zregs[4]) },
> +    { WHvArm64RegisterQ5,  offsetof(CPUARMState, vfp.zregs[5]) },
> +    { WHvArm64RegisterQ6,  offsetof(CPUARMState, vfp.zregs[6]) },
> +    { WHvArm64RegisterQ7,  offsetof(CPUARMState, vfp.zregs[7]) },
> +    { WHvArm64RegisterQ8,  offsetof(CPUARMState, vfp.zregs[8]) },
> +    { WHvArm64RegisterQ9,  offsetof(CPUARMState, vfp.zregs[9]) },
> +    { WHvArm64RegisterQ10, offsetof(CPUARMState, vfp.zregs[10]) },
> +    { WHvArm64RegisterQ11, offsetof(CPUARMState, vfp.zregs[11]) },
> +    { WHvArm64RegisterQ12, offsetof(CPUARMState, vfp.zregs[12]) },
> +    { WHvArm64RegisterQ13, offsetof(CPUARMState, vfp.zregs[13]) },
> +    { WHvArm64RegisterQ14, offsetof(CPUARMState, vfp.zregs[14]) },
> +    { WHvArm64RegisterQ15, offsetof(CPUARMState, vfp.zregs[15]) },
> +    { WHvArm64RegisterQ16, offsetof(CPUARMState, vfp.zregs[16]) },
> +    { WHvArm64RegisterQ17, offsetof(CPUARMState, vfp.zregs[17]) },
> +    { WHvArm64RegisterQ18, offsetof(CPUARMState, vfp.zregs[18]) },
> +    { WHvArm64RegisterQ19, offsetof(CPUARMState, vfp.zregs[19]) },
> +    { WHvArm64RegisterQ20, offsetof(CPUARMState, vfp.zregs[20]) },
> +    { WHvArm64RegisterQ21, offsetof(CPUARMState, vfp.zregs[21]) },
> +    { WHvArm64RegisterQ22, offsetof(CPUARMState, vfp.zregs[22]) },
> +    { WHvArm64RegisterQ23, offsetof(CPUARMState, vfp.zregs[23]) },
> +    { WHvArm64RegisterQ24, offsetof(CPUARMState, vfp.zregs[24]) },
> +    { WHvArm64RegisterQ25, offsetof(CPUARMState, vfp.zregs[25]) },
> +    { WHvArm64RegisterQ26, offsetof(CPUARMState, vfp.zregs[26]) },
> +    { WHvArm64RegisterQ27, offsetof(CPUARMState, vfp.zregs[27]) },
> +    { WHvArm64RegisterQ28, offsetof(CPUARMState, vfp.zregs[28]) },
> +    { WHvArm64RegisterQ29, offsetof(CPUARMState, vfp.zregs[29]) },
> +    { WHvArm64RegisterQ30, offsetof(CPUARMState, vfp.zregs[30]) },
> +    { WHvArm64RegisterQ31, offsetof(CPUARMState, vfp.zregs[31]) },
> +};
> +
> +#define WHPX_SYSREG(crn, crm, op0, op1, op2) \
> +        ENCODE_AA64_CP_REG(CP_REG_ARM64_SYSREG_CP, crn, crm, op0, op1, op2)
> +
> +struct whpx_sreg_match {
> +    WHV_REGISTER_NAME reg;
> +    uint32_t key;
> +    bool global;
> +    uint32_t cp_idx;
> +};
> +
> +static struct whpx_sreg_match whpx_sreg_match[] = {
> +    { WHvArm64RegisterDbgbvr0El1, WHPX_SYSREG(0, 0, 2, 0, 4) },
> +    { WHvArm64RegisterDbgbcr0El1, WHPX_SYSREG(0, 0, 2, 0, 5) },
> +    { WHvArm64RegisterDbgwvr0El1, WHPX_SYSREG(0, 0, 2, 0, 6) },
> +    { WHvArm64RegisterDbgwcr0El1, WHPX_SYSREG(0, 0, 2, 0, 7) },
> +
> +    { WHvArm64RegisterDbgbvr0El1, WHPX_SYSREG(0, 1, 2, 0, 4) },
> +    { WHvArm64RegisterDbgbcr0El1, WHPX_SYSREG(0, 1, 2, 0, 5) },
> +    { WHvArm64RegisterDbgwvr0El1, WHPX_SYSREG(0, 1, 2, 0, 6) },
> +    { WHvArm64RegisterDbgwcr0El1, WHPX_SYSREG(0, 1, 2, 0, 7) },
> +
> +    { WHvArm64RegisterDbgbvr2El1, WHPX_SYSREG(0, 2, 2, 0, 4) },
> +    { WHvArm64RegisterDbgbcr2El1, WHPX_SYSREG(0, 2, 2, 0, 5) },
> +    { WHvArm64RegisterDbgwvr2El1, WHPX_SYSREG(0, 2, 2, 0, 6) },
> +    { WHvArm64RegisterDbgwcr2El1, WHPX_SYSREG(0, 2, 2, 0, 7) },
> +
> +    { WHvArm64RegisterDbgbvr3El1, WHPX_SYSREG(0, 3, 2, 0, 4) },
> +    { WHvArm64RegisterDbgbcr3El1, WHPX_SYSREG(0, 3, 2, 0, 5) },
> +    { WHvArm64RegisterDbgwvr3El1, WHPX_SYSREG(0, 3, 2, 0, 6) },
> +    { WHvArm64RegisterDbgwcr3El1, WHPX_SYSREG(0, 3, 2, 0, 7) },
> +
> +    { WHvArm64RegisterDbgbvr4El1, WHPX_SYSREG(0, 4, 2, 0, 4) },
> +    { WHvArm64RegisterDbgbcr4El1, WHPX_SYSREG(0, 4, 2, 0, 5) },
> +    { WHvArm64RegisterDbgwvr4El1, WHPX_SYSREG(0, 4, 2, 0, 6) },
> +    { WHvArm64RegisterDbgwcr4El1, WHPX_SYSREG(0, 4, 2, 0, 7) },
> +
> +    { WHvArm64RegisterDbgbvr5El1, WHPX_SYSREG(0, 5, 2, 0, 4) },
> +    { WHvArm64RegisterDbgbcr5El1, WHPX_SYSREG(0, 5, 2, 0, 5) },
> +    { WHvArm64RegisterDbgwvr5El1, WHPX_SYSREG(0, 5, 2, 0, 6) },
> +    { WHvArm64RegisterDbgwcr5El1, WHPX_SYSREG(0, 5, 2, 0, 7) },
> +
> +    { WHvArm64RegisterDbgbvr6El1, WHPX_SYSREG(0, 6, 2, 0, 4) },
> +    { WHvArm64RegisterDbgbcr6El1, WHPX_SYSREG(0, 6, 2, 0, 5) },
> +    { WHvArm64RegisterDbgwvr6El1, WHPX_SYSREG(0, 6, 2, 0, 6) },
> +    { WHvArm64RegisterDbgwcr6El1, WHPX_SYSREG(0, 6, 2, 0, 7) },
> +
> +    { WHvArm64RegisterDbgbvr7El1, WHPX_SYSREG(0, 7, 2, 0, 4) },
> +    { WHvArm64RegisterDbgbcr7El1, WHPX_SYSREG(0, 7, 2, 0, 5) },
> +    { WHvArm64RegisterDbgwvr7El1, WHPX_SYSREG(0, 7, 2, 0, 6) },
> +    { WHvArm64RegisterDbgwcr7El1, WHPX_SYSREG(0, 7, 2, 0, 7) },
> +
> +    { WHvArm64RegisterDbgbvr8El1, WHPX_SYSREG(0, 8, 2, 0, 4) },
> +    { WHvArm64RegisterDbgbcr8El1, WHPX_SYSREG(0, 8, 2, 0, 5) },
> +    { WHvArm64RegisterDbgwvr8El1, WHPX_SYSREG(0, 8, 2, 0, 6) },
> +    { WHvArm64RegisterDbgwcr8El1, WHPX_SYSREG(0, 8, 2, 0, 7) },
> +
> +    { WHvArm64RegisterDbgbvr9El1, WHPX_SYSREG(0, 9, 2, 0, 4) },
> +    { WHvArm64RegisterDbgbcr9El1, WHPX_SYSREG(0, 9, 2, 0, 5) },
> +    { WHvArm64RegisterDbgwvr9El1, WHPX_SYSREG(0, 9, 2, 0, 6) },
> +    { WHvArm64RegisterDbgwcr9El1, WHPX_SYSREG(0, 9, 2, 0, 7) },
> +
> +    { WHvArm64RegisterDbgbvr10El1, WHPX_SYSREG(0, 10, 2, 0, 4) },
> +    { WHvArm64RegisterDbgbcr10El1, WHPX_SYSREG(0, 10, 2, 0, 5) },
> +    { WHvArm64RegisterDbgwvr10El1, WHPX_SYSREG(0, 10, 2, 0, 6) },
> +    { WHvArm64RegisterDbgwcr10El1, WHPX_SYSREG(0, 10, 2, 0, 7) },
> +
> +    { WHvArm64RegisterDbgbvr11El1, WHPX_SYSREG(0, 11, 2, 0, 4) },
> +    { WHvArm64RegisterDbgbcr11El1, WHPX_SYSREG(0, 11, 2, 0, 5) },
> +    { WHvArm64RegisterDbgwvr11El1, WHPX_SYSREG(0, 11, 2, 0, 6) },
> +    { WHvArm64RegisterDbgwcr11El1, WHPX_SYSREG(0, 11, 2, 0, 7) },
> +
> +    { WHvArm64RegisterDbgbvr12El1, WHPX_SYSREG(0, 12, 2, 0, 4) },
> +    { WHvArm64RegisterDbgbcr12El1, WHPX_SYSREG(0, 12, 2, 0, 5) },
> +    { WHvArm64RegisterDbgwvr12El1, WHPX_SYSREG(0, 12, 2, 0, 6) },
> +    { WHvArm64RegisterDbgwcr12El1, WHPX_SYSREG(0, 12, 2, 0, 7) },
> +
> +    { WHvArm64RegisterDbgbvr13El1, WHPX_SYSREG(0, 13, 2, 0, 4) },
> +    { WHvArm64RegisterDbgbcr13El1, WHPX_SYSREG(0, 13, 2, 0, 5) },
> +    { WHvArm64RegisterDbgwvr13El1, WHPX_SYSREG(0, 13, 2, 0, 6) },
> +    { WHvArm64RegisterDbgwcr13El1, WHPX_SYSREG(0, 13, 2, 0, 7) },
> +
> +    { WHvArm64RegisterDbgbvr14El1, WHPX_SYSREG(0, 14, 2, 0, 4) },
> +    { WHvArm64RegisterDbgbcr14El1, WHPX_SYSREG(0, 14, 2, 0, 5) },
> +    { WHvArm64RegisterDbgwvr14El1, WHPX_SYSREG(0, 14, 2, 0, 6) },
> +    { WHvArm64RegisterDbgwcr14El1, WHPX_SYSREG(0, 14, 2, 0, 7) },
> +
> +    { WHvArm64RegisterDbgbvr15El1, WHPX_SYSREG(0, 15, 2, 0, 4) },
> +    { WHvArm64RegisterDbgbcr15El1, WHPX_SYSREG(0, 15, 2, 0, 5) },
> +    { WHvArm64RegisterDbgwvr15El1, WHPX_SYSREG(0, 15, 2, 0, 6) },
> +    { WHvArm64RegisterDbgwcr15El1, WHPX_SYSREG(0, 15, 2, 0, 7) },
> +#ifdef SYNC_NO_RAW_REGS
> +    /*
> +     * The registers below are manually synced on init because they are
> +     * marked as NO_RAW. We still list them to make number space sync easier.
> +     */
> +    { WHvArm64RegisterMidrEl1, WHPX_SYSREG(0, 0, 3, 0, 0) },
> +    { WHvArm64RegisterMpidrEl1, WHPX_SYSREG(0, 0, 3, 0, 5) },
> +    { WHvArm64RegisterIdPfr0El1, WHPX_SYSREG(0, 4, 3, 0, 0) },
> +#endif
> +    { WHvArm64RegisterIdAa64Pfr1El1, WHPX_SYSREG(0, 4, 3, 0, 1), true },
> +    { WHvArm64RegisterIdAa64Dfr0El1, WHPX_SYSREG(0, 5, 3, 0, 0), true },
> +    { WHvArm64RegisterIdAa64Dfr1El1, WHPX_SYSREG(0, 5, 3, 0, 1), true },
> +    { WHvArm64RegisterIdAa64Isar0El1, WHPX_SYSREG(0, 6, 3, 0, 0), true },
> +    { WHvArm64RegisterIdAa64Isar1El1, WHPX_SYSREG(0, 6, 3, 0, 1), true },
> +#ifdef SYNC_NO_MMFR0
> +    /* We keep the hardware MMFR0 around. HW limits are there anyway */
> +    { WHvArm64RegisterIdAa64Mmfr0El1, WHPX_SYSREG(0, 7, 3, 0, 0) },
> +#endif
> +    { WHvArm64RegisterIdAa64Mmfr1El1, WHPX_SYSREG(0, 7, 3, 0, 1), true },
> +    { WHvArm64RegisterIdAa64Mmfr2El1, WHPX_SYSREG(0, 7, 3, 0, 2), true },
> +    { WHvArm64RegisterIdAa64Mmfr3El1, WHPX_SYSREG(0, 7, 3, 0, 3), true },
> +
> +    { WHvArm64RegisterMdscrEl1, WHPX_SYSREG(0, 2, 2, 0, 2) },
> +    { WHvArm64RegisterSctlrEl1, WHPX_SYSREG(1, 0, 3, 0, 0) },
> +    { WHvArm64RegisterCpacrEl1, WHPX_SYSREG(1, 0, 3, 0, 2) },
> +    { WHvArm64RegisterTtbr0El1, WHPX_SYSREG(2, 0, 3, 0, 0) },
> +    { WHvArm64RegisterTtbr1El1, WHPX_SYSREG(2, 0, 3, 0, 1) },
> +    { WHvArm64RegisterTcrEl1, WHPX_SYSREG(2, 0, 3, 0, 2) },
> +
> +    { WHvArm64RegisterApiAKeyLoEl1, WHPX_SYSREG(2, 1, 3, 0, 0) },
> +    { WHvArm64RegisterApiAKeyHiEl1, WHPX_SYSREG(2, 1, 3, 0, 1) },
> +    { WHvArm64RegisterApiBKeyLoEl1, WHPX_SYSREG(2, 1, 3, 0, 2) },
> +    { WHvArm64RegisterApiBKeyHiEl1, WHPX_SYSREG(2, 1, 3, 0, 3) },
> +    { WHvArm64RegisterApdAKeyLoEl1, WHPX_SYSREG(2, 2, 3, 0, 0) },
> +    { WHvArm64RegisterApdAKeyHiEl1, WHPX_SYSREG(2, 2, 3, 0, 1) },
> +    { WHvArm64RegisterApdBKeyLoEl1, WHPX_SYSREG(2, 2, 3, 0, 2) },
> +    { WHvArm64RegisterApdBKeyHiEl1, WHPX_SYSREG(2, 2, 3, 0, 3) },
> +    { WHvArm64RegisterApgAKeyLoEl1, WHPX_SYSREG(2, 3, 3, 0, 0) },
> +    { WHvArm64RegisterApgAKeyHiEl1, WHPX_SYSREG(2, 3, 3, 0, 1) },
> +
> +    { WHvArm64RegisterSpsrEl1, WHPX_SYSREG(4, 0, 3, 0, 0) },
> +    { WHvArm64RegisterElrEl1, WHPX_SYSREG(4, 0, 3, 0, 1) },
> +    { WHvArm64RegisterSpEl1, WHPX_SYSREG(4, 1, 3, 0, 0) },
> +    { WHvArm64RegisterEsrEl1, WHPX_SYSREG(5, 2, 3, 0, 0) },
> +    { WHvArm64RegisterFarEl1, WHPX_SYSREG(6, 0, 3, 0, 0) },
> +    { WHvArm64RegisterParEl1, WHPX_SYSREG(7, 4, 3, 0, 0) },
> +    { WHvArm64RegisterMairEl1, WHPX_SYSREG(10, 2, 3, 0, 0) },
> +    { WHvArm64RegisterVbarEl1, WHPX_SYSREG(12, 0, 3, 0, 0) },
> +    { WHvArm64RegisterContextidrEl1, WHPX_SYSREG(13, 0, 3, 0, 1) },
> +    { WHvArm64RegisterTpidrEl1, WHPX_SYSREG(13, 0, 3, 0, 4) },
> +    { WHvArm64RegisterCntkctlEl1, WHPX_SYSREG(14, 1, 3, 0, 0) },
> +    { WHvArm64RegisterCsselrEl1, WHPX_SYSREG(0, 0, 3, 2, 0) },
> +    { WHvArm64RegisterTpidrEl0, WHPX_SYSREG(13, 0, 3, 3, 2) },
> +    { WHvArm64RegisterTpidrroEl0, WHPX_SYSREG(13, 0, 3, 3, 3) },
> +    { WHvArm64RegisterCntvCtlEl0, WHPX_SYSREG(14, 3, 3, 3, 1) },
> +    { WHvArm64RegisterCntvCvalEl0, WHPX_SYSREG(14, 3, 3, 3, 2) },
> +    { WHvArm64RegisterSpEl1, WHPX_SYSREG(4, 1, 3, 4, 0) },
> +};
To ease maintenance, this array should follow this equivalent
changeset:

$ git log --oneline a648af4885b~..bffe756ea10
bffe756ea10 target/arm/hvf: Sort the cpreg_indexes array
98c2af435e6 target/arm/hvf: Replace hvf_sreg_match with hvf_sreg_list
e6728fb3492 target/arm/hvf: Remove hvf_sreg_match.key
7d4d89a4377 target/arm/hvf: Add KVMID_TO_HVF, HVF_TO_KVMID
8da60618b6d target/arm/hvf: Reorder DEF_SYSREG arguments
a648af4885b target/arm/hvf: Split out sysreg.c.inc

