Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5F95B140F
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 07:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiIHFaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 01:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiIHFaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 01:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0142B474E6
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 22:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21845B81FA8
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 05:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A5AC433C1;
        Thu,  8 Sep 2022 05:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662615011;
        bh=zsMeKE1D7WudXd7oqTe2LsHtqZyZWxFaEKXZRnNz1z4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hCY4a03NS8JxFovloUKxelnYNtgnwo+lwyBGukOzfCqFwKoHx6AuMCcz6ked0lysP
         6YygRKxr0Qm/Oxre3LiNGLWzaYN1wftP/lJnLMo6puAwOYY0GJHM5j5p3RFVeRm01P
         /KoWY73yd+ryCW8d+GexELHE84AEh4EVr7pX5Ar9bghm2VJlQb8Wvh4MYUceEeHzlc
         vMViQEEOMaZDiAdqglbsoOq3R9LQH/W53FxGLSjY0yxhjNLQKNDrPcNGs/jHCjyPGV
         wYR6hYwA3r32fevTd34CxO75wGFii3Ctd+XxxxrL4rYra8wnWqSQfSErEm94+uuwWW
         udvQIW6qrdTdg==
Date:   Wed, 7 Sep 2022 22:30:09 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Moger, Babu" <Babu.Moger@amd.com>
Subject: Re: Guest IA32_SPEC_CTRL on AMD hosts without X86_FEATURE_V_SPEC_CTRL
Message-ID: <20220908053009.p2fc2u2r327qyd6w@treble>
References: <CALMp9eRkuPPtkv7LadDDMT6DuKhvscJX0Fjyf2h05ijoxkYaoQ@mail.gmail.com>
 <20220903235013.xy275dp7zy2gkocv@treble>
 <CALMp9eR+sRARi8Y2=ZEmChSxXF1LEah3fjg57Mg7ZVM_=+_3Lw@mail.gmail.com>
 <CALMp9eT2mSjW3jpS4fGmCYorQ-9+YxHn61AZGc=azSEmgDziyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALMp9eT2mSjW3jpS4fGmCYorQ-9+YxHn61AZGc=azSEmgDziyA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 03, 2022 at 08:55:04PM -0700, Jim Mattson wrote:
> On Sat, Sep 3, 2022 at 8:30 PM Jim Mattson <jmattson@google.com> wrote:
> >
> > On Sat, Sep 3, 2022 at 4:50 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > > [*] Not 100% true - if STIBP gets disabled by the guest, there's a small
> > >     window of opportunity where the SMT sibling can help force a
> > >     retbleed attack on a RET between the MSR write and the vmrun.  But
> > >     that's really unrealistic IMO.
> >
> > That was my concern. How big does that window have to be before a
> > cross-thread attack becomes realistic, and how do we ensure that the
> > window never gets that large?
> 
> Per https://developer.amd.com/wp-content/resources/111006-B_AMD64TechnologyIndirectBranchControlExtenstion_WP_7-18Update_FNL.pdf:
> 
> When this bit is set in processors that share branch prediction
> information, indirect branch predictions from sibling threads cannot
> influence the predictions of other sibling threads.
> 
> It does not say that upon clearing IA32_SPEC_CTRL.STIBP, that only
> *future* branch prediction information will be shared.
> 
> If all existing branch prediction information is shared when
> IA32_SPEC_CTRL.STIBP is clear, then there is no window.

Yes, that would be an important distinction.  If thread B can train the
branch predictor -- specifically targeting a retbleed attack on thread
A's RET insn (in the thunk) -- while STIBP is enabled, and then later
(when STIBP is disabled in the window before starting the guest) the
poisoned branch prediction info (BTB/BHB/whatever) suddenly becomes
visible on thread A, that makes the attack at least somewhat more
feasible.

Note the return thunk gets untrained on kernel entry, so the attack
window is still constrained to the time between kernel entry and STIBP
disable.

It sounds like that behavior may need clarification from AMD.  If that's
possible then it might indeed make sense to move the AMD spec_ctrl wrmsr
to asm like we did for Intel.

-- 
Josh
