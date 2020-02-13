Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9EF915C988
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 18:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgBMRhS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 12:37:18 -0500
Received: from mga05.intel.com ([192.55.52.43]:45921 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728186AbgBMRhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 12:37:18 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Feb 2020 09:37:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,437,1574150400"; 
   d="scan'208";a="227305266"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 13 Feb 2020 09:37:17 -0800
Date:   Thu, 13 Feb 2020 09:37:17 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 30/61] KVM: x86: Handle MPX CPUID adjustment in VMX code
Message-ID: <20200213173717.GB18610@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-31-sean.j.christopherson@intel.com>
 <4ff69a7e-acdb-40fd-d717-3b2829f20154@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ff69a7e-acdb-40fd-d717-3b2829f20154@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 13, 2020 at 09:51:08PM +0800, Xiaoyao Li wrote:
> On 2/2/2020 2:51 AM, Sean Christopherson wrote:
> >Move the MPX CPUID adjustments into VMX to eliminate an instance of the
> >undesirable "unsigned f_* = *_supported ? F(*) : 0" pattern in the
> >common CPUID handling code.
> >
> >Note, VMX must manually check for kernel support via
> >boot_cpu_has(X86_FEATURE_MPX).
> 
> Why must?

do_cpuid_7_mask() runs the CPUID result through cpuid_mask(), which masks
features based on boot_cpu_data, i.e. clears bits for features that are
supported by hardware but unsupported/disabled by the kernel.

vmx_set_supported_cpuid() needs to to query boot_cpu_has() to preserve the
"supported by kernel" check provided by cpuid_mask().

> 
> >No functional change intended.
> >
> >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >---
> >  arch/x86/kvm/cpuid.c   |  3 +--
> >  arch/x86/kvm/vmx/vmx.c | 14 ++++++++++++--
> >  2 files changed, 13 insertions(+), 4 deletions(-)
> >
> >diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> >index cb5870a323cc..09e24d1d731c 100644
> >--- a/arch/x86/kvm/cpuid.c
> >+++ b/arch/x86/kvm/cpuid.c
> >@@ -340,7 +340,6 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
> >  static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
> >  {
> >  	unsigned f_invpcid = kvm_x86_ops->invpcid_supported() ? F(INVPCID) : 0;
> >-	unsigned f_mpx = kvm_mpx_supported() ? F(MPX) : 0;
> >  	unsigned f_umip = kvm_x86_ops->umip_emulated() ? F(UMIP) : 0;
> >  	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
> >  	unsigned f_la57;
> >@@ -349,7 +348,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
> >  	/* cpuid 7.0.ebx */
> >  	const u32 kvm_cpuid_7_0_ebx_x86_features =
> >  		F(FSGSBASE) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
> >-		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | f_mpx | F(RDSEED) |
> >+		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | 0 /*MPX*/ | F(RDSEED) |
> >  		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
> >  		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
> >  		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt;
> >diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >index 3ff830e2258e..143193fc178e 100644
> >--- a/arch/x86/kvm/vmx/vmx.c
> >+++ b/arch/x86/kvm/vmx/vmx.c
> >@@ -7106,8 +7106,18 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
> >  static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
> >  {
> >-	if (entry->function == 1 && nested)
> >-		entry->ecx |= feature_bit(VMX);
> >+	switch (entry->function) {
> >+	case 0x1:
> >+		if (nested)
> >+			cpuid_entry_set(entry, X86_FEATURE_VMX);
> >+		break;
> >+	case 0x7:
> >+		if (boot_cpu_has(X86_FEATURE_MPX) && kvm_mpx_supported())
> >+			cpuid_entry_set(entry, X86_FEATURE_MPX);
> >+		break;
> >+	default:
> >+		break;
> >+	}
> >  }
> >  static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
> >
> 
