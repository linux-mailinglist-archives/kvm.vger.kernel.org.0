Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB191E34A8
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 03:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgE0BVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 21:21:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:40356 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbgE0BVl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 21:21:41 -0400
IronPort-SDR: Q1e+s7xmMiFcyU8wWg+OJBvB+v4s1/ksuetGpE+WEi43RAT6Pe6wRBoZOdCpBD8DGJfhVw4qLH
 Wp0pQ8RZgW5Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 18:21:41 -0700
IronPort-SDR: y1IVERXaiT9vHZgUR/zwGBYB9pUJ74kVYXAxqyzY9zotxceVuf/FzRUx+kq8C/UrLX5Z+nMZKn
 BuaP760ox6Vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,439,1583222400"; 
   d="scan'208";a="468558465"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 26 May 2020 18:21:40 -0700
Date:   Tue, 26 May 2020 18:21:40 -0700
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
Subject: Re: [PATCH 2/2] kvm/x86: don't expose MSR_IA32_UMWAIT_CONTROL
 unconditionally
Message-ID: <20200527012140.GD31696@linux.intel.com>
References: <20200523161455.3940-1-mlevitsk@redhat.com>
 <20200523161455.3940-3-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523161455.3940-3-mlevitsk@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 23, 2020 at 07:14:55PM +0300, Maxim Levitsky wrote:
> This msr is only available when the host supports WAITPKG feature.
> 
> This breaks a nested guest, if the L1 hypervisor is set to ignore
> unknown msrs, because the only other safety check that the
> kernel does is that it attempts to read the msr and
> rejects it if it gets an exception.
> 
> Fixes: 6e3ba4abce KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL

Same comments on the line wraps and Fixes tag.

For the code:

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b226fb8abe41b..4752293312947 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5316,6 +5316,10 @@ static void kvm_init_msr_list(void)
>  			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
>  				continue;
>  			break;
> +		case MSR_IA32_UMWAIT_CONTROL:
> +			if (!kvm_cpu_cap_has(X86_FEATURE_WAITPKG))
> +				continue;
> +			break;
>  		default:
>  			break;
>  		}
> -- 
> 2.26.2
> 
