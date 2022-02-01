Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6064A5DCB
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 14:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238953AbiBAN5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 08:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237337AbiBAN5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 08:57:30 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964AFC061714;
        Tue,  1 Feb 2022 05:57:30 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id r65so51086903ybc.11;
        Tue, 01 Feb 2022 05:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gmPaQg3ZV/NzjWszRhN/vx7xYoj6dJ6Nz9nhp20TkY0=;
        b=kxws1Bm7isRqI/ht4fr4+gcveANEX49JWqnYr8dQe7mNzd+IDdPb5AmSwscJwZ6Ona
         qbIhviualk8JNHmt5RwpviIdNsuOAJxoQ3Gcs7UJnuzqiB9XPwUAZeJSv21PCc9/JLQn
         WtHo1LKNcmbc/M90TAUUx7pBQ4Zw1pkjUOoOJ25sjwYonIGGXCtXcbT74gfw8o406Eg+
         UyvxoAEQNjK2yATWp0pn+c7uIynv/ohql2a3DY1H2g9DdhquMvJV3JlMlQODBYDmhrP9
         RCGAaVGOjY56g0NQtBx2iHYGBp/qv6t4aGaAe1hI3b1sxTQLt2rm6oWtcHN3R89dLHl6
         R4Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gmPaQg3ZV/NzjWszRhN/vx7xYoj6dJ6Nz9nhp20TkY0=;
        b=2+NmE9aQeDCRgteaPZL37+O0vbmefkgEguml+afe7rm0BWAo+pFxHaIkZureURBFYV
         oYXpdfqLAPjEyFMirpE0MEiLIK7PV+haEuJ8cFxpLSFYJ/y+5iKpljNSssq5Q83+UXYg
         EiiZtZ9NjJC1SMjqnFfYcA1tuYY/2+CZcqEO5r1YqB8Chn1ET77QF8wsJCsMaP9BnRdt
         Vb7xJEFGVeKr3+760kjp1Rat5JpLArejaWonmpp99kMhneKDm+/8CyXtvB41oWD/2V0q
         MBkhKufJdQQ9UUk8De45SMbSwygVtW5tD1OVp288lgA2RuOMUtaLazfKXM3A31r6y15e
         fRPg==
X-Gm-Message-State: AOAM532J0IaQyr5fBdhVOGGkhJ3JO7+6hTJRbg0sSSQG8p+KYmt2kEoU
        0JFIzbUYMFGEHBX4D74usX9/FwP+CNVZIax0dD8=
X-Google-Smtp-Source: ABdhPJzjYusBJzMKzp9/ffPXRWGG1NuJJEOzMtRtLfKO4XOKtBQ+gSH59XiC/T+N89ZGmQS5monA5MJTw7+LJ+ZDVso=
X-Received: by 2002:a25:b88:: with SMTP id 130mr34680074ybl.199.1643723849842;
 Tue, 01 Feb 2022 05:57:29 -0800 (PST)
MIME-Version: 1.0
References: <1643112538-36743-1-git-send-email-wanpengli@tencent.com> <ae828eca-40bd-60f3-263f-5b3de637a9aa@redhat.com>
In-Reply-To: <ae828eca-40bd-60f3-263f-5b3de637a9aa@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 1 Feb 2022 21:57:19 +0800
Message-ID: <CANRm+CwkYJAsv=VngY6m1uQtCLa+WqOJwSJzx95dO7LRAkbsbg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2] KVM: LAPIC: Enable timer posted-interrupt when
 mwait/hlt is advertised
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Aili Yao <yaoaili@kingsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 1 Feb 2022 at 20:11, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 1/25/22 13:08, Wanpeng Li wrote:
> > As commit 0c5f81dad46 (KVM: LAPIC: Inject timer interrupt via posted interrupt)
> > mentioned that the host admin should well tune the guest setup, so that vCPUs
> > are placed on isolated pCPUs, and with several pCPUs surplus for*busy*  housekeeping.
> > It is better to disable mwait/hlt/pause vmexits to keep the vCPUs in non-root
> > mode. However, we may isolate pCPUs for other purpose like DPDK or we can make
> > some guests isolated and others not, we may lose vmx preemption timer/timer fastpath
> > due to not well tuned setup, and the checking in kvm_can_post_timer_interrupt()
> > is not enough. Let's guarantee mwait/hlt is advertised before enabling posted-interrupt
> > interrupt. vmx preemption timer/timer fastpath can continue to work if both of them
> > are not advertised.
>
> Is this the same thing that you meant?
>
> --------
> As commit 0c5f81dad46 ("KVM: LAPIC: Inject timer interrupt via posted interrupt")
> mentioned that the host admin should well tune the guest setup, so that vCPUs
> are placed on isolated pCPUs, and with several pCPUs surplus for *busy* housekeeping.
> In this setup, it is preferrable to disable mwait/hlt/pause vmexits to
> keep the vCPUs in non-root mode.
>
> However, if only some guests isolated and others not, they would not have
> any benefit from posted timer interrupts, and at the same time lose
> VMX preemption timer fast paths because kvm_can_post_timer_interrupt()
> returns true and therefore forces kvm_can_use_hv_timer() to false.
>
> By guaranteeing that posted-interrupt timer is only used if MWAIT or HLT
> are done without vmexit, KVM can make a better choice and use the
> VMX preemption timer and the corresponding fast paths.
> --------

Looks better, thanks Paolo! :)

    Wanpeng
