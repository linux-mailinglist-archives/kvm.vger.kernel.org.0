Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C341B34C2
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 04:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgDVCCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 22:02:19 -0400
Received: from mga03.intel.com ([134.134.136.65]:40160 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726228AbgDVCCS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 22:02:18 -0400
IronPort-SDR: bBNHpvB1Tire37z6wX8hztIYNey1Z5EV0NTEildgAdXV/fIrGAywvV/rH+RupXIowvLXpFE3fw
 +2/LFCb726tQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 19:02:17 -0700
IronPort-SDR: Lb0Yd8qcGAF0Tm+nkqLLtEjEaMQXGUdbMY5WGhxTgodve9frRMVoRl5zm/5tyS6LKl35mhuBNC
 KV0ExfeQWPDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,412,1580803200"; 
   d="scan'208";a="291787604"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 21 Apr 2020 19:02:17 -0700
Date:   Tue, 21 Apr 2020 19:02:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Makarand Sonare <makarandsonare@google.com>
Cc:     kvm@vger.kernel.org, pshier@google.com, jmattson@google.com
Subject: Re: [kvm PATCH 2/2] KVM: nVMX: Don't clobber preemption timer in the
 VMCS12 before L2 ran
Message-ID: <20200422020216.GF17836@linux.intel.com>
References: <20200417183452.115762-1-makarandsonare@google.com>
 <20200417183452.115762-3-makarandsonare@google.com>
 <20200422015759.GE17836@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422015759.GE17836@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 21, 2020 at 06:57:59PM -0700, Sean Christopherson wrote:
> On Fri, Apr 17, 2020 at 11:34:52AM -0700, Makarand Sonare wrote:
> > Don't clobber the VMX-preemption timer value in the VMCS12 during
> > migration on the source while handling an L1 VMLAUNCH/VMRESUME but
> > before L2 ran. In that case the VMCS12 preemption timer value
> > should not be touched as it will be restarted on the target
> > from its original value. This emulates migration occurring while L1
> > awaits completion of its VMLAUNCH/VMRESUME instruction.
> > 
> > Signed-off-by: Makarand Sonare <makarandsonare@google.com>
> > Signed-off-by: Peter Shier <pshier@google.com>
> 
> The SOB tags are reversed, i.e. Peter's should be first to show that he
> wrote the patch and then transfered it to you for upstreaming.
> 
> > Change-Id: I376d151585d4f1449319f7512151f11bbf08c5bf
> > ---
> >  arch/x86/kvm/vmx/nested.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 5365d7e5921ea..66155e9114114 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -3897,11 +3897,13 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
> >  		vmcs12->guest_activity_state = GUEST_ACTIVITY_ACTIVE;
> >  
> >  	if (nested_cpu_has_preemption_timer(vmcs12)) {
> > -		vmx->nested.preemption_timer_remaining =
> > -			vmx_get_preemption_timer_value(vcpu);
> > -		if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
> > -			vmcs12->vmx_preemption_timer_value =
> > -				vmx->nested.preemption_timer_remaining;
> > +		if (!vmx->nested.nested_run_pending) {
> > +			vmx->nested.preemption_timer_remaining =
> > +				vmx_get_preemption_timer_value(vcpu);
> > +			if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
> > +				vmcs12->vmx_preemption_timer_value =
> > +					vmx->nested.preemption_timer_remaining;
> > +			}
> 
> This indentation is messed up, the closing brace is for !nested_run_pending,
> but it's aligned with (vm_exit_controls & ..._PREEMPTION_TIMER).
> 
> Even better than fixing the indentation would be to include !nested_run_pending
> in the top-level if statement, which reduces the nesting level and produces
> a much cleaner diff, e.g.
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 409a39af121f..7dd6440425ab 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3951,7 +3951,8 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>         else
>                 vmcs12->guest_activity_state = GUEST_ACTIVITY_ACTIVE;
> 
> -       if (nested_cpu_has_preemption_timer(vmcs12)) {
> +       if (nested_cpu_has_preemption_timer(vmcs12) &&
> +           !vmx->nested.nested_run_pending) {
>                 vmx->nested.preemption_timer_remaining =
>                         vmx_get_preemption_timer_value(vcpu);
>                 if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)

Actually, why is this a separate patch?  The code it's fixing was introduced
in patch one of this series.
