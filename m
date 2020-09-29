Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC17627BC4E
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 07:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725791AbgI2FP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 01:15:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:10267 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI2FP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 01:15:28 -0400
IronPort-SDR: Bm+EbaawbJDQ+rlpgwhgqSYR6TxIklYrLVzifWew0xHFwX1AZ6CFEw9jZYEI9EaHlAME2uK3Rf
 nd40msS0PbiQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="162180219"
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="scan'208";a="162180219"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 22:15:27 -0700
IronPort-SDR: DTZmPi9P93L/egJWF9MbJKYfFpDPN2yT9BwsCdgxHKC1nCm2v7aLggLB4d/6P6AzP0ylnW/f9k
 T1oPt0BuLQ4A==
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="scan'208";a="457124988"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 22:15:27 -0700
Date:   Mon, 28 Sep 2020 22:15:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH v6 4/4] KVM: nSVM: implement on demand allocation of the
 nested state
Message-ID: <20200929051526.GD353@linux.intel.com>
References: <20200922211025.175547-1-mlevitsk@redhat.com>
 <20200922211025.175547-5-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922211025.175547-5-mlevitsk@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 23, 2020 at 12:10:25AM +0300, Maxim Levitsky wrote:
> This way we don't waste memory on VMs which don't use nesting
> virtualization even when the host enabled it for them.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 42 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c    | 55 ++++++++++++++++++++++-----------------
>  arch/x86/kvm/svm/svm.h    |  6 +++++
>  3 files changed, 79 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 09417f5197410..dd13856818a03 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -467,6 +467,9 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
>  
>  	vmcb12 = map.hva;
>  
> +	if (WARN_ON(!svm->nested.initialized))

Probably should use WARN_ON_ONCE, if this is somehow it, userspace could
easily spam the kernel.

Side topic, do we actually need 'initialized'?  Wouldn't checking for a
valid nested.msrpm or nested.hsave suffice?

> +		return 1;
> +
>  	if (!nested_vmcb_checks(svm, vmcb12)) {
>  		vmcb12->control.exit_code    = SVM_EXIT_ERR;
>  		vmcb12->control.exit_code_hi = 0;
> @@ -684,6 +687,45 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  	return 0;
>  }
