Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9B55BC2B8
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 08:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiISGMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 02:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiISGMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 02:12:01 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE901AF2F
        for <kvm@vger.kernel.org>; Sun, 18 Sep 2022 23:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663567920; x=1695103920;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xP07MG2LZpGM4fSELwtQs+nWzgGYK+3ztLksyhtQoIU=;
  b=XejC3isAmWwIVVH0M+UMwbysl3bGegFr9CaDfj5X1mlR73rAhJXYtDW6
   Sovgt8dzm/ivIFPu6wNLYig792plTqFQ1w+6kxcvaB3TEKSNNihXcYElY
   JM2G5PXum0q0FMoCIfo5dG9aHrEf6CXSes61llV+5ndDc2A0HgjLABSSk
   I6T7iPIZjeVbIsFBSJkATrdlQQ1pmeQBN0J7LRIUFlA7jwykf3MPHnrCZ
   EIk2/kfOB2HCSfbvWeZ9CtdUVGoo5ZWG3w+Elt/t8pG7QeeUtoRMlCm7p
   CrtEOVLzC6zCnO0CZQ/n+JYWSJ3lv8EOq80AZyhlUea+LDbVyk1NeOaft
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10474"; a="286359079"
X-IronPort-AV: E=Sophos;i="5.93,327,1654585200"; 
   d="scan'208";a="286359079"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2022 23:12:00 -0700
X-IronPort-AV: E=Sophos;i="5.93,327,1654585200"; 
   d="scan'208";a="947078454"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.170.149]) ([10.249.170.149])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2022 23:11:57 -0700
Message-ID: <a224206a-c5db-18a4-ecad-2c7132e12452@intel.com>
Date:   Mon, 19 Sep 2022 14:11:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.0
Subject: Re: [PATCH v6 2/2] i386: Add notify VM exit support
Content-Language: en-US
To:     Chenyi Qiang <chenyi.qiang@intel.com>, Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
References: <20220915092839.5518-1-chenyi.qiang@intel.com>
 <20220915092839.5518-3-chenyi.qiang@intel.com> <YyTxL7kstA20tB5a@xz-m1.local>
 <5beb9f1c-a419-94f7-a1b9-4aeb281baa41@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <5beb9f1c-a419-94f7-a1b9-4aeb281baa41@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/19/2022 1:46 PM, Chenyi Qiang wrote:
>> Not sure some warning would be also useful here, but I really don't know
>> the whole context so I can't tell whether there can easily be false
>> positives to pollute qemu log.
>>
> 
> The false positive case is not easy to happen unless some potential 
> issues in silicon. But in case of it, to avoid polluting qemu log, how 
> about:
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index ae7fb2c495..8f97133cbf 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -5213,6 +5213,7 @@ int kvm_arch_handle_exit(CPUState *cs, struct 
> kvm_run *run)
>           break;
>       case KVM_EXIT_NOTIFY:
>           ret = 0;
> +        warn_report_once("KVM: notify window was exceeded in guest");
>           if (run->notify.flags & KVM_NOTIFY_CONTEXT_INVALID) {
>               warn_report("KVM: invalid context due to notify vmexit");
>               if (has_triple_fault_event) {

how about this

     case KVM_EXIT_NOTIFY:
         bool ctx_invalid = run->notify.flags & KVM_NOTIFY_CONTEXT_INVALID;
         ret = 0;
         warn_report_once("KVM: Encounter notify exit with %svalid context",
                          ctx_invalid ? "in" : "");

         if (ctx_invalid) {
             ...
         }
