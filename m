Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E4636253D
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 18:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240086AbhDPQLF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 12:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240003AbhDPQLC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 12:11:02 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E366AC061574;
        Fri, 16 Apr 2021 09:10:33 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0cc5009814827a174df863.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:c500:9814:827a:174d:f863])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6A3B61EC0266;
        Fri, 16 Apr 2021 18:10:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1618589431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=+MJ/0/bCWRz30Mius/GPUqvFtWhZjXcEQ85tGdDxnEo=;
        b=hsOStmq9d5jwAO8B6qzzf5VDCgjx5/XxwAJLSA2VQ2rYv5uslbCRphvdsyyJnpAOzpo+FH
        9U3I0ffyWY/RegHhRlRgbX3Q+MOZkS8RBG1IcvOS8NhJhD06gfFI99DclF1yagr0GM+cC+
        xX+x7G9BNyk3o0AaS9loMaucg32h2xo=
Date:   Fri, 16 Apr 2021 18:10:30 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Peter Gonda <pgonda@google.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv2 02/13] x86/kvm: Introduce KVM memory protection feature
Message-ID: <20210416161030.GC22348@zn.tnic>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
 <20210416154106.23721-3-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210416154106.23721-3-kirill.shutemov@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 16, 2021 at 06:40:55PM +0300, Kirill A. Shutemov wrote:
> Provide basic helpers, KVM_FEATURE, CPUID flag and a hypercall.
> 
> Host side doesn't provide the feature yet, so it is a dead code for now.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  arch/x86/include/asm/cpufeatures.h   |  1 +
>  arch/x86/include/asm/kvm_para.h      |  5 +++++
>  arch/x86/include/uapi/asm/kvm_para.h |  3 ++-
>  arch/x86/kernel/kvm.c                | 17 +++++++++++++++++
>  include/uapi/linux/kvm_para.h        |  3 ++-
>  5 files changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 84b887825f12..d8f3d2619913 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -238,6 +238,7 @@
>  #define X86_FEATURE_VMW_VMMCALL		( 8*32+19) /* "" VMware prefers VMMCALL hypercall instruction */
>  #define X86_FEATURE_SEV_ES		( 8*32+20) /* AMD Secure Encrypted Virtualization - Encrypted State */
>  #define X86_FEATURE_VM_PAGE_FLUSH	( 8*32+21) /* "" VM Page Flush MSR is supported */
> +#define X86_FEATURE_KVM_MEM_PROTECTED	( 8*32+22) /* "" KVM memory protection extension */

That feature bit is still unused.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
