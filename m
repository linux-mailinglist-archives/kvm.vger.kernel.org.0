Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C03156A564
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 16:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbiGGO2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 10:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiGGO2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 10:28:44 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29622101F4;
        Thu,  7 Jul 2022 07:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657204123; x=1688740123;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lew5L0hGNEdLY7OPIiUC+eu2JioJ0wYpzwTmjdjpnes=;
  b=U5Ru64LGpnc0wjSm9dNqi0OizmYopDiAw+7j01KZuCzMm2qrjjyitjmP
   9PA87CxbPNyMrK9QV7sJ18ZFgCG0gjUWem6xlQGepEYrFhNBwY0g95uzk
   fZgWRCKCRecKZstoUGITtBNHiSqCOgu89IolBCfMJPrsRupjRXj8dET2b
   GViYTzcr7W5334WGB95D0rcd/EXzrmvm1quFdDNH2NZAdvNqadZRc6ncn
   qrwyWtO12uAEPUkZiti/DVGWsd6IImirO8lbDnuYeFDDta/di3WAJVsl7
   KivyHPCXGgnuH4xfT2X3TAxpUe1KAYFy3HwYBxGyh2bvXV4iW5HIwq5TS
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="263820686"
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="263820686"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 07:28:42 -0700
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="568539686"
Received: from nmajidi-mobl.amr.corp.intel.com (HELO [10.251.17.238]) ([10.251.17.238])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 07:28:41 -0700
Message-ID: <880f3991-09e5-2f96-d5ba-213cff05c458@intel.com>
Date:   Thu, 7 Jul 2022 07:26:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v5 12/22] x86/virt/tdx: Convert all memory regions in
 memblock to TDX memory
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
References: <cover.1655894131.git.kai.huang@intel.com>
 <8288396be7fedd10521a28531e138579594d757a.1655894131.git.kai.huang@intel.com>
 <20d63398-928f-0c6f-47ec-8e225c049ad8@intel.com>
 <76d7604ff21b26252733165478d5c54035d84d98.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <76d7604ff21b26252733165478d5c54035d84d98.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/26/22 23:16, Kai Huang wrote:
> On Fri, 2022-06-24 at 12:40 -0700, Dave Hansen wrote:
>>> +/*
>>> + * Walks over all memblock memory regions that are intended to be
>>> + * converted to TDX memory.  Essentially, it is all memblock memory
>>> + * regions excluding the low memory below 1MB.
>>> + *
>>> + * This is because on some TDX platforms the low memory below 1MB is
>>> + * not included in CMRs.  Excluding the low 1MB can still guarantee
>>> + * that the pages managed by the page allocator are always TDX memory,
>>> + * as the low 1MB is reserved during kernel boot and won't end up to
>>> + * the ZONE_DMA (see reserve_real_mode()).
>>> + */
>>> +#define memblock_for_each_tdx_mem_pfn_range(i, p_start, p_end, p_nid)	\
>>> +	for_each_mem_pfn_range(i, MAX_NUMNODES, p_start, p_end, p_nid)	\
>>> +		if (!pfn_range_skip_lowmem(p_start, p_end))
>>
>> Let's summarize where we are at this point:
>>
>> 1. All RAM is described in memblocks
>> 2. Some memblocks are reserved and some are free
>> 3. The lower 1MB is marked reserved
>> 4. for_each_mem_pfn_range() walks all reserved and free memblocks, so we
>>    have to exclude the lower 1MB as a special case.
>>
>> That seems superficially rather ridiculous.  Shouldn't we just pick a
>> memblock iterator that skips the 1MB?  Surely there is such a thing.
> 
> Perhaps you are suggesting we should always loop the _free_ ranges so we don't
> need to care about the first 1MB which is reserved?
> 
> The problem is some reserved memory regions are actually later freed to the page
> allocator, for example, initrd.  So to cover all those 'late-freed-reserved-
> regions', I used for_each_mem_pfn_range(), instead of for_each_free_mem_range().

Why not just entirely remove the lower 1MB from the memblock structure
on TDX systems?  Do something equivalent to adding this on the kernel
command line:

	memmap=1M$0x0

> Btw, I do have a checkpatch warning around this code:
> 
> ERROR: Macros with complex values should be enclosed in parentheses
> #109: FILE: arch/x86/virt/vmx/tdx/tdx.c:377:
> +#define memblock_for_each_tdx_mem_pfn_range(i, p_start, p_end, p_nid)	\
> +	for_each_mem_pfn_range(i, MAX_NUMNODES, p_start, p_end, p_nid)	\
> +		if (!pfn_range_skip_lowmem(p_start, p_end))
> 
> But it looks like a false positive to me.

I think it doesn't like the if().
