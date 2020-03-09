Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F80B17E9BF
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 21:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgCIULf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 16:11:35 -0400
Received: from mga18.intel.com ([134.134.136.126]:39979 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgCIULf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 16:11:35 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Mar 2020 13:11:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,534,1574150400"; 
   d="scan'208";a="245452962"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 09 Mar 2020 13:11:34 -0700
Date:   Mon, 9 Mar 2020 13:11:34 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v2 00/66] KVM: x86: Introduce KVM cpu caps
Message-ID: <20200309201134.GA10653@linux.intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
 <cd8eae75-b85b-59a9-24ea-c8bde7bd7cee@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd8eae75-b85b-59a9-24ea-c8bde7bd7cee@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 06, 2020 at 09:27:48AM +0100, Paolo Bonzini wrote:
> I put the complete series on the cpu-caps branch of kvm.git.

Looks good, arrived at more or less the same end result when rebasing my
local branch to kvm/queue.  CPUID diff and smoke test on Icelake ran clean.

For supported_xss, would it make sense to handle it purely in common x86
code, e.g. stub in something similar to supported_xcr0?  KVM_SUPPORTED_XSS
would be 0 for now.  I assume whatever XSAVES features are supported will
be "supported" by both VMX and SVM, in the sense that VMX/SVM won't need
to mask off features that can exist on their respective hardware but can't
be exposed to the guest.

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 4dca3579e740..c6e9910d1149 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1371,8 +1371,6 @@ static __init void svm_set_cpu_caps(void)
 {
        kvm_set_cpu_caps();
 
-       supported_xss = 0;
-
        /* CPUID 0x80000001 and 0x8000000A (SVM features) */
        if (nested) {
                kvm_cpu_cap_set(X86_FEATURE_SVM);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8001070b209c..e91a84bb251c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7126,7 +7126,6 @@ static __init void vmx_set_cpu_caps(void)
                kvm_cpu_cap_set(X86_FEATURE_UMIP);
 
        /* CPUID 0xD.1 */
-       supported_xss = 0;
        if (!vmx_xsaves_supported())
                kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 96e897d38a63..29cfe80db4b4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9628,6 +9628,8 @@ int kvm_arch_hardware_setup(void)
 
        if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
                supported_xss = 0;
+       else
+               supported_xss = host_xss & KVM_SUPPORTED_XSS;
 
        cr4_reserved_bits = kvm_host_cr4_reserved_bits(&boot_cpu_data);
