Return-Path: <kvm+bounces-64939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A61FC92704
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 16:18:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6A0DE4E12A4
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 15:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B51F4265621;
	Fri, 28 Nov 2025 15:18:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D722724A07C
	for <kvm@vger.kernel.org>; Fri, 28 Nov 2025 15:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764343130; cv=none; b=YtkNuruP5lI2amXwDV9ePUyjcFVZc/1ivzKu3VXar+u18nc6ycNIoUuRfJa/UwjFrLjmQNtwCLC1cqjdELK5zT/SbiSS7NvV1HI3aQm7AcoHSwtOmDbyYdzx/8OpMTfeTC8+zZV3nyaAk6tdchiBL3CEQnbqGLLg2IsgzRQ77k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764343130; c=relaxed/simple;
	bh=cPIAl0MknH3Ubw5SLJY+k56ymudueQeGEETaisFABrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZlrZ0LVfp39GFEmzfNembzxHBk8UeSrvLbDapB/L984cBr1wi2ghr/2MnzmFYmuzD0gFDtgL1Sb2dpzROUPI1Jeezt1rfiAo+B2zP0KQFn0yMpjilQmV0vGX7+Az4ik8PRmFd5ie91On0fZiGCWpnufcfJUpvoUXwDKtTTFMq6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C031D176A;
	Fri, 28 Nov 2025 07:18:39 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E0BE83F66E;
	Fri, 28 Nov 2025 07:18:45 -0800 (PST)
Date: Fri, 28 Nov 2025 15:18:43 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, andrew.jones@linux.dev,
	kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v3 02/10] arm64: efi: initialise SCTLR_ELx
 fully
Message-ID: <20251128151843.GB3391839@e124191.cambridge.arm.com>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-3-joey.gouly@arm.com>
 <92f27f98-e4c9-41d9-badc-635e5ba40552@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92f27f98-e4c9-41d9-badc-635e5ba40552@redhat.com>

On Thu, Nov 27, 2025 at 05:49:45PM +0100, Eric Auger wrote:
> Hi Joey,
> 
> On 9/25/25 4:19 PM, Joey Gouly wrote:
> > Don't rely on the value of SCTLR_ELx when booting via EFI.
> >
> > Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> > ---
> >  lib/arm/asm/setup.h   |  6 ++++++
> >  lib/arm/setup.c       |  3 +++
> >  lib/arm64/processor.c | 12 ++++++++++++
> >  3 files changed, 21 insertions(+)
> >
> > diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
> > index 9f8ef82e..4e60d552 100644
> > --- a/lib/arm/asm/setup.h
> > +++ b/lib/arm/asm/setup.h
> > @@ -28,6 +28,12 @@ void setup(const void *fdt, phys_addr_t freemem_start);
> >  
> >  #include <efi.h>
> >  
> > +#ifdef __aarch64__
> > +void setup_efi_sctlr(void);
> > +#else
> > +static inline void setup_efi_sctlr(void) {}
> > +#endif
> > +
> >  efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo);
> >  
> >  #endif
> > diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> > index 67b5db07..0aaa1d3a 100644
> > --- a/lib/arm/setup.c
> > +++ b/lib/arm/setup.c
> > @@ -349,6 +349,9 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
> >  {
> >  	efi_status_t status;
> >  
> > +
> spurious line
> > +	setup_efi_sctlr();
> > +
> >  	exceptions_init();
> >  
> >  	memregions_init(arm_mem_regions, NR_MEM_REGIONS);
> > diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
> > index eb93fd7c..edc0ad87 100644
> > --- a/lib/arm64/processor.c
> > +++ b/lib/arm64/processor.c
> > @@ -8,6 +8,7 @@
> >  #include <libcflat.h>
> >  #include <asm/ptrace.h>
> >  #include <asm/processor.h>
> > +#include <asm/setup.h>
> >  #include <asm/thread_info.h>
> >  
> >  static const char *vector_names[] = {
> > @@ -271,3 +272,14 @@ bool __mmu_enabled(void)
> >  {
> >  	return read_sysreg(sctlr_el1) & SCTLR_EL1_M;
> >  }
> > +
> > +#ifdef CONFIG_EFI
> > +
> > +void setup_efi_sctlr(void)
> > +{
> > +	// EFI exits boot services with SCTLR_ELx.M=1, so keep
> > +	// the MMU enabled.
> I don't really understand the comment, if MMU was enabled why are we
> mandated to set M bit again?

I'm overwriting sctlr_el1 with a fully new value, rather than using a
'read-modify-write' style. So the comment is justifying why I'm using the
INIT_SCTLR_EL1_MMU_OFF define but also or-ing in the M bit.

> 
> Eric
> > +	write_sysreg(INIT_SCTLR_EL1_MMU_OFF | SCTLR_EL1_M, sctlr_el1);
> > +}
> > +
> > +#endif
> 

Thanks,
Joey

