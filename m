Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49FF87BE8D7
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 20:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377400AbjJISGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 14:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376935AbjJISGQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 14:06:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7393194;
        Mon,  9 Oct 2023 11:06:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1684C433C7;
        Mon,  9 Oct 2023 18:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696874775;
        bh=qqVvnqpRR2N4XysEim0lFNvDHLgFX3LGkETYl0RUp4A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g3TE2KEeFA9h+2fmDP9XZhcbQc0uMpaGwj7ccP0sJbXdxGQQHNymKHn3YUj4OrhjM
         UXzja3eHHsmyiRHb+bWSj9pFXrXLL8a6JE7SSWJPxKq/6M+s6ky94JbqAURdhJHsB7
         7vKVKTBkklWclrMCflsCU1u+Io306z4YQtA+LyY1gwkjLbZNvP6+PqiKU0pqrq3N+/
         opSASAs5D9NG5dfUbCyOP05KhdS2zlR3acolnen7rrWHLzBVjdTR1FX1nEXPQBfwSi
         cOAg557HhXwoZVS1IEqr2jSKmgPAMVSuANlP26pKsjBWedsRbD1B4V7zoC/OfANosz
         /MrrZ4pDjclUA==
Date:   Mon, 9 Oct 2023 11:06:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, workflows@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: deprecate KVM_WERROR in favor of general WERROR
Message-ID: <20231009110613.2405ff47@kernel.org>
In-Reply-To: <ZSQ7z8gqIemJQXI6@google.com>
References: <20231006205415.3501535-1-kuba@kernel.org>
        <ZSQ7z8gqIemJQXI6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 9 Oct 2023 10:43:43 -0700 Sean Christopherson wrote:
> On Fri, Oct 06, 2023, Jakub Kicinski wrote:
> > Setting WERROR for random subsystems make life really hard
> > for subsystems which want to build-test their stuff with W=1.
> > WERROR for the entire kernel now exists and can be used
> > instead. W=1 people probably know how to deal with the global
> > W=1 already, tracking all per-subsystem WERRORs is too much...  
> 
> I assume s/W=1/WERROR=y in this line?

Yes, sorry about that.

> > Link: https://lore.kernel.org/all/0da9874b6e9fcbaaa5edeb345d7e2a7c859fc818.1696271334.git.thomas.lendacky@amd.com/
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  Documentation/process/maintainer-kvm-x86.rst |  2 +-
> >  arch/x86/kvm/Kconfig                         | 14 --------------
> >  arch/x86/kvm/Makefile                        |  1 -
> >  3 files changed, 1 insertion(+), 16 deletions(-)
> > 
> > diff --git a/Documentation/process/maintainer-kvm-x86.rst b/Documentation/process/maintainer-kvm-x86.rst
> > index 9183bd449762..cd70c0351108 100644
> > --- a/Documentation/process/maintainer-kvm-x86.rst
> > +++ b/Documentation/process/maintainer-kvm-x86.rst
> > @@ -243,7 +243,7 @@ context and disambiguate the reference.
> >  Testing
> >  -------
> >  At a bare minimum, *all* patches in a series must build cleanly for KVM_INTEL=m
> > -KVM_AMD=m, and KVM_WERROR=y.  Building every possible combination of Kconfigs
> > +KVM_AMD=m, and WERROR=y.  Building every possible combination of Kconfigs
> >  isn't feasible, but the more the merrier.  KVM_SMM, KVM_XEN, PROVE_LOCKING, and
> >  X86_64 are particularly interesting knobs to turn.
> >  
> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index ed90f148140d..12929324ac3e 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -63,20 +63,6 @@ config KVM
> >  
> >  	  If unsure, say N.
> >  
> > -config KVM_WERROR
> > -	bool "Compile KVM with -Werror"
> > -	# KASAN may cause the build to fail due to larger frames
> > -	default y if X86_64 && !KASAN  
> 
> Hrm, I am loath to give up KVM's targeted -Werror as it allows for more aggresive
> enabling, e.g. enabling CONFIG_WERROR for i386 builds with other defaults doesn't
> work because of CONFIG_FRAME_WARN=1024.  That in turns means making WERROR=y a
> requirement in maintainer-kvm-x86.rst is likely unreasonable.
> 
> And arguably KVM_WERROR is doing its job by flagging the linked W=1 error.  The
> problem there lies more in my build testing, which I'll go fix by adding a W=1
> configuration or three.  As the changelog notes, I highly doubt W=1 builds work
> with WERROR, whereas keeping KVM x86 warning-free even with W=1 is feasible.
> 
> > -	# We use the dependency on !COMPILE_TEST to not be enabled
> > -	# blindly in allmodconfig or allyesconfig configurations
> > -	depends on KVM
> > -	depends on (X86_64 && !KASAN) || !COMPILE_TEST  
> 
> On a related topic, this is comically stale as WERROR is on by default for both
> allmodconfig and allyesconfig, which work because they trigger 64-bit builds.
> And KASAN on x86 is 64-bit only.
> 
> Rather than yank out KVM_WERROR entirely, what if we make default=n and trim the
> depends down to "KVM && EXPERT && !KASAN"?  E.g.

IMO setting WERROR is a bit perverse. The way I see it WERROR is a
crutch for people who don't have the time / infra to properly build
test changes they send to Linus. Or wait for build bots to do their job.
We do have sympathy for these folks, we are mostly volunteers after
all. At the same time someone's under-investment should not be causing
pain to those of us who _do_ build test stuff carefully.

Rather than tweak stuff I'd prefer if we could agree that local -Werror
is anti-social :(

The global WERROR seems to be a good compromise.
