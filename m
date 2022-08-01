Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1757F5873EB
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 00:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbiHAW1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 18:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235348AbiHAW1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 18:27:19 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4BD43E7C
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 15:27:17 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id g12so11905875pfb.3
        for <kvm@vger.kernel.org>; Mon, 01 Aug 2022 15:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=3Q6E/4wJML3+dZQ/vFh6w9chsrslWFwyy3w4tz3NuUc=;
        b=hcOlhhGydI4ECtzVfXVnZaKOgxOl8FahXdD9fNBauhkCdPWTAh8qFJyhhY7raFH22u
         WTdIwKlIcEmtgNEEx3fdTagjbUtlNaOHOl3zA2QEp8GeeNCtxVrtjSyB5Jx28F7xxlqw
         oupS5xVbDmjYhy1ygwBI/xPr8EfjOjOUwlH3KZbjxiCcph13YStezRq9PUo3Gso+4NAy
         U8wHR8YsA11fuUp/7V9Yx/AMlWRznKILNV6bWDoBXIDAEcFS1BaUWor3IWL7Vi5wg/45
         uM4JBJsyuaUfcklg4Pxe4QqIO2fdjhqFOU3Y0BOznNN8HRrvIIxNxi/wIFotdzBkJBIC
         LyrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=3Q6E/4wJML3+dZQ/vFh6w9chsrslWFwyy3w4tz3NuUc=;
        b=vyt+6c60IPcVZkGjh0knrUphZ1cHO+d4BcB40VFOxzCiUV9kc39OLQfuKLw/DYti8a
         mqzVKEtpp5Grjohrw9jAJvG5cMibr7NkX0bXHmNDstqvMMaDXiTtSewaAnThBtTlw/s+
         asH3B65jWnxExafpwFLYzq7qzkt4Go9ggQiVOp+5av99iKvmzzBgp4MIIJeCV2/2YLFl
         qOaZy/l9NXUBUhyR2xDaRNq1Jjz9tTqBI5sLprCINprkXx7yCQF5Oy0AenvpW78kZXwA
         hBWYDg6an0BwRbgZVgcG93FKuA8CGpknQLWkQR3+R/bOTl4cnixOfMeyURKEHbVK1Vzl
         S5nw==
X-Gm-Message-State: AJIora98/IN9ntZmkXim7H52+cRow5KUGq7HinfOogsveWuJx8efVsBo
        4Rjyd7BnreV/HwsTAuQKgAHEQg==
X-Google-Smtp-Source: AGRyM1s3ynLlbdGrGBkXGTOvAw+2jmNVdIZP7eY0n5rff3bGV8eDhej4XQUrnY70PPxDt8Q2OovaZA==
X-Received: by 2002:a05:6a00:1745:b0:52a:f0d3:ae7 with SMTP id j5-20020a056a00174500b0052af0d30ae7mr18659685pfc.72.1659392836646;
        Mon, 01 Aug 2022 15:27:16 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id oo8-20020a17090b1c8800b001f3244768d4sm9392005pjb.13.2022.08.01.15.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 15:27:15 -0700 (PDT)
Date:   Mon, 1 Aug 2022 15:27:11 -0700
From:   David Matlack <dmatlack@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [RFC PATCH v6 036/104] KVM: x86/mmu: Explicitly check for MMIO
 spte in fast page fault
Message-ID: <YuhTPxZNhxFs+xjc@google.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <d1a1da631b44f425d929767fda74c90de2d87a8d.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1a1da631b44f425d929767fda74c90de2d87a8d.1651774250.git.isaku.yamahata@intel.com>
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

On Thu, May 05, 2022 at 11:14:30AM -0700, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Explicitly check for an MMIO spte in the fast page fault flow.  TDX will
> use a not-present entry for MMIO sptes, which can be mistaken for an
> access-tracked spte since both have SPTE_SPECIAL_MASK set.
> 
> MMIO sptes are handled in handle_mmio_page_fault for non-TDX VMs, so this
> patch does not affect them.  TDX will handle MMIO emulation through a
> hypercall instead.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index d1c37295bb6e..4a12d862bbb6 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3184,7 +3184,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  		else
>  			sptep = fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
>  
> -		if (!is_shadow_present_pte(spte))
> +		if (!is_shadow_present_pte(spte) || is_mmio_spte(spte))

I wonder if this patch is really necessary. is_shadow_present_pte()
checks if SPTE_MMU_PRESENT_MASK is set (which is bit 11, not
shadow_present_mask). Do TDX VMs set bit 11 in MMIO SPTEs?

>  			break;
>  
>  		sp = sptep_to_sp(sptep);
> -- 
> 2.25.1
> 
