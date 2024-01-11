Return-Path: <kvm+bounces-6060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D511C82A9C1
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 09:54:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0AA0AB24A4A
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 08:54:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22BAC11C85;
	Thu, 11 Jan 2024 08:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Luy1IRe7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F32811719
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 08:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704963251; x=1736499251;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SLxjjko8qKGRdIGBrm/PZpmWi4YJzLg3fbqCblM3LrI=;
  b=Luy1IRe7vT83ndWu7IYNjwG3qPd6IvFQdJaXw4ndds+qfLmnafMaV13I
   jHtQwSTsezMJ+IYzW3gYvL3hMMzspz4V73CpiJJkScInPqi6avNSjDxUL
   teu+Cw7zyB+jEaPdKqilPX5tuN6h1bbfKGaNcaGP/EAm4u5ufzPBDK8lQ
   bntdDJXelUhXI0SBbYs7Gcw1lekZ9LQqGujhwkKG5pdB509IU/PuFZ6qQ
   xXu4XS35Ne2InrRL72d5kdrADbzXNNuXuVCrGsUBu4/19sdwsCEdQqQBo
   BtP7usji9zFMWTlGlEgzEfgqD85Zwx8OFb023BS7P/oMUucqbRhI5YTpg
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10949"; a="397657378"
X-IronPort-AV: E=Sophos;i="6.04,185,1695711600"; 
   d="scan'208";a="397657378"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 00:54:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10949"; a="852886314"
X-IronPort-AV: E=Sophos;i="6.04,185,1695711600"; 
   d="scan'208";a="852886314"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmsmga004.fm.intel.com with ESMTP; 11 Jan 2024 00:54:07 -0800
Date: Thu, 11 Jan 2024 17:07:03 +0800
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
Subject: Re: [PATCH v7 05/16] i386: Decouple CPUID[0x1F] subleaf with
 specific topology level
Message-ID: <ZZ+vt/JxXaAgdl9d@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-6-zhao1.liu@linux.intel.com>
 <cb75fcea-7e3a-4062-8d1c-3067f5e53bcc@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb75fcea-7e3a-4062-8d1c-3067f5e53bcc@intel.com>

Hi Xiaoyao,

