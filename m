Return-Path: <kvm+bounces-9303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EDCF485D812
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 13:41:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 730451F2281A
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 12:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B60996931D;
	Wed, 21 Feb 2024 12:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fL1f6Xjc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CA36930D
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 12:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708519305; cv=none; b=ReOBMw3zBDCJkvc6YJnyxQfKgqYTZBvtFCGXxN4hC67V/WVlB9LXC0A8kfj78hk3S4eMCuqRfxH1F239igyRQnP4jSIKTQzYKkVdDTOQxcgw43uFf6ueHrpRjupmnlkr2KxF7YZt8kJnbr0cKfZe6WW8Z3aArmwb0edbTUk70sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708519305; c=relaxed/simple;
	bh=7pI4QLw+nCzyuht2evuVZPbwoAcV4qAdKmJ4nHFNvq4=;
	h=From:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=O/nWc+Lr6kBYBwwioqlf2GxAzYiAtACx0l0AaihPidnhIq48AOYKc+3JVd7BBiKcdp1d4kvQ+/sgSr/2pF83Ug4FjlFt1kIHBI1ojaJ1XPlC5rIrCQ8m1jAflcyEqFKYWhDBtQinzmv9+cMa6u6jhRuXroU+5hv78KtnVpg6dLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fL1f6Xjc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708519302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hfCTcbflO1YjVk3OzUtGo+Ok/3XvaaHLHZiWYZpHLsE=;
	b=fL1f6XjcW26VFfDoWoN/8erqRC1GVMNBNgR3vOSxBXn4rQCWxM1NFM4/i/dRu0PF+mXpwR
	yOmJZ1petWHdzuVziLBpf174kL6PNK+v9cq2k0LrdwCT3uJgKkQQHEqerh/tOpBRJfKj+7
	Wi5ru57GLA+dNUuZOfzwC7iyQ7aj57Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-SUvk1-neMiWrj2J9JMWqhw-1; Wed, 21 Feb 2024 07:41:39 -0500
X-MC-Unique: SUvk1-neMiWrj2J9JMWqhw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4ED9A82DFE1;
	Wed, 21 Feb 2024 12:41:38 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.55])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 801DE8CE8;
	Wed, 21 Feb 2024 12:41:37 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 639E121E66C8; Wed, 21 Feb 2024 13:41:35 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,  Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,
  Yanan Wang <wangyanan55@huawei.com>,  "Michael S . Tsirkin"
 <mst@redhat.com>,  Paolo Bonzini <pbonzini@redhat.com>,  Richard Henderson
 <richard.henderson@linaro.org>,  Eric Blake <eblake@redhat.com>,  Marcelo
 Tosatti <mtosatti@redhat.com>,  qemu-devel@nongnu.org,
  kvm@vger.kernel.org,  Babu Moger <babu.moger@amd.com>,  Xiaoyao Li
 <xiaoyao.li@intel.com>,  Zhenyu Wang <zhenyu.z.wang@intel.com>,  Zhuocheng
 Ding <zhuocheng.ding@intel.com>,  Yongwei Ma <yongwei.ma@intel.com>,  Zhao
 Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v8 00/21] Introduce smp.modules for x86 in QEMU
In-Reply-To: <20240131101350.109512-1-zhao1.liu@linux.intel.com> (Zhao Liu's
	message of "Wed, 31 Jan 2024 18:13:29 +0800")
References: <20240131101350.109512-1-zhao1.liu@linux.intel.com>
MTo: Zhao Liu <zhao1.liu@linux.intel.com>
Date: Wed, 21 Feb 2024 13:41:35 +0100
Message-ID: <87plwqgfb4.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Zhao Liu <zhao1.liu@linux.intel.com> writes:

> From: Zhao Liu <zhao1.liu@intel.com>
>
> Hi list,
>
> This is the our v8 patch series, rebased on the master branch at the
> commit 11be70677c70 ("Merge tag 'pull-vfio-20240129' of
> https://github.com/legoater/qemu into staging").
>
> Compared with v7 [1], v8 mainly has the following changes:
>   * Introduced smp.modules for x86 instead of reusing current
>     smp.clusters.
>   * Reworte the CPUID[0x1F] encoding.
>
> Given the code change, I dropped the most previously gotten tags
> (Acked-by/Reviewed-by/Tested-by from Michael & Babu, thanks for your
> previous reviews and tests!) in v8.
>
> With the description of the new modules added to x86 arch code in v7 [1]
> cover letter, the following sections are mainly the description of
> the newly added smp.modules (since v8) as supplement.
>
> Welcome your comments!
>
>
> Why We Need a New CPU Topology Level
> ====================================
>
> For the discussion in v7 about whether we should reuse current
> smp.clusters for x86 module, the core point is what's the essential
> differences between x86 module and general cluster.
>
> Since, cluster (for ARM/riscv) lacks a comprehensive and rigorous
> hardware definition, and judging from the description of smp.clusters
> [2] when it was introduced by QEMU, x86 module is very similar to
> general smp.clusters: they are all a layer above existing core level
> to organize the physical cores and share L2 cache.
>
> However, after digging deeper into the description and use cases of
> cluster in the device tree [3], I realized that the essential
> difference between clusters and modules is that cluster is an extremely
> abstract concept:
>   * Cluster supports nesting though currently QEMU doesn't support
>     nested cluster topology. However, modules will not support nesting.
>   * Also due to nesting, there is great flexibility in sharing resources
>     on clusters, rather than narrowing cluster down to sharing L2 (and
>     L3 tags) as the lowest topology level that contains cores.
>   * Flexible nesting of cluster allows it to correspond to any level
>     between the x86 package and core.
>
> Based on the above considerations, and in order to eliminate the naming
> confusion caused by the mapping between general cluster and x86 module
> in v7, we now formally introduce smp.modules as the new topology level.
>
>
> Where to Place Module in Existing Topology Levels
> =================================================
>
> The module is, in existing hardware practice, the lowest layer that
> contains the core, while the cluster is able to have a higher topological
> scope than the module due to its nesting.
>
> Thereby, we place the module between the cluster and the core, viz:
>
>     drawer/book/socket/die/cluster/module/core/thread
>
>
> Additional Consideration on CPU Topology
> ========================================
>
> Beyond this patchset, nowadays, different arches have different topology
> requirements, and maintaining arch-agnostic general topology in SMP
> becomes to be an increasingly difficult thing due to differences in
> sharing resources and special flexibility (e.g., nesting):
>   * It becomes difficult to put together all CPU topology hierarchies of
>     different arches to define complete topology order.
>   * It also becomes complex to ensure the correctness of the topology
>     calculations.
>       - Now the max_cpus is calculated by multiplying all topology
>         levels, and too many topology levels can easily cause omissions.
>
> Maybe we should consider implementing arch-specfic topology hierarchies.
>
>
> [1]: https://lore.kernel.org/qemu-devel/20240108082727.420817-1-zhao1.liu@linux.intel.com/
> [2]: https://lists.gnu.org/archive/html/qemu-devel/2023-02/msg04051.html
> [3]: https://www.kernel.org/doc/Documentation/devicetree/bindings/cpu/cpu-topology.txt

Have you considered putting an abridged version of your lovely rationale
into a commit message, so it can be found later more easily?


