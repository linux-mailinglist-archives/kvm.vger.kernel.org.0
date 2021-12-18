Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E4E4799DA
	for <lists+kvm@lfdr.de>; Sat, 18 Dec 2021 10:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbhLRJIl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 18 Dec 2021 04:08:41 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:33863 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhLRJIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Dec 2021 04:08:41 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JGKl73hMgzcbxv;
        Sat, 18 Dec 2021 17:08:19 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 18 Dec 2021 17:08:39 +0800
Received: from dggpeml100016.china.huawei.com ([7.185.36.216]) by
 dggpeml100016.china.huawei.com ([7.185.36.216]) with mapi id 15.01.2308.020;
 Sat, 18 Dec 2021 17:08:39 +0800
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Huangzhichao <huangzhichao@huawei.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: The vcpu won't be wakened for a long time
Thread-Topic: The vcpu won't be wakened for a long time
Thread-Index: Adfw8hOY5GAlKZgbTtqexw2IMvmqfP//t/OA//yjT/CABmGSgP/8xDNw
Date:   Sat, 18 Dec 2021 09:08:39 +0000
Message-ID: <8a1a3ac75a6e4acf9bd1ce9779835e1c@huawei.com>
References: <73d46f3cc46a499c8e39fdf704b2deaf@huawei.com>
 <YbjWFTtNo9Ap7kDp@google.com> <9e5aef1ae0c141e49c2b1d19692b9295@huawei.com>
 <Ybtea42RxZ9aVzCh@google.com>
In-Reply-To: <Ybtea42RxZ9aVzCh@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.148.223]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Sean Christopherson [mailto:seanjc@google.com]
> Sent: Thursday, December 16, 2021 11:43 PM
> To: Longpeng (Mike, Cloud Infrastructure Service Product Dept.)
> <longpeng2@huawei.com>
> Cc: pbonzini@redhat.com; kvm@vger.kernel.org; Gonglei (Arei)
> <arei.gonglei@huawei.com>; Huangzhichao <huangzhichao@huawei.com>; Wanpeng Li
> <wanpengli@tencent.com>; Vitaly Kuznetsov <vkuznets@redhat.com>; Jim Mattson
> <jmattson@google.com>; Joerg Roedel <joro@8bytes.org>; linux-kernel
> <linux-kernel@vger.kernel.org>
> Subject: Re: The vcpu won't be wakened for a long time
> 
> On Thu, Dec 16, 2021, Longpeng (Mike, Cloud Infrastructure Service Product Dept.)
> wrote:
> > > What kernel version?  There have been a variety of fixes/changes in the
> > > area in recent kernels.
> >
> > The kernel version is 4.18, and it seems the latest kernel also has this problem.
> >
> > The following code can fixes this bug, I've tested it on 4.18.
> >
> > (4.18)
> >
> > @@ -3944,6 +3944,11 @@ static void vmx_deliver_posted_interrupt(struct
> kvm_vcpu *vcpu, int vector)
> >         if (pi_test_and_set_on(&vmx->pi_desc))
> >                 return;
> >
> > +       if (swq_has_sleeper(kvm_arch_vcpu_wq(vcpu))) {
> > +               kvm_vcpu_kick(vcpu);
> > +               return;
> > +       }
> > +
> >         if (vcpu != kvm_get_running_vcpu() &&
> >                 !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
> >                 kvm_vcpu_kick(vcpu);
> >
> >
> > (latest)
> >
> > @@ -3959,6 +3959,11 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu
> *vcpu, int vector)
> >         if (pi_test_and_set_on(&vmx->pi_desc))
> >                 return 0;
> >
> > +       if (rcuwait_active(&vcpu->wait)) {
> > +               kvm_vcpu_kick(vcpu);
> > +               return 0;
> > +       }
> > +
> >         if (vcpu != kvm_get_running_vcpu() &&
> >             !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
> >                 kvm_vcpu_kick(vcpu);
> >
> > Do you have any suggestions ?
> 
> Hmm, that strongly suggests the "vcpu != kvm_get_running_vcpu()" is at fault.
> Can you try running with the below commit?  It's currently sitting in kvm/queue,
> but not marked for stable because I didn't think it was possible for the check
> to a cause a missed wake event in KVM's current code base.
> 

The below commit can fix the bug, we have just completed  the tests.
Thanks.

> commit 6a8110fea2c1b19711ac1ef718680dfd940363c6
> Author: Sean Christopherson <seanjc@google.com>
> Date:   Wed Dec 8 01:52:27 2021 +0000
> 
>     KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU == this vCPU
> 
>     Drop a check that guards triggering a posted interrupt on the currently
>     running vCPU, and more importantly guards waking the target vCPU if
>     triggering a posted interrupt fails because the vCPU isn't IN_GUEST_MODE.
>     The "do nothing" logic when "vcpu == running_vcpu" works only because KVM
>     doesn't have a path to ->deliver_posted_interrupt() from asynchronous
>     context, e.g. if apic_timer_expired() were changed to always go down the
>     posted interrupt path for APICv, or if the IN_GUEST_MODE check in
>     kvm_use_posted_timer_interrupt() were dropped, and the hrtimer fired in
>     kvm_vcpu_block() after the final kvm_vcpu_check_block() check, the vCPU
>     would be scheduled() out without being awakened, i.e. would "miss" the
>     timer interrupt.
> 
>     One could argue that invoking kvm_apic_local_deliver() from (soft) IRQ
>     context for the current running vCPU should be illegal, but nothing in
>     KVM actually enforces that rules.  There's also no strong obvious benefit
>     to making such behavior illegal, e.g. checking IN_GUEST_MODE and calling
>     kvm_vcpu_wake_up() is at worst marginally more costly than querying the
>     current running vCPU.
> 
>     Lastly, this aligns the non-nested and nested usage of triggering posted
>     interrupts, and will allow for additional cleanups.
> 
>     Signed-off-by: Sean Christopherson <seanjc@google.com>
>     Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>     Message-Id: <20211208015236.1616697-18-seanjc@google.com>
>     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 38749063da0e..f61a6348cffd 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3995,8 +3995,7 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu
> *vcpu, int vector)
>          * guaranteed to see PID.ON=1 and sync the PIR to IRR if triggering a
>          * posted interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
>          */
> -       if (vcpu != kvm_get_running_vcpu() &&
> -           !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
> +       if (!kvm_vcpu_trigger_posted_interrupt(vcpu, false))
>                 kvm_vcpu_wake_up(vcpu);
> 
>         return 0;
