Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FE63F3406
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 20:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbhHTSnX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 14:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhHTSnW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 14:43:22 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D02C061756
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 11:42:43 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id g20so3827366lfr.7
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 11:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YIxdmdOK93PDI+3/pOtlT4h8TOVvTfwI7jxbnF4v/8I=;
        b=o8+3gnoBM3c+ATq9Vukii1eFIe61G3lGZOFUEDDzxuzH4ztaiJQwabCRtO1Y9Wm3Wx
         FeLKuAWt9M6Bel3wmTw69OZQibdUIA4T6ACOyfZrmF/PiPU6/0BvFlD9N5lElCd9DqLM
         aVsOXyN1vB4L/WCboQnqaua428UHP+AB9k/pPBNoD6JT64wIHdPh6IEtjjFIlfAWCEWA
         iINuZPiGwHcmDpe4DlFm83lgOKyhL5FnPmmcty0vZvq7q/PBiU20ODxOPSWFVubXZTNR
         JXVNNLAzzkM0qgLsWtuFCvCcV6DKJeMN1aurlKyK2FKy80sP7apxRPdV3GyWoHDkHAoh
         BBSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YIxdmdOK93PDI+3/pOtlT4h8TOVvTfwI7jxbnF4v/8I=;
        b=lgv1c3B4+yMgB/EvXYZWvGYVDddPhBSrw/mEgK0smxF58rFOjZyPZfLsIHC97sFITs
         zsrqRgZPMXpTI1ywAtjbOkzMPhVvyuGbbz+BZbKq6NXZNal0IKrilG7ml85I5YkAeS7/
         KiUKibuKpDJ4XQ65a5K0oLSJclGyz6AxgqrPqY/BIl/+2rHYKzXGpVyjgmw5RfVgOFw5
         oL2n/2yZB1PibyFbgVm8PtTkBMLc9YNCLH+qNCLqJM5DzpqcX/KN6WGU46LYBnehJw3D
         J63l3CRv+qCfU2akF/LeCce6CYQd2GNooSXHQdkjbZyvv6d4s/I/BJyh1J7yODzoos5Y
         9C3g==
X-Gm-Message-State: AOAM532aYK+QZ2/hYI64HTKkQqQIcD65Hgru5auxCBxFJwkZ2He2mlfI
        h6zzzdI7DDI3VGvXLEFPUewOQ0WfhP2ONw4GIHgp6A==
X-Google-Smtp-Source: ABdhPJxGSQkui+u6oxP9qSpGFHbnvSHr9Xx5ldGdIeKBFFyQ3Iw8ZMHKcOvlSq/HVIZhncng4jucqhE/Hx0YmGcMcsk=
X-Received: by 2002:ac2:5324:: with SMTP id f4mr16017789lfh.106.1629484961611;
 Fri, 20 Aug 2021 11:42:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210817230508.142907-1-jingzhangos@google.com>
 <YRxKZXm68FZ0jr34@google.com> <CAAdAUthw0gT2_K+WzkWeEHApGqM14qpH+kuoO6WZBnjvez6ZAg@mail.gmail.com>
 <CAJfu=UcwHWzqCvTjniAMkGj1mmjw9QCy5a-fGJ2mxTK8EFW7Dg@mail.gmail.com> <YR7dJflS7yBR52tL@google.com>
In-Reply-To: <YR7dJflS7yBR52tL@google.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Fri, 20 Aug 2021 11:42:30 -0700
Message-ID: <CAAdAUtj-Y_MuaeqAHKonNTBDR=kjjmWP__Siqjv5=AxvZbe-Bw@mail.gmail.com>
Subject: Re: [PATCH] KVM: stats: add stats to detect if vcpu is currently halted
To:     Sean Christopherson <seanjc@google.com>
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On Thu, Aug 19, 2021 at 3:37 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Aug 18, 2021, Cannon Matthews wrote:
> > Since a guest has explictly asked for a vcpu to HLT, this is "useful work on
> > behalf of the guest" even though the thread is "blocked" from running.
> >
> > This allows answering questions like, are we spending too much time waiting
> > on mutexes, or long running kernel routines rather than running the vcpu in
> > guest mode, or did the guest explictly tell us to not doing anything.
> >
> > So I would suggest keeping the "halt" part of the counters' name, and remove
> > the "blocked" part rather than the other way around. We explicitly do not
> > want to include non-halt blockages in this.
>
> But this patch does include non-halt blockages, which is why I brought up the
> technically-wrong naming.  Specifically, x86 reaches this path for any !RUNNABLE
> vCPU state, e.g. if the vCPU is in WFS.  Non-x86 usage appears to mostly call
> this for halt-like behavior, but PPC looks like it has at least one path that's
> not halt-like.
>
> I doubt anyone actually cares if the stat is a misnomer in some cases, but at the
> same time I think there's opportunity for clean up here.  E.g. halt polling if a
> vCPU is in WFS or UNINITIALIZED is a waste of cycles.  Ditto for the calls to
> kvm_arch_vcpu_blocking() and kvm_arch_vcpu_unblocking() when halt polling is
> successful, e.g. arm64 puts and reloads the vgic, which I assume is a complete
> waste of cycles if the vCPU doesn't actually block.  And kvm_arch_vcpu_block_finish()
> can be dropped by moving the one line of code into s390, which can add its own
> wrapper if necessary.
>
> So with a bit of massaging and a slight change in tracing behavior, I believe we
> can isolate the actual wait/halt and avoid "halted" being technically-wrong, and
> fix some inefficiencies at the same time.
>
> Jing, can you do a v2 of this patch and send it to me off-list?  With luck, my
> idea will work and I can fold your patch in, and if not we can always post v2
> standalone in a few weeks.
Of course, will do.
Thanks,
Jing
>
> E.g. I'm thinking something like...
>
> void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
> {
>         vcpu->stat.generic.halted = 1;
>
>         if (<halt polling failed>)
>                 kvm_vcpu_block();
>
>         vcpu->stat.generic.halted = 0;
>
>         <update halt polling stuff>
> }
>
> void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> {
>         bool waited = false;
>         ktime_t start, cur;
>         u64 block_ns;
>
>         start = ktime_get();
>
>
>         prepare_to_rcuwait(&vcpu->wait);
>         for (;;) {
>                 set_current_state(TASK_INTERRUPTIBLE);
>
>                 if (kvm_vcpu_check_block(vcpu) < 0)
>                         break;
>
>                 waited = true;
>                 schedule();
>         }
>         finish_rcuwait(&vcpu->wait);
>
>         block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
>         trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
> }
>
