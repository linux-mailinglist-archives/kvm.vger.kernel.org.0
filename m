Return-Path: <kvm+bounces-32930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B3A7A9E295C
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 18:33:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC0D2B24099
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 14:50:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB2791F7544;
	Tue,  3 Dec 2024 14:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="P2SUz7Vc"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06ED41B3942;
	Tue,  3 Dec 2024 14:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237434; cv=none; b=CYPHCIKtR2OGuyghhAGPzLheh6+5+lIDUkLpoRT6gCM2xvyiL3dzcIJXxO5Qlkyreb6+ct+vBeCFLdori3OmSCqIZEl43PpVaCR5hjchrrASC+p8+VT2jJqeqW58mGhcW0Cc75jsKMJQbIqQwz77R7lARk2Lmb4khCxsPrgEo2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237434; c=relaxed/simple;
	bh=+x0jq6ieLP+RKroyUmslzxJrFDnWtgCBUEcvfZ/mK1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tmd/TJWtyyATuqTphtz3nM+bIk5H2IWt5W+++zRq4lYMzyXiV4U3M25NSmCfRjeI/WN+SDZYU9seR90tV2ej6DUrlBmERJzEaT3wu67D80EEBkML9WIrk711z4C5g+c+HHapmal6Rn0p3wVi/IAeNEErFAYdcwxS4KsBQzLAFRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=P2SUz7Vc; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D964740E0269;
	Tue,  3 Dec 2024 14:50:29 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id e0EPJkvpp4w1; Tue,  3 Dec 2024 14:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733237423; bh=zhzQ5cCwaTn5mU+JsmEkUoNiwtkjIFQELLsG2oG7zec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P2SUz7VcuWwMxzCJcRLy/q/Qg+DAJGSsrS7WBol6qlCpZwDNM7Bjx4tkoMd2/sWjQ
	 SguQ51/WPACrDxyRSEUV4GmKGJ+S2XRTV5QkDnmn/CAc9/yfSmAPfvqWjNj4YHezeL
	 7jlcSjYB7X14esXXQqf3S8RnBj/4H9rb1fCJJO5QLIwK2IP5EnDuqVIR7nGFyLN0GM
	 uiYd6rcc17fxLrK/GwjrsVvtLdMLCsC5SuaHaZFCIrg9mIaxMwf1voclDUg9Q6f+ib
	 CzQP5W6Iov99Cq3VGBov+Pmrvdmk4lENkmST1+xkt3wYxPN4UGrFWo8vAuqMToQgvu
	 iaUxMjsQHUrAV0PSck4muS4AK/QeTHwog0bKwiuDOhIfanTf7wLBrRRHFZaFr5G7as
	 nRXdptX8FMPwm1bVzj2iBPgkzoPc1DV3RDz2x4a2bmRaU+eu7IzOdmxmtJmlmCbiGR
	 9UFVS70P49g5cD8MQKl2+RREMTrmgM1mLNw2jngS8EQugMIJXFzBNbXYOpyIU6Gobc
	 v5IsPmHJMYEqR+ELalArd5Fnm1ArlKrO+iUEmOTMDYqHEKPPwQkK6Ovpn0kTmI2qes
	 uI3umK8lGa4jRl2U3Bigj2MEVBt8Dc2rWNPs5J9HbmopgGEiG7fuh/rWiflHwfm8RD
	 91xzomb4Yz11ytt5sR7J5eo4=
Received: from zn.tnic (pd9530b86.dip0.t-ipconnect.de [217.83.11.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3592740E0196;
	Tue,  3 Dec 2024 14:50:12 +0000 (UTC)
Date: Tue, 3 Dec 2024 15:50:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 01/13] x86/sev: Carve out and export SNP guest
 messaging init routines
Message-ID: <20241203145006.GGZ08anlXCntr8cjVu@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-2-nikunj@amd.com>
 <20241203141950.GCZ08ThrMOHmDFeaa2@fat_crate.local>
 <891f0e65-f2fa-4e0c-a59c-ef97ea00ba3f@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <891f0e65-f2fa-4e0c-a59c-ef97ea00ba3f@amd.com>

On Tue, Dec 03, 2024 at 08:05:32PM +0530, Nikunj A. Dadhania wrote:
> This is what I use with checkpatch, that didnt catch the wrong spelling.

Not surprised.

> Do you suggest using something else ?

You can enable spellchecking in your editor with which you write the commit
messages. For example:

https://www.linux.com/training-tutorials/using-spell-checking-vim/

Or, you can use my tool:

https://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git/log/?h=vp

You'd need to fish it out of the repo.

It doesn't completely replace checkpatch yet but I am extending it with
features as I go. But it does spellcheck:

$ ~/dev/vp/.tip/bin/vp.py ~/tmp/review/new
prepratation for adding Secure TSC guest support, carve out APIs to
Unknown word [prepratation] in commit message.
Suggestions: ['preparation', 'preparations', 'reparation', 'perpetration', 'reputation', 'perpetuation', 'peroration', 'presentation', 'repatriation', 'propagation', "preparation's"]

Class patch:
    original subject: [[PATCH v15 01/13] x86/sev: Carve out and export SNP guest messaging init routines]
             subject: [x86/sev: Carve out and export SNP guest messaging init routines]
              sender: [Nikunj A Dadhania <nikunj@amd.com>]
              author: [Nikunj A Dadhania <nikunj@amd.com>]
             version: [15]
              number: [1]
                name: [x86-sev-carve_out_and_export_snp_guest_messaging_init_routines]
                date: [Tue, 03 Dec 2024 14:30:33 +0530]
          message-id: [20241203090045.942078-2-nikunj@amd.com]

I'm sure there are gazillion other ways to automate it, ofc.

HTH.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

