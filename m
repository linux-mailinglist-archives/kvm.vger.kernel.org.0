Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F3F5F361B
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 21:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiJCTHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 15:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiJCTHS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 15:07:18 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBB43FD79
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 12:07:18 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-131fd187e35so10341957fac.7
        for <kvm@vger.kernel.org>; Mon, 03 Oct 2022 12:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jwW1l/E5rgDOPp/EOj70xffytr1/5lByZttkgb/34hg=;
        b=tCcSgJFmsf9DgRauma8dz+NE/QFDuY0ctxtQ5CsZc1vHc60+l46KjS92w809hkRPwp
         y1K74XLrm8Jk3eomM/kw424NqKifbKu9iGdzAEMGjjHDZn/MMb9DnUmVs5px/+636rMR
         ibeOjNwQEqetJ/mjdaZiStxdhzO7Wpeb6JhbM/ywqKLmHlT/fWv+D3O0QkJ9m85dtfjH
         2T0ZA3LkwkqbQlLcOgoOQCi4WfRJj0dtvZVxrDYb+p9lto+QeT4jrAk720UskLahFFcb
         pZjtIy5SFwtZCnllmSVJh9mmxOlzFO44HAnavzqV0zt30iofZbMFqR3LCfLpF7z8ILCv
         C2RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jwW1l/E5rgDOPp/EOj70xffytr1/5lByZttkgb/34hg=;
        b=QXIcMYhRcDWnxJuodaprK696cweJximuRQgNU+yRJVhChptyaZw9cEGG46O+2hsmlj
         bGiUO6Rnx4bFieWG+4OHd/RzBzHV7fet8Ooiy440eeYYsNzUuceNawUG6SeaHo+niwQF
         NhprZ2CV9+zU/hO/7da5F55j3pPhN+YiZmZsaPnzvKr6oZnoNC1ruEOn1SozgA5uyHJa
         RyD/iPjPb1JFoT9DFgFnMHPDkqPrnG+x6dHxs8eIQtrFU1hPeUsbUnawRWPlKLkdHuQY
         tCSN7fBnCZGSorgAx33O6dfWji2V+MUo3l/kXYUPvPb16m5I8g0MbDkkRfRNBEze423m
         MPXQ==
X-Gm-Message-State: ACrzQf2bmTPz8nvabQ55gsdnQJjzu6+AuUPS6i252C1H0/P0JClquuOU
        Dyodmd8XOHuMqT/LtomefFK4iEKdoS9t2cjmZaHofQ==
X-Google-Smtp-Source: AMsMyM7TFiwvYq/EOIQtcmCSDK57KT7L+e/IB/p/iQGCa8Hw3m/eeVsTdKMgGaUGT7M/oQfwgN9mgqumjkPsFnyClww=
X-Received: by 2002:a05:6870:356:b0:132:76a2:15a9 with SMTP id
 n22-20020a056870035600b0013276a215a9mr2882176oaf.13.1664824037092; Mon, 03
 Oct 2022 12:07:17 -0700 (PDT)
MIME-Version: 1.0
References: <CALMp9eRkuPPtkv7LadDDMT6DuKhvscJX0Fjyf2h05ijoxkYaoQ@mail.gmail.com>
 <20220903235013.xy275dp7zy2gkocv@treble> <CALMp9eR+sRARi8Y2=ZEmChSxXF1LEah3fjg57Mg7ZVM_=+_3Lw@mail.gmail.com>
 <CALMp9eT2mSjW3jpS4fGmCYorQ-9+YxHn61AZGc=azSEmgDziyA@mail.gmail.com>
 <20220908053009.p2fc2u2r327qyd6w@treble> <3b670574-a3bc-25d2-1237-571df009cfcc@amd.com>
In-Reply-To: <3b670574-a3bc-25d2-1237-571df009cfcc@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 3 Oct 2022 12:07:06 -0700
Message-ID: <CALMp9eT3vK7HpqD2wHKPEKWNatQu+PPuQCJYkj3e+0=79URV2A@mail.gmail.com>
Subject: Re: Guest IA32_SPEC_CTRL on AMD hosts without X86_FEATURE_V_SPEC_CTRL
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Moger, Babu" <Babu.Moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 3, 2022 at 11:56 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 9/8/22 00:30, Josh Poimboeuf wrote:
> > On Sat, Sep 03, 2022 at 08:55:04PM -0700, Jim Mattson wrote:
> >> On Sat, Sep 3, 2022 at 8:30 PM Jim Mattson <jmattson@google.com> wrote:
> >>>
> >>> On Sat, Sep 3, 2022 at 4:50 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >>>
> >>>> [*] Not 100% true - if STIBP gets disabled by the guest, there's a small
> >>>>      window of opportunity where the SMT sibling can help force a
> >>>>      retbleed attack on a RET between the MSR write and the vmrun.  But
> >>>>      that's really unrealistic IMO.
> >>>
> >>> That was my concern. How big does that window have to be before a
> >>> cross-thread attack becomes realistic, and how do we ensure that the
> >>> window never gets that large?
> >>
> >> Per https://developer.amd.com/wp-content/resources/111006-B_AMD64TechnologyIndirectBranchControlExtenstion_WP_7-18Update_FNL.pdf:
> >>
> >> When this bit is set in processors that share branch prediction
> >> information, indirect branch predictions from sibling threads cannot
> >> influence the predictions of other sibling threads.
> >>
> >> It does not say that upon clearing IA32_SPEC_CTRL.STIBP, that only
> >> *future* branch prediction information will be shared.
> >>
> >> If all existing branch prediction information is shared when
> >> IA32_SPEC_CTRL.STIBP is clear, then there is no window.
> >
> > Yes, that would be an important distinction.  If thread B can train the
> > branch predictor -- specifically targeting a retbleed attack on thread
> > A's RET insn (in the thunk) -- while STIBP is enabled, and then later
> > (when STIBP is disabled in the window before starting the guest) the
> > poisoned branch prediction info (BTB/BHB/whatever) suddenly becomes
> > visible on thread A, that makes the attack at least somewhat more
> > feasible.
> >
> > Note the return thunk gets untrained on kernel entry, so the attack
> > window is still constrained to the time between kernel entry and STIBP
> > disable.
> >
> > It sounds like that behavior may need clarification from AMD.  If that's
> > possible then it might indeed make sense to move the AMD spec_ctrl wrmsr
> > to asm like we did for Intel.
>
> Sorry, just saw this thread...
>
> Any predictions made while STIBP is enabled are local to the thread
> creating them. When STIBP is cleared, newly created predictions would be
> shared between thread A and thread B, but old/existing predictions from
> Thread B that were created while STIBP was enabled, wouldn't be used in
> thread A.

The original question was about the following scenario:

One thread is in the host kernel, processing a #VMEXIT. The other
thread is in the guest. Initially, the host kernel thread has STIBP
enabled, and the guest thread does not. All is well.

In preparation for returning to the guest, the host kernel thread
loads the guest's SPEC_CTRL value, which has STIBP clear. It does this
well in advance of the next VMRUN, the way the code is written today.

At this point, the guest thread can create shared predictions. How
quickly can it do so? Is it quick enough that we should worry about
the fact that the host kernel thread still has RET instructions to
execute before the next VMRUN?
