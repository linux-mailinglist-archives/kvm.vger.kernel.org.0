Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598203E0E4D
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 08:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236276AbhHEG2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 02:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235592AbhHEG2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 02:28:16 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C97FC061765
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 23:28:01 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id l4so5647856ljq.4
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 23:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qZujMoRT1ZKK0WrlZq2+xupgWWhgF2cPYjSHNhOFfkU=;
        b=A8TcVfSSUWhwH5Gwiljw1kOaURLOTjY3Hxlw0BvexgCrBmDI1AmbOksHtYpHNO437X
         qp4U2afG8SepZqohJ7E240SqnKG4GNQHuoWvyXSw2H1dzAvMsncgsrBfw3zjGrAXZ+e7
         ajsp/PW3uLnjA29mTqPLW5EHlBUXd90yI+BNEeE2qnEK763ozktvU3lIcjFV3s3ne4T9
         zxUIr5Umhmq6LDpa2oZzfgWtiMt5cdUhDpT/UVszVdo4XnLpU9yGsa21inrQgX3XQ7ab
         DnD51btLSrRk72pk4bh0tDrVV41dNOYd3T5yhe58dzQD+fkuEWM0uenNb5JytQKfUKOu
         AmbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qZujMoRT1ZKK0WrlZq2+xupgWWhgF2cPYjSHNhOFfkU=;
        b=FqL9VcJW9aszfEEn1ujxyqInCn8uALs2pnzX+URiNTYUklOBLyebfq6MPDZ0ADeM6L
         2TmM8bxebayV7zPuB4fHPIdjq290Nyaa9BMR+VORs+T8PF25bU33dpQny1PCdelWE2kI
         TarKrAvCXDGLLBSvf3bQDb3WxEBEsgRjsq36x3DHk9+Jsuyz/60MIdneW5T6HP04fgWO
         A3mv6Fk/p3ItzLl/hkkVl5bYSJc56vYjpL5su9ouWxQ/KV1Aj4Udj55LLSxt4hESDVo9
         JafGEWGl1vouH3Qn7C2DsmWuSLKDgyT54rMFT2cb9rE71wfpRboDtqs5LX+lDx46YXuz
         LkRQ==
X-Gm-Message-State: AOAM532VSDyLmmiYt5LcGivdizSEItxhqWJfH6p5iPSow7SEiHw1+OaW
        P9Iwb4dCU4BNrWu/w/17dXg99/7ARFWrku1wMvk1kA==
X-Google-Smtp-Source: ABdhPJx71BAqveU+GESvhEqPQ6+JEFcqk5SdIMktg0RjCYmjLebuoo+kva+QCUatWyOaLmvBQuiQznsARu5ehNolva4=
X-Received: by 2002:a2e:9b4f:: with SMTP id o15mr2061197ljj.22.1628144879477;
 Wed, 04 Aug 2021 23:27:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com> <20210804085819.846610-20-oupton@google.com>
 <20210804110531.x6gm2bpygg7laiau@gator.home>
In-Reply-To: <20210804110531.x6gm2bpygg7laiau@gator.home>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 4 Aug 2021 23:27:48 -0700
Message-ID: <CAOQ_QsgzsS1iMPQ8t+-ivjiTWJbbOQ2k_AmBHar3NqKJ=YydsA@mail.gmail.com>
Subject: Re: [PATCH v6 19/21] KVM: arm64: Emulate physical counter offsetting
 on non-ECV systems
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On Wed, Aug 4, 2021 at 4:05 AM Andrew Jones <drjones@redhat.com> wrote:
> > +static bool ptimer_emulation_required(struct kvm_vcpu *vcpu)
> > +{
> > +     return timer_get_offset(vcpu_ptimer(vcpu)) &&
> > +                     !cpus_have_const_cap(ARM64_ECV);
>
> Whenever I see a static branch check and something else in the same
> condition, I always wonder if we could trim a few instructions for
> the static branch is false case by testing it first.

Good point, I'll reclaim those few cycles in the next spin ;-)

> > @@ -1539,11 +1551,8 @@ int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> >       switch (attr->attr) {
> >       case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
> >       case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
> > -             return 0;
> >       case KVM_ARM_VCPU_TIMER_OFFSET:
> > -             if (cpus_have_const_cap(ARM64_ECV))
> > -                     return 0;
> > -             break;
> > +             return 0;
>
> So now, if userspace wants to know when they're using an emulated
> TIMER_OFFSET vs. ECV, then they'll need to check the HWCAP. I guess
> that's fair. We should update the selftest to report what it's testing
> when the HWCAP is available.
>

Hmm...

I hadn't yet wired up the ECV cpufeature bits to an ELF HWCAP, but
this point is a bit interesting. I can see the argument being made
that we shouldn't have two ELF HWCAP bits for ECV (depending on
partial or full ECV support). ECV=0x1 is most certainly of interest to
userspace, since self-synchronized views of the counter are then
available. However, ECV=0x2 is purely of interest to EL2.

What if we only had only one ELF HWCAP bit for ECV >= 0x1? We could
let userspace read ID_AA64MMFR0_EL1.ECV if it really needs to know
about ECV = 0x2.

> > +     if (vcpu_ptimer(vcpu)->host_offset && !cpus_have_const_cap(ARM64_ECV))
>
> Shouldn't we expose and reuse ptimer_emulation_required() here?
>

Agreed, makes it much cleaner.

> > +             val &= ~CNTHCTL_EL1PCTEN;
> > +     else
> > +             val |= CNTHCTL_EL1PCTEN;
> >       write_sysreg(val, cnthctl_el2);
> >  }
> > --
> > 2.32.0.605.g8dce9f2422-goog
> >
>
> Otherwise,
>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>

Thanks!

--
Oliver
