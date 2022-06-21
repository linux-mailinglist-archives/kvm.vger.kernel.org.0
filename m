Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5E3553819
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 18:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353362AbiFUQki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 12:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352267AbiFUQka (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 12:40:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA1962A41D
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 09:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655829624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mw7ZffdffuzSEpMbDJcTsX2mwbZPEKH73O8nnPbDnHs=;
        b=U8SPufhGCk4/8zfZgrFzDQ5SIhWHF6McALR3XgLo9hducPLr/MjFiaOW+6Od5ngUo4Wciu
        ux+mdiLzmp3H0IQF9MIzzmh2a8sSw37wHmYzq/GvSCLJcjw+qxBkvI/6z5jEurZN5E6Fmn
        RdtwJEv1QtoVijCGOpSywJR+y60flPg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-464-35Q8To5qNHaoBFndH8Xsgw-1; Tue, 21 Jun 2022 12:40:22 -0400
X-MC-Unique: 35Q8To5qNHaoBFndH8Xsgw-1
Received: by mail-wm1-f72.google.com with SMTP id m22-20020a7bcb96000000b0039c4f6ade4dso4486520wmi.8
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 09:40:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mw7ZffdffuzSEpMbDJcTsX2mwbZPEKH73O8nnPbDnHs=;
        b=q0WlODB5+s9dgaFn5+I2TogZpQcW5hEkaKVSS+r57V4gcNlxwA/u+hgNdxInhdLpoK
         xs4TOs/rdL8mkQLsPncHFhdPoNc3puOhERAIl3AimHLVpD3f2je75bIoBkt+yLor/bSO
         kFWLy0jdVGJq8SgtkcSNlvyVvR4O7PMogB1OIwAUT0DtUbO5JVn7JS70cRAClQA/ZSS0
         Ex/BdTMI/BVLICpEbOibyuptBmbhjDoSW7zgYklkg0H8Nv+WnQ6GL3LafM+PKAiqsUpE
         4z9heNgu80Qjat2/WNDcdqnR7dRyfcnJOVIpJpSNJJw0fQCiRFj6yPjwskcAg71dbPOi
         pQCg==
X-Gm-Message-State: AJIora/JiHdFfOWSoG+MADP/yuOIj7S609dN/t5B2z3L8mPu1pLN5Zq3
        tk5eh6IJ55qmcP9oG6lGd1gYWQUXgNGyE8D0IbzvaYmk5UKdDNbqYav+3IoqmOGaZ/lKDEIYilT
        KC4a1lplnl/pr
X-Received: by 2002:a05:6000:1867:b0:218:5c3b:1a41 with SMTP id d7-20020a056000186700b002185c3b1a41mr29948130wri.88.1655829621633;
        Tue, 21 Jun 2022 09:40:21 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uZ+C2JsjY3zJFhFb5Lae8TkvhpL7JjVU/zwrcqUtnJgpOs1Qo69z93UHzHQ72LKje6dBq3ww==
X-Received: by 2002:a05:6000:1867:b0:218:5c3b:1a41 with SMTP id d7-20020a056000186700b002185c3b1a41mr29948093wri.88.1655829621342;
        Tue, 21 Jun 2022 09:40:21 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id y14-20020a1c4b0e000000b0039c95b31812sm18550896wma.31.2022.06.21.09.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 09:40:20 -0700 (PDT)
Date:   Tue, 21 Jun 2022 17:40:17 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, michael.roth@amd.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 06/49] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
Message-ID: <YrH0ca3Sam7Ru11c@work-vm>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <e4643e9d37fcb025d0aec9080feefaae5e9245d5.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4643e9d37fcb025d0aec9080feefaae5e9245d5.1655761627.git.ashish.kalra@amd.com>
User-Agent: Mutt/2.2.5 (2022-05-16)
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Ashish Kalra (Ashish.Kalra@amd.com) wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
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
> index cb16f0e5b585..6ab872311544 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -85,7 +85,9 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
>  
>  /* RMP page size */
>  #define RMP_PG_SIZE_4K			0
> +#define RMP_PG_SIZE_2M			1
>  #define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
> +#define X86_TO_RMP_PG_LEVEL(level)	(((level) == PG_LEVEL_4K) ? RMP_PG_SIZE_4K : RMP_PG_SIZE_2M)
>  
>  /*
>   * The RMP entry format is not architectural. The format is defined in PPR
> @@ -126,6 +128,15 @@ struct snp_guest_platform_data {
>  	u64 secrets_gpa;
>  };
>  
> +struct rmpupdate {
> +	u64 gpa;
> +	u8 assigned;
> +	u8 pagesize;
> +	u8 immutable;
> +	u8 rsvd;
> +	u32 asid;
> +} __packed;

I see above it says the RMP entry format isn't architectural; is this
'rmpupdate' structure? If not how is this going to get handled when we
have a couple of SNP capable CPUs with different layouts?

Dave

>  #ifdef CONFIG_AMD_MEM_ENCRYPT
>  extern struct static_key_false sev_es_enable_key;
>  extern void __sev_es_ist_enter(struct pt_regs *regs);
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index 59e7ec6b0326..f6c64a722e94 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -2429,3 +2429,75 @@ int snp_lookup_rmpentry(u64 pfn, int *level)
>  	return !!rmpentry_assigned(e);
>  }
>  EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
> +
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
> +
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
> +
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
> -- 
> 2.25.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

