Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B716328654D
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 18:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgJGQxd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 12:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728046AbgJGQxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 12:53:31 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72C8C0613D2
        for <kvm@vger.kernel.org>; Wed,  7 Oct 2020 09:53:30 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id d197so3139848iof.0
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 09:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nDdFpy68M4qcIzjp5XTKty3VRwf5DXuMbkrk++kW+nE=;
        b=NJ+883kU7p70HCRlrjwPHALnKwuBGBHt5ndHWo0n/reWd61Gz99+NtoeWL1TUkeMzg
         lhuT7M+Z13S6MZjZD0m9uVCbRSWrts7qvF32MDIGkygCzj8/vkosUGfrOCsbZMQnb/eP
         z8AKbViiBxfxSd1TSGjNym04Z/Ma654XyzTLahNgEUwQFoS0hEEbBXFGjvROrFSZJDMP
         InC71Do8rR55zxc83vTXNtr8MFiqCSSu2o7EzRTWYcrOwBfZ9J3kzWC20uHjYEA26/Dj
         oyZSkNxE3W64MAm/+ZQ0ErgTRbTUBsTvbVgYvARD/mei0aehqIsUsjoCt+HnfHrs4LQc
         HcFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nDdFpy68M4qcIzjp5XTKty3VRwf5DXuMbkrk++kW+nE=;
        b=Ikg6CKGTosZWnWHQ3h/0ykfGzvJlFSUeriJRmlT65FcHVJdFvDU40+a1f//mzyu6o/
         /tVRf6H7xz31FSMgtYwPVj8AK82cSwZmFD5qnjQy6S9I2CCMolH/ayqeKwoBB+I9jpP3
         VTKfQ/8k7VO2BedBpLm2AyKNceqygE/rfhyxM2podPI7D538JMEpJ9kRaaj0BEPRSfZ7
         baBkmiQtNWQBDivhX5qWa3p8ECPNZq8B7plJBzO1ozDYzoIBcr970tdNEhoLMHTpzl7J
         PGMu1ZKNMTSD3crs0Ahmr7UnNw6ONCdx3ERpdHKdH9GXSN38qX4Nw6668XsY+c6E/9OR
         lq1g==
X-Gm-Message-State: AOAM532SBAxwSgQl0y759F1FASBpBYPk7Wd+76xZhNzoRlKKIauWMubT
        ViUKvSvsMQ/t/uP6TG67YIbRbf5f3t6d2skm7ak9LA==
X-Google-Smtp-Source: ABdhPJwp528UTrs90kH7IE/N22tb1FxHWMWLbTdbd9+bm42WHqsss518ZxHYih9DuwjZtt8PY+Um/SGTyOmRCXwJe6I=
X-Received: by 2002:a05:6638:1508:: with SMTP id b8mr3620771jat.25.1602089609707;
 Wed, 07 Oct 2020 09:53:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com> <20200925212302.3979661-16-bgardon@google.com>
 <622ffc59-d914-c718-3f2f-952f714ac63c@redhat.com>
In-Reply-To: <622ffc59-d914-c718-3f2f-952f714ac63c@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 7 Oct 2020 09:53:18 -0700
Message-ID: <CANgfPd_8SpHkCd=NyBKtRFWKkczx4SMxPLRon-kx9Oc6P7b=Ew@mail.gmail.com>
Subject: Re: [PATCH 15/22] kvm: mmu: Support changed pte notifier in tdp MMU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 28, 2020 at 8:11 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 25/09/20 23:22, Ben Gardon wrote:
> > +             *iter.sptep = 0;
> > +             handle_changed_spte(kvm, as_id, iter.gfn, iter.old_spte,
> > +                                 new_spte, iter.level);
> > +
>
> Can you explain why new_spte is passed here instead of 0?

That's just a bug. Thank you for catching it.

>
> All calls to handle_changed_spte are preceded by "*something =
> new_spte" except this one, so I'm thinking of having a change_spte
> function like
>
> static void change_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>                         u64 *sptep, u64 new_spte, int level)
> {
>         u64 old_spte = *sptep;
>         *sptep = new_spte;
>
>         __handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level);
>         handle_changed_spte_acc_track(old_spte, new_spte, level);
>         handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte, new_spte, level);
> }
>
> in addition to the previously-mentioned cleanup of always calling
> handle_changed_spte instead of special-casing calls to two of the
> three functions.  It would be a nice place to add the
> trace_kvm_mmu_set_spte tracepoint, too.

I'm not sure we can avoid special casing calls to the access tracking
and dirty logging handler functions. At least in the past that's
created bugs with things being marked dirty or accessed when they
shouldn't be. I'll revisit those assumptions. It would certainly be
nice to get rid of that complexity.

I agree that putting the SPTE assignment and handler functions in a
helper function would clean up the code. I'll do that. I got some
feedback on the RFC I sent last year which led me to open-code a lot
more, but I think this is still a good cleanup.

Re tracepoints, I was planning to just insert them all once this code
is stabilized, if that's alright.

>
> Paolo
>
