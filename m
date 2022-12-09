Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276DB647ADB
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 01:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiLIAlG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 19:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiLIAlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 19:41:00 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E56279C9B
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 16:40:57 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y17so3227363plp.3
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 16:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ts8VuH29eJs0lRoNKSbLyJ+3BhxqS01nZUvAotdimj8=;
        b=puLym57KgZSHA6OLMzxQdEiLCorOlK5qeq6JNO/dlUOPemCt31YG5It3xWuyjajzeE
         skQZbJvGqufccY/6LQsUcD1h08as6WW8NUv9AcgbdANxa0MRoIePF8pJLf5x9x4zSnG4
         fSj83bMCzHp1CVyhwrLfPuYW1gEZz/GLb2TFAt9/jYnVHtQW22XVoMJ3Qpld2+JfRwtj
         3U6ZW9evQ7eDPkM8Yxq4AOH5rZKZn1vSR/wHYuPbfFe+B5Y0q0IbdawX2lX7yjBL0EB2
         z+nlImr8AssZ2IQv9rR2VxRoMOn/bunwy+X93JZF+p+sMNLJdGmZG4KWfUmWq0uDHyOy
         eWRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ts8VuH29eJs0lRoNKSbLyJ+3BhxqS01nZUvAotdimj8=;
        b=vN7rXiU3KcVAL+FqHoGc0CzdVrKl5jfjLkTVPRFDH55tDKJGrIFrb8SXmvvdkw/lfc
         psNGJHp/jQ1zBiwk9tgbHfe436erEEWQA0BHWBCZJWG475oI2jxqWN2QLJkA3XXPdF0H
         PXn7SdVZTPJ+iZT0NwgQVYABA7iwt3/4ykcjLCjKfevVRUjeKP7h9B1c/PPWB93SDyMY
         TUluczRzOaEilgbQ4+jycXL+cAzVAtcdKnC6B9Nup9ehx/gHbc1SKPt2LEGLrHKIJtXf
         PeaotQm35P6lPb0O6I+dpPgr0+wVyhEubx/wHGi13uxbLgzBbeM3rOHwLFmXH7kHozuT
         xZaA==
X-Gm-Message-State: ANoB5pnflzSFq3HC+b+aW8hwFY31dwyCIeaqpHZn6x9Dgzr3Y1ya9OnD
        zjhff2eO9PmTVEmAy3/j3HrUlA==
X-Google-Smtp-Source: AA0mqf60ZYGsjIPoGKd7H1LF264DseAYN1CQIVB5EPBFnwar2u2F8zq/m4VWj8XYnzH4abdHKGly0w==
X-Received: by 2002:a17:902:be01:b0:189:6624:58c0 with SMTP id r1-20020a170902be0100b00189662458c0mr1615935pls.3.1670546456839;
        Thu, 08 Dec 2022 16:40:56 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q15-20020a170902a3cf00b0016d9b101413sm28385plb.200.2022.12.08.16.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 16:40:56 -0800 (PST)
Date:   Fri, 9 Dec 2022 00:40:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH v4 03/32] KVM: SVM: Flush the "current" TLB when
 activating AVIC
Message-ID: <Y5KEFdCfdFTplNZ5@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
 <20221001005915.2041642-4-seanjc@google.com>
 <b9f336f17eec6bfbb8429700e0f135d19813c576.camel@redhat.com>
 <7930223f7593c67962e5bd67d7d334d87fbc2d3a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7930223f7593c67962e5bd67d7d334d87fbc2d3a.camel@redhat.com>
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

On Thu, Dec 08, 2022, Maxim Levitsky wrote:
> On Wed, 2022-12-07 at 18:02 +0200, Maxim Levitsky wrote:
> On Sat, 2022-10-01 at 00:58 +0000, Sean Christopherson wrote:
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -86,6 +86,12 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
> >                 /* Disabling MSR intercept for x2APIC registers */
> >                 svm_set_x2apic_msr_interception(svm, false);
> >         } else {
> > +               /*
> > +                * Flush the TLB, the guest may have inserted a non-APIC
> > +                * mapping into the TLB while AVIC was disabled.
> > +                */
> > +               kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, &svm->vcpu);
> > +
> >                 /* For xAVIC and hybrid-xAVIC modes */
> >                 vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
> >                 /* Enabling MSR intercept for x2APIC registers */
> 
> 
> I agree, that if guest disables APIC on a vCPU, this will lead to call to
> kvm_apic_update_apicv which will disable AVIC, but if other vCPUs don't
> disable it, the AVIC's private memslot will still be mapped and guest could
> read/write it from this vCPU, and its TLB mapping needs to be invalidated
> if/when APIC is re-enabled.
>  
> However I think that this adds an unnecessarily (at least in the future)
> performance penalty to AVIC nesting coexistence:
>  
> L1's AVIC is inhibited on each nested VM entry, and uninhibited on each
> nested VM exit, but while nested the guest can't really access it as it has
> its own NPT.
>  
> With this patch KVM will invalidate L1's TLB on each nested VM exit. KVM
> sadly already does this but this can be fixed (its another thing on my TODO
> list)
>  
> Note that APICv doesn't have this issue, it is not inhibited on nested VM
> entry/exit, thus this code is not performance sensitive for APICv.
>  
>  
> I somewhat vote again, as I said before to disable the APICv/AVIC memslot, if
> any of vCPUs have APICv/AVIC hardware disabled, because it is also more
> correct from an x86 perspective. I do wonder how often is the usage of having
> "extra" cpus but not using them, and thus having their APIC in disabled
> state.

There are legimate scenarios where a kernel might want to disable the APIC on
select CPUs, e.g. to offline SMT siblings in BIOS.  Whether or not doing that in
a VM makes sense is debatable, but we really have no way of knowing if there are
existing guests that selectively disable APICs.

> KVM does support adding new vCPUs on the fly, so this shouldn't be needed,
> and APICv inhibit in this case is just a perf regression.

Heh, "just" a perf regression.  Inhibiting APICv would definitely be a perf regression
that people care about, e.g. see the very recent bug fixes:

https://lore.kernel.org/all/20221116205123.18737-1-gedwards@ddn.com
https://lore.kernel.org/all/1669984574-32692-1-git-send-email-yuanzhaoxiong@baidu.com

Conceptually, I like the idea of inhibiting the APICv memslot if a vCPU has its
APIC hardware disabled.  But practically speaking, because KVM has allowed that
scenario for years, I don't think we should introduce such an inhibit and risk
regressing guests.

> Or at least do this only when APIC does back from hardware disabled state to
> enabled.

I have no objection to fine tuning this in follow-up, but for this bug fix I'd
much prefer to go with this minimal change.  The nested SVM TLB flushing issue
extends far beyond this one case, i.e. needs a non-trivial overhaul and an audit
of pretty every piece of SVM code that can interact with TLBs.
