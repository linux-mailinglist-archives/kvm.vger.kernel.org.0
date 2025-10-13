Return-Path: <kvm+bounces-59952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A993BD6BDB
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 01:29:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 69E3E4E953C
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 23:29:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C95E82F9DB1;
	Mon, 13 Oct 2025 23:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rwb+9i81"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28872DAFC9
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 23:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760398172; cv=none; b=g//K+atZZLBp+nmD4EVm6HA57QG7nOBZd6HQi/2y86QqX626atsIZmt7xmj8lqiUwPSv9dgP8H63ZftNQCDCY4+r6PW7JmipnijlCQXis3Tl5RhzRA2hmtzEjgvIcf1g+HttnPmJzs98DEy579oPHmvfDIohSy9nzM0j/YiVt/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760398172; c=relaxed/simple;
	bh=frCkNdHFg6gFZkpQ8R/gWpJUarl2/IhZnnqo+TVChx0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pjTngLeYeykJNYzCGKwUayKlmfpihsk8KtN5xDsUUmYAfl61PiGho4UOV7pUjbghfv5Lo90v5JZmVScKRHslFWeAy03qwmVd3w+JMWM53ZaeEPiq6NHay108uxgE7L9KwLEOY68f5NMFVgNQRqs56aYYafbhEVq2EE7C1zR12iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rwb+9i81; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eb2b284e4so14362975a91.1
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 16:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760398169; x=1761002969; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6I25W7llJFin8S8DJoBGT81mljmaC0FlyXWknURs3B0=;
        b=Rwb+9i81VnZDtCrFV0FtXFZwwvGdAwcv6YunZV85Fnzf24I/VT9us3fHXxWf5fTB03
         GccqCM0FZd30N7DgI3w9QrW7gbm5zTOTuhWAJ55MSFIq/YS4NNOLlrZie5DAev2pfqcc
         12Azb9jLBey7Qevs39GlUHE5Ti4MMGDsECJ/xSr6Z5Vm4bDMHb0J7TGAeWG2ajEC6eve
         sFmb4RDiYRMBNVc+RG9yeZByxX59XJaoWtbTqUW5/CslfcQCXXEbCARKsCluy8xRGDd1
         CvdOof3nh8Byit1MN2bDkDRxXjer9r+318lj6QaNol/1eo+jBo+MUmt2+YcGELGCWwdR
         PCFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760398169; x=1761002969;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6I25W7llJFin8S8DJoBGT81mljmaC0FlyXWknURs3B0=;
        b=COYcTdysEalCbGxDe6POompE4q7NTI1Hmubgo0X1No6UZrd51BbsV2FwkKN9YPipRV
         Iqwh8jX0obMHtqZzTNwAiOgkzZQFio5HfIgOWeEBJ9ACS8bVK5zulv/XUZLyc4F64mCa
         0VzRARpd3rWaIdI+YF744AFBsRvrA0DwOEutEeAgds9LU2c0bziEy3Nz/ygQJxKveBHv
         7rKEtPcDVlcahJpF+3DlMcwfUYBYnzL2qp7o3zOtBMiGfjC7rm9mkct7eYfy/3HZYLKD
         hrSB5Qr7ooUV2b9BKytszuE4QWokkJP+HSxXpD6yNX+iwWxmkeZN2uDKivBYTe2e7YxR
         Pgkw==
X-Forwarded-Encrypted: i=1; AJvYcCVeFNtyTpwYj5VLCFMkZK26l7JaftaOw4k5ehACmh6dMJmru975upN7pE0KAtYKAl5u3yo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaqnIS2aETWp58bv1t02hwBAGopto60P7ltElW0je4cJ8dgaUF
	WZG4d9kU1VVliHdkjRWQHZf935gDxgYBveFo3lbi2FkEhAXdOUv1KfQhNoGcmoyhvo1DrkYytYD
	1cRaL2g==
