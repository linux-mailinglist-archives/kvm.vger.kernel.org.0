Return-Path: <kvm+bounces-36410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D3B9A1A84D
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 18:02:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15B363A66A0
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 17:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDBD413E03A;
	Thu, 23 Jan 2025 17:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="g3sJJF8v"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC8C126C02;
	Thu, 23 Jan 2025 17:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737651734; cv=none; b=EoFabsdP4VD0pKvg/1GD45NbFSr0wyOYnD/oCEyuQUdNaQVsg5kHBhLbdL4iX92TIeSYS/DwbnUUn8ignSQ45BR/sXkr+5QGWgfPrQta7nSMri3WcdP0sRdFoSMnS0K9t9NAQiQFXbHzClgzAL/6sAV7dAFbhZYWio2sTIoPGNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737651734; c=relaxed/simple;
	bh=V6+j3hh4mRPUOw7BK9x3gRaFDIW0sNoj18yEwZLI2BI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vCULRrenvYkU4xc329RI8nrv1RA/LUeNwg0VZX5n/xfoK1HSxUvj//N2aGv8y3pA+pZBd7n/9A3ekRlvW4hMMnGqezIWb/xfsnnlljPJzbqgjVKMPBUs/lHjDXrKajud0mpHrEWvgbXEB3jXraRSSa0X9zsmfE3lqDuR2ehNKTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=g3sJJF8v; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3511540E021A;
	Thu, 23 Jan 2025 17:02:08 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id EBWQyGcD76_1; Thu, 23 Jan 2025 17:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1737651724; bh=pB+ti7PVAOP+Kw7No2ZXR3Kk6PBBTemImGnuMLUn6vA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g3sJJF8v4mlVwhoJFkmCWRFtdL7rg+3VRyI959SyJxUvgyTvt9xDsQygFWviXyEF4
	 xF6XaChcBDGYshVXp5pEAHOa3Ly/8qDTYnJX2bi+G7B6GknSp/KfUf/ME9uurkpDWJ
	 ChnaoyR8WtKm/Nn0b0XxRuLNcfCsBN8aeAUhmV3FlOoc9MLZYahc0ZNFHDo3H5v1FO
	 nlVKb+VCZyUKXPaIK2nlHM0hSqv5ou3ud6uViloLdyKhWJxmWVxCPFO3d041VSoPnZ
	 DhKCSIvFzTkwWMSH/KNyFJ0QGbpCBassjI9AcblZc4cwG7653ndeG3iwpWy5WSKuwK
	 pjz/rNY98wAKqA+TY+SBf0SoRgrLLTm+X03Vt407bxkB50O3o/XXEPOMkIj0ylno1N
	 P5se/MNLwn0DkEUEJWA6HwW9ulgPoNjlrQbygloJRAPTLoPGpba2xug6JrlXGpcESt
	 KyIqb406V/7TH0wDh6WgYaxrJGguIPVrJAnBK081QVGEawgmYHZtkD/31XZAVE2obE
	 NV3qeRvC7UM0bVMxrK5Emn+s7BtvdbeTxnSOdmeuKxKRGb+xdmUuFhGtnvU43CibQd
	 A73Y2j+dduQXFVZTrRNrD+sdq2YuZvk7b+cAjMCG55mLaxvKw9op5dRquR0EFephPc
	 p0Srhv1kkWNPCs7Z8oAEJCf4=
Received: from zn.tnic (pd953008e.dip0.t-ipconnect.de [217.83.0.142])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 26B4B40E0163;
	Thu, 23 Jan 2025 17:01:56 +0000 (UTC)
Date: Thu, 23 Jan 2025 18:01:49 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20250123170149.GCZ5J1_WovzHQzo0cW@fat_crate.local>
References: <Z2B2oZ0VEtguyeDX@google.com>
 <20241230111456.GBZ3KAsLTrVs77UmxL@fat_crate.local>
 <Z35_34GTLUHJTfVQ@google.com>
 <20250108154901.GFZ36ebXAZMFZJ7D8t@fat_crate.local>
 <Z36zWVBOiBF4g-mW@google.com>
 <20250108181434.GGZ37AiioQkcYbqugO@fat_crate.local>
 <20250111125215.GAZ4Jpf6tbcoS7jCzz@fat_crate.local>
 <Z4qnzwNYGubresFS@google.com>
 <20250118152655.GBZ4vIP44MivU2Bv0i@fat_crate.local>
 <Z5JtbZ-UIBJy2aYE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z5JtbZ-UIBJy2aYE@google.com>

On Thu, Jan 23, 2025 at 08:25:17AM -0800, Sean Christopherson wrote:
> But if we wanted to catch all paths, wrap the guts and clear the feature in the
> outer layer?

Yap, all valid points, thanks for catching those.

> +static void __init srso_select_mitigation(void)
> +{
> +       __srso_select_mitigation();
>  
>         if (srso_mitigation != SRSO_MITIGATION_BP_SPEC_REDUCE)
>                 setup_clear_cpu_cap(X86_FEATURE_SRSO_BP_SPEC_REDUCE);
> -
> -       pr_info("%s\n", srso_strings[srso_mitigation]);
>  }

What I'd like, though, here is to not dance around this srso_mitigation
variable setting in __srso_select_mitigation() and then know that the __
function did modify it and now we can eval it.

I'd like for the __ function to return it like __ssb_select_mitigation() does.

But then if we do that, we'll have to do the same changes and turn the returns
to "goto out" where all the paths converge. And I'd prefer if those paths
converged anyway and not have some "early escapes" like those returns which
I completely overlooked. :-\

And that code is going to change soon anyway after David's attack vectors
series.

So, long story short, I guess the simplest thing to do would be to simply do
the below.

I *think*. 

I'll stare at it later, on a clear head again and test all cases to make sure
nothing's escaping anymore.

Thx!

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 9e3ea7f1b358..11cafe293c29 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2581,7 +2581,7 @@ static void __init srso_select_mitigation(void)
 	    srso_cmd == SRSO_CMD_OFF) {
 		if (boot_cpu_has(X86_FEATURE_SBPB))
 			x86_pred_cmd = PRED_CMD_SBPB;
-		return;
+		goto out;
 	}
 
 	if (has_microcode) {
@@ -2593,7 +2593,7 @@ static void __init srso_select_mitigation(void)
 		 */
 		if (boot_cpu_data.x86 < 0x19 && !cpu_smt_possible()) {
 			setup_force_cpu_cap(X86_FEATURE_SRSO_NO);
-			return;
+			goto out;
 		}
 
 		if (retbleed_mitigation == RETBLEED_MITIGATION_IBPB) {
@@ -2692,11 +2692,11 @@ static void __init srso_select_mitigation(void)
 	}
 
 out:
-
 	if (srso_mitigation != SRSO_MITIGATION_BP_SPEC_REDUCE)
 		setup_clear_cpu_cap(X86_FEATURE_SRSO_BP_SPEC_REDUCE);
 
-	pr_info("%s\n", srso_strings[srso_mitigation]);
+	if (srso_mitigation != SRSO_MITIGATION_NONE)
+		pr_info("%s\n", srso_strings[srso_mitigation]);
 }
 
 #undef pr_fmt




-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

