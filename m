Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C35283592
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 17:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731692AbfHFPqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 11:46:44 -0400
Received: from mga03.intel.com ([134.134.136.65]:46146 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729161AbfHFPqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 11:46:44 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 08:40:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,353,1559545200"; 
   d="scan'208";a="179186990"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 06 Aug 2019 08:40:33 -0700
Date:   Tue, 6 Aug 2019 08:40:33 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 2/5] x86: KVM: svm: avoid flooding logs when
 skip_emulated_instruction() fails
Message-ID: <20190806154033.GD27766@linux.intel.com>
References: <20190806060150.32360-1-vkuznets@redhat.com>
 <20190806060150.32360-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806060150.32360-3-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 06, 2019 at 08:01:47AM +0200, Vitaly Kuznetsov wrote:
> When we're unable to skip instruction with kvm_emulate_instruction() we
> will not advance RIP and most likely the guest will get stuck as
> consequitive attempts to execute the same instruction will likely result
> in the same behavior.
> 
> As we're not supposed to see these messages under normal conditions, switch
> to pr_err_once().
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/svm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 7e843b340490..80f576e05112 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -782,7 +782,8 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
>  	if (!svm->next_rip) {
>  		if (kvm_emulate_instruction(vcpu, EMULTYPE_SKIP) !=
>  				EMULATE_DONE)
> -			printk(KERN_DEBUG "%s: NOP\n", __func__);
> +			pr_err_once("KVM: %s: unable to skip instruction\n",
> +				    __func__);

IMO the proper fix would be to change skip_emulated_instruction() to
return an int so that emulation failure can be reported back up the stack.
It's a relatively minor change as there are a limited number of call sites
to skip_emulated_instruction() in SVM and VMX.

>  		return;
>  	}
>  	if (svm->next_rip - kvm_rip_read(vcpu) > MAX_INST_SIZE)
> -- 
> 2.20.1
> 
