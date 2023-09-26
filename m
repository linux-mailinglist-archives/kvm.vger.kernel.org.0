Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7907AE3D7
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 04:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjIZC7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 22:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjIZC7b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 22:59:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501C09F
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 19:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695697165; x=1727233165;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Rn9ZAVdvw5aAJT0ZRX6eVmguRCBmW4htGGpT1cAptSY=;
  b=BRkKbBOdymY6OIQsR2UnFXYV9dd/oylifVgYjRzYBDR5AYBxhS8N54qy
   SgiU3C1wS9IyRNqaDfcZyoJJsCpues/pUX5g9ACDIKW4AErC7xSNvzSiz
   nRgXsHN2uxkEgj/s96dUqUmzEmvoPiWV2L2U4GUhiMk4hh2w/bOYzsEjI
   PjmpKGYoWY7hbpNCFTlfTavmuMO30xbRh4ay1WdRkQ9Ml3r2mcFq/irsg
   XUKS+ZI+zK8ZeyLrJMCYjC3l4gqR2UFwKOzOExuhMQegCdcS0jGAfAgs0
   frodic1amiSatwZ8jHL+b9MI3J7ibRIzdXSAm5VUNCU9tBULnI0LDeui3
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="384244000"
X-IronPort-AV: E=Sophos;i="6.03,176,1694761200"; 
   d="scan'208";a="384244000"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 19:59:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="864241897"
X-IronPort-AV: E=Sophos;i="6.03,176,1694761200"; 
   d="scan'208";a="864241897"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmsmga002.fm.intel.com with ESMTP; 25 Sep 2023 19:59:20 -0700
Date:   Tue, 26 Sep 2023 11:10:28 +0800
From:   Zhao Liu <zhao1.liu@linux.intel.com>
To:     Babu Moger <babu.moger@amd.com>
Cc:     Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v4 19/21] i386: Use offsets get NumSharingCache for
 CPUID[0x8000001D].EAX[bits 25:14]
Message-ID: <ZRJLpDmI8nBKsleY@liuzhao-OptiPlex-7080>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
 <20230914072159.1177582-20-zhao1.liu@linux.intel.com>
 <69d49658-07ca-e7e5-df2b-aec75f6652ff@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69d49658-07ca-e7e5-df2b-aec75f6652ff@amd.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 02:27:18PM -0500, Moger, Babu wrote:
> Date: Fri, 22 Sep 2023 14:27:18 -0500
> From: "Moger, Babu" <bmoger@amd.com>
> Subject: Re: [PATCH v4 19/21] i386: Use offsets get NumSharingCache for
>  CPUID[0x8000001D].EAX[bits 25:14]
> 
> 
> On 9/14/2023 2:21 AM, Zhao Liu wrote:
> > From: Zhao Liu <zhao1.liu@intel.com>
> > 
> > The commit 8f4202fb1080 ("i386: Populate AMD Processor Cache Information
> > for cpuid 0x8000001D") adds the cache topology for AMD CPU by encoding
> > the number of sharing threads directly.
> > 
> >  From AMD's APM, NumSharingCache (CPUID[0x8000001D].EAX[bits 25:14])
> > means [1]:
> > 
> > The number of logical processors sharing this cache is the value of
> > this field incremented by 1. To determine which logical processors are
> > sharing a cache, determine a Share Id for each processor as follows:
> > 
> > ShareId = LocalApicId >> log2(NumSharingCache+1)
> > 
> > Logical processors with the same ShareId then share a cache. If
> > NumSharingCache+1 is not a power of two, round it up to the next power
> > of two.
> > 
> >  From the description above, the calculation of this field should be same
> > as CPUID[4].EAX[bits 25:14] for Intel CPUs. So also use the offsets of
> > APIC ID to calculate this field.
> > 
> > [1]: APM, vol.3, appendix.E.4.15 Function 8000_001Dh--Cache Topology
> >       Information
> > 
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Reviewed-by: Babu Moger <babu.moger@amd.com>

Thanks Babu!

-Zhao

> > ---
> > Changes since v3:
> >   * Rewrite the subject. (Babu)
> >   * Delete the original "comment/help" expression, as this behavior is
> >     confirmed for AMD CPUs. (Babu)
> >   * Rename "num_apic_ids" (v3) to "num_sharing_cache" to match spec
> >     definition. (Babu)
> > 
> > Changes since v1:
> >   * Rename "l3_threads" to "num_apic_ids" in
> >     encode_cache_cpuid8000001d(). (Yanan)
> >   * Add the description of the original commit and add Cc.
> > ---
> >   target/i386/cpu.c | 10 ++++------
> >   1 file changed, 4 insertions(+), 6 deletions(-)
> > 
> > diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> > index 5d066107d6ce..bc28c59df089 100644
> > --- a/target/i386/cpu.c
> > +++ b/target/i386/cpu.c
> > @@ -482,7 +482,7 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
> >                                          uint32_t *eax, uint32_t *ebx,
> >                                          uint32_t *ecx, uint32_t *edx)
> >   {
> > -    uint32_t l3_threads;
> > +    uint32_t num_sharing_cache;
> >       assert(cache->size == cache->line_size * cache->associativity *
> >                             cache->partitions * cache->sets);
> > @@ -491,13 +491,11 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
> >       /* L3 is shared among multiple cores */
> >       if (cache->level == 3) {
> > -        l3_threads = topo_info->modules_per_die *
> > -                     topo_info->cores_per_module *
> > -                     topo_info->threads_per_core;
> > -        *eax |= (l3_threads - 1) << 14;
> > +        num_sharing_cache = 1 << apicid_die_offset(topo_info);
> >       } else {
> > -        *eax |= ((topo_info->threads_per_core - 1) << 14);
> > +        num_sharing_cache = 1 << apicid_core_offset(topo_info);
> >       }
> > +    *eax |= (num_sharing_cache - 1) << 14;
> >       assert(cache->line_size > 0);
> >       assert(cache->partitions > 0);
