Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC111BACE8
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 20:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgD0Sg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 14:36:57 -0400
Received: from mga17.intel.com ([192.55.52.151]:35122 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbgD0Sg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 14:36:57 -0400
IronPort-SDR: naqbU4v4yGjOrqXAUFq2F6zB1J1Cn4jWaQrjcAyK54Uln/5rwwjPlNc4UX1qMnSWue73sejTjK
 yRmMmXovqsOg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 11:36:56 -0700
IronPort-SDR: lhNRKftxecrArb0ifevrmQZSglEPvEDWlICFbxaFvVzcaAQDgs9+HU9KlSIDPL7K1NkjhI77fH
 7nED5OMry3Cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,325,1583222400"; 
   d="scan'208";a="404401595"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 27 Apr 2020 11:36:56 -0700
Date:   Mon, 27 Apr 2020 11:36:56 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: Re: [PATCH v3 2/5] KVM: X86: Introduce need_cancel_enter_guest helper
Message-ID: <20200427183656.GO14870@linux.intel.com>
References: <1587709364-19090-1-git-send-email-wanpengli@tencent.com>
 <1587709364-19090-3-git-send-email-wanpengli@tencent.com>
 <CANRm+CwvTrwmJnFWR8UgEkqyE_fyoc6KmrNuHQj=DuJDkR-UGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+CwvTrwmJnFWR8UgEkqyE_fyoc6KmrNuHQj=DuJDkR-UGA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 26, 2020 at 10:05:00AM +0800, Wanpeng Li wrote:
> On Fri, 24 Apr 2020 at 14:23, Wanpeng Li <kernellwp@gmail.com> wrote:
> >
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Introduce need_cancel_enter_guest() helper, we need to check some
> > conditions before doing CONT_RUN, in addition, it can also catch
> > the case vmexit occurred while another event was being delivered
> > to guest software since vmx_complete_interrupts() adds the request
> > bit.
> >
> > Tested-by: Haiwei Li <lihaiwei@tencent.com>
> > Cc: Haiwei Li <lihaiwei@tencent.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 12 +++++++-----
> >  arch/x86/kvm/x86.c     | 10 ++++++++--
> >  arch/x86/kvm/x86.h     |  1 +
> >  3 files changed, 16 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index f1f6638..5c21027 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6577,7 +6577,7 @@ bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
> >
> >  static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >  {
> > -       enum exit_fastpath_completion exit_fastpath;
> > +       enum exit_fastpath_completion exit_fastpath = EXIT_FASTPATH_NONE;
> >         struct vcpu_vmx *vmx = to_vmx(vcpu);
> >         unsigned long cr3, cr4;
> >
> > @@ -6754,10 +6754,12 @@ static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >         vmx_recover_nmi_blocking(vmx);
> >         vmx_complete_interrupts(vmx);
> >
> > -       exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
> > -       /* static call is better with retpolines */
> > -       if (exit_fastpath == EXIT_FASTPATH_CONT_RUN)
> > -               goto cont_run;
> > +       if (!kvm_need_cancel_enter_guest(vcpu)) {
> > +               exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
> > +               /* static call is better with retpolines */
> > +               if (exit_fastpath == EXIT_FASTPATH_CONT_RUN)
> > +                       goto cont_run;
> > +       }
> 
> The kvm_need_cancel_enter_guest() should not before
> vmx_exit_handlers_fastpath() which will break IPI fastpath. How about
> applying something like below, otherwise, maybe introduce another
> EXIT_FASTPATH_CONT_FAIL to indicate fails due to
> kvm_need_cancel_enter_guest() if checking it after
> vmx_exit_handlers_fastpath(), then we return 1 in vmx_handle_exit()
> directly instead of kvm_skip_emulated_instruction(). VMX-preemption
> timer exit doesn't need to skip emulated instruction but wrmsr
> TSCDEADLINE MSR exit does which results in a little complex here.
> 
> Paolo, what do you think?
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 853d3af..9317924 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6564,6 +6564,9 @@ static enum exit_fastpath_completion
> handle_fastpath_preemption_timer(struct kvm
>  {
>      struct vcpu_vmx *vmx = to_vmx(vcpu);
> 
> +    if (kvm_need_cancel_enter_guest(vcpu))
> +        return EXIT_FASTPATH_NONE;
> +
>      if (!vmx->req_immediate_exit &&
>          !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
>              kvm_lapic_expired_hv_timer(vcpu);
> @@ -6771,12 +6774,10 @@ static enum exit_fastpath_completion
> vmx_vcpu_run(struct kvm_vcpu *vcpu)
>      vmx_recover_nmi_blocking(vmx);
>      vmx_complete_interrupts(vmx);
> 
> -    if (!(kvm_need_cancel_enter_guest(vcpu))) {
> -        exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
> -        if (exit_fastpath == EXIT_FASTPATH_CONT_RUN) {
> -            vmx_sync_pir_to_irr(vcpu);
> -            goto cont_run;
> -        }
> +    exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
> +    if (exit_fastpath == EXIT_FASTPATH_CONT_RUN) {

Relying on the handlers to check kvm_need_cancel_enter_guest() will be
error prone and costly to maintain.  I also don't like that it buries the
logic.

What about adding another flavor, e.g.:

	exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
	if (exit_fastpath == EXIT_FASTPATH_CONT_RUN &&
	    kvm_need_cancel_enter_guest(vcpu))
		exit_fastpath = EXIT_FASTPATH_NOP;

That would also allow you to enable preemption timer without first having
to add CONT_RUN, which would be a very good thing for bisection.

> +        vmx_sync_pir_to_irr(vcpu);
> +        goto cont_run;
>      }
> 
>      return exit_fastpath;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 99061ba..11b309c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1618,6 +1618,9 @@ static int
> handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
> 
>  static int handle_fastpath_set_tscdeadline(struct kvm_vcpu *vcpu, u64 data)
>  {
> +    if (kvm_need_cancel_enter_guest(vcpu))
> +        return 1;
> +
>      if (!kvm_x86_ops.set_hv_timer ||
>          kvm_mwait_in_guest(vcpu->kvm) ||
>          kvm_can_post_timer_interrupt(vcpu))
