Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7529A47C2C9
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 16:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239324AbhLUP1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 10:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239302AbhLUP1G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 10:27:06 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681B5C06173F
        for <kvm@vger.kernel.org>; Tue, 21 Dec 2021 07:27:06 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id m1so11005185pfk.8
        for <kvm@vger.kernel.org>; Tue, 21 Dec 2021 07:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OcqLbLpVK2PIL+tVVK3oj3YcivrWvMceDvQIOqXppa8=;
        b=NRJKhaaPZm61mDvvTiVG+bE7vxe/wAtwOpOWWAXnhgs6u3xH9W33ghn/jxD5DBo4ul
         0+TJFl8larb77zYXFWfRIuMTIiYIOTtV/4tguXTL5ug7WhitJDvfgmeWiGipWoYueWZZ
         fF1eIiqv+co+RJkjigC/kp1lJ2zi1gl5KbOU6eJZXOKSzSS4jEB1jUC4otFxwIekQK8o
         x2ZKvlOMj895QCWiUaXE+8UCrjyAC6CZJy2EZnQaBGWcCVYPnMGpM/IqguVB+7z7MIMf
         CzrzdlA0yJmmI/XFBmqsxko5FUeeJa4v39HNo08LW0ifyQza40qI/+l1By1+niIW13Nv
         Fz0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OcqLbLpVK2PIL+tVVK3oj3YcivrWvMceDvQIOqXppa8=;
        b=qE7H/reqwEj/3SNdJZbUt+17lrBIoSKNs1Vn4mTFudsbEw1FAr+9UnshPZgehX8/oC
         Kg3iHYC35gTGTv/WIBkxZju071TawyUD1QJ41m4baRE21bZ8fH0bWQXiq/jACE7IBqXo
         f0kbzyFZr7wIRqcoY5OwO87Ty6lMKe/2zaubM6pHv3gbXQlZMxBaMScLXlILTLe7hCZs
         EcDjkj5WPoFCBgAu8Al+uzLp4PZwHx65zH3/MY8vgWgGIf8IGh7G8cyZZ+G3jotaxqm9
         VWOd3Ci5UW/QK0MywzFiTF05wdsu+2h8u2ADjIn9c4sIrtFoNJ618+zt3kW8kAGW37Cz
         NIvw==
X-Gm-Message-State: AOAM5302PaW6jxUGuY9Nmdu2qXcDo64WCQIWgtKoqtC5YciIcoNswItu
        2U7Xvhx+HLHPehlIFdNLNC96vQ==
X-Google-Smtp-Source: ABdhPJwU7QUzcqcAfRonlYyAOy+iQRUTGUU/X51saqjUvF157aryTHs8wMwzmxD+oXB6VCHrTGpWKw==
X-Received: by 2002:a05:6a00:2151:b0:4a2:5c9a:f0a9 with SMTP id o17-20020a056a00215100b004a25c9af0a9mr3910185pfk.39.1640100425667;
        Tue, 21 Dec 2021 07:27:05 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gg23sm3067476pjb.31.2021.12.21.07.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:27:05 -0800 (PST)
Date:   Tue, 21 Dec 2021 15:27:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Huangzhichao <huangzhichao@huawei.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: The vcpu won't be wakened for a long time
Message-ID: <YcHyReHoF+qjIVTy@google.com>
References: <73d46f3cc46a499c8e39fdf704b2deaf@huawei.com>
 <YbjWFTtNo9Ap7kDp@google.com>
 <9e5aef1ae0c141e49c2b1d19692b9295@huawei.com>
 <Ybtea42RxZ9aVzCh@google.com>
 <8a1a3ac75a6e4acf9bd1ce9779835e1c@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a1a3ac75a6e4acf9bd1ce9779835e1c@huawei.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 18, 2021, Longpeng (Mike, Cloud Infrastructure Service Product Dept.) wrote:
> > Hmm, that strongly suggests the "vcpu != kvm_get_running_vcpu()" is at fault.
> > Can you try running with the below commit?  It's currently sitting in kvm/queue,
> > but not marked for stable because I didn't think it was possible for the check
> > to a cause a missed wake event in KVM's current code base.
> > 
> 
> The below commit can fix the bug, we have just completed  the tests.
> Thanks.

