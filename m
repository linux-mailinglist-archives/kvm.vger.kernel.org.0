Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A271578051C
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 06:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357851AbjHREbd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 00:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357845AbjHREbc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 00:31:32 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB8030DF;
        Thu, 17 Aug 2023 21:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692333090; x=1723869090;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=aTDAix5un+yi8UdWj+aP3E02mqXJ0FXW1Bc4OAQFw/c=;
  b=Pat8IRXipMhDrMaLKDapy6sVQ77PlS3m6OPUZmLuHxE9gBBNg1lGLy+/
   rAPaHT1qgA6s9c+RUS2kEY3tp+NQpCbiSejUfLSGnQNW1uIqrxQyDeK8M
   b5qPbCVfEP5W51fD0+oVlCNJhh3q96SE2h+7MFV2s8OadG2e5nixGZncG
   DgKtRskiODGmm81tldOlwDhgOG14N+6N+hRGLqXnJ1EUNdtrsAVIFizWP
   KJfhWv0f9JvbWgZGB6h1O6w2uPFULG4w9GrcS2jOkKJ9g7NnlKIunbxYT
   vyN6tb7Gx1/F62IAgTVTNgabhY76KIQWmxb9PMIdjF3TyWXMRUG+cdrpK
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="403989146"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="403989146"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 21:31:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="878526116"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.93.8.202]) ([10.93.8.202])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 21:31:32 -0700
Message-ID: <e4aa03cb-0f80-bd5f-f69e-39b636476f00@linux.intel.com>
Date:   Fri, 18 Aug 2023 12:31:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v10 0/9] Linear Address Masking (LAM) KVM Enabling
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com,
        guang.zeng@intel.com
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
 <ZN1M5RvuARP1YMfp@google.com>
 <6e990b88-1e28-9563-2c2f-0d5d52f9c7ca@linux.intel.com>
In-Reply-To: <6e990b88-1e28-9563-2c2f-0d5d52f9c7ca@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/17/2023 5:17 PM, Binbin Wu wrote:
>
>
> On 8/17/2023 6:25 AM, Sean Christopherson wrote:
>> On Wed, Jul 19, 2023, Binbin Wu wrote:
>>> Binbin Wu (7):
>>>    KVM: x86/mmu: Use GENMASK_ULL() to define __PT_BASE_ADDR_MASK
>>>    KVM: x86: Add & use kvm_vcpu_is_legal_cr3() to check CR3's legality
>>>    KVM: x86: Use KVM-governed feature framework to track "LAM enabled"
>>>    KVM: x86: Virtualize CR3.LAM_{U48,U57}
>>>    KVM: x86: Introduce get_untagged_addr() in kvm_x86_ops and call 
>>> it in
>>>      emulator
>>>    KVM: VMX: Implement and wire get_untagged_addr() for LAM
>>>    KVM: x86: Untag address for vmexit handlers when LAM applicable
>>>
>>> Robert Hoo (2):
>>>    KVM: x86: Virtualize CR4.LAM_SUP
>>>    KVM: x86: Expose LAM feature to userspace VMM
>> Looks good, just needs a bit of re-organination.  Same goes for the 
>> LASS series.
>>
>> For the next version, can you (or Zeng) send a single series for LAM 
>> and LASS?
>> They're both pretty much ready to go, i.e. I don't expect one to hold 
>> up the other
>> at this point, and posting a single series will reduce the 
>> probability of me
>> screwing up a conflict resolution or missing a dependency when applying.
>>
Hi Sean,
Do you still prefer a single series for LAM and LASS  for the next 
version when we don't need to rush for v6.6?

>> Lastly, a question: is there a pressing need to get LAM/LASS support 
>> merged _now_?
>> E.g. are there are there any publicly available CPUs that support LAM 
>> and/or LASS?
> AFAIK, there is no publicly available CPU supporting LAM and LASS yet.
>
>>
>> If not, I'll wait until v6.7 to grab these, e.g. so that you don't 
>> have to rush
>> madly to turn around the next version, and so that I'm not trying to 
>> squeeze too
>> much stuff in just before the merge window.
>

