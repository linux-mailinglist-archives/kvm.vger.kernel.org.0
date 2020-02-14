Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10C4115F8CE
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 22:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388686AbgBNVd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 16:33:58 -0500
Received: from mga14.intel.com ([192.55.52.115]:65043 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388332AbgBNVd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 16:33:58 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 13:33:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,441,1574150400"; 
   d="scan'208";a="223151442"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 14 Feb 2020 13:33:57 -0800
Date:   Fri, 14 Feb 2020 13:33:57 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2] KVM: X86: Grab KVM's srcu lock when accessing hv
 assist page
Message-ID: <20200214213357.GH20690@linux.intel.com>
References: <CANRm+CznPq3LQUyiXr8nA7uP5q+d8Ud-Ki-W7vPCo_BjDJtOSw@mail.gmail.com>
 <7171e537-27f9-c1e5-ae32-9305710be2c7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7171e537-27f9-c1e5-ae32-9305710be2c7@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The subject shoud be rewritten to simply states that the vmcs12->shadow
sync is being.  The changelog can explain the motiviation, but a one-line
git log should clearly reveal that this affects the shadow VMCS.

Subsystem should also be "KVM: nVMX:"

On Fri, Feb 14, 2020 at 10:27:12AM +0100, Paolo Bonzini wrote:
> On 14/02/20 10:16, Wanpeng Li wrote:
> > From: wanpeng li <wanpengli@tencent.com>
> > 
> > For the duration of mapping eVMCS, it derefences ->memslots without holding
> > ->srcu or ->slots_lock when accessing hv assist page. This patch fixes it by
> > moving nested_sync_vmcs12_to_shadow to prepare_guest_switch, where the SRCU
> > is already taken.
> 
> Looks good, but I'd like an extra review from Sean or Vitaly.
> 
> We also should add a WARN_ON_ONCE that replaces the previous location of
> the "if (vmx->nested.need_vmcs12_to_shadow_sync)", but I can do that myself.
> 
> Thanks,
> 
> Paolo
> 
> > It can be reproduced by running kvm's evmcs_test selftest.
> > 
> >   =============================
> >   warning: suspicious rcu usage
> >   5.6.0-rc1+ #53 tainted: g        w ioe
> >   -----------------------------
> >   ./include/linux/kvm_host.h:623 suspicious rcu_dereference_check() usage!
> > 
> >   other info that might help us debug this:
> > 
> >    rcu_scheduler_active = 2, debug_locks = 1
> >   1 lock held by evmcs_test/8507:
> >    #0: ffff9ddd156d00d0 (&vcpu->mutex){+.+.}, at:
> > kvm_vcpu_ioctl+0x85/0x680 [kvm]
> > 
> >   stack backtrace:
> >   cpu: 6 pid: 8507 comm: evmcs_test tainted: g        w ioe     5.6.0-rc1+ #53
> >   hardware name: dell inc. optiplex 7040/0jctf8, bios 1.4.9 09/12/2016
> >   call trace:
> >    dump_stack+0x68/0x9b
> >    kvm_read_guest_cached+0x11d/0x150 [kvm]
> >    kvm_hv_get_assist_page+0x33/0x40 [kvm]
> >    nested_enlightened_vmentry+0x2c/0x60 [kvm_intel]
> >    nested_vmx_handle_enlightened_vmptrld.part.52+0x32/0x1c0 [kvm_intel]
> >    nested_sync_vmcs12_to_shadow+0x439/0x680 [kvm_intel]
> >    vmx_vcpu_run+0x67a/0xe60 [kvm_intel]
> >    vcpu_enter_guest+0x35e/0x1bc0 [kvm]
> >    kvm_arch_vcpu_ioctl_run+0x40b/0x670 [kvm]
> >    kvm_vcpu_ioctl+0x370/0x680 [kvm]
> >    ksys_ioctl+0x235/0x850
> >    __x64_sys_ioctl+0x16/0x20
> >    do_syscall_64+0x77/0x780
> >    entry_syscall_64_after_hwframe+0x49/0xbe
> > 
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 9a66648..6bd6ca4 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -1214,6 +1214,9 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
> > 
> >      vmx_set_host_fs_gs(host_state, fs_sel, gs_sel, fs_base, gs_base);
> >      vmx->guest_state_loaded = true;
> > +
> > +    if (vmx->nested.need_vmcs12_to_shadow_sync)
> > +        nested_sync_vmcs12_to_shadow(vcpu);

This needs to be above the short circuit check on guest_state_loaded, e.g.:

	if (vmx->nested.need_vmcs12_to_shadow_sync)
		nested_sync_vmcs12_to_shadow(vcpu);

	if (vmx->guest_state_loaded)
		return;

> >  }
> > 
> >  static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
> > @@ -6480,9 +6483,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >          vmcs_write32(PLE_WINDOW, vmx->ple_window);
> >      }
> > 
> > -    if (vmx->nested.need_vmcs12_to_shadow_sync)
> > -        nested_sync_vmcs12_to_shadow(vcpu);
> > -
> >      if (kvm_register_is_dirty(vcpu, VCPU_REGS_RSP))
> >          vmcs_writel(GUEST_RSP, vcpu->arch.regs[VCPU_REGS_RSP]);
> >      if (kvm_register_is_dirty(vcpu, VCPU_REGS_RIP))
> > --
> > 2.7.4
> > 
> 
