Return-Path: <kvm+bounces-36401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 72477A1A7D4
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 17:25:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A436188C380
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 16:25:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59F49213236;
	Thu, 23 Jan 2025 16:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dK62tGqW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188D612FF69
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 16:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737649521; cv=none; b=ldlgwndDV2HQMc/nKCAFb8sQI1RL9uW1nspqfYMfmPY0yTnEuzb+wxJh0ev2dUcoYXsc7cmok3BFixL7WliKohWu9kShW1ZSdD3w0cvPhdgxfquRp2dDBKF02N7XHf7e3iGHgHcycBJ99YdGp5Nx6gXNwOj3Gf0ObtVm4wP09GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737649521; c=relaxed/simple;
	bh=aLNarEYJyTL1NCCIDRVBboOMwudeY8FI9Le5DHImmWQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WQBEGNdzVwdYKrbuG8oa4p28whvP5JfwPsD2AAFR7ks4D4Nc07E8WX6Q7W2xpv4fJALT4UH820O0FnRKVfVtgvZLtgAE3drxUgYWKtq5wBGUYAuZDvFDC3RJz3CKkVdgjXjWYUy4cSb497hMFz4zL7c2qZcyemF1cuNAbsWkSfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dK62tGqW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef114d8346so2336412a91.0
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 08:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737649519; x=1738254319; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=64SCyRiS1jxS05j2UF5uPNfBJJO/VhtQn/q+gs3Jrf0=;
        b=dK62tGqW8FkPDDF7M7orsEvxDj8sdiDG3qUXxhzzpl5kATZPjd96LI9D8WM+MezjqT
         TfSoRoKYEoZdeVfrvQ5CTn1LKr8AzF/MEIu6pcoEXQL22ZoL2p3dECREB5rqXPt2kQZ2
         P/VWcn0jt7Y2uuSlUSy2iV+xMNL6+Eh05jywhIo8abgRwXrECXgo1DYw7i25EmhAzliP
         QMOMD6rIAgOSar1FZG2hat4YlO/keRD8/mJANCJkJIMdKzIJZjVR+ulXBC49fcdOdZ9E
         MzncQP4YpBvoZowkeNlQKZnnUCwMOUZJOur3ZXzkQPIxi3Uxq9IBQLkRAeHiVk/fWCtD
         C2hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737649519; x=1738254319;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=64SCyRiS1jxS05j2UF5uPNfBJJO/VhtQn/q+gs3Jrf0=;
        b=cmrIi7OCgXQ//yZtoQQMl72wZPj8ilev7whqTzF+Z9h4f59loJIQKazGAxd2z5slKD
         pe5q5gdvADnCKQ7aZofvw9+bkRKWJLimCAsbWJWbZmwjQt7QIHAv/gzZOfKaoPGxkPJq
         ngWTggQfhcS1FLivvsIsUVSPC1e5jeboEeT5Qk0VXAja2I2u29hGPDiXthzn3uYP5igr
         Wo8qaVsrUeQz77yFcViDoOSOv33znrYycymK/3bB9WU/qsANuQRIZ2rhlXK9H393gVK/
         IE3msO50QCiCnoeHPBiOHqalmK8Zn9eRsNX2tNZ8eBKfKfvNF3uQUj5iYA59yUykbieI
         3nEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUY0di14awfRfFUW7jmnt4n+hiwmWd9boatLdyse/JJJKzpqaqjf7JTWHWHN3QtpZv02mY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuCdFwakrNA09Vpa8/7mGoe9aowUt8hAotn2uxW2YIEwa2jB/P
	WBdjGevgQ8X9xpZUJdWvGCdw6AtMNpeaLNumo8eFWODqnLHXenBM9VJex04y6EWEh9yEghymBmC
	/3g==
