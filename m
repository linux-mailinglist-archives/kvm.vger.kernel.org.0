Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 396D0177A8B
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 16:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbgCCPfv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 10:35:51 -0500
Received: from mga14.intel.com ([192.55.52.115]:42732 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729588AbgCCPfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 10:35:51 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 07:35:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="386820172"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 03 Mar 2020 07:35:50 -0800
Date:   Tue, 3 Mar 2020 07:35:50 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v2 36/66] KVM: x86: Handle GBPAGE CPUID adjustment for
 EPT in VMX code
Message-ID: <20200303153550.GC1439@linux.intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
 <20200302235709.27467-37-sean.j.christopherson@intel.com>
 <90df7276-e586-9082-3d80-6b45e0fb4670@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90df7276-e586-9082-3d80-6b45e0fb4670@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 03, 2020 at 03:59:14PM +0100, Paolo Bonzini wrote:
> On 03/03/20 00:56, Sean Christopherson wrote:
> > Move the clearing of the GBPAGE CPUID bit into VMX to eliminate an
> > instance of the undesirable "unsigned f_* = *_supported ? F(*) : 0"
> > pattern in the common CPUID handling code, and to pave the way toward
> > eliminating ->get_lpage_level().
> > 
> > No functional change intended.
> 
> And no functional change is done indeed but there is a preexisting bug 
> that should be fixed.
> 
> cpu_has_vmx_ept_1g_page() has no relationship to whether 1GB pages should be
> marked as supported in CPUID.  This has no ill effect because we're only
> clearing the bit, but it results in 1GB pages not being available when
> EPT is disabled (even though they are actually supported thanks to
> shadowing).

Oof, that took me a long time to process.  You're saying that KVM can
allow the guest to use GBPAGES when shadow paging is enabled because KVM
can effectively emulate GBPAGES.  And IIUC, you're also saying that
cpuid.GBPAGES should never be influenced by EPT restrictions.

That all makes sense.

> The right fix should be this:
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 84b9a488a443..8bbba8eb4ce5 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -416,8 +416,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  	int r, i, max_idx;
>  	unsigned f_nx = is_efer_nx() ? F(NX) : 0;
>  #ifdef CONFIG_X86_64
> -	unsigned f_gbpages = (kvm_x86_ops->get_lpage_level() == PT_PDPE_LEVEL)
> -				? F(GBPAGES) : 0;
> +	unsigned f_gbpages = F(GBPAGES);
>  	unsigned f_lm = F(LM);
>  #else
>  	unsigned f_gbpages = 0;
> @@ -691,6 +690,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  	case 0x80000001:
>  		entry->edx &= kvm_cpuid_8000_0001_edx_x86_features;
>  		cpuid_entry_mask(entry, CPUID_8000_0001_EDX);
> +		if (!tdp_enabled)
> +			cpuid_entry_set(entry, X86_FEATURE_GBPAGES);
>  		entry->ecx &= kvm_cpuid_8000_0001_ecx_x86_features;
>  		cpuid_entry_mask(entry, CPUID_8000_0001_ECX);
>  		break;
> 
> Paolo
> 
