Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C823E6EA3E4
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 08:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjDUGf0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 02:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjDUGfY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 02:35:24 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14A62137
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 23:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682058923; x=1713594923;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5UAeF2BnuAnm42qH6pCRggxdwMM+FyZ00ll/cf3vjiM=;
  b=Aj16XL5njX2Y+MLAZYRVlQcpvAgTY3zUcnlhC/ZT10twT8fJn65TfDgQ
   kKP0Ed5UY8jsHKVsZlPanviBZfwAAiKBvfYHa+sChilt0AeFREcK1h4lb
   kyqt/vCdUggNxqY+vfJHZodMdp9Be0u+8O//6HTEmEbUN19ZmjJzXF/W3
   GHIar5Ff/VFlJq+HwfRpxCdPDc8SpHoK4/P8PUKY5Dn+Ae4+Qbyhfc0vN
   IL2am3//2PEZwReRdgbctQAORIwO0clr/3S1gqo9LdBIkF1OQYs4++7tF
   7mCeFAuAskwkT96oReXKqFD+o8gftdrm5iU4BbCZWiebaXGSyOdvI1mFa
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="334802023"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="334802023"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 23:35:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="722664190"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="722664190"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.214.158]) ([10.254.214.158])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 23:35:21 -0700
Message-ID: <5e229834-3e55-a580-d9f6-a5ffe971c567@linux.intel.com>
Date:   Fri, 21 Apr 2023 14:35:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
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
 <cc265df1-d4fc-0eb7-f6e8-494e98ece2d9@linux.intel.com>
 <BL1PR11MB5978D1FA3B572A119F5EF3A9F7989@BL1PR11MB5978.namprd11.prod.outlook.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <BL1PR11MB5978D1FA3B572A119F5EF3A9F7989@BL1PR11MB5978.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/13/2023 5:13 PM, Huang, Kai wrote:
>> On 4/13/2023 10:27 AM, Huang, Kai wrote:
>>> On Thu, 2023-04-13 at 09:36 +0800, Binbin Wu wrote:
>>>> On 4/12/2023 7:58 PM, Huang, Kai wrote:
>>>>
>> ...
>>>>>> +	root_gfn = (root_pgd & __PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
>>>>> Or, should we explicitly mask vcpu->arch.cr3_ctrl_bits?  In this
>>>>> way, below
>>>>> mmu_check_root() may potentially catch other invalid bits, but in
>>>>> practice there should be no difference I guess.
>>>> In previous version, vcpu->arch.cr3_ctrl_bits was used as the mask.
>>>>
>>>> However, Sean pointed out that the return value of
>>>> mmu->get_guest_pgd(vcpu) could be
>>>> EPTP for nested case, so it is not rational to mask to CR3 bit(s) from EPTP.
>>> Yes, although EPTP's high bits don't contain any control bits.
>>>
>>> But perhaps we want to make it future-proof in case some more control
>>> bits are added to EPTP too.
>>>
>>>> Since the guest pgd has been check for valadity, for both CR3 and
>>>> EPTP, it is safe to mask off non-address bits to get GFN.
>>>>
>>>> Maybe I should add this CR3 VS. EPTP part to the changelog to make it
>>>> more undertandable.
>>> This isn't necessary, and can/should be done in comments if needed.
>>>
>>> But IMHO you may want to add more material to explain how nested cases
>>> are handled.
>> Do you mean about CR3 or others?
>>
> This patch is about CR3, so CR3.

For nested case, I plan to add the following in the changelog:

     For nested guest:
     - If CR3 is intercepted, after CR3 handled in L1, CR3 will be 
checked in
       nested_vmx_load_cr3() before returning back to L2.
     - For the shadow paging case (SPT02), LAM bits are also be handled 
to form
       a new shadow CR3 in vmx_load_mmu_pgd().


