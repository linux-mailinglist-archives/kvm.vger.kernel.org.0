Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA9B6A78E9
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 02:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjCBBhb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 20:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjCBBha (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 20:37:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8748434332;
        Wed,  1 Mar 2023 17:37:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A3F35CE1DF2;
        Thu,  2 Mar 2023 01:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF23C433EF;
        Thu,  2 Mar 2023 01:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677721045;
        bh=5TPfW2FAVzvukO9C6PIlJTa5cqjUicEsT/o6u0kTLzo=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=EVR6tNVfJ2FRRUnVY8lhdnD9R/MkQqbe+bKD4xGjOYgAZ4jR4dz24HvMcSIrISHN4
         ll3u7AOOIbHdQuM3MdAhhIR1i2PL3hXzmXIRL6v8j5oBR3LoiwZVGTcZUqZMnJFxSm
         8AxSzdmYorgSkgOAKuN3MIsCZ8XGypUm/fDTVVyDHNsNZNW+Bnt1FroEdlHEPlAz3H
         0y5O/zgVQxBsY71HGd759CyoPRiuwiMRh8YzLzplsUVn+EFYH29l81do49W9Kk8wdl
         0ZszCVZHgRChG27O9Pmz71wfZWGXzIYRt7FnCe/ydt536Rs91zLZqpJjVEjfXwGakR
         HAUt8rJuoiXxw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 9F1975C0377; Wed,  1 Mar 2023 17:37:24 -0800 (PST)
Date:   Wed, 1 Mar 2023 17:37:24 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Josh Triplett <josh@joshtriplett.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        kim.phillips@amd.com, brgerst@gmail.com, piotrgorski@cachyos.org,
        oleksandr@natalenko.name, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH v12 07/11] x86/smpboot: Remove early_gdt_descr on 64-bit
Message-ID: <20230302013724.GO2948950@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230226110802.103134-1-usama.arif@bytedance.com>
 <20230226110802.103134-8-usama.arif@bytedance.com>
 <878rghmrn2.ffs@tglx>
 <96c0c723-9976-a222-8dc8-a5da6a1a558e@linux.intel.com>
 <Y/+2Wuunn1sIF8eT@localhost>
 <20230301221632.GI2948950@paulmck-ThinkPad-P17-Gen-1>
 <Y//Q4Mh6/65Keruu@localhost>
 <20230302002851.GK2948950@paulmck-ThinkPad-P17-Gen-1>
 <41baeedf-f3ee-7342-7a5e-097f9a3c4de0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41baeedf-f3ee-7342-7a5e-097f9a3c4de0@infradead.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 01, 2023 at 05:05:39PM -0800, Randy Dunlap wrote:
> 
> 
> On 3/1/23 16:28, Paul E. McKenney wrote:
> > On Wed, Mar 01, 2023 at 02:25:36PM -0800, Josh Triplett wrote:
> >> On Wed, Mar 01, 2023 at 02:16:32PM -0800, Paul E. McKenney wrote:
> >>> On Wed, Mar 01, 2023 at 12:32:26PM -0800, Josh Triplett wrote:
> >>>> On Tue, Feb 28, 2023 at 01:02:33PM -0800, Arjan van de Ven wrote:
> >>>>   Thomas Gleixner wrote:
> >>>>>>
> >>>>>> Maybe we should enforce CONFIG_SMP=y first :)
> >>>>>>
> >>>>>> Thanks,
> >>>>>
> >>>>> for 64 bit I can see the point of removing the !SMP case entirely from arch/x86 .
> >>>>> maybe even for 32 bit if it just makes the code simpler I suppose
> >>>>
> >>>> As one of the folks keeping an eye on tinyconfig and kernel size, I
> >>>> actually think we *should* make this change and rip out !CONFIG_SMP,
> >>>> albeit carefully.
> >>>>
> >>>> In particular, I would propose that we rip out !CONFIG_SMP, *but* we
> >>>> allow building with CONFIG_NR_CPUS=1. (And we could make sure in that
> >>>> case that the compiler can recognize that at compile time and optimize
> >>>> accordingly, so that it might provide some of the UP optimizations for
> >>>> us.)
> >>>>
> >>>> Then, any *optimizations* for the "will only have one CPU, ever" case
> >>>> can move to CONFIG_NR_CPUS=1 rather than !CONFIG_SMP. I think many of
> >>>> those optimizations may be worth keeping for small embedded systems, or
> >>>> for cases like Linux-as-bootloader or similar.
> >>>>
> >>>> The difference here would be that code written for !CONFIG_SMP today
> >>>> needs to account for the UP case for *correctness*, whereas code written
> >>>> for CONFIG_SMP can *optionally* consider CONFIG_NR_CPUS=1 for
> >>>> *performance*.
> >>>
> >>> It certainly would not make much sense to keep Tiny RCU and Tiny SRCU
> >>> around if there was no CONFIG_SMP=n.
> >>
> >> On the contrary, I think it's entirely appropriate to keep them for
> >> CONFIG_NR_CPUS=1; that's exactly the kind of simple optimization that
> >> seems well worth having. (Ideal optimization: "very very simple for UP,
> >> complex for SMP"; non-ideal optimization: "complex for SMP, differently
> >> complex for UP".)
> > 
> > Fair enough, but how does removing CONFIG_SMP help with that?  Given that
> > it is not all that hard to work around the lack of CONFIG_SMP for Tiny
> > RCU and Tiny SRCU, then it cannot be all that hard to work around that
> > lack for the use cases that you are trying to get rid of, right?
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > diff --git a/kernel/rcu/Kconfig b/kernel/rcu/Kconfig
> > index 9071182b1284b..7487bee3d4341 100644
> > --- a/kernel/rcu/Kconfig
> > +++ b/kernel/rcu/Kconfig
> > @@ -7,7 +7,7 @@ menu "RCU Subsystem"
> >  
> >  config TREE_RCU
> >  	bool
> > -	default y if SMP
> > +	default y if CONFIG_NR_CPUS = 1
> >  	# Dynticks-idle tracking
> >  	select CONTEXT_TRACKING_IDLE
> >  	help
> > @@ -31,7 +31,7 @@ config PREEMPT_RCU
> >  
> >  config TINY_RCU
> >  	bool
> > -	default y if !PREEMPTION && !SMP
> > +	default y if !PREEMPTION && CONFIG_NR_CPUS != 1
> >  	help
> >  	  This option selects the RCU implementation that is
> >  	  designed for UP systems from which real-time response
> 
> but drop the CONFIG_ prefixes...

Indeed.  What I don't understand is how the above passed some light
rcutorture testing.  And the comparisons are backwards as well.
Perhaps this time two bugs make working code?

How about the following?

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcu/Kconfig b/kernel/rcu/Kconfig
index 9071182b1284b..a2ba97b949498 100644
--- a/kernel/rcu/Kconfig
+++ b/kernel/rcu/Kconfig
@@ -7,7 +7,7 @@ menu "RCU Subsystem"
 
 config TREE_RCU
 	bool
-	default y if SMP
+	default y if NR_CPUS != 1
 	# Dynticks-idle tracking
 	select CONTEXT_TRACKING_IDLE
 	help
@@ -31,7 +31,7 @@ config PREEMPT_RCU
 
 config TINY_RCU
 	bool
-	default y if !PREEMPTION && !SMP
+	default y if !PREEMPTION && NR_CPUS = 1
 	help
 	  This option selects the RCU implementation that is
 	  designed for UP systems from which real-time response
