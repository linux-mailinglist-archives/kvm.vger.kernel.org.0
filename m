Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDE7B69C7
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 19:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbfIRRnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 13:43:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:27720 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727824AbfIRRnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 13:43:09 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Sep 2019 10:43:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,521,1559545200"; 
   d="scan'208";a="189334744"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 18 Sep 2019 10:43:08 -0700
Date:   Wed, 18 Sep 2019 10:43:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Steve Rutherford <srutherford@google.com>,
        Jacob Xu <jacobhxu@google.com>, Peter Shier <pshier@google.com>
Subject: Re: [RFC][PATCH] kvm: x86: Improve emulation of CPUID leaves 0BH and
 1FH
Message-ID: <20190918174308.GC14850@linux.intel.com>
References: <20190912232753.85969-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912232753.85969-1-jmattson@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 12, 2019 at 04:27:53PM -0700, Jim Mattson wrote:
> If these CPUID leaves are implemented, the EDX output is always the
> x2APIC ID, regardless of the ECX input. Furthermore, the low byte of
> the ECX output is always identical to the low byte of the ECX input.
> 
> KVM's CPUID emulation doesn't report the correct ECX and EDX outputs
> when the ECX input is greater than the first subleaf for which the
> "level type" is zero. This is probably only significant in the case of
> the x2APIC ID, which should be the result of CPUID(EAX=0BH):EDX or
> CPUID(EAX=1FH):EDX, without even setting a particular ECX input value.

At a glance, shouldn't leaf 0x1f be marked significant in do_host_cpuid()?

