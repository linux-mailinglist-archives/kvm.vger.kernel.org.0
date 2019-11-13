Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBC2FAA0B
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 07:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfKMGGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 01:06:09 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42762 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfKMGGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 01:06:09 -0500
Received: by mail-ot1-f66.google.com with SMTP id b16so626131otk.9;
        Tue, 12 Nov 2019 22:06:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+QE4XASVIkmqkoyLlQVR4J5C2c9+Lx6ndpeyktLyfQ4=;
        b=lCz3DVS1lKfCY3SgtsEmnOyb1HlRJkV7+nVxdYnV9S5uP4Fr/Tas3Oby6qOwCrwGgm
         Tf68KOT++FEB5Kd87D28wQobDdgloCNl64XlY9Ul/ZfC5r36CPanTDfs8aPkznCtsTP6
         zz5zdAjtDLITq3YUs11NC04xvkHVg9UJhS8jqWAU48cm9Y5QffDHC0rwOhVK0GqnZ0x9
         Y+AlJzvDZPga+ZP1kPM/2/P5hEhl/Kam3iVCgkI2KWaG0Sy+XdtSHHpC+Jc08gNM8SnO
         R845UtaN01sashkJcXhWtCR7PUiG1kFlUZ87Ig2TR1zqKQiJHccCz2Uvza67zKuK5MGD
         mGGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+QE4XASVIkmqkoyLlQVR4J5C2c9+Lx6ndpeyktLyfQ4=;
        b=qILnAwXiQmR1Mgm3B/ouTpW3rMsaalTDHpuTFT2ZdQH95B06sNX0nanVAdM/6Pa8jq
         baVEVs+UM1JRyMmwtUYjE0X1/AziYJA+Ax/MRNLr1BzNuGJDt8baSoPB64GDpWHpZB/t
         27RZfnwUHHwqUxOR0LlaJ6T7519n5I4r+9EesqyHwlF8r/yVnGLOx2+MQfeFDyHvzvcv
         ZpgRiXf///WAzu042AibFUPPVJXUsba1pdhu4s2DbuRXNtgjVsjRyRHm0QijmeM5bund
         7F/MzCXwmjkYsG6agUP/8KKgiGEEIpZ6P5eGY6FPWOzEv+6jRmF+LWU2KdCq2SfCvrrU
         zq1A==
X-Gm-Message-State: APjAAAVtd0SAspZOELqDGMHaS7xrjSCq5gGarn4c2U9IgiKUHzkG7PnT
        JN7WCwP1fHyqCD6JJJubTQbzUEMxYfNoyBj+meE=
X-Google-Smtp-Source: APXvYqxBDUdPjaUK+N/uVjGsJ7h4rObhrYujlUDtL9QfRRobxCFg8lPuVY9m6xx6GKQc3Ri4xxgaiMuL50mIJRCHfS0=
X-Received: by 2002:a9d:590f:: with SMTP id t15mr1238056oth.118.1573625168434;
 Tue, 12 Nov 2019 22:06:08 -0800 (PST)
MIME-Version: 1.0
References: <1573283135-5502-1-git-send-email-wanpengli@tencent.com>
 <4418c734-68e1-edaf-c939-f24d041acf2e@redhat.com> <CANRm+CzK_h2E9XWFipkNpAALLCBcM2vrUkdBpumwmT9AP09hfA@mail.gmail.com>
In-Reply-To: <CANRm+CzK_h2E9XWFipkNpAALLCBcM2vrUkdBpumwmT9AP09hfA@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 13 Nov 2019 14:05:59 +0800
Message-ID: <CANRm+CzLvyWswEX1UDnESSLHO5xt2wPciL6b=TTr-ua7yKZSTA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: X86: Single target IPI fastpath
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Nov 2019 at 09:33, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> On Tue, 12 Nov 2019 at 05:59, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 09/11/19 08:05, Wanpeng Li wrote:
> > > From: Wanpeng Li <wanpengli@tencent.com>
> > >
> > > This patch tries to optimize x2apic physical destination mode, fixed delivery
> > > mode single target IPI by delivering IPI to receiver immediately after sender
> > > writes ICR vmexit to avoid various checks when possible.
> > >
> > > Testing on Xeon Skylake server:
> > >
> > > The virtual IPI latency from sender send to receiver receive reduces more than
> > > 330+ cpu cycles.
> > >
> > > Running hackbench(reschedule ipi) in the guest, the avg handle time of MSR_WRITE
> > > caused vmexit reduces more than 1000+ cpu cycles:
> > >
> > > Before patch:
> > >
> > >   VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time   Avg time
> > > MSR_WRITE    5417390    90.01%    16.31%      0.69us    159.60us    1.08us
> > >
> > > After patch:
> > >
> > >   VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time   Avg time
> > > MSR_WRITE    6726109    90.73%    62.18%      0.48us    191.27us    0.58us
> >
> > Do you have retpolines enabled?  The bulk of the speedup might come just
> > from the indirect jump.
>
> Adding 'mitigations=off' to the host grub parameter:
>
> Before patch:
>
>     VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time   Avg time
> MSR_WRITE    2681713    92.98%    77.52%      0.38us     18.54us
> 0.73us ( +-   0.02% )
>
> After patch:
>
>     VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time   Avg time
> MSR_WRITE    2953447    92.48%    62.47%      0.30us     59.09us
> 0.40us ( +-   0.02% )
>
> Actually, this is not the first attempt to add shortcut for MSR writes
> which performance sensitive, the other effort is tscdeadline timer
> from Isaku Yamahata, https://patchwork.kernel.org/cover/10541035/ ,
> ICR and TSCDEADLINE MSR writes cause the main MSR write vmexits in our
> product observation, multicast IPIs are not as common as unicast IPI
> like RESCHEDULE_VECTOR and CALL_FUNCTION_SINGLE_VECTOR etc. As far as
> I know, something similar to this patch has already been deployed in
> some cloud companies private kvm fork.

Hi Paolo,

Do you think I should continue for this?

    Wanpeng
