Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED426A8E80
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 02:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjCCBJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 20:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjCCBI7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 20:08:59 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0176112877
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 17:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677805738; x=1709341738;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=v4/c86AD4NNpiiIluW1WSJYHJalqbmz8mBIt00RtGtw=;
  b=XEkkiifioF6vaM181TR0IO9ZJlw5M1T9AQhODOMUKe+KHd3UmvXYYdKW
   dKXyyg0les2pYxWtvM94OINNfrreD5T1BaOZpANOnzMc/ahqokARQxoti
   Up22hrSV2hQMFxkmQn/zNP2j72nrtzZ6L4W96/Qo7CZuYQyqX9D4RuW35
   5qQlZtoG7MqGhUj0ezIuhLnSs+IURZKsrM5hVkW1+bYsr3/H03w2pWmIr
   9TJ7oQtOB1CsfQw7MX9Nn09BShTgL0WTJIk7h4t8gxGZ6ZJOtgQ6s0AqI
   bhTz7s2YVu5XgnsKUtEBO02bBuFNuuFtJdEgtW8+ds5SpFR7M6ipWAUB9
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="318734690"
X-IronPort-AV: E=Sophos;i="5.98,229,1673942400"; 
   d="scan'208";a="318734690"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 17:08:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="849296667"
X-IronPort-AV: E=Sophos;i="5.98,229,1673942400"; 
   d="scan'208";a="849296667"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.169.115]) ([10.249.169.115])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 17:08:55 -0800
Message-ID: <52e5514d-89f3-f060-71fb-01da3fe81a7a@linux.intel.com>
Date:   Fri, 3 Mar 2023 09:08:53 +0800
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
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <871716083508732b474ae22b381a58be66889707.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/2/2023 9:16 PM, Robert Hoo wrote:
> On Thu, 2023-03-02 at 14:41 +0800, Binbin Wu wrote:
>> __linearize is not the only path the modified LAM canonical check
>> needed, also some vmexits path should be taken care of, like VMX,
>> SGX
>> ENCLS.
>>
> SGX isn't in this version's implementation's scope, like nested LAM.

LAM in SGX enclave mode is not the scope of the this version.
But I think since the capability is exposed to guest, need to cover the 
case if the guest use the supervisor mode pointer as the operand of SGX 
EENCS operations.


>
>> Also the instruction INVLPG, INVPCID should have some special
>> handling
>> since LAM is not applied to the memory operand of the two
>> instruction
>> according to the LAM spec.
> The spec's meaning on these 2 is: LAM masking doesn't apply to their
> operands (the address), so the behavior is like before LAM feature
> introduced. No change.

Yes, LAM are not applied to the 2 instrustions, but the __linearize is 
changed.
For example, the emulation of invlpg (em_invpg) will also call it. So 
need to handle the case specificlly.
Can add a flag as the input of linearize to indicate the LAM check and 
untag is needed or not.


>>
>>> +#ifdef CONFIG_X86_64
>>> +/*
>>> + * LAM Canonical Rule:
>>> + * LAM_U/S48 -- bit 63 == bit 47
>>> + * LAM_U/S57 -- bit 63 == bit 56
>> The modified LAM canonical check for LAM_U57 + 4-level paging is:
>> bit
>> 63, bit 56:47 should be all 0s.
>>
> Yes, this case was missed. Chao's suggestion on signed-extend + legacy
> canonical check can cover this.
>
