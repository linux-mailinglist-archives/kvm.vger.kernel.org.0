Return-Path: <kvm+bounces-34487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21EB09FFA9F
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 15:55:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA9C1162C54
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 14:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30639CA6B;
	Thu,  2 Jan 2025 14:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ii7TqEvA"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC221B3950;
	Thu,  2 Jan 2025 14:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735829698; cv=none; b=nQ22avFlabD6XFaqAJ8ckGvM+lp/wAfHdrXCLZHOynTtl19OiyKuXNddwwxV/RfsXkeXMoYEHt0gD2pFWIPpcDJcVlyMJcTWtN6k8qYDpcMn8P2WnOw/tl01Ds1N6nAXZL7FjjaRYp1JmaPuzL5a1CO59/D/JrtybcwWgSwr2fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735829698; c=relaxed/simple;
	bh=gF7MdmJtlrLkjMSwwyHZIgnCezY8r5bwmhL1+rmGAJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q0zcd0NYUr/1ibr7hX6O4tjzXfJaUyZskzXp4a5j3mWjvwVfU/FE36oCfTWbEtx7t0v5e1wfTh3FGjQye9I/KXBnjcP98udVIz3GBbrz8Z8dSp0gnP7kYxywltg1/ZIHa/LrmtmzEr/KOPhVNVkopdIqrENBrqoLpzdw653ntvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ii7TqEvA; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 05F8740E0289;
	Thu,  2 Jan 2025 14:54:54 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id JRLgkEiNXvUS; Thu,  2 Jan 2025 14:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1735829689; bh=4nhJFWfpAEXTdVEiqjV3C/5Qhny+cjECDHXVL4lPypg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ii7TqEvAMhikYs1Sk5uD2yj6rfGzSHf/AJvyw025IVcjP6U4mQoIEKkensOCXk5Ok
	 GlFGk2f7GTaTuB+7ApkQMG+wn+W+07tzeDRL5KKFAAzr1LVdmF+xc6RWX2D5hZcSvn
	 MDmYgxtl1RFL2JFHX/DH4xHl3yq+t7bmPvTuo4AKnSvin32Ji8mX89d1/17DFb+qHa
	 U3Wb8KL7ipIiBOeIOIm956Ht+t8sxrb7RLbqNBCx7JpuuTDUjfhwuCIYHIqFjGTxOI
	 6dHluy3JYAGDTuRzNZTVNDCccsastT2tpTqkWJ0WXzcz1hK4EIQgzDX8DEKWsWw+4s
	 rNedzuxCfyCl8NCTC7vNMkFkFWRp1en2sCkKvr5dqzy1K4SMkTFglMxNNv4SbW8dqm
	 wTCzSkpZ5qRe59KD3pdQ+9LWf6gNnyZkgvP9plfmcoacx9ll1Jedz899AJHrSkjpeZ
	 VTvT1Ri1FhgHiaP7sDwq+p2+57Goql4AXrJItflxppGpwX54o3N/apa6UDcgXYycoL
	 XZQ+itmyjnFWs2fMcWOFIvMj9y1XV850RO4HzPKbvSykFpZICtBs/U4jubEAooE+nK
	 gFY3zSYfWziStiPF9lju9ja3NLD6xCmJaMes0hteNxEEvu0bmsEjCN2ZYZ3kWVqV0I
	 en2TdePzhLQ8TgP5J3BPqsyg=
Received: from zn.tnic (p200300EA971f9374329C23fFfEA6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:9374:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A713040E021D;
	Thu,  2 Jan 2025 14:54:38 +0000 (UTC)
Date: Thu, 2 Jan 2025 15:54:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com,
	tglx@linutronix.de, dave.hansen@linux.intel.com, pgonda@google.com,
	seanjc@google.com, pbonzini@redhat.com
Subject: Re: [PATCH v15 06/13] x86/sev: Prevent GUEST_TSC_FREQ MSR
 interception for Secure TSC enabled guests
Message-ID: <20250102145431.GAZ3aop4Z1NOakZ9KO@fat_crate.local>
References: <ff7226fa-683f-467b-b777-8a091a83231e@amd.com>
 <20241217105739.GBZ2FZI0V8pAIy-kZ8@fat_crate.local>
 <7a5de2be-4e79-409a-90f2-398815fc59c7@amd.com>
 <20241224115346.GAZ2qgyt3sQmPdbA4V@fat_crate.local>
 <a28dfd0a-c0ab-490f-bc1a-945182d07790@amd.com>
 <20250101161047.GBZ3VpB3SMr9C__thS@fat_crate.local>
 <9d4c903f-424b-41ce-91f7-a8c9bf74c07c@amd.com>
 <20250102090734.GBZ3ZXVqpo0OgEwbrQ@fat_crate.local>
 <fe09ff1d-4a9b-4307-92c0-767cd3974152@amd.com>
 <b9c71735-96e5-aa4f-4d13-ca6c50c2f625@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b9c71735-96e5-aa4f-4d13-ca6c50c2f625@amd.com>

On Thu, Jan 02, 2025 at 08:45:36AM -0600, Tom Lendacky wrote:
> >> @@ -1477,7 +1477,9 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
> >>  	case MSR_IA32_TSC:
> >>  	case MSR_AMD64_GUEST_TSC_FREQ:
> >>  		if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
> >> -			return __vc_handle_msr_tsc(regs, write);
> >> +			return __vc_handle_secure_tsc_msrs(regs, write);
> >> +		else
> >> +			break;
> 
> There's a return as part of the if, so no reason for the else. Just put
> the break in the normal place and it reads much clearer.

I guess that's in the eye of the beholder. I prefer a balanced

	if
		foo
	else
		bar

as it is as obvious and clear as it gets. Especially if it is interwoven in
a switch-case like here.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

