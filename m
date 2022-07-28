Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A777584366
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 17:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiG1PnP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 11:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiG1PnN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 11:43:13 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA22568DF0
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 08:43:12 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id o3so2127336ple.5
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 08:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OvVirUwva7iitmCWZI9gOg8g2CWki9PsaWOed+nTpOU=;
        b=AiRFPHaA7gZOYNc69ZY96d8VhlOkMnaDNRHXUPXYvDABBFKi+J5uw7z/ofo7pXx+kZ
         OLkNhH6Kgd3V69r4I7YmRLT/Tjia4T46btmtB1dIkIw28Vis+01PIRvIPlJitO/FwFw/
         1U1P8H0p3NMJKHx+U00LYiF/H6ovjadOyBh9jbw5EV0yzAp2mhazixc661ahs+T9PIG2
         PLxkwjYXNKIM7s/70lnmsJ6WXvH8uJuhEARVWaFT4vFEvklLelKE8IPxtg2ZlI3gWFrm
         WLZJK2MpAbAObHMb4Zc+gAO/fwqAEfWJaGvKTCbie4uhrbeJl0J8pMdvZBKF8ZOaLOct
         J5WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OvVirUwva7iitmCWZI9gOg8g2CWki9PsaWOed+nTpOU=;
        b=dgg0QqRZ1jp37aFTi48w7djQNiRS3yJfiZbyRnzrs4uJcn4xzObBviLiMM2U7l1GYC
         QSFa+FTJJM0TSILPy6fZnC074NcDIcdUWvJC2sdgNNhkW2zCTJ7Fh4PsUiH+ettBjjXV
         8rw/Wofp4oKtj9KPj690MZZ+81cLLY0YaHZtOcwE7Fs67Qvltd8Tf9TprfBdCzIHxBwT
         p53gTWNosfafONt92hRfjbVhZqrQew7Q2ZdbTxyzkhW3pCbFy7A37qQvReskm6b8VIgZ
         3Cg/hmXwWfXKG1+BxPl1ffWmv+5aBfPfbBbIrCyMuvaknIX4OXkyKKBtKXnAAeLblbwO
         rFFg==
X-Gm-Message-State: AJIora99o/epizJWUt4hlH3Av4OCidz8Mdqu2dyvhsYXl8IBE6FNR5sZ
        +BXdIGMWmRbCh+QIN9M/4lqkag==
X-Google-Smtp-Source: AGRyM1sH1quS5prsBUI9o3IRDsm8cA8ZRJf5b7TYuFSboXNv9OrkXcNXF6d6uc0XJRCyRVNDWZAZfg==
X-Received: by 2002:a17:902:d483:b0:16d:6d17:1695 with SMTP id c3-20020a170902d48300b0016d6d171695mr20600840plg.73.1659022992223;
        Thu, 28 Jul 2022 08:43:12 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q17-20020aa78431000000b0052badc0f3d7sm947704pfn.50.2022.07.28.08.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 08:43:11 -0700 (PDT)
Date:   Thu, 28 Jul 2022 15:43:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: Possible 5.19 regression for systems with 52-bit physical
 address support
Message-ID: <YuKuiyFFFY3QbZ3z@google.com>
References: <20220728134430.ulykdplp6fxgkyiw@amd.com>
 <20220728135320.6u7rmejkuqhy4mhr@amd.com>
 <YuKjsuyM7+Gbr2nw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuKjsuyM7+Gbr2nw@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 28, 2022, Sean Christopherson wrote:
> On Thu, Jul 28, 2022, Michael Roth wrote:
> > On Thu, Jul 28, 2022 at 08:44:30AM -0500, Michael Roth wrote:
> Different approach.  To fix the bug with enable_mmio_caching not being set back to
> true when a vendor-specific mask allows caching, I believe the below will do the
> trick.

...
 
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 7314d27d57a4..a57add994b8d 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -19,8 +19,9 @@
>  #include <asm/memtype.h>
>  #include <asm/vmx.h>
> 
> -bool __read_mostly enable_mmio_caching = true;
> -module_param_named(mmio_caching, enable_mmio_caching, bool, 0444);
> +bool __read_mostly enable_mmio_caching;
> +static bool __read_mostly __enable_mmio_caching = true;
> +module_param_named(mmio_caching, __enable_mmio_caching, bool, 0444);
> 
>  u64 __read_mostly shadow_host_writable_mask;
>  u64 __read_mostly shadow_mmu_writable_mask;
> @@ -340,6 +341,8 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
>         BUG_ON((u64)(unsigned)access_mask != access_mask);
>         WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
> 
> +       enable_mmio_caching = __enable_mmio_caching;

This isn't ideal as the value used by KVM won't be reflected in the module param.
The basic approach is sound, but KVM should snapshot the original value of the module
param and "reset" to that.

> +
>         if (!enable_mmio_caching)
>                 mmio_value = 0;
> 
> 
