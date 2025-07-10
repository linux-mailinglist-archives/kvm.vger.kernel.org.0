Return-Path: <kvm+bounces-52034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 88962B00093
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 13:29:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46CB41BC160E
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 11:30:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9F332E5417;
	Thu, 10 Jul 2025 11:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Gxx2HqAt"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BAA944F;
	Thu, 10 Jul 2025 11:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752146980; cv=none; b=pdA38mMZvsNzvBDamEzXL1wivcbywY3xy3aBLCGBugPhgvml825oN5U4UhlNSfBIz60ZTdcG2nmCk0Vo7JLbvhtqZUiGqAjRHq15CcycpEpLVM6TLMW2IXogWRgru8740OaSmeIzEuk8cFRsb6uGAzRTJPXd74VDmlVoXU7z4Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752146980; c=relaxed/simple;
	bh=sDvvwgksakgq1MqUj25WTBeUoKn2iNnomLd7Pz5rxXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bjiNxanqA5WPz3gf2Z7zaUFJe9r6vilsQpPJYBRSEWJQYmDoSu6/9qGuiKIPiMH1rBCNesshekBRvic9E5meaVLq3P28a3YsA7CFgSL1JUjLQpabt+lJgSQcgvKyzlZOpV4btaH49Ud+zn6RnfmTmOYajvg9a3x21zWqjHPL544=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Gxx2HqAt; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6369D40E020E;
	Thu, 10 Jul 2025 11:29:33 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id A2zW3RKcDLpp; Thu, 10 Jul 2025 11:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1752146969; bh=rz8G5mq5LEqN6TYjqrNYUDOCAUTijX5k1pmbJpMz6Wo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gxx2HqAt2d7wKhrw8qlXYmeSAXd4/gkw6ItvVB03Muzq83pesnZBOdnMprWCPwYjG
	 k1qNqreeCMZPLMvlku5bg0vHS6JPw1K/RcsAv6r7QV+LVYH/banXQ1/Y16aluIvtM6
	 Z4ptd4CYVBDSX0l5TNYKaZUAD3RqKb98oW8ydzRLCujZhjLiDDlQgnI38UO5cYzih2
	 qQEc9XoPyXo877fkwmIehL3nQLAVmYrBqpfILk8KAtNtUPSATeKmK53rwi4kGjOkQb
	 YizHosSyl5WrCqmzxO2wk5FUU64gctO1lGcJXaAX5zU25vANQiM/hTdii11QBdKu8u
	 enBHAoJF4MqUS26CNU5lKoZVNLRC2wmssH+KSS1frBS5a6GhTnpGblW4n2RR/VwhnN
	 8WL+5MacS2wpFxXg0Y0OkAT9nCydML3orMjTV5rxmJYoT7zgDlZ14VSByU/E2YwvVe
	 bWb/GlHW2r7Go8gU2Y5N4VJcumPFXCbOKyLJp++e9m5lyE+UjAR2IiTMmS/tJWWfLT
	 xD5Zez9BWA5eQNUOfwgeC2o7rjnUoxEcTC+WKiynpeHRpLkFxDv74wiS7HuoKUA7O2
	 OYXszMq9ZMg1t/sCUDsTzf+VddiNxtHp3NorcXff1rsF3je1SBOCsqgeirdXDeJ4tW
	 heQxpPz7qMMsD8sr7S4nGtHM=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 79A2D40E0169;
	Thu, 10 Jul 2025 11:29:08 +0000 (UTC)
Date: Thu, 10 Jul 2025 13:29:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Kevin Loughlin <kevinloughlin@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Kai Huang <kai.huang@intel.com>, Ingo Molnar <mingo@kernel.org>,
	Zheyun Shen <szy0127@sjtu.edu.cn>,
	Mingwei Zhang <mizhang@google.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>
Subject: Re: [PATCH v3 3/8] x86, lib: Add WBNOINVD helper functions
Message-ID: <20250710112902.GCaG-j_l-K6LYRzZsb@fat_crate.local>
References: <20250522233733.3176144-1-seanjc@google.com>
 <20250522233733.3176144-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250522233733.3176144-4-seanjc@google.com>

On Thu, May 22, 2025 at 04:37:27PM -0700, Sean Christopherson wrote:
> diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
> index 079c3f3cd32c..1789db5d8825 100644
> --- a/arch/x86/lib/cache-smp.c
> +++ b/arch/x86/lib/cache-smp.c
> @@ -19,3 +19,14 @@ void wbinvd_on_all_cpus(void)
>  	on_each_cpu(__wbinvd, NULL, 1);
>  }
>  EXPORT_SYMBOL(wbinvd_on_all_cpus);
> +
> +static void __wbnoinvd(void *dummy)
> +{
> +	wbnoinvd();
> +}
> +
> +void wbnoinvd_on_all_cpus(void)
> +{
> +	on_each_cpu(__wbnoinvd, NULL, 1);
> +}
> +EXPORT_SYMBOL(wbnoinvd_on_all_cpus);

If there's no particular reason for the non-GPL export besides being
consistent with the rest - yes, I did the change for wbinvd_on_all_cpus() but
that was loooong time ago - I'd simply make this export _GPL.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

