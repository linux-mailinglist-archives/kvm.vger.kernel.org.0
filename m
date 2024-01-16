Return-Path: <kvm+bounces-6345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2099582F286
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 17:40:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5747EB23756
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 16:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C9F218E06;
	Tue, 16 Jan 2024 16:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rp5FWF60"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A11749F
	for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 16:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705423220; x=1736959220;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SIJRqR66I++wv+06tbPBSmPYbEK0u68zhL8WKSbNS/w=;
  b=Rp5FWF60PPI0NB7KIZj/h5qafZQhm9n6dgmdDTYR9CS2000oc2jVcuLM
   /QEBeai7aFSNSMGOhaMFBYn/31J0gZhR75+o8wCI3wZ32w8ocZCvnjDFy
   erLFE1kVEOaXvQdr/+W4BnQkLcQzXWq96kUHdl/RMkJQMjHt/LmAMBymF
   QIxiCzJv6eHvnyUMfKcUYhdbpS1Itw/AjWI8drd2WrECqWpbMFMnirPM0
   ZV+o1dGDllfaaKAG76wY4VlnD2YbDNswer7yt4fHuEeKlUHVfgg92Vuxt
   dLkM5jHoCMwZSvOAek6B5Maeu4EAv0u+zsENe08ehDJMKW4kTna5FGd4c
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="6672274"
X-IronPort-AV: E=Sophos;i="6.05,199,1701158400"; 
   d="scan'208";a="6672274"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 08:40:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="818218010"
X-IronPort-AV: E=Sophos;i="6.05,199,1701158400"; 
   d="scan'208";a="818218010"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.22.149]) ([10.93.22.149])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 08:40:15 -0800
Message-ID: <f9f675c2-9e53-4673-a232-89b72150f092@intel.com>
Date: Wed, 17 Jan 2024 00:40:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/16] i386/cpu: Introduce cluster-id to X86CPU
Content-Language: en-US
To: Zhao Liu <zhao1.liu@linux.intel.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Zhuocheng Ding <zhuocheng.ding@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Babu Moger <babu.moger@amd.com>, Yongwei Ma <yongwei.ma@intel.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>
References: <ZaTJyea4KMMk6x/m@intel.com>
 <1c58dd98-d4f6-4226-9a17-8b89c3ed632e@intel.com> <ZaVMq3v6yPoFARsF@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZaVMq3v6yPoFARsF@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/2024 11:18 PM, Zhao Liu wrote:
> Hi Xiaoyao,
> 
> On Mon, Jan 15, 2024 at 03:45:58PM +0800, Xiaoyao Li wrote:
>> Date: Mon, 15 Jan 2024 15:45:58 +0800
>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>> Subject: Re: [PATCH v7 10/16] i386/cpu: Introduce cluster-id to X86CPU
>>
>> On 1/15/2024 1:59 PM, Zhao Liu wrote:
>>> (Also cc "machine core" maintainers.)
>>>u
>>> Hi Xiaoyao,
>>>
>>> On Mon, Jan 15, 2024 at 12:18:17PM +0800, Xiaoyao Li wrote:
>>>> Date: Mon, 15 Jan 2024 12:18:17 +0800
>>>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> Subject: Re: [PATCH v7 10/16] i386/cpu: Introduce cluster-id to X86CPU
>>>>
>>>> On 1/15/2024 11:27 AM, Zhao Liu wrote:
>>>>> On Sun, Jan 14, 2024 at 09:49:18PM +0800, Xiaoyao Li wrote:
>>>>>> Date: Sun, 14 Jan 2024 21:49:18 +0800
>>>>>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>>>>> Subject: Re: [PATCH v7 10/16] i386/cpu: Introduce cluster-id to X86CPU
>>>>>>
>>>>>> On 1/8/2024 4:27 PM, Zhao Liu wrote:
>>>>>>> From: Zhuocheng Ding <zhuocheng.ding@intel.com>
>>>>>>>
>>>>>>> Introduce cluster-id other than module-id to be consistent with
>>>>>>> CpuInstanceProperties.cluster-id, and this avoids the confusion
>>>>>>> of parameter names when hotplugging.
>>>>>>
>>>>>> I don't think reusing 'cluster' from arm for x86's 'module' is a good idea.
>>>>>> It introduces confusion around the code.
>>>>>
>>>>> There is a precedent: generic "socket" v.s. i386 "package".
>>>>
>>>> It's not the same thing. "socket" vs "package" is just software people and
>>>> hardware people chose different name. It's just different naming issue.
>>>
>>> No, it's a similar issue. Same physical device, different name only.
>>>
>>> Furthermore, the topology was introduced for resource layout and silicon
>>> fabrication, and similar design ideas and fabrication processes are fairly
>>> consistent across common current arches. Therefore, it is possible to
>>> abstract similar topological hierarchies for different arches.
>>>
>>>>
>>>> however, here it's reusing name issue while 'cluster' has been defined for
>>>> x86. It does introduce confusion.
>>>
>>> There's nothing fundamentally different between the x86 module and the
>>> generic cluster, is there? This is the reason that I don't agree with
>>> introducing "modules" in -smp.
>>
>> generic cluster just means the cluster of processors, i.e, a group of
>> cpus/lps. It is just a middle level between die and core.
> 
> Not sure if you mean the "cluster" device for TCG GDB? "cluster" device
> is different with "cluster" option in -smp.

