Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFE224E4F2
	for <lists+kvm@lfdr.de>; Sat, 22 Aug 2020 05:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgHVDku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 23:40:50 -0400
Received: from mga18.intel.com ([134.134.136.126]:27132 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726588AbgHVDkt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 23:40:49 -0400
IronPort-SDR: XI8iZwOPVRae2SmO+ZrWvqBwxj/r8G/3aocDDZ2He1icgfqhzknynFypuWlhlsC39tZyYJlNQt
 CGEdwDtgDiog==
X-IronPort-AV: E=McAfee;i="6000,8403,9720"; a="143314513"
X-IronPort-AV: E=Sophos;i="5.76,339,1592895600"; 
   d="scan'208";a="143314513"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 20:40:48 -0700
IronPort-SDR: mOIn+FLsb6AuSFKJaaWlUZqjfnGTlLWwIYCCjdzZV6hPJlZXc7LShklM3zKdnwjO/NhfmTI97Y
 6923My5/k4Fw==
X-IronPort-AV: E=Sophos;i="5.76,339,1592895600"; 
   d="scan'208";a="401644126"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 20:40:47 -0700
Date:   Fri, 21 Aug 2020 20:40:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: fix crash cleanup when KVM wasn't used
Message-ID: <20200822034046.GE4769@sjchrist-ice>
References: <20200401081348.1345307-1-vkuznets@redhat.com>
 <CALMp9eROXAOg_g=R8JRVfywY7uQXzBtVxKJYXq0dUcob-BfR-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eROXAOg_g=R8JRVfywY7uQXzBtVxKJYXq0dUcob-BfR-g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 20, 2020 at 01:08:22PM -0700, Jim Mattson wrote:
> On Wed, Apr 1, 2020 at 1:13 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 3aba51d782e2..39a5dde12b79 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -2257,10 +2257,6 @@ static int hardware_enable(void)
> >             !hv_get_vp_assist_page(cpu))
> >                 return -EFAULT;
> >
> > -       INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> > -       INIT_LIST_HEAD(&per_cpu(blocked_vcpu_on_cpu, cpu));
> > -       spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
> > -
> >         r = kvm_cpu_vmxon(phys_addr);
> >         if (r)
> >                 return r;
> > @@ -8006,7 +8002,7 @@ module_exit(vmx_exit);
> >
> >  static int __init vmx_init(void)
> >  {
> > -       int r;
> > +       int r, cpu;
> >
> >  #if IS_ENABLED(CONFIG_HYPERV)
> >         /*
> > @@ -8060,6 +8056,12 @@ static int __init vmx_init(void)
> >                 return r;
> >         }
> >
> > +       for_each_possible_cpu(cpu) {
> > +               INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> > +               INIT_LIST_HEAD(&per_cpu(blocked_vcpu_on_cpu, cpu));
> > +               spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
> > +       }
> 
> Just above this chunk, we have:
> 
> r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
> if (r) {
>         vmx_exit();
> ...
> 
> If we take that early exit, because vmx_setup_l1d_flush() fails, we
> won't initialize loaded_vmcss_on_cpu. However, vmx_exit() calls
> kvm_exit(), which calls on_each_cpu(hardware_disable_nolock, NULL, 1).
> Hardware_disable_nolock() then calls kvm_arch_hardware_disable(),
> which calls kvm_x86_ops.hardware_disable() [the vmx.c
> hardware_disable()], which calls vmclear_local_loaded_vmcss().
> 
> I believe that vmclear_local_loaded_vmcss() will then try to
> dereference a NULL pointer, since per_cpu(loaded_vmcss_on_cpu, cpu) is
> uninitialzed.

I agree the code is a mess (kvm_init() and kvm_exit() included), but I'm
pretty sure hardware_disable_nolock() is guaranteed to be a nop as it's
impossible for kvm_usage_count to be non-zero if vmx_init() hasn't
finished.

> >  #ifdef CONFIG_KEXEC_CORE
> >         rcu_assign_pointer(crash_vmclear_loaded_vmcss,
> >                            crash_vmclear_local_loaded_vmcss);
> > --
> > 2.25.1
> >
