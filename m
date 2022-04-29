Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89328514C9D
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 16:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377133AbiD2OX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 10:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355718AbiD2OXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 10:23:25 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6C72BCF;
        Fri, 29 Apr 2022 07:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651242007; x=1682778007;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/bGhVKHoEh7eHUDyaw5m0yQ3oS5lWEnkoQ/GQvJerek=;
  b=c9ITCokXFmq+Z7NsDa4qGXrnaYFJUNENfuVWSnu02Jz0jUGrAfCwCpYV
   xIrPgShsbJIaATPpKxMkxXkBglePDJyFCHT3sSRpSzwMrEWau0SGBS4Ha
   J0yg9LXf4468CC2PT3YA0cruM7tBgVmyyUJBujwiBVbbHQEAobIWC5VhN
   7697wGuM1eAeW2lySAtkfoQVw9h+puGkoPXiiYkRue/GAd6FNjYEFVW7E
   fHguXUiH2ucqFhZeiiDZ718k4fw2jSlYKE4Q/3p20V1KpjkrZg2qaG2xy
   ya/n2VUXy0srFexolBZIpOwqhq5P33j17YEQn4UynEVd3ch2YK/jxYwdr
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="329600105"
X-IronPort-AV: E=Sophos;i="5.91,185,1647327600"; 
   d="scan'208";a="329600105"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 07:20:06 -0700
X-IronPort-AV: E=Sophos;i="5.91,185,1647327600"; 
   d="scan'208";a="582148551"
Received: from jinggu-mobl1.amr.corp.intel.com (HELO [10.212.30.227]) ([10.212.30.227])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 07:20:05 -0700
Message-ID: <5984b61f-6a4a-c12a-944d-f4a78bdefc3d@intel.com>
Date:   Fri, 29 Apr 2022 07:20:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 13/21] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <ffc2eefdd212a31278978e8bfccd571355db69b0.1649219184.git.kai.huang@intel.com>
 <c9b17e50-e665-3fc6-be8c-5bb16afa784e@intel.com>
 <3664ab2a8e0b0fcbb4b048b5c3aa5a6e85f9618a.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <3664ab2a8e0b0fcbb4b048b5c3aa5a6e85f9618a.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 00:46, Kai Huang wrote:
> On Thu, 2022-04-28 at 10:12 -0700, Dave Hansen wrote:
>> This is also a good place to note the downsides of using
>> alloc_contig_pages().
> 
> For instance:
> 
> 	The allocation may fail when memory usage is under pressure.

It's not really memory pressure, though.  The larger the allocation, the
more likely it is to fail.  The more likely it is that the kernel can't
free the memory or that if you need 1GB of contiguous memory that
999.996MB gets freed, but there is one stubborn page left.

alloc_contig_pages() can and will fail.  The only mitigation which is
guaranteed to avoid this is doing the allocation at boot.  But, you're
not doing that to avoid wasting memory on every TDX system that doesn't
use TDX.

A *good* way (although not foolproof) is to launch a TDX VM early in
boot before memory gets fragmented or consumed.  You might even want to
recommend this in the documentation.

>>> +/*
>>> + * Locate the NUMA node containing the start of the given TDMR's first
>>> + * RAM entry.  The given TDMR may also cover memory in other NUMA nodes.
>>> + */
>>
>> Please add a sentence or two on the implications here of what this means
>> when it happens.  Also, the joining of e820 regions seems like it might
>> span NUMA nodes.  What prevents that code from just creating one large
>> e820 area that leads to one large TDMR and horrible NUMA affinity for
>> these structures?
> 
> How about adding:
> 
> 	When TDMR is created, it stops spanning at NUAM boundary.

I actually don't know what that means at all.  I was thinking of
something like this.

/*
 * Pick a NUMA node on which to allocate this TDMR's metadata.
 *
 * This is imprecise since TDMRs are 1GB aligned and NUMA nodes might
 * not be.  If the TDMR covers more than one node, just use the _first_
 * one.  This can lead to small areas of off-node metadata for some
 * memory.
 */

>>> +static int tdmr_get_nid(struct tdmr_info *tdmr)
>>> +{
>>> +	u64 start, end;
>>> +	int i;
>>> +
>>> +	/* Find the first RAM entry covered by the TDMR */

There's something else missing in here.  Why not just do:

	return phys_to_target_node(TDMR_START(tdmr));

This would explain it:

	/*
	 * The beginning of the TDMR might not point to RAM.
	 * Find its first RAM address which which its node can
	 * be found.
	 */

>>> +	e820_for_each_mem(i, start, end)
>>> +		if (end > TDMR_START(tdmr))
>>> +			break;
>>
>> Brackets around the big loop, please.
> 
> OK.
> 
>>
>>> +	/*
>>> +	 * One TDMR must cover at least one (or partial) RAM entry,
>>> +	 * otherwise it is kernel bug.  WARN_ON() in this case.
>>> +	 */
>>> +	if (WARN_ON_ONCE((start >= end) || start >= TDMR_END(tdmr)))
>>> +		return 0;

This really means "no RAM found for this TDMR", right?  Can we say that,
please.


>>> +	/*
>>> +	 * Allocate one chunk of physically contiguous memory for all
>>> +	 * PAMTs.  This helps minimize the PAMT's use of reserved areas
>>> +	 * in overlapped TDMRs.
>>> +	 */
>>
>> Ahh, this explains it.  Considering that tdmr_get_pamt_sz() is really
>> just two lines of code, I'd probably just the helper and open-code it
>> here.  Then you only have one place to comment on it.
> 
> It has a loop and internally calls __tdmr_get_pamt_sz().  It looks doesn't fit
> if we open-code it here.
> 
> How about move this comment to tdmr_get_pamt_sz()?

I thought about that.  But tdmr_get_pamt_sz() isn't itself doing any
allocation so it doesn't make a whole lot of logical sense.  This is a
place where a helper _can_ be removed.  Remove it, please.