X-Google-Smtp-Source: AGHT+IH0yGN/QwJj2qp5uqOKGauUQieE3T8AzQn7D6+8pBhJNJGOpa+Ovr7omqAZIvsz9KNZ4usYPH1yyCs=
X-Received: from pfbbv12.prod.google.com ([2002:a05:6a00:414c:b0:724:f17d:ebd7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:448a:b0:725:ebab:bb2e
 with SMTP id d2e1a72fcca58-72daf981283mr35774059b3a.11.1737649519289; Thu, 23
 Jan 2025 08:25:19 -0800 (PST)
Date: Thu, 23 Jan 2025 08:25:17 -0800
In-Reply-To: <20250118152655.GBZ4vIP44MivU2Bv0i@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241216173142.GDZ2Bj_uPBG3TTPYd_@fat_crate.local>
 <Z2B2oZ0VEtguyeDX@google.com> <20241230111456.GBZ3KAsLTrVs77UmxL@fat_crate.local>
 <Z35_34GTLUHJTfVQ@google.com> <20250108154901.GFZ36ebXAZMFZJ7D8t@fat_crate.local>
 <Z36zWVBOiBF4g-mW@google.com> <20250108181434.GGZ37AiioQkcYbqugO@fat_crate.local>
 <20250111125215.GAZ4Jpf6tbcoS7jCzz@fat_crate.local> <Z4qnzwNYGubresFS@google.com>
 <20250118152655.GBZ4vIP44MivU2Bv0i@fat_crate.local>
Message-ID: <Z5JtbZ-UIBJy2aYE@google.com>
Subject: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Sat, Jan 18, 2025, Borislav Petkov wrote:
>  static enum srso_mitigation srso_mitigation __ro_after_init = SRSO_MITIGATION_NONE;
> @@ -2663,6 +2665,12 @@ static void __init srso_select_mitigation(void)

Unless I'm missing something, the cpu_mitigations_off() and "srso_cmd == SRSO_CMD_OFF"
cases need to clear the feature

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 9e3ea7f1b3587..3939a8dee27d4 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2581,6 +2581,7 @@ static void __init srso_select_mitigation(void)
            srso_cmd == SRSO_CMD_OFF) {
                if (boot_cpu_has(X86_FEATURE_SBPB))
                        x86_pred_cmd = PRED_CMD_SBPB;
+               setup_clear_cpu_cap(X86_FEATURE_SRSO_BP_SPEC_REDUCE);
                return;
        }

There's also the Zen1/Zen2 ucode+!SMT path, which I assume is irreveleant in
practice:

		if (boot_cpu_data.x86 < 0x19 && !cpu_smt_possible()) {
			setup_force_cpu_cap(X86_FEATURE_SRSO_NO);
			return;
		}

But if we wanted to catch all paths, wrap the guts and clear the feature in the
outer layer?

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 9e3ea7f1b3587..0501e31971421 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2572,7 +2572,7 @@ early_param("spec_rstack_overflow", srso_parse_cmdline);
 
 #define SRSO_NOTICE "WARNING: See https://kernel.org/doc/html/latest/admin-guide/hw-vuln/srso.html for mitigation options."
 
-static void __init srso_select_mitigation(void)
+static void __init __srso_select_mitigation(void)
 {
        bool has_microcode = boot_cpu_has(X86_FEATURE_IBPB_BRTYPE);
 
@@ -2692,11 +2692,15 @@ static void __init srso_select_mitigation(void)
        }
 
 out:
+       pr_info("%s\n", srso_strings[srso_mitigation]);
+}
+
+static void __init srso_select_mitigation(void)
+{
+       __srso_select_mitigation();
 
        if (srso_mitigation != SRSO_MITIGATION_BP_SPEC_REDUCE)
                setup_clear_cpu_cap(X86_FEATURE_SRSO_BP_SPEC_REDUCE);
-
-       pr_info("%s\n", srso_strings[srso_mitigation]);
 }
 
 #undef pr_fmt

>  ibpb_on_vmexit:
>  	case SRSO_CMD_IBPB_ON_VMEXIT:
> +		if (boot_cpu_has(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
> +			pr_notice("Reducing speculation to address VM/HV SRSO attack vector.\n");
> +			srso_mitigation = SRSO_MITIGATION_BP_SPEC_REDUCE;
> +			break;
> +		}
> +
>  		if (IS_ENABLED(CONFIG_MITIGATION_SRSO)) {
>  			if (!boot_cpu_has(X86_FEATURE_ENTRY_IBPB) && has_microcode) {
>  				setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
> @@ -2684,6 +2692,10 @@ static void __init srso_select_mitigation(void)
>  	}
>  
>  out:
> +

Spurious newlines.

> +	if (srso_mitigation != SRSO_MITIGATION_BP_SPEC_REDUCE)
> +		setup_clear_cpu_cap(X86_FEATURE_SRSO_BP_SPEC_REDUCE);
> +
>  	pr_info("%s\n", srso_strings[srso_mitigation]);
>  }

