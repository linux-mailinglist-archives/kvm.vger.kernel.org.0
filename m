Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534C7584269
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 16:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiG1O6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 10:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbiG1O5o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 10:57:44 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26C96AA0F
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 07:56:55 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id z19so2031363plb.1
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 07:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IE9HJ/QB34gIaoVfeAMT+Lysq4a4pjkYfZrZPAIzbsM=;
        b=RXTHZFRSPzp68kD724m5hsf+h9LtUEHJnmncEI+XoFM3zKXOvGbuUcMNHL7XGgFBAc
         iiIYHrNSQAOXKsuaxXf6NQ295QaBAwFreKJlS/XP8KudogteskdpNKxm3cSavhkIe6ja
         fymhfAygy+H7mP4QKCHAI0TXGkfJcxKeSsM/2srtvZHtBU52GVLEciyL/1cnLLLa/guD
         vM4SQQsM89mlD/gf0Rw4UGb4b1TypUkRGfCm16zj0mgmcFOrozxTtVDXLltzwtwdv0YD
         1j6gK3vJUkoI8EgGPoCV7ENnokfEIOPU/UQkVEHNBbUBciaFb0SSkhgQERl3LHuNNmAN
         5yew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IE9HJ/QB34gIaoVfeAMT+Lysq4a4pjkYfZrZPAIzbsM=;
        b=NJkEkecmOQ2SDEO2SgdigAuZgCA+llExNST11rKgK0rZdIJr3XxyagadaAwe35GPhR
         1TGqU4n1xTRe1rulI9ljWqH9Jg4zBSOVo4B/6p5521h/ogD8r/Sg5/FwFyIPe9QfpJgw
         9vU1ynEJyy1VFoZ8IRconemtXF9KgQPY4ZGUx4D3GjWBK9YLFz1AXn3/Q+T4Ms4eKF3a
         6CZy+ZDTUEJH1ty+UBKmD1F0zrWGrGzYS/RgJmmbLXzyG3/dZh2F7qZWs5UleBqIFPts
         t/f91jYuttoadbVOf+NyHgpaXIk7tkDyi09ibfXF4ogHD4D2nhnfD/wKTNC4YnqYpRVq
         faqw==
X-Gm-Message-State: AJIora913sOhJ1ukitv9ohbY3TBNT/tltpgvNJOnLXwJj7D62snsRNrH
        3MPu+0pGMpHAIipupTELSTtvgA==
X-Google-Smtp-Source: AGRyM1uTsDdDBG61hWpxX10KUtjI5qqB2K1VibyIddhNEL7eC66FtNpaFPjMeUkIbxIvplNZrvb1aQ==
X-Received: by 2002:a17:90b:1c0b:b0:1f0:23df:5406 with SMTP id oc11-20020a17090b1c0b00b001f023df5406mr10853910pjb.157.1659020214919;
        Thu, 28 Jul 2022 07:56:54 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902a3cc00b0016397da033csm1437740plb.62.2022.07.28.07.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 07:56:54 -0700 (PDT)
Date:   Thu, 28 Jul 2022 14:56:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: Possible 5.19 regression for systems with 52-bit physical
 address support
Message-ID: <YuKjsuyM7+Gbr2nw@google.com>
References: <20220728134430.ulykdplp6fxgkyiw@amd.com>
 <20220728135320.6u7rmejkuqhy4mhr@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728135320.6u7rmejkuqhy4mhr@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 28, 2022, Michael Roth wrote:
> On Thu, Jul 28, 2022 at 08:44:30AM -0500, Michael Roth wrote:
> > Hi Sean,
> > 
> > With this patch applied, AMD processors that support 52-bit physical
> 
> Sorry, threading got messed up. This is in reference to:
> 
> https://lore.kernel.org/lkml/20220420002747.3287931-1-seanjc@google.com/#r
> 
> commit 8b9e74bfbf8c7020498a9ea600bd4c0f1915134d
> Author: Sean Christopherson <seanjc@google.com>
> Date:   Wed Apr 20 00:27:47 2022 +0000
> 
>     KVM: x86/mmu: Use enable_mmio_caching to track if MMIO caching is enabled

Oh crud.  I suspect I also broke EPT with MAXPHYADDR=52; the initial
kvm_mmu_reset_all_pte_masks() will clear the flag, and it won't get set back to
true even though EPT can generate a reserved bit fault.

> > address will result in MMIO caching being disabled. This ends up
> > breaking SEV-ES and SNP, since they rely on the MMIO reserved bit to
> > generate the appropriate NAE MMIO exit event.
> >
> > This failure can also be reproduced on Milan by disabling mmio_caching
> > via KVM module parameter.

Hrm, this is a separate bug of sorts.  SEV-ES (and later) needs to have an explicit
check the MMIO caching is enabled, e.g. my bug aside, if KVM can't use MMIO caching
due to the location of the C-bit, then SEV-ES must be disabled.

Speaking of which, what prevents hardware (firmware?) from configuring the C-bit
position to be bit 51 and thus preventing KVM from generating the reserved #NPF?

> > In the case of AMD, guests use a separate physical address range that
> > and so there are still reserved bits available to make use of the MMIO
> > caching. This adjustment happens in svm_adjust_mmio_mask(), but since
> > mmio_caching_enabled flag is 0, any attempts to update masks get
> > ignored by kvm_mmu_set_mmio_spte_mask().
> > 
> > Would adding 'force' parameter to kvm_mmu_set_mmio_spte_mask() that
> > svm_adjust_mmio_mask() can set to ignore enable_mmio_caching be
> > reasonable fix, or should we take a different approach?

Different approach.  To fix the bug with enable_mmio_caching not being set back to
true when a vendor-specific mask allows caching, I believe the below will do the
trick.

The SEV-ES dependency is easy to solve, but will require a few patches in order
to get the necessary ordering; svm_adjust_mmio_mask() is currently called _after_
SEV-ES is configured.

I'll test (as much as I can, I don't think we have platforms with MAXPHYADDR=52)
and get a series sent out later today.

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 7314d27d57a4..a57add994b8d 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -19,8 +19,9 @@
 #include <asm/memtype.h>
 #include <asm/vmx.h>

-bool __read_mostly enable_mmio_caching = true;
-module_param_named(mmio_caching, enable_mmio_caching, bool, 0444);
+bool __read_mostly enable_mmio_caching;
+static bool __read_mostly __enable_mmio_caching = true;
+module_param_named(mmio_caching, __enable_mmio_caching, bool, 0444);

 u64 __read_mostly shadow_host_writable_mask;
 u64 __read_mostly shadow_mmu_writable_mask;
@@ -340,6 +341,8 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
        BUG_ON((u64)(unsigned)access_mask != access_mask);
        WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);

+       enable_mmio_caching = __enable_mmio_caching;
+
        if (!enable_mmio_caching)
                mmio_value = 0;


