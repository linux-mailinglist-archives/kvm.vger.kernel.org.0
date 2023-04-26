Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC9F6EED75
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 07:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbjDZFNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 01:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjDZFNo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 01:13:44 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B24E77
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 22:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682486023; x=1714022023;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kCGHvfHMif1gGFmZP86KGvJTcBgFeBnk6tiUYxia9KE=;
  b=jk5oo+1aIAHvzx3cP9+YHk/o4zmWgLszXX9TBNd+eNk4WFuTq4A3oMlF
   dLrVFPlmVZEeDevvNqibrQqi/PBWhPA02s3682SfGZXjnq6z7kXPMu/AF
   sVGiEBf150oCS+cKZxsrgXVkF1BMrrJpNlaA7RTlzeVaZa/Fry7MdX4ZS
   ywwq8CyouhtK9E3bqcAI4od15bAV6BdLpcv4RtU0Ah8w57YNBsHUqA9k4
   ubZk7t1/xqOFoaWqskUGsqO+hQtVi2qoXl1pAdhTChAwimlocd4bmK3Gj
   zLZXBBk/sm7aXN4NfoKKrUEupXAaVwzomfcd7A3lM2IEK2z0tfWdpJncH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="327316037"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="327316037"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 22:13:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="724283173"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="724283173"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.3.89]) ([10.238.3.89])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 22:13:39 -0700
Message-ID: <27c77030-58f4-61be-81b0-f3cc7c084b9f@linux.intel.com>
Date:   Wed, 26 Apr 2023 13:13:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
To:     Chao Gao <chao.gao@intel.com>, "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Guo, Xuelian" <xuelian.guo@intel.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>
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
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZEiU5Rln4uztr1bz@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/26/2023 11:05 AM, Chao Gao wrote:
> On Wed, Apr 26, 2023 at 06:48:21AM +0800, Huang, Kai wrote:
>> ... when EPT is on, as you mentioned guest can update CR3 w/o causing VMEXIT to
>> KVM.
>>
>> Is there any global enabling bit in any of CR to turn on/off LAM globally?  It
>> seems there isn't because AFAICT the bits in CR4 are used to control super mode
>> linear address but not LAM in global?
> Right.
>
>> So if it is true, then it appears hardware depends on CPUID purely to decide
>> whether to perform LAM or not.
>>
>> Which means, IIRC, when EPT is on, if we don't expose LAM to the guest on the
>> hardware that supports LAM, I think guest can still enable LAM in CR3 w/o
>> causing any trouble (because the hardware actually supports this feature)?
> Yes. But I think it is a non-issue ...
>
>> If it's true, it seems we should trap CR3 (at least loading) when hardware
>> supports LAM but it's not exposed to the guest, so that KVM can correctly reject
>> any LAM control bits when guest illegally does so?
>>
> Other features which need no explicit enablement (like AVX and other
> new instructions) have the same problem.
>
> The impact is some guests can use features which they are not supposed
> to use. Then they might be broken after migration or kvm's instruction
> emulation. But they put themselves at stake, KVM shouldn't be blamed.
Agree.

>
> The downside of intercepting CR3 is the performance impact on existing
> VMs (all with old CPU models and thus all have no LAM). If they are
> migrated to LAM-capable parts in the future, they will suffer
> performance drop even though they are good tenents (i.e., won't try to
> use LAM).
>
> IMO, the value of preventing some guests from setting LAM_U48/U57 in CR3
> when EPT=on cannot outweigh the performance impact. So, I vote to
> document in changelog or comments that:
> A guest can enable LAM for userspace pointers when EPT=on even if LAM
> isn't exposed to it. KVM doens't prevent this out of performance
> consideration

How about add the comments on the code:

+       /*
+        * A guest can enable LAM for userspace pointers when EPT=on on a
+        * processor supporting LAM even if LAM isn't exposed to it.
+        * KVM doesn't prevent this out of performance considerations.
+        */
         if (guest_cpuid_has(vcpu, X86_FEATURE_LAM))
                 vcpu->arch.cr3_ctrl_bits |= X86_CR3_LAM_U48 | 
X86_CR3_LAM_U57;


