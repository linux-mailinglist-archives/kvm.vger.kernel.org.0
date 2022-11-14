Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80782627671
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 08:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235416AbiKNHge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 02:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiKNHgd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 02:36:33 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31DB95B0;
        Sun, 13 Nov 2022 23:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668411392; x=1699947392;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iwseW+ufoMzA9Lw682rdq9CJ9jtdE8JEhKRFHlYDiow=;
  b=Cyofp+qBzT036jX0LuA0lD/yGKfAiV6O+2W74t5+6jgCfjwfyvi+ea7b
   Pdawh0zccavGfrzFA4/ZKz3Lde5mV8em4IqYA5FYZD1wvxqhkcOJWN8Sg
   t7kYipiKmkA0V61SyizbNeRAypwJkTAb3xSRKHEoBDF56C9WWNDuOKvo3
   NFXb7cohOk69m6Zmuh1v0/7CXF+cWb/f62QgNY6S3iOmM5oPy3sI8iPzz
   rfg/M7JbYxpGneaH5/t4RB16SWIZ6fE5ABDHurIZLG/T+IXaV5cu7BLl2
   jvtKHYPosQObu7lBKpbcONqnRJtmm7TdNY7VauDgzhBbjBpz/CjiB37X8
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="338688468"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="338688468"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2022 23:36:32 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="669537840"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="669537840"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.173.21]) ([10.249.173.21])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2022 23:36:29 -0800
Message-ID: <8584a9c7-0ec1-db36-bb32-d508a091ea09@linux.intel.com>
Date:   Mon, 14 Nov 2022 15:36:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v10 071/108] KVM: x86: Allow to update cached values in
 kvm_user_return_msrs w/o wrmsr
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Chao Gao <chao.gao@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <238ab2d9a9d2ea71ecacb25203b91abbaf6fbcb4.1667110240.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <238ab2d9a9d2ea71ecacb25203b91abbaf6fbcb4.1667110240.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/30/2022 2:23 PM, isaku.yamahata@intel.com wrote:
> From: Chao Gao <chao.gao@intel.com>
>
> Several MSRs are constant and only used in userspace(ring 3).  But VMs may
> have different values.  KVM uses kvm_set_user_return_msr() to switch to
> guest's values and leverages user return notifier to restore them when the
> kernel is to return to userspace.  To eliminate unnecessary wrmsr, KVM also
> caches the value it wrote to an MSR last time.
>
> TDX module unconditionally resets some of these MSRs to architectural INIT
> state on TD exit.  It makes the cached values in kvm_user_return_msrs are
> inconsistent with values in hardware.  This inconsistency needs to be
> fixed.  Otherwise, it may mislead kvm_on_user_return() to skip restoring
> some MSRs to the host's values.  kvm_set_user_return_msr() can help correct
> this case, but it is not optimal as it always does a wrmsr.  So, introduce
> a variation of kvm_set_user_return_msr() to update cached values and skip
> that wrmsr.
>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/x86.c              | 26 +++++++++++++++++++++-----
>   2 files changed, 22 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b225cdfac4bc..fdb00d96e954 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2082,6 +2082,7 @@ int kvm_add_user_return_msr(u32 msr);
>   int kvm_find_user_return_msr(u32 msr);
>   void kvm_user_return_msr_init_cpu(void);
>   int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
> +void kvm_user_return_update_cache(unsigned int index, u64 val);
>   
>   static inline bool kvm_is_supported_user_return_msr(u32 msr)
>   {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 65541bfebb37..4d4b71c4cdb1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -440,6 +440,15 @@ void kvm_user_return_msr_init_cpu(void)
>   }
>   EXPORT_SYMBOL_GPL(kvm_user_return_msr_init_cpu);
>   
> +static void kvm_user_return_register_notifier(struct kvm_user_return_msrs *msrs)
> +{
> +	if (!msrs->registered) {
> +		msrs->urn.on_user_return = kvm_on_user_return;
> +		user_return_notifier_register(&msrs->urn);
> +		msrs->registered = true;
> +	}
> +}
> +
>   int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
>   {
>   	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
> @@ -455,15 +464,22 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
>   		return 1;
>   
>   	msrs->values[slot].curr = value;
> -	if (!msrs->registered) {
> -		msrs->urn.on_user_return = kvm_on_user_return;
> -		user_return_notifier_register(&msrs->urn);
> -		msrs->registered = true;
> -	}
> +	kvm_user_return_register_notifier(msrs);
>   	return 0;
>   }
>   EXPORT_SYMBOL_GPL(kvm_set_user_return_msr);
>   
> +/* Update the cache, "curr", and register the notifier */
> +void kvm_user_return_update_cache(unsigned int slot, u64 value)
> +{
> +	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
> +
> +	WARN_ON_ONCE(!msrs->initialized);
> +	msrs->values[slot].curr = value;

If the value is the same as the cached one, can it just skip notifier 
registration?


> +	kvm_user_return_register_notifier(msrs);
> +}
> +EXPORT_SYMBOL_GPL(kvm_user_return_update_cache);
> +
>   static void drop_user_return_notifiers(void)
>   {
>   	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
