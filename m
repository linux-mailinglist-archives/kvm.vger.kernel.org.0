Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDBF18793A
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 06:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgCQF3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 01:29:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:36414 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgCQF3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 01:29:23 -0400
IronPort-SDR: XaZZiAzL+9Qd45yLhedp9xWJo+ddeOULHtMv3kZ1Wuc+cDdeyU/qncQU/RY6HeQnND6EjeN0kx
 xXgf0iSI6MXA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 22:29:23 -0700
IronPort-SDR: PUIlMNm7xVASLuPlejGWZhuu0wSElctBxpEEQS5vYpKR5cGY/eZM5jT1eChKj5aHr23GA9uDaP
 Y/xHmnqh0MWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="262919627"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 16 Mar 2020 22:29:22 -0700
Date:   Mon, 16 Mar 2020 22:29:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 06/10] KVM: nVMX: Convert local exit_reason to u16 in
 ...enter_non_root_mode()
Message-ID: <20200317052922.GQ24267@linux.intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com>
 <20200312184521.24579-7-sean.j.christopherson@intel.com>
 <87pndgnyud.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pndgnyud.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 13, 2020 at 02:55:38PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Use a u16 for nested_vmx_enter_non_root_mode()'s local "exit_reason" to
> > make it clear the intermediate code is only responsible for setting the
> > basic exit reason, e.g. FAILED_VMENTRY is unconditionally OR'd in when
> > emulating a failed VM-Entry.
> >
> > No functional change intended.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 1848ca0116c0..8fbbe2152ab7 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -3182,7 +3182,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> >  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> >  	bool evaluate_pending_interrupts;
> > -	u32 exit_reason = EXIT_REASON_INVALID_STATE;
> > +	u16 exit_reason = EXIT_REASON_INVALID_STATE;
> >  	u32 exit_qual;
> >  
> >  	evaluate_pending_interrupts = exec_controls_get(vmx) &
> > @@ -3308,7 +3308,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> >  		return NVMX_VMENTRY_VMEXIT;
> >  
> >  	load_vmcs12_host_state(vcpu, vmcs12);
> > -	vmcs12->vm_exit_reason = exit_reason | VMX_EXIT_REASONS_FAILED_VMENTRY;
> > +	vmcs12->vm_exit_reason = VMX_EXIT_REASONS_FAILED_VMENTRY | exit_reason;
> 
> My personal preference would be to do
>  (u32)exit_reason | VMX_EXIT_REASONS_FAILED_VMENTRY 
> instead but maybe I'm just not in love with implicit type convertion in C.

Either way works for me.  Paolo?
