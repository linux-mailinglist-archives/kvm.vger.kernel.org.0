Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD611CD5CD
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 12:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbgEKKCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 06:02:09 -0400
Received: from mail.skyhub.de ([5.9.137.197]:55062 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725983AbgEKKCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 06:02:08 -0400
Received: from zn.tnic (p200300EC2F05F1002C1974F11FB72105.dip0.t-ipconnect.de [IPv6:2003:ec:2f05:f100:2c19:74f1:1fb7:2105])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 45A641EC02FA;
        Mon, 11 May 2020 12:02:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1589191327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=zwMOv/5lYrHVlC0KrboBSXdHgtiHMsqiApbipX705iE=;
        b=g1zePbp4zFJpzqNjEzIJ0MjfU42ysbAD86M/i6EJcFGZYnQFoUwU9TZWE9EGYpwUSqVVOB
        x8cBcUP13CAUZH+OvPxcw2KH21AwRYvi8CqxzNDqkT6mvEcdATfTQk1Ngx3Q8T8HcZ2x6x
        BFna8ZFwCLH3XjZeRCFMJ8EokPVQd80=
Date:   Mon, 11 May 2020 12:02:01 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 22/75] x86/boot/compressed/64: Add
 set_page_en/decrypted() helpers
Message-ID: <20200511100201.GA25861@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-23-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-23-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:16:32PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> The functions are needed to map the GHCB for SEV-ES guests. The GHCB is
> used for communication with the hypervisor, so its content must not be
> encrypted. After the GHCB is not needed anymore it must be mapped
> encrypted again so that the running kernel image can safely re-use the
> memory.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/boot/compressed/ident_map_64.c | 134 ++++++++++++++++++++++++
>  arch/x86/boot/compressed/misc.h         |   2 +
>  2 files changed, 136 insertions(+)

...

> +
> +static int set_clr_page_flags(struct x86_mapping_info *info,
> +			      unsigned long address,
> +			      pteval_t set, pteval_t clr)
> +{
> +	unsigned long scratch, *target;
> +	pgd_t *pgdp = (pgd_t *)top_level_pgt;
> +	p4d_t *p4dp;
> +	pud_t *pudp;
> +	pmd_t *pmdp;
> +	pte_t *ptep, pte;
> +
> +	/*
> +	 * First make sure there is a PMD mapping for 'address'.
> +	 * It should already exist, but keep things generic.
> +	 *
> +	 * To map the page just read from it and fault it in if there is no
> +	 * mapping yet. add_identity_map() can't be called here because that
> +	 * would unconditionally map the address on PMD level, destroying any
> +	 * PTE-level mappings that might already exist.  Also do something
> +	 * useless

You mean something like this?

        asm volatile("mov %[address], %%r9"
                     :: [address] "g" (*(unsigned long *)address)
                     : "r9", "memory");

The "memory" clobber should prevent gcc from optimizing that thing away
and r9 is callee-clobbered.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
