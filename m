Return-Path: <kvm+bounces-55036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47C48B2CCFB
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 21:29:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31893587B9E
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 19:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CDAA326D73;
	Tue, 19 Aug 2025 19:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="khSyx8R2"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963FC322C82;
	Tue, 19 Aug 2025 19:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755631744; cv=none; b=PBtY9kTfwDvzL5eCz+4GSDe2YaFWdZMTT1FkyKg8JM2d1VJx8rDLgqr0uhFWEIjGZjcg2xsBLVTAPaSo30ppTCHYGX4v5NHz9mkZnMRHC1HM7uAQGAzM/Vuvz43m/I0ApE+60NQgwcyfjR3nqCErI+d1/r2iowlIrQFTmLD0ZtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755631744; c=relaxed/simple;
	bh=KCcclhS7M7Ppsuz47p4LBEib816ICcU5xamy6lRtODk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I+STBym/Bzq/fjpLgpJItyRcXYun6nTc2YK4+SeLo3fUhyq4TgIylVO1zbEOuSdaFz5z0R4/1EF53T+gjLek2aRI6xPdCIFUzXFy5QU6wB3isUZTfCvo6bGEMdk43n3dxFx/vMW/Unukoeylvhr7SnO/TPZEsi4doxiNAjdBtz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=khSyx8R2; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id CA75240E0194;
	Tue, 19 Aug 2025 19:28:57 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id kRss8kZpu-Vf; Tue, 19 Aug 2025 19:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1755631732; bh=pFKYBFysi0D/h33TNA0NMCZJ3QXsXWW3B+PXOFIgWuk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=khSyx8R25lIkOrcJpw/1kKrg4RYFZnlq9wYxCyMgabZgnaL8Y4mt8jamtlNFGWKZ0
	 /rOXZR5dhCEn0Civr73Y1DvVkDtg2uakPUDxv8TIVs88M8jkkKZO20RD0uElPhNZL0
	 FcieW0eLb5YqWLDGD7S3b7trpfPIJenu0Q+F/iLJz4T/MYRAZcCh4RsRjvVmufa7l9
	 hAnXmKlFRQWlhtgUbZg7/6hvUfX/M+HYRR/dnPXEG83zGyeqJVKmHt0bkFoOm24RNI
	 LdNZsCfhkUKrPEcNnandRmGQz2dnij9A1iMxhwjmxS91Wk/wq4Mog6ugON6njmLewN
	 4msdmObyFpIieffYL4zCfq8VNhk20s64dG8ho8iVWZuwCzFcCjxHcNVLr863UIj45j
	 6EqKucr4JOfUoAjR6haFgPByGT2JZzJV8ctPsNNi8EBsmhIEMRcZ5oOYgJ8+vtO+w8
	 Q8AnobCKFmKkiImjeLQjKjNsqoP+AtqNsGmV2Zzt8Eq+gkNB9DPbXZt/7rJFRRqWHs
	 a0FVuLYZ2BGjLXKXLxXtCuev+tckF1//nVM2dAJYyAiVVS51Zj4gEOxQPfBvlDiTdO
	 Q6l9YmqHqjwiUo1RLdywUuYJGFQAfxpYAOjutR3ACglv2ieaL3jW/amRjpApfv+ivP
	 zXyTy0xo3a75+jc/AJQawuyY=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2BC1840E023B;
	Tue, 19 Aug 2025 19:28:29 +0000 (UTC)
Date: Tue, 19 Aug 2025 21:28:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Kai Huang <kai.huang@intel.com>
Cc: dave.hansen@intel.com, tglx@linutronix.de, peterz@infradead.org,
	mingo@redhat.com, hpa@zytor.com, thomas.lendacky@amd.com,
	x86@kernel.org, kas@kernel.org, rick.p.edgecombe@intel.com,
	dwmw@amazon.co.uk, linux-kernel@vger.kernel.org,
	pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
	reinette.chatre@intel.com, isaku.yamahata@intel.com,
	dan.j.williams@intel.com, ashish.kalra@amd.com,
	nik.borisov@suse.com, chao.gao@intel.com, sagis@google.com,
	farrah.chen@intel.com
