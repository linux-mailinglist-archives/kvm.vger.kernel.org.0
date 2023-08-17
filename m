Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A370377F316
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 11:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349475AbjHQJST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 05:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349556AbjHQJSG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 05:18:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638642684;
        Thu, 17 Aug 2023 02:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692263865; x=1723799865;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=A+AokkXaJj9i8YrWEzlhAoW/AeaNvhtQ33j2YkNOjG8=;
  b=Tx8+UyIImCbV63cxyAdzeavEt+zLffGa168fZLSNE8f+1RJnq0myEssf
   wQvqvbE6VlnQqBTxiMkCsi8aR42JqPhP7M9RQXQr2f5FgD7LLJgu//y6u
   rl+R8X46mlqapL09GbB2gItCCi4PYDWsNqGzvEpfTNFck++MLqWbVZyb7
   ySWzulsiYwVtHF0NKuRWNQ1gavHfV1oaR6lDa/NXNWx5obFiKm+eswkj+
   Y54Q736iIHU3fQlJZbmHDznGmSmzpdDgv4APakOfEHdvnnxdTcgyb6xWk
   qAMgjDxkJ+Dsa3S3k/6RGXZOJt96F+22oJT6EKqxv7UAllCI6KM2ux+Zi
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="403739952"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="403739952"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 02:17:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="734597227"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="734597227"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.52]) ([10.238.10.52])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 02:17:31 -0700
Message-ID: <6e990b88-1e28-9563-2c2f-0d5d52f9c7ca@linux.intel.com>
Date:   Thu, 17 Aug 2023 17:17:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v10 0/9] Linear Address Masking (LAM) KVM Enabling
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com,
        guang.zeng@intel.com
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
 <ZN1M5RvuARP1YMfp@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZN1M5RvuARP1YMfp@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/17/2023 6:25 AM, Sean Christopherson wrote:
> On Wed, Jul 19, 2023, Binbin Wu wrote:
>> Binbin Wu (7):
>>    KVM: x86/mmu: Use GENMASK_ULL() to define __PT_BASE_ADDR_MASK
>>    KVM: x86: Add & use kvm_vcpu_is_legal_cr3() to check CR3's legality
>>    KVM: x86: Use KVM-governed feature framework to track "LAM enabled"
>>    KVM: x86: Virtualize CR3.LAM_{U48,U57}
>>    KVM: x86: Introduce get_untagged_addr() in kvm_x86_ops and call it in
>>      emulator
>>    KVM: VMX: Implement and wire get_untagged_addr() for LAM
>>    KVM: x86: Untag address for vmexit handlers when LAM applicable
>>
>> Robert Hoo (2):
>>    KVM: x86: Virtualize CR4.LAM_SUP
>>    KVM: x86: Expose LAM feature to userspace VMM
> Looks good, just needs a bit of re-organination.  Same goes for the LASS series.
>
> For the next version, can you (or Zeng) send a single series for LAM and LASS?
> They're both pretty much ready to go, i.e. I don't expect one to hold up the other
> at this point, and posting a single series will reduce the probability of me
> screwing up a conflict resolution or missing a dependency when applying.
>
> Lastly, a question: is there a pressing need to get LAM/LASS support merged _now_?
> E.g. are there are there any publicly available CPUs that support LAM and/or LASS?
AFAIK, there is no publicly available CPU supporting LAM and LASS yet.

>
> If not, I'll wait until v6.7 to grab these, e.g. so that you don't have to rush
> madly to turn around the next version, and so that I'm not trying to squeeze too
> much stuff in just before the merge window.

