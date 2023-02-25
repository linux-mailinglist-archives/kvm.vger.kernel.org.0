Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21C906A2557
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 01:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjBYAJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 19:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjBYAJi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 19:09:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8194365330;
        Fri, 24 Feb 2023 16:09:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3487AB81D69;
        Sat, 25 Feb 2023 00:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F218C433D2;
        Sat, 25 Feb 2023 00:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677283774;
        bh=RECK9lZ040VDapm9jACPtKxrwZ3B3mKnm5zxgCnxXTI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PIIzlP5FGApfltmgGEWd810KQSx8gJQZHS6T/9Q9mgE90h4HY1PePGrZ4T5b91O7U
         N7b1N+mhdVbL2Ge3ajierfPjSnSI4tVXqvlkQ2GosAYyFv0OjUueSbSrHxBiZvcbN1
         fROVMQNC0fd5uGhxQMmJTInomULvbhqA1p0dKI/rAKXAtFZvyv3OBtmIGSkAZww0Hl
         43HQ1V/Di793m7/vnjUX9Rr89wh+zdaxAIWOcuXg9lrBboZvAcokip2VBfMuyTgnux
         f3E3j/d0u0FCbtc+3UL08Z2y7CzX9Tv2SvE16fvf1z1dEEiTfQ+8c5el1+6qvWpJ1q
         rDbc9n1sqJrjw==
Date:   Fri, 24 Feb 2023 16:09:31 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kim Phillips <kim.phillips@amd.com>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 7/8] x86/cpu: Support AMD Automatic IBRS
Message-ID: <20230225000931.wrednfun4jifkqau@treble>
References: <20230124163319.2277355-1-kim.phillips@amd.com>
 <20230124163319.2277355-8-kim.phillips@amd.com>
 <20230224185257.o3mcmloei5zqu7wa@treble>
 <Y/knUC0s+rg6ef2r@zn.tnic>
 <Y/k/ZXUXOFiBhOiI@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y/k/ZXUXOFiBhOiI@zn.tnic>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 24, 2023 at 11:51:17PM +0100, Borislav Petkov wrote:
> On Fri, Feb 24, 2023 at 10:08:32PM +0100, Borislav Petkov wrote:
> > On Fri, Feb 24, 2023 at 10:52:57AM -0800, Josh Poimboeuf wrote:
> > > Doesn't this only enable it on the boot CPU?
> > 
> > Whoops, you might be right.
> 
> Actually, we stick that MSR - EFER - into the trampoline header and then
> each AP gets it written to in arch/x86/realmode/rm/trampoline_64.S
> 
> But this is only from code staring - I'll confirm this tomorrow.

Ah, I had to stare it that for a bit to figure out how it works.
setup_real_mode() reads MSR_EFER from the boot CPU and stores it in
trampoline_header->efer.  Then the other CPUs read that stored value in
startup_32() and write it into their MSR.

> And if so, we should at least put comments in that trampoline code so
> that people do not remove the MSR writes.
> 
> Or, actually, we should simply write it again because it is the init
> path and not really a hot path but it should damn well make sure that
> that bit gets set.

Yeah, I think that would be good.  Otherwise it's rather magical.  That
EFER MSR is a surprising place to put that bit.

-- 
Josh
