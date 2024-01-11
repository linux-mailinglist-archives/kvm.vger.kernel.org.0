Return-Path: <kvm+bounces-6058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79F5A82A925
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 09:30:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C76A28802D
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 08:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C3DAFBFF;
	Thu, 11 Jan 2024 08:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nRVdLylu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0885FC01
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 08:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704961814; x=1736497814;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=J+deJNjpIEK00V1p9zxYsDXB9a23bGaVRqJ2YriWaYE=;
  b=nRVdLyluocvgp+HZrL8L07s2UL2VfUYwH/0x0PdPgUCjFfvdopc4bih6
   95xatelyXtYNXUdwLNzVQT3HWUvzurA/J3ayXzUYtgM06hiIXdmdMQMp5
   aMWW+EVz4JKJn6CJzP3qqa97r7qwRmvefXTIGjIcrP/uducbnrpI6yYfL
   meRPaaNIXejgGLl7FVSipK5cLrLz4RoV5+2hCBDv5F1O0oVtJMAnxA7X4
   r7fggM7EAd6+Tvh/M+JldD6pXAaYKs9qlcClsZtB2mHNCFDneaFho/9VY
   h0HW+Iw3KkQeip2a1313PsUEHdUqC6vSS29eZ2Bh60U+NLK6JMvXxra13
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10949"; a="5521920"
X-IronPort-AV: E=Sophos;i="6.04,185,1695711600"; 
   d="scan'208";a="5521920"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 00:30:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10949"; a="905866973"
X-IronPort-AV: E=Sophos;i="6.04,185,1695711600"; 
   d="scan'208";a="905866973"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orsmga004.jf.intel.com with ESMTP; 11 Jan 2024 00:30:08 -0800
Date: Thu, 11 Jan 2024 16:43:05 +0800
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
	Zhao Liu <zhao1.liu@intel.com>,
	Robert Hoo <robert.hu@linux.intel.com>,
	Babu Moger <babu.moger@amd.com>, Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH v7 02/16] i386/cpu: Use APIC ID offset to encode cache
 topo in CPUID[4]
Message-ID: <ZZ+qGfykupOEFPA2@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-3-zhao1.liu@linux.intel.com>
 <f5202ebd-6bc8-44b1-b22b-f3a033e0f283@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5202ebd-6bc8-44b1-b22b-f3a033e0f283@intel.com>

Hi Xiaoyao,

On Wed, Jan 10, 2024 at 05:31:28PM +0800, Xiaoyao Li wrote:
> Date: Wed, 10 Jan 2024 17:31:28 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH v7 02/16] i386/cpu: Use APIC ID offset to encode cache
>  topo in CPUID[4]
> 
> On 1/8/2024 4:27 PM, Zhao Liu wrote:
> > From: Zhao Liu <zhao1.liu@intel.com>
> > 
> > Refer to the fixes of cache_info_passthrough ([1], [2]) and SDM, the
> > CPUID.04H:EAX[bits 25:14] and CPUID.04H:EAX[bits 31:26] should use the
> > nearest power-of-2 integer.
> > 
> > The nearest power-of-2 integer can be calculated by pow2ceil() or by
> > using APIC ID offset (like L3 topology using 1 << die_offset [3]).
> > 
> > But in fact, CPUID.04H:EAX[bits 25:14] and CPUID.04H:EAX[bits 31:26]
> > are associated with APIC ID. For example, in linux kernel, the field
> > "num_threads_sharing" (Bits 25 - 14) is parsed with APIC ID.
> 
> And for
> > another example, on Alder Lake P, the CPUID.04H:EAX[bits 31:26] is not
> > matched with actual core numbers and it's calculated by:
> > "(1 << (pkg_offset - core_offset)) - 1".
> 
> could you elaborate it more? what is the value of actual core numbers on
> Alder lake P? and what is the pkg_offset and core_offset?

For example, the following's the CPUID dump of an ADL-S machine:

CPUID.04H:

0x00000004 0x00: eax=0xfc004121 ebx=0x01c0003f ecx=0x0000003f edx=0x00000000
0x00000004 0x01: eax=0xfc004122 ebx=0x01c0003f ecx=0x0000007f edx=0x00000000
0x00000004 0x02: eax=0xfc01c143 ebx=0x03c0003f ecx=0x000007ff edx=0x00000000
0x00000004 0x03: eax=0xfc1fc163 ebx=0x0240003f ecx=0x00009fff edx=0x00000004
0x00000004 0x04: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000


CPUID.1FH:

0x0000001f 0x00: eax=0x00000001 ebx=0x00000001 ecx=0x00000100 edx=0x0000004c
0x0000001f 0x01: eax=0x00000007 ebx=0x00000014 ecx=0x00000201 edx=0x0000004c
0x0000001f 0x02: eax=0x00000000 ebx=0x00000000 ecx=0x00000002 edx=0x0000004c

The CPUID.04H:EAX[bits 31:26] is 63.
From CPUID.1FH.00H:EAX[bits 04:00], the core_offset is 1, and from
CPUID.1FH.01H:EAX[bits 04:00], the pkg_offset is 7.

Thus we can verify that the above equation as:

1 << (0x7 - 0x1) - 1 = 63.

"Maximum number of addressable IDs" refers to the maximum number of IDs
that can be enumerated in the APIC ID's topology layout, which does not
necessarily correspond to the actual number of topology domains.

