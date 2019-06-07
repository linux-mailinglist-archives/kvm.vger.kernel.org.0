Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C621A393A1
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 19:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbfFGRrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 13:47:55 -0400
Received: from mga05.intel.com ([192.55.52.43]:52612 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728684AbfFGRry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 13:47:54 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jun 2019 10:47:54 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga003.jf.intel.com with ESMTP; 07 Jun 2019 10:47:53 -0700
Date:   Fri, 7 Jun 2019 10:47:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: simplify vmx_prepare_switch_to_{guest,host}
Message-ID: <20190607174753.GH9083@linux.intel.com>
References: <1559927301-8124-1-git-send-email-pbonzini@redhat.com>
 <20190607173710.GG9083@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607173710.GG9083@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 07, 2019 at 10:37:10AM -0700, Sean Christopherson wrote:
> On Fri, Jun 07, 2019 at 07:08:21PM +0200, Paolo Bonzini wrote:
> > vmx->loaded_cpu_state can only be NULL or equal to vmx->loaded_vmcs,
> > so change it to a bool.  Because the direction of the bool is
> > now the opposite of vmx->guest_msrs_dirty, change the direction of
> > vmx->guest_msrs_dirty so that they match.
> > 
> > Finally, do not imply that MSRs have to be reloaded when
> > vmx->guest_sregs_loaded is false; instead, set vmx->guest_msrs_loaded
> > to false explicitly in vmx_prepare_switch_to_host.
> > 
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> ...
> 
> > @@ -1165,13 +1163,15 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
> >  	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
> >  #endif
> >  	load_fixmap_gdt(raw_smp_processor_id());
> > +	vmx->guest_sregs_loaded = false;
> > +	vmx->guest_msrs_loaded = false;
> >  }
> >  
> >  #ifdef CONFIG_X86_64
> >  static u64 vmx_read_guest_kernel_gs_base(struct vcpu_vmx *vmx)
> >  {
> >  	preempt_disable();
> > -	if (vmx->loaded_cpu_state)
> > +	if (vmx->guest_sregs_loaded)
> >  		rdmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
> 
> This is the hiccup with naming it sregs_loaded.  The split bools is also
> kinda wonky since the 32->64 case is a one-off scenario.  I think a
> cleaner solution would be to remove guest_msrs_dirty and refresh the MSRs
> directly from setup_msrs().  Then loaded_cpu_state -> loaded_guest_state
> can be a straight conversion from loaded_vmcs -> bool.  I'll send patches.

Actually, would it be easier on your end if I do a v2 of the series that
would introduce vmx_sync_vmcs_host_state(), and splice these patch into it?
