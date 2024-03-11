Return-Path: <kvm+bounces-11526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BE336877E08
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 11:22:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34B111F21A86
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 10:22:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B07F62BB16;
	Mon, 11 Mar 2024 10:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J/YJwPLd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7FD224D7
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 10:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710152549; cv=none; b=GPEaVXokC7uUmjrGZja8Cy2ptkjFXn3o2q1gooaoZ5tpnxw6F7zDaAKDDyvyf/oTwqAolR+8lJZ3f6eiTtUi2l7gjQ9NAFKyHePSuM2bHMDi0q9EdUSpHtjUfEXnaNVYNVZWrhq+T/2EV9clYx+aJbvVyGrWYzzBFQ96MayGzd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710152549; c=relaxed/simple;
	bh=JjN91EHR9CxEvRvZ+oBPMzA30BEBgNyoheCGlVqJbf4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FkispHQYMwR+IjpT7SdEopq6NMOe/rdS2QstJ5hJj2R1tZKCQLHJPmkP4ogjY3Ue0jJ7/7DBeJvzG8KFLezeL56o+xDO6JjJx5TPjX84giwYFLnVeDmhSpP3hJL+3WCEhnlM3KKyOVlbcqQmCutLKfa7QB3YOJ2mncEd1HLlRgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J/YJwPLd; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710152548; x=1741688548;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JjN91EHR9CxEvRvZ+oBPMzA30BEBgNyoheCGlVqJbf4=;
  b=J/YJwPLdLw3n4rlEVfv9/TNJd1Z0SgqIXSbdJhXnyGVUoiR6XDU9FVE3
   U0Imtzn1eJfFpsEU6B/ZD4tojCS01TrOqiP6J8PqiO23AszYm1c1n1fpF
   kYFSnaVza99dqqy6rWko+8tIWBg6jfxzkAn3mCqSwiC5Yf5h1L1NQqNeR
   jU5QeYZ+s8iTVcq3ot4A8a08uQWEjlZXwnxnGGzkeyqjbtvfBYlebyvQE
   11aFU/QvB72XrgY9RpfDq0N7M7MWuRv5tYyg8iIbyqgPWxDFQWxOknrBg
   42GbiaVnFLclIJ0/K3uflHkpYmZGhuuUvonu7rNgxkbeBoSbRz61m3az0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11009"; a="16208088"
X-IronPort-AV: E=Sophos;i="6.07,116,1708416000"; 
   d="scan'208";a="16208088"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 03:22:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,116,1708416000"; 
   d="scan'208";a="11560017"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.239.60]) ([10.124.239.60])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 03:22:22 -0700
Message-ID: <e730da3c-42be-45d0-aa11-279ee47bb933@linux.intel.com>
Date: Mon, 11 Mar 2024 18:22:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 02/21] hw/core/machine: Support modules in -smp
Content-Language: en-US
To: Zhao Liu <zhao1.liu@linux.intel.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Zhuocheng Ding <zhuocheng.ding@intel.com>, Babu Moger <babu.moger@amd.com>,
 Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
 <20240227103231.1556302-3-zhao1.liu@linux.intel.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240227103231.1556302-3-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/27/2024 6:32 PM, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
>
> Add "modules" parameter parsing support in -smp.
>
> Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changes since v8:
>   * Add module description in qemu_smp_opts.
>
> Changes since v7:
>   * New commit to introduce module level in -smp.
> ---
>   hw/core/machine-smp.c | 39 +++++++++++++++++++++++++++++----------
>   hw/core/machine.c     |  1 +
>   qapi/machine.json     |  3 +++
>   system/vl.c           |  3 +++
>   4 files changed, 36 insertions(+), 10 deletions(-)
>
> diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
> index a0a30da59aa4..8a8296b0d05b 100644
> --- a/hw/core/machine-smp.c
> +++ b/hw/core/machine-smp.c
> @@ -51,6 +51,10 @@ static char *cpu_hierarchy_to_string(MachineState *ms)
>           g_string_append_printf(s, " * clusters (%u)", ms->smp.clusters);
>       }
>   
> +    if (mc->smp_props.modules_supported) {
> +        g_string_append_printf(s, " * modules (%u)", ms->smp.clusters);
> +    }

