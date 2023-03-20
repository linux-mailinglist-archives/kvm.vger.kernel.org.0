Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F13B6C115F
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 13:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjCTMAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 08:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbjCTMAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 08:00:13 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83A524723
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 05:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679313609; x=1710849609;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sAiQ6MWvpAsmsjJ6HmDb1yxutyHTZKHVgyUQ0YApyew=;
  b=azCKpB9s1HweTHzXLFtKUEnCM57hGNhCw+LAs+W7Itfo3emIzWGhDrPE
   kOU4lLJAzguBbP21n0mAW96cfZjV3KLWL0u4g1lRvcCH+yG5p829h0y/6
   9+gcKTU1gPVCRwZ8VaGXMePoAwkJRZ/WBupvCw46KtsrCLcQOAmF+Y9FX
   aEPeK5UO0y9Wa6RMfyxHrEYa16hwOTjW/pUDHIqx6tigFALh9bNd0hShO
   q6bIym4xQkzj2s4v3s76AQxp1sG1xKHjZbEZmG08LQ10ue415+DbRuifb
   U83mEU2C8+BJ3aatl5TKtUkVrtr6vEadmhITZAxp3pVP1FFvcsk6nm0Ul
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="327012968"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="327012968"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 05:00:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="713538536"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="713538536"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.172.177]) ([10.249.172.177])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 05:00:07 -0700
Message-ID: <4c2cc4b8-17a2-57d3-1581-0776775335e3@linux.intel.com>
Date:   Mon, 20 Mar 2023 20:00:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v6 7/7] KVM: x86: Expose LAM feature to userspace VMM
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        robert.hu@linux.intel.com, Jingqi Liu <jingqi.liu@intel.com>
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
 <20230319084927.29607-8-binbin.wu@linux.intel.com> <ZBgf6Kj6veld5xkI@gao-cwp>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZBgf6Kj6veld5xkI@gao-cwp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/20/2023 4:57 PM, Chao Gao wrote:
> On Sun, Mar 19, 2023 at 04:49:27PM +0800, Binbin Wu wrote:
>> From: Robert Hoo <robert.hu@linux.intel.com>
>>
>> LAM feature is enumerated by CPUID.7.1:EAX.LAM[bit 26].
>> Expose the feature to guest as the final step after the following
> Nit: s/guest/userspace/. Because it is QEMU that decides whther or not
> to expose a feature to guests.


OK. Will update it and thanks for review-by

>
>> supports:
>> - CR4.LAM_SUP virtualization
>> - CR3.LAM_U48 and CR3.LAM_U57 virtualization
>> - Check and untag 64-bit linear address when LAM applies in instruction
>>   emulations and vmexit handlers.
>>
>> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
>
>> ---
>> arch/x86/kvm/cpuid.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 8f8edeaf8177..13840ef897c7 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -670,7 +670,7 @@ void kvm_set_cpu_caps(void)
>> 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
>> 		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
>> 		F(FZRM) | F(FSRS) | F(FSRC) |
>> -		F(AMX_FP16) | F(AVX_IFMA)
>> +		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
>> 	);
>>
>> 	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
>> -- 
>> 2.25.1
>>
