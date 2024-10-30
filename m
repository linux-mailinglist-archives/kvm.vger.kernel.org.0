Return-Path: <kvm+bounces-30009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D54F99B5FBE
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 11:10:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44442B22921
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 10:10:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5F041E2829;
	Wed, 30 Oct 2024 10:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="PFUL8SIi"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C92194151;
	Wed, 30 Oct 2024 10:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730283033; cv=none; b=ipqDLLq7M0VH4UVmHJf6+5CGJ24gom2I3YCGDWy35ivugt2GLaXS90K1ie1+Cv1IkiQXAJZ42JoHr9EAS/1AJUiWSMQ0acUJupu8kgg148+pvRIS9++nKqCKLCT+7tEonkE+nfH34C3RVb+h3/Bd3WB5OIegWv49dIqVanlYiY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730283033; c=relaxed/simple;
	bh=i4GE77iCf1S6gY67Vn5TV97o355YitLy44ad9O0SH2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VTcCbqCL6UWVefUOM/ylye21GgWrb5wWWQz0iiqeAT38XBtBMhB506QylXJTz5U+dz/OWt/HYPwhrh+M+jJzvXTEn82fogXtNrAygCxdVbpiAnPpqdPyBlH+T7PjF71Dniw/UWxfHFG7d7dNjl/iq4ACGhBf4FFajtc985rRAgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=PFUL8SIi; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C492D40E019C;
	Wed, 30 Oct 2024 10:10:26 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id jfjINq8O0L2C; Wed, 30 Oct 2024 10:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730283022; bh=8Aon9BgNC50dX50N7nMgOjmUoYAVReOI8W6mo7U0dCY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PFUL8SIic5GaUicFyA5suH7Yn3zXh5JAfuLtkquvjXXD0iYbdRcEp1mgOXmq40+KF
	 TGfSgzEg2MscpcygdivT1p802Ep8RUFG65sASdcM6v5Bq/KJhhSfjlFsYF4hC0HTMM
	 peopAU27ffbUIVG8t154Dx73EIbV7zy70B/4yhYCtI/9wW+J3l87lkqxrRCjHd2yWs
	 xAH4HFEHgMngqcwEqVLwagHmgNCyIGOhbvHnB/tH2PWqgvYx186ff9tuFyZbNL2GR5
	 kd5EIq16gLZkyfHdF+j10nJzzNHnmZFWzAE+4iGAaAFdhRNIT/mHhU76i/nvL7U7Bk
	 +2zyF2syCbcsMOxfHtP32oGsgjnNvRFJpAY3f+rXjMWWpzg2nYdf6t3oL/545/VoUd
	 JDkHiCq+vetsVJewDqdJxx+JWmgafumcVAQREBGDEQPkIp8sopq4ICWRqIlgvJMvGo
	 NpaUnV5G0oBS1/2CHlHI3lMKSlK/as0bMXeOiK0XjpC3X0+tDBaMFqSzm++JTyfhD7
	 nINH8PPPDVEryytrw5Xr9ETCj61KpPot+Afosh63QsAPsajtAfbikht39yM+5FZt0M
	 /Ry1HZalAM69I1U8Rq6CnLVm2kU92XeWh0oXC9vV+pxU7ZG+tjZTJ+blDSFCgUaGy/
	 4sUCaSs5AinjPj4UJtJicQeg=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E9E9740E0191;
	Wed, 30 Oct 2024 10:10:10 +0000 (UTC)
Date: Wed, 30 Oct 2024 11:10:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v14 01/13] x86/sev: Carve out and export SNP guest
 messaging init routines
Message-ID: <20241030101005.GAZyIF_bKVpe9gpHrn@fat_crate.local>
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-2-nikunj@amd.com>
 <20241029174357.GWZyEe3VwJr3xYHXoT@fat_crate.local>
 <733831ed-8622-de7d-a2e6-8f6c9ad4bc96@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <733831ed-8622-de7d-a2e6-8f6c9ad4bc96@amd.com>

On Wed, Oct 30, 2024 at 10:14:45AM +0530, Nikunj A. Dadhania wrote:
> >> Carve out common SNP guest messaging buffer allocations and message
> >> initialization routines to core/sev.c and export them. These newly added
> >> APIs set up the SNP message context (snp_msg_desc), which contains all the
> >> necessary details for sending SNP guest messages.
> 
> This explains how it is being done, which I think is useful. However, if you
> think otherwise, I can remove.

