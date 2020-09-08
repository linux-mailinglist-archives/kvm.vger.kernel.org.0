Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5C22616E3
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 19:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731785AbgIHRVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 13:21:42 -0400
Received: from mail.skyhub.de ([5.9.137.197]:58316 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727940AbgIHRUw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 13:20:52 -0400
Received: from zn.tnic (p200300ec2f10bf0070b09dfd4356f225.dip0.t-ipconnect.de [IPv6:2003:ec:2f10:bf00:70b0:9dfd:4356:f225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6016C1EC0493;
        Tue,  8 Sep 2020 19:20:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1599585648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=LmUlHAGcDfQUhA9DUzYK7oqYD6W3gPvxbkj2WBXLliI=;
        b=NT+D1hisw4b0wW+6D7Ney6pv8pqgOWkQiIpZMVJFpu03DYUr3koV1ACECWUSItIFaW0klI
        6lQvPBJz1xfNqiAypVEEPioZLzJhxPHQWnPMBFkqcSx5eFSdpW4Hse7mx++L7Y6j3zJfOv
        V2b1QESn48gtV8CN2wkTeDHRDEKrGvo=
Date:   Tue, 8 Sep 2020 19:20:42 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v7 67/72] x86/smpboot: Load TSS and getcpu GDT entry
 before loading IDT
Message-ID: <20200908172042.GF25236@zn.tnic>
References: <20200907131613.12703-1-joro@8bytes.org>
 <20200907131613.12703-68-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200907131613.12703-68-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 07, 2020 at 03:16:08PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> The IDT on 64bit contains vectors which use paranoid_entry() and/or IST
> stacks. To make these vectors work the TSS and the getcpu GDT entry need
> to be set up before the IDT is loaded.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/include/asm/processor.h |  1 +
>  arch/x86/kernel/cpu/common.c     | 23 +++++++++++++++++++++++
>  arch/x86/kernel/smpboot.c        |  2 +-
>  3 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index d8a82e650810..5ac507586769 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -696,6 +696,7 @@ extern void load_direct_gdt(int);
>  extern void load_fixmap_gdt(int);
>  extern void load_percpu_segment(int);
>  extern void cpu_init(void);
> +extern void cpu_init_exception_handling(void);
>  extern void cr4_init(void);
>  
>  static inline unsigned long get_debugctlmsr(void)
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 1d65365363a1..a9527c0c38fb 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1854,6 +1854,29 @@ static inline void tss_setup_io_bitmap(struct tss_struct *tss)
>  #endif
>  }
>  
> +/*
> + * Setup everything needed to handle exceptions from the IDT, including the IST
> + * exceptions which use paranoid_entry()
> + */
> +void cpu_init_exception_handling(void)
> +{
> +	struct tss_struct *tss = this_cpu_ptr(&cpu_tss_rw);
> +	int cpu = raw_smp_processor_id();
> +
> +	/* paranoid_entry() gets the CPU number from the GDT */
> +	setup_getcpu(cpu);
> +
> +	/* IST vectors need TSS to be set up. */
> +	tss_setup_ist(tss);
> +	tss_setup_io_bitmap(tss);
> +	set_tss_desc(cpu, &get_cpu_entry_area(cpu)->tss.x86_tss);
> +
> +	load_TR_desc();

Aha, this is what you mean here in your 0th message. I'm guessing it is
ok to do those things twice in start_secondary...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
