Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A88124212E
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 11:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437489AbfFLJkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 05:40:14 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:40934 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfFLJkO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 05:40:14 -0400
Received: by mail-oi1-f194.google.com with SMTP id w196so11195626oie.7;
        Wed, 12 Jun 2019 02:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FVoAL/mxIofQtM8+Ijg+ZIeTSoEU3dKXPoThV0hSLcA=;
        b=jBI9mrKAUV2KSupGQPeN9PeAsaWi5QWlbK9xn9VFnhlMWui0B+zrXa9VMvPZZi1u8G
         ABcXBOM/Fnmj8rqtjih6du5B7f7TR9+EiJnHnjYiUDnOLfzNqYA7SsxEqJYM9LGtxq3Y
         n4M3ERAfKZ157LEl2SWirEMhaJ4IWORsk607AwSuhpLcyAgjpDDhOyvCUXbj84e+MEZw
         3xyMTXbuM1rJgzWVSU4g1x5lwZ9CytCV9JEaKMNjJb7hJ3+DMytLWh/8lhITk9Kr9eqJ
         6paymmbbSpp1C77hYAu14GFyMUzYdXjKGdI/u3gZq2esoWfK9YRmv3HpGRSIVptnzVj4
         kvIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FVoAL/mxIofQtM8+Ijg+ZIeTSoEU3dKXPoThV0hSLcA=;
        b=ihGCiKBIkdI5W27XuSjW4MUqRqrWj86HWZqiLXfuAZDjSVMso+btMz+4KS1wCamjWz
         Crb/1iJye+UrbA5egrLnDDRt0cahzXFNreeyPky9o8qu0xRnMVofxoHp4gaMcglYKunW
         RuHUaY45RYKaasouP+ZTslc35f3i09Usjipur9RP70YDq1pF3pmVeOftjeBpzG4+DCJb
         /Ujj0Xm5mDtbJAPQOfX+FDYhV5lAAqIy1ju+Jz2xboV2p0whaynhRLr5OoEe+3oRp2NR
         Hwnj8YDVGogui+WbjGa4aAfGNe5YsFUQzRPeiswMJ6ZD//+kyVsa47BXf6ygU46wLOkK
         LQuw==
X-Gm-Message-State: APjAAAUL78gwVEV55FTNOTAdLeqvOaSqWOHIJEDdCasnqqOAW/oWCBks
        2u/DFkKqxNteIjUvONj3GGK3efW75q1rINKUBquqkA==
X-Google-Smtp-Source: APXvYqxrZ8xGXX06Vng88mRhUQ5foYHWXyowrcR5e4GnfKyCC7eZmipk8UwTkRegfTzEUFajgnulQAkCaiqR1kP+bFU=
X-Received: by 2002:aca:544b:: with SMTP id i72mr18813897oib.174.1560332413690;
 Wed, 12 Jun 2019 02:40:13 -0700 (PDT)
MIME-Version: 1.0
References: <1560332160-17050-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1560332160-17050-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 12 Jun 2019 17:40:57 +0800
Message-ID: <CANRm+CxR_jrB=tMpmM9OMEJ-pm8gdfMNN7UsDdQ+YrG_akGdAg@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] KVM: LAPIC: Optimize timer latency further
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry, send out the wrong patchset, please ignore.
On Wed, 12 Jun 2019 at 17:36, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> Advance lapic timer tries to hidden the hypervisor overhead between the
> host emulated timer fires and the guest awares the timer is fired. However,
> it just hidden the time between apic_timer_fn/handle_preemption_timer ->
> wait_lapic_expire, instead of the real position of vmentry which is
> mentioned in the orignial commit d0659d946be0 ("KVM: x86: add option to
> advance tscdeadline hrtimer expiration"). There is 700+ cpu cycles between
> the end of wait_lapic_expire and before world switch on my haswell desktop.
>
> This patchset tries to narrow the last gap(wait_lapic_expire -> world switch),
> it takes the real overhead time between apic_timer_fn/handle_preemption_timer
> and before world switch into consideration when adaptively tuning timer
> advancement. The patchset can reduce 40% latency (~1600+ cycles to ~1000+
> cycles on a haswell desktop) for kvm-unit-tests/tscdeadline_latency when
> testing busy waits.
>
> v2 -> v3:
>  * expose 'kvm_timer.timer_advance_ns' to userspace
>  * move the tracepoint below guest_exit_irqoff()
>  * move wait_lapic_expire() before flushing the L1
>
> v1 -> v2:
>  * fix indent in patch 1/4
>  * remove the wait_lapic_expire() tracepoint and expose by debugfs
>  * move the call to wait_lapic_expire() into vmx.c and svm.c
>
> Wanpeng Li (5):
>   KVM: LAPIC: Extract adaptive tune timer advancement logic
>   KVM: LAPIC: Fix lapic_timer_advance_ns parameter overflow
>   KVM: LAPIC: Expose per-vCPU timer_advance_ns to userspace
>   KVM: LAPIC: Delay trace advance expire delta
>   KVM: LAPIC: Optimize timer latency further
>
>  arch/x86/kvm/debugfs.c | 16 +++++++++++++
>  arch/x86/kvm/lapic.c   | 62 +++++++++++++++++++++++++++++---------------------
>  arch/x86/kvm/lapic.h   |  3 ++-
>  arch/x86/kvm/svm.c     |  4 ++++
>  arch/x86/kvm/vmx/vmx.c |  4 ++++
>  arch/x86/kvm/x86.c     |  7 +++---
>  6 files changed, 65 insertions(+), 31 deletions(-)
>
> --
> 2.7.4
>
