Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C03D1748AD
	for <lists+kvm@lfdr.de>; Sat, 29 Feb 2020 19:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbgB2ScV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 Feb 2020 13:32:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:1549 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727274AbgB2ScV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Feb 2020 13:32:21 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Feb 2020 10:32:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,500,1574150400"; 
   d="scan'208";a="232610651"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 29 Feb 2020 10:32:18 -0800
Date:   Sat, 29 Feb 2020 10:32:19 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/61] KVM: x86: Introduce KVM cpu caps
Message-ID: <20200229183219.GA22451@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <87wo8ak84x.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wo8ak84x.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 25, 2020 at 04:18:38PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> >
> >   7. Profit!
> 
> Would it be better or worse if we eliminate set_supported_cpuid() hook
> completely by doing an ugly hack like (completely untested):
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a2a091d328c6..5ad291d48e1b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1145,8 +1145,6 @@ struct kvm_x86_ops {
>  
>         void (*set_tdp_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
>  
> -       void (*set_supported_cpuid)(struct kvm_cpuid_entry2 *entry);
> -
>         bool (*has_wbinvd_exit)(void);
>  
>         u64 (*read_l1_tsc_offset)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index e8beb1e542a8..88431fc02797 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -749,6 +749,16 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
>  		break;
>  	}
> +	case 0x8000000A:
> +		if (boot_cpu_has(X86_FEATURE_SVM)) {
> +			entry->eax = 1; /* SVM revision 1 */
> +			entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
> +					   ASID emulation to nested SVM */
> +			entry->ecx = 0; /* Reserved */
> +			entry->edx = 0; /* Per default do not support any
> +					   additional features */

Lucky thing that you suggested this change, patch ("KVM: SVM: Convert
feature updates from CPUID to KVM cpu caps") was buggy in that clearing
entry->edx here would wipe out all X86_FEATURE_NRIPS and X86_FEATURE_NPT.
Only noticed it when moving this code. 
