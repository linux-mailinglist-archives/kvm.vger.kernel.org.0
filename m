Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E42636F3B
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 01:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiKXAsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 19:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiKXAs3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 19:48:29 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C70ED723;
        Wed, 23 Nov 2022 16:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669250896; x=1700786896;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=aTDswLwxnrT1m4Bb2RWu3He8hrN2rQUrmQl5QgIYb3c=;
  b=iKJvu7fLirYeMGa5TtlgVuOTLcV4M7muj9TK0i22nuHTcHEPlqu56yJ9
   u4582E2Wxt036y7+5ae4JiA5q0EHfPab8eV5m2VC8LIuz5i23Q/X6qcif
   3aEoE3pzLegAnLS0VBT2JRyBvv07B8IFBt02R/NuYvjxYcwDnI/+1AGvK
   raRoBTv3nrmZRm1u02fwNVqfWMaKcd3+2mkcUv+FADP6YtYK6MkA8zWGh
   h4//lw3RdXS3WjRvYACG1Ke1CzP45CfL/B70Satxy9/kq36+4KwrpCwGW
   wGa3POT9KcvlCH6Hhk/dMIvVG/H8nylanoNGSJ+7JxwkHL2MxT3b8TIZV
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="293892611"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="293892611"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 16:48:16 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="673057198"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="673057198"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 16:48:11 -0800
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
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
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
        <87sfibpxda.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <973ca04b3323d28a31dbc1cfeb52bd10bd9d9bf3.camel@intel.com>
Date:   Thu, 24 Nov 2022 08:47:07 +0800
In-Reply-To: <973ca04b3323d28a31dbc1cfeb52bd10bd9d9bf3.camel@intel.com> (Kai
        Huang's message of "Tue, 22 Nov 2022 17:16:11 +0800")
Message-ID: <87o7sxp4ac.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Huang, Kai" <kai.huang@intel.com> writes:

>> > > > +/*
>> > > > + * Add all memblock memory regions to the @tdx_memlist as TDX memory.
>> > > > + * Must be called when get_online_mems() is called by the caller.
>> > > > + */
>> > > > +static int build_tdx_memory(void)
>> > > > +{
>> > > > +   unsigned long start_pfn, end_pfn;
>> > > > +   int i, nid, ret;
>> > > > +
>> > > > +   for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
>> > > > +           /*
>> > > > +            * The first 1MB may not be reported as TDX convertible
>> > > > +            * memory.  Manually exclude them as TDX memory.
>> > > > +            *
>> > > > +            * This is fine as the first 1MB is already reserved in
>> > > > +            * reserve_real_mode() and won't end up to ZONE_DMA as
>> > > > +            * free page anyway.
>> > > > +            */
>> > > > +           start_pfn = max(start_pfn, (unsigned long)SZ_1M >> PAGE_SHIFT);
>> > > > +           if (start_pfn >= end_pfn)
>> > > > +                   continue;
>> > >
>> > > How about check whether first 1MB is reserved instead of depending on
>> > > the corresponding code isn't changed?  Via for_each_reserved_mem_range()?
>> >
>> > IIUC, some reserved memory can be freed to page allocator directly, i.e. kernel
>> > init code/data.  I feel it's not safe to just treat reserved memory will never
>> > be in page allocator.  Otherwise we have for_each_free_mem_range() can use.
>>
>> Yes.  memblock reverse information isn't perfect.  But I still think
>> that it is still better than just assumption to check whether the frist
>> 1MB is reserved in memblock.  Or, we can check whether the pages of the
>> first 1MB is reversed via checking struct page directly?
>>
>
> Sorry I am a little bit confused what you want to achieve here.  Do you want to
> make some sanity check to make sure the first 1MB is indeed not in the page
> allocator?
>
> IIUC, it is indeed true.  Please see the comment of calling reserve_real_mode()
> in setup_arch().  Also please see efi_free_boot_services(), which doesn't free
> the boot service if it is below 1MB.
>
> Also, my understanding is kernel's intention is to always reserve the first 1MB:
>
>                 /*
>                  * Don't free memory under 1M for two reasons:
>                  * - BIOS might clobber it
>                  * - Crash kernel needs it to be reserved
>                  */
>
> So if any page in first 1MB ended up to the page allocator, it should be the
> kernel bug which is not related to TDX, correct?

I suggest to add some code to verify this.  It's possible for the code
to be changed in the future (although possibility is low).  And TDX may
not be changed at the same time.  Then the verifying code here can catch
that.  So, we can make change accordingly.

Best Regards,
Huang, Ying
