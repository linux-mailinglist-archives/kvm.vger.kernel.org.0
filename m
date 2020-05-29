Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4D21E817E
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgE2PSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:18:24 -0400
Received: from mga17.intel.com ([192.55.52.151]:6947 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbgE2PSX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 11:18:23 -0400
IronPort-SDR: 9WrHnicg8QL5vwd73JWnkksS0zy90kcNvx3pfmfCNWYmbjaEXzuYoaW2+Z2BrpL6N8wJa8roWm
 eGnB6RhATeMg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 08:18:23 -0700
IronPort-SDR: OplPGLJByH3Z+2rL2t/q/aOVHNclPfjb0n2yzDOGYfTN2bI+FYBs4xTzC31bMAGIFWVkR1I8v+
 PmZ4bhdaOAgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,449,1583222400"; 
   d="scan'208";a="303152952"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga008.jf.intel.com with ESMTP; 29 May 2020 08:18:22 -0700
Date:   Fri, 29 May 2020 08:18:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 1/2] selftests: kvm: introduce cpu_has_svm() check
Message-ID: <20200529151822.GB520@linux.intel.com>
References: <20200529130407.57176-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529130407.57176-1-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 29, 2020 at 03:04:06PM +0200, Vitaly Kuznetsov wrote:
> More tests may want to check if the CPU is Intel or AMD in
> guest code, separate cpu_has_svm() and put it as static
> inline to svm_util.h.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/include/x86_64/svm_util.h | 10 ++++++++++
>  tools/testing/selftests/kvm/x86_64/state_test.c       |  9 +--------
>  2 files changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
> index cd037917fece..b1057773206a 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
> @@ -35,4 +35,14 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
>  void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa);
>  void nested_svm_check_supported(void);
>  
> +static inline bool cpu_has_svm(void)
> +{
> +	u32 eax = 0x80000001, ecx;
> +
> +	asm volatile("cpuid" :
> +		     "=a" (eax), "=c" (ecx) : "0" (eax) : "ebx", "edx");

	u32 eax, ecx;

	asm("cpuid" : "=a" (eax), "=c" (ecx) : "a" (0x80000001) : "ebx", "edx");

The volatile shouldn't be needed, e.g. no one should be using this purely
for its seralization properties, and I don't see any reason to put the leaf
number into a variable.

Alternatively, adding a proper cpuid framework to processor.h would likely
be useful in the long run.

> +
> +	return ecx & CPUID_SVM;
> +}
> +
