Return-Path: <kvm+bounces-46318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03F0FAB50E1
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:05:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FB4A188121C
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE73242D8C;
	Tue, 13 May 2025 10:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dvuAijKI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1690023A989
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747130448; cv=none; b=c2PVpajv1DDw6W0D3yDAvVgvAMQmsuUPB1BaJNPIjRZXDxivYWZHZpI5ZVVmFiYj0/SbM8nciBi/1VT1ELbp37Sz+gA7DpF2/yqZbVoE39oJa9kBfCm2sPYaKLsZlgE8ntK6igo+mDkPwpNm8XMzVDz6hHDMpbiXO5NbFO0Ekgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747130448; c=relaxed/simple;
	bh=TM9Cunbn5+Apn5c0PZIB8feY6cZT73m8lhjti2zhpt4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EVLAkDIvyEhR7wPb6S4NMNlYUwE0b7JgfXsbFMfx6djDIY3DyPmhsePcUr8qH2bw5/Q6631rZ0EqIAGfZVjLJLquckTp4zTa+apih0uyEQA0NZD8qhL9FVFPKNq5VBi9G2EutJ93ceNgU4pRQfI6Wkr+kwuU1EbalvsBmHGOrFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dvuAijKI; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43cf628cb14so43828755e9.1
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 03:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747130445; x=1747735245; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A6X/8oxrpAwVwBgKDFjZb6gd7YyOOEgNL2DIro56QAg=;
        b=dvuAijKIpSqjxKmmUW1e8iOo7uNDHnnMLKTnvyR5In8M0cKRKMvBULy/CKNwnG4IzE
         odbhQLV2vAQ8qe57Jf/Sqb1zGh+TnfLS09DwsuFJmQDpX35C+dZZRd9C9oT/PVGDjjmB
         dlC/u9xgqWhz5/cFaDWAVvvU1Pya5kwm7K84Si7C2I3OVP+0semQnzorpV7nhmK8ZF5B
         USQphbrj4wp3UtD609Gdb6Df2VMq0uBT2c7x6+EXaZURIK62jCmmFvwe7YV/9A1g7+bC
         u7b+7Q6iVjth7Qem1PDyj2SGBWBVPZtNIHQFKGmfuUd/dtiZ9NO/ktdMhQtDFJ9Ldbs1
         v+PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747130445; x=1747735245;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A6X/8oxrpAwVwBgKDFjZb6gd7YyOOEgNL2DIro56QAg=;
        b=OwKsPe9XsS/m7ivymNrud9f67f0ksr1FKKhqAJVF+zO0SZ6fU/MJebavn4fpoLMgW9
         la0fDDVvhW2Nw0vJMSKL6h+ET8EGjOun0Um/HfqJA0sVyeayNnxWuEhEBlNJJgFw2OW3
         orXcZtt2Q72nsrwWYtfvkqwYNoZY/lHIxDfK4NRCD196xMzQxQXEqXZwzPDZVDRNQdfQ
         VRwRu+BqXDsrXgowBpcLlh/wQK+SSWoJjcKCOzytQPjEeQ209LyMMnFyziFZh+YAlpu7
         /lLzDTGDj6v0QZ0eHMKcp/SEgD80rinsfklgzaHqKdPEvLGEKv/dYY4IbpC90t8v6yho
         4NaA==
X-Gm-Message-State: AOJu0YwnClKRhG7dpeyLm4Af6VkBx8mafkORneTFunwphyBTfA/QWlrX
	Zk3w9nPKslkSdN1h2gxhTawk8eW5LS0nWBWR28i2DKD2DpfVYzzrNU7hg7231TQ=
X-Gm-Gg: ASbGncugn6SvNyaK4cT63avTjDrUfXKvEWcgdE9zHiB8AjlhDWaETPy/CAbL6TtlMSP
	7qlCVA3YJ4ushV9RpuEcvjo84oGtj8svKhUHTGo2eOhSQZUEuh+h4tY8wPTtwLAzAWRkdR3WG+Y
	dzeO18D/IbvAFhE/KQ+4F8ujPBFpl4BH6PzQcU6MsRxG/rlIf9AEzvr0uIssslxNa7xAC5DEqlD
	7aTkmZsrup8TyMLM80euNNejTizxk1sHtKuYt0v3yywBs25b0PG/oKJUx3oEcSuYu3GbATfs2Sk
	VzxwtWE8ajwhPPSI+JEJUDE7fz4V92mO3Apq2NLtbqeW5zmPrcczt2I+dsgoXkwtXOzxg+1FE85
	d2dVCG8fYWLwk
X-Google-Smtp-Source: AGHT+IE9noWdUSLKLXTSJ+E5Phwdhc/M6/7kGwEv8EQZtG6DJWhggVKOupQOu5BGqxQvxDgrVQ66mg==
X-Received: by 2002:a05:6000:250f:b0:3a1:1215:9bc with SMTP id ffacd0b85a97d-3a340d34583mr2205372f8f.27.1747130445153;
        Tue, 13 May 2025 03:00:45 -0700 (PDT)
Received: from [10.61.1.197] (110.8.30.213.rev.vodafone.pt. [213.30.8.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f58f2a79sm15364718f8f.48.2025.05.13.03.00.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 03:00:44 -0700 (PDT)
Message-ID: <af13ffc1-961f-4f5e-ac32-856faf4f0212@linaro.org>
Date: Tue, 13 May 2025 11:00:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 05/48] target/arm/kvm-stub: add kvm_arm_reset_vcpu stub
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, alex.bennee@linaro.org, anjo@rev.ng,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
 <20250512180502.2395029-6-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250512180502.2395029-6-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/5/25 20:04, Pierrick Bouvier wrote:
> Needed in target/arm/cpu.c once kvm is possible.
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/kvm-stub.c | 5 +++++
>   1 file changed, 5 insertions(+)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


