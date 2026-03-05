Return-Path: <kvm+bounces-72817-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SFY2F3l5qWl77wAAu9opvQ
	(envelope-from <kvm+bounces-72817-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 13:39:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6279C211D04
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 13:39:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 636C53024BF8
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 12:37:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72B6239B4B7;
	Thu,  5 Mar 2026 12:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ftTR59Xo"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3234739E196;
	Thu,  5 Mar 2026 12:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772714232; cv=none; b=gDiWw1ZUZ8fli5s2BCqxAJmutVANoZfx7E2eJfRiclwuR5nKkgwoL4v7rqk3ao0Yw9Vf0D/yhCFhgcNwrVwUzUxQZL/HE9dhAZlLPCk20lhz9dKsdkFAC1DsPPy7dwp6xIGPHLRy8Zq5OPQMDqMsCIL/lDGcVYtEu6jxrcSkjOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772714232; c=relaxed/simple;
	bh=RgGyNNdqIjOgrAqL+GlweCLk+LqtKtjZYUw3vDQn6y8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kNKhyiTssfMvZPUsvbpQ5+9iL1+XmctKbC502mneu+zGtPTvGGInkPRMdfMLc8rH9vu6CTYXLWab9JzBUnT16q4NyfTrKxRAZnFBYWpZgQa9qxfokMvpwEoB7+Wy8us4dpmtdFyXxdN2TvdI2TcNrI+o2bENm0rgyD6h3O/oZ5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ftTR59Xo; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8242D40E0169;
	Thu,  5 Mar 2026 12:37:03 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ZuA0T_DorMHJ; Thu,  5 Mar 2026 12:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1772714218; bh=FdLGhI+DKtaC+bV/1yMll/XT7I8JFxUD3aTMY78plpA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ftTR59XoXE0SLEETFfVID/cp83ClrywO1Qf9vg3EiTu3FsJlGuwqRs/ZNEbnMizVY
	 +vk0wC/55+dx8MzeOFHFMDQ4LD04kFDgJrLD2f0dFXOEZEENeEC0e2lAUfbCpdFbI1
	 tqWAVMNomvwKIgUENf1eqh8A8vMyFPx7pUHHudRMD+BEUldKH+jJA+Q7Ige+BIolbK
	 ko0rctrW89EM9bGxWhqwEoZ+++/3sXuCGDd3ia3sgm7/F/eYOGFvIQtsOh3z5Y4SxC
	 62HFqZfqMsDEjwwYBHT6AF3InAvepFU3ZQPV0Ep/VxzxIfWdqlzTQMnnqzibR7ZyqM
	 fzALAKXDa2TYbruVF+i/DPfwvI3bAQiQkvKhSngLeTxVBMG0riqBxRX58HwuuM7I6e
	 4hqpuJuFa4SbSvrr3ECtYwkingN6JlgqamFtJFC+Rg3jxxuNpSV6vPJ/0f+i455psz
	 WWBLYFMXWLPoQ2q6zgZMLoB/72VEETAzy7wyMNlWIc7jVWH1hrKet4ur+uGs7IMvNa
	 1+QapLbaji1Myah5cX+vkzfuTFXz0Zk6q9rJHTZxhc0B+XMUOyFdvVP/kAAewJxvb+
	 g/7zprUNfojCgBXgh2NbybOqyAU4PIFN09GZIipzgiZqT2RCil33IQ5JoZo8PDRLSW
	 RpvqDJo9JLTrpab9Yiq+tay0=
Received: from zn.tnic (pd9530d5e.dip0.t-ipconnect.de [217.83.13.94])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id CC89940E0031;
	Thu,  5 Mar 2026 12:36:24 +0000 (UTC)
Date: Thu, 5 Mar 2026 13:36:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ashish Kalra <Ashish.Kalra@amd.com>,
	Sean Christopherson <seanjc@google.com>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
	thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, ardb@kernel.org, pbonzini@redhat.com,
	aik@amd.com, Michael.Roth@amd.com, KPrateek.Nayak@amd.com,
	Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, jackyli@google.com,
	pgonda@google.com, rientjes@google.com, jacobhxu@google.com,
	xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
	babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com,
	john.allen@amd.com, darwi@linutronix.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH v2 1/7] x86/cpufeatures: Add X86_FEATURE_AMD_RMPOPT
 feature flag
Message-ID: <20260305123618.GFaal4whNN9VMxMWLA@fat_crate.local>
References: <cover.1772486459.git.ashish.kalra@amd.com>
 <219ebbd57ac1d99fc5ea055431f7a8396021c2c2.1772486459.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <219ebbd57ac1d99fc5ea055431f7a8396021c2c2.1772486459.git.ashish.kalra@amd.com>
X-Rspamd-Queue-Id: 6279C211D04
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[alien8.de,none];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72817-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[33];
	DKIM_TRACE(0.00)[alien8.de:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bp@alien8.de,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,amd.com:url,amd.com:email,alien8.de:dkim]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026 at 09:35:19PM +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Add a flag indicating whether RMPOPT instruction is supported.
> 
> RMPOPT is a new instruction designed to minimize the performance
> overhead of RMP checks on the hypervisor and on non-SNP guests by
> allowing RMP checks to be skipped when 1G regions of memory are known
> not to contain any SEV-SNP guest memory.
> 
> For more information on the RMPOPT instruction, see the AMD64 RMPOPT
> technical documentation. [1]
> 
> Link: https://docs.amd.com/v/u/en-US/69201_1.00_AMD64_RMPOPT_PUB [1]

Please do not add URLs to documents on corporate sites because latter change
notoriously fast, resulting in dead links. Instead, quote the document title
so that anyone looking for it, can find it after a web search engine has
indexed it.

> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 2 +-
>  arch/x86/kernel/cpu/scattered.c    | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)

Btw, looking further in the set, the first several patches are for tip and
then KVM ones come.

I'm thinking, when the time comes, I'll give you, Sean, an immutable branch
which you can merge.

Right?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

