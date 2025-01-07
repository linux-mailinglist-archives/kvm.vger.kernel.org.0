Return-Path: <kvm+bounces-34698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B4314A048A3
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 18:52:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBFA61887BD9
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 17:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94E061F37D5;
	Tue,  7 Jan 2025 17:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Qxk5oIAg"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300431898ED;
	Tue,  7 Jan 2025 17:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736272327; cv=none; b=n5LCj6cRTiCg9z8hKwQsRbRDShrPSFsCiz6psOf1ihiobkplMrIG+IDdkatGusqIJCFpvDKKUDIlPLrKRpv3KL4OWzwLQc6Fant73pO/c/eVlJZJYjmj8WGVoU8uiu7b7LZH7+wZ7LlBpi5UZbxREKwyvknDHWDDf7OHyKMfHzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736272327; c=relaxed/simple;
	bh=+Mp+CVfXYaKYkoaaxH4hDrZpPAYKNDklHY2BWRaWwXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qop6jUNujYuhI4p258slwRI1/txY05aoeYf9SeRj3BRQAXXG3RZMHQvESCTIuocQeFkOYQu3LNjRoHREj7QLmKg/FVeMwz6FehbZ2vDG+q/lliPtTUV7UhkGdavmOJdV+kDn9nhJj/DuVnkKVjT7dTwiylaOBO67IcubRnDp8Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Qxk5oIAg; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B940B40E021E;
	Tue,  7 Jan 2025 17:52:00 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id qsskCgeDaNS5; Tue,  7 Jan 2025 17:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1736272310; bh=Wrh8ZBeNM3GdfNBaIOBA9IbIdUenkVCIhMBjTrwJRqE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qxk5oIAg1WNOeD4sl8Sbtu4WJqzmLwQtJpCFiue+UBHFKXplckV/3m2jl22TQXj4X
	 rV8UjvNTa68/BL2hNBnNyMZZHiHTxr6U8rTdkciGihxm4dfN4HQHdSOuLIvHKzL/B5
	 bKb71NjiZZTZhasXhxItj82s+AhkyKqXh94l9kLH/tWliSgnDDUFURtkCPzsQp9fxu
	 8mG9y8P4mofSDibKjovimbxX57P2njY3GJOmIYVXzAWf7DlPmIYOP5ayfxh6a4Cob0
	 grmJA3Y2rRLmhHp8uEicQalesgVZjQzanLxsff5fE9d7N3Y9Sciq9G8fTCHeokPnLR
	 RVwGT6/sNOH2t3stippbO6ul2wbDoHtIwBgTc0HoO+hswQyCV7kBWyG1psPyWHFnuB
	 BvMeDzk/1bxvq4ubm5KEBkvuUSKTt7uyZUtyyWTZ9h4K4/rywI8rzA2H5l5kNtWemo
	 cKSOcMXttP9gkEamWQcMh/tK1llP1fo2GkuABSIpeL/bLqix3e+cPP+OgdcfOefwiV
	 69B5JcDT3yn6oJSQC0sLLKd9/1qTe43t4V6DBgsS55uagjzR4WhRVPFTgIrUx1wbMf
	 RUTsEGQ2+tBogj9yhYw15LOhOp/TzVdMhgUslYKLs90H70z5rTI5aNil8roIegDu9O
	 ylrFmf3RRlpvyMSTSYJZPIHQ=
Received: from zn.tnic (p200300ea971F9314329C23fffeA6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:9314:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C6B9040E01C5;
	Tue,  7 Jan 2025 17:51:34 +0000 (UTC)
Date: Tue, 7 Jan 2025 18:51:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com, francescolavra.fl@gmail.com,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v16 11/13] x86/tsc: Upgrade TSC clocksource rating for
 guests
Message-ID: <20250107175128.GGZ31poPrKk2E_k-H3@fat_crate.local>
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-12-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250106124633.1418972-12-nikunj@amd.com>

On Mon, Jan 06, 2025 at 06:16:31PM +0530, Nikunj A Dadhania wrote:
> Hypervisor platform setup (x86_hyper_init::init_platform) routines register
> their own PV clock sources (KVM, HyperV, and Xen) at different clock
> ratings, resulting in PV clocksource being selected even when a stable TSC
> clocksource is available. Upgrade the clock rating of the TSC early and
> regular clocksource to prefer TSC over PV clock sources when TSC is
> invariant, non-stop, and stable
> 
> Cc: Alexey Makhalov <alexey.makhalov@broadcom.com>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/kernel/tsc.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)

This needs to make it perfectly clear that it is about virt and not in
general:

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index e98b7e585c1c..3741d097d925 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -276,14 +276,16 @@ bool using_native_sched_clock(void)
 
 /*
  * Upgrade the clock rating for TSC early and regular clocksource when the
- * underlying platform provides non-stop, invariant, and stable TSC. TSC
+ * underlying guest is provided a non-stop, invariant, and stable TSC. TSC
  * early/regular clocksource will be preferred over other PV clock sources.
  */
-static void __init upgrade_clock_rating(struct clocksource *tsc_early,
-					struct clocksource *tsc)
+static void __init virt_upgrade_clock_rating(struct clocksource *tsc_early,
+					     struct clocksource *tsc)
 {
-	if (cpu_feature_enabled(X86_FEATURE_HYPERVISOR) &&
-	    cpu_feature_enabled(X86_FEATURE_CONSTANT_TSC) &&
+	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
+		return;
+
+	if (cpu_feature_enabled(X86_FEATURE_CONSTANT_TSC) &&
 	    cpu_feature_enabled(X86_FEATURE_NONSTOP_TSC) &&
 	    !tsc_unstable) {
 		tsc_early->rating = 449;
@@ -295,7 +297,7 @@ u64 sched_clock_noinstr(void) __attribute__((alias("native_sched_clock")));
 
 bool using_native_sched_clock(void) { return true; }
 
-static void __init upgrade_clock_rating(struct clocksource *tsc_early, struct clocksource *tsc) { }
+static void __init virt_upgrade_clock_rating(struct clocksource *tsc_early, struct clocksource *tsc) { }
 #endif
 
 notrace u64 sched_clock(void)
@@ -1584,7 +1586,7 @@ void __init tsc_init(void)
 	if (tsc_clocksource_reliable || no_tsc_watchdog)
 		tsc_disable_clocksource_watchdog();
 
-	upgrade_clock_rating(&clocksource_tsc_early, &clocksource_tsc);
+	virt_upgrade_clock_rating(&clocksource_tsc_early, &clocksource_tsc);
 
 	clocksource_register_khz(&clocksource_tsc_early, tsc_khz);
 	detect_art();


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

