Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9626A76AD
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 23:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjCAWQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 17:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjCAWQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 17:16:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CCA4C6EF;
        Wed,  1 Mar 2023 14:16:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A83126142F;
        Wed,  1 Mar 2023 22:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C6AC433EF;
        Wed,  1 Mar 2023 22:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677708993;
        bh=T3ouLFszvAdE0KZGRccHE35mCtsYm4+r+n4I401yIbw=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Kj4BAz7Db0WeMDNT9fFa039TuCgRcLm+43UIkq+yoFu3AqDIwAmkD2pB8JWchU46O
         UE7ytIbEeuTEt4/JXnm96HGeLvKBXtd9OtWuk0GjatNIWlSMwGI8QL6xNy/QXJr/if
         1xMg+cWR74xnGXwXHs5Jm7nTAWGUaDRn9+SU1xTjLH9942rGoVcqWvIAlGQ81KuAXf
         QY0KEnavaCCNuVA4gO/ueutoneVap1PAj0E44C7rvPQdCBaD8gdnSGefCvbF21i2y8
         qJRBLHSyZRYBBxVqVfCRRGka2VfOmoNUZLCvGmpMiOdJF9meJqFQ4bjGSt7UZ7Rkw/
         Etl+E/RqTBTyA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 9BDFB5C03F0; Wed,  1 Mar 2023 14:16:32 -0800 (PST)
Date:   Wed, 1 Mar 2023 14:16:32 -0800
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
Message-ID: <20230301221632.GI2948950@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230226110802.103134-1-usama.arif@bytedance.com>
 <20230226110802.103134-8-usama.arif@bytedance.com>
 <878rghmrn2.ffs@tglx>
 <96c0c723-9976-a222-8dc8-a5da6a1a558e@linux.intel.com>
 <Y/+2Wuunn1sIF8eT@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/+2Wuunn1sIF8eT@localhost>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 01, 2023 at 12:32:26PM -0800, Josh Triplett wrote:
> On Tue, Feb 28, 2023 at 01:02:33PM -0800, Arjan van de Ven wrote:
>   Thomas Gleixner wrote:
> > > 
> > > Maybe we should enforce CONFIG_SMP=y first :)
> > > 
> > > Thanks,
> > 
> > for 64 bit I can see the point of removing the !SMP case entirely from arch/x86 .
> > maybe even for 32 bit if it just makes the code simpler I suppose
> 
> As one of the folks keeping an eye on tinyconfig and kernel size, I
> actually think we *should* make this change and rip out !CONFIG_SMP,
> albeit carefully.
> 
> In particular, I would propose that we rip out !CONFIG_SMP, *but* we
> allow building with CONFIG_NR_CPUS=1. (And we could make sure in that
> case that the compiler can recognize that at compile time and optimize
> accordingly, so that it might provide some of the UP optimizations for
> us.)
> 
> Then, any *optimizations* for the "will only have one CPU, ever" case
> can move to CONFIG_NR_CPUS=1 rather than !CONFIG_SMP. I think many of
> those optimizations may be worth keeping for small embedded systems, or
> for cases like Linux-as-bootloader or similar.
> 
> The difference here would be that code written for !CONFIG_SMP today
> needs to account for the UP case for *correctness*, whereas code written
> for CONFIG_SMP can *optionally* consider CONFIG_NR_CPUS=1 for
> *performance*.

It certainly would not make much sense to keep Tiny RCU and Tiny SRCU
around if there was no CONFIG_SMP=n.

It should be interesting seeing what comes up out of the IoT space.  ;-)

							Thanx, Paul
