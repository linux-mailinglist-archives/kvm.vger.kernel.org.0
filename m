Return-Path: <kvm+bounces-38279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 255ADA36E3E
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 13:54:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CE62170ED2
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 12:53:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 295E11C701C;
	Sat, 15 Feb 2025 12:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="JUwxh7lu"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2350C23BB;
	Sat, 15 Feb 2025 12:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739624014; cv=none; b=PWO+BqBq/p2gTziRzHQrqWN7mussuV7lqMBccQ5ujIBaOMja1f+l7xnoax8l3dcBvzkRru4P+C1dXTHlH2snmr59ihclSWMpB9BUI4tpk40ijfku2wWfc6Z3dTEzPWtfZu4CbwEymU24q2LotMHhlCBQIqLR4Xs3IbZS3AaFL1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739624014; c=relaxed/simple;
	bh=55bFo5TwjiljeZK/OPEexGvWmrI7hXcDphFJik7KjUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aVKDLcJfUgGLnC004l49Apw2TOtac6wOavQhQXREG7DbWmvRKDK6LEBkkcILsfxWRZHpFGUgi3deKnhhYq0RQiBLgdBn6PGcNshIZNlg869Ly3foSuQgR++l7lw6E+xk9rS/1jEIHOMsEqX60kS/KCWMZUzUn4PaCgcd6nv7ycU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=JUwxh7lu; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 99FAA40E016A;
	Sat, 15 Feb 2025 12:53:28 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id wXaB67OA_vJI; Sat, 15 Feb 2025 12:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1739624004; bh=G4jABUnk//FFd36m5A3RahJKuG1xCrEuoKlicK3ZhsY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JUwxh7luVQQB8MeXuPuqa7zXQILmEi4HwRoRzbsXzkAGnkRtMHDvLABpNXKhmPvMM
	 KkrawAk58zjqSzX6Yl6lj07cRczBQxhAaUXnI04A0YAQbAeH2e7F3KynI1/9n/6j6l
	 k0PW/i1aIRjHRdDKWX4YdOhFM5O3ZuBHJpoXxzjHJnlOpn9V921g9r5ZL5/XDq4+6q
	 h4zTVyZSy1IThlO1vsRKEzlnHCpZG5Q8x3ORERKGJaPVRB4v3cSF41NnpLrp7HOHbB
	 fyZR80Mb7O6YBIPQn3ycHtBKsjKkxiHScNVOaC4psC9dagaamwHGLHpibR2m+oUNMu
	 AHULu9twTHGauY82oL/mrMBogwYqiVxNuCyQKHAZuTM+EZquBOTFrBgNxVrUNOwf8v
	 g/cfcZfaNAHMeucKfqcwqdDaBuIfjr7hA51CFXG6Oy+Mg/SFEnRN9boZ6WLZm+2j2p
	 1zZWf6bvsngCITHF4s0rRSyF+Dp5/haaAbNfy/JwzF1HE0cT53TzmFl3B5eJBF6Uj3
	 hbwrXn2yLicDjnKpE9YJa3PYosQF3XLg6WVkJ5Qrxlg3Z/yrQ5V4tIZec09nN44tAL
	 zpQK0XIbYJDwqvnEZ4LIxrdMfNUADa1t4pS3G8ye2ByL9Vy8qX4lcQERCordJ+vKQJ
	 jcwIruCfJx5evdTJ9QFI16tU=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3BBCE40E0028;
	Sat, 15 Feb 2025 12:53:13 +0000 (UTC)
Date: Sat, 15 Feb 2025 13:53:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Patrick Bellasi <derkling@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: Re: Re: Re: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20250215125307.GBZ7COM-AkyaF8bNiC@fat_crate.local>
References: <20250213142815.GBZ64Bf3zPIay9nGza@fat_crate.local>
 <20250213175057.3108031-1-derkling@google.com>
 <20250214201005.GBZ6-jHUff99tmkyBK@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250214201005.GBZ6-jHUff99tmkyBK@fat_crate.local>

On Fri, Feb 14, 2025 at 09:10:05PM +0100, Borislav Petkov wrote:
> After talking with folks internally, you're probably right. We should slap an
> IBPB before clearing. Which means, I cannot use the MSR return slots anymore.
> I will have to resurrect some of the other solutions we had lined up...

So I'm thinking about this (totally untested ofc) but I'm doing it in the CLGI
region so no need to worry about migration etc.

Sean, that ok this way?

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6ea3632af580..dcc4e5935b82 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4272,8 +4272,16 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
 		x86_spec_ctrl_set_guest(svm->virt_spec_ctrl);
 
+	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
+		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
+
 	svm_vcpu_enter_exit(vcpu, spec_ctrl_intercepted);
 
+	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
+		indirect_branch_prediction_barrier();
+		msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
+	}
+
 	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
 		x86_spec_ctrl_restore_host(svm->virt_spec_ctrl);
 
-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

