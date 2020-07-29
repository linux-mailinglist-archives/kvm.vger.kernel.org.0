Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C08423215C
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 17:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgG2PO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 11:14:56 -0400
Received: from mga06.intel.com ([134.134.136.31]:33739 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726802AbgG2PO4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 11:14:56 -0400
IronPort-SDR: Zw5ZNS+VRAWHOk95oYhugVe0rU4/N72f8Lt3Pt8VjP1QnnzEcs3Y+nxqIR8R6/qCNcHFkHMtsx
 0E6XH3KiH2ug==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="212966923"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="212966923"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 08:14:55 -0700
IronPort-SDR: MKShLvdEyM3yvsmg01aB6FLbJ2ASbO1OSN76CEeN/s6p+0KtLELT8YBy7+trkPlWXiBy5+aOIL
 RrEknSY6LgGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="286543206"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 29 Jul 2020 08:14:55 -0700
Date:   Wed, 29 Jul 2020 08:14:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 1/4] KVM: SVM: nested: Don't allocate VMCB structures on
 stack
Message-ID: <20200729151454.GB27751@linux.intel.com>
References: <20200729132234.2346-1-joro@8bytes.org>
 <20200729132234.2346-2-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729132234.2346-2-joro@8bytes.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 29, 2020 at 03:22:31PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Do not allocate a vmcb_control_area and a vmcb_save_area on the stack,
> as these structures will become larger with future extenstions of
> SVM and thus the svm_set_nested_state() function will become a too large
> stack frame.

Speaking of too large, would it be overly paranoid to add:

  BUILD_BUG_ON(sizeof(struct vmcb_control_area) + sizeof(struct vmcb_save_area) <
	       KVM_STATE_NESTED_SVM_VMCB_SIZE)

More so for documentation than for any real concern that the SVM architecture
will do something silly, e.g. to make it obvious that patch 2 in this series
won't break backwards compatibility.
 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/kvm/svm/nested.c | 44 ++++++++++++++++++++++++++-------------
>  1 file changed, 30 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 61378a3c2ce4..f3c3c4e1ca7f 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1061,8 +1061,9 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	struct vmcb *hsave = svm->nested.hsave;
>  	struct vmcb __user *user_vmcb = (struct vmcb __user *)
>  		&user_kvm_nested_state->data.svm[0];
> -	struct vmcb_control_area ctl;
> -	struct vmcb_save_area save;
> +	struct vmcb_control_area *ctl;
> +	struct vmcb_save_area *save;
> +	int ret;
>  	u32 cr0;
>  
>  	if (kvm_state->format != KVM_STATE_NESTED_FORMAT_SVM)
> @@ -1096,13 +1097,22 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  		return -EINVAL;
>  	if (kvm_state->size < sizeof(*kvm_state) + KVM_STATE_NESTED_SVM_VMCB_SIZE)
>  		return -EINVAL;
> -	if (copy_from_user(&ctl, &user_vmcb->control, sizeof(ctl)))
> -		return -EFAULT;
> -	if (copy_from_user(&save, &user_vmcb->save, sizeof(save)))
> -		return -EFAULT;
>  
> -	if (!nested_vmcb_check_controls(&ctl))
> -		return -EINVAL;
> +	ret  = -ENOMEM;
> +	ctl  = kzalloc(sizeof(*ctl),  GFP_KERNEL);
> +	save = kzalloc(sizeof(*save), GFP_KERNEL);
> +	if (!ctl || !save)
> +		goto out_free;
> +
> +	ret = -EFAULT;
> +	if (copy_from_user(ctl, &user_vmcb->control, sizeof(ctl)))

The sizeof() calc is wrong, this is now calculating the size of the pointer,
not the size of the struct.  It'd need to be sizeof(*ctl).

> +		goto out_free;
> +	if (copy_from_user(save, &user_vmcb->save, sizeof(save)))

Same bug here.

> +		goto out_free;
> +
> +	ret = -EINVAL;
> +	if (!nested_vmcb_check_controls(ctl))
> +		goto out_free;
>  
>  	/*
>  	 * Processor state contains L2 state.  Check that it is
> @@ -1110,15 +1120,15 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	 */
>  	cr0 = kvm_read_cr0(vcpu);
>          if (((cr0 & X86_CR0_CD) == 0) && (cr0 & X86_CR0_NW))
> -                return -EINVAL;
> +                goto out_free;
>  
>  	/*
>  	 * Validate host state saved from before VMRUN (see
>  	 * nested_svm_check_permissions).
>  	 * TODO: validate reserved bits for all saved state.
>  	 */
> -	if (!(save.cr0 & X86_CR0_PG))
> -		return -EINVAL;
> +	if (!(save->cr0 & X86_CR0_PG))
> +		goto out_free;
>  
>  	/*
>  	 * All checks done, we can enter guest mode.  L1 control fields
> @@ -1127,15 +1137,21 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	 * contains saved L1 state.
>  	 */
>  	copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
> -	hsave->save = save;
> +	hsave->save = *save;
>  
>  	svm->nested.vmcb = kvm_state->hdr.svm.vmcb_pa;
> -	load_nested_vmcb_control(svm, &ctl);
> +	load_nested_vmcb_control(svm, ctl);
>  	nested_prepare_vmcb_control(svm);
>  
>  out_set_gif:
>  	svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
> -	return 0;
> +
> +	ret = 0;
> +out_free:
> +	kfree(save);
> +	kfree(ctl);
> +
> +	return ret;
>  }
>  
>  struct kvm_x86_nested_ops svm_nested_ops = {
> -- 
> 2.17.1
> 
