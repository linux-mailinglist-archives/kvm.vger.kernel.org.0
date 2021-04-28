Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21E136E1CE
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 01:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240125AbhD1Wjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 18:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbhD1Wjg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 18:39:36 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF8BC06138C
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 15:38:51 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id y22-20020a17090a8b16b0290150ae1a6d2bso9931874pjn.0
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 15:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=40mvDvEqW9Ck6kXUyy+OdsmQH7a8B6aLXhlL5FWmJuM=;
        b=J5iAoCMPLGAbUrLxrJOkHQjozfbLQ4i8a1MCBD1nju7qsziZGaHIQlEO90RvN4sYwC
         on3bzxKOmtiPcK+Z3RKtcmHiabsgeY3xUN+OufCZ50Hh9mma9vuzJ4L4OX/lxLlGjBuA
         jyiltB2KNjrOCrjK49wDpCNkUDe0ii5gNSFUxsizZ9ZXRIhuZCj8GEWmzjG7hyXQa26z
         Col68vtxqCTOPCPWY5WxaDjt8BCloymnV0Mx5a76O8clVLhfGYY8fHKfyg7E3QCjeQ4S
         ggtXtG284l8i6itUzk7NUMRB/+d3uwPMQgYezzh55k/zZX2WN9VyoO3e+KciP/ewG4s0
         IxoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=40mvDvEqW9Ck6kXUyy+OdsmQH7a8B6aLXhlL5FWmJuM=;
        b=bCRp5GNNrqNjhzUA4EPX8HWtgWkHp8tvIgCL8QcfnLqOunGSbrC8ENcx4auC/DKDrM
         X7ienH+CxatKtrvp0c3aB9Skr7rzNbTtnlT4HhYCHkAuksBUzkO1l/QQdxPqdy69EGYh
         belw94at0rwr+ty2Dy6hka2v2oQCEUzrkFCyZbIs+xAKhqujgFGQz5Brd8waM0vg7Idv
         kCIaESfRK9tcjtinj4gQAb7VubKuJPhJBDpGrzyTDtpICYLWqeCXj4LpZpOZdgRpJrTV
         vyxl1Pci+1v7tXqxJJXwCqItoaiBHpGQVIx8h1YMH93zoBWMTZ2mL1hQFUn99BO71F1P
         Tt4w==
X-Gm-Message-State: AOAM5328qj62r85u6+CT9Lxe1Ekln4zxwgiEtt1xm0oZpOKAOD+qHrO2
        sXfo3KEvMK/ydUKS7s5tnjWIwA==
X-Google-Smtp-Source: ABdhPJxxyerV2sLaJmaReymvIjG1ou0vnWrNIz7CdomcPKHywlk+yQp1i+7gM5oynqmH//eLr0TFXA==
X-Received: by 2002:a17:90a:a58f:: with SMTP id b15mr34064584pjq.135.1619649530360;
        Wed, 28 Apr 2021 15:38:50 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id t4sm578754pfq.165.2021.04.28.15.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 15:38:49 -0700 (PDT)
Date:   Wed, 28 Apr 2021 22:38:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v3 3/9] KVM: x86: Defer tick-based accounting 'til after
 IRQ handling
Message-ID: <YInj9QtUFdAlKqr3@google.com>
References: <20210415222106.1643837-1-seanjc@google.com>
 <20210415222106.1643837-4-seanjc@google.com>
 <20210420231402.GA8720@lothringen>
 <YH9jKpeviZtMKxt8@google.com>
 <20210421121940.GD16580@lothringen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421121940.GD16580@lothringen>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Apologies for the slow response.

On Wed, Apr 21, 2021, Frederic Weisbecker wrote:
> On Tue, Apr 20, 2021 at 11:26:34PM +0000, Sean Christopherson wrote:
> > On Wed, Apr 21, 2021, Frederic Weisbecker wrote:
> > > On Thu, Apr 15, 2021 at 03:21:00PM -0700, Sean Christopherson wrote:
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index 16fb39503296..e4d475df1d4a 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -9230,6 +9230,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> > > >  	local_irq_disable();
> > > >  	kvm_after_interrupt(vcpu);
> > > >  
> > > > +	/*
> > > > +	 * When using tick-based accounting, wait until after servicing IRQs to
> > > > +	 * account guest time so that any ticks that occurred while running the
> > > > +	 * guest are properly accounted to the guest.
> > > > +	 */
> > > > +	if (!vtime_accounting_enabled_this_cpu())
> > > > +		vtime_account_guest_exit();
> > > 
> > > Can we rather have instead:
> > > 
> > > static inline void tick_account_guest_exit(void)
> > > {
> > > 	if (!vtime_accounting_enabled_this_cpu())
> > > 		current->flags &= ~PF_VCPU;
> > > }
> > > 
> > > It duplicates a bit of code but I think this will read less confusing.
> > 
> > Either way works for me.  I used vtime_account_guest_exit() to try to keep as
> > many details as possible inside vtime, e.g. in case the implemenation is tweaked
> > in the future.  But I agree that pretending KVM isn't already deeply intertwined
> > with the details is a lie.
> 
> Ah I see, before 87fa7f3e98a131 the vtime was accounted after interrupts get
> processed. So it used to work until then. I see that ARM64 waits for IRQs to
> be enabled too.
> 
> PPC/book3s_hv, MIPS, s390 do it before IRQs get re-enabled (weird, how does that
> work?)

No idea.  It's entirely possible it doesn't work on one or more of those
architectures.

Based on init/Kconfig, s390 doesn't support tick-based accounting, so I assume
s390 is ok.

  config TICK_CPU_ACCOUNTING
	bool "Simple tick based cputime accounting"
	depends on !S390 && !NO_HZ_FULL

> And PPC/book3s_pr calls guest_exit() so I guess it has interrupts enabled.
> 
> The point is: does it matter to call vtime_account_guest_exit() before or
> after interrupts? If it doesn't matter, we can simply call
> vtime_account_guest_exit() once and for all once IRQs are re-enabled.
> 
> If it does matter because we don't want to account the host IRQs firing at the
> end of vcpu exit, then probably we should standardize that behaviour and have
> guest_exit_vtime() called before interrupts get enabled and guest_exit_tick()
> called after interrupts get enabled. It's probably then beyond the scope of this
> patchset but I would like to poke your opinion on that.
> 
> Thanks.

I don't know.  For x86, I would be ok with simply moving the call to
vtime_account_guest_exit() to after IRQs are enabled.  It would bug me a little
bit that KVM _could_ be more precise when running with
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y, and KVM would still be poking into the details
of vtime_account_guest_exit() to some extent, but overall it would be an
improvement from a code cleanliness perspective.

The problem is I have no clue who, if anyone, deploys KVM on x86 with
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y.  On the other hand, AMD/SVM has always had the
"inaccurate" accounting, and Intel/VMX has been inaccurate since commit
d7a08882a0a4 ("KVM: x86: Unconditionally enable irqs in guest context"), which
amusingly was a fix for an edge case in tick-based accounting.

Anyone have an opinion either way?  I'm very tempted to go with Frederic's
suggestion of moving the time accounting back to where it was, it makes KVM just
a little less ugly.
