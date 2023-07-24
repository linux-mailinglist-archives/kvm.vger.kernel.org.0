Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B142975E98D
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 04:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbjGXCMk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Jul 2023 22:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbjGXCM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Jul 2023 22:12:27 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159A15269;
        Sun, 23 Jul 2023 19:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690164535; x=1721700535;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tl4MlhnuH+gxd1QJIB7HxSdpTHBpYZOJ42p6SMXaSlc=;
  b=fvke2/zZzgPz2ahbQsyWl65J14TcL4Tm3xe0hdXKbSxkJ2eYQ2m08QvP
   dkhHXqxf+6NGu7Jhf2cXM5qj7j4PAq+X/27Wt3ONfz3TeoHQBzCzkpYHD
   rDA9lA8Ti3aGRsgf9IJJXeVAnmrMwzlr70ekpo2p/sijdTkqwiIFm2Rus
   MqaKQg2XmQIuviVILDN0Z8phE1Uoyf64Ntrp69W5yIlyTjvg8uihrWlhf
   rVmj8a9pe8gizUTDHudp5V77j0oLaPb3C0gXFa2i0vrXv4dXiEfzfw2jT
   vyCv7EbwuN/K2ZZ+vH1PsJRmOBJO74QDBNgaIfdInE0T+L3ScaIyf/aHp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="367357843"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="367357843"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2023 19:07:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="760613679"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="760613679"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.9.27]) ([10.238.9.27])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2023 19:07:51 -0700
Message-ID: <6086d09d-f218-d962-18dc-7b1a0390f258@linux.intel.com>
Date:   Mon, 24 Jul 2023 10:07:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 2/9] KVM: x86: Add & use kvm_vcpu_is_legal_cr3() to
 check CR3's legality
To:     Sean Christopherson <seanjc@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        chao.gao@intel.com, kai.huang@intel.com, David.Laight@aculab.com,
        robert.hu@linux.intel.com, guang.zeng@intel.com
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
 <20230719144131.29052-3-binbin.wu@linux.intel.com>
 <20230720235352.GH25699@ls.amr.corp.intel.com>
 <e84129b1-603b-a6c4-ade5-8cf529929675@linux.intel.com>
 <ZLqeUXerpNlri7Px@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZLqeUXerpNlri7Px@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/21/2023 11:03 PM, Sean Christopherson wrote:
> On Fri, Jul 21, 2023, Binbin Wu wrote:
>>
>> On 7/21/2023 7:53 AM, Isaku Yamahata wrote:
>>> On Wed, Jul 19, 2023 at 10:41:24PM +0800,
>>> Binbin Wu <binbin.wu@linux.intel.com> wrote:
>>>
>>>> Add and use kvm_vcpu_is_legal_cr3() to check CR3's legality to provide
>>>> a clear distinction b/t CR3 and GPA checks. So that kvm_vcpu_is_legal_cr3()
>>>> can be adjusted according to new feature(s).
>>>>
>>>> No functional change intended.
>>>>
>>>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>>>> ---
>>>>    arch/x86/kvm/cpuid.h      | 5 +++++
>>>>    arch/x86/kvm/svm/nested.c | 4 ++--
>>>>    arch/x86/kvm/vmx/nested.c | 4 ++--
>>>>    arch/x86/kvm/x86.c        | 4 ++--
>>>>    4 files changed, 11 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
>>>> index f61a2106ba90..8b26d946f3e3 100644
>>>> --- a/arch/x86/kvm/cpuid.h
>>>> +++ b/arch/x86/kvm/cpuid.h
>>>> @@ -283,4 +283,9 @@ static __always_inline bool guest_can_use(struct kvm_vcpu *vcpu,
>>>>    	return vcpu->arch.governed_features.enabled & kvm_governed_feature_bit(x86_feature);
>>>>    }
>>>> +static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>>>> +{
>>>> +	return kvm_vcpu_is_legal_gpa(vcpu, cr3);
>>>> +}
>>>> +
>>> The remaining user of kvm_vcpu_is_illegal_gpa() is one left.  Can we remove it
>>> by replacing !kvm_vcpu_is_legal_gpa()?
>> There are still two callsites of kvm_vcpu_is_illegal_gpa() left (basing on
>> Linux 6.5-rc2), in handle_ept_violation() and nested_vmx_check_eptp().
>> But they could be replaced by !kvm_vcpu_is_legal_gpa() and then remove
>> kvm_vcpu_is_illegal_gpa().
>> I am neutral to this.
> I'm largely neutral on this as well, though I do like the idea of having only
> "legal" APIs.  I think it makes sense to throw together a patch, we can always
> ignore the patch if end we up deciding to keep kvm_vcpu_is_illegal_gpa().
OK. Thanks for the advice.
Should I send a seperate patch or add a patch to remove 
kvm_vcpu_is_illegal_gpa() in next version?


