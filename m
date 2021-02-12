Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34FF31A47A
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 19:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhBLSVq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 13:21:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhBLSVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 13:21:44 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C81C061786
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 10:21:04 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id s107so22431otb.8
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 10:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bUMsYMBNuCNJt0jRmV+9prMqZqy3gWKv3ULEMJtHZFc=;
        b=MU49D+lu466dSb70945bTHgsMfMC2eq1cUaSFdxcO4E/6sWNryZ7H61zEDV/3ph6ea
         a8VUzNvWiRhRw0diBk0zebLkRj3EByyh9m/yTyi/hmGTxjxYLJPUjmsJUlXlk3UvAp1d
         nmuRwZGai3i9lvCmQVOtErBCCcLkBIx7RFfTHlqmWmu/KuyYMXU2E/ge3GWuK8ZTYbqI
         T2kGKJGvxlz+8oQNp7igWrIfcThABqoB2DYwqYdRCMyo/cE73R2IEKNB7HJcR9/4Rt/H
         4fM9RcDgA84luZqEylE5YhnHXG/9rW3vgYGDczAzNLBm9y4Ooi4vHmZlQJP1GFdicRSH
         fVHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bUMsYMBNuCNJt0jRmV+9prMqZqy3gWKv3ULEMJtHZFc=;
        b=U8juTpQ797t9ePcl7GmtJYJaGCFX1qR3cTgDAvMAETdFy2vVWjhm4M6e7jfVS9ZVW6
         sctC24fzuMS15N0HVR1OC/d21lmvBGhBxFpDscEdATey/QoT32wJaObNRErOwTeuwZNn
         EP3k9Q4Bxfjd72vzPVXXi/NJcJNsD1ZHuej0ANKByyTrcCcqZ1hMCWk/cW1PFVF2/TF1
         LPG4ezyU8G7waiIDVCi871kwd2YlquMKyevHHMwCc1GgWavP0cHY3ka8vdopQLPeMAPk
         e2dQsx3KD4VXNSAwmZdCAISqoL6dWX8f+1p0qkMJyk3KOxXTqNGh7H3q9rvi8BjG9mDz
         mPvg==
X-Gm-Message-State: AOAM530Xg4VgWfd2CpecfCFUBWMKx/A/OuSlh49gjhfQewNPAtMb4FrU
        OUsEFc1+jDfylX+E+bUGvzU/UH15dX8W3UOR9+F3hV2nno0=
X-Google-Smtp-Source: ABdhPJw3GgljOW4FAMdpJcTdrCgaZTzs/c4rJQ9kaSRtXT5DPpcgVdd2TSyIMAWHYx22iSaIegVPmc82xx1QoLVjXt4=
X-Received: by 2002:a05:6830:902:: with SMTP id v2mr3015560ott.56.1613154063989;
 Fri, 12 Feb 2021 10:21:03 -0800 (PST)
MIME-Version: 1.0
References: <20210211212241.3958897-1-bsd@redhat.com> <ac52c9b9-1561-21cd-6c8c-dad21e9356c6@redhat.com>
 <jpgo8gpbath.fsf@linux.bootlegged.copy> <CALMp9eQ370MQ1ZPtby4ezodCga9wDeXXGTcrqoXjj03WPJOEhQ@mail.gmail.com>
 <jpg35y1f9x8.fsf@linux.bootlegged.copy>
In-Reply-To: <jpg35y1f9x8.fsf@linux.bootlegged.copy>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 12 Feb 2021 10:20:52 -0800
Message-ID: <CALMp9eSk1Ar0UB0udM050sZpGaG_OGL3kOs4LbQ+bigUr_s8CA@mail.gmail.com>
Subject: Re: [PATCH 0/3] AMD invpcid exception fix
To:     Bandan Das <bsd@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "Huang2, Wei" <wei.huang2@amd.com>,
        "Moger, Babu" <babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 12, 2021 at 9:55 AM Bandan Das <bsd@redhat.com> wrote:
>
> Jim Mattson <jmattson@google.com> writes:
>
> > On Fri, Feb 12, 2021 at 6:49 AM Bandan Das <bsd@redhat.com> wrote:
> >>
> >> Paolo Bonzini <pbonzini@redhat.com> writes:
> >>
> >> > On 11/02/21 22:22, Bandan Das wrote:
> >> >> The pcid-disabled test from kvm-unit-tests fails on a Milan host because the
> >> >> processor injects a #GP while the test expects #UD. While setting the intercept
> >> >> when the guest has it disabled seemed like the obvious thing to do, Babu Moger (AMD)
> >> >> pointed me to an earlier discussion here - https://lkml.org/lkml/2020/6/11/949
> >> >>
> >> >> Jim points out there that  #GP has precedence over the intercept bit when invpcid is
> >> >> called with CPL > 0 and so even if we intercept invpcid, the guest would end up with getting
> >> >> and "incorrect" exception. To inject the right exception, I created an entry for the instruction
> >> >> in the emulator to decode it successfully and then inject a UD instead of a GP when
> >> >> the guest has it disabled.
> >> >>
> >> >> Bandan Das (3):
> >> >>    KVM: Add a stub for invpcid in the emulator table
> >> >>    KVM: SVM: Handle invpcid during gp interception
> >> >>    KVM: SVM:  check if we need to track GP intercept for invpcid
> >> >>
> >> >>   arch/x86/kvm/emulate.c |  3 ++-
> >> >>   arch/x86/kvm/svm/svm.c | 22 +++++++++++++++++++++-
> >> >>   2 files changed, 23 insertions(+), 2 deletions(-)
> >> >>
> >> >
> >> > Isn't this the same thing that "[PATCH 1/3] KVM: SVM: Intercept
> >> > INVPCID when it's disabled to inject #UD" also does?
> >> >
> >> Yeah, Babu pointed me to Sean's series after I posted mine.
> >> 1/3 indeed will fix the kvm-unit-test failure. IIUC, It doesn't look like it
> >> handles the case for the guest executing invpcid at CPL > 0 when it's
> >> disabled for the guest - #GP takes precedence over intercepts and will
> >> be incorrectly injected instead of an #UD.
> >
> > I know I was the one to complain about the #GP, but...
> >
> > As a general rule, kvm cannot always guarantee a #UD for an
> > instruction that is hidden from the guest. Consider, for example,
> > popcnt, aesenc, vzeroall, movbe, addcx, clwb, ...
> > I'm pretty sure that Paolo has brought this up in the past when I've
> > made similar complaints.
>
> Ofcourse, even for vm instructions failures, the fixup table always jumps
> to a ud2. I was just trying to address the concern because it is possible
> to inject the correct exception via decoding the instruction.

But kvm doesn't intercept #GP, except when enable_vmware_backdoor is
set, does it? I don't think it's worth intercepting #GP just to get
this #UD right.
