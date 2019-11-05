Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFECF061F
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 20:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390912AbfKEThw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 14:37:52 -0500
Received: from mga05.intel.com ([192.55.52.43]:51705 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390782AbfKEThv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 14:37:51 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 11:37:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,271,1569308400"; 
   d="scan'208";a="195936707"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 05 Nov 2019 11:37:50 -0800
Date:   Tue, 5 Nov 2019 11:37:50 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: Re: [PATCH RFC] KVM: x86: tell guests if the exposed SMT topology is
 trustworthy
Message-ID: <20191105193749.GA20225@linux.intel.com>
References: <20191105161737.21395-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105161737.21395-1-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 05, 2019 at 05:17:37PM +0100, Vitaly Kuznetsov wrote:
> Virtualized guests may pick a different strategy to mitigate hardware
> vulnerabilities when it comes to hyper-threading: disable SMT completely,
> use core scheduling, or, for example, opt in for STIBP. Making the
> decision, however, requires an extra bit of information which is currently
> missing: does the topology the guest see match hardware or if it is 'fake'
> and two vCPUs which look like different cores from guest's perspective can
> actually be scheduled on the same physical core. Disabling SMT or doing
> core scheduling only makes sense when the topology is trustworthy.
> 
> Add two feature bits to KVM: KVM_FEATURE_TRUSTWORTHY_SMT with the meaning
> that KVM_HINTS_TRUSTWORTHY_SMT bit answers the question if the exposed SMT
> topology is actually trustworthy. It would, of course, be possible to get
> away with a single bit (e.g. 'KVM_FEATURE_FAKE_SMT') and not lose backwards
> compatibility but the current approach looks more straightforward.

I'd stay away from "trustworthy", especially if this is controlled by
userspace.  Whether or not the hint is trustworthy is purely up to the
guest.  Right now it doesn't really matter, but that will change as we
start moving pieces of the host out of the guest's TCB.

It may make sense to split the two (or even three?) cases, e.g.
KVM_FEATURE_NO_SMT and KVM_FEATURE_ACCURATE_TOPOLOGY.  KVM can easily
enforce NO_SMT _today_, i.e. allow it to be set if and only if SMT is
truly disabled.  Verifying that the topology exposed to the guest is legit
is a completely different beast.

If/when the kernel gains core scheduling, a new flag to communicate core
sharing could be added, e.g. KVM_FEATURE_NO_NON_ARCH_CORE_SHARING.

Differentiating between host kernel and userspace doesn't add much unless
the host kernel can attest itself to the guest, but splitting things up
at least keeps that option open.

> There were some offline discussions on whether this new feature bit should
> be complemented with a 're-enlightenment' mechanism for live migration (so
> it can change in guest's lifetime) but it doesn't seem to be very
> practical: what a sane guest is supposed to do if it's told that SMT
> topology is about to become fake other than kill itself? Also, it seems to
> make little sense to do e.g. CPU pinning on the source but not on the
> destination.
>
> There is also one additional piece of the information missing. A VM can be
> sharing physical cores with other VMs (or other userspace tasks on the
> host) so does KVM_FEATURE_TRUSTWORTHY_SMT imply that it's not the case or
> not? It is unclear if this changes anything and can probably be left out
> of scope (just don't do that).

This is why I'd go with something like "accurate" instead of "trustworthy".
 
> Similar to the already existent 'NoNonArchitecturalCoreSharing' Hyper-V
> enlightenment, the default value of KVM_HINTS_TRUSTWORTHY_SMT is set to
> !cpu_smt_possible(). KVM userspace is thus supposed to pass it to guest's
> CPUIDs in case it is '1' (meaning no SMT on the host at all) or do some
> extra work (like CPU pinning and exposing the correct topology) before
> passing '1' to the guest.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  Documentation/virt/kvm/cpuid.rst     | 27 +++++++++++++++++++--------
>  arch/x86/include/uapi/asm/kvm_para.h |  2 ++
>  arch/x86/kvm/cpuid.c                 |  7 ++++++-
>  3 files changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> index 01b081f6e7ea..64b94103fc90 100644
> --- a/Documentation/virt/kvm/cpuid.rst
> +++ b/Documentation/virt/kvm/cpuid.rst
> @@ -86,6 +86,10 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest checks this feature bit
>                                                before using paravirtualized
>                                                sched yield.
>  
> +KVM_FEATURE_TRUSTWORTHY_SMT       14          set when host supports 'SMT
> +                                              topology is trustworthy' hint
> +                                              (KVM_HINTS_TRUSTWORTHY_SMT).
> +
>  KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
>                                                per-cpu warps are expeced in
>                                                kvmclock
> @@ -97,11 +101,18 @@ KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
>  
>  Where ``flag`` here is defined as below:
>  
> -================== ============ =================================
> -flag               value        meaning
> -================== ============ =================================
> -KVM_HINTS_REALTIME 0            guest checks this feature bit to
> -                                determine that vCPUs are never
> -                                preempted for an unlimited time
> -                                allowing optimizations
> -================== ============ =================================
> +================================= =========== =================================
> +flag                              value       meaning
> +================================= =========== =================================
> +KVM_HINTS_REALTIME                0           guest checks this feature bit to
> +                                              determine that vCPUs are never
> +                                              preempted for an unlimited time
> +                                              allowing optimizations
> +
> +KVM_HINTS_TRUSTWORTHY_SMT         1           the bit is set when the exposed
> +                                              SMT topology is trustworthy, this
> +                                              means that two guest vCPUs will
> +                                              never share a physical core
> +                                              unless they are exposed as SMT
> +                                              threads.
> +================================= =========== =================================
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 2a8e0b6b9805..183239d5dfad 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -31,8 +31,10 @@
>  #define KVM_FEATURE_PV_SEND_IPI	11
>  #define KVM_FEATURE_POLL_CONTROL	12
>  #define KVM_FEATURE_PV_SCHED_YIELD	13
> +#define KVM_FEATURE_TRUSTWORTHY_SMT	14
>  
>  #define KVM_HINTS_REALTIME      0
> +#define KVM_HINTS_TRUSTWORTHY_SMT	1
>  
>  /* The last 8 bits are used to indicate how to interpret the flags field
>   * in pvclock structure. If no bits are set, all flags are ignored.
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index f68c0c753c38..dab527a7081f 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -712,7 +712,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  			     (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
>  			     (1 << KVM_FEATURE_PV_SEND_IPI) |
>  			     (1 << KVM_FEATURE_POLL_CONTROL) |
> -			     (1 << KVM_FEATURE_PV_SCHED_YIELD);
> +			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
> +			     (1 << KVM_FEATURE_TRUSTWORTHY_SMT);
>  
>  		if (sched_info_on())
>  			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
> @@ -720,6 +721,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  		entry->ebx = 0;
>  		entry->ecx = 0;
>  		entry->edx = 0;
> +
> +		if (!cpu_smt_possible())
> +			entry->edx |= (1 << KVM_HINTS_TRUSTWORTHY_SMT);
> +
>  		break;
>  	case 0x80000000:
>  		entry->eax = min(entry->eax, 0x8000001f);
> -- 
> 2.20.1
> 
