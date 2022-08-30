Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375AF5A5F58
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 11:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbiH3J0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 05:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbiH3J0d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 05:26:33 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AD3D86D1;
        Tue, 30 Aug 2022 02:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661851591; x=1693387591;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yCWYSMqigSyE57DfRG6ddCpuzq/kzzgVQql2z0Dcpo4=;
  b=dweFlS8OjpZJqud/BHp6NHDuceYxjzZHxp+TRtacvSySTRC3yObbwa5Z
   WW3qSf8RHBv0FIiTy6uVcbG/HtrnMt8GmLRQGWRwivUbRx53GtIBAaWgj
   6PiWYZlCdGFrGKGddCobk3uQaXfUjgdzmGrsG8aapyhed8S7EnG/Gqk2R
   JEmJ29G+9IVuJVdZJvdMK0Dk9DW/2HqhPJYCDM3GipdKuYAMUfsCLWnEe
   jzdB6ntJcZudaSed0vml/ArY+EcVZvcxQHorEwdD+FaoP4BV3issgyvV9
   AaGCOszJBIsuy+ebRGjT8eOw4z/GEfwa/w8/+y4AHkYE1ZgVhI497b6UH
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="296407798"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="296407798"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 02:26:30 -0700
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="641301004"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.29.86]) ([10.255.29.86])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 02:26:28 -0700
Message-ID: <6064e98c-7229-f982-2b23-37d8f2d40607@intel.com>
Date:   Tue, 30 Aug 2022 17:26:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [PATCH v8 020/103] KVM: TDX: create/destroy VM structure
Content-Language: en-US
To:     Binbin Wu <binbin.wu@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <810ce6dbd0330f06a80e05afa0a068b5f5b332f3.1659854790.git.isaku.yamahata@intel.com>
 <bd9ae0af-47de-c8ea-3880-a98fed2de48d@linux.intel.com>
 <20220829190921.GA2700446@ls.amr.corp.intel.com>
 <6704f880-14ed-b8e8-4204-ac0d8afef5ef@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <6704f880-14ed-b8e8-4204-ac0d8afef5ef@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/30/2022 4:57 PM, Binbin Wu wrote:
> 
> On 2022/8/30 3:09, Isaku Yamahata wrote:
>>
>>>> +}
>>>> +
>>>> +static int tdx_reclaim_page(unsigned long va, hpa_t pa, bool do_wb, 
>>>> u16 hkid)
>>>> +{
>>>> +    struct tdx_module_output out;
>>>> +    u64 err;
>>>> +
>>>> +    err = tdh_phymem_page_reclaim(pa, &out);
>>>> +    if (WARN_ON_ONCE(err)) {
>>>> +        pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err, &out);
>>>> +        return -EIO;
>>>> +    }
>>>> +
>>>> +    if (do_wb) {
>>>> +        err = tdh_phymem_page_wbinvd(set_hkid_to_hpa(pa, hkid));
>>>> +        if (WARN_ON_ONCE(err)) {
>>>> +            pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
>>>> +            return -EIO;
>>>> +        }
>>>> +    }
>>>> +
>>>> +    tdx_clear_page(va);
>>> Is it really necessary to clear the reclaimed page using MOVDIR64?
>>>
>>> According to the TDX module spec,  when add a page to TD, both for 
>>> control
>>> structures and TD private memory, during the process some function of 
>>> the
>>> TDX module will initialize the page using binding hkid and direct write
>>> (MOVDIR64B).
>>>
>>> So still need to clear the page using direct write to avoid integrity 
>>> error
>>> when re-assign one page from old keyid to a new keyid as you 
>>> mentioned in
>>> the comment?
>> Yes. As you described above, TDX module does when assining a page to a 
>> private
>> hkid. i.e. TDH.MEM.PAGE.{ADD, AUG}.  But when re-assigning a page from 
>> an old
>> private hkid to a new _shared_ hkid, i.e. TDH.MEM.PAGE.REMOVE or
>> TDH.PHYMEM.PAGE.RECLAIM, TDX module doesn't.
> 
> Is the reason you added the tdx_clear_page() here due to the description 
> in 1.3.1 of Intel CPU Architectural Extensions Specification for TDX 
> (343754-002US)?

NO. The purpose of tdx_clear_page() is to update the HKID associated 
with the memory to 0. Otherwise the page cannot be used for host/KVM. 
Because the cacheline is still associated with a TD HKID, and it will 
get TD-bit mismatch when host accesses it without MOVDIR64B to update 
the HKID.

> The description as following:
> "MKTME on an SOC that supports SEAM might support an integrity 
> protected, memory encryption mode. When using keys with integrity 
> enabled, the MKTME associates a message authentication code (MAC) with 
> each cache line. By design, when reading a cache line using a KeyID with 
> integrity enabled, if the MAC stored in the metadata does not match the 
> MAC regenerated by the MKTME, then the cache line is marked poisoned to 
> prevent the data from being consumed. Integrity protected memory must be 
> initialized before being read, and such initialization must be performed 
> using 64-bytes direct-store with 64-byte write atomicity using the 
> MOVDIR64B instruction"
> 
> Actually I have a question about the description,  does the 
> initialization using MOVDIR64B must associated with the according hkid?
> 

MOVDIR64B is just an instruction to write memory. What HKID is used 
depends on your purpose. When TDX module tries to initialize the private 
memory for TDs, TD's HKID is embedded into the PA. When host kernel/KVM 
tries to reclaim the memory from TD, it needs to embed HKID 0 into PA to 
clear the page.

