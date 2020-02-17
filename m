Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 355B7161319
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 14:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbgBQNQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 08:16:45 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:39383 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728424AbgBQNQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 08:16:44 -0500
Received: by mail-ot1-f68.google.com with SMTP id 77so16010289oty.6;
        Mon, 17 Feb 2020 05:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nuL8CtX55BPzoxygKW6S6mjcIN5tjUT7yCyHUMOTXFo=;
        b=uY++/MYyUuwsgE64k/bddQKpPdzGtkbxV+rSZh8QMqltJT0hYCIvJnjZX3pqR2nlHC
         aqqD/UAK3cMEOGdOoVQzgKbvz1LU1s4F3PqBtX4RIYrMan2knFMpp6iQove+FnCekIJx
         LL25CNd/avk2I8VoI4/VrPcOHxH3GsVD8Hm97VuLvAX7x4ljb6VCrQ/YmFn877xqDkuB
         gBcJvknwdcPJZre+JBdVZQlpTlAEJtMZilpKF9y7KFf6niLltb88TdB4cl1V2CgJwaUE
         jyQWQiQx+8WQK7qXO/vvk9amOfCdbb9vB+MPUZt5uxc5v/7n5rz1/eGLR1wjb5q8hy1S
         zDKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nuL8CtX55BPzoxygKW6S6mjcIN5tjUT7yCyHUMOTXFo=;
        b=mT7XRl2VlfGC6RhkHOXs+SbehXLRqOOrAa22C6H9Ug2Wq/zYdDPuMezhe9iT86eyzT
         U1NUr3w5RsuJtOezek9VhAsR/hAll4glrL21W8CsybDaqJ2H/WgwQ1nl2f8XNUQBwNt2
         unOaCj0Llsf8/YNac8pVhXmKylcIiFvVykwVYgS+91rAWIfmKZeMU5eDx+hLdgZRLsav
         i1f+87I3j393+9HnVQQ6yN38/jLQCPKDO6LVODVtPMXPJyaSFVkY9mW+wJ4t9dZugUlN
         yWZMdj1nsRVLNCzWQY5GxxpttNZvFTqhu8+o7jd+UzG0aCfk8SRtvGcuvDEDCDPUHIUu
         yGhw==
X-Gm-Message-State: APjAAAXjJa1je2D1yzQkmRYs93oZl/dUMS38NsKre1q3IvuzosFMFUWl
        X9m4teeGTfQ89SwO7ULQB2nySauWyis95p70PJo=
X-Google-Smtp-Source: APXvYqyO59KG3VGRDFRxNNSCDwt0uDuXL6mNedgykhIhPOwWQpJrde2FHja7BQSCWDOOV+Zqg2DIo1uZRUdPnbB9RPM=
X-Received: by 2002:a9d:7ccd:: with SMTP id r13mr11674114otn.56.1581945402563;
 Mon, 17 Feb 2020 05:16:42 -0800 (PST)
MIME-Version: 1.0
References: <CANRm+CznPq3LQUyiXr8nA7uP5q+d8Ud-Ki-W7vPCo_BjDJtOSw@mail.gmail.com>
 <7171e537-27f9-c1e5-ae32-9305710be2c7@redhat.com> <20200214213357.GH20690@linux.intel.com>
In-Reply-To: <20200214213357.GH20690@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 17 Feb 2020 21:16:31 +0800
Message-ID: <CANRm+CwEnrU0ErsxXd51K5muVyYypx5HME6ZNj1b2uEUN57gwQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: X86: Grab KVM's srcu lock when accessing hv
 assist page
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 15 Feb 2020 at 05:33, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> The subject shoud be rewritten to simply states that the vmcs12->shadow
> sync is being.  The changelog can explain the motiviation, but a one-line
> git log should clearly reveal that this affects the shadow VMCS.
>
> Subsystem should also be "KVM: nVMX:"
>
> On Fri, Feb 14, 2020 at 10:27:12AM +0100, Paolo Bonzini wrote:
> > On 14/02/20 10:16, Wanpeng Li wrote:
> > > From: wanpeng li <wanpengli@tencent.com>
> > >
> > > For the duration of mapping eVMCS, it derefences ->memslots without holding
> > > ->srcu or ->slots_lock when accessing hv assist page. This patch fixes it by
> > > moving nested_sync_vmcs12_to_shadow to prepare_guest_switch, where the SRCU
> > > is already taken.
> >
> > Looks good, but I'd like an extra review from Sean or Vitaly.
> >
> > We also should add a WARN_ON_ONCE that replaces the previous location of
> > the "if (vmx->nested.need_vmcs12_to_shadow_sync)", but I can do that myself.
> >
> > Thanks,
> >
> > Paolo
> >
> > > It can be reproduced by running kvm's evmcs_test selftest.
> > >
> > >   =============================
> > >   warning: suspicious rcu usage
> > >   5.6.0-rc1+ #53 tainted: g        w ioe
> > >   -----------------------------
> > >   ./include/linux/kvm_host.h:623 suspicious rcu_dereference_check() usage!
> > >
> > >   other info that might help us debug this:
> > >
> > >    rcu_scheduler_active = 2, debug_locks = 1
> > >   1 lock held by evmcs_test/8507:
> > >    #0: ffff9ddd156d00d0 (&vcpu->mutex){+.+.}, at:
> > > kvm_vcpu_ioctl+0x85/0x680 [kvm]
> > >
> > >   stack backtrace:
> > >   cpu: 6 pid: 8507 comm: evmcs_test tainted: g        w ioe     5.6.0-rc1+ #53
> > >   hardware name: dell inc. optiplex 7040/0jctf8, bios 1.4.9 09/12/2016
> > >   call trace:
> > >    dump_stack+0x68/0x9b
> > >    kvm_read_guest_cached+0x11d/0x150 [kvm]
> > >    kvm_hv_get_assist_page+0x33/0x40 [kvm]
> > >    nested_enlightened_vmentry+0x2c/0x60 [kvm_intel]
> > >    nested_vmx_handle_enlightened_vmptrld.part.52+0x32/0x1c0 [kvm_intel]
> > >    nested_sync_vmcs12_to_shadow+0x439/0x680 [kvm_intel]
> > >    vmx_vcpu_run+0x67a/0xe60 [kvm_intel]
> > >    vcpu_enter_guest+0x35e/0x1bc0 [kvm]
> > >    kvm_arch_vcpu_ioctl_run+0x40b/0x670 [kvm]
> > >    kvm_vcpu_ioctl+0x370/0x680 [kvm]
> > >    ksys_ioctl+0x235/0x850
> > >    __x64_sys_ioctl+0x16/0x20
> > >    do_syscall_64+0x77/0x780
> > >    entry_syscall_64_after_hwframe+0x49/0xbe
> > >
> > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > ---
> > >  arch/x86/kvm/vmx/vmx.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 9a66648..6bd6ca4 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -1214,6 +1214,9 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
> > >
> > >      vmx_set_host_fs_gs(host_state, fs_sel, gs_sel, fs_base, gs_base);
> > >      vmx->guest_state_loaded = true;
> > > +
> > > +    if (vmx->nested.need_vmcs12_to_shadow_sync)
> > > +        nested_sync_vmcs12_to_shadow(vcpu);
>
> This needs to be above the short circuit check on guest_state_loaded, e.g.:
>
>         if (vmx->nested.need_vmcs12_to_shadow_sync)
>                 nested_sync_vmcs12_to_shadow(vcpu);
>
>         if (vmx->guest_state_loaded)
>                 return;

Agreed, do it in new version.

    Wanpeng
