Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDFA6EF074
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 10:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240108AbjDZIue (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 04:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjDZIua (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 04:50:30 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1812D74
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 01:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682499025; x=1714035025;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eng2ZmM+LfmbCWSMAf9OmlbBviWTrIqgtyRG/xCDS/c=;
  b=D7j8JKlxI33lJJW2iI+rRRVC3K8MHk+XDMc9Q5lyQ93HLEeeN58E+Srg
   c3lyLPw9s8Dg4+D83XajfRb0P9xcVZqsejIP6hfPIilKholdePKa47wwD
   XUv82D4GF3uxxGDAqVvDzUf4BvfO6SyO8oFYJV0nPr7zOo32/9Nb8Iobd
   0Fg+r+vMsQCxrgqwKEoVhz1pHW9OjfzaND8Dyeu1ZsZa7iXO562Q1BiN7
   tZmsD1VPw3A0tYghLW3SJII53a2A/1TOQV9OORdRQKxDXebPml2KMAzF+
   S80x07/BRhlTjIaLD4TQJ4zI1/4Cnp/9n1Qs0+4bU1AkqI06F8hgsCuXk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="326654331"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="326654331"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 01:50:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="783230097"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="783230097"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.3.89]) ([10.238.3.89])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 01:50:23 -0700
Message-ID: <88bd8592-b815-35bf-dd28-ef7615754dab@linux.intel.com>
Date:   Wed, 26 Apr 2023 16:50:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
To:     "Huang, Kai" <kai.huang@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Guo, Xuelian" <xuelian.guo@intel.com>
References: <20230404130923.27749-3-binbin.wu@linux.intel.com>
 <9c99eceaddccbcd72c5108f72609d0f995a0606c.camel@intel.com>
 <497514ed-db46-16b9-ca66-04985a687f2b@linux.intel.com>
 <7b296e6686bba77f81d1d8c9eaceb84bd0ef0338.camel@intel.com>
 <cc265df1-d4fc-0eb7-f6e8-494e98ece2d9@linux.intel.com>
 <BL1PR11MB5978D1FA3B572A119F5EF3A9F7989@BL1PR11MB5978.namprd11.prod.outlook.com>
 <5e229834-3e55-a580-d9f6-a5ffe971c567@linux.intel.com>
 <7895c517a84300f903cb04fbf2f05c4b8e518c91.camel@intel.com>
 <612345f3-74b8-d4bc-b87d-d74c8d0aedd1@linux.intel.com>
 <14e019dff4537cfcffe522750a10778b4e0f1690.camel@intel.com>
 <ZEiU5Rln4uztr1bz@chao-email>
 <27c77030-58f4-61be-81b0-f3cc7c084b9f@linux.intel.com>
 <aee97e18098f069c34f40c4ead0f548bed28bda2.camel@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <aee97e18098f069c34f40c4ead0f548bed28bda2.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/26/2023 4:44 PM, Huang, Kai wrote:
> On Wed, 2023-04-26 at 13:13 +0800, Binbin Wu wrote:
>> On 4/26/2023 11:05 AM, Chao Gao wrote:
>>> On Wed, Apr 26, 2023 at 06:48:21AM +0800, Huang, Kai wrote:
>>>> ... when EPT is on, as you mentioned guest can update CR3 w/o causing VMEXIT to
>>>> KVM.
>>>>
>>>> Is there any global enabling bit in any of CR to turn on/off LAM globally?  It
>>>> seems there isn't because AFAICT the bits in CR4 are used to control super mode
>>>> linear address but not LAM in global?
>>> Right.
>>>
>>>> So if it is true, then it appears hardware depends on CPUID purely to decide
>>>> whether to perform LAM or not.
>>>>
>>>> Which means, IIRC, when EPT is on, if we don't expose LAM to the guest on the
>>>> hardware that supports LAM, I think guest can still enable LAM in CR3 w/o
>>>> causing any trouble (because the hardware actually supports this feature)?
>>> Yes. But I think it is a non-issue ...
>>>
>>>> If it's true, it seems we should trap CR3 (at least loading) when hardware
>>>> supports LAM but it's not exposed to the guest, so that KVM can correctly reject
>>>> any LAM control bits when guest illegally does so?
>>>>
>>> Other features which need no explicit enablement (like AVX and other
>>> new instructions) have the same problem.
>>>
>>> The impact is some guests can use features which they are not supposed
>>> to use. Then they might be broken after migration or kvm's instruction
>>> emulation. But they put themselves at stake, KVM shouldn't be blamed.
>> Agree.
>>
>>> The downside of intercepting CR3 is the performance impact on existing
>>> VMs (all with old CPU models and thus all have no LAM). If they are
>>> migrated to LAM-capable parts in the future, they will suffer
>>> performance drop even though they are good tenents (i.e., won't try to
>>> use LAM).
>>>
>>> IMO, the value of preventing some guests from setting LAM_U48/U57 in CR3
>>> when EPT=on cannot outweigh the performance impact. So, I vote to
>>> document in changelog or comments that:
>>> A guest can enable LAM for userspace pointers when EPT=on even if LAM
>>> isn't exposed to it. KVM doens't prevent this out of performance
>>> consideration
>> How about add the comments on the code:
>>
>> +       /*
>> +        * A guest can enable LAM for userspace pointers when EPT=on on a
>> +        * processor supporting LAM even if LAM isn't exposed to it.
>> +        * KVM doesn't prevent this out of performance considerations.
>> +        */
>>           if (guest_cpuid_has(vcpu, X86_FEATURE_LAM))
>>                   vcpu->arch.cr3_ctrl_bits |= X86_CR3_LAM_U48 |
>> X86_CR3_LAM_U57;
>>
>>
> I would say we should at least call out in the changelog, but I don't have
> opinion on whether to have this comment around this code or not.
OK, will also add it to changelog.

