Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF86288307
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 20:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfHISzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 14:55:25 -0400
Received: from mga14.intel.com ([192.55.52.115]:58709 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfHISzZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 14:55:25 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Aug 2019 11:55:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,366,1559545200"; 
   d="scan'208";a="326706151"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga004.jf.intel.com with ESMTP; 09 Aug 2019 11:55:24 -0700
Date:   Fri, 9 Aug 2019 11:55:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v3 7/7] x86: KVM: svm: eliminate hardcoded RIP
 advancement from vmrun_interception()
Message-ID: <20190809185524.GG10541@linux.intel.com>
References: <20190808173051.6359-1-vkuznets@redhat.com>
 <20190808173051.6359-8-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808173051.6359-8-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 08, 2019 at 07:30:51PM +0200, Vitaly Kuznetsov wrote:
> Just like we do with other intercepts, in vmrun_interception() we should be
> doing kvm_skip_emulated_instruction() and not just RIP += 3. Also, it is
> wrong to increment RIP before nested_svm_vmrun() as it can result in
> kvm_inject_gp().
> 
> We can't call kvm_skip_emulated_instruction() after nested_svm_vmrun() so
> move it inside. To preserve the return value from it nested_svm_vmrun()
> needs to start returning an int.
> 
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/svm.c | 27 ++++++++++++---------------
>  1 file changed, 12 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 43bc4a5e4948..6c4046eb26b3 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -3586,9 +3586,9 @@ static void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>  	mark_all_dirty(svm->vmcb);
>  }
>  
> -static bool nested_svm_vmrun(struct vcpu_svm *svm)
> +static int nested_svm_vmrun(struct vcpu_svm *svm)
>  {
> -	int rc;
> +	int rc, ret;
>  	struct vmcb *nested_vmcb;
>  	struct vmcb *hsave = svm->nested.hsave;
>  	struct vmcb *vmcb = svm->vmcb;
> @@ -3598,12 +3598,15 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
>  	vmcb_gpa = svm->vmcb->save.rax;
>  
>  	rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map);
> -	if (rc) {
> -		if (rc == -EINVAL)
> -			kvm_inject_gp(&svm->vcpu, 0);
> -		return false;
> +	if (rc == -EINVAL) {
> +		kvm_inject_gp(&svm->vcpu, 0);
> +		return 1;
>  	}
>  
> +	ret = kvm_skip_emulated_instruction(&svm->vcpu);
> +	if (rc)
> +		return ret;

This should probably have a comment, the 'if (rc)' looks so wrong at first
glance.  Maybe not the best suggestion on my part...

Alternatively, this sequence is more obvious and at worst adds a few bytes
to the code footprint.

	if (ret == EINVAL) {
		kvm_inject_gp(&svm->vcpu, 0);
		return 1;
	} else if (ret) {
		return kvm_skip_emulated_instruction(&svm->vcpu);
	}

	ret = kvm_skip_emulated_instruction(&svm->vcpu);

> +
>  	nested_vmcb = map.hva;
>  
>  	if (!nested_vmcb_checks(nested_vmcb)) {
> @@ -3614,7 +3617,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
>  
>  		kvm_vcpu_unmap(&svm->vcpu, &map, true);
>  
> -		return false;
> +		return ret;
>  	}
>  
>  	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb_gpa,
> @@ -3667,7 +3670,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
>  		nested_svm_vmexit(svm);
>  	}
>  
> -	return true;
> +	return ret;
>  }
>  
>  static void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
> @@ -3743,13 +3746,7 @@ static int vmrun_interception(struct vcpu_svm *svm)
>  	if (nested_svm_check_permissions(svm))
>  		return 1;
>  
> -	/* Save rip after vmrun instruction */
> -	kvm_rip_write(&svm->vcpu, kvm_rip_read(&svm->vcpu) + 3);
> -
> -	if (!nested_svm_vmrun(svm))
> -		return 1;
> -
> -	return 1;
> +	return nested_svm_vmrun(svm);
>  }
>  
>  static int stgi_interception(struct vcpu_svm *svm)
> -- 
> 2.20.1
> 
