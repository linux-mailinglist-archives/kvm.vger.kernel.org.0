Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D75BF18046E
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 18:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgCJRKS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 13:10:18 -0400
Received: from mga14.intel.com ([192.55.52.115]:37450 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbgCJRKS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 13:10:18 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 10:10:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,537,1574150400"; 
   d="scan'208";a="443241331"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 10 Mar 2020 10:10:17 -0700
Date:   Tue, 10 Mar 2020 10:10:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Pu Wen <puwen@hygon.cn>
Subject: Re: [PATCH v2 4/7] KVM: x86: Fix CPUID range checks for Hypervisor
 and Centaur classes
Message-ID: <20200310171017.GC9305@linux.intel.com>
References: <20200305013437.8578-1-sean.j.christopherson@intel.com>
 <20200305013437.8578-5-sean.j.christopherson@intel.com>
 <CALMp9eRRWZ54kzMXdTqRCy2KmaUAq+HVVVzbxJNVdgktg65XCA@mail.gmail.com>
 <20200305192532.GN11500@linux.intel.com>
 <CALMp9eRxdGj0DL0_g-an0YC+gTMcWcSk7=md=k4-8S0Zcankbg@mail.gmail.com>
 <20200305215149.GS11500@linux.intel.com>
 <5567edf6-a04c-5810-8ed5-78a0db14b202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5567edf6-a04c-5810-8ed5-78a0db14b202@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 06, 2020 at 10:03:37AM +0100, Paolo Bonzini wrote:
> On 05/03/20 22:51, Sean Christopherson wrote:
> >> Ah. So cross-vendor CPUID specifications are not supported?
> > Cross-vendor CPUID is sort of allowed?  E.g. this plays nice with creating
> > a Centaur CPU on an Intel platform.  My interpretation of GET_SUPPORTED...
> > is that KVM won't prevent enumerating what you want in CPUID, but it only
> > promises to correctly support select leafs.
> 
> But in practice does this change anything?  If the vendor is not Centaur 
> it's unlikely that there is a 0xc0000000 leaf.  The 0x80000000 bound is
> certainly not going to be at 0xc0000000 or beyond, and likewise to 0xc0000000
> bound is not going to be at 0xd0000000 or beyond.  So I'm not sure if
> anything is lost from this simplification:

Probably not?  But in the unlikely scenario that Intel wants to add a CPUID
leaf above 0xc0000000, I don't want to have to explain that it might cause
problems for KVM guests because I added code to emulate (alleged) Centaur
behavior for virtual Intel CPUs.

> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index ed5e0bda672c..f43a8875c126 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -963,8 +963,7 @@ static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
>  
>  	if (function >= 0x40000000 && function <= 0x4fffffff)
>  		class = kvm_find_cpuid_entry(vcpu, function & 0xffffff00, 0);
> -	else if (function >= 0xc0000000 && function <= 0xcfffffff &&
> -		 is_guest_vendor_centaur(basic->ebx, basic->ecx, basic->edx))
> +	else if (function >= 0xc0000000)
>  		class = kvm_find_cpuid_entry(vcpu, 0xc0000000, 0);
>  	else
>  		class = kvm_find_cpuid_entry(vcpu, function & 0x80000000, 0);
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index 12ddfa493bae..3cb50eda606d 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -424,13 +424,6 @@ static inline bool is_guest_vendor_hygon(u32 ebx, u32 ecx, u32 edx)
>  	       edx == X86EMUL_CPUID_VENDOR_HygonGenuine_edx;
>  }
>  
> -static inline bool is_guest_vendor_centaur(u32 ebx, u32 ecx, u32 edx)
> -{
> -	return ebx == X86EMUL_CPUID_VENDOR_CentaurHauls_ebx &&
> -	       ecx == X86EMUL_CPUID_VENDOR_CentaurHauls_ecx &&
> -	       edx == X86EMUL_CPUID_VENDOR_CentaurHauls_edx;
> -}
> -
>  enum x86_intercept_stage {
>  	X86_ICTP_NONE = 0,   /* Allow zero-init to not match anything */
>  	X86_ICPT_PRE_EXCEPT,
> 