smp.clusters -> smp.modules?


> +
>       g_string_append_printf(s, " * cores (%u)", ms->smp.cores);
>       g_string_append_printf(s, " * threads (%u)", ms->smp.threads);
>   
> @@ -88,6 +92,7 @@ void machine_parse_smp_config(MachineState *ms,
>       unsigned sockets = config->has_sockets ? config->sockets : 0;
>       unsigned dies    = config->has_dies ? config->dies : 0;
>       unsigned clusters = config->has_clusters ? config->clusters : 0;
> +    unsigned modules = config->has_modules ? config->modules : 0;
>       unsigned cores   = config->has_cores ? config->cores : 0;
>       unsigned threads = config->has_threads ? config->threads : 0;
>       unsigned maxcpus = config->has_maxcpus ? config->maxcpus : 0;
> @@ -102,6 +107,7 @@ void machine_parse_smp_config(MachineState *ms,
>           (config->has_sockets && config->sockets == 0) ||
>           (config->has_dies && config->dies == 0) ||
>           (config->has_clusters && config->clusters == 0) ||
> +        (config->has_modules && config->modules == 0) ||
>           (config->has_cores && config->cores == 0) ||
>           (config->has_threads && config->threads == 0) ||
>           (config->has_maxcpus && config->maxcpus == 0)) {
> @@ -117,12 +123,12 @@ void machine_parse_smp_config(MachineState *ms,
>           error_setg(errp, "dies not supported by this machine's CPU topology");
>           return;
>       }
> +    dies = dies > 0 ? dies : 1;
> +
>       if (!mc->smp_props.clusters_supported && clusters > 1) {
>           error_setg(errp, "clusters not supported by this machine's CPU topology");
>           return;
>       }
> -
> -    dies = dies > 0 ? dies : 1;
>       clusters = clusters > 0 ? clusters : 1;
>   
>       if (!mc->smp_props.books_supported && books > 1) {
> @@ -138,6 +144,13 @@ void machine_parse_smp_config(MachineState *ms,
>       }
>       drawers = drawers > 0 ? drawers : 1;
>   
> +    if (!mc->smp_props.modules_supported && modules > 1) {
> +        error_setg(errp, "modules not supported by this "
> +                   "machine's CPU topology");
> +        return;
> +    }
> +    modules = modules > 0 ? modules : 1;
> +
>       /* compute missing values based on the provided ones */
>       if (cpus == 0 && maxcpus == 0) {
>           sockets = sockets > 0 ? sockets : 1;
> @@ -152,11 +165,13 @@ void machine_parse_smp_config(MachineState *ms,
>                   cores = cores > 0 ? cores : 1;
>                   threads = threads > 0 ? threads : 1;
>                   sockets = maxcpus /
> -                          (drawers * books * dies * clusters * cores * threads);
> +                          (drawers * books * dies * clusters *
> +                           modules * cores * threads);
>               } else if (cores == 0) {
>                   threads = threads > 0 ? threads : 1;
>                   cores = maxcpus /
> -                        (drawers * books * sockets * dies * clusters * threads);
> +                        (drawers * books * sockets * dies *
> +                         clusters * modules * threads);
>               }
>           } else {
>               /* prefer cores over sockets since 6.2 */
> @@ -164,23 +179,26 @@ void machine_parse_smp_config(MachineState *ms,
>                   sockets = sockets > 0 ? sockets : 1;
>                   threads = threads > 0 ? threads : 1;
>                   cores = maxcpus /
> -                        (drawers * books * sockets * dies * clusters * threads);
> +                        (drawers * books * sockets * dies *
> +                         clusters * modules * threads);
>               } else if (sockets == 0) {
>                   threads = threads > 0 ? threads : 1;
>                   sockets = maxcpus /
> -                          (drawers * books * dies * clusters * cores * threads);
> +                          (drawers * books * dies * clusters *
> +                           modules * cores * threads);
>               }
>           }
>   
>           /* try to calculate omitted threads at last */
>           if (threads == 0) {
>               threads = maxcpus /
> -                      (drawers * books * sockets * dies * clusters * cores);
> +                      (drawers * books * sockets * dies *
> +                       clusters * modules * cores);
>           }
>       }
>   
>       maxcpus = maxcpus > 0 ? maxcpus : drawers * books * sockets * dies *
> -                                      clusters * cores * threads;
> +                                      clusters * modules * cores * threads;
>       cpus = cpus > 0 ? cpus : maxcpus;
>   
>       ms->smp.cpus = cpus;
> @@ -189,6 +207,7 @@ void machine_parse_smp_config(MachineState *ms,
>       ms->smp.sockets = sockets;
>       ms->smp.dies = dies;
>       ms->smp.clusters = clusters;
> +    ms->smp.modules = modules;
>       ms->smp.cores = cores;
>       ms->smp.threads = threads;
>       ms->smp.max_cpus = maxcpus;
> @@ -196,8 +215,8 @@ void machine_parse_smp_config(MachineState *ms,
>       mc->smp_props.has_clusters = config->has_clusters;
>   
>       /* sanity-check of the computed topology */
> -    if (drawers * books * sockets * dies * clusters * cores * threads !=
> -        maxcpus) {
> +    if (drawers * books * sockets * dies * clusters * modules * cores *
> +        threads != maxcpus) {
>           g_autofree char *topo_msg = cpu_hierarchy_to_string(ms);
>           error_setg(errp, "Invalid CPU topology: "
>                      "product of the hierarchy must match maxcpus: "
> diff --git a/hw/core/machine.c b/hw/core/machine.c
> index 36fe3a4806f2..030b7e250ac5 100644
> --- a/hw/core/machine.c
> +++ b/hw/core/machine.c
> @@ -872,6 +872,7 @@ static void machine_get_smp(Object *obj, Visitor *v, const char *name,
>           .has_sockets = true, .sockets = ms->smp.sockets,
>           .has_dies = true, .dies = ms->smp.dies,
>           .has_clusters = true, .clusters = ms->smp.clusters,
> +        .has_modules = true, .modules = ms->smp.modules,
>           .has_cores = true, .cores = ms->smp.cores,
>           .has_threads = true, .threads = ms->smp.threads,
>           .has_maxcpus = true, .maxcpus = ms->smp.max_cpus,
> diff --git a/qapi/machine.json b/qapi/machine.json
> index 93b46772869e..5233a8947556 100644
> --- a/qapi/machine.json
> +++ b/qapi/machine.json
> @@ -1640,6 +1640,8 @@
>   #
>   # @clusters: number of clusters per parent container (since 7.0)
>   #
> +# @modules: number of modules per parent container (since 9.0)
> +#
>   # @cores: number of cores per parent container
>   #
>   # @threads: number of threads per core
> @@ -1653,6 +1655,7 @@
>        '*sockets': 'int',
>        '*dies': 'int',
>        '*clusters': 'int',
> +     '*modules': 'int',
>        '*cores': 'int',
>        '*threads': 'int',
>        '*maxcpus': 'int' } }
> diff --git a/system/vl.c b/system/vl.c
> index b8469d9965da..15ff95b89b57 100644
> --- a/system/vl.c
> +++ b/system/vl.c
> @@ -741,6 +741,9 @@ static QemuOptsList qemu_smp_opts = {
>           }, {
>               .name = "clusters",
>               .type = QEMU_OPT_NUMBER,
> +        }, {
> +            .name = "modules",
> +            .type = QEMU_OPT_NUMBER,
>           }, {
>               .name = "cores",
>               .type = QEMU_OPT_NUMBER,

