Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7181840E4B2
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 19:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344749AbhIPRFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 13:05:15 -0400
Received: from mail.skyhub.de ([5.9.137.197]:37514 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346683AbhIPQ55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 12:57:57 -0400
Received: from zn.tnic (p200300ec2f11c6001e49ea6afe1054f5.dip0.t-ipconnect.de [IPv6:2003:ec:2f11:c600:1e49:ea6a:fe10:54f5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 211431EC0277;
        Thu, 16 Sep 2021 18:56:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1631811390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=CsguPVegY1Z3/cHkTvyO5SSM87RXYzv+szSa5MU4dro=;
        b=Y9B3Lju7uANekQ/vNO1kgsIJoEUoNMktGkOPAuf61gUG3/WfraP1VY1HDl/EF4DE+WMM0G
        ofFGOckCcDnYYrqRrz50rI90T6nYdB8WXn2m2WPaCJAiVmQZKUs9nmqa7f9Kvafb01t8GQ
        YNWW7riHkc74G2m2g7g3cj+hKDcPN14=
Date:   Thu, 16 Sep 2021 18:56:22 +0200
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
Subject: Re: [PATCH Part2 v5 01/45] x86/cpufeatures: Add SEV-SNP CPU feature
Message-ID: <YUN3Nquhsn4OD9S8@zn.tnic>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-2-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-2-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021 at 10:58:34AM -0500, Brijesh Singh wrote:
> Add CPU feature detection for Secure Encrypted Virtualization with
> Secure Nested Paging. This feature adds a strong memory integrity
> protection to help prevent malicious hypervisor-based attacks like
> data replay, memory re-mapping, and more.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h       | 1 +
>  arch/x86/kernel/cpu/amd.c                | 3 ++-
>  tools/arch/x86/include/asm/cpufeatures.h | 1 +
>  3 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index d0ce5cfd3ac1..62f458680772 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -398,6 +398,7 @@
>  #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
>  #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
>  #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
> +#define X86_FEATURE_SEV_SNP		(19*32+4)  /* AMD Secure Encrypted Virtualization - Secure Nested Paging */

s/AMD Secure Encrypted Virtualization/AMD SEV/g

Bit 1 above already has that string - no need for repeating it
everywhere.

Also, note the vertical alignment (space after the '+'):

					(19*32+ 4)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
