Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F5A6E57DC
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 05:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbjDRDey (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 23:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjDRDew (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 23:34:52 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C8730C6
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 20:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681788890; x=1713324890;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZVErIPWVXkfc+87kMAvef3hq+Pzk8GOigyDXo30hbX8=;
  b=b7wDcA5wn5lGH7vX40iQM9KlzxtUIfaOsLKaB+fwHxwLVCRu9BVii9E2
   sukvHEvJh6fVJZ7MTA7ymaFk63CMbnwEv9mBmCWoRA8bGb+A/FGSLtrBF
   tque02V5ML7rk14qQ4KhHy+BJQ8+t7qias5Ud7rzyJmii99m4PcHypNCy
   m7Bz9010w6fiND1Z+kcJGZwMOp7VkOmsqPZlrjDDl1N+RFcDryrt8FN03
   txYgeg9aZQ3oqlg122/L6eYdNbBrrXbJ9yXQSl/WYBOgx+rK2Dmvvmj8c
   H9V5Yab/n0FqOfYq5rQ3WEobkwuebNrrz5PcA8FNBtO2ZDE7knnQwT4Av
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="410283680"
X-IronPort-AV: E=Sophos;i="5.99,206,1677571200"; 
   d="scan'208";a="410283680"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 20:34:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="641203404"
X-IronPort-AV: E=Sophos;i="5.99,206,1677571200"; 
   d="scan'208";a="641203404"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.174.28]) ([10.249.174.28])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 20:34:47 -0700
Message-ID: <fa8ccc1a-b85f-8dee-ec22-9003152ea995@linux.intel.com>
Date:   Tue, 18 Apr 2023 11:34:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 3/5] KVM: x86: Introduce untag_addr() in kvm_x86_ops
To:     Zeng Guang <guang.zeng@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Guo, Xuelian" <Xuelian.Guo@intel.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
 <20230404130923.27749-4-binbin.wu@linux.intel.com>
 <d0e57964-0c93-d5da-c95f-bbb33a010961@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <d0e57964-0c93-d5da-c95f-bbb33a010961@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/18/2023 11:08 AM, Zeng Guang wrote:
>
> On 4/4/2023 9:09 PM, Binbin Wu wrote:
>> Introduce a new interface untag_addr() to kvm_x86_ops to untag the 
>> metadata
>> from linear address. Implement LAM version in VMX and dummy version 
>> in SVM.
>>
>> When enabled feature like Intel Linear Address Masking or AMD Upper
>> Address Ignore, linear address may be tagged with metadata. Linear
>> address should be checked for modified canonicality and untagged in
>> instrution emulations or vmexit handlings if LAM or UAI is applicable.
>>
>> Introduce untag_addr() to kvm_x86_ops to hide the code related to vendor
>> specific details.
>> - For VMX, LAM version is implemented.
>>    LAM has a modified canonical check when applicable:
>>    * LAM_S48                : [ 1 ][ metadata ][ 1 ]
>>                                 63               47
>>    * LAM_U48                : [ 0 ][ metadata ][ 0 ]
>>                                 63               47
>>    * LAM_S57                : [ 1 ][ metadata ][ 1 ]
>>                                 63               56
>>    * LAM_U57 + 5-lvl paging : [ 0 ][ metadata ][ 0 ]
>>                                 63               56
>>    * LAM_U57 + 4-lvl paging : [ 0 ][ metadata ][ 0...0 ]
>>                                 63               56..47
>>    If LAM is applicable to certain address, untag the metadata bits and
>>    replace them with the value of bit 47 (LAM48) or bit 56 (LAM57). 
>> Later
>>    the untagged address will do legacy canonical check. So that LAM 
>> canonical
>>    check and mask can be covered by "untag + legacy canonical check".
>>
>>    For cases LAM is not applicable, 'flags' is passed to the interface
>>    to skip untag.
>>
>> - For SVM, add a dummy version to do nothing, but return the original
>>    address.
>>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>> ---
>>   arch/x86/include/asm/kvm-x86-ops.h |  1 +
>>   arch/x86/include/asm/kvm_host.h    |  5 +++
>>   arch/x86/kvm/svm/svm.c             |  7 ++++
>>   arch/x86/kvm/vmx/vmx.c             | 60 ++++++++++++++++++++++++++++++
>>   arch/x86/kvm/vmx/vmx.h             |  2 +
>>   5 files changed, 75 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/kvm-x86-ops.h 
>> b/arch/x86/include/asm/kvm-x86-ops.h
>> index 8dc345cc6318..7d63d1b942ac 100644
>> --- a/arch/x86/include/asm/kvm-x86-ops.h
>> +++ b/arch/x86/include/asm/kvm-x86-ops.h
>> @@ -52,6 +52,7 @@ KVM_X86_OP(cache_reg)
>>   KVM_X86_OP(get_rflags)
>>   KVM_X86_OP(set_rflags)
>>   KVM_X86_OP(get_if_flag)
>> +KVM_X86_OP(untag_addr)
>>   KVM_X86_OP(flush_tlb_all)
>>   KVM_X86_OP(flush_tlb_current)
>>   KVM_X86_OP_OPTIONAL(tlb_remote_flush)
>> diff --git a/arch/x86/include/asm/kvm_host.h 
>> b/arch/x86/include/asm/kvm_host.h
>> index 498d2b5e8dc1..cb674ec826d4 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -69,6 +69,9 @@
>>   #define KVM_X86_NOTIFY_VMEXIT_VALID_BITS 
>> (KVM_X86_NOTIFY_VMEXIT_ENABLED | \
>>                            KVM_X86_NOTIFY_VMEXIT_USER)
>>   +/* flags for kvm_x86_ops::untag_addr() */
>> +#define KVM_X86_UNTAG_ADDR_SKIP_LAM    _BITULL(0)
>> +
>
> Prefer to make definition and comments to be generic.
> How about:
>     /* x86-specific emulation flags */
>     #define KVM_X86_EMULFLAG_SKIP_LAM_UNTAG_ADDR _BITULL(0)

You mean make the flag definitions not dedicated for LAM, but also can 
be used for other features?

AFAIK, LASS may also need to define similar flags for instruction 
emulation and VMExit handling.

For me, I'd like to define it as:

     /* x86-specific emulation flags */
     #define KVM_X86_EMULFLAG_SKIP_LAM    _BITULL(0)

since IMO, SKIP_LAM has described the purpose clearly already.

