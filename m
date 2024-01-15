Return-Path: <kvm+bounces-6176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B223A82D33F
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 04:14:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 35CF21F21385
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 03:14:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 918C11FDD;
	Mon, 15 Jan 2024 03:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a1lsbFet"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21C11C3D
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 03:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705288460; x=1736824460;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MJAglOb3jYjkpfEpGyk5lKRRycQdHXJJAtybYzmPs2w=;
  b=a1lsbFetDiv2hiPb36SRoMo9JJSiDNDA3i7zR6g3lsiROZl7GUOIrEfE
   qeTOa8q1Tc9RZczxugEm06Pa3YJ+3i9ubP6vrwD2gVFmv0GsXOQHYSemu
   L/6WTeLhy1z/cN+m3ztY4hbgLw6jIm1sTg+cnJJ4EgoRvpruJDOVTNFs2
   +dm39NjaWGr9GRMfo+SvqhCID5kqFFWjrieBIeOGoMlDr64DqirQpQYPF
   opBoQcUgd6nC3fTFUlctdZKoWdGfvAmvwSWZjPJt6ExpLi5wtrBBDakqk
   Zp9e2tXGnfI41j9qSRROyUsnvietwi1SQNWnzqTJkN5EUJ3zj0liFEhGT
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="398391009"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="398391009"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 19:14:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="902640731"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="902640731"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmsmga002.fm.intel.com with ESMTP; 14 Jan 2024 19:14:15 -0800
Date: Mon, 15 Jan 2024 11:27:14 +0800
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
Subject: Re: [PATCH v7 10/16] i386/cpu: Introduce cluster-id to X86CPU
Message-ID: <ZaSmEpLaEg0Yx/h7@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-11-zhao1.liu@linux.intel.com>
 <46663f59-2a28-4f22-8fb9-9c447b903e4a@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46663f59-2a28-4f22-8fb9-9c447b903e4a@intel.com>

On Sun, Jan 14, 2024 at 09:49:18PM +0800, Xiaoyao Li wrote:
> Date: Sun, 14 Jan 2024 21:49:18 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH v7 10/16] i386/cpu: Introduce cluster-id to X86CPU
> 
> On 1/8/2024 4:27 PM, Zhao Liu wrote:
> > From: Zhuocheng Ding <zhuocheng.ding@intel.com>
> > 
> > Introduce cluster-id other than module-id to be consistent with
> > CpuInstanceProperties.cluster-id, and this avoids the confusion
> > of parameter names when hotplugging.
> 
> I don't think reusing 'cluster' from arm for x86's 'module' is a good idea.
> It introduces confusion around the code.

There is a precedent: generic "socket" v.s. i386 "package".

The direct definition of cluster is the level that is above the "core"
and shares the hardware resources including L2. In this sense, arm's
cluster is the same as x86's module.

Though different arches have different naming styles, but QEMU's generic
code still need the uniform topology hierarchy.

> 
> s390 just added 'drawer' and 'book' in cpu topology[1]. I think we can also
> add a module level for x86 instead of reusing cluster.
> 
> (This is also what I want to reply to the cover letter.)
> 
> [1] https://lore.kernel.org/qemu-devel/20231016183925.2384704-1-nsg@linux.ibm.com/

These two new levels have the clear topological hierarchy relationship
and don't duplicate existing ones.

"book" or "drawer" may correspond to intel's "cluster".

Maybe, in the future, we could support for arch-specific alias topologies
in -smp.

Thanks,
Zhao

