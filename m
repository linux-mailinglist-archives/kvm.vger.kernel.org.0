Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A70A4FFAC8
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 17:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbiDMQAk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 12:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbiDMQAi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 12:00:38 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00E26579A
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 08:58:16 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 2so2462206pjw.2
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 08:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4bTyFfuYg117mHrOPjFdcRKmF73DZFgwO9XOIh2i8I8=;
        b=F/y/0Y4YsM1LXqqX95uamfPxjNaztl3m6b/hnNEt0V9inxXgwJUWo0kcDf3h+57Phj
         6/eUYw6UWms3qnrK/kPb5mf1eGnUxJIes275Flgt9DBrBgTk0x7ceLHcAbWVzTgzeos6
         t2BRe7jXFwc/1iOi+x4tiOGjWYBSupPRoTGzShaLORid5zP9plJoaNH+p+VRy2dHlpDj
         u70eM282nPewF+HLoC00rH9ixZLHFAS8XKhxQcNAZRdTOKEbJVQf0Ebz8hicJpY75gPR
         qPHz6QIkNY03lIojOD3m7ntpJiBsNKziDp6dmPY+dION/p/eVHHwD0jdmx6LzDed6B7K
         EZqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4bTyFfuYg117mHrOPjFdcRKmF73DZFgwO9XOIh2i8I8=;
        b=DEB3VlOv92gcJthDmnX/wgI8ZQMTeLw6Ao6+Q61zv7AtcucmMP6rcbCiiT1engCrR/
         gA1lhvXkCyczV4wSqTiPXhWFVoMt3AsvRjjMNTiguH32SJjJrA4QiWUy4cZ3J9NdtSGI
         jyAbkmZnLW0XZ/HAZv+iZuknyOf5iwi62KDKqv4eQKRHf+OvL3Xcgo0vQtbwIkzHxSjR
         hLPlVMDsAy4uo0M6qchCxihV1vD21ntF6cSXkMhjs5GRu3yDjXh5OCnH2YmoL3L6KxRQ
         hyyhEMu8EBztS5Vu7PgySlQalo9jLGkok18WMxfH4R1I9eG9phsSD8fBAyz2Hqim7XmG
         1mjA==
X-Gm-Message-State: AOAM530V/GFdRKKhi9/pnXMi9Lcr5Axo+2bhpFfOqDfrlg5TKoTKnENM
        /R4FmBgzLTzHlmqSSJpE6nDkpA==
X-Google-Smtp-Source: ABdhPJym39oT3Qt01/V1VZ/ABoryL7M3GYo6DbDdyAvkrIq3WIxV2y2dWDMGmckvg6oBmty1LFgPig==
X-Received: by 2002:a17:90b:350e:b0:1c6:cd4e:303a with SMTP id ls14-20020a17090b350e00b001c6cd4e303amr11527479pjb.141.1649865496255;
        Wed, 13 Apr 2022 08:58:16 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b4-20020a17090a550400b001ca38abb248sm3391730pji.53.2022.04.13.08.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 08:58:15 -0700 (PDT)
Date:   Wed, 13 Apr 2022 15:58:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 04/10] x86: Move load_gdt_tss() to
 desc.c
Message-ID: <YlbzE5tlrgfeYez8@google.com>
References: <20220412173407.13637-1-varad.gautam@suse.com>
 <20220412173407.13637-5-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412173407.13637-5-varad.gautam@suse.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022, Varad Gautam wrote:
> diff --git a/lib/x86/setup.c b/lib/x86/setup.c
> index 94e9f86..7dd6677 100644
> --- a/lib/x86/setup.c
> +++ b/lib/x86/setup.c
> @@ -170,7 +170,7 @@ void setup_multiboot(struct mbi_bootinfo *bi)
>  #ifdef CONFIG_EFI
>  
>  /* From x86/efi/efistart64.S */
> -extern void load_gdt_tss(size_t tss_offset);
> +extern void setup_segments64(void);
>  
>  static efi_status_t setup_memory_allocator(efi_bootinfo_t *efi_bootinfo)
>  {
> @@ -275,6 +275,8 @@ static void setup_gdt_tss(void)
>  	/* 64-bit setup_tss does not use the stacktop argument.  */
>  	tss_offset = setup_tss(NULL);
>  	load_gdt_tss(tss_offset);
> +
> +	setup_segments64();

Rather than call back into asm, how about doing this in inline asm?  It's a bit
gross no matter what, but this has the advantage of getting to use KERNEL_CS/DS
without extra magic.

And then the future patch that manipulates MSR_GS_BASE can use the wrmsr() helper.

	asm volatile("mov %0, %%ds\n\t"
		     "mov %0, %%es\n\t"
		     "mov %0, %%fs\n\t"
		     "mov %0, %%gs\n\t"
		     "mov %0, %%ss\n\t"
		     "pushq %1\n\t"
		     "lea 1f(%%rip), %0\n\t"
		     "pushq %0\n\t"
		     "lretq\n\t"
		     "1:"
		     :: "r" ((u64)KERNEL_DS), "i" (KERNEL_CS)
	);


>  efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
> diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
> index ea3d1c0..8eadca5 100644
> --- a/x86/efi/efistart64.S
> +++ b/x86/efi/efistart64.S
> @@ -26,15 +26,8 @@ ptl4:
>  .code64
>  .text
>  
> -.globl load_gdt_tss
> -load_gdt_tss:
> -	/* Load GDT */
> -	lgdt gdt_descr(%rip)
> -
> -	/* Load TSS */
> -	mov %rdi, %rax
> -	ltr %ax
> -
> +.globl setup_segments64
> +setup_segments64:
>  	/* Update data segments */
>  	mov $0x10, %ax /* 3rd entry in gdt64: 32/64-bit data segment */
>  	mov %ax, %ds
> -- 
> 2.32.0
> 
