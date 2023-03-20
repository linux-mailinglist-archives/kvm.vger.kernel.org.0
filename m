Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13D36C11CD
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 13:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjCTMXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 08:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjCTMXq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 08:23:46 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F7A1BF7
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 05:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679315024; x=1710851024;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZbUUbSOhc9HpXk3XQ77iyy8ddDl3b4md1ziyXhraqcA=;
  b=n78ef3CU1WY8nFbIm1ZPe2TMohxNALAyxMxo0hwNUeV9K7UqToChOugA
   CFNNOSLZOx5l/9KaVCqvYZTI2ycZTPoT7O7DaYkyRDhQr6T/94OEgGwbf
   AEqjb69Etcw8/fFQE7pPGFvebYoIHib3xm+UfWfSgG01qSdrw1D/J0S+T
   gWvwKSsR8CVySry+BvU/NuPBatAUA6KoywcLLISBNwiMkAYeuhiFBnvZ/
   zKrb5Rh5ITcJE4LitrL5rM8yAVwukQS8bVnh4pEib8az9dMT6PpD1FhIw
   ORFXj71RpgyVNCA0WKvBVIIuTmxufUtd+j1GSNRcPKo7Fr1ISpP38AaWi
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="322487567"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="322487567"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 05:23:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="674372591"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="674372591"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.172.177]) ([10.249.172.177])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 05:23:42 -0700
Message-ID: <cad303af-3ab5-4cb7-7b50-430d37b6270e@linux.intel.com>
Date:   Mon, 20 Mar 2023 20:23:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v6 5/7] KVM: x86: Introduce untag_addr() in kvm_x86_ops
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        robert.hu@linux.intel.com
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
 <20230319084927.29607-6-binbin.wu@linux.intel.com> <ZBhMfRoAujRSmaRp@gao-cwp>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZBhMfRoAujRSmaRp@gao-cwp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/20/2023 8:07 PM, Chao Gao wrote:
> On Sun, Mar 19, 2023 at 04:49:25PM +0800, Binbin Wu wrote:
>> Introduce a new interface untag_addr() to kvm_x86_ops to untag the metadata
> >from linear address. Implement LAM version in VMX and dummy version in SVM.
>> When enabled feature like Intel Linear Address Masking or AMD Upper
>> Address Ignore, linear address may be tagged with metadata. Linear
>> address should be checked for modified canonicality and untagged in
>> instrution emulations or vmexit handlings if LAM or UAI is applicable.
>>
>> Introduce untag_addr() to kvm_x86_ops to hide the code related to vendor
>> specific details.
>> - For VMX, LAM version is implemented.
>>   LAM has a modified canonical check when applicable:
>>   * LAM_S48                : [ 1 ][ metadata ][ 1 ]
>>                                63               47
>>   * LAM_U48                : [ 0 ][ metadata ][ 0 ]
>>                                63               47
>>   * LAM_S57                : [ 1 ][ metadata ][ 1 ]
>>                                63               56
>>   * LAM_U57 + 5-lvl paging : [ 0 ][ metadata ][ 0 ]
>>                                63               56
>>   * LAM_U57 + 4-lvl paging : [ 0 ][ metadata ][ 0...0 ]
>>                                63               56..47
>>   If LAM is applicable to certain address, untag the metadata bits and
>>   replace them with the value of bit 47 (LAM48) or bit 56 (LAM57). Later
>>   the untagged address will do legacy canonical check. So that LAM canonical
>>   check and mask can be covered by "untag + legacy canonical check".
>>
>>   For cases LAM is not applicable, 'flags' is passed to the interface
>>   to skip untag.
>>
>> - For SVM, add a dummy version to do nothing, but return the original
>>   address.
>>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> ---
>> arch/x86/include/asm/kvm-x86-ops.h |  1 +
>> arch/x86/include/asm/kvm_host.h    |  5 +++
>> arch/x86/kvm/svm/svm.c             |  7 ++++
>> arch/x86/kvm/vmx/vmx.c             | 60 ++++++++++++++++++++++++++++++
>> arch/x86/kvm/vmx/vmx.h             |  2 +
>> 5 files changed, 75 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
>> index 8dc345cc6318..7d63d1b942ac 100644
>> --- a/arch/x86/include/asm/kvm-x86-ops.h
>> +++ b/arch/x86/include/asm/kvm-x86-ops.h
>> @@ -52,6 +52,7 @@ KVM_X86_OP(cache_reg)
>> KVM_X86_OP(get_rflags)
>> KVM_X86_OP(set_rflags)
>> KVM_X86_OP(get_if_flag)
>> +KVM_X86_OP(untag_addr)
> Suppose AMD doesn't/won't use CR4.LAM_SUP and CR3.LAM_U48/U57 for other
> purposes, it is fine to use a common x86 function to perform LAM masking
> for pointers. It won't do anything harmful on AMD parts because those
> enabling bits shouldn't be set and then no bits will be masked out by
> the common x86 function.
>
> Probably we can defer the introduction of the hook to when the
> assumption becomes wrong.

Another reason I introduced the hook is I noticed the AMD Upper Address 
Ignore using [63:57] as metadata.
So the untag implementaion will be differnet. But indeed, it also will 
be a future issue.

Let's hear more opinions from others, if more guys think the hook is 
unnecessary for now, I can switch back to
a common x86 function.


