Return-Path: <kvm+bounces-6728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 47228838A83
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 10:43:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C81321F23290
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 09:43:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1EBD5BAF1;
	Tue, 23 Jan 2024 09:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hes+WLoh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377F25BAE1
	for <kvm@vger.kernel.org>; Tue, 23 Jan 2024 09:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706003012; cv=none; b=KquCB5R1nOTgWQpTFxrBfA4uzQFFLwRYGt49BRpx1d97xzC1tdP+lD41FitZxsYcBoeUrxeOkKBMVA/KPVJGw7OiyT3tpcImdfRoLbAVQyFEEjqk4htWEWJ9Ly9kQKisCPyzRIYRperKQF8pZcyFy/K1+ZAJXAbo33vesSs0t+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706003012; c=relaxed/simple;
	bh=wU64uHlR52rNEzdKGKovUXzpWZVCS6qVw80l/VHg/G4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r6PQ3MPrSPzjXeKjIbQ9cHwGjdObK4pbM5BJ38ADkNudYmJJDZuzQeVucR5H+XWkPoKYihvqAAK7G7snY55X1DXP+6KlT4QyOwsCaSLwEv2V+SPHWKA8/4TnwCctTZlC66rbYIpcW84yJ+JuSFldaGsYMIRC1QHBYc4p3pAXTt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hes+WLoh; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706003010; x=1737539010;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wU64uHlR52rNEzdKGKovUXzpWZVCS6qVw80l/VHg/G4=;
  b=Hes+WLohbmkFahJe5YRQ5lzy1ZUKlPy14peUFgmuCNB8kZH5FJsdrNal
   PDWHxzSYax9PovGvHGt0eZ7FVl2FbSs89Klt/V3CHc+py3k1qmUndrEzG
   bnWwymLA2MLUdZD/Sh0LVYOYljPJjePvAQz6n028H9wNuKDP0cre0HIXc
   bsdgnYp9YqAS01UsfabM5nplOeeODcQFCRJU/jM4NEm2cCI6XnbwDaPgf
   DE7RIK4oXkMNHSrnP5iZApXMjA7euL3iRxQliRga9h/d4B1tgSP0EKB7r
   +H+Gnjwu+5XS44azCWlW3DjTwzAK9yxPGhZUazIGkRxtyhNOn0bxWpx3n
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="8838337"
X-IronPort-AV: E=Sophos;i="6.05,214,1701158400"; 
   d="scan'208";a="8838337"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 01:43:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="735514573"
X-IronPort-AV: E=Sophos;i="6.05,214,1701158400"; 
   d="scan'208";a="735514573"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orsmga003.jf.intel.com with ESMTP; 23 Jan 2024 01:43:25 -0800
Date: Tue, 23 Jan 2024 17:56:27 +0800
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
Message-ID: <Za+NS1OneKg7IHOj@intel.com>
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

In my practice, I have found this way to be rather tricky since...

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

this array actually pre-binds the 0x1f subleaf to the topology level,
so this way brings difficulties to the array initialization stage...

> 
> and initialize it as below, when initializing the env
> 
> env->valid_cpu_topo[0] = CPU_TOPO_LEVEL_SMT;
> env->valid_cpu_topo[1] = CPU_TOPO_LEVEL_CORE;
> if (env->nr_dies > 1) {
> 	env->valid_cpu_topo[2] = CPU_TOPO_LEVEL_DIE;
> }

... as here.

Based on 1f encoding rule, with module, we may need this logic like
this:

// If there's module, encode the module level at ECX=2.
if (env->nr_modules > 1) {
       env->valid_cpu_topo[2] = CPU_TOPO_LEVEL_MODULE;
       if (env->nr_dies > 1) {
       		env->valid_cpu_topo[3] = CPU_TOPO_LEVEL_DIE;
       }
} else if (env->nr_dies > 1) { // Otherwise, encode die directly.
       env->valid_cpu_topo[2] = CPU_TOPO_LEVEL_DIE;
}

Such case-by-case checking lacks scalability, and if more levels are
supported in the future, such as tiles, the whole checking becomes
unclean. Am I understanding you correctly?

About the static bitmap, declaring it as static is an optimization.
Because the count (ECX, e.g., ECX=N) means the Nth topology levels,
if we didn't use static virable, we would need to iterate each time
to find the Nth level.

Since we know that the subleaf of 0x1f must be sequentially encoded,
the logic of this static code is always in effect.

What do you think?

Thanks,
Zhao

