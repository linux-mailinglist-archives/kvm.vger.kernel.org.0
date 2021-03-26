Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CE034A9C0
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 15:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhCZOar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 10:30:47 -0400
Received: from mail.skyhub.de ([5.9.137.197]:40658 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229908AbhCZOaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 10:30:35 -0400
Received: from zn.tnic (p200300ec2f075f0023f9e598b0fb3457.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:5f00:23f9:e598:b0fb:3457])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5B94D1EC052C;
        Fri, 26 Mar 2021 15:30:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616769034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=oJkolnL9jjg81qljwrUuZ1hFVB/MeYbUdPDzJrA7TaA=;
        b=RqBGPN32FfzzHmc1/a0E6NVvybDsMbmjnjZRdaKi8+XReCeSIyFqRCMt/iAWqODxuC9NR0
        rf5959QvQ4wv3lvBFR7NmOHb+Fb+BP9MVdMKWRpMj9/ZqxJOdYiNBojBinue0WCGpJ51bK
        nyo7OTxp/G2xKb9DsbZSzpPowPFnRqY=
Date:   Fri, 26 Mar 2021 15:30:26 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 03/13] x86: add a helper routine for the
 PVALIDATE instruction
Message-ID: <20210326143026.GB27507@zn.tnic>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-4-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210324164424.28124-4-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021 at 11:44:14AM -0500, Brijesh Singh wrote:
>  arch/x86/include/asm/sev-snp.h | 52 ++++++++++++++++++++++++++++++++++

Hmm, a separate header.

Yeah, I know we did sev-es.h but I think it all should be in a single
sev.h which contains all AMD-specific memory encryption declarations.
It's not like it is going to be huge or so, by the looks of how big
sev-es.h is.

Or is there a particular need to have a separate snp header?

If not, please do a pre-patch which renames sev-es.h to sev.h and then
add the SNP stuff to it.

>  1 file changed, 52 insertions(+)
>  create mode 100644 arch/x86/include/asm/sev-snp.h
> 
> diff --git a/arch/x86/include/asm/sev-snp.h b/arch/x86/include/asm/sev-snp.h
> new file mode 100644
> index 000000000000..5a6d1367cab7
> --- /dev/null
> +++ b/arch/x86/include/asm/sev-snp.h
> @@ -0,0 +1,52 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * AMD SEV Secure Nested Paging Support
> + *
> + * Copyright (C) 2021 Advanced Micro Devices, Inc.
> + *
> + * Author: Brijesh Singh <brijesh.singh@amd.com>
> + */
> +
> +#ifndef __ASM_SECURE_NESTED_PAGING_H
> +#define __ASM_SECURE_NESTED_PAGING_H
> +
> +#ifndef __ASSEMBLY__
> +#include <asm/irqflags.h> /* native_save_fl() */

Where is that used? Looks like leftovers.

> +
> +/* Return code of __pvalidate */
> +#define PVALIDATE_SUCCESS		0
> +#define PVALIDATE_FAIL_INPUT		1
> +#define PVALIDATE_FAIL_SIZEMISMATCH	6
> +
> +/* RMP page size */
> +#define RMP_PG_SIZE_2M			1
> +#define RMP_PG_SIZE_4K			0
> +
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +static inline int __pvalidate(unsigned long vaddr, int rmp_psize, int validate,

Why the "__" prefix?

> +			      unsigned long *rflags)
> +{
> +	unsigned long flags;
> +	int rc;
> +
> +	asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFF\n\t"
> +		     "pushf; pop %0\n\t"

Ewww, PUSHF is expensive.

> +		     : "=rm"(flags), "=a"(rc)
> +		     : "a"(vaddr), "c"(rmp_psize), "d"(validate)
> +		     : "memory", "cc");
> +
> +	*rflags = flags;
> +	return rc;

Hmm, rc *and* rflags. Manual says "Upon completion, a return code is
stored in EAX. rFLAGS bits OF, ZF, AF, PF and SF are set based on this
return code."

So what exactly does that mean and is the return code duplicated in
rFLAGS?

If so, can you return a single value which has everything you need to
know?

I see that you're using the retval only for the carry flag to check
whether the page has already been validated so I think you could define
a set of return value defines from that function which callers can
check.

And looking above again, you do have PVALIDATE_* defines except that
nothing's using them. Use them please.

Also, for how to do condition code checks properly, see how the
CC_SET/CC_OUT macros are used.

> +}
> +
> +#else	/* !CONFIG_AMD_MEM_ENCRYPT */

This else-ifdeffery can go too if you move the ifdeffery inside the
function:

static inline int __pvalidate(unsigned long vaddr, int rmp_psize, int validate,
{
	int rc = 0;

#fidef CONFIG_AMD_MEM_ENCRYPT

	...

#endif

	return rc;
}

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