> Create a "wildcard" kvm_cpuid_entry2 for leaves 0BH and 1FH in
> response to the KVM_GET_SUPPORTED_CPUID ioctl. This entry does not
> have the KVM_CPUID_FLAG_SIGNIFCANT_INDEX flag, so it matches all
> subleaves for which there isn't a prior explicit index match.
> 
> Add a new KVM_CPUID flag that is only applicable to leaves 0BH and
> 1FH: KVM_CPUID_FLAG_CL_IS_PASSTHROUGH. When KVM's CPUID emulation
> encounters this flag, it will fix up ECX[7:0] in the CPUID output. Add
> this flag to the aforementioned "wildcard" kvm_cpuid_entry2.
> 
> Note that userspace is still responsible for setting EDX to the x2APIC
> ID of the vCPU in each of these structures, *including* the wildcard.
> 
> Qemu doesn't pass the flags from KVM_GET_SUPPORTED_CPUID to
> KVM_SET_CPUID2, so it will have to be modified to take advantage of
> these changes. Note that passing the new flag to older kernels will
> have no effect.
> 
> Unfortunately, the new flag bit was not previously reserved, so it is
> possible that a userspace agent that already sets this bit will be
> unhappy with the new behavior. Technically, I suppose, this should be
> implemented as a new set of ioctls. Posting as an RFC to get comments
> on the API breakage.
> 
> Fixes: 0771671749b59a ("KVM: Enhance guest cpuid management")
> Fixes: a87f2d3a6eadab ("KVM: x86: Add Intel CPUID.1F cpuid emulation support")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Steve Rutherford <srutherford@google.com>
> Reviewed-by: Jacob Xu <jacobhxu@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Change-Id: I6b422427f78b530106af3f929518363895367e25
> ---
>  Documentation/virt/kvm/api.txt  |  6 +++++
>  arch/x86/include/uapi/asm/kvm.h |  1 +
>  arch/x86/kvm/cpuid.c            | 39 +++++++++++++++++++++++++++------
>  3 files changed, 39 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> index 2d067767b6170..be5cc42ad35f4 100644
> --- a/Documentation/virt/kvm/api.txt
> +++ b/Documentation/virt/kvm/api.txt
> @@ -1396,6 +1396,7 @@ struct kvm_cpuid2 {
>  #define KVM_CPUID_FLAG_SIGNIFCANT_INDEX		BIT(0)
>  #define KVM_CPUID_FLAG_STATEFUL_FUNC		BIT(1)
>  #define KVM_CPUID_FLAG_STATE_READ_NEXT		BIT(2)
> +#define KVM_CPUID_FLAG_CL_IS_PASSTHROUGH	BIT(3)
>  
>  struct kvm_cpuid_entry2 {
>  	__u32 function;
> @@ -1447,6 +1448,8 @@ emulate them efficiently. The fields in each entry are defined as follows:
>          KVM_CPUID_FLAG_STATE_READ_NEXT:
>             for KVM_CPUID_FLAG_STATEFUL_FUNC entries, set if this entry is
>             the first entry to be read by a cpu
> +	KVM_CPUID_FLAG_CL_IS_PASSTHROUGH:
> +	   If the output value of ECX[7:0] matches the input value of ECX[7:0]
>     eax, ebx, ecx, edx: the values returned by the cpuid instruction for
>           this function/index combination
>  
> @@ -2992,6 +2995,7 @@ The member 'flags' is used for passing flags from userspace.
>  #define KVM_CPUID_FLAG_SIGNIFCANT_INDEX		BIT(0)
>  #define KVM_CPUID_FLAG_STATEFUL_FUNC		BIT(1)
>  #define KVM_CPUID_FLAG_STATE_READ_NEXT		BIT(2)
> +#define KVM_CPUID_FLAG_CL_IS_PASSTHROUGH	BIT(3)
>  
>  struct kvm_cpuid_entry2 {
>  	__u32 function;
> @@ -3040,6 +3044,8 @@ The fields in each entry are defined as follows:
>          KVM_CPUID_FLAG_STATE_READ_NEXT:
>             for KVM_CPUID_FLAG_STATEFUL_FUNC entries, set if this entry is
>             the first entry to be read by a cpu
> +	KVM_CPUID_FLAG_CL_IS_PASSTHROUGH:
> +	   If the output value of ECX[7:0] matches the input value of ECX[7:0]
>     eax, ebx, ecx, edx: the values returned by the cpuid instruction for
>           this function/index combination
>  
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 503d3f42da167..3b67d21123946 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -223,6 +223,7 @@ struct kvm_cpuid_entry2 {
>  #define KVM_CPUID_FLAG_SIGNIFCANT_INDEX		(1 << 0)
>  #define KVM_CPUID_FLAG_STATEFUL_FUNC		(1 << 1)
>  #define KVM_CPUID_FLAG_STATE_READ_NEXT		(1 << 2)
> +#define KVM_CPUID_FLAG_CL_IS_PASSTHROUGH	(1 << 3)
>  
>  /* for KVM_SET_CPUID2 */
>  struct kvm_cpuid2 {
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index e7d25f4364664..280a796159cb2 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -612,19 +612,41 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  	 */
>  	case 0x1f:
>  	case 0xb: {
> -		int i, level_type;
> +		int i;
>  
> -		/* read more entries until level_type is zero */
> -		for (i = 1; ; ++i) {
> +		/*
> +		 * We filled in entry[0] for CPUID(EAX=<function>,
> +		 * ECX=00H) above.  If its level type (ECX[15:8]) is
> +		 * zero, then the leaf is unimplemented, and we're
> +		 * done.  Otherwise, continue to populate entries
> +		 * until the level type (ECX[15:8]) of the previously
> +		 * added entry is zero.
> +		 */
> +		for (i = 1; entry[i - 1].ecx & 0xff00; ++i) {
>  			if (*nent >= maxnent)
>  				goto out;
>  
> -			level_type = entry[i - 1].ecx & 0xff00;
> -			if (!level_type)
> -				break;
>  			do_host_cpuid(&entry[i], function, i);
>  			++*nent;
>  		}

This should be a standalone bugfix/enhancement path.  Bugfix because it
eliminates a false positive on *nent >= maxnent.

> +
> +		if (i > 1) {
> +			/*
> +			 * If this leaf has multiple entries, treat
> +			 * the final entry as a "wildcard." Clear the
> +			 * "significant index" flag so that the index
> +			 * will be ignored when we later look for an
> +			 * entry that matches a CPUID
> +			 * invocation. Since this entry will now match
> +			 * CPUID(EAX=<function>, ECX=<index>) for any
> +			 * <index> >= (i - 1), set the "CL
> +			 * passthrough" flag to ensure that ECX[7:0]
> +			 * will be set to (<index> & 0xff), per the SDM.
> +			 */
> +			entry[i - 1].flags &= ~KVM_CPUID_FLAG_SIGNIFCANT_INDEX;

If I'm reading the code correctly, this is fragile and subtle.  The order
of cpuid entries is controlled by userspace, which means that clearing
KVM_CPUID_FLAG_SIGNIFCANT_INDEX depends on this entry being kept after all
other entries for this function.  In practice I'm guessing userspaces
naturally sort entries with the same function by ascending index, but it
seems like avoidable issue.

Also, won't matching the last entry generate the wrong values for EAX, EBX
and ECX, i.e. the valid values for the last index instead of zeroes?

> +			entry[i - 1].flags |= KVM_CPUID_FLAG_CL_IS_PASSTHROUGH;

Lastly, do we actually need to enumerate this silliness to userspace?
What if we handle this as a one-off case in CPUID emulation and avoid the
ABI breakage that way?  E.g.:

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index dd5985eb61b4..aaf5cdcb88c9 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1001,6 +1001,16 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
        }

 out:
+       if (!best && (function == 0xb || function == 0x1f)) {
+               best = check_cpuid_limit(vcpu, function, 0);
+               if (best) {
+                       *eax = 0;
+                       *ebx = 0;
+                       *ecx &= 0xff;
+                       *edx = *best->edx;
+               }
+       }
+
        if (best) {
                *eax = best->eax;
                *ebx = best->ebx;

> +		}
> +
>  		break;
>  	}
>  	case 0xd: {
> @@ -1001,8 +1023,11 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>  		*ebx = best->ebx;
>  		*ecx = best->ecx;
>  		*edx = best->edx;
> -	} else
> +		if (best->flags & KVM_CPUID_FLAG_CL_IS_PASSTHROUGH)
> +			*ecx = (*ecx & ~0xff) | (index & 0xff);
> +	} else {
>  		*eax = *ebx = *ecx = *edx = 0;
> +	}
>  	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, entry_found);
>  	return entry_found;
>  }
> -- 
> 2.23.0.237.gc6a4ce50a0-goog
> 
