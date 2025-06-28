Return-Path: <kvm+bounces-51043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96DA7AEC73A
	for <lists+kvm@lfdr.de>; Sat, 28 Jun 2025 14:51:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE6D34A0CA4
	for <lists+kvm@lfdr.de>; Sat, 28 Jun 2025 12:50:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12577248F68;
	Sat, 28 Jun 2025 12:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="a5N9NNm3"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E3B2F1FF1;
	Sat, 28 Jun 2025 12:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751115045; cv=none; b=llSAoHxp1mgUPxkRl6pbJp9PtWeGzdr2K1Q/LTWmMDDf/xc90DnL20So4qQbe0agTxNDBmOShEI37kBF3OiSg7KyGpASpPV5lLHpyNMioKrvaQOfKZF9EOOxseP1zmYwEPRP7ejAyuWrk5AYahu3RTV/L64KY97dmgJXjfdGKXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751115045; c=relaxed/simple;
	bh=+JmxlUms8ba1ram7kTy8gjDP915eQ8RojEt9nzFQck8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L8JgbQr8EhnFNiURYmIaMPg1/xNmBh5Ta4GRosghI1qE2MB5aok2ZvaZUmMirXqbVHB9OUKzRXueAaGwdhev9rMLtPA3E3KD8V9gPCi799bGhQwN7TKL+MEd7hkZKyVnrX43fHivxwyQIojX/U43sMb36eS692Glqq5F1Yak1n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=a5N9NNm3; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id BC4A340E0198;
	Sat, 28 Jun 2025 12:50:32 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Tb8WqKgMt53u; Sat, 28 Jun 2025 12:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1751115028; bh=eLc46ItctJeCFTOqG/1cEMrFtQ/BEN7LI1Y39fPMwsU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a5N9NNm3jrjATCZFMuROj51umNu2AEsdwEzaywbxkJLZz1j0600Fs4hN46K7L+bo8
	 eP95aLWHTpEDBQg6ypa8dKw9dQKpYxDi+focSMxeU5I6QnQbDuL626SrTqS/+S83Vu
	 KfyXuqleLGYsQyjQKb6Rt2TgFqBesuZgGAHYr3qPOmzU+grURFPqRapq/EWSbGeqsa
	 w0Yiz6IxmjAULk3/rPrWvPEm6c5L1c2th9ghfbSEctF5lpReDCO6yz/xIuTYBZB2oy
	 wkIuWh5vBRY1FDvWUdpQiLUkMSlEp7Zu6pXmGlK10f5exX/rr1KeLiVc4UzqMlQ0JJ
	 dc/Vcu5hCX245GU6muztrfvkdVAwsbyWVcKLHi3xjE+auG1Ovm38PTiUZNKPB9Pvz6
	 pw/WIVrIfKbjGwLRe6kADVkUPkl28ZWWyUtDl323W+B/5rX2zxSsixoU/+OiFK7qoA
	 X8IL2A9V5mBUzUjaQ6qVIAweLxSvyZg+tPk6UqLmblcYDyB3SFEd9gKoeHbXvURVlz
	 9rpMcxTlasdsRby125USTE64eLigcXQQXzXszb1knqlG7fAYIRegmfqcUhRQRseCeI
	 1JGgXXyASIQWmN9aXvazFXc+RtAo+kuzyZT/X6d+Af/+JlSSzfVK38G0sDUt9yX345
	 dT/xF7Z2NKppW7LpRJJW6/gU=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0F81440E00DC;
	Sat, 28 Jun 2025 12:50:08 +0000 (UTC)
Date: Sat, 28 Jun 2025 14:50:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Kai Huang <kai.huang@intel.com>
Cc: dave.hansen@intel.com, tglx@linutronix.de, peterz@infradead.org,
	mingo@redhat.com, hpa@zytor.com, thomas.lendacky@amd.com,
	x86@kernel.org, kirill.shutemov@linux.intel.com,
	rick.p.edgecombe@intel.com, linux-kernel@vger.kernel.org,
	pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
	reinette.chatre@intel.com, isaku.yamahata@intel.com,
	dan.j.williams@intel.com, ashish.kalra@amd.com,
	nik.borisov@suse.com, sagis@google.com
Subject: Re: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
Message-ID: <20250628125001.GDaF_k-e2KTo4QlKjl@fat_crate.local>
References: <cover.1750934177.git.kai.huang@intel.com>
 <b963fcd60abe26c7ec5dc20b42f1a2ebbcc72397.1750934177.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b963fcd60abe26c7ec5dc20b42f1a2ebbcc72397.1750934177.git.kai.huang@intel.com>

On Thu, Jun 26, 2025 at 10:48:47PM +1200, Kai Huang wrote:

...

> Doing WBINVD in stop_this_cpu() could potentially increase the chance to
> trigger the above "race" despite it's still rare to happen.

Oh the amount of text... 

Please run it and all your comments through AI to simplify formulations etc.
It is a lot to read.

> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/include/asm/kexec.h         |  2 +-
>  arch/x86/include/asm/processor.h     |  2 ++
>  arch/x86/kernel/cpu/amd.c            | 16 ++++++++++++++++
>  arch/x86/kernel/machine_kexec_64.c   | 15 ++++++++++-----
>  arch/x86/kernel/process.c            | 16 +++-------------
>  arch/x86/kernel/relocate_kernel_64.S | 15 +++++++++++----
>  6 files changed, 43 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
> index f2ad77929d6e..d7e93522b93d 100644
> --- a/arch/x86/include/asm/kexec.h
> +++ b/arch/x86/include/asm/kexec.h
> @@ -122,7 +122,7 @@ relocate_kernel_fn(unsigned long indirection_page,
>  		   unsigned long pa_control_page,
>  		   unsigned long start_address,
>  		   unsigned int preserve_context,
> -		   unsigned int host_mem_enc_active);
> +		   unsigned int cache_incoherent);

So preserve_context and cache_incoherent are both a *single* bit of
information. And we use two u32s for that?!?!

How about flags please?

>  #endif
>  extern relocate_kernel_fn relocate_kernel;
>  #define ARCH_HAS_KIMAGE_ARCH
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index bde58f6510ac..a24c7805acdb 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -731,6 +731,8 @@ void __noreturn stop_this_cpu(void *dummy);
>  void microcode_check(struct cpuinfo_x86 *prev_info);
>  void store_cpu_caps(struct cpuinfo_x86 *info);
>  

So much text above - not a single comment here explaining what this var is
for.

> +DECLARE_PER_CPU(bool, cache_state_incoherent);
> +
>  enum l1tf_mitigations {
>  	L1TF_MITIGATION_OFF,
>  	L1TF_MITIGATION_AUTO,
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index f18f540db58c..4c7fde344216 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -503,6 +503,22 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>  {
>  	u64 msr;
>  
> +	/*
> +	 * Mark using wbinvd is needed during kexec on processors that

For all text: write insns in caps pls - WBINVD.

> +	 * support SME. This provides support for performing a successful
> +	 * kexec when going from SME inactive to SME active (or vice-versa).
> +	 *
> +	 * The cache must be cleared so that if there are entries with the
> +	 * same physical address, both with and without the encryption bit,
> +	 * they don't race each other when flushed and potentially end up
> +	 * with the wrong entry being committed to memory.
> +	 *
> +	 * Test the CPUID bit directly because the machine might've cleared
> +	 * X86_FEATURE_SME due to cmdline options.

Where?

That same function does the clearing later...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

