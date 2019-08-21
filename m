Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9748970ED
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 06:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbfHUEQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 00:16:37 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:44525 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfHUEQh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 00:16:37 -0400
Received: by mail-oi1-f194.google.com with SMTP id k22so584823oiw.11;
        Tue, 20 Aug 2019 21:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pMRXLSyAlcMfdfwoL80Y2c2YUHOyJGNHzi4KrIYHFcc=;
        b=Jq+sbN/+uLDU2tt+BkRA3cof6F2A03Y5A6lujqXWYzzoSjg7uXRsGMz8LlJGz5FJ9f
         zrxHAqcUx0hdhnrPdKJ2C+t5QFQwR342kVCqVM7+h9RRKwA6SEL7L5I4b/KmzUe4n78U
         vQayfqLL7i/OUjE2Exlz4uYpYxZDpL+Y5+FJEASd0dx6VrCs/sfYgl3vQOGkgSMhFbdf
         B1hvW+q6Ocn9yVEqwrdJahms0es20CxOvBSIXr87HbKn6XBVU1HMnCwovjYaK7yezu81
         6AcR10Q5poPrSSAjXlnu2Xuzdn/AubtxkBzcGFWcGzoUW5MbRI1ewDbWHtyxoFLwLZg3
         eETQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pMRXLSyAlcMfdfwoL80Y2c2YUHOyJGNHzi4KrIYHFcc=;
        b=gEKbVLv8HBpRR0eSfa3BbBlM7qJjEjHYu04MFGkYKu9rXoZjjOxugcygu6qaMBR2C3
         wCefXCxO39LEe4Yptpuoy4Tv1oNP6AJ5bkkVWQ0SC8wsC0bPoXtC+JNNXbQwNNPzBKIL
         Y6gfEMqSYl89a0bqQ/jAUezvFdzffodQ4RBkIPew4zCTaW7JMUpSyxqTKP8lnwfv/m4/
         Cw4ZFdt8XXlrpIOa7qdVxyQ5vVORYmoEhdlM+9UlYKZ11loD37rj/tyZZLsB8KiyrU6L
         CFCOncQPWfDnyYRwZEtyFxkm9TgqQBevxoHegqTiR83j3au13SDyc62YMlgd5BrX1kxf
         uG2w==
X-Gm-Message-State: APjAAAWFaKnb4YI2W2rlF9dlu7PZRvw2GYPdSik2LuTHh64RozPGNx5y
        zeTH7m8iVEk/+Gz+QzA72jn36U8mRolsdmOFIR/n1M0P
X-Google-Smtp-Source: APXvYqzRADenjJAm6FhIzYAtAI/ifRbBkWNV2p7ZeXbg8KUqtUaK4H3cIg7DcF+cY2K7Ou3hs6aklm7MZnIISGZX9X4=
X-Received: by 2002:aca:c449:: with SMTP id u70mr2525647oif.5.1566360995565;
 Tue, 20 Aug 2019 21:16:35 -0700 (PDT)
MIME-Version: 1.0
References: <1562376411-3533-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1562376411-3533-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 21 Aug 2019 12:16:03 +0800
Message-ID: <CANRm+CwU6vVj80TKhhy_tR=HVMsEeboFPYTE1s9Jm+k2bvd3rg@mail.gmail.com>
Subject: Re: [PATCH v7 0/2] KVM: LAPIC: Implement Exitless Timer
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 6 Jul 2019 at 09:26, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> Dedicated instances are currently disturbed by unnecessary jitter due
> to the emulated lapic timers fire on the same pCPUs which vCPUs resident.
> There is no hardware virtual timer on Intel for guest like ARM. Both
> programming timer in guest and the emulated timer fires incur vmexits.
> This patchset tries to avoid vmexit which is incurred by the emulated
> timer fires in dedicated instance scenario.
>
> When nohz_full is enabled in dedicated instances scenario, the unpinned
> timer will be moved to the nearest busy housekeepers after commit
> 9642d18eee2cd (nohz: Affine unpinned timers to housekeepers) and commit
> 444969223c8 ("sched/nohz: Fix affine unpinned timers mess"). However,
> KVM always makes lapic timer pinned to the pCPU which vCPU residents, the
> reason is explained by commit 61abdbe0 (kvm: x86: make lapic hrtimer
> pinned). Actually, these emulated timers can be offload to the housekeepi=
ng
> cpus since APICv is really common in recent years. The guest timer interr=
upt
> is injected by posted-interrupt which is delivered by housekeeping cpu
> once the emulated timer fires.
>
> The host admin should fine tuned, e.g. dedicated instances scenario w/
> nohz_full cover the pCPUs which vCPUs resident, several pCPUs surplus
> for busy housekeeping, disable mwait/hlt/pause vmexits to keep in non-roo=
t
> mode, ~3% redis performance benefit can be observed on Skylake server.
>
> w/o patchset:
>
>             VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time   Avg =
time
>
> EXTERNAL_INTERRUPT    42916    49.43%   39.30%   0.47us   106.09us   0.71=
us ( +-   1.09% )
>
> w/ patchset:
>
>             VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time       =
  Avg time
>
> EXTERNAL_INTERRUPT    6871     9.29%     2.96%   0.44us    57.88us   0.72=
us ( +-   4.02% )
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
>
> v6 -> v7:
>  * remove bool argument
>
> v5 -> v6:
>  * don't overwrites whatever the user specified
>  * introduce kvm_can_post_timer_interrupt and kvm_use_posted_timer_interr=
upt
>  * remove kvm_hlt_in_guest() condition
>  * squash all of 2/3/4 together
>
> v4 -> v5:
>  * update patch description in patch 1/4
>  * feed latest apic->lapic_timer.expired_tscdeadline to kvm_wait_lapic_ex=
pire()
>  * squash advance timer handling to patch 2/4
>
> v3 -> v4:
>  * drop the HRTIMER_MODE_ABS_PINNED, add kick after set pending timer
>  * don't posted inject already-expired timer
>
> v2 -> v3:
>  * disarming the vmx preemption timer when posted_interrupt_inject_timer_=
enabled()
>  * check kvm_hlt_in_guest instead
>
> v1 -> v2:
>  * check vcpu_halt_in_guest
>  * move module parameter from kvm-intel to kvm
>  * add housekeeping_enabled
>  * rename apic_timer_expired_pi to kvm_apic_inject_pending_timer_irqs
>
>
> Wanpeng Li (2):
>   KVM: LAPIC: Make lapic timer unpinned
>   KVM: LAPIC: Inject timer interrupt via posted interrupt

There is a further optimization for this feature in houseeking/hrtimer
subsystem.

[1] https://lkml.org/lkml/2019/7/25/963
[2] https://lkml.org/lkml/2019/6/28/231

The [2] patch tries to optimize the worst case, however, it will not
be merged by maintainers and get offline confirm, Thomas will refactor
this to avoid to predict the future on every timer enqueue. Anyway, it
still should be considered to be backported to product environment as
long as get_nohz_timer_target() is using.

Regards,
Wanpeng Li
