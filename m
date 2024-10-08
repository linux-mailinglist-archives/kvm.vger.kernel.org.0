Return-Path: <kvm+bounces-28124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A18EF99452B
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 12:17:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B51E5B251F1
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 10:17:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B199E18FDB7;
	Tue,  8 Oct 2024 10:16:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97779EEC8
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 10:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728382619; cv=none; b=boqqYqws73v91i/JIcGnuWeKTI/JPit9eCDF4+BsvRCd9toUUay7YzdO3AvRIV1ivPxK+X9blcLvp41QGiqmkPG2PaF+JVKaOXCPiTkslsqe4Pey768LTFpSYcrY85Sd7mGzcqQJrPv+sqJSjZmJDTrtm2cR4qiv6hs5i3qJgWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728382619; c=relaxed/simple;
	bh=+Q0fF7RnAGuWLFWtgeZxb2xG06HjK3PhaG/KJBfe3so=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y2BafS6RkMvGvF1UKcz9vHxKeUFzlj/RKLVrZk/1I+NFsCUNyb0BwI+WZJfqj8hGMigKHaEbIur4lfGumGBtc3VVCn5ASwEU8OzB90MCbyENGULTqpJ1ggqfAUllbXIOTJZrc+ufbaK90ZWpMIBX4tRLvbOZbokrjq/55ViJ1HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XNBkv1GZFz6K5rX;
	Tue,  8 Oct 2024 18:16:39 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id C4996140391;
	Tue,  8 Oct 2024 18:16:53 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 8 Oct
 2024 12:16:52 +0200
Date: Tue, 8 Oct 2024 11:16:51 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Zhao Liu <zhao1.liu@intel.com>
CC: "Daniel P . =?ISO-8859-1?Q?Berrang=E9?=" <berrange@redhat.com>, "Igor
 Mammedov" <imammedo@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Philippe =?ISO-8859-1?Q?Ma?=
 =?ISO-8859-1?Q?thieu-Daud=E9?= <philmd@linaro.org>, Yanan Wang
	<wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Richard Henderson
	<richard.henderson@linaro.org>, Sergio Lopez <slp@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Stefano Stabellini <sstabellini@kernel.org>, "Anthony
 PERARD" <anthony@xenproject.org>, Paul Durrant <paul@xen.org>, "Edgar E .
 Iglesias" <edgar.iglesias@gmail.com>, Eric Blake <eblake@redhat.com>, Markus
 Armbruster <armbru@redhat.com>, Alex =?ISO-8859-1?Q?Benn=E9e?=
	<alex.bennee@linaro.org>, Peter Maydell <peter.maydell@linaro.org>,
	<qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, <qemu-arm@nongnu.org>,
	"Zhenyu Wang" <zhenyu.z.wang@intel.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [RFC v2 05/12] hw/core/machine: Introduce custom CPU topology
 with max limitations
Message-ID: <20241008111651.000025ab@Huawei.com>
In-Reply-To: <20240919061128.769139-6-zhao1.liu@intel.com>
References: <20240919061128.769139-1-zhao1.liu@intel.com>
	<20240919061128.769139-6-zhao1.liu@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Thu, 19 Sep 2024 14:11:21 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> Custom topology allows user to create CPU topology totally via -device
> from CLI.
> 
> Once custom topology is enabled, machine will stop the default CPU
> creation and expect user's CPU topology tree built from CLI.
> 
> With custom topology, any CPU topology, whether symmetric or hybrid
> (aka, heterogeneous), can be created naturally.
> 
> However, custom topology also needs to be restricted because
> possible_cpus[] requires some preliminary topology information for
> initialization, which is the max limitation (the new max parameters in
> -smp). Custom topology will be subject to this max limitation.
> 
> Max limitations are necessary because creating custom topology before
> initializing possible_cpus[] would compromise future hotplug scalability.
> 
> Max limitations are placed in -smp, even though custom topology can be
> defined as hybrid. From an implementation perspective, any hybrid
> topology can be considered a subset of a complete SMP structure.
> Therefore, semantically, using max limitations to constrain hybrid
> topology is consistent.
> 
> Introduce custom CPU topology related properties in MachineClass. At the
> same time, add and parse max parameters from -smp, and store the max
> limitations in CPUSlot.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

A few code style comments inline.

J
> diff --git a/hw/cpu/cpu-slot.c b/hw/cpu/cpu-slot.c
> index 1cc3b32ed675..2d16a2729501 100644
> --- a/hw/cpu/cpu-slot.c
> +++ b/hw/cpu/cpu-slot.c

