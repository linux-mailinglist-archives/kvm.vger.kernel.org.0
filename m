Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD611EE702
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 16:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbgFDOx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 10:53:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:7508 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729115AbgFDOx6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 10:53:58 -0400
IronPort-SDR: 12LJ8/wV8Ft7m3YTxGepw3c8Yhy72NMhbO6OrV/5aRf6OVycD3H4u9pA2PgTP+51p2A89j2q3l
 BvJU3K3W8lMQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 07:53:57 -0700
IronPort-SDR: 8ETeAVtoSYMA43db23qetcezChvupW5d/MOYb+LcSrr6k/pIV2RwyqAHZSpqC3QdHWLcEvJAXD
 0p5mi5Yv8yeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,472,1583222400"; 
   d="scan'208";a="471444497"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 04 Jun 2020 07:53:57 -0700
Date:   Thu, 4 Jun 2020 07:53:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Inject #GP when nested_vmx_get_vmptr() fails
 to read guest memory
Message-ID: <20200604145357.GA30223@linux.intel.com>
References: <20200604143158.484651-1-vkuznets@redhat.com>
 <da7acd6f-204d-70e2-52aa-915a4d9163ef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da7acd6f-204d-70e2-52aa-915a4d9163ef@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 04, 2020 at 04:40:52PM +0200, Paolo Bonzini wrote:
> On 04/06/20 16:31, Vitaly Kuznetsov wrote:

...

> > KVM could've handled the request correctly by going to userspace and
> > performing I/O but there doesn't seem to be a good need for such requests
> > in the first place. Sane guests should not call VMXON/VMPTRLD/VMCLEAR with
> > anything but normal memory. Just inject #GP to find insane ones.
> > 
> > Reported-by: syzbot+2a7156e11dc199bdbd8a@syzkaller.appspotmail.com
> > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 19 +++++++++++++++++--
> >  1 file changed, 17 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 9c74a732b08d..05d57c3cb1ce 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -4628,14 +4628,29 @@ static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer)
> >  {
> >  	gva_t gva;
> >  	struct x86_exception e;
> > +	int r;
> >  
> >  	if (get_vmx_mem_address(vcpu, vmx_get_exit_qual(vcpu),
> >  				vmcs_read32(VMX_INSTRUCTION_INFO), false,
> >  				sizeof(*vmpointer), &gva))
> >  		return 1;
> >  
> > -	if (kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e)) {
> > -		kvm_inject_emulated_page_fault(vcpu, &e);
> > +	r = kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e);
> > +	if (r != X86EMUL_CONTINUE) {
> > +		if (r == X86EMUL_PROPAGATE_FAULT) {
> > +			kvm_inject_emulated_page_fault(vcpu, &e);
> > +		} else {
> > +			/*
> > +			 * X86EMUL_IO_NEEDED is returned when kvm_vcpu_read_guest_page()
> > +			 * fails to read guest's memory (e.g. when 'gva' points to MMIO
> > +			 * space). While KVM could've handled the request correctly by
> > +			 * exiting to userspace and performing I/O, there doesn't seem
> > +			 * to be a real use-case behind such requests, just inject #GP
> > +			 * for now.
> > +			 */
> > +			kvm_inject_gp(vcpu, 0);
> > +		}
> > +
> >  		return 1;
> >  	}
> >  
> > 
> 
> Hi Vitaly,
> 
> looks good but we need to do the same in handle_vmread, handle_vmwrite,
> handle_invept and handle_invvpid.  Which probably means adding something
> like nested_inject_emulation_fault to commonize the inner "if".

Can we just kill the guest already instead of throwing more hacks at this
and hoping something sticks?  We already have one in
kvm_write_guest_virt_system...

  commit 541ab2aeb28251bf7135c7961f3a6080eebcc705
  Author: Fuqian Huang <huangfq.daxian@gmail.com>
  Date:   Thu Sep 12 12:18:17 2019 +0800

    KVM: x86: work around leak of uninitialized stack contents

    Emulation of VMPTRST can incorrectly inject a page fault
    when passed an operand that points to an MMIO address.
    The page fault will use uninitialized kernel stack memory
    as the CR2 and error code.

    The right behavior would be to abort the VM with a KVM_EXIT_INTERNAL_ERROR
    exit to userspace; however, it is not an easy fix, so for now just ensure
    that the error code and CR2 are zero.

