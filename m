Return-Path: <kvm+bounces-36622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E300A1CE4F
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 21:00:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0979E7A229B
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 20:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D0E9175D4F;
	Sun, 26 Jan 2025 20:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QosqzDY2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156F51487F8
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 20:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737921624; cv=none; b=LutDk3gQLeYaYOHl0uC6q0tIpQYvj1kcp6erZLmZI2Zg92GWGhRxFN8f0FPswB6poXrmtTp7DriuQm90IqQfcjjFhZkqm2fK0HL8P9oeGZ1j4hmsHTvVIvRVEsEQJqBatyzUaSSS8jaBLRAAOZWDLjZNgnvBaPhiBIIt6HXc4c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737921624; c=relaxed/simple;
	bh=ku58px3qBB79+yU0CjeS4CsO72uOtUWAp//TFr9ExMw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T04IaViKc4kH/dS0Jk5gs5rk/+tE9P2SYc0NEtuDK32I63azpk6c811EjybD4zo5Bkg/YcYhpj3puQhoyDPyKP0pXRgcKpmlkOg8all1iiNHVmFbBbL6XkD8GCt3/wYSzSDrgN998RUnsuk4DHupKxauvEb6NeDr2M4/J9v8p90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QosqzDY2; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2167141dfa1so65355075ad.1
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 12:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737921622; x=1738526422; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r4XT8sSxnuMIL4fpPA4fND9osMVr0JW6MvSO5af0S0M=;
        b=QosqzDY2p8s4XRajCye7tQDNJqoiOc1GG5sF1VgzMHl4cyZ5U2rFG0opZDiiDSVn5J
         CbpV7+p5ON5Ku3xy1iJ70j9ajsynQDCxsHemj3hrwE9AEcxYe3u/AkUTv6yj3bRP+ee8
         A+q4Fe5AxROWbEVxp+oJQLSGYi+i4H6B8BPuInTOFydxgPu2ApQYYga5EAYUHiFGt7M7
         W2zfmV5iOOFEi2PjsbDeBloF6w1RA6jBieevanoP+X3yM5tKzgj9Vh3+MpOvU+lY4kOe
         +GBAPvy39/f2zJ8srpP8e89dunXfJ+Hw9Jgu1wBFNuJNm1HJqabIIf5bLroquzWrcIVT
         FETw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737921622; x=1738526422;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r4XT8sSxnuMIL4fpPA4fND9osMVr0JW6MvSO5af0S0M=;
        b=DAo7dboaNHufjeXt7yuBRUIox54aBbrfErBrdbB7xJ5i0r3SlZgml9mYuCA7ZuEek5
         +Zb2YQ7wiA591tS4lf/wnza4urWW5hErDHJyZmypsv6zJ+Vfdkyr9jF5qwrxeWsfPDqW
         XSShjfHdT7oZ2YtuqVV3LtM+v+l3Naa3aWO58NqMCJE4mRmvtw2IXKdfwU53C92nUtYe
         HqgQ/GlTDb9/zuGhWo0wVV84+hna/oFCCTo9vPLxCAAm5M76GXecgv2EKvAc+yD5fmU1
         GFkwfSx5IX0C9HqCJ/ZRw5O0DRO0j7zAKQCHkyFf78oBk3qbyAs0X2R15+6HxYmSSghE
         wXLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrdKzV6nVW6j7D1opQlfp6vLfGFKziXTCK688vXNnNyJ+WFymZnCtGUctPfaYmLptmhVM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yye9SJsUOfVazuNJS/4RxXj4Q9UmJpltssE47X026QcXYWcPEVW
	qPJ1AtCVV9j1fymmFWD7GcKnHMRmPpcllcbxgUxHh75yxB+HTw3+7QFbryNN4B4=
X-Gm-Gg: ASbGncso5of32qxQ8DyT6p62Yfs307XdE9vn4TVE13ClHI/GBtUX38CEH0IMax9yI38
	Yp4RxZVMK4hb6nbYdIwR3qfnzqn9DNKlQ8Y517igSi7Qcfxv5pbYka0VGndb2QPeC3UEjgDlaIO
	LY6cn24byhW7LjaDJUg1lbObR2LqYvliTpi+Ja0tcsEV6MwsZCyys2ExiYE268qMujLPtpPa4Ou
	+mhJ//0tf/4Q8d2waT5zpYMBPUgLxScG4uM0diggX0Qahatkucj/8l9z0XWfnJBBbVhdO8ePLiY
	iQ/4KnjP7biXod6FlNZzl9Oq9kmgJBE7yowiDUek8KtBdsA=
X-Google-Smtp-Source: AGHT+IFeEZa5nVv+mtwIu6A9hZNGU86wznbWhD1KnBdApuLwR5PvKTBdXCajk9Qtynkb/fqX/bwRng==
X-Received: by 2002:a17:903:124b:b0:215:98e7:9b1 with SMTP id d9443c01a7336-21d993177a2mr227130405ad.5.1737921622320;
        Sun, 26 Jan 2025 12:00:22 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da3d9e083sm49207555ad.25.2025.01.26.12.00.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 12:00:21 -0800 (PST)
Message-ID: <bb022c56-2ec9-4e76-9bc6-efe2f7272806@linaro.org>
Date: Sun, 26 Jan 2025 12:00:19 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/20] accel/kvm: Remove unused 'system/cpus.h' header in
 kvm-cpus.h
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, David Hildenbrand <david@redhat.com>,
 qemu-s390x@nongnu.org, xen-devel@lists.xenproject.org
References: <20250123234415.59850-1-philmd@linaro.org>
 <20250123234415.59850-7-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250123234415.59850-7-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/23/25 15:44, Philippe Mathieu-Daudé wrote:
> Missed in commit b86f59c7155 ("accel: replace struct CpusAccel
> with AccelOpsClass") which removed the single CpusAccel use.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   accel/kvm/kvm-cpus.h | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/accel/kvm/kvm-cpus.h b/accel/kvm/kvm-cpus.h
> index b5435286e42..688511151c8 100644
> --- a/accel/kvm/kvm-cpus.h
> +++ b/accel/kvm/kvm-cpus.h
> @@ -10,8 +10,6 @@
>   #ifndef KVM_CPUS_H
>   #define KVM_CPUS_H
>   
> -#include "system/cpus.h"
> -
>   int kvm_init_vcpu(CPUState *cpu, Error **errp);
>   int kvm_cpu_exec(CPUState *cpu);
>   void kvm_destroy_vcpu(CPUState *cpu);

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