> +
> +bool machine_parse_custom_topo_config(MachineState *ms,
> +                                      const SMPConfiguration *config,
> +                                      Error **errp)
> +{
> +    MachineClass *mc = MACHINE_GET_CLASS(ms);
> +    CPUSlot *slot = ms->topo;
> +    bool is_valid;
> +    int maxcpus;
> +
> +    if (!slot) {
> +        return true;
> +    }
> +
> +    is_valid = config->has_maxsockets && config->maxsockets;
> +    if (mc->smp_props.custom_topo_supported) {
> +        slot->stat.entries[CPU_TOPOLOGY_LEVEL_SOCKET].max_limit =
> +            is_valid ? config->maxsockets : ms->smp.sockets;
> +    } else if (is_valid) {
> +        error_setg(errp, "maxsockets > 0 not supported "
> +                   "by this machine's CPU topology");
> +        return false;
> +    } else {
> +        slot->stat.entries[CPU_TOPOLOGY_LEVEL_SOCKET].max_limit =
> +            ms->smp.sockets;
> +    }
Having the error condition in the middle is rather confusing to
read to my eyes. Playing with equivalents I wonder what works best..


    if (!is_valid) {
        slot->stat.entries[CPU_TOPOLOGY_LEVEL_SOCKET].max_limit =
            ms->smp.sockets;
    } else if (mc->smp_props.custom_topo_supported) {
        slot->stat.entries[CPU_TOPOLOGY_LEVEL_SOCKET].max_limit =
            config->max_sockets;
    } else {
        error_setg...
        return false;
    }

or take the bad case out first.  Maybe this is a little obscure
though (assuming I even got it right) as it relies on the fact
that is_valid must be false for the legacy path.

    if (!mc->smp_props.custom_topo_supported && is_valid) {
        error_setg();
        return false;
    }

    slot->stat.entries[CPU_TOPOLOGY_LEVEL_SOCKET].max_limit =
          is_valid ? config->maxsockets : ms->smp.sockets;

Similar for other cases.

> +
> +    is_valid = config->has_maxdies && config->maxdies;
> +    if (mc->smp_props.custom_topo_supported &&
> +        mc->smp_props.dies_supported) {
> +        slot->stat.entries[CPU_TOPOLOGY_LEVEL_DIE].max_limit =
> +            is_valid ? config->maxdies : ms->smp.dies;
> +    } else if (is_valid) {
> +        error_setg(errp, "maxdies > 0 not supported "
> +                   "by this machine's CPU topology");
> +        return false;
> +    } else {
> +        slot->stat.entries[CPU_TOPOLOGY_LEVEL_DIE].max_limit =
> +            ms->smp.dies;
> +    }
> +
> +    is_valid = config->has_maxmodules && config->maxmodules;
> +    if (mc->smp_props.custom_topo_supported &&
> +        mc->smp_props.modules_supported) {
> +        slot->stat.entries[CPU_TOPOLOGY_LEVEL_MODULE].max_limit =
> +            is_valid ? config->maxmodules : ms->smp.modules;
> +    } else if (is_valid) {
> +        error_setg(errp, "maxmodules > 0 not supported "
> +                   "by this machine's CPU topology");
> +        return false;
> +    } else {
> +        slot->stat.entries[CPU_TOPOLOGY_LEVEL_MODULE].max_limit =
> +            ms->smp.modules;
> +    }
> +
> +    is_valid = config->has_maxcores && config->maxcores;
> +    if (mc->smp_props.custom_topo_supported) {
> +        slot->stat.entries[CPU_TOPOLOGY_LEVEL_CORE].max_limit =
> +            is_valid ? config->maxcores : ms->smp.cores;
> +    } else if (is_valid) {
> +        error_setg(errp, "maxcores > 0 not supported "
> +                   "by this machine's CPU topology");
> +        return false;
> +    } else {
> +        slot->stat.entries[CPU_TOPOLOGY_LEVEL_CORE].max_limit =
> +            ms->smp.cores;
> +    }
> +
> +    is_valid = config->has_maxthreads && config->maxthreads;
> +    if (mc->smp_props.custom_topo_supported) {
> +        slot->stat.entries[CPU_TOPOLOGY_LEVEL_THREAD].max_limit =
> +            is_valid ? config->maxthreads : ms->smp.threads;
> +    } else if (is_valid) {
> +        error_setg(errp, "maxthreads > 0 not supported "
> +                   "by this machine's CPU topology");
> +        return false;
> +    } else {
> +        slot->stat.entries[CPU_TOPOLOGY_LEVEL_THREAD].max_limit =
> +            ms->smp.threads;
> +    }
> +
> +    maxcpus = 1;
> +    /* Initizlize max_limit to 1, as members of CpuTopology. */
> +    for (int i = 0; i < CPU_TOPOLOGY_LEVEL__MAX; i++) {
> +        maxcpus *= slot->stat.entries[i].max_limit;
> +    }
> +
> +    if (!config->has_maxcpus) {
> +        ms->smp.max_cpus = maxcpus;
Maybe early return here to get rid of need for the else?

> +    } else {
> +        if (maxcpus != ms->smp.max_cpus) {

Unless this is going to get more complex later,  else if probably appropriate here
(if you don't drop the else above.

> +            error_setg(errp, "maxcpus (%d) should be equal to "
> +                       "the product of the remaining max parameters (%d)",
> +                       ms->smp.max_cpus, maxcpus);
> +            return false;
> +        }
> +    }
> +
> +    return true;
> +}


