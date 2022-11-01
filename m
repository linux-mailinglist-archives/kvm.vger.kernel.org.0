Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94916150BE
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 18:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiKAReG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 13:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiKARcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 13:32:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F11D1CB04;
        Tue,  1 Nov 2022 10:32:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38187B81E9A;
        Tue,  1 Nov 2022 17:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E12C433D6;
        Tue,  1 Nov 2022 17:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667323926;
        bh=JbOeM0AqPBBllU0o+kD6rGUUaYrAlKa7olm2RWjRX8A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FUfEpkIf4c2oRPE6z3YmW84PIJsB9HNzoMJhSMGNSdLUmy1s3QY70HYASvWiz+aPY
         KtXu/HZUpi2LmnOJh1wm+mLGuPUwM+T6LF5aTgjoVZCmUPEQmVt1TFaF+3Ek08stt+
         4Uf5Z+qLZrbpFnIjaz+OWvc56vcnkfx2/g3bIfTIPFLgjUW5icvEfmZvN6hlwKprB1
         o6VHHDFN7Nh0uNJ+8PNADUryctE0FnW0zoOWuoTP4tSphJuQiEuwWW3/2iJLRB0NJo
         fOwWI5tkWg8KB7XoJzXzmIpMYTY0KvLm2AI2hNDvA7QSzRSBSjBWHiNJXBYHLn3RPf
         MiYKuTqqHhBTA==
Date:   Tue, 1 Nov 2022 10:32:04 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jmattson@google.com
Subject: Re: [PATCH 1/7] KVM: VMX: remove regs argument of __vmx_vcpu_run
Message-ID: <20221101173204.w7yuoerkafxonyzx@treble>
References: <20221028230723.3254250-1-pbonzini@redhat.com>
 <20221028230723.3254250-2-pbonzini@redhat.com>
 <Y2AH6sevOvD/GnKV@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y2AH6sevOvD/GnKV@google.com>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 31, 2022 at 05:37:46PM +0000, Sean Christopherson wrote:
> On Fri, Oct 28, 2022, Paolo Bonzini wrote:
> > Registers are reachable through vcpu_vmx, no need to pass
> > a separate pointer to the regs[] array.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/kernel/asm-offsets.c |  1 +
> >  arch/x86/kvm/vmx/nested.c     |  3 +-
> >  arch/x86/kvm/vmx/vmenter.S    | 58 +++++++++++++++--------------------
> >  arch/x86/kvm/vmx/vmx.c        |  3 +-
> >  arch/x86/kvm/vmx/vmx.h        |  3 +-
> >  5 files changed, 29 insertions(+), 39 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
> > index cb50589a7102..90da275ad223 100644
> > --- a/arch/x86/kernel/asm-offsets.c
> > +++ b/arch/x86/kernel/asm-offsets.c
> > @@ -111,6 +111,7 @@ static void __used common(void)
> >  
> >  	if (IS_ENABLED(CONFIG_KVM_INTEL)) {
> >  		BLANK();
> > +		OFFSET(VMX_vcpu_arch_regs, vcpu_vmx, vcpu.arch.regs);
> 
> Is there an asm-offsets-like solution that doesn't require exposing vcpu_vmx
> outside of KVM?  We (Google) want to explore loading multiple instances of KVM,
> i.e. loading multiple versions of kvm.ko at the same time, to allow intra-host
> migration between versions of KVM to upgrade/rollback KVM without changing the
> kernel (RFC coming soon-ish).  IIRC, asm-offsets is the only place where I haven't
> been able to figure out a simple way to avoid exposing KVM's internal structures
> outside of KVM (so that the structures can change across KVM instances without
> breaking kernel code).

Is that really a problem?  Would it even make sense for non-KVM kernel
code to use 'vcpu_vmx' anyway?  It already seems to be private.
asm-offsets.c has to "cheat" to get access to it by including
"../kvm/vmx/vmx.h".

So the only concern is exposing the asm offsets, right?  But it seems
highly unlikely any non-KVM code would be using those either.

And, that would be a bug anyway: module code is subject to change and
could always get recompiled.  The kernel proper shouldn't be making any
assumptions about the layouts of module-owned structs.

-- 
Josh
