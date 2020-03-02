Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4F4176554
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 21:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgCBUtl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 15:49:41 -0500
Received: from mga07.intel.com ([134.134.136.100]:13572 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgCBUtl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 15:49:41 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 12:49:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,508,1574150400"; 
   d="scan'208";a="440279368"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 02 Mar 2020 12:49:40 -0800
Date:   Mon, 2 Mar 2020 12:49:40 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jan Kiszka <jan.kiszka@siemens.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 1/6] KVM: x86: Fix tracing of CPUID.function when
 function is out-of-range
Message-ID: <20200302204940.GG6244@linux.intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
 <20200302195736.24777-2-sean.j.christopherson@intel.com>
 <188dc96a-6a3b-4021-061a-0f11cbb9f177@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <188dc96a-6a3b-4021-061a-0f11cbb9f177@siemens.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 02, 2020 at 09:26:54PM +0100, Jan Kiszka wrote:
> On 02.03.20 20:57, Sean Christopherson wrote:
> >Rework kvm_cpuid() to query entry->function when adjusting the output
> >values so that the original function (in the aptly named "function") is
> >preserved for tracing.  This fixes a bug where trace_kvm_cpuid() will
> >trace the max function for a range instead of the requested function if
> >the requested function is out-of-range and an entry for the max function
> >exists.
> >
> >Fixes: 43561123ab37 ("kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH")
> >Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
> >Cc: Jim Mattson <jmattson@google.com>
> >Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >---
> >  arch/x86/kvm/cpuid.c | 15 +++++++--------
> >  1 file changed, 7 insertions(+), 8 deletions(-)
> >
> >diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> >index b1c469446b07..6be012937eba 100644
> >--- a/arch/x86/kvm/cpuid.c
> >+++ b/arch/x86/kvm/cpuid.c
> >@@ -997,12 +997,12 @@ static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
> >  	return max && function <= max->eax;
> >  }
> >+/* Returns true if the requested leaf/function exists in guest CPUID. */
> >  bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
> >  	       u32 *ecx, u32 *edx, bool check_limit)
> >  {
> >-	u32 function = *eax, index = *ecx;
> >+	const u32 function = *eax, index = *ecx;
> >  	struct kvm_cpuid_entry2 *entry;
> >-	struct kvm_cpuid_entry2 *max;
> >  	bool found;
> >  	entry = kvm_find_cpuid_entry(vcpu, function, index);
> >@@ -1015,18 +1015,17 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
> >  	 */
> >  	if (!entry && check_limit && !guest_cpuid_is_amd(vcpu) &&
> >  	    !cpuid_function_in_range(vcpu, function)) {
> >-		max = kvm_find_cpuid_entry(vcpu, 0, 0);
> >-		if (max) {
> >-			function = max->eax;
> >-			entry = kvm_find_cpuid_entry(vcpu, function, index);
> >-		}
> >+		entry = kvm_find_cpuid_entry(vcpu, 0, 0);
> >+		if (entry)
> >+			entry = kvm_find_cpuid_entry(vcpu, entry->eax, index);
> >  	}
> >  	if (entry) {
> >  		*eax = entry->eax;
> >  		*ebx = entry->ebx;
> >  		*ecx = entry->ecx;
> >  		*edx = entry->edx;
> >-		if (function == 7 && index == 0) {
> >+
> >+		if (entry->function == 7 && index == 0) {
> >  			u64 data;
> >  		        if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
> >  			    (data & TSX_CTRL_CPUID_CLEAR))
> >
> 
> What about the !entry case below this? It was impacted by the function
> capping so far, not it's no longer.

Hmm, the only way the output would be different is in a really contrived
scenario where userspace doesn't provide an entry for the max basic leaf.

The !entry path can only be reached with "orig_function != function" if
orig_function is out of range and there is no entry for the max basic leaf.
The adjustments for 0xb/0x1f require the max basic leaf to be 0xb or 0x1f,
and to take effect with !entry would require there to be a CPUID.max.1 but
not a CPUID.max.0.  That'd be a violation of Intel's SDM, i.e. it's bogus
userspace input and IMO can be ignored.
