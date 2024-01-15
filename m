Return-Path: <kvm+bounces-6178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1330982D352
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 04:28:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E6131C20A85
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 03:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 447ED1C3D;
	Mon, 15 Jan 2024 03:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l+A+3n21"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D3C17F6
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 03:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705289278; x=1736825278;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=h0AIxX4bVDy0l8YfQsX/WdUgJCNRwHm4F00ykNVLXuc=;
  b=l+A+3n21mHC/j4Nl5d5N4/9iXHlkMiDX6YOGn4zL2fh2Yq8x8lfyvTBh
   OM7j0UydYv2S29Sg74CyVwGQmXqbLGz6JySZz26W1OZrIO6sLhEC6ROJX
   8me7fUd7XmV3+h3zNOpThie6ES4fTRCvEfS6WEv2f6pWMS/V+H2ya/x/0
   xrph1xSTI6RW72dOQMDSqxfZolxMpmraxMCVvLQ6bkcARqZouv+3+n1PH
   uYzdzyZrnkEwIzd/wjd/oYEIAUA+7YD91T/Wj2uLkvyswDLiSmIzKhni7
   pUDj8cTW8GgAz4CFDNUdHl5twlV8/rI4U3lGYdBpF0vTG4W/aPz/Z9An0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="21000745"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="21000745"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 19:27:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="956706335"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="956706335"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 14 Jan 2024 19:27:52 -0800
Date: Mon, 15 Jan 2024 11:40:50 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>, Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH v7 14/16] i386: Use CPUCacheInfo.share_level to encode
 CPUID[4]
Message-ID: <ZaSpQuQxU5UrbIf4@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-15-zhao1.liu@linux.intel.com>
 <a0cd67f2-94f2-4c4b-9212-6b7344163660@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0cd67f2-94f2-4c4b-9212-6b7344163660@intel.com>

Hi Xiaoyao,

On Sun, Jan 14, 2024 at 10:31:50PM +0800, Xiaoyao Li wrote:
> Date: Sun, 14 Jan 2024 22:31:50 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH v7 14/16] i386: Use CPUCacheInfo.share_level to encode
>  CPUID[4]
> 
> On 1/8/2024 4:27 PM, Zhao Liu wrote:
> > From: Zhao Liu <zhao1.liu@intel.com>
> > 
> > CPUID[4].EAX[bits 25:14] is used to represent the cache topology for
> > Intel CPUs.
> > 
> > After cache models have topology information, we can use
> > CPUCacheInfo.share_level to decide which topology level to be encoded
> > into CPUID[4].EAX[bits 25:14].
> > 
> > And since maximum_processor_id (original "num_apic_ids") is parsed
> > based on cpu topology levels, which are verified when parsing smp, it's
> > no need to check this value by "assert(num_apic_ids > 0)" again, so
> > remove this assert.
> > 
> > Additionally, wrap the encoding of CPUID[4].EAX[bits 31:26] into a
> > helper to make the code cleaner.
> > 
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > Tested-by: Babu Moger <babu.moger@amd.com>
> > Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > Changes since v1:
> >   * Use "enum CPUTopoLevel share_level" as the parameter in
> >     max_processor_ids_for_cache().
> >   * Make cache_into_passthrough case also use
> >     max_processor_ids_for_cache() and max_core_ids_in_package() to
> >     encode CPUID[4]. (Yanan)
> >   * Rename the title of this patch (the original is "i386: Use
> >     CPUCacheInfo.share_level to encode CPUID[4].EAX[bits 25:14]").
> > ---
> >   target/i386/cpu.c | 70 +++++++++++++++++++++++++++++------------------
> >   1 file changed, 43 insertions(+), 27 deletions(-)
> > 
> > diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> > index 81e07474acef..b23e8190dc68 100644
> > --- a/target/i386/cpu.c
> > +++ b/target/i386/cpu.c
> > @@ -235,22 +235,53 @@ static uint8_t cpuid2_cache_descriptor(CPUCacheInfo *cache)
> >                          ((t) == UNIFIED_CACHE) ? CACHE_TYPE_UNIFIED : \
> >                          0 /* Invalid value */)
> > +static uint32_t max_processor_ids_for_cache(X86CPUTopoInfo *topo_info,
> > +                                            enum CPUTopoLevel share_level)
> 
> I prefer the name to max_lp_ids_share_the_cache()

Yes, lp is more accurate.

