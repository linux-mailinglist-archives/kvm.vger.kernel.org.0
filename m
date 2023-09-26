Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD817AE3D2
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 04:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjIZC6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 22:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjIZC57 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 22:57:59 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE2B9F
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 19:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695697072; x=1727233072;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6Vlhpy7x58o2/+dG5U3wB6nifjQsA7018Vk9J5UoX0Y=;
  b=EEVbLjbCWEaBAg3g+8vn/unkSAtqbN+AMyxe+5ifynYRRCXdLY57lY0b
   8jNaW2LzHTgUOrNb88swh5f45a2XealV+D/uvvjNAs3o6k7f4d/p8JyEH
   Hghun0AWMZU0gYCI4SjG+Dn8FL7gR7AcIMLVRmR8varoQ5A6/o1XP+skj
   77qxQZ4T+9mcqn6PVH4AbTiHlfpOMu76HaKqHauWOfgWQ2NYOsGVUTgBN
   WzEuMlQFyjnmRCIWb8+IfODvUZr/oO0ptO8yR/hep26LJbPI13FyHpU8q
   VkxFSS69iJ1JdITF/o9jun0jWc1a9EN2rvoBQ++FuLJV1U71AQyL3kHeK
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="366527087"
X-IronPort-AV: E=Sophos;i="6.03,176,1694761200"; 
   d="scan'208";a="366527087"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 19:57:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="1079528082"
X-IronPort-AV: E=Sophos;i="6.03,176,1694761200"; 
   d="scan'208";a="1079528082"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmsmga005.fm.intel.com with ESMTP; 25 Sep 2023 19:57:47 -0700
Date:   Tue, 26 Sep 2023 11:08:55 +0800
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
Subject: Re: [PATCH v4 20/21] i386: Use CPUCacheInfo.share_level to encode
 CPUID[0x8000001D].EAX[bits 25:14]
Message-ID: <ZRJLR+9hpNCrHND8@liuzhao-OptiPlex-7080>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
 <20230914072159.1177582-21-zhao1.liu@linux.intel.com>
 <269b02c3-7abb-2fb1-959e-1441d3ecf07f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <269b02c3-7abb-2fb1-959e-1441d3ecf07f@amd.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 02:27:58PM -0500, Moger, Babu wrote:
> Date: Fri, 22 Sep 2023 14:27:58 -0500
> From: "Moger, Babu" <bmoger@amd.com>
> Subject: Re: [PATCH v4 20/21] i386: Use CPUCacheInfo.share_level to encode
>  CPUID[0x8000001D].EAX[bits 25:14]
> 
> 
> On 9/14/2023 2:21 AM, Zhao Liu wrote:
> > From: Zhao Liu <zhao1.liu@intel.com>
> > 
> > CPUID[0x8000001D].EAX[bits 25:14] NumSharingCache: number of logical
> > processors sharing cache.
> > 
> > The number of logical processors sharing this cache is
> > NumSharingCache + 1.
> > 
> > After cache models have topology information, we can use
> > CPUCacheInfo.share_level to decide which topology level to be encoded
> > into CPUID[0x8000001D].EAX[bits 25:14].
> > 
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> 
> Reviewed-by: Babu Moger <babu.moger@amd.com>

Thanks Babu!

-Zhao

> 
> 
> > ---
> > Changes since v3:
> >   * Explain what "CPUID[0x8000001D].EAX[bits 25:14]" means in the commit
> >     message. (Babu)
> > 
> > Changes since v1:
> >   * Use cache->share_level as the parameter in
> >     max_processor_ids_for_cache().
> > ---
> >   target/i386/cpu.c | 10 +---------
> >   1 file changed, 1 insertion(+), 9 deletions(-)
> > 
> > diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> > index bc28c59df089..3bed823dc3b7 100644
> > --- a/target/i386/cpu.c
> > +++ b/target/i386/cpu.c
> > @@ -482,20 +482,12 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
> >                                          uint32_t *eax, uint32_t *ebx,
> >                                          uint32_t *ecx, uint32_t *edx)
> >   {
> > -    uint32_t num_sharing_cache;
> >       assert(cache->size == cache->line_size * cache->associativity *
> >                             cache->partitions * cache->sets);
> >       *eax = CACHE_TYPE(cache->type) | CACHE_LEVEL(cache->level) |
> >                  (cache->self_init ? CACHE_SELF_INIT_LEVEL : 0);
> > -
> > -    /* L3 is shared among multiple cores */
> > -    if (cache->level == 3) {
> > -        num_sharing_cache = 1 << apicid_die_offset(topo_info);
> > -    } else {
> > -        num_sharing_cache = 1 << apicid_core_offset(topo_info);
> > -    }
> > -    *eax |= (num_sharing_cache - 1) << 14;
> > +    *eax |= max_processor_ids_for_cache(topo_info, cache->share_level) << 14;
> >       assert(cache->line_size > 0);
> >       assert(cache->partitions > 0);
