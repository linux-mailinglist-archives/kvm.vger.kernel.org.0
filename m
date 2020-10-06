Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398AE2853D3
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 23:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgJFVWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 17:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727301AbgJFVWt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 17:22:49 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D313EC061755
        for <kvm@vger.kernel.org>; Tue,  6 Oct 2020 14:22:48 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id z8so2977003lfd.11
        for <kvm@vger.kernel.org>; Tue, 06 Oct 2020 14:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kqf0mfPbDxUJw+w6TI82pAryJKbZXD6ERc1Br897awA=;
        b=FVUrmxNSnwxfguQIoLwhB3PwdpdxFvlIvs7dmFxZEFRTNZoW/rhfFleYV0ZKhMLZB0
         +09XmvwJTp2Fvz6umhz3jUcC9+lFcx5t//ysmFtqT2zBHlMGEDPtpTc8O84R2tH0wKmF
         JIm6IRLP/+1wSUsC2H/vUfMizhs/HCKrSyq2ULOT3LvG1fJKxBrkum5INBXF5T1qgnyl
         zL73DYY0CIujLPhx0haxCU00wxNNA5BZnUzDq+UIzBvp5vJzU+Zn9nAI6M0ubx7j+SYK
         rVON5EqLho0hbxs5mvEZ3LKqwJszdwE+qU34S34yH1KcI579XxJQsemZ1AFM+QoqDUbg
         x0QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kqf0mfPbDxUJw+w6TI82pAryJKbZXD6ERc1Br897awA=;
        b=o3EZcW+O3ZJ4NqpsYp9NiHNBL7QXWIIfZpB+aM4Lv0xRlKEfQv7t6y6OLD1+ydKLr9
         K6E14Vl3XFuhoh0fgOHqzzPhj+Coz/XfLl/VWN7L0EhoX34zYcauVawOOI/IPYZ+iuM9
         PVsNF3C6JiyHzX7JFr3nAXcAGpN3OUa3aMDaX6De1M3HP18IC/AGvVZloBIfFmgdapwE
         UVeYYQRjr7qsM/KYbPNZSS7xpofercQtpm5w4uGy+qmNwqr1df+eMYhBZQ4YjM++Lmv5
         uGIQkvj+sHUYe0Fr1MGIiAY/l3f+BNpso09jrBo+TsdcuKxtV0SA4i7kC5z49WvWwJlW
         A4VQ==
X-Gm-Message-State: AOAM532rg0tEX/XRwC32UsJsSxS/epGzqlcXkCQWxHm6EPpFcSrYfX+d
        A95riv7HqRXohbt2/gwFitvdTK40onbjEmZcbsw5fw==
X-Google-Smtp-Source: ABdhPJzDVu79X2bMHe1wvPdya0pCa53aKeq61U6EVOSzv1ylR6iO7CRJesyo+0hXqfdtsNs6ZWvtr6Nf0LrbXRMyMGU=
X-Received: by 2002:ac2:4316:: with SMTP id l22mr1047155lfh.310.1602019366938;
 Tue, 06 Oct 2020 14:22:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200812175129.12172-1-sean.j.christopherson@intel.com>
 <CALMp9eTc9opgQ4pU92wmKSM6gUv6AEKZRqSnv_Q+rzixOLOZiw@mail.gmail.com> <20201006183501.GD17610@linux.intel.com>
