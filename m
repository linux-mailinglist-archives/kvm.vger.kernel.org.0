Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A9D4153D9
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 01:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238414AbhIVXYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 19:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbhIVXYM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 19:24:12 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD9EC061574
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 16:22:41 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id p29so18268128lfa.11
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 16:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yk3ZBWr1n5IrjSyR0cfU0vmtzd7r3a9rIjQQ1A/kKAg=;
        b=NuR7toXGRAmohK70NQ8+rh5MJHstn1edKRlUfHuMXDCyh/4jiSX3eoOPwcCQ/kXAtp
         4A7I/88gBVm0lqRdfzTaYE1wlbXdh4rYxDFyknD6AFzjhHQ6LDk1gs/io20fIR77ePDz
         YSvMW6K8/GF67iYX/JNVaqv61sdTFh0CjFsf7ejKlOW5B60MtJHTA/5T+f6QRjB+LDYp
         vKcsz5hcy0/QWSI6eM5+toi/NprVxiGknAJ5HnHUlHtg9wTym7ppshn6n+3A6u6AX66L
         kFWq49gBQ0f6w7SGqF9Ay2WKEYF6wrgy+w3CF4arSV5qy+iReJ+qj4AwhbquLWAHlmy1
         64pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yk3ZBWr1n5IrjSyR0cfU0vmtzd7r3a9rIjQQ1A/kKAg=;
        b=76xAQV5SiUEf7PTWQiKvRywEbXTnXJM781hDKwnSb3Y7UE4vw3fsgE2TJ1gg6yPJ21
         46i9SfgwIBzXkKrWTll+cYC7XiostCmRjYcFY1wZspGgF45Y7Bm2jLMR1tk8KBymDBvf
         LFDuF2+AplgpAsKln5+BERFxmfu4hVqMiYtFq72/dgFUNHVU9hMuObkB0nwJdQFUJ4S5
         EQEOEAt+jIztrPBrP+B6zQWjJThiJgr3xTErfDhsfC+yTZA5lB8k+hK91/agVJwOagFv
         F2TcjCiJDpZrd+aQz/gZNHt4O9l+71hbal3diaUlTzysw0L7FGMFB7LuOHHsAmKhMOkL
         sbNg==
X-Gm-Message-State: AOAM531FiUahPn+usW+wD5UDddpXqXxBdrlZe2s8VnFQ/OuH8vaX2KnZ
        F5uRTuWePz/1kr1mpK7xUp6KnEtLGzUeFZap6Zu/sA==
X-Google-Smtp-Source: ABdhPJzytAbhMPWX5aemlDWfYpMTXy90obCR37PCue90R2xsux+omJEqhaIYYSOZgMm9tzBFn5bjFgmBbMT77dy0a7Q=
X-Received: by 2002:a05:6512:3f91:: with SMTP id x17mr1463436lfa.518.1632352959485;
 Wed, 22 Sep 2021 16:22:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210922010851.2312845-1-jingzhangos@google.com>
 <20210922010851.2312845-3-jingzhangos@google.com> <87czp0voqg.wl-maz@kernel.org>
 <d16ecbd2-2bc9-2691-a21d-aef4e6f007b9@redhat.com> <YUtyVEpMBityBBNl@google.com>
 <875yusv3vm.wl-maz@kernel.org>
In-Reply-To: <875yusv3vm.wl-maz@kernel.org>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 22 Sep 2021 16:22:12 -0700
Message-ID: <CALzav=cuzT=u6G0TCVZUfEgAKOCKTSCDE8x2v5qc-Gd_NL-pzg@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] KVM: arm64: Add histogram stats for handling time
 of arch specific exit reasons
To:     Marc Zyngier <maz@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.cs.columbia.edu>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 11:53 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 22 Sep 2021 19:13:40 +0100,
> Sean Christopherson <seanjc@google.com> wrote:
>
> > Stepping back a bit, this is one piece of the larger issue of how to
> > modernize KVM for hyperscale usage.  BPF and tracing are great when
> > the debugger has root access to the machine and can rerun the
> > failing workload at will.  They're useless for identifying trends
> > across large numbers of machines, triaging failures after the fact,
> > debugging performance issues with workloads that the debugger
> > doesn't have direct access to, etc...
>
> Which is why I suggested the use of trace points as kernel module
> hooks to perform whatever accounting you require. This would give you
> the same level of detail this series exposes.

How would a kernel module (or BPF program) get the data to userspace?
The KVM stats interface that Jing added requires KVM to know how to
get the data when handling the read() syscall.

>
> And I'm all for adding these hooks where it matters as long as they
> are not considered ABI and don't appear in /sys/debug/tracing (in
> general, no userspace visibility).
>
> The scheduler is a interesting example of this, as it exposes all sort
> of hooks for people to look under the hood. No user of the hook? No
> overhead, no additional memory used. I may have heard that Android
> makes heavy use of this.
>
> Because I'm pretty sure that whatever stat we expose, every cloud
> vendor will want their own variant, so we may just as well put the
> matter in their own hands.

I think this can be mitigated by requiring sufficient justification
when adding a new stat to KVM. There has to be a real use-case and it
has to be explained in the changelog. If a stat has a use-case for one
cloud provider, it will likely be useful to other cloud providers as
well.

>
> I also wouldn't discount BPF as a possibility. You could perfectly
> have permanent BPF programs running from the moment you boot the
> system, and use that to generate your histograms. This isn't necessary
> a one off, debug only solution.
>
> > Logging is a similar story, e.g. using _ratelimited() printk to aid
> > debug works well when there are a very limited number of VMs and
> > there is a human that can react to arbitrary kernel messages, but
> > it's basically useless when there are 10s or 100s of VMs and taking
> > action on a kernel message requires a prior knowledge of the
> > message.
>
> I'm not sure logging is remotely the same. For a start, the kernel
> should not log anything unless something has oopsed (and yes, I still
> have some bits to clean on the arm64 side). I'm not even sure what you
> would want to log. I'd like to understand the need here, because I
> feel like I'm missing something.
>
> > I'm certainly not expecting other people to solve our challenges,
> > and I fully appreciate that there are many KVM users that don't care
> > at all about scalability, but I'm hoping we can get the community at
> > large, and especially maintainers and reviewers, to also consider
> > at-scale use cases when designing, implementing, reviewing, etc...
>
> My take is that scalability has to go with flexibility. Anything that
> gets hardcoded will quickly become a burden: I definitely regret
> adding the current KVM trace points, as they don't show what I need,
> and I can't change them as they are ABI.

This brings up a good discussion topic: To what extent are the KVM
stats themselves an ABI? I don't think this is documented anywhere.
The API itself is completely dynamic and does not hardcode a list of
stats or metadata about them. Userspace has to read stats fd to see
what's there.

Fwiw we just deleted the lpages stat without any drama.




>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
