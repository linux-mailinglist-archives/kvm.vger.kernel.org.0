Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527CE6EFFEE
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 05:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242937AbjD0Dq0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 23:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242825AbjD0DqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 23:46:16 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5E0420E;
        Wed, 26 Apr 2023 20:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682567175; x=1714103175;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vxDIREfs/gWOTr6RZRuTNYwYFcISY67IkdEr84O8tCQ=;
  b=TC3r27VlFwBaIBn/KKWGomfmiSTab+7ZVyMkCtakCeVYs8JbChUoRA8/
   VS6+unOVz0gcWFHm4picxktevtKE3vjC2kuHqYCaQhbq+S4hClzzyFn1v
   7+H2jQXK5Tmo3SMTvywLibMX0vFSZYV1KE/rnlz0pXkrX0OyBFNH4iwmY
   VL2fH34Q0tRl221wtyIg2eYe55XyiWt09Uvyose26PVmcUKm66S626pl8
   lpcTZiqrEJbmHryhyRSVEp+bxQjRE0xj/zxb69f2PtcHpgbMfldvfvSGJ
   949paqPTWQA3V+Oe0iqCvic4/7dMSBSJGGRf8c+qS8PU+8yojlzFRhjbk
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="326916673"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="326916673"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 20:46:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="726856647"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="726856647"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.34]) ([10.238.10.34])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 20:46:12 -0700
Message-ID: <a46895fa-3ffa-e2d8-2841-625a1f791ece@linux.intel.com>
Date:   Thu, 27 Apr 2023 11:46:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 09/21] KVM:x86: Load guest FPU state when accessing
 xsaves-managed MSRs
To:     Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com,
        pbonzini@redhat.com, peterz@infradead.org, john.allen@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
 <20230421134615.62539-10-weijiang.yang@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230421134615.62539-10-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/21/2023 9:46 PM, Yang Weijiang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Load the guest's FPU state if userspace is accessing MSRs whose values are
> managed by XSAVES so that the MSR helpers, e.g. kvm_{get,set}_xsave_msr(),
So far, kvm_{get,set}_xsave_msr() is not introduced yet.
IMO, it is a bit confusing to understand the whole picture without the 
following patches.
May be add some description or adjust the order?


> can simply do {RD,WR}MSR to access the guest's value.
>
> If new feature MSRs supported in XSS are passed through to the guest they
> are saved and restored by XSAVES/XRSTORS, i.e. in the guest's FPU state.
>
> Because is also used for the KVM_GET_MSRS device ioctl(), explicitly check
> @vcpu is non-null before attempting to load guest state. The XSS supporting
> MSRs cannot be retrieved via the device ioctl() without loading guest FPU
> state (which doesn't exist).
>
> Note that guest_cpuid_has() is not queried as host userspace is allowed
> to access MSRs that have not been exposed to the guest, e.g. it might do
> KVM_SET_MSRS prior to KVM_SET_CPUID2.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   arch/x86/kvm/x86.c | 29 ++++++++++++++++++++++++++++-
>   1 file changed, 28 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d2975ca96ac5..7788646bbf1f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -130,6 +130,9 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
>   static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
>   
>   static DEFINE_MUTEX(vendor_module_lock);
> +static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
> +static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
> +
>   struct kvm_x86_ops kvm_x86_ops __read_mostly;
>   
>   #define KVM_X86_OP(func)					     \
> @@ -4336,6 +4339,21 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   }
>   EXPORT_SYMBOL_GPL(kvm_get_msr_common);
>   
> +static const u32 xsave_msrs[] = {
> +	MSR_IA32_U_CET, MSR_IA32_PL3_SSP,
> +};
> +
> +static bool is_xsaves_msr(u32 index)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(xsave_msrs); i++) {
> +		if (index == xsave_msrs[i])
> +			return true;
> +	}
> +	return false;
> +}
> +
>   /*
>    * Read or write a bunch of msrs. All parameters are kernel addresses.
>    *
> @@ -4346,11 +4364,20 @@ static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
>   		    int (*do_msr)(struct kvm_vcpu *vcpu,
>   				  unsigned index, u64 *data))
>   {
> +	bool fpu_loaded = false;
>   	int i;
>   
> -	for (i = 0; i < msrs->nmsrs; ++i)
> +	for (i = 0; i < msrs->nmsrs; ++i) {
> +		if (vcpu && !fpu_loaded && kvm_caps.supported_xss &&
> +		    is_xsaves_msr(entries[i].index)) {
> +			kvm_load_guest_fpu(vcpu);
> +			fpu_loaded = true;
> +		}
>   		if (do_msr(vcpu, entries[i].index, &entries[i].data))
>   			break;
> +	}
> +	if (fpu_loaded)
> +		kvm_put_guest_fpu(vcpu);
>   
>   	return i;
>   }

