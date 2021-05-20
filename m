Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBAB38B540
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 19:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbhETReP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 13:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbhETReN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 13:34:13 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D99C061574;
        Thu, 20 May 2021 10:32:50 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0eb6009f35b1f88a592069.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:b600:9f35:b1f8:8a59:2069])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 48CD01EC064A;
        Thu, 20 May 2021 19:32:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1621531968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u8iXPH5P0KT0EXX32h1RoqsIrcIQPzeP3RsrjsiJkxU=;
        b=HqZlwIaK7S+8G5XIuqTKYDYoH54ZGPWvd6EFH8d54FW40o1whnt82F4Dk18qUYuWxmBBZo
        sy6asLrefqibkXizoqhJMVNEkmjHKQa3RCCTgy2wUL9eJoa4zdtyxhbqTQA5C0PZnP62ay
        4MYoc9PehMWFAm44E7p+cKzMJY/KgvQ=
Date:   Thu, 20 May 2021 19:32:42 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 10/20] x86/sev: Add a helper for the
 PVALIDATE instruction
Message-ID: <YKadOnfjaeffKwav@zn.tnic>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-11-brijesh.singh@amd.com>
 <4ecbed35-aca4-9e30-22d0-f5c46b67b70a@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4ecbed35-aca4-9e30-22d0-f5c46b67b70a@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 08:05:36AM -0500, Brijesh Singh wrote:
> While generating the patches for part1, I accidentally picked the wrong
> version of this patch.

Adding the right one...

> Author: Brijesh Singh <brijesh.singh@amd.com>
> Date:   Thu Apr 29 16:45:36 2021 -0500
> 
>     x86/sev: Add a helper for the PVALIDATE instruction
>     
>     An SNP-active guest uses the PVALIDATE instruction to validate or
>     rescind the validation of a guest page’s RMP entry. Upon completion,
>     a return code is stored in EAX and rFLAGS bits are set based on the
>     return code. If the instruction completed successfully, the CF
>     indicates if the content of the RMP were changed or not.
> 
>     See AMD APM Volume 3 for additional details.
> 
>     Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 134a7c9d91b6..be67d9c70267 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -59,6 +59,16 @@ extern void vc_no_ghcb(void);
>  extern void vc_boot_ghcb(void);
>  extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
>  
> +/* Return code of pvalidate */
> +#define PVALIDATE_SUCCESS		0
> +#define PVALIDATE_FAIL_INPUT		1
> +#define PVALIDATE_FAIL_SIZEMISMATCH	6

Those are unused. Remove them pls.

> +#define PVALIDATE_FAIL_NOUPDATE		255 /* Software defined (when rFlags.CF = 1) */

Put the comment above the define pls.

> +
> +/* RMP page size */
> +#define RMP_PG_SIZE_2M			1
> +#define RMP_PG_SIZE_4K			0

Add those when you need them - I see

[PATCH Part2 RFC v2 06/37] x86/sev: Add RMP entry lookup helpers

is moving them to some generic header. No need to add them to this patch
here.

>  #ifdef CONFIG_AMD_MEM_ENCRYPT
>  extern struct static_key_false sev_es_enable_key;
>  extern void __sev_es_ist_enter(struct pt_regs *regs);
> @@ -81,12 +91,29 @@ static __always_inline void sev_es_nmi_complete(void)
>  		__sev_es_nmi_complete();
>  }
>  extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
> +static inline int pvalidate(unsigned long vaddr, bool rmp_psize, bool validate)
> +{
> +	bool no_rmpupdate;
> +	int rc;

Adding this for the mail archives when we find this mail again in the
future so that I don't have to do binutils git archeology again:

Enablement for the "pvalidate" mnemonic is in binutils commit
646cc3e0109e ("Add AMD znver3 processor support"). :-)

Please put over the opcode bytes line:

	/* "pvalidate" mnemonic support in binutils 2.36 and newer */

> +
> +	asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFF\n\t"
> +		     CC_SET(c)
> +		     : CC_OUT(c) (no_rmpupdate), "=a"(rc)
> +		     : "a"(vaddr), "c"(rmp_psize), "d"(validate)
> +		     : "memory", "cc");
> +
> +	if (no_rmpupdate)
> +		return PVALIDATE_FAIL_NOUPDATE;
> +
> +	return rc;
> +}

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
