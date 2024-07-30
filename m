Return-Path: <kvm+bounces-22687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DBC8C941F27
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 20:01:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C83E1F24A0A
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 18:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2D5718991A;
	Tue, 30 Jul 2024 18:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rzp6td/y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838991A76C5
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 18:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722362462; cv=none; b=QILmPSDCzpfcopAOY03PhYQgPwJZ1P897MQqU8sfTVatV40QB8ZTPgFB9h2m9D7Z4CNTD52qDov4ul0Bp8SazQR6Pgm+xocsuE8N5p2RJua8AHw1IDd6HpTAg48pZS4ZOwRY6bIPCQfFxK06sDG4n42W6buK7/B0NLDOsklcQWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722362462; c=relaxed/simple;
	bh=9clhoVreU2N/nXr+10v0kwlUjt4vVJ2U2EbtVOSvxOs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LucLTA8k3DmeQUj6YCLzNQc0Jpd8Hregk3fwQEDhcw2UplJZWRvyuPaQEsGzQTMhLXS/fczdMsc32nY7hA6d3DpalxVuyc2IcHwlEUykhN7tX+6Xn/nl0DsM8uPX4nmYatBOXZLZp7qL8JazEBhg/YX1jqMym+rPkZ1TaOmtImw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rzp6td/y; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-650ab31aabdso77981437b3.3
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 11:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722362459; x=1722967259; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ukEjow9DcWXrb9MV8XjnrC3aUUwwEyCM45VOz1brskg=;
        b=Rzp6td/ymKS8mJ5KJfewpd6cJL3vlpIWZZl5dBOy+CcevQiQr53PIYDjhSbIbWlCEU
         jC3mngSPR133OrN5SlmTGJL+2l11TwbOhxHSxr+U8oZ5/nERaZJOYoGbDhhmH4cSqzkf
         kSp7AWC20dBdRrLK//3W7CsN41YKaQXuoiJT7AOiZpWF3i3WYCMz3s7gyQ25jgXS6IHh
         1e8E/eekjyRsehOuHmo9j04d5JBhTYp9Sz7c0SqgzoNS7mgPcGwkgJLJ7Im+VZ7si5zg
         tl6JiW+DnFznSQFVyKfwqr4LGmXwVx8NsTT5/6SmG34D4E3Bx+shLmFCc5jBJV7AKQJw
         qPxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722362459; x=1722967259;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ukEjow9DcWXrb9MV8XjnrC3aUUwwEyCM45VOz1brskg=;
        b=mzDmfOJRTQn3Jq+7FZLEgJNvIp7EuBBdQ/2sv4nH/lL9wKhwgQU2rRMkuLoZdFe0GF
         9Cgzt7OcEXarGJkor8B/GELqw8Z5sPkpnWKFLDmG2bZAEDZf63qhV3wqGvyldiUoKPst
         5t3l4gIvM17QY4cxb5fVicEqm3zKHNvYhx9B6+4Lk22NbxsNW/zQgDFt1ycch2ynbJyi
         /6yIlb1ms1IU+KO3jDd7bvx2Tc/VaMrLes/hWsH+JMClXBpozI0gcG/CRSHmpB5IO+9W
         Ne6uRxIJLiE2vP6toMrqglGLMEOmjg7VWIUSRezIQMxk91u7onTqSybQkRVu3GYwzBQc
         FYtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXE76gJrrliHIXVkY2g0YvzvjyHFOVoim7yoQZIjSfEKdVxBDEGrx0cWMyGfX3kLixjlq2R36OBIfq3NnbaZ4WkJy/L
X-Gm-Message-State: AOJu0YzClgKpI7oAntkKAMy/pdZEXpHgZ9hjelSSyJnAzgI/MAqpnV8i
	7MgIgdMJKYS/cjBTlZZeY3zwbEfxgnPIoTT436335vTxise1mctoD9ZTMAr5qh9MW2RS6y9u5NC
	tFQ==
X-Google-Smtp-Source: AGHT+IHufTn+BQ1jTs+XXzxBmA6Be+2G2qQD2Bu1RfSBbycKZB4JjM9TkNXOpnLclwUFEbXk8QOLQe4qk50=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1549:b0:e05:eccb:95dc with SMTP id
 3f1490d57ef6-e0b5445f558mr154305276.6.1722362459366; Tue, 30 Jul 2024
 11:00:59 -0700 (PDT)
Date: Tue, 30 Jul 2024 11:00:57 -0700
In-Reply-To: <20240730174751.15824-1-john.allen@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240730174751.15824-1-john.allen@amd.com>
Message-ID: <ZqkqWTCa6GdeVykw@google.com>
Subject: Re: [PATCH] KVM: x86: Advertise SUCCOR and OVERFLOW_RECOV cpuid bits
From: Sean Christopherson <seanjc@google.com>
To: John Allen <john.allen@amd.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	bp@alien8.de, mlevitsk@redhat.com, linux-kernel@vger.kernel.org, 
	x86@kernel.org, yazen.ghannam@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 30, 2024, John Allen wrote:
> Handling deferred, uncorrected MCEs on AMD guests is now possible with
> additional support in qemu. Ensure that the SUCCOR and OVERFLOW_RECOV
> bits are advertised to the guest in KVM.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
>  arch/x86/kvm/cpuid.c   | 2 +-
>  arch/x86/kvm/svm/svm.c | 7 +++++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 2617be544480..4745098416c3 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1241,7 +1241,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  
>  		/* mask against host */
>  		entry->edx &= boot_cpu_data.x86_power;
> -		entry->eax = entry->ebx = entry->ecx = 0;
> +		entry->eax = entry->ecx = 0;

Needs an override to prevent reporting all of EBX to userspace.

		cpuid_entry_override(entry, CPUID_8000_0007_EBX);

>  		break;
>  	case 0x80000008: {
>  		/*
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c115d26844f7..a6820b0915db 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5199,6 +5199,13 @@ static __init void svm_set_cpu_caps(void)
>  		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
>  	}
>  
> +	/* CPUID 0x80000007 */
> +	if (boot_cpu_has(X86_FEATURE_SUCCOR))
> +		kvm_cpu_cap_set(X86_FEATURE_SUCCOR);
> +
> +	if (boot_cpu_has(X86_FEATURE_OVERFLOW_RECOV))
> +		kvm_cpu_cap_set(X86_FEATURE_OVERFLOW_RECOV);

This _could_ use kvm_cpu_cap_check_and_set(), but given that this an AMD specific
leaf and unlikely to ever be used by Intel, I'm inclined to handle this in cpuid.c,
with an opporunustic "conversion" to one feature per line[*]:

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2617be544480..ea11a7e45174 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -743,6 +743,11 @@ void kvm_set_cpu_caps(void)
        if (!tdp_enabled && IS_ENABLED(CONFIG_X86_64))
                kvm_cpu_cap_set(X86_FEATURE_GBPAGES);
 
+       kvm_cpu_cap_mask(CPUID_8000_0007_EBX,
+               F(OVERFLOW_RECOV) |
+               F(SUCCOR)
+       );
+
        kvm_cpu_cap_init_kvm_defined(CPUID_8000_0007_EDX,
                SF(CONSTANT_TSC)
        );


[*] https://lore.kernel.org/all/ZoxooTvO5vIEnS5V@google.com