X-Google-Smtp-Source: AGHT+IEiNPpbW/grCKFuHxlhV/+CCABZVtb58WuWOIKWZbzgQenU8nHFmCCMfdmsu0j9FdPxTq60YfDRtpU=
X-Received: from pjza20.prod.google.com ([2002:a17:90a:e214:b0:329:7261:93b6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38d1:b0:32e:8c1e:1301
 with SMTP id 98e67ed59e1d1-33b513eac36mr30623229a91.34.1760398168867; Mon, 13
 Oct 2025 16:29:28 -0700 (PDT)
Date: Mon, 13 Oct 2025 16:29:27 -0700
In-Reply-To: <20251013125117.87739-1-fuqiang.wng@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251013125117.87739-1-fuqiang.wng@gmail.com>
Message-ID: <aO2LV-ipewL59LC6@google.com>
Subject: Re: [PATCH RESEND] avoid hv timer fallback to sw timer if delay
 exceeds period
From: Sean Christopherson <seanjc@google.com>
To: fuqiang wang <fuqiang.wng@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yu chen <chen.yu@easystack.com>, 
	dongxu zhang <dongxu.zhang@easystack.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 01, 2025, fuqiang wang wrote:
> When the guest uses the APIC periodic timer, if the delay exceeds the
> period, the delta will be negative. 

IIUC, by "delay" you mean the time it takes for KVM to get (back) to
advance_periodic_target_expiration().  If that's correct, I think it would be
clearer to word this as:

  When the guest uses the APIC periodic timer, if the next period has already
  expired, e.g. due to the period being smaller than the delay in processing
  the timer, the delta will be negative.

> nsec_to_cycles() may then convert this
> delta into an absolute value larger than guest_l1_tsc, resulting in a
> negative tscdeadline. Since the hv timer supports a maximum bit width of
> cpu_preemption_timer_multi + 32, this causes the hv timer setup to fail and
> switch to the sw timer.
> 
> Moreover, due to the commit 98c25ead5eda ("KVM: VMX: Move preemption timer
> <=> hrtimer dance to common x86"), if the guest is using the sw timer
> before blocking, it will continue to use the sw timer after being woken up,
> and will not switch back to the hv timer until the relevant APIC timer
> register is reprogrammed.  Since the periodic timer does not require
> frequent APIC timer register programming, the guest may continue to use the
> software timer for an extended period.
> 
> The reproduction steps and patch verification results at link [1].
> 
> [1]: https://github.com/cai-fuqiang/kernel_test/tree/master/period_timer_test
> 
> Fixes: 98c25ead5eda ("KVM: VMX: Move preemption timer <=> hrtimer dance to common x86")

I'm pretty sure this should be:

  Fixes: d8f2f498d9ed ("x86/kvm: fix LAPIC timer drift when guest uses periodic mode")

because that's where the bug with tsdeadline (incorrectly) wrapping was introduced.
The aforementioned commit exacerbated (and likely exposed?) the bug, but AFAICT
that commit itself didn't introduce any bugs (related to this issue).

> Signed-off-by: fuqiang wang <fuqiang.wng@gmail.com>
> ---
>  arch/x86/kvm/lapic.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 5fc437341e03..afd349f4d933 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2036,6 +2036,9 @@ static void advance_periodic_target_expiration(struct kvm_lapic *apic)
>  	u64 tscl = rdtsc();
>  	ktime_t delta;
>  
> +	u64 delta_cycles_u;
> +	u64 delta_cycles_s;
> +
>  	/*
>  	 * Synchronize both deadlines to the same time source or
>  	 * differences in the periods (caused by differences in the
> @@ -2047,8 +2050,11 @@ static void advance_periodic_target_expiration(struct kvm_lapic *apic)
>  		ktime_add_ns(apic->lapic_timer.target_expiration,
>  				apic->lapic_timer.period);
>  	delta = ktime_sub(apic->lapic_timer.target_expiration, now);
> +	delta_cycles_u = nsec_to_cycles(apic->vcpu, abs(delta));
> +	delta_cycles_s = delta > 0 ? delta_cycles_u : -delta_cycles_u;
> +
>  	apic->lapic_timer.tscdeadline = kvm_read_l1_tsc(apic->vcpu, tscl) +
> -		nsec_to_cycles(apic->vcpu, delta);
> +		delta_cycles_s;

This isn't quite correct either.  E.g. if delta is negative while L1 TSC is tiny,
then subtracting the delta will incorrectly result the deadline wrapping too.
Very, very, theoretically, L1 TSC could even be '0', e.g. due to a weird offset
for L1, so I don't think subtracting is ever safe.  Heh, of course we're hosed
in that case no matter what since KVM treats tscdeadline==0 as "not programmed".

Anyways, can't we just skip adding negative value?  Whether or not the TSC deadline
has expired is mostly a boolean value; for the vast majority of code it doesn't
matter exactly when the timer expired.

The only code that cares is __kvm_wait_lapic_expire(), and the only downside to
setting tscdeadline=L1.TSC is that adjust_lapic_timer_advance() won't adjust as
aggressively as it probably should.

Ha!  That's essentially what update_target_expiration() already does:

	now = ktime_get();
	remaining = ktime_sub(apic->lapic_timer.target_expiration, now);
	if (ktime_to_ns(remaining) < 0)
		remaining = 0;

E.g.

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0ae7f913d782..2fb03a8a9ae9 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2131,18 +2131,26 @@ static void advance_periodic_target_expiration(struct kvm_lapic *apic)
        ktime_t delta;
 
        /*
-        * Synchronize both deadlines to the same time source or
-        * differences in the periods (caused by differences in the
-        * underlying clocks or numerical approximation errors) will
-        * cause the two to drift apart over time as the errors
-        * accumulate.
+        * Use kernel time as the time source for both deadlines so that they
+        * stay synchronized.  Computing each deadline independently will cause
+        * the two deadlines to drift apart over time as differences in the
+        * periods accumulate, e.g. due to differences in the underlying clocks
+        * or numerical approximation errors.
         */
        apic->lapic_timer.target_expiration =
                ktime_add_ns(apic->lapic_timer.target_expiration,
                                apic->lapic_timer.period);
        delta = ktime_sub(apic->lapic_timer.target_expiration, now);
-       apic->lapic_timer.tscdeadline = kvm_read_l1_tsc(apic->vcpu, tscl) +
-               nsec_to_cycles(apic->vcpu, delta);
+
+       /*
+        * Don't adjust the TSC deadline if the next period has already expired,
+        * e.g. due to software overhead resulting in delays larger than the
+        * period.  Blindly adding a negative delta could cause the deadline to
+        * become excessively large due to the deadline being an unsigned value.
+        */
+       apic->lapic_timer.tscdeadline = kvm_read_l1_tsc(apic->vcpu, tscl);
+       if (delta > 0)
+               apic->lapic_timer.tscdeadline += nsec_to_cycles(apic->vcpu, delta);
 }
 
 static void start_sw_period(struct kvm_lapic *apic)

