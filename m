Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A9D1EB2EB
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 03:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725841AbgFBBVk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 21:21:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:12591 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFBBVk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 21:21:40 -0400
IronPort-SDR: fkLtjjboi+CVjRekpSdV4sluVd3NntZgA5qfqk3djYKW4l3PbJ/IcfkCe+0IUG5/WAipBOfujO
 1BmM/PTVUm0A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2020 18:21:39 -0700
IronPort-SDR: 2O7GVJX4L+YkqLspchaG42Vq7SmiCiOjk3VNxJxE6GMbc3ifNJTk+OHXb2Xn1Ch1b1yEwjZfUm
 Dz4GjQ2WDh0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,462,1583222400"; 
   d="scan'208";a="286463313"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga002.jf.intel.com with ESMTP; 01 Jun 2020 18:21:39 -0700
Date:   Mon, 1 Jun 2020 18:21:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH v3 3/4] kvm: vmx: Add last_cpu to struct vcpu_vmx
Message-ID: <20200602012139.GF21661@linux.intel.com>
References: <20200601222416.71303-1-jmattson@google.com>
 <20200601222416.71303-4-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601222416.71303-4-jmattson@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 01, 2020 at 03:24:15PM -0700, Jim Mattson wrote:
> As we already do in svm, record the last logical processor on which a
> vCPU has run, so that it can be communicated to userspace for
> potential hardware errors.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 1 +
>  arch/x86/kvm/vmx/vmx.h | 3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 170cc76a581f..42856970d3b8 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6730,6 +6730,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	if (vcpu->arch.cr2 != read_cr2())
>  		write_cr2(vcpu->arch.cr2);
>  
> +	vmx->last_cpu = vcpu->cpu;

This is redundant in the EXIT_FASTPATH_REENTER_GUEST case.  Setting it
before reenter_guest is technically wrong if emulation_required is true, but
that doesn't seem like it'd be an issue in practice.

>  	vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
>  				   vmx->loaded_vmcs->launched);
>  
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 672c28f17e49..8a1e833cf4fb 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -302,6 +302,9 @@ struct vcpu_vmx {
>  	u64 ept_pointer;
>  
>  	struct pt_desc pt_desc;
> +
> +	/* which host CPU was used for running this vcpu */
> +	unsigned int last_cpu;

Why not put this in struct kvm_vcpu_arch?  I'd also vote to name it
last_run_cpu, as last_cpu is super misleading.

And if it's in arch, what about setting it vcpu_enter_guest?

>  };
>  
>  enum ept_pointers_status {
> -- 
> 2.27.0.rc2.251.g90737beb825-goog
> 
