Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 262AAE2A01
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 07:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406921AbfJXFio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 01:38:44 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:57085 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390925AbfJXFio (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 01:38:44 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46zGJ169gXz9sPp; Thu, 24 Oct 2019 16:38:41 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1571895521; bh=Pvk4pjfud4nhWj0HS/7DHrPbxYicG2LOW+g9wM0CxM8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t6OH7K7acC/K4mI4A05FoIBp8bV/pCbT+fl4WMecL+VzGDHWtyvpjKUEwzsPkvZkl
         zu2ALcjEGJO/U9Z7DPZIhENE1CEiCsNazBtCLlMQG9bBxSZBxHv5Jntsl10zGTzgDm
         k+S0umNnNBCQZPmlzGLzsR/Z0bSOGIjkcCTBZbLjS03IJT7zrRk58J311BKCGM1nDW
         Ug5EzR4+nNuj3Z0v2ZRdE1v+EKiuxCYZtXmiDxxPGVKz+J8D1vQcGV0bskSVdN3LhT
         z37ODJ2hKYVQE2dAcCJqHehYqMIqmzb6O6Ma3gsGnoEBcWdPsUBWt+ISWJxxzdf6c1
         I/rPRObXjj+Sw==
Date:   Thu, 24 Oct 2019 15:48:31 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 14/23] KVM: PPC: Book3S HV: Nested: Context switch slb
 for nested hpt guest
Message-ID: <20191024044831.GB773@oak.ozlabs.ibm.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
 <20190826062109.7573-15-sjitindarsingh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826062109.7573-15-sjitindarsingh@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 26, 2019 at 04:21:00PM +1000, Suraj Jitindar Singh wrote:
> A version 2 of the H_ENTER_NESTED hcall was added with an argument to
> specify the slb entries which should be used to run the nested guest.
> 
> Add support for this version of the hcall structures to
> kvmhv_enter_nested_guest() and context switch the slb when the nested
> guest being run is a hpt (hash page table) guest.
> 
> Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

Question below...

> @@ -307,6 +335,26 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
>  	vcpu->arch.regs.msr = vcpu->arch.shregs.msr;
>  	saved_l1_regs = vcpu->arch.regs;
>  	kvmhv_save_hv_regs(vcpu, &saved_l1_hv);
> +	/* if running hpt then context switch the slb in the vcpu struct */
> +	if (!radix) {
> +		slb_ptr = kvmppc_get_gpr(vcpu, 6);
> +		l2_slb = kzalloc(sizeof(*l2_slb), GFP_KERNEL);
> +		saved_l1_slb = kzalloc(sizeof(*saved_l1_slb), GFP_KERNEL);
> +
> +		if ((!l2_slb) || (!saved_l1_slb)) {
> +			ret = H_HARDWARE;
> +			goto out_free;
> +		}
> +		err = kvm_vcpu_read_guest(vcpu, slb_ptr, l2_slb,
> +					  sizeof(struct guest_slb));
> +		if (err) {
> +			ret = H_PARAMETER;
> +			goto out_free;
> +		}
> +		if (kvmppc_need_byteswap(vcpu))
> +			byteswap_guest_slb(l2_slb);
> +		kvmhv_save_guest_slb(vcpu, saved_l1_slb);

Why are we bothering to save the SLB state of the L1 guest, which has
to be a radix guest?  Won't the L1 SLB state always just have 0
entries?

> @@ -354,6 +409,8 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
>  		vcpu->arch.shregs.msr |= MSR_TS_S;
>  	vc->tb_offset = saved_l1_hv.tb_offset;
>  	restore_hv_regs(vcpu, &saved_l1_hv);
> +	if (!radix)
> +		kvmhv_restore_guest_slb(vcpu, saved_l1_slb);

Likewise here can't we just set vcpu->arch.slb_max and
vcpu->arch.slb_nr to zero?

Paul.
