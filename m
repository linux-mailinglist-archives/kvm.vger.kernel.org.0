Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C181698D2F
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 07:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjBPGiR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 01:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjBPGiO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 01:38:14 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4031474D7
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 22:38:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676529480; x=1708065480;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xuQzp1IB+9HMm6jOwXi4JnslkyQu/xPAdCkXLSBFeFc=;
  b=VUlz1ONKMRVdST26/uTuzp/WMIbaX2rDWuPIapDl3tTf3qH4wKQPvnP0
   54auSQnUv21ROXYE7H1q1Itg9DmjGzO1ag02W9Erh4y8V4SaPOSSgbM3G
   lhTjrBqE6OS3uWHrv6sp8rjxRhYVcgimaq7vsBRlvs7UxyAMa3qpbhHXi
   qAmZWQXrNOQ+1yLNY3OkmNNLsoJfmqNO1TdUcFdk5JIu6ygo/7fEgVIyn
   orWXQ/ZGAHJQmIHVEmG6Ly0om6do8TMbX8nmgP4ApVhDBK4GuKTWIoSCq
   gx9nXwH5DMcYtVTYJ/gVmaQLMfQTmwxQdy770X4YVsZuZPkmYpCJX+82a
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="332962568"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="332962568"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 22:37:58 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="670022689"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="670022689"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.1.250]) ([10.238.1.250])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 22:37:56 -0800
Message-ID: <738f8bb9-83b1-794c-26c5-1d3f17c5618b@linux.intel.com>
Date:   Thu, 16 Feb 2023 14:37:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v4 5/9] KVM: x86: Untag LAM bits when applicable
To:     Robert Hoo <robert.hu@linux.intel.com>,
        Chao Gao <chao.gao@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, isaku.yamahata@intel.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-6-robert.hu@linux.intel.com>
 <Y+ZdFtr1fJkdCtRL@gao-cwp>
 <468be41d91840501db0bb49c4e518a0020e6018f.camel@linux.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <468be41d91840501db0bb49c4e518a0020e6018f.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/11/2023 1:57 PM, Robert Hoo wrote:
> On Fri, 2023-02-10 at 23:04 +0800, Chao Gao wrote:
>
>>> @@ -1809,6 +1809,10 @@ static int __kvm_set_msr(struct kvm_vcpu
>>> *vcpu, u32 index, u64 data,
>>> 	case MSR_KERNEL_GS_BASE:
>>> 	case MSR_CSTAR:
>>> 	case MSR_LSTAR:
>>> +		/*
>>> +		 * The strict canonical checking still applies to MSR
>>> +		 * writing even LAM is enabled.
>>> +		 */
>>> 		if (is_noncanonical_address(data, vcpu))
>> LAM spec says:
>>
>> 	Processors that support LAM continue to require the addresses
>> written to
>> 	control registers or MSRs be 57-bit canonical if the processor
>> supports
>> 	5-level paging or 48-bit canonical if it supports only 4-level
>> paging
>>
>> My understanding is 57-bit canonical checking is performed if the
>> processor
>> __supports__ 5-level paging. Then the is_noncanonical_address() here
>> is
>> arguably wrong. Could you double-confirm and fix it?
>>
> Emm, condition of "support" V.S. "enabled", you mean
> vcpu_virt_addr_bits(), right?
> {
> 	return kvm_read_cr4_bits(vcpu, X86_CR4_LA57) ? 57 : 48;
> }
>
> This is worth double-confirm. Let me check with Yu. Thanks.

I have a check about the definition of canonical address checking in 
Intel SDM.
It says: “In 64-bit mode, an address is considered to be in canonical 
form if address bits 63 through to the most-significant implemented bit 
by the microarchitecture are set to either all ones or all zeros”.
So the processor canonical address checking bit width depends on the 
"support" of 5-level paging, not the "enable status" of it.
And the description is aligned with LAM spec.

The current code for canonical check is not strictly aligned with the 
hardware behavior.
IMHO, the current code can work properly becasue the design of virtual 
memory map of OSes in 4-level paging mode still makes bits 63:47 
identical for canonical addresses (, which is reasonable and necessary 
for back compatibility), after the processor supports 5-level paging .
So for functionality, the current implementation should be OK.

Want to hear more options about whether we need to modify the code to 
strictly align with the hardware behavior.


