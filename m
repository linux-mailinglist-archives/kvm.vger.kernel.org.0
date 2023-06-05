Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091BF722CC7
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 18:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbjFEQg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 12:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbjFEQgV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 12:36:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB0D10CB;
        Mon,  5 Jun 2023 09:35:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF40662835;
        Mon,  5 Jun 2023 16:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B70C4339C;
        Mon,  5 Jun 2023 16:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685982955;
        bh=L7xzv+kSx174UlUtHfXxVLC08BZ82BvEB+2sWRo7BNg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aUUxOLT3y8TH5o2dzR7y8OwCxsD2ZTNBgKWagSKJ5eHAeaN3UKv12v6M0oEvzebgU
         ACktNhMu8MbhDhPMZI6q2SzTuJlKr0k76v43Y8UMRj4bga9rNg5eilImKGsj7Qn+8c
         Vg7Ejv1crV80ADIAW2SsVD/K6ytKOu0Uv5Fanur8/fuKpO9KY+ZGKrAC+a4D+PG6CN
         PKueXoV+4MM4sY53dqTWh7fmBd9XRdHMA4//vigUeeuiyTyxiLiQxXOZqmzCokJegL
         iZ1Q+TxX9YJPSW3/K5Viy5scqly4UMRIXsAC+ScHdAm2Yw6zMw2T1rIZ8dxMYC0m3w
         jvDibjKLgBw3w==
Date:   Mon, 5 Jun 2023 09:35:52 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
Message-ID: <20230605163552.hi5kvh5wijegmus6@treble>
References: <20230531150112.76156-1-jon@nutanix.com>
 <20230531231820.trrs2uugc24gegj4@treble>
 <F4BEBCAF-CBFC-4C3E-8B01-2ED84CF2E13A@nutanix.com>
 <20230601004202.63yulqs73kuh3ep6@treble>
 <846dd0c5-d431-e20e-fdb3-a4a26b6a22ca@citrix.com>
 <20230601012323.36te7hfv366danpf@desk>
 <20230601042345.52s5337uz62p6aow@treble>
 <21D1D290-7DE9-4864-A05B-A36779D9DC26@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <21D1D290-7DE9-4864-A05B-A36779D9DC26@nutanix.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 02:29:02PM +0000, Jon Kohler wrote:
> 
> 
> > On Jun 1, 2023, at 12:23 AM, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > 
> > On Wed, May 31, 2023 at 06:24:29PM -0700, Pawan Gupta wrote:
> > 
> > ## 2023-05-31
> >> On Thu, Jun 01, 2023 at 01:50:48AM +0100, Andrew Cooper wrote:
> >>> On 01/06/2023 1:42 am, Josh Poimboeuf wrote:
> >>>> So each LFENCE has a distinct purpose.  That said, there are no indirect
> >>>> branches or unbalanced RETs between them.
> >>> 
> >>> How lucky are you feeling?
> >>> 
> >>> You're in C at this point, which means the compiler could have emitted a
> >>> call to mem{cpy,cmp}() in place of a simple assignment/comparison.
> >> 
> >> Moving the second LFENCE to the else part of WRMSR should be possible?
> >> So that the serialization can be achived either by WRMSR or LFENCE. This
> >> saves an LFENCE when host and guest value of MSR_SPEC_CTRL differ.
> > 
> > Yes.  Though in practice it might not make much of a difference.  With
> > wrmsr+lfence, the lfence has nothing to do so it might be almost
> > instantaneous anyway.
> > 
> > -- 
> > Josh
> 
> Coming back to this, what if we hoisted call vmx_spec_ctrl_restore_host above
> FILL_RETURN_BUFFER, and dropped this LFENCE as I did here?
> 
> That way, we wouldn’t have to mess with the internal LFENCE in nospec-branch.h,
> and that would act as the “final line of defense” LFENCE.
> 
> Would that be acceptable? Or does FILL_RETURN_BUFFER *need* to occur
> before any sort of calls no matter what?

If we go by Intel's statement that only unbalanced RETs are a concern,
that *might* be ok as long as there's a nice comment above the
FILL_RETURN_BUFFER usage site describing the two purposes for the
LFENCE.

However, based on Andy's concerns, which I've discussed with him
privately (but I'm not qualified to agree or disagree with), we may want
to just convert vmx_spec_ctrl_restore_host() to asm.  Better safe than
sorry.  My original implementation of that function was actually asm.  I
can try to dig up that code.

-- 
Josh
