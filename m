Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F2C189FEF
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 16:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgCRPs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 11:48:27 -0400
Received: from mga17.intel.com ([192.55.52.151]:39703 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgCRPs1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Mar 2020 11:48:27 -0400
IronPort-SDR: IubkZVx9SyRPBr2HOdxnbA7sT+HnsPRIlGeGPc19xv+PJdmmx+c+QcV0PuhStac1brWG4R8bud
 mne/c5Em1JmQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 08:48:26 -0700
IronPort-SDR: /aX59V9repMYpLW/5FIc310Y1PFdZtCX2rGo5SjqQnhOQzC4AeYNRjx/FQWNKhsuu8Bgvh5Hxh
 yGud3BHxL6VA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,568,1574150400"; 
   d="scan'208";a="248216170"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 18 Mar 2020 08:48:26 -0700
Date:   Wed, 18 Mar 2020 08:48:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Luwei Kang <luwei.kang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Subject: Re: [PATCH] KVM: VMX: Disable Intel PT before VM-entry
Message-ID: <20200318154826.GC24357@linux.intel.com>
References: <1584503298-18731-1-git-send-email-luwei.kang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1584503298-18731-1-git-send-email-luwei.kang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 18, 2020 at 11:48:18AM +0800, Luwei Kang wrote:
> If the logical processor is operating with Intel PT enabled (
> IA32_RTIT_CTL.TraceEn = 1) at the time of VM entry, the “load
> IA32_RTIT_CTL” VM-entry control must be 0(SDM 26.2.1.1).
> 
> The first disabled the host Intel PT(Clear TraceEn) will make all the
> buffered packets are flushed out of the processor and it may cause
> an Intel PT PMI. The host Intel PT will be re-enabled in the host Intel
> PT PMI handler.
> 
> handle_pmi_common()
>     -> intel_pt_interrupt()
>             -> pt_config_start()

IIUC, this is only possible when PT "plays nice" with VMX, correct?
Otherwise pt->vmx_on will be true and pt_config_start() would skip the
WRMSR.

And IPT PMI must be delivered via NMI (though maybe they're always
delivered via NMI?).

In any case, redoing WRMSR doesn't seem safe, and it certainly isn't
performant, e.g. what prevents the second WRMSR from triggering a second
IPT PMI?

pt_guest_enter() is called after the switch to the vCPU has already been
recorded, can't this be handled in the IPT code, e.g. something like this?

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 1db7a51d9792..e38ddae9f0d1 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -405,7 +405,7 @@ static void pt_config_start(struct perf_event *event)
        ctl |= RTIT_CTL_TRACEEN;
        if (READ_ONCE(pt->vmx_on))
                perf_aux_output_flag(&pt->handle, PERF_AUX_FLAG_PARTIAL);
-       else
+       else (!(current->flags & PF_VCPU))
                wrmsrl(MSR_IA32_RTIT_CTL, ctl);

        WRITE_ONCE(event->hw.config, ctl);

> This patch will disable the Intel PT twice to make sure the Intel PT
> is disabled before VM-Entry.
> 
> Signed-off-by: Luwei Kang <luwei.kang@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 26f8f31..d936a91 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1095,6 +1095,8 @@ static inline void pt_save_msr(struct pt_ctx *ctx, u32 addr_range)
>  
>  static void pt_guest_enter(struct vcpu_vmx *vmx)
>  {
> +	u64 rtit_ctl;
> +
>  	if (pt_mode == PT_MODE_SYSTEM)
>  		return;
>  
> @@ -1103,8 +1105,14 @@ static void pt_guest_enter(struct vcpu_vmx *vmx)
>  	 * Save host state before VM entry.
>  	 */
>  	rdmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
> -	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
> +	if (vmx->pt_desc.host.ctl & RTIT_CTL_TRACEEN) {
>  		wrmsrl(MSR_IA32_RTIT_CTL, 0);
> +		rdmsrl(MSR_IA32_RTIT_CTL, rtit_ctl);
> +		if (rtit_ctl)
> +			wrmsrl(MSR_IA32_RTIT_CTL, 0);
> +	}
> +
> +	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
>  		pt_save_msr(&vmx->pt_desc.host, vmx->pt_desc.addr_range);
>  		pt_load_msr(&vmx->pt_desc.guest, vmx->pt_desc.addr_range);
>  	}
> -- 
> 1.8.3.1
> 
