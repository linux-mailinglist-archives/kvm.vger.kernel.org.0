Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1745351CA
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 18:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348076AbiEZQBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 12:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348081AbiEZQBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 12:01:41 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CB4D5D
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 09:01:37 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id j6so2007192pfe.13
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 09:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0wDwEbvj2W8EBJJzj5GYa4VDlivxhpjuZEM3P0GFWVg=;
        b=rzbsOKPxkw1y3rvKMtPj+R0UaslkSSTYVLxXPfnfs4Bu3e0XjOK130UAYTzuBesWze
         VUXl1FJqWiXGJTzuhhgU/9CRoEQDOI6lVFcdYxDheXj5suqK057rAE8MHMagjNMeE6py
         enfQJK1lNKpLsbI/VmhivBKOHokHnNUgIp+ydK2pLrH46oU0056NNmHF69wASKmilxIY
         6TCaQ7cJKCWxiDhLn7dhhJuFhJfkHN9hvG5rc2G5PzWwjDj8jWaTuab6n+xlI/WYVV7j
         nmf0oceoaLaz0HIQjQkKGwd/66M1ph9If5YNxXevfwxcDY3O/CPHlifSG5rS0IVbhG1s
         8XCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0wDwEbvj2W8EBJJzj5GYa4VDlivxhpjuZEM3P0GFWVg=;
        b=k/P1UzVc2PU8G1aC7PTRvX0CCnXbDS3doTpN8e1KHNa7VMd7sDjDCotLEXUXt9RxJV
         jPxo1ZRvGD3s1eiI+BB14HO3JuZiXm7IYDdilRRG04lOU2xN9yqVeVUngsHuenbc4YC2
         I82kI562kt4ec9s9z+S9XmkAeG/42K5RiA6oG0nCsCiXAwXsUS6XXt8zH61Jojoybman
         W9XRHJt+hbW6dvCKrDLwKDyYpAmHbck13CiXQtKwIgVSDTDQi+6VzNWdYmPLPTIUJ3f2
         nVGFoNvdTzgBsU3Mx/FYXlWPBLYV0WmwOVIHBOm44SCTNO9btBj3TvFiQ5Qo1+7xwVeW
         RkxA==
X-Gm-Message-State: AOAM531eVJW9dmvSA9Dy0Yz+VNDclq9+ep1jHm8O2MBIFonDmbqqk+dO
        edg+b3QmhRiNN7a8xT2qvvHTnw==
X-Google-Smtp-Source: ABdhPJxWeVGhDADcS2EV6MDVYRLZdtTXEe7zHWZmcdKOxfk+OiR5C2jE3xk085AN9iyKigpitEm41g==
X-Received: by 2002:a65:5601:0:b0:3fb:355:5f2f with SMTP id l1-20020a655601000000b003fb03555f2fmr4661946pgs.78.1653580896440;
        Thu, 26 May 2022 09:01:36 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p9-20020a170902f08900b0015e8d4eb25fsm1706120pla.169.2022.05.26.09.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 09:01:35 -0700 (PDT)
Date:   Thu, 26 May 2022 16:01:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Dinse <nanook@eskimo.com>
Subject: Re: [PATCH 2/4] KVM: x86: Harden _regs accesses to guard against
 buggy input
Message-ID: <Yo+kXEKYAdduOAZX@google.com>
References: <20220525222604.2810054-1-seanjc@google.com>
 <20220525222604.2810054-3-seanjc@google.com>
 <202205260835.9BC23703@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202205260835.9BC23703@keescook>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022, Kees Cook wrote:
> On Wed, May 25, 2022 at 10:26:02PM +0000, Sean Christopherson wrote:
> > Link: https://lore.kernel.org/all/YofQlBrlx18J7h9Y@google.com
> > Cc: Robert Dinse <nanook@eskimo.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/emulate.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > index 7226a127ccb4..c58366ae4da2 100644
> > --- a/arch/x86/kvm/emulate.c
> > +++ b/arch/x86/kvm/emulate.c
> > @@ -247,6 +247,9 @@ enum x86_transfer_type {
> >  
> >  static ulong reg_read(struct x86_emulate_ctxt *ctxt, unsigned nr)
> >  {
> > +	if (WARN_ON_ONCE(nr >= 16))
> > +		nr &= 16 - 1;
> 
> Instead of doing a modulo here, what about forcing it into an "unused"
> slot?
> 
> i.e. define _regs as an array of [16 + 1], and:
> 
> 	if (WARN_ON_ONCE(nr >= 16)
> 		nr = 16;
> 
> Then there is both no out-of-bounds access, but also no weird "actual"
> register indexed?

Eh, IMO it doesn't provide any meaningful value, and requires documenting why
the emulator allocates an extra register.

The guest is still going to experience data loss/corruption if KVM drops a write
or reads zeros instead whatever register it was supposed to access.  I.e. the
guest is equally hosed either way.

One idea along the lines of Vitaly's idea of KVM_BUG_ON() would be to add an
emulator hook to bug the VM, e.g.

#define KVM_EMULATOR_BUG_ON(cond, ctxt)				\
({								\
	int __ret = (cond);					\
								\
	if (WARN_ON_ONCE(__ret))				\
		ctxt->ops->vm_bugged(ctxt);			\
	unlikely(__ret);					\
})

to workaround not having access to the 'struct kvm_vcpu' in the emulator.  The
bad access will still go through, but the VM will be killed before the vCPU can
re-enter the guest and do more damage.
