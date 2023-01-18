Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3AB671245
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 04:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjARD4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 22:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjARD4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 22:56:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864E954227;
        Tue, 17 Jan 2023 19:56:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FA776160E;
        Wed, 18 Jan 2023 03:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78111C433D2;
        Wed, 18 Jan 2023 03:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674014189;
        bh=GqWHxua0L6lPQIAKNKiopte/74IpSnqlqs2H7TJq2CY=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=IsHlAjKa0F21eCJONlHnQ09ZgmN3Ee1N/60k4+a1P9S1q8BgaBbWNPXkmkx7jsT4L
         GqL7yV9k5hPlNt0zIFq0VDALvsKynyX9yvNru//R2857HCbm/CIKUSlCSzwH7tzfhg
         uS5CEVlF2W+p8rSoPdkaB2x/GeAtrNbImkFwFPPyzC+kbqrU14yahamYETyTnxNAcZ
         UDjCKvXutsebE6Vdn/J21JpxtGjyTF7Wn4xovwCGuGqbJOuhYOOt9vVN7OnAPWv5hy
         fsBcalCiLh2ODwqVdwI52Gv7BGT8FMiviv6R85bU4DoMcmw3U0aoM1aQAD7SMP2i+6
         V+zXgzmkVileA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 2A9985C1052; Tue, 17 Jan 2023 19:56:29 -0800 (PST)
Date:   Tue, 17 Jan 2023 19:56:29 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@meta.com, rostedt@goodmis.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH rcu v2 17/20] kvm: Remove "select SRCU"
Message-ID: <20230118035629.GT2948950@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230113001103.GA3374173@paulmck-ThinkPad-P17-Gen-1>
 <20230113001132.3375334-17-paulmck@kernel.org>
 <Y8dLCJKXn5fL/2Iq@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8dLCJKXn5fL/2Iq@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 18, 2023 at 01:27:36AM +0000, Sean Christopherson wrote:
> On Thu, Jan 12, 2023, Paul E. McKenney wrote:
> > Now that the SRCU Kconfig option is unconditionally selected, there is
> > no longer any point in selecting it.  Therefore, remove the "select SRCU"
> > Kconfig statements from the various KVM Kconfig files.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > Cc: Huacai Chen <chenhuacai@kernel.org>
> > Cc: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> > Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > Cc: Michael Ellerman <mpe@ellerman.id.au>
> > Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: <kvm@vger.kernel.org>
> > Acked-by: Marc Zyngier <maz@kernel.org> (arm64)
> > Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
> > Acked-by: Anup Patel <anup@brainfault.org> (riscv)
> > Acked-by: Heiko Carstens <hca@linux.ibm.com> (s390)
> > Reviewed-by: John Ogness <john.ogness@linutronix.de>
> > ---
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> 
> 
> Ugh, my apologies Paul.  I didn't realize 0cd7e350abc4 ("rcu: Make SRCU mandatory")
> is already in Linus' tree, i.e. bundling this in a single patch was unnecessary work
> for you.
> 
> Anyways, since there isn't an external dependency, this can go through the KVM
> tree.  Unless you prefer to take it directly, I'll make sure Paolo sends it along
> at some point before v6.2 final.

I am very happy to have you guys take it.  Just let me know when you
have it in place, and I will drop my copy on my next rebase after that.

							Thanx, Paul
