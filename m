Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5B54FFE16
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 20:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236392AbiDMSqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 14:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233329AbiDMSqc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 14:46:32 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42DB457B5
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 11:44:08 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id y6so2711539plg.2
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 11:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jZ9jhvujWYeiIc2IyEfT8qkFks6uTSuot3E6q3dQUw4=;
        b=Y2LdkwmVD/mYtdw98AvBlJEe4Eqd9PMWbNN5XdL+gKZtW1FpRvF5jl/ctKkvY05FV+
         yhspEx8nbF3GrxM4XXRAZb8otDEysrB96rU3PZDOGectFij+bRdiFqalP1SSDD9/m45w
         66o69X45hLduFujzjpKs7c+B8adFYARq4dac7JVrBMfEH7VKZvM1aMXDfqYk06w8OpIj
         8rtF7UAQYHecIZnWEU8tzw3I6KhlbqqONdSTcEvXCsALHdILcjuVIYsb7+Y5kk8p1+ml
         WTxafmek4K0lNvnnvvqQTtRZmNWMAb4J/Qo+rORhHZ1qsKUQDZxD2V2MHd4jsWL7Ivx4
         dh7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jZ9jhvujWYeiIc2IyEfT8qkFks6uTSuot3E6q3dQUw4=;
        b=DDLXvxf9Lr0meDyt/ZGT2cNuuUh9CYaCGslCPmKrXY+zuzknc2FbkdB2jyPxc6hHaD
         K+I86kqMQ/FwymuF2594ty7FwVo+UhgNGOGUVJri2YhuvKhzj19mveFUmZrBBJOAmfJY
         f+yDju0m4Pj7x3T4zdvsQLmIl1iCwMmf8rrUMmvaiE5/FwGi1DpR3x4lRNEt0AQbt+ID
         HHmd2UUwXyGU5XWdouNVlWxgN25h/hxBcU7kL5Uu967AD0h6YU9GJGnuQp+zAu/kwZ4E
         mJwI5Llg5s0PmVscQ/6p8Ugme0QTToE7qIO0kFZvc3PnoS43Fy7rdNQt49kj43SYDW/O
         qt+w==
X-Gm-Message-State: AOAM533F/c0GgZb1XiYaMjV9KfAWhhFMePJvl8MtvdJRA/4V7ZCYHNBO
        oV0uEfQF5U6CGk5QZsazp6SugQ==
X-Google-Smtp-Source: ABdhPJxTmKI6YlZog+uWJIh2GVXLzQExtx7MFfvKoYrGFMfAkhOqsa924g2F8/L/P8ytN+qqq6Qbjw==
X-Received: by 2002:a17:903:240f:b0:158:b871:33ac with SMTP id e15-20020a170903240f00b00158b87133acmr3530plo.135.1649875448050;
        Wed, 13 Apr 2022 11:44:08 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h18-20020a63c012000000b0039cc3c323f7sm6598260pgg.33.2022.04.13.11.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 11:44:07 -0700 (PDT)
Date:   Wed, 13 Apr 2022 18:44:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 01/10] x86: Move ap_init() to smp.c
Message-ID: <YlcZ83yz9eoBjmEt@google.com>
References: <20220412173407.13637-1-varad.gautam@suse.com>
 <20220412173407.13637-2-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412173407.13637-2-varad.gautam@suse.com>
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
> @@ -142,3 +143,26 @@ void smp_reset_apic(void)
>  
>  	atomic_inc(&active_cpus);
>  }
> +
> +void ap_init(void)
> +{
> +	u8 *dst_addr = 0;

Oof, this is subtle.  I didn't realize until patch 7 that this is actually using
va=pa=0 for the trampoline.

Does anything actually prevent KUT from allocating pa=0?  Ah, looks like __setup_vm()
excludes the lower 1mb.

'0' should be a #define somewhere, e.g. EFI_RM_TRAMPOLINE_PHYS_ADDR, probably in
lib/alloc_page.h next to AREA_ANY_NUMBER with a comment tying the two together.
And then patch 7 can (hopefully without too much pain) use the define instead of
open coding the reference to PA=0, which is really confusing and unnecessarily
fragile.

E.g. instead of

	/* Retrieve relocated gdt32_descr address at (PAGE_SIZE - 2). */
	mov (PAGE_SIZE - 2), %ebx

hopefully it can be

	mov (EFI_RM_TRAMPOLINE_PHYS_ADDR + PAGE_SIZE - 2), %ebx

> +	size_t sipi_sz = (&sipi_end - &sipi_entry) + 1;

Nit, maybe sipi_trampoline_size?

> +	asm volatile("cld");
> +
> +	/* Relocate SIPI vector to dst_addr so it can run in 16-bit mode. */
> +	memcpy(dst_addr, &sipi_entry, sipi_sz);

A more descriptive name than dst_addr would help, and I'm pretty sure it can be
a void *.  Maybe?

	void *rm_trampoline = EFI_RM_TRAMPOLINE_PHYS_ADDR?

And rather than add the assert+memset in patch 7, do that here.  Oh, and fill
the page with 0xcc, i.e. int3, instead of 0, so that if an AP wanders into the
weeds, it gets a fault and shutdown.  All zeros decodes to ADD [rax], rax (or maybe
the reverse?), i.e. isn't guaranteed to fail right away.

	assert(sipi_trampoline_size < PAGE_SIZE);

	/* Comment goes here about filling with 0xcc. */
	memset(rm_trampoline, 0xcc, PAGE_SIZE);
	memcpy(rm_trampoline, &sipi_entry, sipi_trampoline_size);
