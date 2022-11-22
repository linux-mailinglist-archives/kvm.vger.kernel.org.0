Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4C363326E
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 02:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbiKVBzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 20:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiKVBzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 20:55:39 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F981789F;
        Mon, 21 Nov 2022 17:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669082138; x=1700618138;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=UL9BppxMI7SvBsBmBhEJhMoMeo2j0emkQGnFT8j41tc=;
  b=CTYkIaboP5NmLGYQ3gx93W7IoJGNpCKsp+xJg4ALkwX9r2NhBqcG65Wh
   jDs3JDdrTSim1cmTA3c3DOYSohnsyUc4NMQ8KGmJe+A+3vg5q0xFdXL1s
   nAzmA5RZPr8lVc5Lp1PTqXIfkJjdLGgGYZmTM6S2SDvF4mRvj1rXRwpno
   YdBYhOKFxfysnA6zQ8W6ZK/QhQgpE7XY4LTi0EfNoBliJ71bpdbstEGNK
   CaZnZnPAomD8BC5L849TAuDjH3OBheBpbc113vJvJKYqqXOoL2U5+hTnu
   PZqegn6tU9BJqoUIZc63PaTt89t01rRYlawqSZkhy3YMpkaZmzXBxBzoK
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="311335513"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="311335513"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 17:55:26 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="730227673"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="730227673"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 17:55:22 -0800
From:   "Huang, Ying" <ying.huang@intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
References: <cover.1668988357.git.kai.huang@intel.com>
        <9b545148275b14a8c7edef1157f8ec44dc8116ee.1668988357.git.kai.huang@intel.com>
        <87cz9gvpej.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <a6ecf5f1a1202f428961a5f8422d5fff61ce1d9a.camel@intel.com>
Date:   Tue, 22 Nov 2022 09:54:25 +0800
In-Reply-To: <a6ecf5f1a1202f428961a5f8422d5fff61ce1d9a.camel@intel.com> (Kai
        Huang's message of "Mon, 21 Nov 2022 17:09:33 +0800")
Message-ID: <87sfibpxda.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Huang, Kai" <kai.huang@intel.com> writes:

[...]

>
>> > +
>> > +/*
>> > + * Add all memblock memory regions to the @tdx_memlist as TDX memory.
>> > + * Must be called when get_online_mems() is called by the caller.
>> > + */
>> > +static int build_tdx_memory(void)
>> > +{
>> > +   unsigned long start_pfn, end_pfn;
>> > +   int i, nid, ret;
>> > +
>> > +   for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
>> > +           /*
>> > +            * The first 1MB may not be reported as TDX convertible
>> > +            * memory.  Manually exclude them as TDX memory.
>> > +            *
>> > +            * This is fine as the first 1MB is already reserved in
>> > +            * reserve_real_mode() and won't end up to ZONE_DMA as
>> > +            * free page anyway.
>> > +            */
>> > +           start_pfn = max(start_pfn, (unsigned long)SZ_1M >> PAGE_SHIFT);
>> > +           if (start_pfn >= end_pfn)
>> > +                   continue;
>>
>> How about check whether first 1MB is reserved instead of depending on
>> the corresponding code isn't changed?  Via for_each_reserved_mem_range()?
>
> IIUC, some reserved memory can be freed to page allocator directly, i.e. kernel
> init code/data.  I feel it's not safe to just treat reserved memory will never
> be in page allocator.  Otherwise we have for_each_free_mem_range() can use.

Yes.  memblock reverse information isn't perfect.  But I still think
that it is still better than just assumption to check whether the frist
1MB is reserved in memblock.  Or, we can check whether the pages of the
first 1MB is reversed via checking struct page directly?

[...]

Best Regards,
Huang, Ying
