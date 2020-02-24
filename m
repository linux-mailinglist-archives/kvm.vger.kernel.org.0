Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAE9916B3AF
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 23:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgBXWSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 17:18:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:38699 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728087AbgBXWSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 17:18:08 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 14:18:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,481,1574150400"; 
   d="scan'208";a="436057537"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 24 Feb 2020 14:18:08 -0800
Date:   Mon, 24 Feb 2020 14:18:07 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/61] KVM: VMX: Add helpers to query Intel PT mode
Message-ID: <20200224221807.GM29865@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-20-sean.j.christopherson@intel.com>
 <87pne8q8c0.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pne8q8c0.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 21, 2020 at 04:16:31PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index a4f7f737c5d4..70eafa88876a 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -449,7 +449,7 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
> >  static inline u32 vmx_vmentry_ctrl(void)
> >  {
> >  	u32 vmentry_ctrl = vmcs_config.vmentry_ctrl;
> > -	if (pt_mode == PT_MODE_SYSTEM)
> > +	if (vmx_pt_mode_is_system())
> 
> Just wondering, would it rather be better to say
>         if (!vmx_pt_supported())
> here?
> 
> >  		vmentry_ctrl &= ~(VM_ENTRY_PT_CONCEAL_PIP |
> >  				  VM_ENTRY_LOAD_IA32_RTIT_CTL);
> >  	/* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
> > @@ -460,7 +460,7 @@ static inline u32 vmx_vmentry_ctrl(void)
> >  static inline u32 vmx_vmexit_ctrl(void)
> >  {
> >  	u32 vmexit_ctrl = vmcs_config.vmexit_ctrl;
> > -	if (pt_mode == PT_MODE_SYSTEM)
> > +	if (vmx_pt_mode_is_system())
> 
> ... and here? I.e. to cover the currently unsupported 'host-only' mode.

Hmm, good question.  I don't think so?  On VM-Enter, RTIT_CTL would need to
be loaded to disable PT.  Clearing RTIT_CTL on VM-Exit would be redundant
at that point[1].  And AIUI, the PIP for VM-Enter/VM-Exit isn't needed
because there is no context switch from the decoder's perspective.

Note, the original upstreaming series also used "pt_mode == PT_MODE_SYSTEM"
logic for this check when "host-only mode" was supported[2].

[1] Arguably, KVM should use the VM-Exit MSR load list to atomically
    reenable tracing, but that's feedback for a non-existence patch :-).
[2] https://patchwork.kernel.org/patch/10104533/

> 
> >  		vmexit_ctrl &= ~(VM_EXIT_PT_CONCEAL_PIP |
> >  				 VM_EXIT_CLEAR_IA32_RTIT_CTL);
> >  	/* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
