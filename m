Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF846EA533
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 09:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbjDUHtJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 03:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbjDUHtG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 03:49:06 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30919729F
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 00:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682063335; x=1713599335;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=iNYJWnceu0vWkPjXjGDXztlU7z56HGDbJs2nJW/hu1w=;
  b=eXOH18U33E1MSPPeTQdiyBzNf0Q+tJwkTAkgvlC2BhjShhvAM3/ooqbT
   LczcCP62sDeDriXmkPx8esn2kxy8yQgCCtbWcwY6fRLB/3w7CpIMDLTlA
   n178VShSjpJ+k1u8I2a23EqkYozeAiK9ku1sQLvVy72T/FgrTWGSxsen/
   n4OQyqlHFbm18Efbl2V958Eie8nDkEdDW6NepW9QqyQ6eeVUZgIrjjIvX
   gG2mz92SpTA7ePae+xvy5KoO5uapje1+KE5MknC0stHLbE6qTDyCwH8oq
   9aY0FMSNrt74fpRhxv/COoE5f7XJYQgrSefmKZ2DyzQRDwESgBC2P1Sqa
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="330137363"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="330137363"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 00:48:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="756819002"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="756819002"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.214.158]) ([10.254.214.158])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 00:48:52 -0700
Message-ID: <22bd3eb6-a3a1-be75-925b-6f50b210a30f@linux.intel.com>
Date:   Fri, 21 Apr 2023 15:48:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 3/5] KVM: x86: Introduce untag_addr() in kvm_x86_ops
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        kai.huang@intel.com, xuelian.guo@intel.com,
        robert.hu@linux.intel.com
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
 <20230404130923.27749-4-binbin.wu@linux.intel.com>
 <ZD9SMgA2h8XUXsBw@chao-env>
 <e572c85a-02d8-9547-f1a5-f986aa6b4e14@linux.intel.com>
In-Reply-To: <e572c85a-02d8-9547-f1a5-f986aa6b4e14@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/19/2023 11:08 AM, Binbin Wu wrote:
>
> On 4/19/2023 10:30 AM, Chao Gao wrote:
>> On Tue, Apr 04, 2023 at 09:09:21PM +0800, Binbin Wu wrote:
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
>> The "flags" can be dropped. Callers can simply skip the call of 
>> .untag_addr().
>
> OK.
>
> The "flags" was added for proof of future if such kind of untag is 
> also adopted in svm for AMD.
>
> The cases to skip untag are different on the two vendor platforms.
>
> But still, it is able to get the information in __linearize(), I will 
> drop the parameter.

Have a second thought, the flags is still needed to pass to vmx/svm.

If both implementions set the skip untag flag (SKIP_UNTAG_VMX | 
SKIP_UNTAG_SVM)
or neither sets the skip untag flag,  __linearize() can decide to call 
.untag_addr() or not.

However, in some case, if only one of the implementation need to set the 
skip untag for itself,
in __linearize(), there is no enough information to tell whether to skip 
the untag or not.


>
>
>
>>
>>> - For SVM, add a dummy version to do nothing, but return the original
>>>   address.
>>>
>>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>>> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>>> --- 
[...]
