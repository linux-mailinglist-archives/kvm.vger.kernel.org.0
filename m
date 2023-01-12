Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E7066675D
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 01:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbjALAF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 19:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjALAFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 19:05:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E760332191;
        Wed, 11 Jan 2023 16:05:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F64A61EF6;
        Thu, 12 Jan 2023 00:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F15C433D2;
        Thu, 12 Jan 2023 00:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673481921;
        bh=B68EjfGhPUeZkY/oEyQdlKSXswgp8PB775kXN5cu0cA=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=aIBO9Rz7Khf/U1lEgBAfrSL26JGaGd3HT9POJoAIjCHY5nBODdEVH2oxvZFmRMmMl
         7/o8QworZKAYLppGXlobxvaDIp32cYTleQeI3EknErXKV2c+efe+lOxeT8McYF/zMm
         idGddiTkJ7nwDPPN5ApmkQlgWntG6yft1+4LUVczL49RYprDCV1d/0KS/QpdgM48Ip
         ApJdg7F3toGm650mW73ISN19Tx7QiebwKm/j/kewDDHf+tWeipkzvbZ/LRdXf1lsL0
         rKTp/Fb8Bb4tyXDuWJWRO77DrndpGUFXdr7EFoPs+DO25gGCcx/+oRnW6/BH9aM9J7
         5LlCGquK1AgXw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 733E35C0AF8; Wed, 11 Jan 2023 16:05:21 -0800 (PST)
Date:   Wed, 11 Jan 2023 16:05:21 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@meta.com, rostedt@goodmis.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH rcu 01/27] arch/x86: Remove "select SRCU"
Message-ID: <20230112000521.GA3036960@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230105003759.GA1769545@paulmck-ThinkPad-P17-Gen-1>
 <20230105003813.1770367-1-paulmck@kernel.org>
 <Y7xSO2dW1sy21RVz@google.com>
 <20230109192228.GV4028633@paulmck-ThinkPad-P17-Gen-1>
 <20230109200553.GA4154229@paulmck-ThinkPad-P17-Gen-1>
 <Y73CoUO63TOxmmnC@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y73CoUO63TOxmmnC@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 10, 2023 at 07:55:13PM +0000, Sean Christopherson wrote:
> On Mon, Jan 09, 2023, Paul E. McKenney wrote:
> > On Mon, Jan 09, 2023 at 11:22:28AM -0800, Paul E. McKenney wrote:
> > > On Mon, Jan 09, 2023 at 05:43:23PM +0000, Sean Christopherson wrote:
> > > > On Wed, Jan 04, 2023, Paul E. McKenney wrote:
> > > > > Now that the SRCU Kconfig option is unconditionally selected, there is
> > > > > no longer any point in selecting it.  Therefore, remove the "select SRCU"
> > > > > Kconfig statements.
> > > > > 
> > > > > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > > > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > > > Cc: Ingo Molnar <mingo@redhat.com>
> > > > > Cc: Borislav Petkov <bp@alien8.de>
> > > > > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > > > > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > > > > Cc: Sean Christopherson <seanjc@google.com>
> > > > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > > Cc: <x86@kernel.org>
> > > > > Cc: <kvm@vger.kernel.org>
> > > > > ---
> > > > 
> > > > ...
> > > > 
> > > > > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > > > > index fbeaa9ddef598..9306d99585188 100644
> > > > > --- a/arch/x86/kvm/Kconfig
> > > > > +++ b/arch/x86/kvm/Kconfig
> > > > > @@ -46,7 +46,6 @@ config KVM
> > > > >  	select KVM_XFER_TO_GUEST_WORK
> > > > >  	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
> > > > >  	select KVM_VFIO
> > > > > -	select SRCU
> > > > 
> > > > Would it be too much trouble to bundle all of the KVM changes into a single patch?
> > > > The SRCU requirement is a generic KVM requirement that's handled in the arch Kconfigs
> > > > purely because of KVM's somewhat roundabout Kconfig setup.
> > > 
> > > No problem, and will do on my next rebase.  I might end up with a long
> > > list of Cc's, but so it goes.  I will of course send the result as a
> > > reply to this message.
> > 
> > Like this?
> 
> Ya, looks good!

Glad you like it!  May I have your ack?  Or would you take this one?

							Thanx, Paul
