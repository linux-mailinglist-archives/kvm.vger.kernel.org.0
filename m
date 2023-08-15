Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0275977C5FC
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 04:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbjHOChZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 22:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234362AbjHOChE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 22:37:04 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263E5199F;
        Mon, 14 Aug 2023 19:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692067006; x=1723603006;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=vHR4xYlNFY3QXhiHYYeRXBjOvyRCRyOZW2MYGLu5e4g=;
  b=EPjULpEffM5SU+WrlQqN6hxLVSv84hce+7H/6rOYi0G1yptoT5ZVZxP1
   Q6RCxWKPMT4eNHcgIB6U1mVBMk3Fq+Q9h+bcNHhi757cc0Cg3KccHOhFW
   PublBc4XRrG+HEEUXsG+1VaGoHd+QyWZMpoeUdK87eBp3XOyyAIJJZ9/W
   l6/hihaHOuGUv7PR17rka8V9g4TAWCYfs1MCHNYfpi+49B47/oBADvEzu
   iLOE7sIp31D3hV8/UyluSc0/bxQtEQWsSCFOL2ZAtqMzToLkeI1gtKbXL
   MB4pBi9HOTBTdJxyOOl2Y4fNR3t/RpoGsdqr3uvILC9q5tq78qU5AJ0Zp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="438525450"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="438525450"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2023 19:36:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="857275482"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="857275482"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga004.jf.intel.com with ESMTP; 14 Aug 2023 19:36:19 -0700
Date:   Tue, 15 Aug 2023 10:36:18 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, mike.kravetz@oracle.com,
        apopple@nvidia.com, jgg@nvidia.com, rppt@kernel.org,
        akpm@linux-foundation.org, kevin.tian@intel.com,
        Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [RFC PATCH v2 0/5] Reduce NUMA balance caused TLB-shootdowns in
 a VM
Message-ID: <20230815023618.uvefne3af7fn5msn@yy-desk-7060>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <41a893e1-f2e7-23f4-cad2-d5c353a336a3@redhat.com>
 <ZNSyzgyTxubo0g/D@yzhao56-desk.sh.intel.com>
 <6b48a161-257b-a02b-c483-87c04b655635@redhat.com>
 <1ad2c33d-95e1-49ec-acd2-ac02b506974e@nvidia.com>
 <846e9117-1f79-a5e0-1b14-3dba91ab8033@redhat.com>
 <d0ad2642-6d72-489e-91af-a7cb15e75a8a@nvidia.com>
 <ZNnvPuRUVsUl5umM@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZNnvPuRUVsUl5umM@yzhao56-desk.sh.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 14, 2023 at 05:09:18PM +0800, Yan Zhao wrote:
> On Fri, Aug 11, 2023 at 12:35:27PM -0700, John Hubbard wrote:
> > On 8/11/23 11:39, David Hildenbrand wrote:
> > ...
> > > > > Should we want to disable NUMA hinting for such VMAs instead (for example, by QEMU/hypervisor) that knows that any NUMA hinting activity on these ranges would be a complete waste of time? I recall that John H. once mentioned that there are
> > > > similar issues with GPU memory:  NUMA hinting is actually counter-productive and they end up disabling it.
> > > > >
> > > >
> > > > Yes, NUMA balancing is incredibly harmful to performance, for GPU and
> > > > accelerators that map memory...and VMs as well, it seems. Basically,
> > > > anything that has its own processors and page tables needs to be left
> > > > strictly alone by NUMA balancing. Because the kernel is (still, even
> > > > today) unaware of what those processors are doing, and so it has no way
> > > > to do productive NUMA balancing.
> > >
> > > Is there any existing way we could handle that better on a per-VMA level, or on the process level? Any magic toggles?
> > >
> > > MMF_HAS_PINNED might be too restrictive. MMF_HAS_PINNED_LONGTERM might be better, but with things like iouring still too restrictive eventually.
> > >
> > > I recall that setting a mempolicy could prevent auto-numa from getting active, but that might be undesired.
> > >
> > > CCing Mel.
> > >
> >
> > Let's discern between page pinning situations, and HMM-style situations.
> > Page pinning of CPU memory is unnecessary when setting up for using that
> > memory by modern GPUs or accelerators, because the latter can handle
> > replayable page faults. So for such cases, the pages are in use by a GPU
> > or accelerator, but unpinned.
> >
> > The performance problem occurs because for those pages, the NUMA
> > balancing causes unmapping, which generates callbacks to the device
> > driver, which dutifully unmaps the pages from the GPU or accelerator,
> > even if the GPU might be busy using those pages. The device promptly
> > causes a device page fault, and the driver then re-establishes the
> > device page table mapping, which is good until the next round of
> > unmapping from the NUMA balancer.
> >
> > hmm_range_fault()-based memory management in particular might benefit
> > from having NUMA balancing disabled entirely for the memremap_pages()
> > region, come to think of it. That seems relatively easy and clean at
> > first glance anyway.
> >
> > For other regions (allocated by the device driver), a per-VMA flag
> > seems about right: VM_NO_NUMA_BALANCING ?
> >
> Thanks a lot for those good suggestions!
> For VMs, when could a per-VMA flag be set?
> Might be hard in mmap() in QEMU because a VMA may not be used for DMA until
> after it's mapped into VFIO.
> Then, should VFIO set this flag on after it maps a range?
> Could this flag be unset after device hot-unplug?

Emm... syscall madvise() in my mind, it does things like change flags
on VMA, e.g madvise(MADV_DONTFORK) adds VM_DONTCOPY to the VMA.

>
>
