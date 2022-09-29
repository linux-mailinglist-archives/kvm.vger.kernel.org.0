Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262795EFC32
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 19:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbiI2RrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 13:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiI2RrS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 13:47:18 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CAB123D9C
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 10:47:16 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-131de9fddbaso1621638fac.5
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 10:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xhL6Adm+BSoN5Hr8xA8hNZEnx3IQFAvbV+n+GW0WDeA=;
        b=qF++aH5EJCkIe7TIo5VAqtOBgmJgsozfZ9ELFBw5bmjU7Gf7aRPs+QMjb5gLCDq0tE
         d2ak8a4xEj1JHRoaIhZQ0rLWlYJqIqhFQ4Xkm3QnSOKreCEM7+Sr2U7RCw62yngG1KzW
         e6J9odUfS75uR8zW1DG0/g3Dk5KzUIes/sDB9lUZeTxIVc9xG18Wul7ojkiKzTFtB4cY
         TKdpl9bi+87lnNc/yO8bvorNVo+d0vv54x91qOOzXV70zCrWTIl9iBxtTdsSnqJWDgmk
         SLoTf+jiN46sr8RTUuc6XxhiXNoPpE/DeJXV33kLCZ4du8BeahkBxLxJyaetSERi4HAD
         k2GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xhL6Adm+BSoN5Hr8xA8hNZEnx3IQFAvbV+n+GW0WDeA=;
        b=0jelqqfdgbHQ9o1Oy3pAzghTu6nqFkx5s2lWtWI/cyYHlFHJ9a6h6tsZWXfzC8QRsl
         P4VgDdy4brXTlfo/9gov7ozfkohuuc0UUQgXk0s5VMRJy7POCuQKb0zcgomHE6bGbRXd
         1OBA5pOVEPgbQ1kzeGAjYibplLc6dxC6bOrsPuQ/L8QJpFPey11r8QPjWmVsTeqHw1Cf
         HYllN31LLfhzlyk61nxDrRK2t4PTm5XIpPcpYTVYI+5J0f+40uPITNpQ/kZ+tn5XS7od
         Rk1CmUQY6Z6TBdwPKnUV7uGwJJqGmqEQ1vRvghu1eXlQe16Iu2DIYjDc6fTAf6c6h8rT
         FMkA==
X-Gm-Message-State: ACrzQf3NG9YbGKOM57LVoijwwF8JRIQlqJhbx0SlJxrYMHMMtkVcYC9e
        tL8FtCXqAFya+QMjfrnPvhIFNmmwd7SEuCkCqs9l+g==
X-Google-Smtp-Source: AMsMyM6ktHHmdF2D8G5QD1e3U+2kSShedIB0btSMPFlYK+gUfoa0qrlutwqSeYDLqXMrgFcv6WOt54jxjmPgAki0g9Y=
X-Received: by 2002:a05:6870:5250:b0:127:4360:a00b with SMTP id
 o16-20020a056870525000b001274360a00bmr9111865oai.13.1664473635795; Thu, 29
 Sep 2022 10:47:15 -0700 (PDT)
MIME-Version: 1.0
References: <CALMp9eRkuPPtkv7LadDDMT6DuKhvscJX0Fjyf2h05ijoxkYaoQ@mail.gmail.com>
 <20220903235013.xy275dp7zy2gkocv@treble> <CALMp9eR+sRARi8Y2=ZEmChSxXF1LEah3fjg57Mg7ZVM_=+_3Lw@mail.gmail.com>
 <CALMp9eT2mSjW3jpS4fGmCYorQ-9+YxHn61AZGc=azSEmgDziyA@mail.gmail.com> <20220908053009.p2fc2u2r327qyd6w@treble>
In-Reply-To: <20220908053009.p2fc2u2r327qyd6w@treble>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 29 Sep 2022 10:47:04 -0700
Message-ID: <CALMp9eQ9A0qGS5RQjkX0HKdsUq3y5nKHFZQ=AVdfNOxxDPC65Q@mail.gmail.com>
Subject: Re: Guest IA32_SPEC_CTRL on AMD hosts without X86_FEATURE_V_SPEC_CTRL
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     kvm list <kvm@vger.kernel.org>,
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

On Wed, Sep 7, 2022 at 10:30 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>
> On Sat, Sep 03, 2022 at 08:55:04PM -0700, Jim Mattson wrote:
> > On Sat, Sep 3, 2022 at 8:30 PM Jim Mattson <jmattson@google.com> wrote:
> > >
> > > On Sat, Sep 3, 2022 at 4:50 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > >
> > > > [*] Not 100% true - if STIBP gets disabled by the guest, there's a small
> > > >     window of opportunity where the SMT sibling can help force a
> > > >     retbleed attack on a RET between the MSR write and the vmrun.  But
> > > >     that's really unrealistic IMO.
> > >
> > > That was my concern. How big does that window have to be before a
> > > cross-thread attack becomes realistic, and how do we ensure that the
> > > window never gets that large?
> >
> > Per https://developer.amd.com/wp-content/resources/111006-B_AMD64TechnologyIndirectBranchControlExtenstion_WP_7-18Update_FNL.pdf:
> >
> > When this bit is set in processors that share branch prediction
> > information, indirect branch predictions from sibling threads cannot
> > influence the predictions of other sibling threads.
> >
> > It does not say that upon clearing IA32_SPEC_CTRL.STIBP, that only
> > *future* branch prediction information will be shared.
> >
> > If all existing branch prediction information is shared when
> > IA32_SPEC_CTRL.STIBP is clear, then there is no window.
>
> Yes, that would be an important distinction.  If thread B can train the
> branch predictor -- specifically targeting a retbleed attack on thread
> A's RET insn (in the thunk) -- while STIBP is enabled, and then later
> (when STIBP is disabled in the window before starting the guest) the
> poisoned branch prediction info (BTB/BHB/whatever) suddenly becomes
> visible on thread A, that makes the attack at least somewhat more
> feasible.
>
> Note the return thunk gets untrained on kernel entry, so the attack
> window is still constrained to the time between kernel entry and STIBP
> disable.
>
> It sounds like that behavior may need clarification from AMD.  If that's
> possible then it might indeed make sense to move the AMD spec_ctrl wrmsr
> to asm like we did for Intel.

On the other side of the transition, restoration of the host
IA32_SPEC_CTRL value is definitely way too late. With respect to the
user/kernel boundary, AMD says, "If software chooses to toggle STIBP
(e.g., set STIBP on kernel entry, and clear it on kernel exit),
software should set STIBP to 1 before executing the return thunk
training sequence." I assume the same requirements apply to the
guest/host boundary. The return thunk training sequence is in
vmenter.S, quite close to the VM-exit. On hosts without V_SPEC_CTRL,
the host's IA32_SPEC_CTRL value is not restored until much later.
