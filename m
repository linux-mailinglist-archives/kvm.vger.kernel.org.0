Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801C173ECC4
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 23:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjFZVU0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 17:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjFZVUY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 17:20:24 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497ACE75
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 14:20:23 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b801e6cebaso12217205ad.0
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 14:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687814423; x=1690406423;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WE7FJwni0q3dlH1xu/laljIYP2fFDEmKjU7VF6N1oIQ=;
        b=GBhmLB+FeUU4gzqe6fdMMOCbgDqJ5xyiSBALxkEKjKWi5PSAlRc8V0S9bpmMM6bk4x
         y95gnd2fUGloSJuGwjfKUExqrGnwFhVtawF0bzEb3xbqtlbCKUH+T6DWFAedfeVPHFV3
         QNW3yRK1rSjwIMhIghk5JS1kEQpLBFc65weV8mjOzha2bm/GyQUEUlQS406TTE+Yf1JX
         1vM5drACJy4FZHTreqm3yKVnuuYgLOuvpbp2JkoKT8RUbNgh/daz/demN5NrEF3VAthn
         tNDmOOcsVfgKYnRLqoBWRBjrFAtSxZ/vPyrHsxMbPLeDhTZW8lgAgvD7+/At8iBn93vb
         XzuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687814423; x=1690406423;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WE7FJwni0q3dlH1xu/laljIYP2fFDEmKjU7VF6N1oIQ=;
        b=PlPWCyVJyq6ed87JPHuLIcC/eCPM9nSxhQeBv9W2m8kivAmlG5umqslC/8zAdZpoEL
         x5xEYCR55l4cvriEiJN6wVMHb3zi8KE7lYri9Ct0uXN1td7ddFp6OGhhqixN5U3n5NGg
         lElvxcrzqyJuEMkpHyp3H6zZG36egiVCI4tNtVHcMcsN62qSurOtt5Jf6zq1XMTqDeSB
         yOqibu+DVoTwfEiRHQj85ZBxi5oM50gLQGW3DxUZ6XaBhc1NxEdBH/eK4FvT/EPTA1dC
         Eu4wgmnJ2Hgb0UJyVK6Xj+gpcVE26C2yCRl9YwOyhdEnZmG0k3JCEz7/x4FXjSswvN/e
         wHEg==
X-Gm-Message-State: AC+VfDy8cRSBsJCSOACf8M/zjDyPp8CHYopr6VrtJNY7QeQcuBDYvMuj
        5cdl7FoLRO91cqe8KaalviBJTIAa2Lw=
X-Google-Smtp-Source: ACHHUZ5pZrv8GDIJADvWZC6aS1aEDkOiinIGdcAK+z5D/sKB+GK664abeWxqO+a0/NsbBxZuVmWGoZvWcrk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:eccb:b0:1b7:ea58:3163 with SMTP id
 a11-20020a170902eccb00b001b7ea583163mr1324942plh.4.1687814422840; Mon, 26 Jun
 2023 14:20:22 -0700 (PDT)
Date:   Mon, 26 Jun 2023 14:20:21 -0700
In-Reply-To: <945384ea-8a15-02cb-66b6-4ba4f22df3db@intel.com>
Mime-Version: 1.0
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-17-weijiang.yang@intel.com> <ZJYc+4fN3K+h8VhM@google.com>
 <945384ea-8a15-02cb-66b6-4ba4f22df3db@intel.com>
Message-ID: <ZJoBFegpUDwCTVLS@google.com>
Subject: Re: [PATCH v3 16/21] KVM:x86: Save/Restore GUEST_SSP to/from SMM
 state save area
From:   Sean Christopherson <seanjc@google.com>
To:     Weijiang Yang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 26, 2023, Weijiang Yang wrote:
> 
> On 6/24/2023 6:30 AM, Sean Christopherson wrote:
> > On Thu, May 11, 2023, Yang Weijiang wrote:
> > > Save GUEST_SSP to SMM state save area when guest exits to SMM
> > > due to SMI and restore it VMCS field when guest exits SMM.
> > This fails to answer "Why does KVM need to do this?"
> 
> How about this:
> 
> Guest SMM mode execution is out of guest kernel, to avoid GUEST_SSP
> corruption,
> 
> KVM needs to save current normal mode GUEST_SSP to SMRAM area so that it can
> restore original GUEST_SSP at the end of SMM.

The key point I am looking for is a call out that KVM is emulating architectural
behavior, i.e. that smram->ssp is defined in the SDM and that the documented
behavior of Intel CPUs is that the CPU's current SSP is saved on SMI and loaded
on RSM.  And I specifically say "loaded" and not "restored", because the field
is writable.

> > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > > ---
> > >   arch/x86/kvm/smm.c | 20 ++++++++++++++++++++
> > >   1 file changed, 20 insertions(+)
> > > 
> > > diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
> > > index b42111a24cc2..c54d3eb2b7e4 100644
> > > --- a/arch/x86/kvm/smm.c
> > > +++ b/arch/x86/kvm/smm.c
> > > @@ -275,6 +275,16 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
> > >   	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
> > >   	smram->int_shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
> > > +
> > > +	if (kvm_cet_user_supported()) {
> > This is wrong, KVM should not save/restore state that doesn't exist from the guest's
> > perspective, i.e. this needs to check guest_cpuid_has().
> 
> Yes, the check missed the case that user space disables SHSTK. Will change
> it, thanks!
> 
> > 
> > On a related topic, I would love feedback on my series that adds a framework for
> > features like this, where KVM needs to check guest CPUID as well as host support.
> > 
> > https://lore.kernel.org/all/20230217231022.816138-1-seanjc@google.com
> 
> The framework looks good, will it be merged in kvm_x86?

Yes, I would like to merge it at some point.

> > > @@ -565,6 +575,16 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
> > >   	static_call(kvm_x86_set_interrupt_shadow)(vcpu, 0);
> > >   	ctxt->interruptibility = (u8)smstate->int_shadow;
> > > +	if (kvm_cet_user_supported()) {
> > > +		struct msr_data msr;
> > > +
> > > +		msr.index = MSR_KVM_GUEST_SSP;
> > > +		msr.host_initiated = true;
> > > +		msr.data = smstate->ssp;
> > > +		/* Mimic host_initiated access to bypass ssp access check. */
> > No, masquerading as a host access is all kinds of wrong.  I have no idea what
> > check you're trying to bypass, but whatever it is, it's wrong.  Per the SDM, the
> > SSP field in SMRAM is writable, which means that KVM needs to correctly handle
> > the scenario where SSP holds garbage, e.g. a non-canonical address.
> 
> MSR_KVM_GUEST_SSP is only accessible to user space, e.g., during LM, it's not
> accessible to VM itself. So in kvm_cet_is_msr_accessible(), I added a check to
> tell whether the access is initiated from user space or not, I tried to bypass
> that check. Yes, I will add necessary checks here.
> 
> > 
> > Why can't this use kvm_get_msr() and kvm_set_msr()?
> 
> If my above assumption is correct, these helpers are passed by
> host_initiated=false and cannot meet the requirments.

Sorry, I don't follow.  These writes are NOT initiated from the host, i.e.
kvm_get_msr() and kvm_set_msr() do the right thing, unless I'm missing something.
