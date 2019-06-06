Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB2E437A91
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 19:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbfFFRIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 13:08:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:45136 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726693AbfFFRIr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 13:08:47 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 10:08:38 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jun 2019 10:08:37 -0700
Date:   Thu, 6 Jun 2019 10:08:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] Revert "KVM: nVMX: always use early vmcs check when
 EPT is disabled"
Message-ID: <20190606170837.GC23169@linux.intel.com>
References: <20190520201029.7126-1-sean.j.christopherson@intel.com>
 <20190520201029.7126-3-sean.j.christopherson@intel.com>
 <40c7c3ee-9c49-1df6-c80b-1bc7811ccf69@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40c7c3ee-9c49-1df6-c80b-1bc7811ccf69@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 06, 2019 at 02:22:56PM +0200, Paolo Bonzini wrote:
> On 20/05/19 22:10, Sean Christopherson wrote:
> > @@ -3777,18 +3777,8 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
> >  	vmx_set_cr4(vcpu, vmcs_readl(CR4_READ_SHADOW));
> >  
> >  	nested_ept_uninit_mmu_context(vcpu);
> > -
> > -	/*
> > -	 * This is only valid if EPT is in use, otherwise the vmcs01 GUEST_CR3
> > -	 * points to shadow pages!  Fortunately we only get here after a WARN_ON
> > -	 * if EPT is disabled, so a VMabort is perfectly fine.
> > -	 */
> > -	if (enable_ept) {
> > -		vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
> > -		__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
> > -	} else {
> > -		nested_vmx_abort(vcpu, VMX_ABORT_VMCS_CORRUPTED);
> > -	}
> > +	vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
> > +	__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
> >  
> >  	/*
> >  	 * Use ept_save_pdptrs(vcpu) to load the MMU's cached PDPTRs
> 
> This hunk needs to be moved to patch 1, which then becomes much easier
> to understand...

I kept the revert in a separate patch so that the bug fix could be
easily backported to stable branches (commit 2b27924bb1d4 ("KVM: nVMX:
always use early vmcs check when EPT is disabled" wasn't tagged for
stable).

> I'm still missing however the place where kvm_mmu_new_cr3 is called
> in the nested_vmx_restore_host_state path.

vcpu->arch.root_mmu.root_hpa is set to INVALID_PAGE via:

    nested_vmx_restore_host_state() ->
        kvm_mmu_reset_context() ->
            kvm_mmu_unload() ->
                kvm_mmu_free_roots()

kvm_mmu_unload() has WARN_ON(root_hpa != INVALID_PAGE), i.e. we can bank
on 'root_hpa == INVALID_PAGE' unless the implementation of
kvm_mmu_reset_context() is changed.

On the way into L1, VMCS.GUEST_CR3 is guaranteed to be written (on a
successful entry) via:

    vcpu_enter_guest() ->
        kvm_mmu_reload() ->
            kvm_mmu_load() ->
                kvm_mmu_load_cr3() ->
                    vmx_set_cr3()

The optimization in kvm_mmu_reload() will fail because kvm_mmu_unload()
set vcpu->arch.root_mmu.root_hpa=INVALID_PAGE, and vcpu->arch.mmu is
guaranteed to point at root_mmu (via nested_ept_uninit_mmu_context()).
