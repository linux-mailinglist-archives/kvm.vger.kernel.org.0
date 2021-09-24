Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F6F417684
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 16:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346680AbhIXOFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 10:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346508AbhIXOFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 10:05:48 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7EDC061571;
        Fri, 24 Sep 2021 07:04:14 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0dd6008eddcbd152a1c1b1.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:d600:8edd:cbd1:52a1:c1b1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0122D1EC0541;
        Fri, 24 Sep 2021 16:04:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1632492249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=HHrCbHtfMapdgdHCywxiLt5xWw+NugbzfPjFHMI1IsA=;
        b=izZgEa0Nz5w/sF+dYGp81sHbvdgjXfqEv4hReEWlibBKbHN5yf3biZcl359Jjb8C1slTp2
        9TCezwSIRcGAgAdIIzYHCFDPGt0B7TGKaK37szg8jY+26PmviIwjwYRDRmg6QfSXtWTAiP
        2U9NKFoADRHb0CpQ/y1xb1NeV2e/FGg=
Date:   Fri, 24 Sep 2021 16:04:00 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 05/45] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
Message-ID: <YU3a0N2EfZIGP2IR@zn.tnic>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-6-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-6-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021 at 10:58:38AM -0500, Brijesh Singh wrote:
> The RMPUPDATE instruction writes a new RMP entry in the RMP Table. The
> hypervisor will use the instruction to add pages to the RMP table. See
> APM3 for details on the instruction operations.
> 
> The PSMASH instruction expands a 2MB RMP entry into a corresponding set of
> contiguous 4KB-Page RMP entries. The hypervisor will use this instruction
> to adjust the RMP entry without invalidating the previous RMP entry.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/sev.h | 11 ++++++
>  arch/x86/kernel/sev.c      | 72 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 83 insertions(+)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 5b1a6a075c47..92ced9626e95 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -78,7 +78,9 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
>  
>  /* RMP page size */
>  #define RMP_PG_SIZE_4K			0
> +#define RMP_PG_SIZE_2M			1
>  #define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
> +#define X86_TO_RMP_PG_LEVEL(level)	(((level) == PG_LEVEL_4K) ? RMP_PG_SIZE_4K : RMP_PG_SIZE_2M)
>  
>  /*
>   * The RMP entry format is not architectural. The format is defined in PPR
> @@ -107,6 +109,15 @@ struct __packed rmpentry {
>  
>  #define RMPADJUST_VMSA_PAGE_BIT		BIT(16)
>  
> +struct rmpupdate {

Function is called the same way - maybe this should be called
rmpupdate_desc or so.

> +	u64 gpa;
> +	u8 assigned;
> +	u8 pagesize;
> +	u8 immutable;
> +	u8 rsvd;
> +	u32 asid;
> +} __packed;
> +
>  #ifdef CONFIG_AMD_MEM_ENCRYPT
>  extern struct static_key_false sev_es_enable_key;
>  extern void __sev_es_ist_enter(struct pt_regs *regs);
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index f383d2a89263..8627c49666c9 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -2419,3 +2419,75 @@ int snp_lookup_rmpentry(u64 pfn, int *level)
>  	return !!rmpentry_assigned(e);
>  }
>  EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
> +

<--- kernel-doc comment.

> +int psmash(u64 pfn)
> +{
> +	unsigned long paddr = pfn << PAGE_SHIFT;
> +	int ret;
> +
> +	if (!pfn_valid(pfn))
> +		return -EINVAL;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return -ENXIO;

Make that the first check pls.

> +
> +	/* Binutils version 2.36 supports the PSMASH mnemonic. */
> +	asm volatile(".byte 0xF3, 0x0F, 0x01, 0xFF"
> +		      : "=a"(ret)
> +		      : "a"(paddr)
> +		      : "memory", "cc");
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(psmash);

That's for kvm?

> +static int rmpupdate(u64 pfn, struct rmpupdate *val)
> +{
> +	unsigned long paddr = pfn << PAGE_SHIFT;
> +	int ret;
> +
> +	if (!pfn_valid(pfn))
> +		return -EINVAL;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return -ENXIO;

Also first check.

> +
> +	/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
> +	asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
> +		     : "=a"(ret)
> +		     : "a"(paddr), "c"((unsigned long)val)
> +		     : "memory", "cc");
> +	return ret;
> +}
> +
> +int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable)
> +{
> +	struct rmpupdate val;
> +
> +	if (!pfn_valid(pfn))
> +		return -EINVAL;

rmpupdate() does that check too so choose one place please and kill the
other.

> +	memset(&val, 0, sizeof(val));
> +	val.assigned = 1;
> +	val.asid = asid;
> +	val.immutable = immutable;
> +	val.gpa = gpa;
> +	val.pagesize = X86_TO_RMP_PG_LEVEL(level);
> +
> +	return rmpupdate(pfn, &val);
> +}
> +EXPORT_SYMBOL_GPL(rmp_make_private);
> +
> +int rmp_make_shared(u64 pfn, enum pg_level level)
> +{
> +	struct rmpupdate val;
> +
> +	if (!pfn_valid(pfn))
> +		return -EINVAL;
> +
> +	memset(&val, 0, sizeof(val));
> +	val.pagesize = X86_TO_RMP_PG_LEVEL(level);
> +
> +	return rmpupdate(pfn, &val);
> +}
> +EXPORT_SYMBOL_GPL(rmp_make_shared);

Both exports for kvm I assume?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