> 
> > Following the legacy smp check rules, also add the cluster_id validity
> > into x86_cpu_pre_plug().
> > 
> > Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
> > Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > Tested-by: Babu Moger <babu.moger@amd.com>
> > Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > Changes since v6:
> >   * Update the comment when check cluster-id. Since there's no
> >     v8.2, the cluster-id support should at least start from v9.0.
> > 
> > Changes since v5:
> >   * Update the comment when check cluster-id. Since current QEMU is
> >     v8.2, the cluster-id support should at least start from v8.3.
> > 
> > Changes since v3:
> >   * Use the imperative in the commit message. (Babu)
> > ---
> >   hw/i386/x86.c     | 33 +++++++++++++++++++++++++--------
> >   target/i386/cpu.c |  2 ++
> >   target/i386/cpu.h |  1 +
> >   3 files changed, 28 insertions(+), 8 deletions(-)
> > 
> > diff --git a/hw/i386/x86.c b/hw/i386/x86.c
> > index 5269aae3a5c2..1c1d368614ee 100644
> > --- a/hw/i386/x86.c
> > +++ b/hw/i386/x86.c
> > @@ -329,6 +329,14 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
> >               cpu->die_id = 0;
> >           }
> > +        /*
> > +         * cluster-id was optional in QEMU 9.0 and older, so keep it optional
> > +         * if there's only one cluster per die.
> > +         */
> > +        if (cpu->cluster_id < 0 && ms->smp.clusters == 1) {
> > +            cpu->cluster_id = 0;
> > +        }
> > +
> >           if (cpu->socket_id < 0) {
> >               error_setg(errp, "CPU socket-id is not set");
> >               return;
> > @@ -345,6 +353,14 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
> >                          cpu->die_id, ms->smp.dies - 1);
> >               return;
> >           }
> > +        if (cpu->cluster_id < 0) {
> > +            error_setg(errp, "CPU cluster-id is not set");
> > +            return;
> > +        } else if (cpu->cluster_id > ms->smp.clusters - 1) {
> > +            error_setg(errp, "Invalid CPU cluster-id: %u must be in range 0:%u",
> > +                       cpu->cluster_id, ms->smp.clusters - 1);
> > +            return;
> > +        }
> >           if (cpu->core_id < 0) {
> >               error_setg(errp, "CPU core-id is not set");
> >               return;
> > @@ -364,16 +380,9 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
> >           topo_ids.pkg_id = cpu->socket_id;
> >           topo_ids.die_id = cpu->die_id;
> > +        topo_ids.module_id = cpu->cluster_id;
> >           topo_ids.core_id = cpu->core_id;
> >           topo_ids.smt_id = cpu->thread_id;
> > -
> > -        /*
> > -         * TODO: This is the temporary initialization for topo_ids.module_id to
> > -         * avoid "maybe-uninitialized" compilation errors. Will remove when
> > -         * X86CPU supports cluster_id.
> > -         */
> > -        topo_ids.module_id = 0;
> > -
> >           cpu->apic_id = x86_apicid_from_topo_ids(&topo_info, &topo_ids);
> >       }
> > @@ -418,6 +427,14 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
> >       }
> >       cpu->die_id = topo_ids.die_id;
> > +    if (cpu->cluster_id != -1 && cpu->cluster_id != topo_ids.module_id) {
> > +        error_setg(errp, "property cluster-id: %u doesn't match set apic-id:"
> > +            " 0x%x (cluster-id: %u)", cpu->cluster_id, cpu->apic_id,
> > +            topo_ids.module_id);
> > +        return;
> > +    }
> > +    cpu->cluster_id = topo_ids.module_id;
> > +
> >       if (cpu->core_id != -1 && cpu->core_id != topo_ids.core_id) {
> >           error_setg(errp, "property core-id: %u doesn't match set apic-id:"
> >               " 0x%x (core-id: %u)", cpu->core_id, cpu->apic_id,
> > diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> > index a2d39d2198b6..498a4be62b40 100644
> > --- a/target/i386/cpu.c
> > +++ b/target/i386/cpu.c
> > @@ -7909,12 +7909,14 @@ static Property x86_cpu_properties[] = {
> >       DEFINE_PROP_UINT32("apic-id", X86CPU, apic_id, 0),
> >       DEFINE_PROP_INT32("thread-id", X86CPU, thread_id, 0),
> >       DEFINE_PROP_INT32("core-id", X86CPU, core_id, 0),
> > +    DEFINE_PROP_INT32("cluster-id", X86CPU, cluster_id, 0),
> >       DEFINE_PROP_INT32("die-id", X86CPU, die_id, 0),
> >       DEFINE_PROP_INT32("socket-id", X86CPU, socket_id, 0),
> >   #else
> >       DEFINE_PROP_UINT32("apic-id", X86CPU, apic_id, UNASSIGNED_APIC_ID),
> >       DEFINE_PROP_INT32("thread-id", X86CPU, thread_id, -1),
> >       DEFINE_PROP_INT32("core-id", X86CPU, core_id, -1),
> > +    DEFINE_PROP_INT32("cluster-id", X86CPU, cluster_id, -1),
> >       DEFINE_PROP_INT32("die-id", X86CPU, die_id, -1),
> >       DEFINE_PROP_INT32("socket-id", X86CPU, socket_id, -1),
> >   #endif
> > diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> > index 97b290e10576..009950b87203 100644
> > --- a/target/i386/cpu.h
> > +++ b/target/i386/cpu.h
> > @@ -2057,6 +2057,7 @@ struct ArchCPU {
> >       int32_t node_id; /* NUMA node this CPU belongs to */
> >       int32_t socket_id;
> >       int32_t die_id;
> > +    int32_t cluster_id;
> >       int32_t core_id;
> >       int32_t thread_id;
> 

