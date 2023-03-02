Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466996A7863
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 01:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjCBA25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 19:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjCBA2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 19:28:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3615E3B3C7;
        Wed,  1 Mar 2023 16:28:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1084614C2;
        Thu,  2 Mar 2023 00:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F198C433D2;
        Thu,  2 Mar 2023 00:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677716932;
        bh=cifQkE7dZi14NSc4jacpfXZQ36+BoQ6aYs+5KMizQmQ=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=UU/2BE1y6tQVgsDkz1bw86saSYy/Dn+nmXlDYgXq66Np87IMyosRwNqM8/K2Cx1RU
         0ArGHXwaLtEJfc3DnvKWhQbngQXvC1XIVDbjEyFJYFmILWSiT8BQsycH0pP2PdppNw
         12ibr0RTmgGB6qsAoXJS7bslS+TQdVpcegm7GZJ6u5IS5AIiPER4dZjyxtZ+3Y8730
         x3gL4XZAKs6unwTSlYLDZ0K4PH1jQNYRZkZWZwqlRGW17VXYYOaiB1EpRo0lPm3Kxj
         5f7YtvNrcVIWW+whND5eBZAgPkbkBLWaIkjxYKwYRB6qlO43OCqdapVZ7G7OSTyu6e
         ZM9RY9sAfLbzg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id A24405C0159; Wed,  1 Mar 2023 16:28:51 -0800 (PST)
Date:   Wed, 1 Mar 2023 16:28:51 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     Arjan van de Ven <arjan@linux.intel.com>,
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
Message-ID: <20230302002851.GK2948950@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230226110802.103134-1-usama.arif@bytedance.com>
 <20230226110802.103134-8-usama.arif@bytedance.com>
 <878rghmrn2.ffs@tglx>
 <96c0c723-9976-a222-8dc8-a5da6a1a558e@linux.intel.com>
 <Y/+2Wuunn1sIF8eT@localhost>
 <20230301221632.GI2948950@paulmck-ThinkPad-P17-Gen-1>
 <Y//Q4Mh6/65Keruu@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y//Q4Mh6/65Keruu@localhost>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 01, 2023 at 02:25:36PM -0800, Josh Triplett wrote:
> On Wed, Mar 01, 2023 at 02:16:32PM -0800, Paul E. McKenney wrote:
> > On Wed, Mar 01, 2023 at 12:32:26PM -0800, Josh Triplett wrote:
> > > On Tue, Feb 28, 2023 at 01:02:33PM -0800, Arjan van de Ven wrote:
> > >   Thomas Gleixner wrote:
> > > > > 
> > > > > Maybe we should enforce CONFIG_SMP=y first :)
> > > > > 
> > > > > Thanks,
> > > > 
> > > > for 64 bit I can see the point of removing the !SMP case entirely from arch/x86 .
> > > > maybe even for 32 bit if it just makes the code simpler I suppose
> > > 
> > > As one of the folks keeping an eye on tinyconfig and kernel size, I
> > > actually think we *should* make this change and rip out !CONFIG_SMP,
> > > albeit carefully.
> > > 
> > > In particular, I would propose that we rip out !CONFIG_SMP, *but* we
> > > allow building with CONFIG_NR_CPUS=1. (And we could make sure in that
> > > case that the compiler can recognize that at compile time and optimize
> > > accordingly, so that it might provide some of the UP optimizations for
> > > us.)
> > > 
> > > Then, any *optimizations* for the "will only have one CPU, ever" case
> > > can move to CONFIG_NR_CPUS=1 rather than !CONFIG_SMP. I think many of
> > > those optimizations may be worth keeping for small embedded systems, or
> > > for cases like Linux-as-bootloader or similar.
> > > 
> > > The difference here would be that code written for !CONFIG_SMP today
> > > needs to account for the UP case for *correctness*, whereas code written
> > > for CONFIG_SMP can *optionally* consider CONFIG_NR_CPUS=1 for
> > > *performance*.
> > 
> > It certainly would not make much sense to keep Tiny RCU and Tiny SRCU
> > around if there was no CONFIG_SMP=n.
> 
> On the contrary, I think it's entirely appropriate to keep them for
> CONFIG_NR_CPUS=1; that's exactly the kind of simple optimization that
> seems well worth having. (Ideal optimization: "very very simple for UP,
> complex for SMP"; non-ideal optimization: "complex for SMP, differently
> complex for UP".)

Fair enough, but how does removing CONFIG_SMP help with that?  Given that
it is not all that hard to work around the lack of CONFIG_SMP for Tiny
RCU and Tiny SRCU, then it cannot be all that hard to work around that
lack for the use cases that you are trying to get rid of, right?

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcu/Kconfig b/kernel/rcu/Kconfig
index 9071182b1284b..7487bee3d4341 100644
--- a/kernel/rcu/Kconfig
+++ b/kernel/rcu/Kconfig
@@ -7,7 +7,7 @@ menu "RCU Subsystem"
 
 config TREE_RCU
 	bool
-	default y if SMP
+	default y if CONFIG_NR_CPUS = 1
 	# Dynticks-idle tracking
 	select CONTEXT_TRACKING_IDLE
 	help
@@ -31,7 +31,7 @@ config PREEMPT_RCU
 
 config TINY_RCU
 	bool
-	default y if !PREEMPTION && !SMP
+	default y if !PREEMPTION && CONFIG_NR_CPUS != 1
 	help
 	  This option selects the RCU implementation that is
 	  designed for UP systems from which real-time response