On Thu, Jan 11, 2024 at 11:19:34AM +0800, Xiaoyao Li wrote:
> Date: Thu, 11 Jan 2024 11:19:34 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH v7 05/16] i386: Decouple CPUID[0x1F] subleaf with
>  specific topology level
> 
> On 1/8/2024 4:27 PM, Zhao Liu wrote:
> > From: Zhao Liu <zhao1.liu@intel.com>
> > 
> > At present, the subleaf 0x02 of CPUID[0x1F] is bound to the "die" level.
> > 
> > In fact, the specific topology level exposed in 0x1F depends on the
> > platform's support for extension levels (module, tile and die).
> > 
> > To help expose "module" level in 0x1F, decouple CPUID[0x1F] subleaf
> > with specific topology level.
> > 
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > Tested-by: Babu Moger <babu.moger@amd.com>
> > Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > Changes since v3:
> >   * New patch to prepare to expose module level in 0x1F.
> >   * Move the CPUTopoLevel enumeration definition from "i386: Add cache
> >     topology info in CPUCacheInfo" to this patch. Note, to align with
> >     topology types in SDM, revert the name of CPU_TOPO_LEVEL_UNKNOW to
> >     CPU_TOPO_LEVEL_INVALID.
> > ---
> >   target/i386/cpu.c | 136 +++++++++++++++++++++++++++++++++++++---------
> >   target/i386/cpu.h |  15 +++++
> >   2 files changed, 126 insertions(+), 25 deletions(-)
> > 
> > diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> > index bc440477d13d..5c295c9a9e2d 100644
> > --- a/target/i386/cpu.c
> > +++ b/target/i386/cpu.c
> > @@ -269,6 +269,116 @@ static void encode_cache_cpuid4(CPUCacheInfo *cache,
> >              (cache->complex_indexing ? CACHE_COMPLEX_IDX : 0);
> >   }
> > +static uint32_t num_cpus_by_topo_level(X86CPUTopoInfo *topo_info,
> > +                                       enum CPUTopoLevel topo_level)
> > +{
> > +    switch (topo_level) {
> > +    case CPU_TOPO_LEVEL_SMT:
> > +        return 1;
> > +    case CPU_TOPO_LEVEL_CORE:
> > +        return topo_info->threads_per_core;
> > +    case CPU_TOPO_LEVEL_DIE:
> > +        return topo_info->threads_per_core * topo_info->cores_per_die;
> > +    case CPU_TOPO_LEVEL_PACKAGE:
> > +        return topo_info->threads_per_core * topo_info->cores_per_die *
> > +               topo_info->dies_per_pkg;
> > +    default:
> > +        g_assert_not_reached();
> > +    }
> > +    return 0;
> > +}
> > +
> > +static uint32_t apicid_offset_by_topo_level(X86CPUTopoInfo *topo_info,
> > +                                            enum CPUTopoLevel topo_level)
> > +{
> > +    switch (topo_level) {
> > +    case CPU_TOPO_LEVEL_SMT:
> > +        return 0;
> > +    case CPU_TOPO_LEVEL_CORE:
> > +        return apicid_core_offset(topo_info);
> > +    case CPU_TOPO_LEVEL_DIE:
> > +        return apicid_die_offset(topo_info);
> > +    case CPU_TOPO_LEVEL_PACKAGE:
> > +        return apicid_pkg_offset(topo_info);
> > +    default:
> > +        g_assert_not_reached();
> > +    }
> > +    return 0;
> > +}
> > +
> > +static uint32_t cpuid1f_topo_type(enum CPUTopoLevel topo_level)
> > +{
> > +    switch (topo_level) {
> > +    case CPU_TOPO_LEVEL_INVALID:
> > +        return CPUID_1F_ECX_TOPO_LEVEL_INVALID;
> > +    case CPU_TOPO_LEVEL_SMT:
> > +        return CPUID_1F_ECX_TOPO_LEVEL_SMT;
> > +    case CPU_TOPO_LEVEL_CORE:
> > +        return CPUID_1F_ECX_TOPO_LEVEL_CORE;
> > +    case CPU_TOPO_LEVEL_DIE:
> > +        return CPUID_1F_ECX_TOPO_LEVEL_DIE;
> > +    default:
> > +        /* Other types are not supported in QEMU. */
> > +        g_assert_not_reached();
> > +    }
> > +    return 0;
> > +}
> > +
> > +static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
> > +                                X86CPUTopoInfo *topo_info,
> > +                                uint32_t *eax, uint32_t *ebx,
> > +                                uint32_t *ecx, uint32_t *edx)
> > +{
> > +    static DECLARE_BITMAP(topo_bitmap, CPU_TOPO_LEVEL_MAX);
> > +    X86CPU *cpu = env_archcpu(env);
> > +    unsigned long level, next_level;
> > +    uint32_t num_cpus_next_level, offset_next_level;
> 
> again, I dislike the name of cpus to represent the logical process or
> thread. we can call it, num_lps_next_level, or num_threads_next_level;

Okay, will use num_threads_next_level ;-)

> 
> > +
> > +    /*
> > +     * Initialize the bitmap to decide which levels should be
> > +     * encoded in 0x1f.
> > +     */
> > +    if (!count) {
> 
> using static bitmap and initialize the bitmap on (count == 0), looks bad to
> me. It highly relies on the order of how encode_topo_cpuid1f() is called,
> and fragile.
> 
> Instead, we can maintain an array in CPUX86State, e.g.,
> 
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1904,6 +1904,8 @@ typedef struct CPUArchState {
> 
>      /* Number of dies within this CPU package. */
>      unsigned nr_dies;
> +
> +    unint8_t valid_cpu_topo[CPU_TOPO_LEVEL_MAX];
>  } CPUX86State;
> 
> 
> and initialize it as below, when initializing the env
> 
> env->valid_cpu_topo[0] = CPU_TOPO_LEVEL_SMT;
> env->valid_cpu_topo[1] = CPU_TOPO_LEVEL_CORE;
> if (env->nr_dies > 1) {
> 	env->valid_cpu_topo[2] = CPU_TOPO_LEVEL_DIE;
> }
> 
> then in encode_topo_cpuid1f(), we can get level and next_level as
> 
> level = env->valid_cpu_topo[count];
> next_level = env->valid_cpu_topo[count + 1];
> 

Good idea, let me try this way.

Thanks,
Zhao