No, I just mean the word 'cluster'. And I thought what you called 
"generic cluster" means "a cluster of logical processors"

Below I quote the description of Yanan's commit 864c3b5c32f0:

     A cluster generally means a group of CPU cores which share L2 cache
     or other mid-level resources, and it is the shared resources that
     is used to improve scheduler's behavior. From the point of view of
     the size range, it's between CPU die and CPU core. For example, on
     some ARM64 Kunpeng servers, we have 6 clusters in each NUMA node,
     and 4 CPU cores in each cluster. The 4 CPU cores share a separate
     L2 cache and a L3 cache tag, which brings cache affinity advantage.

What I get from it, is, cluster is just a middle level between CPU die 
and CPU core. The cpu cores inside one cluster shares some mid-level 
resource. L2 cache is just one example of the shared mid-level resource. 
So it can be either module level, or tile level in x86, or even the 
diegrp level you mentioned below.

> When Yanan introduced the "cluster" option in -smp, he mentioned that it
> is for sharing L2 and L3 tags, which roughly corresponds to our module.
> 
>>
>> It can be the module level in intel, or tile level. Further, if per die lp
>> number increases in the future, there might be more middle levels in intel
>> between die and core. Then at that time, how to decide what level should
>> cluster be mapped to?
> 
> Currently, there're 3 levels defined in SDM which are between die and
> core: diegrp, tile and module. In our products, L2 is just sharing on the
> module, so the intel's module and the general cluster are the best match.

you said 'generic cluster' a lot of times. But from my point of view, 
you are referring to current ARM's cluster instead of *generic* cluster.

Anyway, cluster is just a mid-level between die and core. We should not 
associate it any specific resource. A resource is shared in what level 
can change, e.g., initially L3 cache is shared in a physical package. 
When multi-die got supported, L3 cache is shared in one die. Now, on AMD 
product, L3 cache is shared in one complex, and one die can have 2 
complexs thus 2 separate L3 cache in one die.

It doesn't matter calling it cluster, or module, or xyz. It is just a 
name to represent a cpu topology level between die and core. What 
matters is, once it gets accepted, it becomes formal ABI for users that 
'cluster' means 'module' for x86 users. This is definitely a big 
confusion for people. Maybe people try to figure out why, and find the 
reason is that 'cluster' means the level at which L2 cache is shared and 
that's just the module level in x86 shares L2 cache. Maybe in the 
future, "L2 is shared in module" get changed just like the example I 
give for L3 above. Then, that's really the big confusion, and all this 
become the "historic reason" that cluster is chosen to represent module 
in x86.

