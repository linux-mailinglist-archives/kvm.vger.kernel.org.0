Return-Path: <kvm+bounces-34411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDC1C9FE5AE
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2024 12:36:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 754EB1624C4
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2024 11:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26DBD1A83EC;
	Mon, 30 Dec 2024 11:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="CSlmeW2B"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2CB1A76B0;
	Mon, 30 Dec 2024 11:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735558595; cv=none; b=f8np0gbT0NrTe/A+sFR701Xe2OgWnNfjvxW0apW7RJI3U2XI757IaCNqy+sFfCM5R2d+D7sCvHv9HVIdnYrP3k1uzpmrB2uQb0HMuRI29wCHdz58h0mSPJO71p6dXnNdQHqEiEs4y+yvMBs5J4H3ayLiNVaU1fATDSOLb+ck23Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735558595; c=relaxed/simple;
	bh=SKEp1/tNMcqtEFDFwiGWbHzGI8Sp/Y0cLrZcb5kCntI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C8/aF6vY/gVw9be2Q4EDcawXKt4BO1rgsrSsfs7whVmXJ4a++H1U9enjbw2VjT5N8nZRHNxNfcOm/NHfA/3KHAIp/oDpU79a6eUc2l0YrEe2CFbvnj7mZhwY6xjEj99QFmQuiJRtKM5335qFR7+ipJxK4OAjQ6iBR+091t4GmKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=CSlmeW2B; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D471840E02D6;
	Mon, 30 Dec 2024 11:36:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Tn2keOnXzs07; Mon, 30 Dec 2024 11:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1735558586; bh=QeG2bmbrRqAFWYoJ6wESD0pONtidL908g2Hmh9WlURU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CSlmeW2BiM0aV0U6jXGop5FKU/4C0E2lFzF25N/OpQn4QkV9tIYBmWZQM4hZaBoRv
	 fu01g+O3pG283FestLrKwiWZF6i8EuDhI9xRlJzkGL5V+GpShZWSfBlBSGtjB3EUa6
	 mgXcjFOKgbuT5qi5Z6pk6PsmfIjnu5GzucfeZPjCFbUrOBZn3RNu41hOnS9wM8vAcQ
	 Icf/EYWBdvIbVpqumTVxfHt0CrnCFzi9YzND87p/agyGwK3//QlEZprpF1OM4C9//D
	 wAmowmvwoeFSYfVB2M95vxAF3nXdBEZFkVVGpZbu6otcU0panTyd9SbLdzsNvPE062
	 mqHdD/gNylrztiT+/KYqBB7nViPHq0EkdWajDdDkBuCCnls+J8R7sjKqFOnhX5kI/o
	 RTPGk9+/0RfeHZdvFR9AYpsXDl9zyFrPgh2+6ths0hC+IttlzdyleeAqf5bloyAUGs
	 Hk2btEEUMyu9SweuyCRpOrWTpTHa/WC12zWgptJA3TplhHr4h8Zw2UONklWqDDd0u3
	 2P2AVDNyHrKiS/PEdmLywL7s3zSFrakqYhJXYtEK+EehYYFwMW2sXAGMm90M85dZ69
	 9Arjs73Cw4KUscZpAKnlSES8lu6jjAjP87/5E9cSKZsjweNcGf1+m79i5bgofxUTNm
	 MRkkCxamPmC1kLXDM6r/ENKY=
Received: from zn.tnic (pd953008e.dip0.t-ipconnect.de [217.83.0.142])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5CDF240E02C0;
	Mon, 30 Dec 2024 11:36:12 +0000 (UTC)
Date: Mon, 30 Dec 2024 12:36:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com, Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v15 10/13] tsc: Upgrade TSC clocksource rating
Message-ID: <20241230113611.GKZ3KFq-Xm_5W40P2M@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-11-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241203090045.942078-11-nikunj@amd.com>

On Tue, Dec 03, 2024 at 02:30:42PM +0530, Nikunj A Dadhania wrote:
> In virtualized environments running on modern CPUs, the underlying
> platforms guarantees to have a stable, always running TSC, i.e. that the
> TSC is a superior timesource as compared to other clock sources (such as
> kvmclock, HPET, ACPI timer, APIC, etc.).

That paragraph sounds like marketing fluff and can't be more far away from the
truth. We still can't have a stable clocksource in the currently ending 2024
without someone f*cking with it.

> Upgrade the rating of the early and regular clock source to prefer TSC over
> other clock sources when TSC is invariant, non-stop and stable.

I don't think so...

Have you read all that gunk in check_system_tsc_reliable() and the commits
touching that logic which disables the TSC clocksource watchdog caused by all
the hw crap that is being produced?

> Cc: Alexey Makhalov <alexey.makhalov@broadcom.com>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/kernel/tsc.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index c0eef924b84e..900edcde0c9e 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -1265,6 +1265,21 @@ static void __init check_system_tsc_reliable(void)
>  		tsc_disable_clocksource_watchdog();
>  }
>  
> +static void __init upgrade_clock_rating(struct clocksource *tsc_early,
> +					struct clocksource *tsc)
> +{
> +	/*
> +	 * Upgrade the clock rating for TSC early and regular clocksource when
> +	 * the underlying platform provides non-stop, invaraint and stable TSC.

Unknown word [invaraint] in comment.
Suggestions: ['invariant', 'inerrant', 'invent', 'intranet', 'infant', 'unvaried', 'informant', 'ingrained', 'entrant', 'inherent', 'unafraid', 'infuriate', 'inferring', 'univalent', 'infringe', 'infringed', 'infuriating']

Spellchecker pls.

> +	 */
> +	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
> +	    boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&

check_for_deprecated_apis: WARNING: arch/x86/kernel/tsc.c:1275: Do not use boot_cpu_has() - use cpu_feature_enabled() instead.
check_for_deprecated_apis: WARNING: arch/x86/kernel/tsc.c:1276: Do not use boot_cpu_has() - use cpu_feature_enabled() instead.

> +	    !tsc_unstable) {
> +		tsc_early->rating = 449;
> +		tsc->rating = 450;
> +	}
> +}
> +
>  /*
>   * Make an educated guess if the TSC is trustworthy and synchronized
>   * over all CPUs.
> @@ -1566,6 +1581,8 @@ void __init tsc_init(void)
>  	if (tsc_clocksource_reliable || no_tsc_watchdog)
>  		tsc_disable_clocksource_watchdog();
>  
> +	upgrade_clock_rating(&clocksource_tsc_early, &clocksource_tsc);
> +
>  	clocksource_register_khz(&clocksource_tsc_early, tsc_khz);
>  	detect_art();
>  }
> -- 
> 2.34.1
> 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

