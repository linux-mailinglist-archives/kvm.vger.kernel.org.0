Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1FF4BEA9E
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 04:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389755AbfIZCah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 22:30:37 -0400
Received: from mga05.intel.com ([192.55.52.43]:49671 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733043AbfIZCah (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 22:30:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 19:30:36 -0700
X-IronPort-AV: E=Sophos;i="5.64,550,1559545200"; 
   d="scan'208";a="183469729"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 25 Sep 2019 19:30:35 -0700
Subject: Re: [PATCH 2/2] kvm: x86: Use AMD CPUID semantics for AMD vCPUs
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Marc Orr <marcorr@google.com>, Peter Shier <pshier@google.com>,
        Jacob Xu <jacobhxu@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20190926000418.115956-1-jmattson@google.com>
 <20190926000418.115956-2-jmattson@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <79a9e68d-808b-2975-ab78-43e0ae00bd1b@intel.com>
Date:   Thu, 26 Sep 2019 10:30:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190926000418.115956-2-jmattson@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/26/2019 8:04 AM, Jim Mattson wrote:
> When the guest CPUID information represents an AMD vCPU, return all
> zeroes for queries of undefined CPUID leaves, whether or not they are
> in range.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Fixes: bd22f5cfcfe8f6 ("KVM: move and fix substitue search for missing CPUID entries")
> Reviewed-by: Marc Orr <marcorr@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Jacob Xu <jacobhxu@google.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/cpuid.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 35e2f930a4b79..0377d2820a7aa 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -988,9 +988,11 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>   	/*
>   	 * Intel CPUID semantics treats any query for an out-of-range
>   	 * leaf as if the highest basic leaf (i.e. CPUID.0H:EAX) were
> -	 * requested.
> +	 * requested. AMD CPUID semantics returns all zeroes for any
> +	 * undefined leaf, whether or not the leaf is in range.
>   	 */
> -	if (!entry && check_limit && !cpuid_function_in_range(vcpu, function)) {
> +	if (!entry && check_limit && !guest_cpuid_is_amd(vcpu) &&
> +	    !cpuid_function_in_range(vcpu, function)) {

IIUC, the parameter check_limit is to indicate whether return highest 
basic leaf when out-of-range. Here you just makes check_limit meaningless.

Maybe we can do like this to use check_limit reasonably：

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0377d2820a7a..e6a61f3f6c0c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1035,7 +1035,8 @@ int kvm_emulate_cpuid(struct kvm_vcpu *vcpu)

         eax = kvm_rax_read(vcpu);
         ecx = kvm_rcx_read(vcpu);
-       kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, true);
+       kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx,
+                       guest_cpuid_is_amd(vcpu) ? false: true);
         kvm_rax_write(vcpu, eax);
         kvm_rbx_write(vcpu, ebx);
         kvm_rcx_write(vcpu, ecx);

>   		max = kvm_find_cpuid_entry(vcpu, 0, 0);
>   		if (max) {
>   			function = max->eax;
> 