> 
> then in encode_topo_cpuid1f(), we can get level and next_level as
> 
> level = env->valid_cpu_topo[count];
> next_level = env->valid_cpu_topo[count + 1];
> 
> 
> > +        /* SMT and core levels are exposed in 0x1f leaf by default. */
> > +        set_bit(CPU_TOPO_LEVEL_SMT, topo_bitmap);
> > +        set_bit(CPU_TOPO_LEVEL_CORE, topo_bitmap);
> > +
> > +        if (env->nr_dies > 1) {
> > +            set_bit(CPU_TOPO_LEVEL_DIE, topo_bitmap);
> > +        }
> > +    }
> > +
> > +    *ecx = count & 0xff;
> > +    *edx = cpu->apic_id;
> > +
> > +    level = find_first_bit(topo_bitmap, CPU_TOPO_LEVEL_MAX);
> > +    if (level == CPU_TOPO_LEVEL_MAX) {
> > +        num_cpus_next_level = 0;
> > +        offset_next_level = 0;
> > +
> > +        /* Encode CPU_TOPO_LEVEL_INVALID into the last subleaf of 0x1f. */
> > +        level = CPU_TOPO_LEVEL_INVALID;
> > +    } else {
> > +        next_level = find_next_bit(topo_bitmap, CPU_TOPO_LEVEL_MAX, level + 1);
> > +        if (next_level == CPU_TOPO_LEVEL_MAX) {
> > +            next_level = CPU_TOPO_LEVEL_PACKAGE;
> > +        }
> > +
> > +        num_cpus_next_level = num_cpus_by_topo_level(topo_info, next_level);
> > +        offset_next_level = apicid_offset_by_topo_level(topo_info, next_level);
> > +    }
> > +
> > +    *eax = offset_next_level;
> > +    *ebx = num_cpus_next_level;
> > +    *ecx |= cpuid1f_topo_type(level) << 8;
> > +
> > +    assert(!(*eax & ~0x1f));
> > +    *ebx &= 0xffff; /* The count doesn't need to be reliable. */
> > +    if (level != CPU_TOPO_LEVEL_MAX) {
> > +        clear_bit(level, topo_bitmap);
> > +    }
> > +}
> > +
> >   /* Encode cache info for CPUID[0x80000005].ECX or CPUID[0x80000005].EDX */
> >   static uint32_t encode_cache_cpuid80000005(CPUCacheInfo *cache)
> >   {
> > @@ -6284,31 +6394,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
> >               break;
> >           }
> > -        *ecx = count & 0xff;
> > -        *edx = cpu->apic_id;
> > -        switch (count) {
> > -        case 0:
> > -            *eax = apicid_core_offset(&topo_info);
> > -            *ebx = topo_info.threads_per_core;
> > -            *ecx |= CPUID_1F_ECX_TOPO_LEVEL_SMT << 8;
> > -            break;
> > -        case 1:
> > -            *eax = apicid_die_offset(&topo_info);
> > -            *ebx = topo_info.cores_per_die * topo_info.threads_per_core;
> > -            *ecx |= CPUID_1F_ECX_TOPO_LEVEL_CORE << 8;
> > -            break;
> > -        case 2:
> > -            *eax = apicid_pkg_offset(&topo_info);
> > -            *ebx = cpus_per_pkg;
> > -            *ecx |= CPUID_1F_ECX_TOPO_LEVEL_DIE << 8;
> > -            break;
> > -        default:
> > -            *eax = 0;
> > -            *ebx = 0;
> > -            *ecx |= CPUID_1F_ECX_TOPO_LEVEL_INVALID << 8;
> > -        }
> > -        assert(!(*eax & ~0x1f));
> > -        *ebx &= 0xffff; /* The count doesn't need to be reliable. */
> > +        encode_topo_cpuid1f(env, count, &topo_info, eax, ebx, ecx, edx);
> >           break;
> >       case 0xD: {
> >           /* Processor Extended State */
> > diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> > index f47bad46db5e..9c78cfc3f322 100644
> > --- a/target/i386/cpu.h
> > +++ b/target/i386/cpu.h
> > @@ -1008,6 +1008,21 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
> >   #define CPUID_MWAIT_IBE     (1U << 1) /* Interrupts can exit capability */
> >   #define CPUID_MWAIT_EMX     (1U << 0) /* enumeration supported */
> > +/*
> > + * CPUTopoLevel is the general i386 topology hierarchical representation,
> > + * ordered by increasing hierarchical relationship.
> > + * Its enumeration value is not bound to the type value of Intel (CPUID[0x1F])
> > + * or AMD (CPUID[0x80000026]).
> > + */
> > +enum CPUTopoLevel {
> > +    CPU_TOPO_LEVEL_INVALID,
> > +    CPU_TOPO_LEVEL_SMT,
> > +    CPU_TOPO_LEVEL_CORE,
> > +    CPU_TOPO_LEVEL_DIE,
> > +    CPU_TOPO_LEVEL_PACKAGE,
> > +    CPU_TOPO_LEVEL_MAX,
> > +};
> > +
> >   /* CPUID[0xB].ECX level types */
> >   #define CPUID_B_ECX_TOPO_LEVEL_INVALID  0
> >   #define CPUID_B_ECX_TOPO_LEVEL_SMT      1
> 

