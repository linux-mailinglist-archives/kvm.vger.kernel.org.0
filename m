Return-Path: <kvm+bounces-31136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D2859C0A1E
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 16:29:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F2401F26CA7
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 15:29:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96CC121315D;
	Thu,  7 Nov 2024 15:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ZpMk5yJ0"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C992938DC8;
	Thu,  7 Nov 2024 15:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730993349; cv=none; b=rYOfaCJDdOw5jx6qB7m0T7MyeuzO/b1Q7LFHbeugJf0eHbYdbXH0FkJ5IQVQcoube3/aQsuYQomDFhjbJuZ8JMS3Kt/MRJq5TUHGFwl/3NZkOADKfkjQPm9TKgORvvwmxcSQhyZM0jzJz2S4mLujp5TiooaaOOyuCPtgT0Ybt2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730993349; c=relaxed/simple;
	bh=rGzDeohh0kX2zA2a/APzEvfZ9/gcKkZR33RHaqQQ5+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BB/qpbO5LFFktCyWH6W3CiMiq64/pc++kdSVtXhz/KJmOlIhsb4ttS2UMmvR+SoC+bnTs/S66GyyEiwVztE72danUNOCuT7MQu1916OZaYJ9XFUaqlmz/WJ/wF2Vc3G1ABuH0YIhjzF66tH41oGwFddkqsIAc0z83dyRfZdqj/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ZpMk5yJ0; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id CCBEE40E019C;
	Thu,  7 Nov 2024 15:29:03 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Gndh5Ytpc09R; Thu,  7 Nov 2024 15:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730993338; bh=XQVaOH6OxI1TpmdcB4SwNzAciQxVj/Ft+l1HUGIJor8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZpMk5yJ0JUElIRIB9wkIf5PXwbLZXZGGVJJVAi0ehcTL8fr7XIlAJATgyULUW1Uar
	 86z3zGNpA3gFwB4P6eFAgjr7VERK3aPYDAv4lk2NV5+OSQ3mjvygEqjKJYB2CvP3Ls
	 T4diFW+oq7oXSK/cHZDs9LjegXaKDPw9M7qmHd03un37GxJ7aMavnMj3VCEM6lpN26
	 LOd0DzEx3RZQmc66IU3QXNPgPlnJLJ7zdhTpZGooncPXURsuwgMgTJNj4QnMkSZqfU
	 LocgmBx8eAByO6mw0TvVSjHnlamwraA2EC80VsK7P7xe3vlUEdXjYAPcnHpjzRt9D1
	 M1zPQIbq4hbEedciSjc0ME9fAPEFMMdr+kCxB2oNCdpDoUjG88+cNxQPFte32nkWBM
	 v2s+dFKxGa4yjXKCO1G+9992QDPCKujdgFbTwk4Elz2BVE3sn0vaxKKBsb3tszXIcG
	 241mEGr6+AiEGUZaeDcYTTMj5aPLZl4aCYAHoKsOn5GPhzHxMYzGsDykEOJTUtMonM
	 fTRjZnPZBsmXdfRw+amPqT65RLRfPSM6oq8yumdXayjyAKjNo1NvKVFLeL0Az/jC99
	 Bg/SoDGe4CCjMLx8jsNzO4AMSMrOvtp+pSsdC6m0IsZuQpnwqu+DMBgwLuB/t92OAe
	 xBAkbw2Bjv4tR4/DTov19Wrg=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2CD5340E0163;
	Thu,  7 Nov 2024 15:28:40 +0000 (UTC)
Date: Thu, 7 Nov 2024 16:28:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 04/14] x86/apic: Initialize APIC backing page for Secure
 AVIC
Message-ID: <20241107152831.GZZyzcn2Tn2eIrMlzq@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-5-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240913113705.419146-5-Neeraj.Upadhyay@amd.com>

On Fri, Sep 13, 2024 at 05:06:55PM +0530, Neeraj Upadhyay wrote:
> From: Kishon Vijay Abraham I <kvijayab@amd.com>
> 
> Secure AVIC lets guest manage the APIC backing page (unlike emulated
> x2APIC or x2AVIC where the hypervisor manages the APIC backing page).
> 
> However the introduced Secure AVIC Linux design still maintains the
> APIC backing page in the hypervisor to shadow the APIC backing page
> maintained by guest (It should be noted only subset of the registers
> are shadowed for specific usecases and registers like APIC_IRR,
> APIC_ISR are not shadowed).
> 
> Add sev_ghcb_msr_read() to invoke "SVM_EXIT_MSR" VMGEXIT to read
> MSRs from hypervisor. Initialize the Secure AVIC's APIC backing
> page by copying the initial state of shadow APIC backing page in
> the hypervisor to the guest APIC backing page. Specifically copy
> APIC_LVR, APIC_LDR, and APIC_LVT MSRs from the shadow APIC backing
> page.

