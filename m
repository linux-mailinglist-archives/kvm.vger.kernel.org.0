Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43627205AED
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 20:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387425AbgFWSj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 14:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733295AbgFWSj2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 14:39:28 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95D2C061755
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 11:39:28 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t8so20437875ilm.7
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 11:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MMSXyImcuZBfchMfbTmyyDTCpqvru9kfQ2n1P5epXmU=;
        b=E5nOfASCg0KLZfYJnx0RJBrvw0hgcvN7agf/yEALoOKoOyqGyeo3GlF7vqZCUrEiIG
         jRd0GMymTl2YWbQTClWJejZ5GGd///O97/aV/0gtqbPe5RnmLLIOkGdYXAVQuNqHCqs7
         ZvH1YD9BnuVTb5ug86OCQpg7SBm54T6Cy9VdyUdQu8MMK7RQeBSIIkt2eXu7hp136ZOI
         ilAkCuJ85pz6Wuh+oiozpw0Pz0+MgkDbQw1UsJjqUeHepSjJyrvwKSUUYGggdNv17iCe
         iHkPhSEhV5F8Z1v96uSmRoU0pvlttTsVgI7o/GnpsV1WTeIeJRue/PFkFMQoaMJ8VIf7
         ErLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MMSXyImcuZBfchMfbTmyyDTCpqvru9kfQ2n1P5epXmU=;
        b=A4Fe4KWIYUhuxYBdzcXVAamAp5PAAgTU1kyiqJUSzMsy5bWeLD/4tQNQHUgHXhfYrF
         AFYCap+UdrGroIUJ7As7qt/c/IHKHZ70rhY0M19YYUuny8QRUXchZvHxyHL2TmGCaqz4
         AKJ4kkDf2Y5KQj2kUxRyV5x6SryPifVs5dLqXg7UH78AHWdfp7NqgQEE7yqfCf+137eH
         doe+xP3CP/TiIVPcAsLQX3EUf7nxRYf2DGIZSjWPm1dc6uU9l0z7CtZL+pHk1sqVN8LN
         LvVWvKejSRDf241+RirJtv4k2b3SBulV9AiByXryhDA0Nlr9rThq8YETRcjMqPl0+BOV
         tVQg==
X-Gm-Message-State: AOAM532b2pLFXZ3YTsJ6L7VoSD0H7DUoroBVLf6ii9AD2QGncXaiP331
        y/V0gy7qt3QbSGIR53HZPDbdG/Op5zlKt4vbC9TEwg==
X-Google-Smtp-Source: ABdhPJzaVCgxNpWBznUqrKseKsAXasxfjsVvnbxT8NFZdObtFa5g4xVCLJ/cORy0Q5LOHjGD4eSddehMr0u4RWuZigw=
X-Received: by 2002:a05:6e02:cd:: with SMTP id r13mr18549799ilq.119.1592937567599;
 Tue, 23 Jun 2020 11:39:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200623063530.81917-1-like.xu@linux.intel.com> <20200623182910.GA24107@linux.intel.com>
In-Reply-To: <20200623182910.GA24107@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 23 Jun 2020 11:39:16 -0700
Message-ID: <CALMp9eQPA40FWBEOiQ8T5JX2fv+uEfU_x6js8WhAguQ8TL6frA@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Emulate APERF/MPERF to report actual VCPU frequency
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, wei.huang2@amd.com,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Li RongQing <lirongqing@baidu.com>,
        Chai Wen <chaiwen@baidu.com>, Jia Lina <jialina01@baidu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 11:29 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Jun 23, 2020 at 02:35:30PM +0800, Like Xu wrote:
> > The aperf/mperf are used to report current CPU frequency after 7d5905dc14a
> > "x86 / CPU: Always show current CPU frequency in /proc/cpuinfo". But guest
> > kernel always reports a fixed VCPU frequency in the /proc/cpuinfo, which
> > may confuse users especially when turbo is enabled on the host.
> >
> > Emulate guest APERF/MPERF capability based their values on the host.
> >
> > Co-developed-by: Li RongQing <lirongqing@baidu.com>
> > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > Reviewed-by: Chai Wen <chaiwen@baidu.com>
> > Reviewed-by: Jia Lina <jialina01@baidu.com>
> > Signed-off-by: Like Xu <like.xu@linux.intel.com>
> > ---
>
> ...
>
> > @@ -8312,7 +8376,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >               dm_request_for_irq_injection(vcpu) &&
> >               kvm_cpu_accept_dm_intr(vcpu);
> >       fastpath_t exit_fastpath;
> > -
> > +     u64 enter_mperf = 0, enter_aperf = 0, exit_mperf = 0, exit_aperf = 0;
> >       bool req_immediate_exit = false;
> >
> >       if (kvm_request_pending(vcpu)) {
> > @@ -8516,8 +8580,17 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >               vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
> >       }
> >
> > +     if (unlikely(vcpu->arch.hwp.hw_coord_fb_cap))
> > +             get_host_amperf(&enter_mperf, &enter_aperf);
> > +
> >       exit_fastpath = kvm_x86_ops.run(vcpu);
> >
> > +     if (unlikely(vcpu->arch.hwp.hw_coord_fb_cap)) {
> > +             get_host_amperf(&exit_mperf, &exit_aperf);
> > +             vcpu_update_amperf(vcpu, get_amperf_delta(enter_aperf, exit_aperf),
> > +                     get_amperf_delta(enter_mperf, exit_mperf));
> > +     }
> > +
>
> Is there an alternative approach that doesn't require 4 RDMSRs on every VMX
> round trip?  That's literally more expensive than VM-Enter + VM-Exit
> combined.
>
> E.g. what about adding KVM_X86_DISABLE_EXITS_APERF_MPERF and exposing the
> MSRs for read when that capability is enabled?

When would you load the hardware MSRs with the guest/host values?
