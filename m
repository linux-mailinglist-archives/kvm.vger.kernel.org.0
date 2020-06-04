Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3F81EE770
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 17:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbgFDPMe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 11:12:34 -0400
Received: from mga07.intel.com ([134.134.136.100]:52430 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729170AbgFDPMe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 11:12:34 -0400
IronPort-SDR: frujNjvOChJT6U5SDYK4x32C9NP9iD+6Ya2lsSR7wWJkp8jTfhJalcMvxWYnt9zxTgYyksmQVj
 +JWed1BNQJ/A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 08:12:33 -0700
IronPort-SDR: OajrGnr5CSBpEfskgXPM/GYq0IN+aJoCCDiz+asYCfXVrUIiloBzNwlVPbD0JWRBz0P66bgpQX
 DPJzhp2RvP6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,472,1583222400"; 
   d="scan'208";a="269442517"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 04 Jun 2020 08:12:33 -0700
Date:   Thu, 4 Jun 2020 08:12:33 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     20200604024304.14643-1-xiaoyao.li@intel.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v2] KVM: x86: Assign correct value to array.maxnent
Message-ID: <20200604151233.GC30223@linux.intel.com>
References: <20200604041636.1187-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604041636.1187-1-xiaoyao.li@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 04, 2020 at 12:16:36PM +0800, Xiaoyao Li wrote:
> Delay the assignment of array.maxnent to use correct value for the case
> cpuid->nent > KVM_MAX_CPUID_ENTRIES.
> 
> Fixes: e53c95e8d41e ("KVM: x86: Encapsulate CPUID entries and metadata in struct")
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> v2:
>    - remove "const" of maxnent to fix build error.
> ---
>  arch/x86/kvm/cpuid.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 253b8e875ccd..3d88ddf781d0 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -426,7 +426,7 @@ EXPORT_SYMBOL_GPL(kvm_set_cpu_caps);
>  
>  struct kvm_cpuid_array {
>  	struct kvm_cpuid_entry2 *entries;
> -	const int maxnent;
> +	int maxnent;
>  	int nent;
>  };
>  
> @@ -870,7 +870,6 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>  
>  	struct kvm_cpuid_array array = {
>  		.nent = 0,
> -		.maxnent = cpuid->nent,
>  	};
>  	int r, i;
>  
> @@ -887,6 +886,8 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>  	if (!array.entries)
>  		return -ENOMEM;
>  
> +	array.maxnent = cpuid->nent;

Eh, I'd vote to just do:

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 253b8e875ccd..1e5b1ee75a76 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -870,7 +870,7 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,

        struct kvm_cpuid_array array = {
                .nent = 0,
-               .maxnent = cpuid->nent,
+               .maxnent = min(cpuid->nent, (u32)KVM_MAX_CPUID_ENTRIES),
        };
        int r, i;



> +
>  	for (i = 0; i < ARRAY_SIZE(funcs); i++) {
>  		r = get_cpuid_func(&array, funcs[i], type);
>  		if (r)
> -- 
> 2.18.2
> 
