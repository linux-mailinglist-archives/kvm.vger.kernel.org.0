Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D3D5A5EC1
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 10:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiH3I5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 04:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiH3I5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 04:57:37 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1167D9FA82;
        Tue, 30 Aug 2022 01:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661849854; x=1693385854;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iFyqrBQdxTUBOpu9l4E3C3J/Crs7bTOiZ1ntimc+HSU=;
  b=YC5OvuaOapHHUl/e59sWdA1w8pUHbITorDwapbw2Xlfh6ao3GEGgtmWV
   nUe2r4xujjb3bTrcqSz776pNjX3c+IUMz2noVU3To/YguWPwE29GELYiJ
   Mc6+FVN7BspJ4flV9EKgfX4xkL0nPvwLM++zpCopLDGeN2saz/EyIAoC2
   xI/D0Co3Qrh8hw9CyCt7aUiTOs4B/wKM1fiviKGimwOaI7/MOB7RC+rIS
   vO/pO1gA26Y/4Wf6jaOxwOCQQiywb+a1GIGmjiylTlniHy9/OGpbEIcK1
   FSh92vCrxR79G1Qp4pMcAzOORFQeufKqQQprbwDOCnyrW4qGpR/zwW9Yn
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="359086657"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="359086657"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 01:57:30 -0700
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="641290765"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.172.100]) ([10.249.172.100])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 01:57:27 -0700
Message-ID: <6704f880-14ed-b8e8-4204-ac0d8afef5ef@linux.intel.com>
Date:   Tue, 30 Aug 2022 16:57:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH v8 020/103] KVM: TDX: create/destroy VM structure
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <810ce6dbd0330f06a80e05afa0a068b5f5b332f3.1659854790.git.isaku.yamahata@intel.com>
 <bd9ae0af-47de-c8ea-3880-a98fed2de48d@linux.intel.com>
 <20220829190921.GA2700446@ls.amr.corp.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20220829190921.GA2700446@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/8/30 3:09, Isaku Yamahata wrote:
>
>>> +}
>>> +
>>> +static int tdx_reclaim_page(unsigned long va, hpa_t pa, bool do_wb, u16 hkid)
>>> +{
>>> +	struct tdx_module_output out;
>>> +	u64 err;
>>> +
>>> +	err = tdh_phymem_page_reclaim(pa, &out);
>>> +	if (WARN_ON_ONCE(err)) {
>>> +		pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err, &out);
>>> +		return -EIO;
>>> +	}
>>> +
>>> +	if (do_wb) {
>>> +		err = tdh_phymem_page_wbinvd(set_hkid_to_hpa(pa, hkid));
>>> +		if (WARN_ON_ONCE(err)) {
>>> +			pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
>>> +			return -EIO;
>>> +		}
>>> +	}
>>> +
>>> +	tdx_clear_page(va);
>> Is it really necessary to clear the reclaimed page using MOVDIR64?
>>
>> According to the TDX module spec,  when add a page to TD, both for control
>> structures and TD private memory, during the process some function of the
>> TDX module will initialize the page using binding hkid and direct write
>> (MOVDIR64B).
>>
>> So still need to clear the page using direct write to avoid integrity error
>> when re-assign one page from old keyid to a new keyid as you mentioned in
>> the comment?
> Yes. As you described above, TDX module does when assining a page to a private
> hkid. i.e. TDH.MEM.PAGE.{ADD, AUG}.  But when re-assigning a page from an old
> private hkid to a new _shared_ hkid, i.e. TDH.MEM.PAGE.REMOVE or
> TDH.PHYMEM.PAGE.RECLAIM, TDX module doesn't.

Is the reason you added the tdx_clear_page() here due to the description 
in 1.3.1 of Intel CPU Architectural Extensions Specification for TDX 
(343754-002US)?

The description as following:
"MKTME on an SOC that supports SEAM might support an integrity 
protected, memory encryption mode. When using keys with integrity 
enabled, the MKTME associates a message authentication code (MAC) with 
each cache line. By design, when reading a cache line using a KeyID with 
integrity enabled, if the MAC stored in the metadata does not match the 
MAC regenerated by the MKTME, then the cache line is marked poisoned to 
prevent the data from being consumed. Integrity protected memory must be 
initialized before being read, and such initialization must be performed 
using 64-bytes direct-store with 64-byte write atomicity using the 
MOVDIR64B instruction"

Actually I have a question about the description,  does the 
initialization using MOVDIR64B must associated with the according hkid?



