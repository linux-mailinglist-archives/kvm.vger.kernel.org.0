Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08A56C125E
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 13:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjCTMxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 08:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbjCTMxC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 08:53:02 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE9328847
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 05:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679316717; x=1710852717;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=c8lxFf4B9p5nsYuRB/R07Z+smXEkoc/f26pn9T957tM=;
  b=UUWtXo9t6rONppVpJQmzBSKUsTfBaDUYXY9UAsUq3MxhGyMPDeowRKqP
   s0wsqERiMYauoNo9d2pVr+RgUN1wPiDG2sBFvr96oroNKELqo6ym4vPjZ
   FxwIXPaGcxBHKXBd9Nr/hLn0kpFdUePkADOrEkenDjBOg/y4N6uNmp9fc
   t5Sq+7PxpMbX2af/FbdG9hEN4wsHOOuDPNtwE45s1H5lHyKg94/tTBeSd
   0p91sYxCVatXzbMoBHqJ2Lj5VUhlsO4WVW9VmcogDfg9kX7gIjA1oPa+/
   Yb7CGrF5gvpocuHlscGRHKpSqgr6ACosp95NvSpIVbDojgE4wGNwRNDld
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="336156143"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="336156143"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 05:51:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="824464638"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="824464638"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.172.177]) ([10.249.172.177])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 05:51:02 -0700
Message-ID: <24048497-5c6e-fbdd-c8aa-fef08b832124@linux.intel.com>
Date:   Mon, 20 Mar 2023 20:51:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        robert.hu@linux.intel.com
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
 <20230319084927.29607-3-binbin.wu@linux.intel.com> <ZBhTa6QSGDp2ZkGU@gao-cwp>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZBhTa6QSGDp2ZkGU@gao-cwp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/20/2023 8:36 PM, Chao Gao wrote:
> On Sun, Mar 19, 2023 at 04:49:22PM +0800, Binbin Wu wrote:
>> get_vmx_mem_address() and sgx_get_encls_gva() use is_long_mode()
>> to check 64-bit mode. Should use is_64_bit_mode() instead.
>>
>> Fixes: f9eb4af67c9d ("KVM: nVMX: VMX instructions: add checks for #GP/#SS exceptions")
>> Fixes: 70210c044b4e ("KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions")
> It is better to split this patch into two: one for nested and one for
> SGX.
>
> It is possible that there is a kernel release which has just one of
> above two flawed commits, then this fix patch cannot be applied cleanly
> to the release.


OK.

>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> ---
>> arch/x86/kvm/vmx/nested.c | 2 +-
>> arch/x86/kvm/vmx/sgx.c    | 4 ++--
>> 2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 557b9c468734..0f84cc05f57c 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -4959,7 +4959,7 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
>>
>> 	/* Checks for #GP/#SS exceptions. */
>> 	exn = false;
>> -	if (is_long_mode(vcpu)) {
>> +	if (is_64_bit_mode(vcpu)) {
>> 		/*
>> 		 * The virtual/linear address is never truncated in 64-bit
>> 		 * mode, e.g. a 32-bit address size can yield a 64-bit virtual
>> diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
>> index aa53c98034bf..0574030b071f 100644
>> --- a/arch/x86/kvm/vmx/sgx.c
>> +++ b/arch/x86/kvm/vmx/sgx.c
>> @@ -29,14 +29,14 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
>>
>> 	/* Skip vmcs.GUEST_DS retrieval for 64-bit mode to avoid VMREADs. */
>> 	*gva = offset;
>> -	if (!is_long_mode(vcpu)) {
>> +	if (!is_64_bit_mode(vcpu)) {
>> 		vmx_get_segment(vcpu, &s, VCPU_SREG_DS);
>> 		*gva += s.base;
>> 	}
>>
>> 	if (!IS_ALIGNED(*gva, alignment)) {
>> 		fault = true;
>> -	} else if (likely(is_long_mode(vcpu))) {
>> +	} else if (likely(is_64_bit_mode(vcpu))) {
>> 		fault = is_noncanonical_address(*gva, vcpu);
>> 	} else {
>> 		*gva &= 0xffffffff;
>> -- 
>> 2.25.1
>>