In-Reply-To: <20201006183501.GD17610@linux.intel.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 6 Oct 2020 14:22:35 -0700
Message-ID: <CAOQ_Qsgycf+p1=XfWVdG+2qpECcMWvPP7L5hM-AJN-V-_brv7g@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Morph notification vector IRQ on nested
 VM-Enter to pending PI
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 6, 2020 at 11:35 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Oct 06, 2020 at 10:36:09AM -0700, Jim Mattson wrote:
> > On Wed, Aug 12, 2020 at 10:51 AM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > On successful nested VM-Enter, check for pending interrupts and convert
> > > the highest priority interrupt to a pending posted interrupt if it
> > > matches L2's notification vector.  If the vCPU receives a notification
> > > interrupt before nested VM-Enter (assuming L1 disables IRQs before doing
> > > VM-Enter), the pending interrupt (for L1) should be recognized and
> > > processed as a posted interrupt when interrupts become unblocked after
> > > VM-Enter to L2.
> > >
> > > This fixes a bug where L1/L2 will get stuck in an infinite loop if L1 is
> > > trying to inject an interrupt into L2 by setting the appropriate bit in
> > > L2's PIR and sending a self-IPI prior to VM-Enter (as opposed to KVM's
> > > method of manually moving the vector from PIR->vIRR/RVI).  KVM will
> > > observe the IPI while the vCPU is in L1 context and so won't immediately
> > > morph it to a posted interrupt for L2.  The pending interrupt will be
> > > seen by vmx_check_nested_events(), cause KVM to force an immediate exit
> > > after nested VM-Enter, and eventually be reflected to L1 as a VM-Exit.
> > > After handling the VM-Exit, L1 will see that L2 has a pending interrupt
> > > in PIR, send another IPI, and repeat until L2 is killed.
> > >
> > > Note, posted interrupts require virtual interrupt deliveriy, and virtual
> > > interrupt delivery requires exit-on-interrupt, ergo interrupts will be
> > > unconditionally unmasked on VM-Enter if posted interrupts are enabled.
> > >
> > > Fixes: 705699a13994 ("KVM: nVMX: Enable nested posted interrupt processing")
> > > Cc: stable@vger.kernel.org
> > > Cc: Liran Alon <liran.alon@oracle.com>
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > ---
> > I don't think this is the best fix.
>
> I agree, even without any more explanantion :-)
>
> > I believe the real problem is the way that external and posted
> > interrupts are handled in vmx_check_nested_events().
> >
> > First of all, I believe that the existing call to
> > vmx_complete_nested_posted_interrupt() at the end of
> > vmx_check_nested_events() is far too aggressive. Unless I am missing
> > something in the SDM, posted interrupt processing is *only* triggered
> > when the notification vector is received in VMX non-root mode. It is
> > not triggered on VM-entry.
>
> That's my understanding as well.  Virtual interrupt delivery is evaluated
> on VM-Enter, but not posted interrupts.
>
>   Evaluation of pending virtual interrupts is caused only by VM entry, TPR
>   virtualization, EOI virtualization, self-IPI virtualization, and posted-
>   interrupt processing.
>
> > Looking back one block, we have:
> >
> > if (kvm_cpu_has_interrupt(vcpu) && !vmx_interrupt_blocked(vcpu)) {
> >     if (block_nested_events)
> >         return -EBUSY;
> >     if (!nested_exit_on_intr(vcpu))
> >         goto no_vmexit;
> >     nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT, 0, 0);
> >     return 0;
> > }
> >
> > If nested_exit_on_intr() is true, we should first check to see if
> > "acknowledge interrupt on exit" is set. If so, we should acknowledge
> > the interrupt right here, with a call to kvm_cpu_get_interrupt(),
> > rather than deep in the guts of nested_vmx_vmexit(). If the vector we
> > get is the notification vector from VMCS12, then we should call
> > vmx_complete_nested_posted_interrupt(). Otherwise, we should call
> > nested_vmx_vmexit(EXIT_REASON_EXTERNAL_INTERRUPT) as we do now.
>
> That makes sense.  And we can pass in exit_intr_info instead of computing
> it in nested_vmx_vmexit() since this is the only path that does a nested
> exit with EXIT_REASON_EXTERNAL_INTERRUPT.
>
> > Furthermore, vmx_complete_nested_posted_interrupt() should write to
> > the L1 EOI register, as indicated in step 4 of the 7-step sequence
> > detailed in section 29.6 of the SDM, volume 3. It skips this step
> > today.
>
> Yar.
>
> Thanks Jim!  I'll get a series out.

Hey Sean,

I actually ran into this issue as well before noticing your patch. I
have a repro kvm-unit-test that I'll send out shortly.

Thanks for looking into this!

--
Oliver
