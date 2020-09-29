Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5030027BC4A
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 07:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbgI2FMt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 01:12:49 -0400
Received: from mga07.intel.com ([134.134.136.100]:25022 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbgI2FMt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 01:12:49 -0400
IronPort-SDR: 6i0PBDolXhukmCxWsf5KGuhNX6jQs4qj7qDw3k2TY+oLOBDM8NKZQEKflrO7ewbmPV0W3WhPsB
 Wsj+Wa4r9zcg==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="226261518"
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="scan'208";a="226261518"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 22:12:47 -0700
IronPort-SDR: HCchCqbYo5JjqGlY0drYNSEreq+kjcjcKmix9f+XbbTuQQjsxlSMRz3+SKvkJWoaUcyuetvgw8
 ZxtovUCW3sSw==
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="scan'208";a="350085017"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 22:12:46 -0700
Date:   Mon, 28 Sep 2020 22:12:45 -0700
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
Subject: Re: [PATCH v6 3/4] KVM: x86: allow kvm_x86_ops.set_efer to return an
 error value
Message-ID: <20200929051245.GC353@linux.intel.com>
References: <20200922211025.175547-1-mlevitsk@redhat.com>
 <20200922211025.175547-4-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922211025.175547-4-mlevitsk@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 23, 2020 at 12:10:24AM +0300, Maxim Levitsky wrote:
> This will be used to signal an error to the userspace, in case
> the vendor code failed during handling of this msr. (e.g -ENOMEM)
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e4b07be450d4e..df53baa0059fe 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1456,6 +1456,7 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  {
>  	u64 old_efer = vcpu->arch.efer;
>  	u64 efer = msr_info->data;
> +	int r;
>  
>  	if (efer & efer_reserved_bits)
>  		return 1;
> @@ -1472,7 +1473,12 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	efer &= ~EFER_LMA;
>  	efer |= vcpu->arch.efer & EFER_LMA;
>  
> -	kvm_x86_ops.set_efer(vcpu, efer);
> +	r = kvm_x86_ops.set_efer(vcpu, efer);
> +

Nit: IMO, omitting the newline would help the reader make a direct connection
between setting 'r' and checking 'r'.

> +	if (r) {
> +		WARN_ON(r > 0);
> +		return r;
> +	}
>  
>  	/* Update reserved bits */
>  	if ((efer ^ old_efer) & EFER_NX)
> -- 
> 2.26.2
> 
