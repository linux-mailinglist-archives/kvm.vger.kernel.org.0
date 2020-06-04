Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732981EE82A
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 18:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbgFDQCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 12:02:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:45312 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729544AbgFDQCy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 12:02:54 -0400
IronPort-SDR: l6jLOIbXa0SmQ3W6wmt1jD0DTiJ5RhXB3Ofa+Qk6TZpIJCIte+ojNTdeDe/umUZ52X8Ph3fQyy
 xBuWriJUuXFw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 09:02:53 -0700
IronPort-SDR: XfMIW/slEzHy8FEIrNuiLel4FFfrQXWrAk8p53myPCBWxxfKJlWe+z6o6XyUVmNCtSwYxqx9Xt
 QXKInEXDxYXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,472,1583222400"; 
   d="scan'208";a="258926535"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 04 Jun 2020 09:02:53 -0700
Date:   Thu, 4 Jun 2020 09:02:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Inject #GP when nested_vmx_get_vmptr() fails
 to read guest memory
Message-ID: <20200604160253.GF30223@linux.intel.com>
References: <20200604143158.484651-1-vkuznets@redhat.com>
 <da7acd6f-204d-70e2-52aa-915a4d9163ef@redhat.com>
 <20200604145357.GA30223@linux.intel.com>
 <87k10meth6.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k10meth6.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 04, 2020 at 05:33:25PM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > On Thu, Jun 04, 2020 at 04:40:52PM +0200, Paolo Bonzini wrote:
> >> On 04/06/20 16:31, Vitaly Kuznetsov wrote:
> >
> > ...
> >
> >> > KVM could've handled the request correctly by going to userspace and
> >> > performing I/O but there doesn't seem to be a good need for such requests
> >> > in the first place. Sane guests should not call VMXON/VMPTRLD/VMCLEAR with
> >> > anything but normal memory. Just inject #GP to find insane ones.
> >> > 
> 
> ...
> 
> >> 
> >> looks good but we need to do the same in handle_vmread, handle_vmwrite,
> >> handle_invept and handle_invvpid.  Which probably means adding something
> >> like nested_inject_emulation_fault to commonize the inner "if".
> >
> > Can we just kill the guest already instead of throwing more hacks at this
> > and hoping something sticks?  We already have one in
> > kvm_write_guest_virt_system...
> >
> >   commit 541ab2aeb28251bf7135c7961f3a6080eebcc705
> >   Author: Fuqian Huang <huangfq.daxian@gmail.com>
> >   Date:   Thu Sep 12 12:18:17 2019 +0800
> >
> >     KVM: x86: work around leak of uninitialized stack contents
> >
> 
> Oh I see...
> 
> [...]
> 
> Let's get back to 'vm_bugged' idea then? 
> 
> https://lore.kernel.org/kvm/87muadnn1t.fsf@vitty.brq.redhat.com/

Hmm, I don't think we need to go that far.  The 'vm_bugged' idea was more
to handle cases where KVM itself (or hardware) screwed something up and
detects an issue deep in a call stack with no recourse for reporting the
error up the stack.

That isn't the case here.  Unless I'm mistaken, the end result is simliar
to this patch, except that KVM would exit to userspace with
KVM_INTERNAL_ERROR_EMULATION instead of injecting a #GP.  E.g.

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9c74a732b08d..e13d2c0014e2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4624,6 +4624,20 @@ void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
        }
 }

+static int nested_vmx_handle_memory_failure(struct kvm_vcpu *vcpu, int ret,
+                                           struct x86_exception *e)
+{
+       if (r == X86EMUL_PROPAGATE_FAULT) {
+               kvm_inject_emulated_page_fault(vcpu, &e);
+               return 1;
+       }
+
+       vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+       vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+       vcpu->run->internal.ndata = 0;
+       return 0;
+}
+
 static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer)
 {
        gva_t gva;
@@ -4634,11 +4648,9 @@ static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer)
                                sizeof(*vmpointer), &gva))
                return 1;

-       if (kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e)) {
-               kvm_inject_emulated_page_fault(vcpu, &e);
-               return 1;
-       }
-
+       r kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e);
+       if (r)
+               return nested_vmx_handle_memory_failure(r, &e);
        return 0;
 }



Side topic, I have some preliminary patches for the 'vm_bugged' idea.  I'll
try to whip them into something that can be posted upstream in the next few
weeks.
