Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6FB7266403
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 18:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgIKQ3b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 12:29:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:31677 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726306AbgIKQ23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 12:28:29 -0400
IronPort-SDR: YREpwWfwOeD0UPOyTTCQF8x61gsF0Jof46jsue7D293q+jsfaPM/ozeCF8rlkTRMWFrxFPUCxl
 VYJtuD78buLA==
X-IronPort-AV: E=McAfee;i="6000,8403,9741"; a="159738486"
X-IronPort-AV: E=Sophos;i="5.76,416,1592895600"; 
   d="scan'208";a="159738486"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 09:28:22 -0700
IronPort-SDR: MRaDYQOI+Y37b7XzL5ehbRYu0W1Y6xATNgCXz6/+joIgRZb3IlK35VMeSAxF2m26DAwL9nQmAe
 UHXSMxDELuzQ==
X-IronPort-AV: E=Sophos;i="5.76,416,1592895600"; 
   d="scan'208";a="481379882"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 09:28:22 -0700
Date:   Fri, 11 Sep 2020 09:28:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Colin King <colin.king@canonical.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: Re: [PATCH][next] KVM: SVM: nested: fix free of uninitialized
 pointers save and ctl
Message-ID: <20200911162814.GC4344@sjchrist-ice>
References: <20200911110730.24238-1-colin.king@canonical.com>
 <87o8mclei1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o8mclei1.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Joerg

On Fri, Sep 11, 2020 at 01:49:42PM +0200, Vitaly Kuznetsov wrote:
> Colin King <colin.king@canonical.com> writes:
> 
> > From: Colin Ian King <colin.king@canonical.com>
> >
> > Currently the error exit path to outt_set_gif will kfree on
> > uninitialized
> 
> typo: out_set_gif
> 
> > pointers save and ctl.  Fix this by ensuring these pointers are
> > inintialized to NULL to avoid garbage pointer freeing.
> >
> > Addresses-Coverity: ("Uninitialized pointer read")
> > Fixes: 6ccbd29ade0d ("KVM: SVM: nested: Don't allocate VMCB structures
> > on stack")
> 
> Where is this commit id from? I don't see it in Paolo's kvm tree, if
> it's not yet merged, maybe we should fix it and avoid introducing the
> issue in the first place?

Ya, AFAIK the series as not been applied.

> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> >  arch/x86/kvm/svm/nested.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 28036629abf8..2b15f49f9e5a 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1060,8 +1060,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
> >  	struct vmcb *hsave = svm->nested.hsave;
> >  	struct vmcb __user *user_vmcb = (struct vmcb __user *)
> >  		&user_kvm_nested_state->data.svm[0];
> > -	struct vmcb_control_area *ctl;
> > -	struct vmcb_save_area *save;
> > +	struct vmcb_control_area *ctl = NULL;
> > +	struct vmcb_save_area *save = NULL;
> >  	int ret;
> >  	u32 cr0;
> 
> I think it would be better if we eliminate 'out_set_gif; completely as
> the 'error path' we have looks a bit weird anyway. Something like
> (untested):

Ya, I agree that duplicating the single line for this one-off case is
preferable to creating a convoluted set of labels.

Joerg, can you fold this change into a prep patch for v4 of your "KVM: SVM:
SEV-ES groundwork" series?

> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 28036629abf8..d1ae94f40907 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1092,7 +1092,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  
>         if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)) {
>                 svm_leave_nested(svm);
> -               goto out_set_gif;
> +               svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
> +               return 0;
>         }
>  
>         if (!page_address_valid(vcpu, kvm_state->hdr.svm.vmcb_pa))
> @@ -1145,7 +1146,6 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>         load_nested_vmcb_control(svm, ctl);
>         nested_prepare_vmcb_control(svm);
>  
> -out_set_gif:
>         svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
>  
>         ret = 0;
> 
> -- 
> Vitaly
> 