You don't have to explain what the patch does - rather, why the patch exists
in the first place and perhaps mention some non-obvious stuff why the code
does what it does.

Check your whole set pls.

> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Co-developed-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
>  arch/x86/coco/sev/core.c            | 41 ++++++++++++++++-----
>  arch/x86/include/asm/sev.h          |  2 ++
>  arch/x86/kernel/apic/x2apic_savic.c | 55 +++++++++++++++++++++++++++++
>  3 files changed, 90 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index 93470538af5e..0e140f92cfef 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -1331,18 +1331,15 @@ int __init sev_es_efi_map_ghcbs(pgd_t *pgd)
>  	return 0;
>  }
>  
> -static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
> +static enum es_result __vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt, bool write)

Yeah, this one was bugging me already during Nikunj's set so I cleaned it up
a bit differently:

https://git.kernel.org/tip/8bca85cc1eb72e21a3544ab32e546a819d8674ca

> +enum es_result sev_ghcb_msr_read(u64 msr, u64 *value)

Why is this a separate function if it is called only once from x2avic_savic.c?

I think you should merge it with read_msr_from_hv(), rename latter to

x2avic_read_msr_from_hv()

and leave it here in sev/core.c.

> +{
> +	struct pt_regs regs = { .cx = msr };
> +	struct es_em_ctxt ctxt = { .regs = &regs };
> +	struct ghcb_state state;
> +	unsigned long flags;
> +	enum es_result ret;
> +	struct ghcb *ghcb;
> +
> +	local_irq_save(flags);
> +	ghcb = __sev_get_ghcb(&state);
> +	vc_ghcb_invalidate(ghcb);
> +
> +	ret = __vc_handle_msr(ghcb, &ctxt, false);
> +	if (ret == ES_OK)
> +		*value = regs.ax | regs.dx << 32;
> +
> +	__sev_put_ghcb(&state);
> +	local_irq_restore(flags);
> +
> +	return ret;
> +}

...

> diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
> index 6a471bbc3dba..99151be4e173 100644
> --- a/arch/x86/kernel/apic/x2apic_savic.c
> +++ b/arch/x86/kernel/apic/x2apic_savic.c
> @@ -11,6 +11,7 @@
>  #include <linux/cc_platform.h>
>  #include <linux/percpu-defs.h>
>  #include <linux/align.h>
> +#include <linux/sizes.h>
>  
>  #include <asm/apic.h>
>  #include <asm/sev.h>
> @@ -20,6 +21,19 @@
>  static DEFINE_PER_CPU(void *, apic_backing_page);
>  static DEFINE_PER_CPU(bool, savic_setup_done);
>  
> +enum lapic_lvt_entry {

What's that enum for?

Oh, you want to use it below but you don't. Why?

> +	LVT_TIMER,
> +	LVT_THERMAL_MONITOR,
> +	LVT_PERFORMANCE_COUNTER,
> +	LVT_LINT0,
> +	LVT_LINT1,
> +	LVT_ERROR,
> +
> +	APIC_MAX_NR_LVT_ENTRIES,
> +};
> +
> +#define APIC_LVTx(x) (APIC_LVTT + 0x10 * (x))
> +
>  static int x2apic_savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
>  {
>  	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
> @@ -35,6 +49,22 @@ static inline void set_reg(char *page, int reg_off, u32 val)
>  	WRITE_ONCE(*((u32 *)(page + reg_off)), val);
>  }
>  
> +static u32 read_msr_from_hv(u32 reg)

A MSR's contents is u64. Make this function generic enough and have the
callsite select only the lower dword.

> +{
> +	u64 data, msr;
> +	int ret;
> +
> +	msr = APIC_BASE_MSR + (reg >> 4);
> +	ret = sev_ghcb_msr_read(msr, &data);
> +	if (ret != ES_OK) {
> +		pr_err("Secure AVIC msr (%#llx) read returned error (%d)\n", msr, ret);

Prepend "0x" to the format specifier.

> +		/* MSR read failures are treated as fatal errors */
> +		snp_abort();
> +	}
> +
> +	return lower_32_bits(data);
> +}

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

