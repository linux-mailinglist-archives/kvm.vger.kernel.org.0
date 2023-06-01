Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15CCF718F95
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 02:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbjFAAmI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 20:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjFAAmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 20:42:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24427123;
        Wed, 31 May 2023 17:42:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B546C63B8E;
        Thu,  1 Jun 2023 00:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77374C433EF;
        Thu,  1 Jun 2023 00:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685580125;
        bh=QkqbhcDF+pePoD2TNskyYwxfYiTvfX92sxcQEnCW/OQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Iq745KawOqer46I4sbFStKnkH553BxrLo/IZbhCWXZ7S4L5zSYWeO8Q0Rg5Bm4rk3
         kB0/A9X9I0mxk3O1Wc3wFiM+7GzvyRVmuvYR/BWi4nTc6kGqsZVMCCeUPVDQiOiPsc
         TLL/eJ+g0AJctxcsP4SMeFIab6k4a1ojYhCGH2PceqDPXrgeVI0abfb0Pc5qNadw2b
         QdCNPUA2i9rEAwj6zME8FxYJ8boKpMUlsfJDqipm3/3NK0yEYRw+5zEvhqIV/BM5HP
         qdUsOi0z9GI9Q2KCdu59IbgH/heA9cIOBDTv+JigOBDsC07z/GYz/L38N2SHP9rLpO
         r12AdJxg9vS2w==
Date:   Wed, 31 May 2023 17:42:02 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
Message-ID: <20230601004202.63yulqs73kuh3ep6@treble>
References: <20230531150112.76156-1-jon@nutanix.com>
 <20230531231820.trrs2uugc24gegj4@treble>
 <F4BEBCAF-CBFC-4C3E-8B01-2ED84CF2E13A@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F4BEBCAF-CBFC-4C3E-8B01-2ED84CF2E13A@nutanix.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023 at 11:58:12PM +0000, Jon Kohler wrote:
> > The goal of this barrier_nospec() is to prevent speculative execution
> > from bypassing the SPEC_CTRL write (due to misprediction of the
> > conditional branch, Spectre v1 style).  Otherwise the next indirect
> > branch or unbalanced RET could be an attack target.
> > 
> > So any previous LFENCEs before that conditional branch won't help here.
> 
> Ah interesting. Ok, to be clear, thats a guest -> host attack, correct? And such
> an attack would not at all be thwarted by the first CALL retire + LFENCE that
> was added on commit 2b1299322016 ("x86/speculation: Add RSB VM Exit 
> protections”)?

Right.

> Sorry to be long winded, just wanting to triple check because
> the aforementioned commit was added slightly after the original one, and I 
> want to make extra sure that they aren’t solving the same thing.
> 
> If that is indeed the case, does that commit need to be revisited at all?
> 
> Or are we saying that this Intel vulnerability needs *two* LFENCE’s to keep
> the host secure?

The first LFENCE (FILL_RETURN_BUFFER) forces the CALL to retire so the
RSB stuff is guaranteed to take effect before the next unbalanced RET
can be speculatively executed.

The second LFENCE (vmx_spec_ctrl_restore_host) forces the conditional
branch to retire so the SPEC_CTRL write (potential IBRS/eIBRS
enablement) is guaranteed to take effect before the next indirect branch
and/or unbalanced RET can be speculatively executed.

So each LFENCE has a distinct purpose.  That said, there are no indirect
branches or unbalanced RETs between them.  So it should be fine to
combine them into a single LFENCE after both.

You could for example just remove the first LFENCE.  But only for that
usage site, i.e. not for other users of FILL_RETURN_BUFFER.

Or, remove them both and add an LFENCE in vmx_vmexit() right after the
call to vmx_spec_ctrl_restore_host().  That might be clearer.  Then it
could have a comment describing its dual purposes.

-- 
Josh
