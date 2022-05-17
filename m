Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5210D52A070
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 13:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345267AbiEQLcN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 07:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345257AbiEQLcL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 07:32:11 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C0127177;
        Tue, 17 May 2022 04:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652787130; x=1684323130;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0cl+rkmtmTmZKgTuf6PUoBtPHgmWZT9BcBjwdiNcxa8=;
  b=lDmthmvx3rnZyMYP9ItKpZoff6jwftcqNVkPAvpuX9Ch/pBwzGvxKK8t
   vvuxaOWv/1GYuoPSPQpo5OOJehjwc1JkQsR5QrPJkRq/Gss31nuflcTOh
   Gr3469gO/ZVfMjhhpRic///CPnWb8bcZNuF9FvrCsPhucCOtuq4GuwIkU
   ONLZAqlH9WP3E4dUb4X0nLvNIiVk4yoM3od+eRcXAaJweJxRG9MyKYjK0
   Brf21isp0RazVJcccx5nd9mYx11KKNvqr52dp06KVUTd3Ubtp0/3HurX4
   77dlnDwHKzMoErYCZG5ybrdDgxsrfFlAZfuO3zI+qnhlUfV7YmY/0zqIn
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="296427742"
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="296427742"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 04:32:04 -0700
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="568840984"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.255.31.115]) ([10.255.31.115])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 04:32:01 -0700
Message-ID: <84f4eb85-0ab4-07f8-e0a0-4b172d420c4d@intel.com>
Date:   Tue, 17 May 2022 19:31:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v11 14/16] KVM: x86/vmx: Flip Arch LBREn bit on guest
 state change
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "jmattson@google.com" <jmattson@google.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220506033305.5135-1-weijiang.yang@intel.com>
 <20220506033305.5135-15-weijiang.yang@intel.com>
 <9f19a5eb-3eb0-58a2-e4ee-612f3298ba82@redhat.com>
 <9e2b5e9f-25a2-b724-c6d7-282dc987aa99@intel.com>
 <8a15c4b4-cabe-7bc3-bd98-bd669d586616@redhat.com>
 <5f264701-b6d5-8660-55ae-a5039d6a9d3a@intel.com>
 <d68f61ab-d122-809b-913e-4eaf89b337c4@intel.com>
 <6212bdfe-ecd2-3787-a2cb-b285318b102a@redhat.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <6212bdfe-ecd2-3787-a2cb-b285318b102a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/17/2022 5:01 PM, Paolo Bonzini wrote:
> On 5/17/22 10:56, Yang, Weijiang wrote:
>>> I added more things to ease migration handling in SMM because: 1) qemu
>>> checks LBREn before transfer Arch LBR MSRs.
> I think it should always transfer them instead?  There's time to post a
> fixup patch.
OK, I'll send a fix patch.
>
>>> 2) Perf event is created when
>>> LBREn is being set.  Two things are not certain: 1) IA32_LBR_CTL doesn't have
>>> corresponding slot in SMRAM,not sure if we need to rely on it to transfer the MSR.
>>> I chose 0x7f10 as the offset(CET takes 0x7f08) for storage, need you double check if
>>> it's free or used.
> 0x7f10 sounds good.
>
>> Hi, Paolo,
>>
>> I found there're some rebase conflicts between this series and your kvm
>> queue branch due to PEBS patches, I can re-post a new version based on
>> your queue branch if necessary.
> Yes, please.
Sure, I'll post  v12 soon.
>
>> Waiting for your comments on this patch...
> I already commented that using bit 63 is not good, didn't I?
Clear :-D, thanks!
>
> Paolo
>
