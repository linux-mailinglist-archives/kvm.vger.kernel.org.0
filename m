Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2123636BCE
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 07:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfFFFoI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 01:44:08 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:34695 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFFFoH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 01:44:07 -0400
Received: by mail-oi1-f196.google.com with SMTP id u64so758127oib.1;
        Wed, 05 Jun 2019 22:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tk6GyDs0VS64a3+zCzYjeMCP8j+xybcK7R+DofWfXTQ=;
        b=rPkLfvqs+b9szsegsJkefc+GolU/hypqfn7qndNQlXpKxrMu+qJOxR3hQhuGjkBtiP
         gi0p0YvHL9enmgSyZaIwDGsMccxH+J847m5eY1lGCDCtdnfsou4DUsb2+bSzwpfyFq/l
         YW/JKyFEnJSc/5KCqOi0Wp0xhEKesDhQ5AqLtJgXruCpU6sUC3CJOnsX2vSJl8LbcU4T
         yEO/u4Glk9PEV2TW8JzlMo2vLKi6fEeYSPfoDB7XeRCNwiq8vuZFTk2d4da5nnGdIk7M
         3mSOuyJg+1VkENKegFNqE0K63VFXYgk27YPXT5/f9mLwgaMXZ6MA860l4/RibM0j2geN
         /SXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tk6GyDs0VS64a3+zCzYjeMCP8j+xybcK7R+DofWfXTQ=;
        b=t/T5t/dvMUh6HrbvWvls9aAs+zyPmzLkfXfZMOzGhnNb/eatS2dNwvOxFTHzs9JMum
         T0w0lEHuJ5PIFQ3SoNax13+XFqGBwQjkQ+r0ck+UXvnl+hYMgJbSlwfI4GURRcNhD5ka
         ro1lpUs7fmawEoagYDtSCPc0YQ4zBACxA82KFkFQs4V5qWGcCnUnLaCyC2i/kDsoMt46
         QTyZLD9owcy8UNOudXxkna4P9pW4lbJj+oRgmlHQ/N3Tz+I3OftvvboKbVNAbLT8XOrq
         E+NZVV66bmMKSwgLWzrzbsCqCpvNDQLkhpDfGChwVlKpPsUvrItg5CrjzAeKPkIySA1P
         B3Gw==
X-Gm-Message-State: APjAAAUPXa7cDpQKI1wUPcsQhjqEtTumSTDy/dMaVfw8vcVK7cpAzlhI
        q+UlGAiCuV/GvQUbrfJAkHtK71afW0ZLKTxwjuZMZg==
X-Google-Smtp-Source: APXvYqxUe7s92029jMIpWaoTI3EgsZO7a8sHg9UZv3yF+SwRVLlLTb2K7J2cTZDYaeLfPYs0+Ib1zyXQO1P6qWQ2bRg=
X-Received: by 2002:aca:51ce:: with SMTP id f197mr7245969oib.33.1559799847126;
 Wed, 05 Jun 2019 22:44:07 -0700 (PDT)
MIME-Version: 1.0
References: <1559729351-20244-1-git-send-email-wanpengli@tencent.com>
 <1559729351-20244-2-git-send-email-wanpengli@tencent.com> <505fc388-2223-146f-ae8a-824169078a17@redhat.com>
In-Reply-To: <505fc388-2223-146f-ae8a-824169078a17@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 6 Jun 2019 13:44:32 +0800
Message-ID: <CANRm+Cz+xqfBQXoxc30SpsBdTKfer+YJW=oV14fBvpmX=kFQYA@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: LAPIC: Make lapic timer unpinned when timer is
 injected by posted-interrupt
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Jun 2019 at 21:04, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 05/06/19 12:09, Wanpeng Li wrote:
> > +static inline bool posted_interrupt_inject_timer(struct kvm_vcpu *vcpu)
> > +{
> > +     return (kvm_x86_ops->pi_inject_timer_enabled(vcpu) &&
> > +             kvm_mwait_in_guest(vcpu->kvm));
> > +}
> > +
>
> Here you need to check kvm_halt_in_guest, not kvm_mwait_in_guest,
> because you need to go through kvm_apic_expired if the guest needs to be
> woken up from kvm_vcpu_block.
>
> There is a case when you get to kvm_vcpu_block with kvm_halt_in_guest,
> which is when the guest disables asynchronous page faults.  Currently,
> timer interrupts are delivered while apf.halted = true, with this change

You are right. I check it in v2 2/3.

> they wouldn't.  I would just disable KVM_REQ_APF_HALT in
> kvm_can_do_async_pf if kvm_halt_in_guest is true, let me send a patch
> for that later.
>
> When you do this, I think you don't need the
> kvm_x86_ops->pi_inject_timer_enabled check at all, because if we know

I still keep check mwait and apicv in v2, since w/o mwait exposed, the
emulated timer can't be offload(thanks to preemption timer is
disabled). In addition,  w/o posted-interrupt, we can't avoid the
timer fire vmexit.

> that the vCPU cannot be asleep in kvm_vcpu_block, then we can inject the
> timer interrupt immediately with __apic_accept_irq (if APICv is
> disabled, it will set IRR and do kvm_make_request + kvm_vcpu_kick).
>
> You can keep the module parameter, mostly for debugging reasons, but
> please move it from kvm-intel to kvm, and add something like
>
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index 123ea07a3f3b..1cc7973c382e 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -14,6 +14,11 @@
>  static cpumask_var_t housekeeping_mask;
>  static unsigned int housekeeping_flags;
>
> +bool housekeeping_enabled(enum hk_flags flags)
> +{
> +       return !!(housekeeping_flags & flags);
> +}
> +
>  int housekeeping_any_cpu(enum hk_flags flags)
>  {
>         if (static_branch_unlikely(&housekeeping_overridden))
>
> so that the default for the module parameter can be
> housekeeping_enabled(HK_FLAG_TIMER).

Agreed. Thanks for the quick review. :)

Regards,
Wanpeng Li
