Return-Path: <kvm+bounces-34680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AF59A0440A
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 16:17:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3C323A1DCC
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 15:17:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFCB21F2C49;
	Tue,  7 Jan 2025 15:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="awW7KLCn"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF591F239B;
	Tue,  7 Jan 2025 15:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736263062; cv=none; b=B9EiFOmvouZ8oJqL8Ow4r1yvPNJakTIGJ7GVvlBdBYLILyp8x0NB3U87PH6qQwk1+God75xu3quKG+/qfSZl13lv7z6UysT835Tg7IjXrjgFVt42Vrx1PRV6Nw5SUYxXUctMn4nl+qwW0jBURlLf4lsTVaTKqgeGH02IiQIuIGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736263062; c=relaxed/simple;
	bh=NKId5VKN2JS5BtzNG74GbnIoWvs5JqwJdZgQOSMryaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MdTeLhfWaY6dTSpgaG5oDwBFP12zTv5wm0a/gzDKbsZNb79GvpxhfEva4oHHCRkA1wQ7DMLLmC6qxrWkrqSHlW5aL0sN+Y63pi0CG6huL1A8YdwdfQQvS48ETTO4Rz6tGvbn2BRyaQVKl5AAyEYfGWPN0xZrkKfBa4bKyRDmsu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=awW7KLCn; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7D73040E0163;
	Tue,  7 Jan 2025 15:17:27 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id w7AsqoCk3HED; Tue,  7 Jan 2025 15:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1736263037; bh=iRVXHxCbFd3Tm5VQ/t939OD/rzFgLvJMNru9uoTvEuk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=awW7KLCnIH+PMIJSDK/m9RYEfgCTAJAz23QLnQXUJkDn8IwGTbQjN3tNBXywvD5jp
	 BjrlstJ++NOejLTXp0W0sMybMJMXe/HWGxFJiQb2k1YPCHcmrTdFYdN/Gs9xAd4MGN
	 ytrB8whw3xxPCLRzRTeyIZ/DMlH3Gf9NH6HGjRInRhzQKLYPvLTSCY2QjyH3ukVapa
	 MOhHAN1bkZR/gFCeG792xCmx5VJyGBXzCOJgggk3ssS+6jert9tkKjFZdp8rkkN1u9
	 v8yIqcYBHAsDJPsWVxyMUV4oXinmTAREk0JKa8FtLOoQD11s7zbFH3tN8XPmxLA+Dc
	 vNZX3KxDhL2MYSMEF4KxRCagVSe7aJVdujeFU0Zka96puhl3NGACDjbuxPXWYk1uQv
	 PgoTLNh4miTUNGKxeWYPWqY2i1FtGp0ZDe73A4ltM/IC7uE6lXoZmNm8yQD6IPsXjr
	 RAZdQyJVKu590vH1FwPypCrKNqJrRCu5XiLTQbyXHzrpDuPmOXIscWBAxCf2j2uc0l
	 lpZG3qqh0hmVe+GOEOU6DGhEtTjJ66OoItG+xvOk69qIHkuRBAXwUj0AyCgCZC1n5I
	 bStNYKZK9OjJDOd75K0j6x4NoKnJk2zk3q2suUH8SbfisBmspleFpguRZg+n/k1bX6
	 Y7NrnsB5fPJokP+bWXQOjPBg=
Received: from zn.tnic (p200300Ea971F9314329C23FFFeA6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:9314:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 01E1240E0267;
	Tue,  7 Jan 2025 15:17:04 +0000 (UTC)
Date: Tue, 7 Jan 2025 16:16:59 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com, francescolavra.fl@gmail.com
Subject: Re: [PATCH v16 10/13] x86/tsc: Switch Secure TSC guests away from
 kvm-clock
Message-ID: <20250107151659.GFZ31Fa1iagsgsyQH3@fat_crate.local>
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-11-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250106124633.1418972-11-nikunj@amd.com>

On Mon, Jan 06, 2025 at 06:16:30PM +0530, Nikunj A Dadhania wrote:
>  static int kvm_cs_enable(struct clocksource *cs)
>  {
> +	/*
> +	 * TSC clocksource should be used for a guest with Secure TSC enabled,
> +	 * taint the kernel and warn when the user changes the clocksource to
> +	 * kvm-clock.
> +	 */
> +	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)) {
> +		add_taint(TAINT_WARN, LOCKDEP_STILL_OK);
> +		WARN_ONCE(1, "For Secure TSC guest, changing the clocksource is not allowed!\n");

So this thing is trying to state that changing the clocksource is not allowed
but it still allows it. Why not simply do this:

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 960260a8d884..d8fef3a65a35 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -151,14 +151,10 @@ bool kvm_check_and_clear_guest_paused(void)
 
 static int kvm_cs_enable(struct clocksource *cs)
 {
-	/*
-	 * TSC clocksource should be used for a guest with Secure TSC enabled,
-	 * taint the kernel and warn when the user changes the clocksource to
-	 * kvm-clock.
-	 */
+	/* Only the TSC should be used in a Secure TSC guest. */
 	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)) {
-		add_taint(TAINT_WARN, LOCKDEP_STILL_OK);
-		WARN_ONCE(1, "For Secure TSC guest, changing the clocksource is not allowed!\n");
+		WARN_ONCE(1, "Secure TSC guest, changing the clocksource is not allowed!\n");
+		return 1;
 	}
 
 	vclocks_set_used(VDSO_CLOCKMODE_PVCLOCK);

?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

