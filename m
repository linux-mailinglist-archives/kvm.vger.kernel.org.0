Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E93361198
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 20:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234369AbhDOSBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 14:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbhDOSBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 14:01:42 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E73DC061574;
        Thu, 15 Apr 2021 11:01:19 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0ace00a15c83b1ea17ab01.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:ce00:a15c:83b1:ea17:ab01])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C4C981EC0288;
        Thu, 15 Apr 2021 20:01:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1618509677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=/BCCbxcbS/Yzgkj80ahhjEBvELn55ocOb9GzJxQIpLw=;
        b=DyHjLsb5mIn2Oq87CClqvfBrEtMtKjdpi818iniK8WEy13D2dAI7zTxhFFmuaqVpDOWMC8
        MjZPrGJM5v5u49OXakEUi+BG+88pSFjCYqkj1RvLDpjDCh+xHjUtGPip1gaWt/GsaoeyF5
        z2IJBg7JN2vTm/33sSaDzkmbP5tiS9o=
Date:   Thu, 15 Apr 2021 20:00:40 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, ak@linux.intel.com,
        herbert@gondor.apana.org.au, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part2 PATCH 03/30] x86: add helper functions for RMPUPDATE
 and PSMASH instruction
Message-ID: <20210415180040.GF6318@zn.tnic>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-4-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210324170436.31843-4-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021 at 12:04:09PM -0500, Brijesh Singh wrote:
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index 06394b6d56b2..7a0138cb3e17 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -644,3 +644,44 @@ rmpentry_t *lookup_page_in_rmptable(struct page *page, int *level)
>  	return entry;
>  }
>  EXPORT_SYMBOL_GPL(lookup_page_in_rmptable);
> +
> +int rmptable_psmash(struct page *page)

psmash() should be enough like all those other wrappers around insns.

> +{
> +	unsigned long spa = page_to_pfn(page) << PAGE_SHIFT;
> +	int ret;
> +
> +	if (!static_branch_unlikely(&snp_enable_key))
> +		return -ENXIO;
> +
> +	/* Retry if another processor is modifying the RMP entry. */

Also, a comment here should say which binutils version supports the
insn mnemonic so that it can be converted to "psmash" later. Ditto for
rmpupdate below.

Looking at the binutils repo, it looks like since version 2.36.

/me rebuilds objdump...

> +	do {
> +		asm volatile(".byte 0xF3, 0x0F, 0x01, 0xFF"
> +			      : "=a"(ret)
> +			      : "a"(spa)
> +			      : "memory", "cc");
> +	} while (ret == PSMASH_FAIL_INUSE);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(rmptable_psmash);
> +
> +int rmptable_rmpupdate(struct page *page, struct rmpupdate *val)

rmpupdate()

> +{
> +	unsigned long spa = page_to_pfn(page) << PAGE_SHIFT;
> +	bool flush = true;
> +	int ret;
> +
> +	if (!static_branch_unlikely(&snp_enable_key))
> +		return -ENXIO;
> +
> +	/* Retry if another processor is modifying the RMP entry. */
> +	do {
> +		asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
> +			     : "=a"(ret)
> +			     : "a"(spa), "c"((unsigned long)val), "d"(flush)
					    ^^^^^^^^^^^^^^^

what's the cast for?

"d"(flush)?

There's nothing in the APM talking about RMPUPDATE taking an input arg
in %rdx?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
