Return-Path: <kvm+bounces-33508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F9B99ED743
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 21:32:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C2C1281BB2
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 20:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F537211A0E;
	Wed, 11 Dec 2024 20:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="dV4d06UF"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3032594B5;
	Wed, 11 Dec 2024 20:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733949161; cv=none; b=ILSy5IBpPbLnR9qQcDN1UeUZT1LHzcIW7CAUWsk2x/gxihphqA1hh5wD8QWQo4EWrw3cwZfFdRfScx5c4MWdKFxGyvWudTUoJp1ZW/mkPPW8HeGexse67fj+Mo6/GCBg6SLjH/aunFjv9wkEkCO9tHzDrM5y8z28M22wfci1K5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733949161; c=relaxed/simple;
	bh=pCrWNNBi554r6fF0yAoa4pQOPYVe5E43HR+EADonklY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B5CxP250NWkoLFOif2ceSfAix/0uSZH/RKbhiA/8BGVlL8Mb260cdn5VpfQe2qf6aB8Blt3Wi23mqN7ylWjKAc+NZDFAe6tvOJL3/VXsmYDrJ91N9z0+FkDmRSbZ1EgOZjEdMyx0K8E/EhztyjsuHrE1WM8bGEWRjCi3Tcps1AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=dV4d06UF; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 91AEE40E0286;
	Wed, 11 Dec 2024 20:32:35 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id kyvswteMX4sA; Wed, 11 Dec 2024 20:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733949151; bh=6eD4Z40sb6Gr6OGjyS3lwQNEdVFubwhsek6uZmA3iKM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dV4d06UFZsmvyqfdidcNGtOHj0krL2ODfCAW4eKI4vSub0YeaBtbL4k9HgcWCJpYq
	 kp2dmv1tylCLRKlUZl193quAlv61Yqs4IXaL+/8hTd/sUUIcdJS+RSRkX7uEFQHU9M
	 XRf/DIkuHjXBDw9bAWVyPG/pek9Y8Nvm1FXsfrwo0/e4DG5SWt/tWAxR4nhZadXN2M
	 tCU5flicQOCNvfikY9K095QmnZrLnzo/UKleLePtTnaYrrByenuDEKkzzuXpiyuGwK
	 lSYAnDsHC/kuwFSo9S3GzXMvruzfzdO5m5hQg78MkqQccNhaGYANI5TU50pBTGVvHF
	 n87du4npP/BugN7QmaXsYV1jRvgSeyYJSS9NIYEJolibXcYwAra0E8x2XwHfoQ/G4Q
	 kh4ngUit8vX2ZVMVMhbiGoiLfEqHemuOvIksI/xr5jKLnddwaV0TMZPY+inMg/tXVP
	 zsRFq+0UkZRvAKaLvSbiUT4HW3e3vEV4pbtEmUl7w40unRSwtZCNSz+ZH5biQZ12V9
	 WTKG5bx69zJpUXGXb6XCNDhFYOg6BlRlVrRl59Wv16MNmCloPuCAB6J7TLxX09TEbY
	 Ewm6/F43sqq/EXHAwA18cMvWsgv3wpBgRWWxmeqsQQTeTfVPn4rfd1uRkxvBbTkcGa
	 WzjehDuic0DA3N1wGlZYWxMU=
Received: from zn.tnic (p200300Ea971F93ce329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:93ce:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 98EA640E0169;
	Wed, 11 Dec 2024 20:32:20 +0000 (UTC)
Date: Wed, 11 Dec 2024 21:32:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 07/13] x86/sev: Mark Secure TSC as reliable
 clocksource
Message-ID: <20241211203214.GDZ1n2zvfqjYj4TpzB@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-8-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241203090045.942078-8-nikunj@amd.com>

On Tue, Dec 03, 2024 at 02:30:39PM +0530, Nikunj A Dadhania wrote:
> diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
> index 774f9677458f..fa0bc52ef707 100644
> --- a/arch/x86/mm/mem_encrypt_amd.c
> +++ b/arch/x86/mm/mem_encrypt_amd.c
> @@ -541,6 +541,10 @@ void __init sme_early_init(void)
>  	 * kernel mapped.
>  	 */
>  	snp_update_svsm_ca();
> +
> +	/* Mark the TSC as reliable when Secure TSC is enabled */
> +	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
> +		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);

What happens if someone writes MSR 0x10 on some CPU and thus makes the TSCs on
the host unsynchronized and that CPU runs a SecureTSC guest?

That guest would use RDTSC and get wrong values and turn the guest into
a mess, right?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

