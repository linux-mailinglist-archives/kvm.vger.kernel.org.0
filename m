Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF056CCFAA
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 03:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjC2By4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 21:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjC2Byz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 21:54:55 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00287E2
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 18:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680054894; x=1711590894;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=cIDENw9BmM++FLioBS1zT4PE310wgCBue2Uc+pRuiyo=;
  b=m4Y7Snfm30FRKazrJpkWG4uLPPdmYeucQcAJ+819dxMZmxzDxsv/UTcI
   w+gbDZpTpyjnjZeT6gvI/WIjMrnNyGcRgaKtu2f0rW6HZEOezz3+PtXqV
   BA3MMeIm/xLp3b1XUhylsK4fm3x+f6YZSsPYZPbY8eaDWXVmpwDU1d/OA
   stoEFGV4qhLWy1cxaXQe69JzFoAZZ96S13PxdxtOaXrdOg2XOpWXONNZs
   /NxY61LmnFYmqQl04godmqTnAW93ym8TIenHoLwEFWA+vxK261KVQfuvA
   YG540GV4GgSbCM0Y8dIfcWyHLA4VK40T6Q3FtIB1Yzmzt0Wv5WsjyY2tl
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="321146383"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="321146383"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 18:54:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="748615266"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="748615266"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.2.227]) ([10.238.2.227])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 18:54:53 -0700
Message-ID: <84be43ab-6ced-a19f-1081-9444faf81e6e@linux.intel.com>
Date:   Wed, 29 Mar 2023 09:54:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v6 5/7] KVM: x86: Introduce untag_addr() in kvm_x86_ops
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     seanjc@google.com
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        Chao Gao <chao.gao@intel.com>, robert.hu@linux.intel.com
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
 <20230319084927.29607-6-binbin.wu@linux.intel.com> <ZBhMfRoAujRSmaRp@gao-cwp>
 <cad303af-3ab5-4cb7-7b50-430d37b6270e@linux.intel.com>
In-Reply-To: <cad303af-3ab5-4cb7-7b50-430d37b6270e@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/20/2023 8:23 PM, Binbin Wu wrote:
>
> On 3/20/2023 8:07 PM, Chao Gao wrote:
>> On Sun, Mar 19, 2023 at 04:49:25PM +0800, Binbin Wu wrote:
>>> Introduce a new interface untag_addr() to kvm_x86_ops to untag the 
>>> metadata
>> >from linear address. Implement LAM version in VMX and dummy version 
>> in SVM.
>>> When enabled feature like Intel Linear Address Masking or AMD Upper
>>> Address Ignore, linear address may be tagged with metadata. Linear
>>> address should be checked for modified canonicality and untagged in
>>> instrution emulations or vmexit handlings if LAM or UAI is applicable.
>>>
>>> Introduce untag_addr() to kvm_x86_ops to hide the code related to 
>>> vendor
>>> specific details.
>>> - For VMX, LAM version is implemented.
>>>   LAM has a modified canonical check when applicable:
>>>   * LAM_S48                : [ 1 ][ metadata ][ 1 ]
>>>                                63               47
>>>   * LAM_U48                : [ 0 ][ metadata ][ 0 ]
>>>                                63               47
>>>   * LAM_S57                : [ 1 ][ metadata ][ 1 ]
>>>                                63               56
>>>   * LAM_U57 + 5-lvl paging : [ 0 ][ metadata ][ 0 ]
>>>                                63               56
>>>   * LAM_U57 + 4-lvl paging : [ 0 ][ metadata ][ 0...0 ]
>>>                                63               56..47
>>>   If LAM is applicable to certain address, untag the metadata bits and
>>>   replace them with the value of bit 47 (LAM48) or bit 56 (LAM57). 
>>> Later
>>>   the untagged address will do legacy canonical check. So that LAM 
>>> canonical
>>>   check and mask can be covered by "untag + legacy canonical check".
>>>
>>>   For cases LAM is not applicable, 'flags' is passed to the interface
>>>   to skip untag.
>>>
>>> - For SVM, add a dummy version to do nothing, but return the original
>>>   address.
>>>
>>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>>> ---
>>> arch/x86/include/asm/kvm-x86-ops.h |  1 +
>>> arch/x86/include/asm/kvm_host.h    |  5 +++
>>> arch/x86/kvm/svm/svm.c             |  7 ++++
>>> arch/x86/kvm/vmx/vmx.c             | 60 ++++++++++++++++++++++++++++++
>>> arch/x86/kvm/vmx/vmx.h             |  2 +
>>> 5 files changed, 75 insertions(+)
>>>
>>> diff --git a/arch/x86/include/asm/kvm-x86-ops.h 
>>> b/arch/x86/include/asm/kvm-x86-ops.h
>>> index 8dc345cc6318..7d63d1b942ac 100644
>>> --- a/arch/x86/include/asm/kvm-x86-ops.h
>>> +++ b/arch/x86/include/asm/kvm-x86-ops.h
>>> @@ -52,6 +52,7 @@ KVM_X86_OP(cache_reg)
>>> KVM_X86_OP(get_rflags)
>>> KVM_X86_OP(set_rflags)
>>> KVM_X86_OP(get_if_flag)
>>> +KVM_X86_OP(untag_addr)
>> Suppose AMD doesn't/won't use CR4.LAM_SUP and CR3.LAM_U48/U57 for other
>> purposes, it is fine to use a common x86 function to perform LAM masking
>> for pointers. It won't do anything harmful on AMD parts because those
>> enabling bits shouldn't be set and then no bits will be masked out by
>> the common x86 function.
>>
>> Probably we can defer the introduction of the hook to when the
>> assumption becomes wrong.
>
> Another reason I introduced the hook is I noticed the AMD Upper 
> Address Ignore using [63:57] as metadata.
> So the untag implementaion will be differnet. But indeed, it also will 
> be a future issue.
>
> Let's hear more opinions from others, if more guys think the hook is 
> unnecessary for now, I can switch back to
> a common x86 function.

Hi Sean,

What's your opinion? Do you think it is too early to introduce the hook?



>
>