Useful why? It should be visible from the diff itself. Why do you have to
explain your diff?

If you feel the need to have to explain it, then *maybe* it needs splitting or
simplifying or whatnot.

> >> At present, the SEV guest platform data structure is used to pass the
> >> secrets page physical address to SEV guest driver. Since the secrets page
> >> address is locally available to the initialization routine, use the cached
> >> address. Remove the unused SEV guest platform data structure.
> 
> In the above paragraph I tried to explains why I have removed
> sev_guest_platform_data.

Probably ok.

> People have different styles of writing, as long as we are capturing the
> required information, IMHO, it should be fine.

"... as long we are not writing what the patch does - which is visible from
the diff itself, it should be fine." is what I would say.

> Let me try to repharse the commit message again:
> 
> x86/sev: Carve out and export SNP guest messaging init routines
> 
> Currently, the sev-guest driver is the only user of SNP guest messaging.
> All routines for initializing SNP guest messaging are implemented within
> the sev-guest driver and are not available during early boot. In
> prepratation for adding Secure TSC guest support, carve out APIs to
> allocate and initialize guest messaging descriptor context and make it part
> of coco/sev/core.c. As there is no user of sev_guest_platform_data anymore,
> remove the structure.

Yap, better.

Btw, you can even use AI for help rephrasing it:

-> Please simpliify this code change description by concentrating only on why
the change is being done:

<insert commit message here>

ChatGPT: "This change is being made to allow the Secure TSC guest feature to
access SNP guest messaging routines earlier in the boot process. By moving
common SNP message initialization routines to a central location (core/sev.c)
and exporting them, these routines become accessible for early boot needs.
Additionally, since the secrets page address is now accessible within the
initialization, the redundant SEV guest platform data structure has been
removed."

-> Do the same as the above but write it in imperative tone

ChatGPT: "Enable Secure TSC guest support by moving the SNP guest messaging
routines to core/sev.c, making them available during early boot. Export these
routines to set up the SNP message context (snp_msg_desc) needed for guest
messaging. Use the cached secrets page address in the initialization routine,
and remove the unused SEV guest platform data structure."

I think that's a good help to use at least as a starter for the final commit
message.

To sum up: I'd like the commit message to contain enough information to know
*why* a change has been done. No rambling about what the patch does.

> > ld: vmlinux.o: in function `snp_init_crypto':
> > /home/boris/kernel/2nd/linux/arch/x86/coco/sev/core.c:2700:(.text+0x1fa3): undefined reference to `aesgcm_expandkey'
> > make[2]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
> > make[1]: *** [/mnt/kernel/kernel/2nd/linux/Makefile:1166: vmlinux] Error 2
> > make[1]: *** Waiting for unfinished jobs....
> > make: *** [Makefile:224: __sub-make] Error 2
> > 
> > I'll stop here until you fix those.
> 
> Sorry for this, I had sev-guest driver as in-built module in my config, so wasn't
> able to catch this in my per patch build script. The corresponding fix is in the 
> following patch[1], during patch juggling it had landed there:
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 2852fcd82cbd..6426b6d469a4 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1556,6 +1556,7 @@ config AMD_MEM_ENCRYPT
>  	select ARCH_HAS_CC_PLATFORM
>  	select X86_MEM_ENCRYPT
>  	select UNACCEPTED_MEMORY
> +	select CRYPTO_LIB_AESGCM

Right, that is debatable. AMD memory encryption support cannot really depend
on a crypto library - you can get it without it too - just won't get secure
TSC but for simplicity's sake let's leave it that way for now.

Because looking at this:

config AMD_MEM_ENCRYPT          
        bool "AMD Secure Memory Encryption (SME) support"
        depends on X86_64 && CPU_SUP_AMD
        depends on EFI_STUB 
        select DMA_COHERENT_POOL
        select ARCH_USE_MEMREMAP_PROT
        select INSTRUCTION_DECODER
        select ARCH_HAS_CC_PLATFORM
        select X86_MEM_ENCRYPT
        select UNACCEPTED_MEMORY
        select CRYPTO_LIB_AESGCM

that symbol is pulling in a lot of other stuff. I guess it is ok for now...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

