Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB5353A019
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 11:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240637AbiFAJM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 05:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234768AbiFAJM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 05:12:56 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D039038791;
        Wed,  1 Jun 2022 02:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654074773; x=1685610773;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6zRdvDgL69wDK3vvy0WkoxuVG15R6Byox2N3ddAF4wY=;
  b=PwRttoiFzUltmorvZhlAmzXmTrwcmXlj+CjKNsmdhJbHrgeNtuaVGnKB
   lo/O1eL0Wt+mpXTJpMKxOL2yqfFXAwio3IETfbjWEjXi22OirB2xLf39P
   jGXFrrfg1Bjqk6nsZ5/PUIRCa340KaJkhhC5XvauHNA5K85qInbZv9GN7
   HlwPHaFVa4Q4jEUu65SS9qhUXvVtvQkGX/jOYlYwXNyAq+yTqB+kUkvNq
   WzJFBjOxC+n/0AAmT3LrNgaplK/ns61Vzh138/XOyEpnr58Lwd7ieIUOo
   UTrJapK1FFm1/JYjZXyzDS6N3b3KeCOyYWx+PywjIbQz8d1FWvV7d+CkT
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10364"; a="336182146"
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="336182146"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 02:12:53 -0700
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="606161990"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.255.29.254]) ([10.255.29.254])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 02:12:50 -0700
Message-ID: <2b3be388-400e-7871-7d73-aba50d49a9b7@intel.com>
Date:   Wed, 1 Jun 2022 17:12:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 1/2] KVM: vmx, pmu: accept 0 for absent MSRs when
 host-initiated
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        likexu@tencent.com
References: <20220531175450.295552-1-pbonzini@redhat.com>
 <20220531175450.295552-2-pbonzini@redhat.com> <YpZgU+vfjkRuHZZR@google.com>
 <4b59b1c0-112b-5e07-e613-607220c3b597@redhat.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <4b59b1c0-112b-5e07-e613-607220c3b597@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/1/2022 4:54 PM, Paolo Bonzini wrote:
> On 5/31/22 20:37, Sean Christopherson wrote:
>>> +
>>>           /*
>>>            * Writing depth MSR from guest could either setting the
>>>            * MSR or resetting the LBR records with the side-effect.
>>> @@ -535,6 +542,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu 
>>> *vcpu, struct msr_data *msr_info)
>>>       case MSR_ARCH_LBR_CTL:
>>>           if (!arch_lbr_ctl_is_valid(vcpu, data))
>>>               break;
>>> +        if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
>>> +            return 0;
>>
>> Similar bug here.
>>
>> Can we just punt this out of kvm/queue until its been properly reviewed?
>
> Yes, I agree.  I have started making some changes and pushed the 
> result to kvm/arch-lbr-for-weijiang.
>
> Most of the MSR handling is rewritten (and untested).
>
> The nested VMX handling was also completely broken so I just removed 
> it.  Instead, KVM should be adjusted so that it does not whine.

Noted, I'll run tests based on it, thanks a lot!

Has the branch been pushed? I cannot see it.

>
> Paolo
>
