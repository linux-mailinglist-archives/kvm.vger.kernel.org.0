Return-Path: <kvm+bounces-38453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C9A8A3A15B
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 16:34:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ACFBC7A1F64
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 15:33:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F6F726D5AC;
	Tue, 18 Feb 2025 15:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="kWqh2nJh"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2CF13AD26;
	Tue, 18 Feb 2025 15:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739892875; cv=none; b=uSEoZjY16vGV6WQ08JoYEdKITfy5GWjJcf4mffy3otgujqTIKtSMH0AAUpJNSLPF2r+fQdXrrkEuqMhwwD7hG7HFUg/a8A+ygEC+/Pfq58IJmyp76WphjHy21C9ySdaEn6k96CdM6/a1phVRxcRKX9cn6zr+CbgrP8YO56qT8Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739892875; c=relaxed/simple;
	bh=xP0O74aAz3/thkqgp4kW0eukkcQDwPA45eEmjLaSsH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DVlJrQCqPaGStDRpKX4Ggh+2xROBPhjgiDh4xZJiCnAWj8XMCJpuulnzwxTsb3pdzY7rN46mjnZSwuDLIwVSAucL1WEH/N4UNtpHHhyF1mLjcWv/WH1gslWDEZE+cGZPReurYhTxAxVLxDw+ZVHaY7czUlMziyBcktjqAwrxocc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=kWqh2nJh; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A684340E0220;
	Tue, 18 Feb 2025 15:34:31 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id zXILX5Pa0jDr; Tue, 18 Feb 2025 15:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1739892868; bh=k5EEcJ+X4BamW818gv6v3mk4r1C4gWG5Gcc90naHqaI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kWqh2nJhYN4pVYrpF88LC423UTe1w79Ajm+8tpwkWpV2vfcP9fmIdNsYcx2qDawbS
	 SSIGbzBkN6zXGZtOTQvdkG1h4GNxcVlDeFQipDjFH7f0UuolPoVgIozRVX6Joxb+/s
	 Ij/Vn52NPnsBERVw/wpA7RQwymTmPTDJfffu7I+V7fnAVhyMG1RQ3I0JyELzt3UFRs
	 1cSv7LlWuQRl6457JolsgMcE8Oxb0ZOPPGdtW9fUZq0PUhmN0A8VsdxKIigZfNkMHr
	 1em4x/gGvQLLV/X1SsuukeqA5lfXrnzZknxKAf899UU/zcgrZw/CzQpMmZtnbG7yOL
	 y+tvN+spNIrCf0DoaCIkQ5tBaAEAAKhBv2bHeRD9OOvvPzQkk/Vv9ALiaWnCfbKxEq
	 EQOvVR8xcqZIcP66VjOd0m0HJYchef6KbkzRwRHSb954YHPdzAdU79BzBFb1cxOpVZ
	 ylWpWr60+wEKYOsA4wISP6ooeoySOpKMRIPX3rSdJZGBwsd9UgEKRYF7RYESj0Uox4
	 54wxqqyII74tedNDVSYZw9wgFsDSGPpWOlDBNsLQFa/Inqcxw4SNTSem96Y3S3Z3vS
	 TvKEhE5E0mZXW2Fc2yJwvxugS+r3YNLwKfzZA47Axy8t6IA7zi4oM1gxBpgCxirIdg
	 tiUluNOWs2+2PjvvI42r/rEo=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B72FC40E0212;
	Tue, 18 Feb 2025 15:34:15 +0000 (UTC)
Date: Tue, 18 Feb 2025 16:34:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Patrick Bellasi <derkling@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>,
	David Kaplan <David.Kaplan@amd.com>
Subject: Re: [PATCH final?] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20250218153414.GMZ7Sodh_eQXqTNE2x@fat_crate.local>
References: <20250218111306.GFZ7RrQh3RD4JKj1lu@fat_crate.local>
 <20250218144257.1033452-1-derkling@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250218144257.1033452-1-derkling@google.com>

On Tue, Feb 18, 2025 at 02:42:57PM +0000, Patrick Bellasi wrote:
> Maybe a small improvement we could add on top is to have a separate and
> dedicated cmdline option?
> 
> Indeed, with `X86_FEATURE_SRSO_USER_KERNEL_NO` we are not effectively using an
> IBPB on VM-Exit anymore. Something like the diff down below?

Except that I don't see the point of this yet one more cmdline option. Our
mitigations options space is a nightmare. Why do we want to add another one?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

