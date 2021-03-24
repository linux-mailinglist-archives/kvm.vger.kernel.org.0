Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA935347FC1
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237281AbhCXRsH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237207AbhCXRro (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:47:44 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE8AC061763
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 10:47:43 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id u9so34300095ejj.7
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 10:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TwICohQDmNlHACww9Px62AaQdCz/JWNO8WU4gTx6NmU=;
        b=krUJcfrBhdcGEBsn5aqX/MR8lqOeTw5agdZMqXxibmOZu7vtwTzVoBlXaLSGDKh/bu
         ds243PYymxqBBkeFxsmYXk7cIKVn1SUKgv/VvHtFuD/c6ibiJwBpsb3rO7BwUCQtbx6z
         4NiLV73RydSj9jih+GZ9W8VMYy2IDB4BszZ6OD7LOJInVxlGWFfJpqsEwNsvhwSxoQZc
         Wezay2YHFqHuIgUih+AUR7DL/MCY+ZiY+RUfNyhBaAyOyFiXrbWPVroXCc5HLGcmg+sz
         mVTDsvVUX3RQI3rccYZ95nAxt8Ib58utJBiVHnfqvX/NE1Dl66f0D80DUs7lpaUyhCcU
         fMZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TwICohQDmNlHACww9Px62AaQdCz/JWNO8WU4gTx6NmU=;
        b=BiMC7ypRA1AUYCxyBmY+foYHlN/taF/iMAVlVk3BV47/Ncdr7QD99EQeGijw06gTCh
         o6bQIuJOeN+en6QGhuE1khsczCOwWG4jGs7htJihMazn00lRcEFuovco8YtMMBUZ/ETf
         c4rVm2bj4TCzpGujB/KeN6lQaa0gFijvBnVryiL9w0+lSijxodsmj5eTdTZtzEihfmny
         EZNVw85dt+lB5o35DP8Hqc9gzxe+Hr6zxkc6esrywIRsL3JK3+cyVCak00uEXevQfAbU
         MV7HqtxS5QJstI1WJ7p08P7q1zeqYaRX5d7xRuFIJVKCejjK8Z1PNRWlxobLYpQSEAiA
         l0gQ==
X-Gm-Message-State: AOAM531MYM8Gv9K0dOPn3EJqI5Bv7DKQ+m8MG8nfH8fRt6MIMhWgKepP
        xZVLJymRRgpixrbpjEaZhdkHekOyyzPLXiue6Zke2g==
X-Google-Smtp-Source: ABdhPJxVAyjvlgOpfOQd4oDsp/FOi1l7mgLH+yycDBxpL2Hwm7JCCiXciqd8rMVwmSe56RwHUwiQDAD0P46rC7JOGlk=
X-Received: by 2002:a17:906:7e12:: with SMTP id e18mr5209337ejr.316.1616608061647;
 Wed, 24 Mar 2021 10:47:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210324170436.31843-1-brijesh.singh@amd.com> <20210324170436.31843-7-brijesh.singh@amd.com>
In-Reply-To: <20210324170436.31843-7-brijesh.singh@amd.com>
From:   Andy Lutomirski <luto@amacapital.net>
Date:   Wed, 24 Mar 2021 10:47:30 -0700
Message-ID: <CALCETrWH4uPUQHSwgwz5PS8XngJyvjxgWZ85EV5s7VGJX=aa_Q@mail.gmail.com>
Subject: Re: [RFC Part2 PATCH 06/30] x86/fault: dump the RMP entry on #PF
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021 at 10:04 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
> If hardware detects an RMP violation, it will raise a page-fault exception
> with the RMP bit set. To help the debug, dump the RMP entry of the faulting
> address.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/mm/fault.c | 75 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 75 insertions(+)
>
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index f39b551f89a6..7605e06a6dd9 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -31,6 +31,7 @@
>  #include <asm/pgtable_areas.h>         /* VMALLOC_START, ...           */
>  #include <asm/kvm_para.h>              /* kvm_handle_async_pf          */
>  #include <asm/vdso.h>                  /* fixup_vdso_exception()       */
> +#include <asm/sev-snp.h>               /* lookup_rmpentry ...          */
>
>  #define CREATE_TRACE_POINTS
>  #include <asm/trace/exceptions.h>
> @@ -147,6 +148,76 @@ is_prefetch(struct pt_regs *regs, unsigned long error_code, unsigned long addr)
>  DEFINE_SPINLOCK(pgd_lock);
>  LIST_HEAD(pgd_list);
>
> +static void dump_rmpentry(struct page *page, rmpentry_t *e)
> +{
> +       unsigned long paddr = page_to_pfn(page) << PAGE_SHIFT;
> +
> +       pr_alert("RMPEntry paddr 0x%lx [assigned=%d immutable=%d pagesize=%d gpa=0x%lx asid=%d "
> +               "vmsa=%d validated=%d]\n", paddr, rmpentry_assigned(e), rmpentry_immutable(e),
> +               rmpentry_pagesize(e), rmpentry_gpa(e), rmpentry_asid(e), rmpentry_vmsa(e),
> +               rmpentry_validated(e));
> +       pr_alert("RMPEntry paddr 0x%lx %016llx %016llx\n", paddr, e->high, e->low);
> +}
> +
> +static void show_rmpentry(unsigned long address)
> +{
> +       struct page *page = virt_to_page(address);

This is an error path, and I don't think you have any particular
guarantee that virt_to_page(address) is valid.  Please add appropriate
validation or use one of the slow lookup helpers.
