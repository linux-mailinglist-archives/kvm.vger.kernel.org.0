Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8285D63A955
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 14:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbiK1NUc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 08:20:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbiK1NUF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 08:20:05 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2142C1D67C;
        Mon, 28 Nov 2022 05:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669641494; x=1701177494;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=feh5wIxMdReyTgHXcIIwra+buNVe+nG18fhOngJ00EI=;
  b=Zg3DHdLz9dsVcx/bHzI3k+48lmMOrvD5sWljCMPd+nxalOANNxfoTHu1
   IrEZwohZQ89B+yvebGuMcN89iUzJTAV0Sm95oEJDZA1wuklpxMzJyTSR2
   1zd7qyeUwLqYCxGLNOHl04n1/0PxQTQ0bIV9yLkLJ2bl34GqaLSmYAwvI
   fnA932Ldsh+vqsh2nzrxetds8vjlbg2hKnwDPsu9omCLjeNRKzMhuTt1n
   pJO3cQ13cDaWVDGECTDwUvwha1wX+Ks4BwmzHVBx55YTocYR8R2eV35NH
   Buef+4+sxcikspTL9+J7OWhZFWELldJ6LMT+JqaIpsM1TMWww4AQkF1UA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="298184275"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="298184275"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 05:18:13 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="593867697"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="593867697"
Received: from nroy-mobl1.amr.corp.intel.com (HELO [10.212.209.4]) ([10.212.209.4])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 05:18:12 -0800
Message-ID: <c752d17e-23fd-4452-e1d8-6c82748b6c8a@intel.com>
Date:   Mon, 28 Nov 2022 05:18:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 14/20] x86/virt/tdx: Set up reserved areas for all
 TDMRs
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <5a5644e691134dc72c5e3fb0fc22fa40d4aa0b34.1668988357.git.kai.huang@intel.com>
 <5526fedd-fa54-0ad2-f356-94b167e6e290@intel.com>
 <0ebf26d1ee540b4e082b65c51cabe3327f6d51ac.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <0ebf26d1ee540b4e082b65c51cabe3327f6d51ac.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/28/22 01:14, Huang, Kai wrote:
> On Wed, 2022-11-23 at 15:39 -0800, Dave Hansen wrote:
...
>> /*
>>  * Go through tdx_memlist to find holes between memory areas.  If any of
>>  * those holes fall within @tdmr, set up a TDMR reserved area to cover
>>  * the hole.
>>  */
>> static int tdmr_populate_rsvd_holes(struct list_head *tdx_memlist,
>> 				    struct tdmr_info *tdmr,
>> 				    int *rsvd_idx)
> 
> Thanks!
> 
> Should I also change below function 'tdmr_set_up_pamt_rsvd_areas()' to, i.e.
> tdmr_populate_rsvd_pamts()?
> 
> Actually, there are two more functions in this patch: tdmr_set_up_rsvd_areas()
> and tdmrs_set_up_rsvd_areas_all().  Should I also change them to
> tdmr_populate_rsvd_areas() and tdmrs_populate_rsvd_areas_all()? 

I don't know.  I'll look at the naming again once I see it all together.

>> but I also get the feeling that 'prev_end' is a crummy variable name.  I
>> don't have any better suggestions at the moment.
>>
>>> +	list_for_each_entry(tmb, &tdx_memlist, list) {
>>> +		u64 start, end;
>>> +
>>> +		start = tmb->start_pfn << PAGE_SHIFT;
>>> +		end = tmb->end_pfn << PAGE_SHIFT;
>>> +
>>
>> More alignment opportunities:
>>
>> 		start = tmb->start_pfn << PAGE_SHIFT;
>> 		end   = tmb->end_pfn   << PAGE_SHIFT;
> 
> Should I use PFN_PHYS()?  Then looks we don't need this alignment.

Sure.

