Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8324FFB68
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 18:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236884AbiDMQiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 12:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235303AbiDMQha (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 12:37:30 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0899F31902
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 09:35:08 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id j17so2457463pfi.9
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 09:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5CEo552b6NXzHsMFOszFajVNNstxWGdOFCyGRD61lTc=;
        b=naYu/blHaWLlHXFfI7r1sh+XBfGamatLmPHRqvzLVo2KcOzqyaGkSgY+SnN2tCYQY5
         dnuN3MTkWU88yfKD1sFs0BAYeYM1ObLXmJjTzsbpk4SwVGHF91TvPaGmmpbnpu00udse
         4fx5EUWR3irR0rulV10rlwKEDJh9rsrC6NM0AdFmB3sDN6ksojPfI/w8ky8f4mRQ4pb3
         BuJkgrw3lM81alLxJ21T9eD7SWEsYnjPV6Lus71b21a2NScY4woFhdGzWoEZYXzxEuCv
         wXf4KlGJ07W8/7tnF0tuF3bPtyF509KUI4GPlpD2uYu3c2SpzvuXgJXb/SZRotNaUHPr
         BFFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5CEo552b6NXzHsMFOszFajVNNstxWGdOFCyGRD61lTc=;
        b=pu6K6kDZNJkmnW1ti+29pjC2KgibVxohYu0eCD6vD0rOghpPJJEDLCOqAQ1YQY4HaL
         H6B/MdHcYU452FOcyWBW2+Ks7Q2dIeFT9Eu9iO6sLkC100ZNmn/0uTwoyrFeh7/hsn7P
         tfJpT/enXpkOPKz2VnpCA6LIlZRJHrvXxTwbn/M7gyKmaGeS88NtJ23IVljKyXuYYfk6
         4dXftJweptH5yoznTSpV0XzmKYhbFstSpNzGmGjck2EhjXX8QF7gpuk/elUvI2jzJZmG
         VUMuxFux/xO3tImqa9OCoNHfm1lk/qXICB+lSZggFqBZCOddVeXJ8XozuZL1h6mXrWVL
         +FPw==
X-Gm-Message-State: AOAM530aIANK/GTwTYxZLYo6ytNb+KLuovOCw1AgAQol3g0dk26Yfjt2
        7QW3FEZWXS64XhYMiJezIctF7A==
X-Google-Smtp-Source: ABdhPJxRv5NNfHDVNnjd1w2KlWa6TOGH28FypbxMZXrNLe2XtpuF1LbzYRgG8kis32RCIunu4yrHWw==
X-Received: by 2002:a63:4516:0:b0:39d:98c8:b5cc with SMTP id s22-20020a634516000000b0039d98c8b5ccmr7420810pga.366.1649867707260;
        Wed, 13 Apr 2022 09:35:07 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k4-20020a17090a3e8400b001cd37f6c0b7sm3458218pjc.46.2022.04.13.09.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 09:35:06 -0700 (PDT)
Date:   Wed, 13 Apr 2022 16:35:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 03/10] x86: desc: Split IDT entry setup
 into a generic helper
Message-ID: <Ylb7tpWVIBcAFrw0@google.com>
References: <20220412173407.13637-1-varad.gautam@suse.com>
 <20220412173407.13637-4-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412173407.13637-4-varad.gautam@suse.com>
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
> EFI bootstrapping code configures a call gate in a later commit to jump
> from 16-bit to 32-bit code.
> 
> Introduce a set_idt_entry_t() routine which can be used to fill both
> an interrupt descriptor and a call gate descriptor on x86.
> 
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  lib/x86/desc.c | 28 ++++++++++++++++++++++------
>  lib/x86/desc.h |  1 +
>  2 files changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/x86/desc.c b/lib/x86/desc.c
> index 087e85c..049adeb 100644
> --- a/lib/x86/desc.c
> +++ b/lib/x86/desc.c
> @@ -57,22 +57,38 @@ __attribute__((regparm(1)))
>  #endif
>  void do_handle_exception(struct ex_regs *regs);
>  
> -void set_idt_entry(int vec, void *addr, int dpl)
> +/*
> + * Fill an idt_entry_t, clearing e_sz bytes first.
> + *
> + * This can also be used to set up x86 call gates, since the gate
> + * descriptor layout is identical to idt_entry_t, except for the
> + * absence of .offset2 and .reserved fields. To do so, pass in e_sz
> + * according to the gate descriptor size.
> + */
> +void set_idt_entry_t(idt_entry_t *e, size_t e_sz, void *addr,
> +		u16 sel, u16 type, u16 dpl)

The usage in patch 7, "Transition APs from 16-bit to 32-bit mode" is really confusing
because it's calling an IDT helper to setup the GDT.  Also, the "_t" postfix usually
indicates a typedef, not a function

Rather than set_idt_entry_t, maybe set_oversized_desc_entry()?  That's not very good
either, but it's at least not outright confusing.  Definitely open to other suggestions...

>  {
> -	idt_entry_t *e = &boot_idt[vec];
> -	memset(e, 0, sizeof *e);
> +	memset(e, 0, e_sz);
>  	e->offset0 = (unsigned long)addr;
> -	e->selector = read_cs();
> +	e->selector = sel;
>  	e->ist = 0;
> -	e->type = 14;
> +	e->type = type;
>  	e->dpl = dpl;
>  	e->p = 1;
>  	e->offset1 = (unsigned long)addr >> 16;
>  #ifdef __x86_64__
> -	e->offset2 = (unsigned long)addr >> 32;
> +	if (e_sz == sizeof(*e)) {
> +		e->offset2 = (unsigned long)addr >> 32;
> +	}
>  #endif
>  }
>  
> +void set_idt_entry(int vec, void *addr, int dpl)
> +{
> +	idt_entry_t *e = &boot_idt[vec];
> +	set_idt_entry_t(e, sizeof *e, addr, read_cs(), 14, dpl);
> +}
> +
>  void set_idt_dpl(int vec, u16 dpl)
>  {
>  	idt_entry_t *e = &boot_idt[vec];
> diff --git a/lib/x86/desc.h b/lib/x86/desc.h
> index 3044409..ae0928f 100644
> --- a/lib/x86/desc.h
> +++ b/lib/x86/desc.h
> @@ -217,6 +217,7 @@ unsigned exception_vector(void);
>  int write_cr4_checking(unsigned long val);
>  unsigned exception_error_code(void);
>  bool exception_rflags_rf(void);
> +void set_idt_entry_t(idt_entry_t *e, size_t e_sz, void *addr, u16 sel, u16 type, u16 dpl);
>  void set_idt_entry(int vec, void *addr, int dpl);
>  void set_idt_sel(int vec, u16 sel);
>  void set_idt_dpl(int vec, u16 dpl);
> -- 
> 2.32.0
> 
