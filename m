Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF8A1E34A6
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 03:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgE0BUk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 21:20:40 -0400
Received: from mga12.intel.com ([192.55.52.136]:59234 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728091AbgE0BUk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 21:20:40 -0400
IronPort-SDR: 1f4YdQ4VlHL0Fm1WvCVAy9XQM34TV/O/QL+y0ggY314UXOTTxsObtlPThQ/Gyq/FyBCkSap84G
 JecNyt/elz2g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 18:20:39 -0700
IronPort-SDR: hAgKyeHCBaFhOYSPZW0fwxys3UDsqclGl4hXiFIOO7DrqSJhToN67IjLjQm7c8NATQDqRem89r
 RDKbgQc8R51g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,439,1583222400"; 
   d="scan'208";a="266664018"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 26 May 2020 18:20:39 -0700
Date:   Tue, 26 May 2020 18:20:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Tao Xu <tao3.xu@intel.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH 1/2] kvm/x86/vmx: enable X86_FEATURE_WAITPKG in KVM
 capabilities
Message-ID: <20200527012039.GC31696@linux.intel.com>
References: <20200523161455.3940-1-mlevitsk@redhat.com>
 <20200523161455.3940-2-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523161455.3940-2-mlevitsk@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 23, 2020 at 07:14:54PM +0300, Maxim Levitsky wrote:
> Even though we might not allow the guest to use
> WAITPKG's new instructions, we should tell KVM
> that the feature is supported by the host CPU.
> 
> Note that vmx_waitpkg_supported checks that WAITPKG
> _can_ be set in secondary execution controls as specified
> by VMX capability MSR, rather that we actually enable it for a guest.

These line wraps are quite weird and inconsistent.

> 
> Fixes: e69e72faa3a0 KVM: x86: Add support for user wait instructions

Checkpatch doesn't complain,  but the preferred Fixes format is

  Fixes: e69e72faa3a07 ("KVM: x86: Add support for user wait instructions")

e.g.

  git show -s --pretty='tformat:%h ("%s")'

For the code itself:

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 55712dd86bafa..fca493d4517c5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7298,6 +7298,9 @@ static __init void vmx_set_cpu_caps(void)
>  	/* CPUID 0x80000001 */
>  	if (!cpu_has_vmx_rdtscp())
>  		kvm_cpu_cap_clear(X86_FEATURE_RDTSCP);
> +
> +	if (vmx_waitpkg_supported())
> +		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
>  }
>  
>  static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
> -- 
> 2.26.2
> 