> There are no commercially available machines for the other levels yet,
> so there's no way to ensure exactly what the future holds, but we should
> try to avoid fragmentation of the topology hierarchy and try to maintain
> the uniform and common topology hierarchies for QEMU.
> 
> Unless a new level for -smp is introduced in the future when an unsolvable
> problem is raised.
> 
>>
>>>>
>>>>> The direct definition of cluster is the level that is above the "core"
>>>>> and shares the hardware resources including L2. In this sense, arm's
>>>>> cluster is the same as x86's module.
>>>>
>>>> then, what about intel implements tile level in the future? why ARM's
>>>> 'cluster' is mapped to 'module', but not 'tile' ?
>>>
>>> This depends on the actual need.
>>>
>>> Module (for x86) and cluster (in general) are similar, and tile (for x86)
>>> is used for L3 in practice, so I use module rather than tile to map
>>> generic cluster.
>>>
>>> And, it should be noted that x86 module is mapped to the generic cluster,
>>> not to ARM's. It's just that currently only ARM is using the clusters
>>> option in -smp.
>>>
>>> I believe QEMU provides the abstract and unified topology hierarchies in
>>> -smp, not the arch-specific hierarchies.
>>>
>>>>
>>>> reusing 'cluster' for 'module' is just a bad idea.
>>>>
>>>>> Though different arches have different naming styles, but QEMU's generic
>>>>> code still need the uniform topology hierarchy.
>>>>
>>>> generic code can provide as many topology levels as it can. each ARCH can
>>>> choose to use the ones it supports.
>>>>
>>>> e.g.,
>>>>
>>>> in qapi/machine.json, it says,
>>>>
>>>> # The ordering from highest/coarsest to lowest/finest is:
>>>> # @drawers, @books, @sockets, @dies, @clusters, @cores, @threads.
>>>
>>> This ordering is well-defined...
>>>
>>>> #
>>>> # Different architectures support different subsets of topology
>>>> # containers.
>>>> #
>>>> # For example, s390x does not have clusters and dies, and the socket
>>>> # is the parent container of cores.
>>>>
>>>> we can update it to
>>>>
>>>> # The ordering from highest/coarsest to lowest/finest is:
>>>> # @drawers, @books, @sockets, @dies, @clusters, @module, @cores,
>>>> # @threads.
>>>
>>> ...but here it's impossible to figure out why cluster is above module,
>>> and even I can't come up with the difference between cluster and module.
>>>
>>>> #
>>>> # Different architectures support different subsets of topology
>>>> # containers.
>>>> #
>>>> # For example, s390x does not have clusters and dies, and the socket
>>>> # is the parent container of cores.
>>>> #
>>>> # For example, x86 does not have drawers and books, and does not support
>>>> # cluster.
>>>>
>>>> even if cluster of x86 is supported someday in the future, we can remove the
>>>> ordering requirement from above description.
>>>
>>> x86's cluster is above the package.
>>>
>>> To reserve this name for x86, we can't have the well-defined topology
>>> ordering.
>>>
>>> But topology ordering is necessary in generic code, and many
>>> calculations depend on the topology ordering.
>>
>> could you point me to the code?
> 
> Yes, e.g., there're 2 helpers: machine_topo_get_cores_per_socket() and
> machine_topo_get_threads_per_socket().

I see. these two helpers are fragile, that they need to be updated every 
time new level between core and socket is introduced.

Anyway, we can ensure the order for each ARCH, that the valid levels for 
any ARCH are ordered. e.g., we have

@drawers, @books, @sockets, @dies, @clusters, @module, @cores, @threads

defined,

for s390, the valid levels are

  @drawers, @books, @sockets, @cores, @threads

for arm, the valid levels are

  @sockets, @dies, @clusters, @cores, @threads
  (I'm not sure if die is supported for ARM?)

for x86, the valid levels are

  @sockets, @dies, @module, @cores, @threads

All of them are ordered. those unsupported level in each ARCH just get 
value 1. It won't have any issue in the calculation for the default 
value, but you provided two functions may not be lucky. anyway, they can 
be fixed at the time when we really go this approach.

>>
>>>>
>>>>>>
>>>>>> s390 just added 'drawer' and 'book' in cpu topology[1]. I think we can also
>>>>>> add a module level for x86 instead of reusing cluster.
>>>>>>
>>>>>> (This is also what I want to reply to the cover letter.)
>>>>>>
>>>>>> [1] https://lore.kernel.org/qemu-devel/20231016183925.2384704-1-nsg@linux.ibm.com/
>>>>>
>>>>> These two new levels have the clear topological hierarchy relationship
>>>>> and don't duplicate existing ones.
>>>>>
>>>>> "book" or "drawer" may correspond to intel's "cluster".
>>>>>
>>>>> Maybe, in the future, we could support for arch-specific alias topologies
>>>>> in -smp.
>>>>
>>>> I don't think we need alias, reusing 'cluster' for 'module' doesn't gain any
>>>> benefit except avoid adding a new field in SMPconfiguration. All the other
>>>> cluster code is ARM specific and x86 cannot share.
>>>
>>> The point is that there is no difference between intel module and general
>>> cluster...Considering only the naming issue, even AMD has the "complex" to
>>> correspond to the Intel's "module".
>>
>> does complex of AMD really match with intel module? L3 cache is shared in
>> one complex, while L2 cache is shared in one module for now.
> 
> If then it could correspond to intel's tile, which is after all a level
> below die.

So if AMD wants to add complex in smp topology, where should complex 
level get put? between die and cluster?

> Thanks,
> Zhao
> 


