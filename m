Return-Path: <kvm+bounces-26844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 891E29786CC
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 19:30:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3EEE41F224D0
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 17:30:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FBBB84DE0;
	Fri, 13 Sep 2024 17:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r+6dicoP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528B81C14
	for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 17:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726248635; cv=none; b=TOk+NCBzYv3k6xMKero6J/sX96FbF/YNBxbeQNYK+He4bNi/rBfZThOOQdACSLErgTKwIBZ8x218O65df0BrP7HYgkqkwd/W15K1b44zn3j8H3c2CChJ4GCM61kMhjonqRBY0wu9TQh+eB5y5InAIpUjoeFH/RfEQkPo1eDfKd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726248635; c=relaxed/simple;
	bh=avuE8sDdkBwyoDjtRSEJc0iN1R8TiV1WBhRrowcs5G8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aklIL23zwm7PQn7J6GdFRL3UVEjLn+Q8WPF1wdN2VzauKE3a8ZgvKN8RrSeV9olpUgEBZ8j9SHpiAqYRIzy4SXPW/85Z0NTVlGcNY0EmHNx2+ajsKLI5rqyJ0Siw7rga2CdA5flpPzWrmZh8em6AU3Tm1kshBs2JYX1kPCgQO/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r+6dicoP; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-690404fd230so46586787b3.3
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 10:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726248633; x=1726853433; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=muv8DD4FcvEwNrsCNMD3J/XvZ3CY/Fmbm537cj+6e7A=;
        b=r+6dicoPY0VMNyhsZHTOICbjhbqsEpP2edYoH6TczkPvQW62yxwY7SOZaOFCaBdYBR
         +A7ccrVNKtJos2Xk0kVDTU6YYtvvRFnupPxHNtVMftt66Jtoa1AwfEJJeOG3cZh+VWFW
         dLKA5/8oy5/4/3RCO+cIw5GwoGltfaGjef+J8+X2CpQbzw/CzKdy6MYOejx/+V5OIGia
         DcMWTpaIIHXnSGGN9ihWmGQ22HujnbOySZ3Iemc3eWRYeNXVs8h5G+ZDgOkiZ4RUIdi8
         boIndmo6zuY9kt2ogO9yCigu+jvsfzjQycnIwuOhRkSuNIf7zawvqoFo7lnw8qKaEZpR
         3wQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726248633; x=1726853433;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=muv8DD4FcvEwNrsCNMD3J/XvZ3CY/Fmbm537cj+6e7A=;
        b=tOzKq0W1TYXMSU917Bpxs77D67hYQtNPmYGBt1MjkBAsmZbPHLM8e4J3POLGDt6oWq
         jsgWt3i5BLYDt/gSAnHj5x5Po5+EtiF0vU2qaexcyBfbnWJLJ5nbJNTPQls0QJipFtzV
         3mmkC+Z4wvMFWTa5OHwEYmiVdwJuHbd5x1IfgG/qRgJ+pyl9Waefb4kl9vv+BTKw7hZs
         ddb4jmu38Ud6fjEO0MHXVK6FbVoLdPiNdO0kFKC/hszGVleUogvYs7hRGavS/1j+MwnS
         Wl25N0FGb4NllDiRjop+Es8LsXcxqi37cSeN6vIX0Pl1ln9BUOxQf/YYhepmcrdq2RIa
         douA==
X-Forwarded-Encrypted: i=1; AJvYcCXxDBNedmaS6XOZqefrBLT0WrTunmDDassr0h/86860R1RnGpAWK4H6pwrGne5JvTtS6Fo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8heM0Szt4t2wzWWcwlhsLHu60o9M9NwSdz383u5utbEydIdji
	eBOY/oXgCn5oN2J2C3wufxniVByiB2HFEZRubq7Aod263/Hi/w6Ex7HdrGli/67Sy7kI7kvp437
	VHw==
X-Google-Smtp-Source: AGHT+IE+5iuXvCyAMuKaKT0gEL+Uw6Gkh8WoLyy+tvqvUhOnFfag/tsvUh5cZQ1p1B+I9A3G/dwbMGpEuM4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:c087:0:b0:6d4:d6de:3e35 with SMTP id
 00721157ae682-6dbb6ba2a49mr1266217b3.8.1726248633303; Fri, 13 Sep 2024
 10:30:33 -0700 (PDT)
Date: Fri, 13 Sep 2024 10:30:31 -0700
In-Reply-To: <20240731150811.156771-20-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240731150811.156771-1-nikunj@amd.com> <20240731150811.156771-20-nikunj@amd.com>
Message-ID: <ZuR2t1QrBpPc1Sz2@google.com>
Subject: Re: [PATCH v11 19/20] x86/kvmclock: Skip kvmclock when Secure TSC is available
From: Sean Christopherson <seanjc@google.com>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de, 
	x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de, 
	dave.hansen@linux.intel.com, pgonda@google.com, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 31, 2024, Nikunj A Dadhania wrote:
> For AMD SNP guests with SecureTSC enabled, kvm-clock is being picked up
> momentarily instead of selecting more stable TSC clocksource.
> 
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000001] kvm-clock: using sched offset of 1799357702246960 cycles
> [    0.001493] clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
> [    0.006289] tsc: Detected 1996.249 MHz processor
> [    0.305123] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x398cadd9d93, max_idle_ns: 881590552906 ns
> [    1.045759] clocksource: Switched to clocksource kvm-clock
> [    1.141326] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x398cadd9d93, max_idle_ns: 881590552906 ns
> [    1.144634] clocksource: Switched to clocksource tsc
> 
> When Secure TSC is enabled, skip using the kvmclock. The guest kernel will
> fallback and use Secure TSC based clocksource.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Tested-by: Peter Gonda <pgonda@google.com>
> ---
>  arch/x86/kernel/kvmclock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index 5b2c15214a6b..3d03b4c937b9 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -289,7 +289,7 @@ void __init kvmclock_init(void)
>  {
>  	u8 flags;
>  
> -	if (!kvm_para_available() || !kvmclock)
> +	if (!kvm_para_available() || !kvmclock || cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))

I would much prefer we solve the kvmclock vs. TSC fight in a generic way.  Unless
I've missed something, the fact that the TSC is more trusted in the SNP/TDX world
is simply what's forcing the issue, but it's not actually the reason why Linux
should prefer the TSC over kvmclock.  The underlying reason is that platforms that
support SNP/TDX are guaranteed to have a stable, always running TSC, i.e. that the
TSC is a superior timesource purely from a functionality perspective.  That it's
more secure is icing on the cake.

>  		return;
>  
>  	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE2)) {
> -- 
> 2.34.1
> 

