Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBF6F68A3D0
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 21:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbjBCUyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 15:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbjBCUym (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 15:54:42 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A679A808
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 12:54:41 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id on9-20020a17090b1d0900b002300a96b358so6076909pjb.1
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 12:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3SzgB8BimWkWsf24WeKc7CMgI/jdN2TsinI4i82l8wc=;
        b=L3UjjGiCf8ibTPp5/Hid2G7dnDw0495SPMM1cxR6q1dvXJjfv4yERdsoVDgct4MjRz
         ULOsvGsNtzE8lUkX3uK6Q4mVz8sLsMiqJF2yhrv6Djjp5rr+4sRkHC1xXDUu94Wgh2MI
         shK4tDAdJhnEOV0UnQinl5+rIEZImUyOlmeevSdlH4+z/1FK7/Pq+2Awy63E8For6RiE
         VW7QPIYoXccxa4oa9WiP6YHIHJzpcaavjkmFcNRhPZItDlM3ho3/AJQulnjl+/jclY5m
         V9prTGKk6420g3Oz94Ww7FVl1FEMDrjrTXrwOgSL9mMJYgd6mABtQvC+1HXcwlej6NX8
         VvFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3SzgB8BimWkWsf24WeKc7CMgI/jdN2TsinI4i82l8wc=;
        b=TfBzZ579939pTocU4f3cPWTSR6P1gCPnjVWy0YHyYuuEIKus9MCt4ZT4kBz9U1rP0P
         oFYWrsxiYyd/M0PYXcaGyon4Z4nk3nK9I5/DljR7nUD0pud4X6fA62aQwZo8r2RxVavs
         k0ncpuZ1YN2u7Dc7/YeHjaUyPz74bo4rDUe2lA47nHs8IcJy7/4A0iunAKVInBGzH7Qq
         MXreu9/TlAoNGIkK71z5fcT4aTjIuZ3LDhtjgKU/6CwdnE8M8ltVctGcG1rv+LXlNpHb
         HWPZEFETrqfU1SWuixez+iI6BmoLLwsP9DSVvfQf8i05u2vqikTgt2UO4rdcxFcZ2iZG
         1gMA==
X-Gm-Message-State: AO0yUKUMeqggpEYddti8+aSK6UKDajo8TByEfdx0Nw7eOfNdm15B7m00
        LZelL2BNuCK81InXse7D+wlozQ==
X-Google-Smtp-Source: AK7set+nzNe5YGWLprg0RVfizk20dA+TEIn04ERrl+m0suik+lGDW0WGdFxGCZfgXaxe+vlEj8L+ag==
X-Received: by 2002:a17:903:249:b0:198:af4f:de0b with SMTP id j9-20020a170903024900b00198af4fde0bmr16701plh.11.1675457680724;
        Fri, 03 Feb 2023 12:54:40 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p10-20020a1709026b8a00b00183c67844aesm2049637plk.22.2023.02.03.12.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 12:54:40 -0800 (PST)
Date:   Fri, 3 Feb 2023 20:54:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 1/7] kvm: x86/mmu: Use KVM_MMU_ROOT_XXX for
 kvm_mmu_invalidate_gva()
Message-ID: <Y910jLLQ+3jVQsta@google.com>
References: <20230105095848.6061-1-jiangshanlai@gmail.com>
 <20230105095848.6061-2-jiangshanlai@gmail.com>
 <Y9sP/0B8A7fx2tkf@google.com>
 <CAJhGHyCgSzH5x9=OutgOcxCEg784woz9VouAwJ=K0xqXTF9Avw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyCgSzH5x9=OutgOcxCEg784woz9VouAwJ=K0xqXTF9Avw@mail.gmail.com>
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

On Fri, Feb 03, 2023, Lai Jiangshan wrote:
> On Thu, Feb 2, 2023 at 9:21 AM Sean Christopherson <seanjc@google.com> wrote:
> 
> >
> > This is logically correct, but there's potential (weird) functional change here.
> > If this is called with an invalid root, then KVM will invalidate the GVA in all
> > roots prior to this patch, but in no roots after this patch.
> >
> > I _think_ it should be impossible get here with an invalid root.  Can you try
> > adding a prep patch to assert that the root is valid so that this patch can
> > reasonably assert that there's no functional change?
> >
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 508074e47bc0..fffd9b610196 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -792,6 +792,8 @@ void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
> >         fault_mmu = fault->nested_page_fault ? vcpu->arch.mmu :
> >                                                vcpu->arch.walk_mmu;
> >
> > +       WARN_ON_ONCE(!VALID_PAGE(fault_mmu->root.hpa));
> > +
> 
> I've been updating the patches as per your suggestions.
> 
> And I suddenly realized that when fault->nested_page_fault=false
> with nested EPT, fault_mmu->root.hpa is always unset.
> 
> fault_mmu->root.hpa is just meaningless when fault_mmu is not
> vcpu->arch.mmu.

Right, because there's no KVM-managed MMU. 

> I will add it as one of the reasons for replacing the argument
> with KVM_MMU_ROOT_XXX.

And maybe call out that when using walk_mmu, the ->invlpg() implementation is
NULL, i.e. using CURRENT root is a nop.

Thanks!
