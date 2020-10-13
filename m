Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA8628C6BC
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 03:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgJMB3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 21:29:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:56905 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728093AbgJMB3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 21:29:40 -0400
IronPort-SDR: JtsYpXbwLMfQ+JvGj54YzXEz8bhqDeSoKlMKQEiIVzCP9L+PNQKSdxsBgdR0pHn6HK6yu9tG/X
 ELAfGeCF9btQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165940576"
X-IronPort-AV: E=Sophos;i="5.77,369,1596524400"; 
   d="scan'208";a="165940576"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 18:29:38 -0700
IronPort-SDR: yZvtb1Pk85zflXWxZ0jIgBKFOv1+Bv1jAnj+/xc76PN7o4MmmO29r1FI7ilHQxgFVPZCIUxw2A
 zQYZmjRZkLWQ==
X-IronPort-AV: E=Sophos;i="5.77,369,1596524400"; 
   d="scan'208";a="313633677"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 18:29:38 -0700
Date:   Mon, 12 Oct 2020 18:29:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Cathy Avery <cavery@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wei.huang2@amd.com,
        mlevitsk@redhat.com
Subject: Re: [PATCH v2 1/2] KVM: SVM: Move asid to vcpu_svm
Message-ID: <20201013012937.GA10366@linux.intel.com>
References: <20201011184818.3609-1-cavery@redhat.com>
 <20201011184818.3609-2-cavery@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201011184818.3609-2-cavery@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 11, 2020 at 02:48:17PM -0400, Cathy Avery wrote:
> Move asid to svm->asid to allow for vmcb assignment

This is misleading.  The asid isn't being moved, it's being copied/tracked.
The "to allow" wording also confused me; I though this was just a prep patch
and the actual assignment was in a follow-up patch.

> during svm_vcpu_run without regard to which level
> guest is running.
> Signed-off-by: Cathy Avery <cavery@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c | 4 +++-
>  arch/x86/kvm/svm/svm.h | 1 +
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d4e18bda19c7..619980a5d540 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1101,6 +1101,7 @@ static void init_vmcb(struct vcpu_svm *svm)
>  		save->cr4 = 0;
>  	}
>  	svm->asid_generation = 0;
> +	svm->asid = 0;
>  
>  	svm->nested.vmcb = 0;
>  	svm->vcpu.arch.hflags = 0;
> @@ -1663,7 +1664,7 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
>  	}
>  
>  	svm->asid_generation = sd->asid_generation;
> -	svm->vmcb->control.asid = sd->next_asid++;
> +	svm->asid = sd->next_asid++;
>  	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);

I know very little (ok, nothing) about SVM VMCB caching rules, but I strongly
suspect this is broken.  The existing code explicitly marks VMCB_ASID dirty,
but there is no equivalent code for the case where there are multiple VMCBs,
e.g. if new_asid() is called while vmcb01 is active, then vmcb02 will pick up
the new ASID but will not mark it dirty.

>  }
> @@ -3446,6 +3447,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>  
>  	sync_lapic_to_cr8(vcpu);
>  
> +	svm->vmcb->control.asid = svm->asid;

Related to the above, handling this in vcpu_run() feels wrong.  There really
shouldn't be a need to track the ASID.  vmcb01 will always exist if vmcb02
exits, e.g. the ASID can be copied and marked dirty when loading vmcb02.
For new_asid(), it can unconditionally update vmcb01 and conditionally update
vmcb02.

>  	svm->vmcb->save.cr2 = vcpu->arch.cr2;
>  
>  	/*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index a798e1731709..862f0d2405e8 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -104,6 +104,7 @@ struct vcpu_svm {
>  	struct vmcb *vmcb;
>  	unsigned long vmcb_pa;
>  	struct svm_cpu_data *svm_data;
> +	u32 asid;
>  	uint64_t asid_generation;
>  	uint64_t sysenter_esp;
>  	uint64_t sysenter_eip;
> -- 
> 2.20.1
> 
