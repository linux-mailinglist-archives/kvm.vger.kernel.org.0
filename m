Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F54769D59F
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 22:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbjBTVNV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 16:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbjBTVNN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 16:13:13 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2E435B9;
        Mon, 20 Feb 2023 13:13:05 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id s22so3094665lfi.9;
        Mon, 20 Feb 2023 13:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676927584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TDIW4axl+hkN5j3NPMXP+ZPoJ29pdF3/fwwVKvtB5gk=;
        b=KE1OVRc+qlYS5auHFljuhewLrBtTVsN/HV2pvtiQwUrLF6eqwzmYRitRPsdm8PzCKP
         f94jSIuX7FTmGS11bxjT4AvvNxyrRqcYUiGEF4Ng3DhvV3zoLw5e9pxiCp4QQ8OrDhxX
         +IYExd0hsXsaDOmT+Huu4SvNvPABnALW1IS0k8plNRR4mfpDqb94BaZcW6HC6enQPONQ
         1emTmsmu6j96DIDwBRU9vHZSilWZTAUV76IdLSvjlWCEwuOHk3swIZ9ku21QyrPbomhK
         StQA/UBsTxKBtZ+RXC4bCF9FuQXIXP0dNTDB6/L1AxVvsISpEQu6VSEPEOdLzBthSfmK
         X9Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676927584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TDIW4axl+hkN5j3NPMXP+ZPoJ29pdF3/fwwVKvtB5gk=;
        b=kj33gVFBgj1olMBLVC97fcAiacipcH3PL/W5vpeJUWdZqDG2jHIAvYiuYjafCZAhLt
         AV1wdj44hyhig1+aQOPtCwfOdn/qAfeHHT5vMbMbWCx+r0Pa1YVXMWXiY0VEyI1uroNN
         dupmOTh/aCJxX0qcyE00gQJiYqL7Rxo4Mx+orelfhlD1FKhg71OtURe/Qh7OY2gtv+t7
         OdbNWssDTRQ7T7GogcxcopBJE6tHDSQ18rUodJZ0rt+GQRGqYNEQ3Iy0FCeGin/j9H0j
         BNLv88LVggpm/lYOayNe9bsrtIYvdKvEj608lC+OoMiEyhoxhKSIgv8M4Y7lnWQC3WAr
         Q93w==
X-Gm-Message-State: AO0yUKWwT0CfwXrEgfQOcKcC8BbElmVwuG8eda0c+tMzprD3TZoms0EQ
        AmYvDYT1q5hleiR+rjpTxXY=
X-Google-Smtp-Source: AK7set+SFmQKGMJwRWrnol+bh+JAzBSaJAJIcs3b4nUG3o31URK0ZZcsUT7nvy2Smugv5Xzpba5R+g==
X-Received: by 2002:a19:f00e:0:b0:4a4:68b9:26c with SMTP id p14-20020a19f00e000000b004a468b9026cmr795903lfc.6.1676927583594;
        Mon, 20 Feb 2023 13:13:03 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id u10-20020ac248aa000000b004dc4cb4f9c4sm1625853lfg.35.2023.02.20.13.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 13:13:03 -0800 (PST)
Date:   Mon, 20 Feb 2023 23:13:00 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>
Subject: Re: [PATCH RFC v8 19/56] x86/fault: Return pfn from
 dump_pagetable() for SEV-specific fault handling.
Message-ID: <20230220231300.00004591@gmail.com>
In-Reply-To: <20230220183847.59159-20-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-20-michael.roth@amd.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Feb 2023 12:38:10 -0600
Michael Roth <michael.roth@amd.com> wrote:

> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Return pfn from dump_pagetable() to do SEV-specific
> fault handling. Used for handling SNP RMP page fault.
> 

It would be better to merge this patch with PATCH 13.

> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/mm/fault.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index afd4cde17001..f2b16dcfbd9a 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -311,7 +311,7 @@ static bool low_pfn(unsigned long pfn)
>  	return pfn < max_low_pfn;
>  }
>  
> -static void dump_pagetable(unsigned long address)
> +static unsigned long dump_pagetable(unsigned long address)
>  {
>  	pgd_t *base = __va(read_cr3_pa());
>  	pgd_t *pgd = &base[pgd_index(address)];
> @@ -345,8 +345,10 @@ static void dump_pagetable(unsigned long address)
>  
>  	pte = pte_offset_kernel(pmd, address);
>  	pr_cont("*pte = %0*Lx ", sizeof(*pte) * 2, (u64)pte_val(*pte));
> +	return 0;
>  out:
>  	pr_cont("\n");
> +	return 0;
>  }
>  
>  #else /* CONFIG_X86_64: */
> @@ -367,10 +369,11 @@ static int bad_address(void *p)
>  	return get_kernel_nofault(dummy, (unsigned long *)p);
>  }
>  
> -static void dump_pagetable(unsigned long address)
> +static unsigned long dump_pagetable(unsigned long address)
>  {
>  	pgd_t *base = __va(read_cr3_pa());
>  	pgd_t *pgd = base + pgd_index(address);
> +	unsigned long pfn;
>  	p4d_t *p4d;
>  	pud_t *pud;
>  	pmd_t *pmd;
> @@ -388,6 +391,7 @@ static void dump_pagetable(unsigned long address)
>  	if (bad_address(p4d))
>  		goto bad;
>  
> +	pfn = p4d_pfn(*p4d);
>  	pr_cont("P4D %lx ", p4d_val(*p4d));
>  	if (!p4d_present(*p4d) || p4d_large(*p4d))
>  		goto out;
> @@ -396,6 +400,7 @@ static void dump_pagetable(unsigned long address)
>  	if (bad_address(pud))
>  		goto bad;
>  
> +	pfn = pud_pfn(*pud);
>  	pr_cont("PUD %lx ", pud_val(*pud));
>  	if (!pud_present(*pud) || pud_large(*pud))
>  		goto out;
> @@ -404,6 +409,7 @@ static void dump_pagetable(unsigned long address)
>  	if (bad_address(pmd))
>  		goto bad;
>  
> +	pfn = pmd_pfn(*pmd);
>  	pr_cont("PMD %lx ", pmd_val(*pmd));
>  	if (!pmd_present(*pmd) || pmd_large(*pmd))
>  		goto out;
> @@ -412,13 +418,14 @@ static void dump_pagetable(unsigned long address)
>  	if (bad_address(pte))
>  		goto bad;
>  
> +	pfn = pte_pfn(*pte);
>  	pr_cont("PTE %lx", pte_val(*pte));
>  out:
>  	pr_cont("\n");
> -
> -	return;
> +	return pfn;
>  bad:
>  	pr_info("BAD\n");
> +	return -1;
>  }
>  
>  #endif /* CONFIG_X86_64 */

