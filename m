Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9900A6A8FEE
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 04:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjCCDfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 22:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCCDfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 22:35:40 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB10342BD2
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 19:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677814539; x=1709350539;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Q5A8v7AZqeI7pjjaqyi6/a1YnC/UikvocwD8KmgtT8g=;
  b=ObMFS1QOZEMyo32ke+S4KiEzxvOSJEznKJfmPpC9bCYzzIlGV0luWMnE
   BTeJax6vNnyAqALWcDahjAftwQoRseN20Y03M90ByRVi2lo4l11DnVGKN
   YT1GZigtzMMKN11yaU7O/J5YV6sHKlyuYp7lvfESOy6Vc6y+MHjpzHB2r
   RxiGfIK9f/n3ywc5tLZOUzNC6uOo05hvQCaFDbE2VJB7zNW9cKVkRoupu
   dP4t2aX1ovO3OHixmJhIMIudeZZZPYM4ZJKZX++qk1268DcNMGh+vAEVK
   W9NfEbakyzHWUxABGGZagMau/vB48XbDwk3TOTtcptXh3f+f9UazjKikB
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="333664057"
X-IronPort-AV: E=Sophos;i="5.98,229,1673942400"; 
   d="scan'208";a="333664057"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 19:35:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="625223625"
X-IronPort-AV: E=Sophos;i="5.98,229,1673942400"; 
   d="scan'208";a="625223625"
Received: from jwu4-mobl.ccr.corp.intel.com (HELO [10.254.215.221]) ([10.254.215.221])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 19:35:37 -0800
Message-ID: <1687b7c1-1c31-2684-7bcf-ca7109038153@linux.intel.com>
Date:   Fri, 3 Mar 2023 11:35:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v5 4/5] KVM: x86: emulation: Apply LAM mask when emulating
 data access in 64-bit mode
To:     Robert Hoo <robert.hu@linux.intel.com>, seanjc@google.com,
        pbonzini@redhat.com, chao.gao@intel.com
Cc:     kvm@vger.kernel.org
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
 <20230227084547.404871-5-robert.hu@linux.intel.com>
 <79b1563b-71e3-3a3d-0812-76cca32fc7b3@linux.intel.com>
 <871716083508732b474ae22b381a58be66889707.camel@linux.intel.com>
 <52e5514d-89f3-f060-71fb-01da3fe81a7a@linux.intel.com>
 <f1714f362630c29e7aeab24dcf75244d7fc41802.camel@linux.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <f1714f362630c29e7aeab24dcf75244d7fc41802.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/3/2023 11:16 AM, Robert Hoo wrote:
> On Fri, 2023-03-03 at 09:08 +0800, Binbin Wu wrote:
>> On 3/2/2023 9:16 PM, Robert Hoo wrote:
>>> On Thu, 2023-03-02 at 14:41 +0800, Binbin Wu wrote:
>>>> __linearize is not the only path the modified LAM canonical check
>>>> needed, also some vmexits path should be taken care of, like VMX,
>>>> SGX
>>>> ENCLS.
>>>>
>>> SGX isn't in this version's implementation's scope, like nested
>>> LAM.
>> LAM in SGX enclave mode is not the scope of the this version.
>> But I think since the capability is exposed to guest,
> I think you can document this or other method to call out this to user.
> Even Kernel enabling doesn't include SGX interaction yet, I doubt if
> it's that urgent for KVM to do this at this phase.
>
>> need to cover the
>> case if the guest use the supervisor mode pointer
> No business with pointer mode here, I think.
>
>>   as the operand of SGX
>> EENCS operations.
>>
>>
>>>> Also the instruction INVLPG, INVPCID should have some special
>>>> handling
>>>> since LAM is not applied to the memory operand of the two
>>>> instruction
>>>> according to the LAM spec.
>>> The spec's meaning on these 2 is: LAM masking doesn't apply to
>>> their
>>> operands (the address), so the behavior is like before LAM feature
>>> introduced. No change.
>> Yes, LAM are not applied to the 2 instrustions, but the __linearize
>> is
>> changed.
>> For example, the emulation of invlpg (em_invpg) will also call it.
>> So
>> need to handle the case specificlly.
>> Can add a flag as the input of linearize to indicate the LAM check
>> and
>> untag is needed or not.
>>
> No need.
>
> "The INVLPG instruction ...
> LAM does not apply to the specified memory address. Thus, in 64-bit
> mode, ** if the memory address specified is in non-canonical form then
> the INVLPG is the same as a NOP. **

Based on current patch, if the address of invlpg is non-canonical, it 
will be first checked and converted by the new LAM handling.
After that, I will be canonical and do the invalidition, but not NOP.
Maybe we can say do an additional TLB invalidation may be no big 
different as NOP, but it need to be documented/comment somewhere


>
> The INVPCID instruction ...
> LAM does not apply to the specified memory address, and in 64-bit
> mode ** if this memory address is in non-canonical form then the
> processor generates a #GP(0) exception. **"
>
> You can double confirm in SDM: Before-and-After LAM introduced, the
> behavior hasn't changed. Thus you don't need to worry about these 2
> INS's emulations.

This is because currently, VMX vmexit handling is not considered yet.
The linear address of guest is retrived from get_vmx_mem_address, which 
is also will be called by INVPCID.

What arguable is that we need to cover all supervisor mode pointer cases 
in this phase.
But IMO if thesel cases are not covered, CR4.LAM_SUP should be not allow 
to be set by guest.