> 
> > +{
> > +    uint32_t num_ids = 0;
> > +
> > +    switch (share_level) {
> > +    case CPU_TOPO_LEVEL_CORE:
> > +        num_ids = 1 << apicid_core_offset(topo_info);
> > +        break;
> > +    case CPU_TOPO_LEVEL_DIE:
> > +        num_ids = 1 << apicid_die_offset(topo_info);
> > +        break;
> > +    case CPU_TOPO_LEVEL_PACKAGE:
> > +        num_ids = 1 << apicid_pkg_offset(topo_info);
> > +        break;
> > +    default:
> > +        /*
> > +         * Currently there is no use case for SMT and MODULE, so use
> > +         * assert directly to facilitate debugging.
> > +         */
> > +        g_assert_not_reached();
> > +    }
> > +
> > +    return num_ids - 1;
> 
> suggest to just return num_ids, and let the caller to do the -1 work.

Emm, SDM calls the whole "num_ids - 1" (CPUID.0x4.EAX[bits 14-25]) as
"maximum number of addressable IDs for logical processors sharing this
cache"...

So if this helper just names "num_ids" as max_lp_ids_share_the_cache,
I'm not sure there would be ambiguity here?

> 
> > +}
> > +
> > +static uint32_t max_core_ids_in_package(X86CPUTopoInfo *topo_info)
> > +{
> > +    uint32_t num_cores = 1 << (apicid_pkg_offset(topo_info) -
> > +                               apicid_core_offset(topo_info));
> > +    return num_cores - 1;
> 
> ditto.
> 
> > +}
> >   /* Encode cache info for CPUID[4] */
> >   static void encode_cache_cpuid4(CPUCacheInfo *cache,
> > -                                int num_apic_ids, int num_cores,
> > +                                X86CPUTopoInfo *topo_info,
> >                                   uint32_t *eax, uint32_t *ebx,
> >                                   uint32_t *ecx, uint32_t *edx)
> >   {
> >       assert(cache->size == cache->line_size * cache->associativity *
> >                             cache->partitions * cache->sets);
> > -    assert(num_apic_ids > 0);
> >       *eax = CACHE_TYPE(cache->type) |
> >              CACHE_LEVEL(cache->level) |
> >              (cache->self_init ? CACHE_SELF_INIT_LEVEL : 0) |
> > -           ((num_cores - 1) << 26) |
> > -           ((num_apic_ids - 1) << 14);
> > +           (max_core_ids_in_package(topo_info) << 26) |
> > +           (max_processor_ids_for_cache(topo_info, cache->share_level) << 14);
> 
> by the way, we can change the order of the two line. :)

Yes!

Thanks,
Zhao

> 
> >       assert(cache->line_size > 0);
> >       assert(cache->partitions > 0);
> > @@ -6263,56 +6294,41 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
> >                   int host_vcpus_per_cache = 1 + ((*eax & 0x3FFC000) >> 14);
> >                   if (cores_per_pkg > 1) {
> > -                    int addressable_cores_offset =
> > -                                                apicid_pkg_offset(&topo_info) -
> > -                                                apicid_core_offset(&topo_info);
> > -
> >                       *eax &= ~0xFC000000;
> > -                    *eax |= (1 << (addressable_cores_offset - 1)) << 26;
> > +                    *eax |= max_core_ids_in_package(&topo_info) << 26;
> >                   }
> >                   if (host_vcpus_per_cache > cpus_per_pkg) {
> > -                    int pkg_offset = apicid_pkg_offset(&topo_info);
> > -
> >                       *eax &= ~0x3FFC000;
> > -                    *eax |= (1 << (pkg_offset - 1)) << 14;
> > +                    *eax |=
> > +                        max_processor_ids_for_cache(&topo_info,
> > +                                                CPU_TOPO_LEVEL_PACKAGE) << 14;
> >                   }
> >               }
> >           } else if (cpu->vendor_cpuid_only && IS_AMD_CPU(env)) {
> >               *eax = *ebx = *ecx = *edx = 0;
> >           } else {
> >               *eax = 0;
> > -            int addressable_cores_offset = apicid_pkg_offset(&topo_info) -
> > -                                           apicid_core_offset(&topo_info);
> > -            int core_offset, die_offset;
> >               switch (count) {
> >               case 0: /* L1 dcache info */
> > -                core_offset = apicid_core_offset(&topo_info);
> >                   encode_cache_cpuid4(env->cache_info_cpuid4.l1d_cache,
> > -                                    (1 << core_offset),
> > -                                    (1 << addressable_cores_offset),
> > +                                    &topo_info,
> >                                       eax, ebx, ecx, edx);
> >                   break;
> >               case 1: /* L1 icache info */
> > -                core_offset = apicid_core_offset(&topo_info);
> >                   encode_cache_cpuid4(env->cache_info_cpuid4.l1i_cache,
> > -                                    (1 << core_offset),
> > -                                    (1 << addressable_cores_offset),
> > +                                    &topo_info,
> >                                       eax, ebx, ecx, edx);
> >                   break;
> >               case 2: /* L2 cache info */
> > -                core_offset = apicid_core_offset(&topo_info);
> >                   encode_cache_cpuid4(env->cache_info_cpuid4.l2_cache,
> > -                                    (1 << core_offset),
> > -                                    (1 << addressable_cores_offset),
> > +                                    &topo_info,
> >                                       eax, ebx, ecx, edx);
> >                   break;
> >               case 3: /* L3 cache info */
> > -                die_offset = apicid_die_offset(&topo_info);
> >                   if (cpu->enable_l3_cache) {
> >                       encode_cache_cpuid4(env->cache_info_cpuid4.l3_cache,
> > -                                        (1 << die_offset),
> > -                                        (1 << addressable_cores_offset),
> > +                                        &topo_info,
> >                                           eax, ebx, ecx, edx);
> >                       break;
> >                   }
> 

