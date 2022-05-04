Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A0351A283
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 16:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351481AbiEDOu4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 10:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240478AbiEDOuy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 10:50:54 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F4A13EBE
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 07:47:18 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n18so1611681plg.5
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 07:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jA2U7X2p/3LAhjnBlGykYcq+8q32UQaHNqJDG7iDoz8=;
        b=joZ7V/hZQ2CuTxOfNunTc0edKk1WTHwW1o5OkZ8MGaXXI6Mv8BBoA7wO4Abow3tXCJ
         oMCqCxEikz77nG+WnNKxGpyVDgZTkrcL317GSOAuoCuwuMc44TDRZ22beADxjNX45ebC
         TdxaH97JHE9e7ZkQnpvEdQI+I1RnGVWsq/4mH0ASU15nV42HY2RVcgcuBKIekswNqVfM
         f2G2fS2iqH01BVOozgDIht7tJ0Kowm83QO39G8Dj0PRD6yeYgY0vym4JpriVXDLpuwjF
         SfqgeRVV16sniPZiACP9Mohp3XtDQ8WtX19hsBJYPve0YOv/MPcavC9GB5Jt4ayHWKR6
         uOzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jA2U7X2p/3LAhjnBlGykYcq+8q32UQaHNqJDG7iDoz8=;
        b=mL1Rrf3DWqo7xPe0AB0N2njzNPhWMG8ucNWnaCHwSU/SV4KIEKXrq16utBzxqki96a
         duseU/4JhOruqGJNFV3Mp/6nzI/rMGh4EAEaAN8botWyLvvb5bmeJpGznrweln8qG6N7
         N0H7T9VXQdZQI0wxYRYxC7HBm5np3/AkrGbUrKpfszV8OjKJf1wPgLQKYP5u/DNM+A6B
         aeXrKti82leIQWEbT3SPYCjN3HwjfA9HzWmsXYJTLR0+mKG+DGJ4nNk+MopvkQz+Ja8y
         o8BhT+cYgcyt1OnzP1I9iUbK8xfONdWfmXE4mphT/odE9Qx4Rt+SeBMLMFYaj1sBCUkM
         Gn/Q==
X-Gm-Message-State: AOAM5330UZMPowsQebV/Igs5Qhr9BRd5U7s2e4fNvpCx0tAeAZ6qzB8g
        uJroj/gsu9AzjKY3aagJYgIOJw==
X-Google-Smtp-Source: ABdhPJzrRKFk/Q/08nIi9uR9fkY6YuJ+bC7hVDKCXz3dZK7Pu5WoMf9Zgg7LYQ84T6TO4Kow0A0sgQ==
X-Received: by 2002:a17:902:f54a:b0:15e:a95a:c0a7 with SMTP id h10-20020a170902f54a00b0015ea95ac0a7mr13675385plf.134.1651675637749;
        Wed, 04 May 2022 07:47:17 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gv21-20020a17090b11d500b001cd4989ff41sm3355441pjb.8.2022.05.04.07.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 07:47:16 -0700 (PDT)
Date:   Wed, 4 May 2022 14:47:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Do not create SPTEs for GFNs that exceed
 host.MAXPHYADDR
Message-ID: <YnKR8DYpwJeMVCoe@google.com>
References: <YmwL87h6klEC4UKV@google.com>
 <ac2001e66957edc8a3af2413b78478c15898f86c.camel@redhat.com>
 <f3ffad3aa8476156f369ff1d4c33f3e127b47d0c.camel@redhat.com>
 <82d1a5364f1cc479da3762b046d22f136db167e3.camel@redhat.com>
 <af15fd31f73e8a956da50db6104e690f9d308dad.camel@redhat.com>
 <YnAMKtfAeoydHr3x@google.com>
 <e11c21e99e7c4ac758b4417e0ae66d3a2f1fe663.camel@redhat.com>
 <cbd4709bb499874c60986083489e17c93b48d003.camel@redhat.com>
 <YnGQyE60lHD7wusA@google.com>
 <42e9431ec2c716f1066fc282ebd97a7a24cbac72.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42e9431ec2c716f1066fc282ebd97a7a24cbac72.camel@redhat.com>
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

On Wed, May 04, 2022, Maxim Levitsky wrote:
> On Tue, 2022-05-03 at 20:30 +0000, Sean Christopherson wrote:
> > Well, I officially give up, I'm out of ideas to try and repro this on my end.  To
> > try and narrow the search, maybe try processing "all" possible gfns and see if that
> > makes the leak go away?
> > 
> > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > index 7e258cc94152..a354490939ec 100644
> > --- a/arch/x86/kvm/mmu.h
> > +++ b/arch/x86/kvm/mmu.h
> > @@ -84,9 +84,7 @@ static inline gfn_t kvm_mmu_max_gfn(void)
> >          * than hardware's real MAXPHYADDR.  Using the host MAXPHYADDR
> >          * disallows such SPTEs entirely and simplifies the TDP MMU.
> >          */
> > -       int max_gpa_bits = likely(tdp_enabled) ? shadow_phys_bits : 52;
> > -
> > -       return (1ULL << (max_gpa_bits - PAGE_SHIFT)) - 1;
> > +       return (1ULL << (52 - PAGE_SHIFT)) - 1;
> >  }
> > 
> >  static inline u8 kvm_get_shadow_phys_bits(void)
> > 
> 
> Nope, still reproduces.
> 
> I'll think on how to trace this, maybe that will give me some ideas.
> Anything useful to dump from the mmu pages that are still not freed at that point?

Dumping the role and gfn is most likely to be useful.  Assuming you aren't seeing
this WARN too:

	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));

then it's not a VM refcounting problem.  The bugs thus far have been tied to the
gfn in some way, e.g. skipping back-to-back entries, the MAXPHYADDR thing.  But I
don't have any ideas for why such a simple test would generate unique behavior.

> Also do you test on AMD? I test on my 3970X.

Yep, I've tried Rome and Milan, and CLX (or maybe SKX?) and HSW on the Intel side.
