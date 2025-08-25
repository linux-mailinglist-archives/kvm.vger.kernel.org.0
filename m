Return-Path: <kvm+bounces-55635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5C98B345AB
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:25:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 220633AF3B6
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 15:25:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C5362F99BC;
	Mon, 25 Aug 2025 15:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="kksYH6eC"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849921C862C
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 15:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756135539; cv=none; b=WlLHcsPN7L1F9XfdGkK/4mlb0EZq2ZbwK9hPNfC1hAZ4ELr2b8T/SaEl+ya1g9w+h7xgQUbbM+oh2gNy1Mem49Y5pGQkV6ct4nsLihQfS7WfM9Vd08BHHbqyHOyLQpM2kQfSpfMMwsM6lDSJi8zYivW3Jxf3NxYF7twh0ihA2SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756135539; c=relaxed/simple;
	bh=A52FAwezOAKp1Qu5TWFTktoFPwXKVKbjCotxVYW0vis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EBGfDQeAXc0w45Jc1lKWGe3xINqpGxBJzvfkTl5eW0N7lGby4JjZirP0E0Z5usZ2ApsBnUhaysKHl43wSDhkwkuVnd+fMOwVMKq05K9ytufzRnwpaCEKTjhiQzPPlto6aU45yq4NPmy0dtD7TAbEjajcKvw3+aUqufeKdXbFQRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=kksYH6eC; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 95BB140E0217;
	Mon, 25 Aug 2025 15:25:33 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id u3FQXnYdIgDT; Mon, 25 Aug 2025 15:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1756135529; bh=wDGac0TYgHwFdyangyB6LUxtI+D7GnL9tmax06sBl2E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kksYH6eClO7cCwGTfJpvPamUQ638dQxsIRz5RqdEsS2aTY0E/1Zx1VnOqyJiM+Fos
	 8uVnP0zFvst7bC+/6K9jSXKbRqiX7aRoq604M3Gx/oXyzTSDPExIHFGfFxfo0E3AEA
	 8+dOdl66Wwqmkk7Mw5ZExpoTSGU7VOd9qu3bHRvQYvc9qFNYOzZT5lvCUoTcm4RK51
	 uo//HK5wwuElCDxqTHJdYVuE9vBt9D0B3eVN0Dxs+Q8TJGX2HA4+96KYZK2uMG+bwx
	 WydgKEZJTT6M4zsbZjsFLj+s3YHnEWE+bsALrdl4NwIMMqfpR7LKhGMkzvbnhnKLCO
	 jk4FTfF5e1hcZmOAdFNJFWT28uOf4T8FW8w1GNbdWSf4esB9cFDHaPPOTJLPYwLJ05
	 qqjWGfX2AhkzY06WRz5kEMr53XLNU05hp+wfgmEtTAWmetPeRFlZdTkXBWLO7Dt8nJ
	 21PX4cugc921ruUohbrxObe4q30A1pW7L4Qb8vRantacHRlgGnUehbbqJUGnANay52
	 pg2K/IUlUgT6L6BwGFVK8t+F3Y4D5syqZa/W/oxFqPIyoQwP3rAMinLtqCSDFC4f/Z
	 QdqJ/bA2/S0f2hm0zpwD3/26ZaMG7hwOp+qU8lviS5oQHs9e0wInn/rk8h8V8wk7Z9
	 WCmee8KiPDnbUiWAE+dlK7fA=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 64D5840E0202;
	Mon, 25 Aug 2025 15:25:22 +0000 (UTC)
Date: Mon, 25 Aug 2025 17:25:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	thomas.lendacky@amd.com, santosh.shukla@amd.com,
	joao.m.martins@oracle.com
Subject: Re: [RFC PATCH 3/4] x86/cpufeatures: Add Page modification logging
Message-ID: <20250825152521.GDaKyAYVSNCXyNjtSL@fat_crate.local>
References: <20250825152009.3512-1-nikunj@amd.com>
 <20250825152009.3512-4-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250825152009.3512-4-nikunj@amd.com>

On Mon, Aug 25, 2025 at 03:20:08PM +0000, Nikunj A Dadhania wrote:
> Page modification logging(PML) is a hardware feature designed to track
> guest modified memory pages. PML enables the hypervisor to identify which
> pages in a guest's memory have been changed since the last checkpoint or
> during live migration.
> 
> The PML feature is advertised via CPUID leaf 0x8000000A ECX[4] bit.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/kernel/cpu/scattered.c    | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 286d509f9363..069c0e17113a 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -227,6 +227,7 @@
>  #define X86_FEATURE_PVUNLOCK		( 8*32+20) /* PV unlock function */
>  #define X86_FEATURE_VCPUPREEMPT		( 8*32+21) /* PV vcpu_is_preempted function */
>  #define X86_FEATURE_TDX_GUEST		( 8*32+22) /* "tdx_guest" Intel Trust Domain Extensions Guest */
> +#define X86_FEATURE_PML			( 8*32+23) /* AMD Page Modification logging */
>  
>  /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
>  #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* "fsgsbase" RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
> diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
> index b4a1f6732a3a..02fc16b28bc9 100644
> --- a/arch/x86/kernel/cpu/scattered.c
> +++ b/arch/x86/kernel/cpu/scattered.c
> @@ -48,6 +48,7 @@ static const struct cpuid_bit cpuid_bits[] = {
>  	{ X86_FEATURE_PROC_FEEDBACK,		CPUID_EDX, 11, 0x80000007, 0 },
>  	{ X86_FEATURE_AMD_FAST_CPPC,		CPUID_EDX, 15, 0x80000007, 0 },
>  	{ X86_FEATURE_MBA,			CPUID_EBX,  6, 0x80000008, 0 },
> +	{ X86_FEATURE_PML,			CPUID_ECX,  4, 0x8000000A, 0 },
>  	{ X86_FEATURE_SMBA,			CPUID_EBX,  2, 0x80000020, 0 },
>  	{ X86_FEATURE_BMEC,			CPUID_EBX,  3, 0x80000020, 0 },
>  	{ X86_FEATURE_TSA_SQ_NO,		CPUID_ECX,  1, 0x80000021, 0 },
> -- 

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