Subject: Re: [PATCH v6 2/7] x86/sme: Use percpu boolean to control WBINVD
 during kexec
Message-ID: <20250819192823.GLaKTQVxIV4n7p60hU@fat_crate.local>
References: <cover.1755126788.git.kai.huang@intel.com>
 <c09d17677fa127a7b23b24b6c225f7dc5b68fd98.1755126788.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c09d17677fa127a7b23b24b6c225f7dc5b68fd98.1755126788.git.kai.huang@intel.com>

On Thu, Aug 14, 2025 at 11:59:02AM +1200, Kai Huang wrote:
> TL;DR:
> 
> Prepare to unify how TDX and SME do cache flushing during kexec by
> making a percpu boolean control whether to do the WBINVD.
> 
> -- Background --
> 
> On SME platforms, dirty cacheline aliases with and without encryption
> bit can coexist, and the CPU can flush them back to memory in random
> order.  During kexec, the caches must be flushed before jumping to the
> new kernel otherwise the dirty cachelines could silently corrupt the
> memory used by the new kernel due to different encryption property.
> 
> TDX also needs a cache flush during kexec for the same reason.  It would
> be good to have a generic way to flush the cache instead of scattering
> checks for each feature all around.
> 
> When SME is enabled, the kernel basically encrypts all memory including
> the kernel itself and a simple memory write from the kernel could dirty
> cachelines.  Currently, the kernel uses WBINVD to flush the cache for
> SME during kexec in two places:
> 
> 1) the one in stop_this_cpu() for all remote CPUs when the kexec-ing CPU
>    stops them;
> 2) the one in the relocate_kernel() where the kexec-ing CPU jumps to the
>    new kernel.
> 
> -- Solution --
> 
> Unlike SME, TDX can only dirty cachelines when it is used (i.e., when
> SEAMCALLs are performed).  Since there are no more SEAMCALLs after the
> aforementioned WBINVDs, leverage this for TDX.
> 
> To unify the approach for SME and TDX, use a percpu boolean to indicate
> the cache may be in an incoherent state and needs flushing during kexec,
> and set the boolean for SME.  TDX can then leverage it.
> 
> While SME could use a global flag (since it's enabled at early boot and
> enabled on all CPUs), the percpu flag fits TDX better:
> 
> The percpu flag can be set when a CPU makes a SEAMCALL, and cleared when
> another WBINVD on the CPU obviates the need for a kexec-time WBINVD.
> Saving kexec-time WBINVD is valuable, because there is an existing
> race[*] where kexec could proceed while another CPU is active.  WBINVD
> could make this race worse, so it's worth skipping it when possible.
> 
> -- Side effect to SME --
> 
> Today the first WBINVD in the stop_this_cpu() is performed when SME is
> *supported* by the platform, and the second WBINVD is done in
> relocate_kernel() when SME is *activated* by the kernel.  Make things
> simple by changing to do the second WBINVD when the platform supports
> SME.  This allows the kernel to simply turn on this percpu boolean when
> bringing up a CPU by checking whether the platform supports SME.
> 
> No other functional change intended.
> 
> [*] The aforementioned race:
> 
> During kexec native_stop_other_cpus() is called to stop all remote CPUs
> before jumping to the new kernel.  native_stop_other_cpus() firstly
> sends normal REBOOT vector IPIs to stop remote CPUs and waits them to
> stop.  If that times out, it sends NMI to stop the CPUs that are still
> alive.  The race happens when native_stop_other_cpus() has to send NMIs
> and could potentially result in the system hang (for more information
> please see [1]).

This text is meandering a bit too much across a bunch of things and could be
made tighter... Just a nitpick anyway...

>  arch/x86/include/asm/kexec.h         |  4 ++--
>  arch/x86/include/asm/processor.h     |  2 ++
>  arch/x86/kernel/cpu/amd.c            | 17 +++++++++++++++++
>  arch/x86/kernel/machine_kexec_64.c   | 14 ++++++++++----
>  arch/x86/kernel/process.c            | 24 +++++++++++-------------
>  arch/x86/kernel/relocate_kernel_64.S | 13 ++++++++++---
>  6 files changed, 52 insertions(+), 22 deletions(-)

Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

