Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 846D5163890
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 01:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgBSAcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 19:32:39 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:36093 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbgBSAci (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 19:32:38 -0500
Received: by mail-ot1-f66.google.com with SMTP id j20so21479357otq.3;
        Tue, 18 Feb 2020 16:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XUM7KYT8zgsfj9AzoZxftNzri4odTmzfAEqNR5lKaWw=;
        b=qfZzlQbjZ0+031d4jhozHvVorMj77fI0+w6j921OCntJmi4EDigsgKgaS6H31x8TFs
         E7dKwMFPvLt10gT0VEmBXdpZhNNOuZJH3pWXR/bfTSigaa3OBq/Y4ELNhGrychMqk+mJ
         HslduXnGz9KGO3Mj/0jyIOlfd7dJOCzuyph/+wwGh+oZyBY57K5apnYbUqe3i3sDjz7S
         MecOvz5isl7ZoPmFvgLEhrUtMYsr79sVr89X0T1i+YiQIID9U+28EzkNB2FMASwelGVx
         z/1+KRrF9hox8B4DJdiBmRJaQLdCa+EgrH6GhKNTxY16587oAq06gV0w/MEHIfAaniX3
         yS0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XUM7KYT8zgsfj9AzoZxftNzri4odTmzfAEqNR5lKaWw=;
        b=CXft6/9mTGlA7TQ04Sqqw5EK+iYjD9dEwv6ak5NZXy4xkcGlG2k19Xgh19EpvqeavQ
         59lzAFS8EXuJMeWYsmOFcYcjc/aP87vj8ImCj+V3Z+qaTwhk6HrgoXPVdlbf0MVmJ6SI
         /bOKRumt79wlM0iKAr0kNpTBZgkY7uO6RkF8bgO+FbvrV8HpRjacFZH45PYjbS+wVRw0
         75xK15mov6aiWEajjlQpPOZXSqj52poO7Bul9JbE4O+jadTBP2rMqr7ac4jMdRAcUBCA
         UGfXOBzLVVeBd/tcH2YIJWEpS0cKumat9KJBnPQB0JLu4kc3Y0FKJwmiThkUVcdSq3WC
         oYuA==
X-Gm-Message-State: APjAAAWAor/jbIakY9F+UuzH2Ps2zzEbq8nQBuBdLrz4uVPx1ByYtpnC
        c+TQAldIB1xxfUoMhItvI2DleB8DLxfy+v6lU+g=
X-Google-Smtp-Source: APXvYqxHAMtCUWrwYc64KvH0vF+pzL1NjzcwLluuwvD4WTY70xyKmmKq2mM25AEvwHor8uaLAmvj5kV5C0T1FFIUC4A=
X-Received: by 2002:a05:6830:1011:: with SMTP id a17mr16743411otp.45.1582072357905;
 Tue, 18 Feb 2020 16:32:37 -0800 (PST)
MIME-Version: 1.0
References: <1581988630-19182-1-git-send-email-wanpengli@tencent.com> <87r1ys7xpk.fsf@vitty.brq.redhat.com>
In-Reply-To: <87r1ys7xpk.fsf@vitty.brq.redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 19 Feb 2020 08:32:26 +0800
Message-ID: <CANRm+CzbVygGMsUxMOXEd-+U3B_gOQjkd6u66DzROBmU_V2mTQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] KVM: X86: Less kvmclock sync induced vmexits after
 VM boots
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Feb 2020 at 22:54, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Wanpeng Li <kernellwp@gmail.com> writes:
>
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > In the progress of vCPUs creation, it queues a kvmclock sync worker to the global
> > workqueue before each vCPU creation completes. Each worker will be scheduled
> > after 300 * HZ delay and request a kvmclock update for all vCPUs and kick them
> > out. This is especially worse when scaling to large VMs due to a lot of vmexits.
> > Just one worker as a leader to trigger the kvmclock sync request for all vCPUs is
> > enough.
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> > v3 -> v4:
> >  * check vcpu->vcpu_idx
> >
> >  arch/x86/kvm/x86.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index fb5d64e..d0ba2d4 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9390,8 +9390,9 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
> >       if (!kvmclock_periodic_sync)
> >               return;
> >
> > -     schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
> > -                                     KVMCLOCK_SYNC_PERIOD);
> > +     if (vcpu->vcpu_idx == 0)
> > +             schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
> > +                                             KVMCLOCK_SYNC_PERIOD);
> >  }
> >
> >  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>
> Forgive me my ignorance, I was under the impression
> schedule_delayed_work() doesn't do anything if the work is already
> queued (see queue_delayed_work_on()) and we seem to be scheduling the
> same work (&kvm->arch.kvmclock_sync_work) which is per-kvm (not
> per-vcpu). Do we actually happen to finish executing it before next vCPU
> is created or why does the storm you describe happens?

I miss it, ok, let's just make patch 2/2 upstream.

    Wanpeng
