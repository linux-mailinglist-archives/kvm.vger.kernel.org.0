Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C5F75BC36
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 04:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjGUCUe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 22:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjGUCUc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 22:20:32 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F171BF2;
        Thu, 20 Jul 2023 19:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689906032; x=1721442032;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xjnZ1gNKtVVKcPTy1GRW7ysr4fcFsCTCJgh8HDtapCA=;
  b=lmVko9DEKNmGJzw2w30S233e8aDEmu/7Ylf/7lfnvT24cFv3xSDxbtjW
   w9nSTJBO+GSaxbJADTqgK2B5RHp6/sMCwtnaMFKklFB4eyGERgSVUETiR
   BBakOfGV8nwn2hNAXDHppQ+r7gTh2bd4bedlTKXbpMXBDmPY/M5EBbFvT
   DG6sZmm/BLyfSwEg0WReLXkJMHbtPHElCfY+/la3/6dHX3+ciDqOw3K1z
   j7qEQZzPtZGNOvWQiYFf0Y60YDqCUZ/TeQsdcP5aSH+VK4KAvTfOoz8vk
   +aiMX/cbbSWYrv5M4IU9bA5Ul0Lth5F6not/9RuB0v+sbv8R2Zkk6QDGg
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="347218891"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="347218891"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 19:20:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="1055406786"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="1055406786"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.9.27]) ([10.238.9.27])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 19:20:29 -0700
Message-ID: <e84129b1-603b-a6c4-ade5-8cf529929675@linux.intel.com>
Date:   Fri, 21 Jul 2023 10:20:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 2/9] KVM: x86: Add & use kvm_vcpu_is_legal_cr3() to
 check CR3's legality
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
 <20230719144131.29052-3-binbin.wu@linux.intel.com>
 <20230720235352.GH25699@ls.amr.corp.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230720235352.GH25699@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/21/2023 7:53 AM, Isaku Yamahata wrote:
> On Wed, Jul 19, 2023 at 10:41:24PM +0800,
> Binbin Wu <binbin.wu@linux.intel.com> wrote:
>
>> Add and use kvm_vcpu_is_legal_cr3() to check CR3's legality to provide
>> a clear distinction b/t CR3 and GPA checks. So that kvm_vcpu_is_legal_cr3()
>> can be adjusted according to new feature(s).
>>
>> No functional change intended.
>>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> ---
>>   arch/x86/kvm/cpuid.h      | 5 +++++
>>   arch/x86/kvm/svm/nested.c | 4 ++--
>>   arch/x86/kvm/vmx/nested.c | 4 ++--
>>   arch/x86/kvm/x86.c        | 4 ++--
>>   4 files changed, 11 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
>> index f61a2106ba90..8b26d946f3e3 100644
>> --- a/arch/x86/kvm/cpuid.h
>> +++ b/arch/x86/kvm/cpuid.h
>> @@ -283,4 +283,9 @@ static __always_inline bool guest_can_use(struct kvm_vcpu *vcpu,
>>   	return vcpu->arch.governed_features.enabled & kvm_governed_feature_bit(x86_feature);
>>   }
>>   
>> +static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>> +{
>> +	return kvm_vcpu_is_legal_gpa(vcpu, cr3);
>> +}
>> +
> The remaining user of kvm_vcpu_is_illegal_gpa() is one left.  Can we remove it
> by replacing !kvm_vcpu_is_legal_gpa()?

There are still two callsites of kvm_vcpu_is_illegal_gpa() left (basing 
on Linux 6.5-rc2), in handle_ept_violation() and nested_vmx_check_eptp().
But they could be replaced by !kvm_vcpu_is_legal_gpa() and then remove 
kvm_vcpu_is_illegal_gpa().
I am neutral to this.


