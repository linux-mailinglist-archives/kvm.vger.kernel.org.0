Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82B64882DE
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 20:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406518AbfHISqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 14:46:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:6049 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbfHISqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 14:46:45 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Aug 2019 11:46:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,366,1559545200"; 
   d="scan'208";a="199479996"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 09 Aug 2019 11:46:44 -0700
Date:   Fri, 9 Aug 2019 11:46:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v3 6/7] x86: KVM: svm: eliminate weird goto from
 vmrun_interception()
Message-ID: <20190809184644.GF10541@linux.intel.com>
References: <20190808173051.6359-1-vkuznets@redhat.com>
 <20190808173051.6359-7-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808173051.6359-7-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 08, 2019 at 07:30:50PM +0200, Vitaly Kuznetsov wrote:
> Regardless of whether or not nested_svm_vmrun_msrpm() fails, we return 1
> from vmrun_interception() so there's no point in doing goto. Also,
> nested_svm_vmrun_msrpm() call can be made from nested_svm_vmrun() where
> other nested launch issues are handled.
> 
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/svm.c | 23 +++++++++--------------
>  1 file changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 6d16d1898810..43bc4a5e4948 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -3658,6 +3658,15 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
>  
>  	enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb, &map);
>  
> +	if (!nested_svm_vmrun_msrpm(svm)) {
> +		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
> +		svm->vmcb->control.exit_code_hi = 0;
> +		svm->vmcb->control.exit_info_1  = 0;
> +		svm->vmcb->control.exit_info_2  = 0;
> +
> +		nested_svm_vmexit(svm);
> +	}
> +
>  	return true;

nested_svm_vmrun() no longer needs a return value, it just needs to return
early.  But making it 'void' just to change it to 'int' in the next patch
is a bit gratuitous, so what about changing it to return an 'int' in this
patch?

That'd also eliminate the funky

	if (!nested_svm_vmrun(svm))
		return 1;

	return 1;

chunk in vmrun_interception() that temporarily exists until patch 7/7.

>  }
>  
> @@ -3740,20 +3749,6 @@ static int vmrun_interception(struct vcpu_svm *svm)
>  	if (!nested_svm_vmrun(svm))
>  		return 1;
>  
> -	if (!nested_svm_vmrun_msrpm(svm))
> -		goto failed;
> -
> -	return 1;
> -
> -failed:
> -
> -	svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
> -	svm->vmcb->control.exit_code_hi = 0;
> -	svm->vmcb->control.exit_info_1  = 0;
> -	svm->vmcb->control.exit_info_2  = 0;
> -
> -	nested_svm_vmexit(svm);
> -
>  	return 1;
>  }
>  
> -- 
> 2.20.1
> 