> 
> > Therefore the offset of APIC ID should be preferred to calculate nearest
> > power-of-2 integer for CPUID.04H:EAX[bits 25:14] and CPUID.04H:EAX[bits
> > 31:26]:
> > 1. d/i cache is shared in a core, 1 << core_offset should be used
> >     instand of "cs->nr_threads" in encode_cache_cpuid4() for
> 
> /s/instand/instead

Thanks!

> 
> >     CPUID.04H.00H:EAX[bits 25:14] and CPUID.04H.01H:EAX[bits 25:14].
> > 2. L2 cache is supposed to be shared in a core as for now, thereby
> >     1 << core_offset should also be used instand of "cs->nr_threads" in
> 
> ditto

Okay.

> 
> >     encode_cache_cpuid4() for CPUID.04H.02H:EAX[bits 25:14].
> > 3. Similarly, the value for CPUID.04H:EAX[bits 31:26] should also be
> >     calculated with the bit width between the Package and SMT levels in
> >     the APIC ID (1 << (pkg_offset - core_offset) - 1).
> > 
> > In addition, use APIC ID offset to replace "pow2ceil()" for
> > cache_info_passthrough case.
> > 
> > [1]: efb3934adf9e ("x86: cpu: make sure number of addressable IDs for processor cores meets the spec")
> > [2]: d7caf13b5fcf ("x86: cpu: fixup number of addressable IDs for logical processors sharing cache")
> > [3]: d65af288a84d ("i386: Update new x86_apicid parsing rules with die_offset support")
> > 
> > Fixes: 7e3482f82480 ("i386: Helpers to encode cache information consistently")
> > Suggested-by: Robert Hoo <robert.hu@linux.intel.com>
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > Tested-by: Babu Moger <babu.moger@amd.com>
> > Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > Changes since v3:
> >   * Fix compile warnings. (Babu)
> >   * Fix spelling typo.
> > 
> > Changes since v1:
> >   * Use APIC ID offset to replace "pow2ceil()" for cache_info_passthrough
> >     case. (Yanan)
> >   * Split the L1 cache fix into a separate patch.
> >   * Rename the title of this patch (the original is "i386/cpu: Fix number
> >     of addressable IDs in CPUID.04H").
> > ---
> >   target/i386/cpu.c | 30 +++++++++++++++++++++++-------
> >   1 file changed, 23 insertions(+), 7 deletions(-)
> > 
> > diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> > index 5a3678a789cf..c8d2a585723a 100644
> > --- a/target/i386/cpu.c
> > +++ b/target/i386/cpu.c
> > @@ -6014,7 +6014,6 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
> >   {
> >       X86CPU *cpu = env_archcpu(env);
> >       CPUState *cs = env_cpu(env);
> > -    uint32_t die_offset;
> >       uint32_t limit;
> >       uint32_t signature[3];
> >       X86CPUTopoInfo topo_info;
> > @@ -6098,39 +6097,56 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
> >                   int host_vcpus_per_cache = 1 + ((*eax & 0x3FFC000) >> 14);
> >                   int vcpus_per_socket = cs->nr_cores * cs->nr_threads;
> >                   if (cs->nr_cores > 1) {
> > +                    int addressable_cores_offset =
> > +                                                apicid_pkg_offset(&topo_info) -
> > +                                                apicid_core_offset(&topo_info);
> > +
> >                       *eax &= ~0xFC000000;
> > -                    *eax |= (pow2ceil(cs->nr_cores) - 1) << 26;
> > +                    *eax |= (1 << (addressable_cores_offset - 1)) << 26;
> 
> it should be ((1 << addressable_cores_offset) - 1) << 26

Good catch! The helper wrapped in a subsequent patch masks the error here.

> 
> I think naming it addressable_cores_width is better than
> addressable_cores_offset. It's not offset because offset means the bit
> position from bit 0.

I agree, "width" is better.

> 
> And we can get the width by another algorithm:
> 
> int addressable_cores_width = apicid_core_width(&topo_info) +
> apicid_die_width(&topo_info);
> *eax |= ((1 << addressable_cores_width) - 1)) << 26;

This algorithm lacks flexibility because there will be more topology
levels between package and core, such as the cluster being introduced...

Using "addressable_cores_width" is clear enough.

> 		
> >                   }
> >                   if (host_vcpus_per_cache > vcpus_per_socket) {
> > +                    int pkg_offset = apicid_pkg_offset(&topo_info);
> > +
> >                       *eax &= ~0x3FFC000;
> > -                    *eax |= (pow2ceil(vcpus_per_socket) - 1) << 14;
> > +                    *eax |= (1 << (pkg_offset - 1)) << 14;
> 
> Ditto, ((1 << pkg_offset) - 1) << 14

Thanks!

> 
> For this one, I think pow2ceil(vcpus_per_socket) is better. Because it's
> intuitive that when host_vcpus_per_cache > vcpus_per_socket, we expose
> vcpus_per_cache (configured by users) to VM.

I tend to use a uniform calculation that is less confusing and easier to
maintain. Since this field encodes "Maximum number of addressable IDs",
OS can't get the exact number of CPUs/vCPUs sharing L3 from here, it can
only know that L3 is shared at the package level.

Thanks,
Zhao


