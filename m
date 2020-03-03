Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5FD176DA5
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 04:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgCCDpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 22:45:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:16934 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbgCCDpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 22:45:33 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 19:45:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="351725731"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 02 Mar 2020 19:45:32 -0800
Date:   Mon, 2 Mar 2020 19:45:32 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Jan Kiszka <jan.kiszka@siemens.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] KVM: x86: Fix tracing of CPUID.function when
 function is out-of-range
Message-ID: <20200303034532.GC27842@linux.intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
 <20200302195736.24777-2-sean.j.christopherson@intel.com>
 <188dc96a-6a3b-4021-061a-0f11cbb9f177@siemens.com>
 <20200302204940.GG6244@linux.intel.com>
 <16e902a8-7883-0b67-d4ee-73e8fe22f955@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16e902a8-7883-0b67-d4ee-73e8fe22f955@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 03, 2020 at 10:27:47AM +0800, Xiaoyao Li wrote:
> On 3/3/2020 4:49 AM, Sean Christopherson wrote:
> >On Mon, Mar 02, 2020 at 09:26:54PM +0100, Jan Kiszka wrote:
> >>On 02.03.20 20:57, Sean Christopherson wrote:
> >>>Rework kvm_cpuid() to query entry->function when adjusting the output
> >>>values so that the original function (in the aptly named "function") is
> >>>preserved for tracing.  This fixes a bug where trace_kvm_cpuid() will
> >>>trace the max function for a range instead of the requested function if
> >>>the requested function is out-of-range and an entry for the max function
> >>>exists.
> >>>
> >>>Fixes: 43561123ab37 ("kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH")
> >>>Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
> >>>Cc: Jim Mattson <jmattson@google.com>
> >>>Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> >>>Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >>>---
> >>>  arch/x86/kvm/cpuid.c | 15 +++++++--------
> >>>  1 file changed, 7 insertions(+), 8 deletions(-)
> >>>
> >>>diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> >>>index b1c469446b07..6be012937eba 100644
> >>>--- a/arch/x86/kvm/cpuid.c
> >>>+++ b/arch/x86/kvm/cpuid.c
> >>>@@ -997,12 +997,12 @@ static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
> >>>  	return max && function <= max->eax;
> >>>  }
> >>>+/* Returns true if the requested leaf/function exists in guest CPUID. */
> >>>  bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
> >>>  	       u32 *ecx, u32 *edx, bool check_limit)
> >>>  {
> >>>-	u32 function = *eax, index = *ecx;
> >>>+	const u32 function = *eax, index = *ecx;
> >>>  	struct kvm_cpuid_entry2 *entry;
> >>>-	struct kvm_cpuid_entry2 *max;
> >>>  	bool found;
> >>>  	entry = kvm_find_cpuid_entry(vcpu, function, index);
> >>>@@ -1015,18 +1015,17 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
> >>>  	 */
> >>>  	if (!entry && check_limit && !guest_cpuid_is_amd(vcpu) &&
> >>>  	    !cpuid_function_in_range(vcpu, function)) {
> >>>-		max = kvm_find_cpuid_entry(vcpu, 0, 0);
> >>>-		if (max) {
> >>>-			function = max->eax;
> >>>-			entry = kvm_find_cpuid_entry(vcpu, function, index);
> >>>-		}
> >>>+		entry = kvm_find_cpuid_entry(vcpu, 0, 0);
> >>>+		if (entry)
> >>>+			entry = kvm_find_cpuid_entry(vcpu, entry->eax, index);
> >>>  	}
> >>>  	if (entry) {
> >>>  		*eax = entry->eax;
> >>>  		*ebx = entry->ebx;
> >>>  		*ecx = entry->ecx;
> >>>  		*edx = entry->edx;
> >>>-		if (function == 7 && index == 0) {
> >>>+
> >>>+		if (entry->function == 7 && index == 0) {
> >>>  			u64 data;
> >>>  		        if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
> >>>  			    (data & TSX_CTRL_CPUID_CLEAR))
> >>>
> >>
> >>What about the !entry case below this? It was impacted by the function
> >>capping so far, not it's no longer.
> >
> >Hmm, the only way the output would be different is in a really contrived
> >scenario where userspace doesn't provide an entry for the max basic leaf.
> >
> >The !entry path can only be reached with "orig_function != function" if
> >orig_function is out of range and there is no entry for the max basic leaf.
> 
> >The adjustments for 0xb/0x1f require the max basic leaf to be 0xb or 0x1f,
> >and to take effect with !entry would require there to be a CPUID.max.1 but
> >not a CPUID.max.0.  That'd be a violation of Intel's SDM, i.e. it's bogus
> >userspace input and IMO can be ignored.
> >
> 
> Sorry I cannot catch you. Why it's a violation of Intel's SDM?

The case being discussed above would look like:

KVM CPUID Entries:
   Function   Index Output
   0x00000000 0x00: eax=0x0000000b ebx=0x756e6547 ecx=0x6c65746e edx=0x49656e69
   0x00000001 0x00: eax=0x000906ea ebx=0x03000800 ecx=0xfffa3223 edx=0x0f8bfbff
   0x00000002 0x00: eax=0x00000001 ebx=0x00000000 ecx=0x0000004d edx=0x002c307d
   0x00000003 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
   0x00000004 0x00: eax=0x00000121 ebx=0x01c0003f ecx=0x0000003f edx=0x00000001
   0x00000004 0x01: eax=0x00000122 ebx=0x01c0003f ecx=0x0000003f edx=0x00000001
   0x00000004 0x02: eax=0x00000143 ebx=0x03c0003f ecx=0x00000fff edx=0x00000001
   0x00000004 0x03: eax=0x00000163 ebx=0x03c0003f ecx=0x00003fff edx=0x00000006
   0x00000005 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000003 edx=0x00000000
   0x00000006 0x00: eax=0x00000004 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
   0x00000007 0x00: eax=0x00000000 ebx=0x009c4fbb ecx=0x00000004 edx=0x84000000
   0x00000008 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
   0x00000009 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
   0x0000000a 0x00: eax=0x07300402 ebx=0x00000000 ecx=0x00000000 edx=0x00000603
--> MISSING CPUID.0xB.0
   0x0000000b 0x01: eax=0x00000000 ebx=0x00000001 ecx=0x00000201 edx=0x00000003

CPUID.0xB.0 does not exist, so output.ECX=0, which indicates an invalid
level-type.

The SDM states (for CPUID.0xB):

   If an input value n in ECX returns the invalid level-type of 0 in ECX[15:8],
   other input values with ECX > n also return 0 in ECX[15:8]

That means returning a valid level-type in CPUID.0xB.1 as above violates
the SDM's definition of how leaf 0xB works.  I'm arguing we can ignore the
adjustments that would be done on output.E{C,D} for an out of range leaf
because the model is bogus.

> Supposing the max basic is 0x1f, and it queries cpuid(0x20, 0x5),
> it should return cpuid(0x1f, 0x5).
> 
> But based on this patch, it returns all zeros.

Have you tested the patch, or is your comment based on the above discussion
and/or code inspection?  Honest question, because I've thoroughly tested
the above scenario and it works as you describe, but now I'm worried I
completely botched my testing.
