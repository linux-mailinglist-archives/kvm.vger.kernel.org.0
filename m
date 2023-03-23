Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2EFA6C5BBA
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 02:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjCWBJX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 21:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjCWBJW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 21:09:22 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01924113E0
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 18:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679533761; x=1711069761;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5R863CrSOBQcIRXEt7VlZj/+LJDrPyd6dnucB7ds6rE=;
  b=GppX/N4jRJBcr59XHTRwST/3nr6KoDG/rwMeNMSipmcXGfSYLWrAxFzW
   NMRFi88bkoRUUJwSBv4gv2zAkq6MPbZEcRx513aD8orusIgotnBMYu0mV
   KYh5b0GSwZ42R55bPCb99S9+slXSVyKobKeFvM7/zEDzgJkwt/1hPSRzF
   nPkWkGs2aEWulC/QD+lJNvrj3vgWsnTVH8oL0b0gDUXri89W4wEQaNZom
   DDBPwzjyohUdDx0PgShfru8KuQd4qxCoYdQx4MOslAvNNbG7ge97KRk6Z
   crrFZoq/JHV/YACkfUHU64Xmjv20aZ9XrJ0ebsIIs431QwzOA3iDmM9Oq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="327747487"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="327747487"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 18:09:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="714609468"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="714609468"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.8.235]) ([10.238.8.235])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 18:09:19 -0700
Message-ID: <3df30e09-841d-b5a8-d984-65bd2ebc385e@linux.intel.com>
Date:   Thu, 23 Mar 2023 09:09:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 2/4] KVM: x86: Replace kvm_read_{cr0,cr4}_bits() with
 kvm_is_{cr0,cr4}_bit_set()
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, robert.hu@linux.intel.com
References: <20230322045824.22970-1-binbin.wu@linux.intel.com>
 <20230322045824.22970-3-binbin.wu@linux.intel.com>
 <ZBs5Eh0LrN/TMErj@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZBs5Eh0LrN/TMErj@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/23/2023 1:21 AM, Sean Christopherson wrote:
> On Wed, Mar 22, 2023, Binbin Wu wrote:
>> Replace kvm_read_{cr0,cr4}_bits() with kvm_is_{cr0,cr4}_bit_set() when only
>> one bit is checked and bool is preferred as return value type.
>> Also change the return value type from int to bool of is_pae(), is_pse() and
>> is_paging().
> I'm going to squash the obvious/direct changes with the introduction of the helpers,
> and isolate is_{pae,pse,paging}() as those are more risky due to the multiple
> casts (ulong=>int=>bool), and because the end usage isn't visible in the patch.
>
> Case in point, there is a benign but in svm_set_cr0() that would be silently
> fixed by converting is_paging() to return a bool:
>
> 	bool old_paging = is_paging(vcpu);
>
> 	...
>
> 	vcpu->arch.cr0 = cr0;
>
> 	if (!npt_enabled) {
> 		hcr0 |= X86_CR0_PG | X86_CR0_WP;
> 		if (old_paging != is_paging(vcpu))
>
> The "old_paging != is_paging(vcpu)" compares a bool (1/0) against an int that
> was an unsigned long (X86_CR0_PG/0), i.e. gets a false positive when paging is
> enabled.
>
> I'll post a fix and slot it in before this patch, both so that there's no silent
> fixes and so that this changelog can reference the commit.

OK, thanks.


>
>> ---
>>   arch/x86/kvm/cpuid.c      |  4 ++--
>>   arch/x86/kvm/mmu.h        |  2 +-
>>   arch/x86/kvm/vmx/nested.c |  2 +-
>>   arch/x86/kvm/vmx/vmx.c    |  2 +-
>>   arch/x86/kvm/x86.c        | 20 ++++++++++----------
>>   arch/x86/kvm/x86.h        | 16 ++++++++--------
> This misses a few conversions in kvm_pmu_rdpmc(), I'll fix those when applying too.
