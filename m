Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B7B514354
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 09:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355213AbiD2HgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 03:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240036AbiD2HgI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 03:36:08 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32ABABB920;
        Fri, 29 Apr 2022 00:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651217571; x=1682753571;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mn9ARlY9krQIfBg1PVBLFG/gRz7xnpPRY0TWUhRtXmI=;
  b=RSMuWVitJDn87zN3Wi4xV/dS4cZSpcEeoN4xxhWRDS03uNMpTn4EWSSK
   yJ2U6sKPwfky9gtTpK9UU2q8h0YhK/spWbLmR7MfztwAdrQK1MjQseC+c
   Ez68cx0h2CQinkXWrvSRWpJRzzBQRnt9Yf1UQJyetkDq9MtyaR6YeesgR
   1zqN7erfb4mrwyXe1PBrP6i+T7dGDvYHrQo8oXtFfIJhraZRSn+XAee9l
   1cQ8b2EzuIjhqBtjz84DscYu9qMvbKk7tXg4h+p5tPlUjYukiBZCvQeM5
   DlJdW6y5ZEOW4FMIv7OlIVc5CqLk8pk8rX9MXCqyY/T8hJy6IXWlhjj8w
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="253945719"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="253945719"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 00:32:50 -0700
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="597211645"
Received: from jenegret-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.59.236])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 00:32:47 -0700
Message-ID: <ddba6e9e284e3a4b4d04ea4cf552822973181c40.camel@intel.com>
Subject: Re: [PATCH v3 11/21] x86/virt/tdx: Choose to use all system RAM as
 TDX memory
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Fri, 29 Apr 2022 19:32:45 +1200
In-Reply-To: <37ba3fa2-06a1-9fd1-a158-d56d2453b30c@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <dee8fb1cc2ab79cf80d4718405069715b0d51235.1649219184.git.kai.huang@intel.com>
         <37ba3fa2-06a1-9fd1-a158-d56d2453b30c@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-28 at 08:54 -0700, Dave Hansen wrote:
> On 4/5/22 21:49, Kai Huang wrote:
> > As one step of initializing the TDX module, the memory regions that the
> > TDX module can use must be configured to it via an array of 'TD Memory
> 
> "can use must be"?

"can use" applies to "the TDX module".  "must be" applies to "the memory
regions".  

Sorry for bad english.  Yes it's not good.  I'll use your words suggested in
another patch:

	The kernel configures TDX-usable memory regions by passing an
	array of "TD Memory Regions" (TDMRs) to the TDX module.

> 
> > Regions' (TDMR).  The kernel is responsible for choosing which memory
> > regions to be used as TDX memory and building the array of TDMRs to
> > cover those memory regions.
> > 
> > The first generation of TDX-capable platforms basically guarantees all
> > system RAM regions during machine boot are Convertible Memory Regions
> > (excluding the memory below 1MB) and can be used by TDX.  The memory
> > pages allocated to TD guests can be any pages managed by the page
> > allocator.  To avoid having to modify the page allocator to distinguish
> > TDX and non-TDX memory allocation, adopt a simple policy to use all
> > system RAM regions as TDX memory.  The low 1MB pages are excluded from
> > TDX memory since they are not in CMRs in some platforms (those pages are
> > reserved at boot time and won't be managed by page allocator anyway).
> > 
> > This policy could be revised later if future TDX generations break
> > the guarantee or when the size of the metadata (~1/256th of the size of
> > the TDX usable memory) becomes a concern.  At that time a CMR-aware
> > page allocator may be necessary.
> 
> Remember that you have basically three or four short sentences to get a
> reviewer's attention.  There's a lot of noise in that changelog.  Can
> you trim it down or at least make the first bit less jargon-packed and
> more readable?
> 
> > Also, on the first generation of TDX-capable machine, the system RAM
> > ranges discovered during boot time are all memory regions that kernel
> > can use during its runtime.  This is because the first generation of TDX
> > architecturally doesn't support ACPI memory hotplug 
> 
> "Architecturally" usually means: written down and agreed to by hardware
> and software alike.  Is this truly written down somewhere?  I don't
> recall seeing it in the architecture documents.
> 
> I fear this is almost the _opposite_ of architecture: it's basically a
> fortunate coincidence.
> 
> > (CMRs are generated
> > during machine boot and are static during machine's runtime).  Also, the
> > first generation of TDX-capable platform doesn't support TDX and ACPI
> > memory hotplug at the same time on a single machine.  Another case of
> > memory hotplug is user may use NVDIMM as system RAM via kmem driver.
> > But the first generation of TDX-capable machine doesn't support TDX and
> > NVDIMM simultaneously, therefore in practice it cannot happen.  One
> > special case is user may use 'memmap' kernel command line to reserve
> > part of system RAM as x86 legacy PMEMs, and user can theoretically add
> > them as system RAM via kmem driver.  This can be resolved by always
> > treating legacy PMEMs as TDX memory.
> 
> Again, there's a ton of noise here.  I'm struggling to get the point.
> 
> > Implement a helper to loop over all RAM entries in e820 table to find
> > all system RAM ranges, as a preparation to covert all of them to TDX
> > memory.  Use 'e820_table', rather than 'e820_table_firmware' to honor
> > 'mem' and 'memmap' command lines. 
> 
> *How* does this honor them?  For instance, if I do mem=4G, will the TDX
> code limit itself to converting 4GB for TDX?

Yes.

> 
> > Following e820__memblock_setup(),
> > both E820_TYPE_RAM and E820_TYPE_RESERVED_KERN types are treated as TDX
> > memory, and contiguous ranges in the same NUMA node are merged together.
> 
> Again, you're just rehashing the code's logic in English.  That's not
> what a changelog is for.

Sorry you are right.

I'll address rest of your comments after we settle memory hotplug handling
discussion.

Thanks!



-- 
Thanks,
-Kai


