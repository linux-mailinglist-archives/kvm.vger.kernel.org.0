Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1652563ADF0
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 17:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbiK1Qj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 11:39:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbiK1QjW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 11:39:22 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C486924F33;
        Mon, 28 Nov 2022 08:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669653560; x=1701189560;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GolNk7mcHs/DhuFZg0xkFTIE8isAPO9WLsuqkpSXlnk=;
  b=h5C31Ec3dH2rreyR96ZeIN2Rsn5+6l3Q7iKHL9F/+I40pmP/vYWOzQgF
   glsy0hgw+PwKa/QorecGr4jSLyBeT2UqoF9S/Y9X/8/vndiO3IYxlq0Qr
   J2hGlYix/ckUwWfVEREMnUcjvGcelp/zznAicHa9diNSdfq8JIxRFFH8y
   OLecLhPsnxbkK5mTiN0kPGEfEaLFIsj/K2mGafeAnjGHQYmfdWMLC++Ga
   AkKzqQPBd3onsrecMpWh9+L4MnGkotuDGGPKgj/bALDVLVHj/z7E2h1oj
   h7D/8ZAPT4Srm9LBhJi3pKCK4EpNIlbfGsD/8GwlQ34FiRUBFcUGNyfbY
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="341795217"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="341795217"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 08:39:20 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="706855535"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="706855535"
Received: from nroy-mobl1.amr.corp.intel.com (HELO [10.212.209.4]) ([10.212.209.4])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 08:39:19 -0800
Message-ID: <1e45748f-0de1-39aa-7e0f-7596ff813302@intel.com>
Date:   Mon, 28 Nov 2022 08:39:19 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 13/20] x86/virt/tdx: Allocate and set up PAMTs for
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
 <ef6cdab2c371b9f068f2b4bf493b1dd0c9bb3c99.1668988357.git.kai.huang@intel.com>
 <74723e2b-3094-d04b-aed7-2789268b00ab@intel.com>
 <cceee7b0476437fb18f90a272e2852bdbb2636cc.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <cceee7b0476437fb18f90a272e2852bdbb2636cc.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/24/22 03:46, Huang, Kai wrote:
> On Wed, 2022-11-23 at 14:57 -0800, Dave Hansen wrote:
>> On 11/20/22 16:26, Kai Huang wrote:
>>> Use alloc_contig_pages() since PAMT must be a physically contiguous area
>>> and it may be potentially large (~1/256th of the size of the given TDMR).
>>> The downside is alloc_contig_pages() may fail at runtime.  One (bad)
>>> mitigation is to launch a TD guest early during system boot to get those
>>> PAMTs allocated at early time, but the only way to fix is to add a boot
>>> option to allocate or reserve PAMTs during kernel boot.
>>
>> FWIW, we all agree that this is a bad permanent way to leave things.
>> You can call me out here as proposing that this wart be left in place
>> while this series is merged and is a detail we can work on afterword
>> with new module params, boot options, Kconfig or whatever.
> 
> Sorry do you mean to call out in the cover letter, or in this changelog?

Cover letter would be best.  But, a note in the changelog that it is
imperfect and will be improved on later would also be nice.

>>> +   /*
>>> +    * Fall back to allocating the TDMR's metadata from node 0 when
>>> +    * no TDX memory block can be found.  This should never happen
>>> +    * since TDMRs originate from TDX memory blocks.
>>> +    */
>>> +   WARN_ON_ONCE(1);
>>
>> That's probably better a pr_warn() or something.  A backtrace and all
>> that jazz seems a bit overly dramatic for this.
> 
> How about below?
> 
> pr_warn("TDMR [0x%llx, 0x%llx): unable to find local NUMA node for PAMT
> allocation, fallback to use node 0.\n");

I actually try to make these somewhat mirror the code.  For instance, if
you are searching using *just* the start TDMR address, then the message
should only talk about the start address.  Also, it's not trying to find
a *node* per se.  It's trying to find a 'tmb'.  So, if someone wanted to
debug this problem, they would actually want to dump out the tmbs.

But, back to the loop that this message describes:

> +	/* Find the first memory region covered by the TDMR */
> +	list_for_each_entry(tmb, &tdx_memlist, list) {
> +		if (tmb->end_pfn > (tdmr_start(tdmr) >> PAGE_SHIFT))
> +			return tmb->nid;
> +	}

That loop is funky.  It's not obvious at *all* why it even works.

1. A 'tmb' describes "real" memory.  It never covers holes.
2. This code is trying to find *a* 'tmb' to place a structure in.  It
   needs real memory to place this, of course.
3. A 'tdmr' may include holes and may not have a 'tmb' at either its
   start or end address
4. A 'tdmr' is expected to cover one or more 'tmb's.  If there were no
   'tmb's, then the TDMR is going to be marked as all reserved and is
   effectively being wasted.
5. A 'tdmr' may cover more than one NUMA node.  If this happens, it is
   ok to get memory from any of those nodes for that tdmr's PAMT.

I'd include this comment on the loop:

	A TDMR must cover at least part of one TMB.  That TMB will end
	after the TDMR begins.  But, that TMB may have started before
	the TDMR.  Find the next 'tmb' that _ends_ after this TDMR
	begins.  Ignore 'tmb' start addresses.  They are irrelevant.

Maybe even a little ASCII diagram about the different tmb configurations
that this can find:

| TDMR1 | TDMR2 |
   |---tmb---|
          |tmb|
          |------tmb-------|
   |------tmb-------|

I'd also include this on the function:

/*
 * Locate a NUMA node which should hold the allocation of the @tdmr
 * PAMT.  This node will have some memory covered by the TDMR.  The
 * relative amount of memory covered is not considered.
 */