Aha!  Somehow I missed this call chain when analyzing the change.

  irqfd_wakeup()
  |
  |->kvm_arch_set_irq_inatomic()
     |
     |-> kvm_irq_delivery_to_apic_fast()
         |
	 |-> kvm_apic_set_irq()


Paolo, can the changelog be amended to the below, and maybe even pull the commit
into 5.16?


KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU == this vCPU

Drop a check that guards triggering a posted interrupt on the currently
running vCPU, and more importantly guards waking the target vCPU if
triggering a posted interrupt fails because the vCPU isn't IN_GUEST_MODE.
If a vIRQ is delivered from asynchronous context, the target vCPU can be
the currently running vCPU and can also be blocking, in which case
skipping kvm_vcpu_wake_up() is effectively dropping what is supposed to
be a wake event for the vCPU.

The "do nothing" logic when "vcpu == running_vcpu" mostly works only
because the majority of calls to ->deliver_posted_interrupt(), especially
when using posted interrupts, come from synchronous KVM context.  But if
a device is exposed to the guest using vfio-pci passthrough, the VFIO IRQ
and vCPU are bound to the same pCPU, and the IRQ is _not_ configured to
use posted interrupts, wake events from the device will be delivered to
KVM from IRQ context, e.g.

  vfio_msihandler()
  |
  |-> eventfd_signal()
      |
      |-> ...
          |
          |->  irqfd_wakeup()
               |
               |->kvm_arch_set_irq_inatomic()
                  |
                  |-> kvm_irq_delivery_to_apic_fast()
                      |
                      |-> kvm_apic_set_irq()

This also aligns the non-nested and nested usage of triggering posted
interrupts, and will allow for additional cleanups.

Fixes: 379a3c8ee444 ("KVM: VMX: Optimize posted-interrupt delivery for timer fastpath")
Cc: stable@vger.kernel.org
Reported-by: Longpeng (Mike) <longpeng2@huawei.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20211208015236.1616697-18-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>




> > commit 6a8110fea2c1b19711ac1ef718680dfd940363c6
> > Author: Sean Christopherson <seanjc@google.com>
> > Date:   Wed Dec 8 01:52:27 2021 +0000
> > 
> >     KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU == this vCPU
> > 
> >     Drop a check that guards triggering a posted interrupt on the currently
> >     running vCPU, and more importantly guards waking the target vCPU if
> >     triggering a posted interrupt fails because the vCPU isn't IN_GUEST_MODE.
> >     The "do nothing" logic when "vcpu == running_vcpu" works only because KVM
> >     doesn't have a path to ->deliver_posted_interrupt() from asynchronous
> >     context, e.g. if apic_timer_expired() were changed to always go down the
> >     posted interrupt path for APICv, or if the IN_GUEST_MODE check in
> >     kvm_use_posted_timer_interrupt() were dropped, and the hrtimer fired in
> >     kvm_vcpu_block() after the final kvm_vcpu_check_block() check, the vCPU
> >     would be scheduled() out without being awakened, i.e. would "miss" the
> >     timer interrupt.
> > 
> >     One could argue that invoking kvm_apic_local_deliver() from (soft) IRQ
> >     context for the current running vCPU should be illegal, but nothing in
> >     KVM actually enforces that rules.  There's also no strong obvious benefit
> >     to making such behavior illegal, e.g. checking IN_GUEST_MODE and calling
> >     kvm_vcpu_wake_up() is at worst marginally more costly than querying the
> >     current running vCPU.
> > 
> >     Lastly, this aligns the non-nested and nested usage of triggering posted
> >     interrupts, and will allow for additional cleanups.
> > 
> >     Signed-off-by: Sean Christopherson <seanjc@google.com>
> >     Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> >     Message-Id: <20211208015236.1616697-18-seanjc@google.com>
> >     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 38749063da0e..f61a6348cffd 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -3995,8 +3995,7 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu
> > *vcpu, int vector)
> >          * guaranteed to see PID.ON=1 and sync the PIR to IRR if triggering a
> >          * posted interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
> >          */
> > -       if (vcpu != kvm_get_running_vcpu() &&
> > -           !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
> > +       if (!kvm_vcpu_trigger_posted_interrupt(vcpu, false))
> >                 kvm_vcpu_wake_up(vcpu);
> > 
> >         return 0;
