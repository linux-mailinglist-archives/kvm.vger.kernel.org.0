Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 950806E0618
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 06:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjDMEpy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 00:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjDMEpx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 00:45:53 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416FA59D2
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 21:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681361152; x=1712897152;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Tvpm42Jh9AGPmulIDPQhLtgr9SQROdT6Rr27yqStRqM=;
  b=NJWXGYtidSp2U30OeQ8EBgtTlVlWpNkaEyC8ja9U7wxwTWFr62ECJN9M
   ozGY3b/FG8w1XVts1dlnCbmFS+EDuxWtBo1ErRjlmJ5f79z545sWiPnGK
   1xKgCXIc6Y6t+JDxZ+/OovBwjMEIy+C/e2evtIDVBS6YZtsdCGSYvwuiu
   s8xkCNVWwGcE4+J31ezwQLFThPKoGWk0JA1N8jX9KPp54aXBY7Obvhm+n
   QmY+KiymJpX2iNky65MEI+xik/Rp8/oMRcIu65lTOP4SGApzyFcqW3RwL
   xC8eSwcHDy4VifvjDMG0qyy+TfWPL0huZZN/ZcBeZLunnyhwHjsBS6YKz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="346768190"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="346768190"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 21:45:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="639485805"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="639485805"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.8.125]) ([10.238.8.125])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 21:45:49 -0700
Message-ID: <cc265df1-d4fc-0eb7-f6e8-494e98ece2d9@linux.intel.com>
Date:   Thu, 13 Apr 2023 12:45:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Cc:     "Guo, Xuelian" <xuelian.guo@intel.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
 <20230404130923.27749-3-binbin.wu@linux.intel.com>
 <9c99eceaddccbcd72c5108f72609d0f995a0606c.camel@intel.com>
 <497514ed-db46-16b9-ca66-04985a687f2b@linux.intel.com>
 <7b296e6686bba77f81d1d8c9eaceb84bd0ef0338.camel@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <7b296e6686bba77f81d1d8c9eaceb84bd0ef0338.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/13/2023 10:27 AM, Huang, Kai wrote:
> On Thu, 2023-04-13 at 09:36 +0800, Binbin Wu wrote:
>> On 4/12/2023 7:58 PM, Huang, Kai wrote:
>>
...
>>>> +	root_gfn = (root_pgd & __PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
>>> Or, should we explicitly mask vcpu->arch.cr3_ctrl_bits?  In this way, below
>>> mmu_check_root() may potentially catch other invalid bits, but in practice there
>>> should be no difference I guess.
>> In previous version, vcpu->arch.cr3_ctrl_bits was used as the mask.
>>
>> However, Sean pointed out that the return value of
>> mmu->get_guest_pgd(vcpu) could be
>> EPTP for nested case, so it is not rational to mask to CR3 bit(s) from EPTP.
> Yes, although EPTP's high bits don't contain any control bits.
>
> But perhaps we want to make it future-proof in case some more control bits are
> added to EPTP too.
>
>> Since the guest pgd has been check for valadity, for both CR3 and EPTP,
>> it is safe to mask off
>> non-address bits to get GFN.
>>
>> Maybe I should add this CR3 VS. EPTP part to the changelog to make it
>> more undertandable.
> This isn't necessary, and can/should be done in comments if needed.
>
> But IMHO you may want to add more material to explain how nested cases are
> handled.

Do you mean about CR3 or others?


