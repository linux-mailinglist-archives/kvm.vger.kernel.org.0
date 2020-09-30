Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E7227F601
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 01:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731678AbgI3X2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 19:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730548AbgI3X2I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 19:28:08 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B723C061755
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 16:28:07 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id z13so4482531iom.8
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 16:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2zNPnMDwSH/evHHtODPlaoouseFTp99pPVZGDDgyGhY=;
        b=csWJ/JkKF1QDPuiE2UlASPtZozKxHAy9twR4BpV/CVlBp3NNqfb7MaHWD+Y/2icij0
         N/Bj3Zg90314vTClj/ISg9iAfKZ4Y9ZfI+ZMQLGVZ8KHCst0NjVmg3HXngQ1Dgee9uoe
         HXjlYMSTvosxHGdfVpcRtIzdCV4f+8/JjKWNBsOv36BJ2nZxOLoHCJHKGfEAFtPclgUf
         vcNFZXE6/z3CZ6hTHf0bdAgjpoKyOZ4s4lJ9JvzrUhFAauxmZVyPTxaOeDX06PlzLGg8
         vrE09LjaLrLUvrIbKHWTzd+j4FjjxrMhDcdIRocMSXyIcb5E877goKN10xxB+MQ6amOf
         gdjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2zNPnMDwSH/evHHtODPlaoouseFTp99pPVZGDDgyGhY=;
        b=aLLXKIGdaUsfbdRbQganMlWmznNIPnbYZFlo+ednldUVH0ZLvDEUWTz5PCPV9pMQjh
         tKkCGBggGTuEVPftVw7g7POWUHrxfbZC3wr/lDOX20bLaDz5AK6JQbeewr3wlhMbYNq+
         5Iqv/kOf5xkxkArVlxVDFcWDnMCxdLLvpzTundrVCMRwnQHnm0a5fL3PC2N8csOcZCmp
         EHygR1mNeMFElPtcpGUj58oJYzEEi2arOEcIJ2kJj6SocVkS5oBzuEH51GyVU+boYJh4
         30nee9LTtwGV+L62d8XnbCwUmPhCazVxNwUxZICnCp2qW8DFsDezcLoAgiaFN2csXi9n
         lu1g==
X-Gm-Message-State: AOAM530eKzGxbqALOKpz15U1yx2i5qSxHjt5elPGTc7190yVZSSWMdGj
        uxGtqOkGb4ZG+ryPj96EaqU1Aoab892WpyfAOX8uqw==
X-Google-Smtp-Source: ABdhPJyV65yYiiq0KobGlnIOzHQWS7SawVm798cnYHga5XG0xk5hDJx4jkkXKyOlo1sSu3e66a/2DgL/9XUAbUvXk4U=
X-Received: by 2002:a05:6602:2d55:: with SMTP id d21mr3333082iow.134.1601508486309;
 Wed, 30 Sep 2020 16:28:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com> <20200925212302.3979661-14-bgardon@google.com>
 <20200930170354.GF32672@linux.intel.com> <CANgfPd8mH7XpNzCbObD-XO_Pzc0TK6oNQpTw9rgSdqBV-4trFw@mail.gmail.com>
 <20200930232429.GA2988@linux.intel.com>
In-Reply-To: <20200930232429.GA2988@linux.intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 30 Sep 2020 16:27:55 -0700
Message-ID: <CANgfPd8hgo+HFNVrpce3Nq8gL54=frL7cjf7KC6v=ORz_zGtKw@mail.gmail.com>
Subject: Re: [PATCH 13/22] kvm: mmu: Support invalidate range MMU notifier for
 TDP MMU
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
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

On Wed, Sep 30, 2020 at 4:24 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Wed, Sep 30, 2020 at 04:15:17PM -0700, Ben Gardon wrote:
> > On Wed, Sep 30, 2020 at 10:04 AM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index 52d661a758585..0ddfdab942554 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -1884,7 +1884,14 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
> > > >  int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
> > > >                       unsigned flags)
> > > >  {
> > > > -     return kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
> > > > +     int r;
> > > > +
> > > > +     r = kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
> > > > +
> > > > +     if (kvm->arch.tdp_mmu_enabled)
> > > > +             r |= kvm_tdp_mmu_zap_hva_range(kvm, start, end);
> > >
> > > Similar to an earlier question, is this intentionally additive, or can this
> > > instead by:
> > >
> > >         if (kvm->arch.tdp_mmu_enabled)
> > >                 r = kvm_tdp_mmu_zap_hva_range(kvm, start, end);
> > >         else
> > >                 r = kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
> > >
> >
> > It is intentionally additive so the legacy/shadow MMU can handle nested.
>
> Duh.  Now everything makes sense.  I completely spaced on nested EPT.
>
> I wonder if would be worth adding a per-VM sticky bit that is set when an
> rmap is added so that all of these flows can skip the rmap walks when using
> the TDP MMU without a nested guest.

We actually do that in the full version of this whole TDP MMU scheme.
It works very well.
I'm not sure why I didn't include that in this patch set - probably
just complexity. I'll definitely include that as an optimization along
with the lazy rmap allocation in the followup patch set.
