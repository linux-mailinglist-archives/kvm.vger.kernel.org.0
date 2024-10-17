Return-Path: <kvm+bounces-29088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F158C9A2695
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 17:30:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64F0AB222EB
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 15:30:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A35DB1DE4D3;
	Thu, 17 Oct 2024 15:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HvZj2vsh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC83E33086
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 15:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729179026; cv=none; b=qwPyAUtEbn52qQqQF7lA0mHSoB8ZHfKyXTwIMfvd1+V1tcgZXiit1nyYCesNPedgYKdQgvgxeDvPOBLb4OISPsc8eETyEUxD/IsTL2XLhhZnvN/4Ni/fZtgPH1AnmboxZWlTE3TaIvhG0bWqIPuf7mjk/gwgvCPFz37NF0B8HhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729179026; c=relaxed/simple;
	bh=BbfYKbf9BExcGoTDQCDoAV2zHecuktHEPNpQj9hetmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ERwrc5ABmhpjscI3imI+sU5lajjUBnTAYxxzfwi80MZksEznnbeMFpFS68trO+8RZp3u1GwjT51BtdxSHAsdJC+jqOOCSml8FKevuMZx2EldJaOD52Wh8ZvckTp+qVn9wZ6eNjYj6qzeNotWgQ9HZ6EvxPDbNCvGgvYicdjv4H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HvZj2vsh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729179020;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=t1Xf++nCYGqvn/3bHmYFDtUgvJ4VAkFrA294hdhwlUo=;
	b=HvZj2vshIAS/qeRj6Xi7DQmDf2duD+sBaX5f79CRMFDb1XT0JaKAQpyqGtlkCd3NAXwIfB
	Aq5TLlySyG/wH4MlzxBH4h8vHqOdZEi5rIVtxQk5hIfMHnMbxI0Ch0+qUfJjvE9zuJCAd6
	EsWXWgPI7KU51isyU7OTnjrvriUtDLA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-84ov-eGgM-6A_V_UMaU9cw-1; Thu,
 17 Oct 2024 11:30:17 -0400
X-MC-Unique: 84ov-eGgM-6A_V_UMaU9cw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3453819560BA;
	Thu, 17 Oct 2024 15:30:15 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.94])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CE6E519560A2;
	Thu, 17 Oct 2024 15:30:06 +0000 (UTC)
Date: Thu, 17 Oct 2024 16:30:03 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH v3 1/7] hw/core: Make CPU topology enumeration
 arch-agnostic
Message-ID: <ZxEte1KBwWuCdkb1@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241012104429.1048908-1-zhao1.liu@intel.com>
 <20241012104429.1048908-2-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241012104429.1048908-2-zhao1.liu@intel.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Sat, Oct 12, 2024 at 06:44:23PM +0800, Zhao Liu wrote:
> Cache topology needs to be defined based on CPU topology levels. Thus,
> define CPU topology enumeration in qapi/machine.json to make it generic
> for all architectures.
> 
> To match the general topology naming style, rename CPU_TOPO_LEVEL_* to
> CPU_TOPOLOGY_LEVEL_*, and rename SMT and package levels to thread and
> socket.
> 
> Also, enumerate additional topology levels for non-i386 arches, and add
> a CPU_TOPOLOGY_LEVEL_DEFAULT to help future smp-cache object to work
> with compatibility requirement of arch-specific cache topology models.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> ---
> Changes since Patch v2:
>  * Updated version of new QAPI structures to v9.2. (Jonathan)
> 
> Changes since Patch v1:
>  * Dropped prefix of CpuTopologyLevel enumeration. (Markus)
>  * Rename CPU_TOPO_LEVEL_* to CPU_TOPOLOGY_LEVEL_* to match the QAPI's
>    generated code. (Markus)
> 
> Changes since RFC v2:
>  * Dropped cpu-topology.h and cpu-topology.c since QAPI has the helper
>    (CpuTopologyLevel_str) to convert enum to string. (Markus)
>  * Fixed text format in machine.json (CpuTopologyLevel naming, 2 spaces
>    between sentences). (Markus)
>  * Added a new level "default" to de-compatibilize some arch-specific
>    topo settings. (Daniel)
>  * Moved CpuTopologyLevel to qapi/machine-common.json, at where the
>    cache enumeration and smp-cache object would be added.
>    - If smp-cache object is defined in qapi/machine.json, storage-daemon
>      will complain about the qmp cmds in qapi/machine.json during
>      compiling.
> 
> Changes since RFC v1:
>  * Used QAPI to enumerate CPU topology levels.
>  * Dropped string_to_cpu_topo() since QAPI will help to parse the topo
>    levels.
> ---
>  hw/i386/x86-common.c       |   4 +-
>  include/hw/i386/topology.h |  22 +-----
>  qapi/machine-common.json   |  46 +++++++++++-
>  target/i386/cpu.c          | 144 ++++++++++++++++++-------------------
>  target/i386/cpu.h          |   4 +-
>  5 files changed, 124 insertions(+), 96 deletions(-)
> 

> diff --git a/include/hw/i386/topology.h b/include/hw/i386/topology.h
> index dff49fce1154..bf740383038b 100644
> --- a/include/hw/i386/topology.h
> +++ b/include/hw/i386/topology.h
> @@ -39,7 +39,7 @@

>      unsigned threads_per_core;
>  } X86CPUTopoInfo;
>  
> -/*
> - * CPUTopoLevel is the general i386 topology hierarchical representation,
> - * ordered by increasing hierarchical relationship.
> - * Its enumeration value is not bound to the type value of Intel (CPUID[0x1F])
> - * or AMD (CPUID[0x80000026]).
> - */
> -enum CPUTopoLevel {
> -    CPU_TOPO_LEVEL_INVALID,
> -    CPU_TOPO_LEVEL_SMT,
> -    CPU_TOPO_LEVEL_CORE,
> -    CPU_TOPO_LEVEL_MODULE,
> -    CPU_TOPO_LEVEL_DIE,
> -    CPU_TOPO_LEVEL_PACKAGE,
> -    CPU_TOPO_LEVEL_MAX,
> -};
> -

snip

> @@ -18,3 +18,47 @@
>  ##
>  { 'enum': 'S390CpuEntitlement',
>    'data': [ 'auto', 'low', 'medium', 'high' ] }
> +
> +##
> +# @CpuTopologyLevel:
> +#
> +# An enumeration of CPU topology levels.
> +#
> +# @invalid: Invalid topology level.

Previously all topology levels were internal to QEMU, and IIUC
this CPU_TOPO_LEVEL_INVALID appears to have been a special
value to indicate  the cache was absent ?

Now we're exposing this directly to the user as a settable
option. We need to explain what effect setting 'invalid'
has on the CPU cache config.

> +#
> +# @thread: thread level, which would also be called SMT level or
> +#     logical processor level.  The @threads option in
> +#     SMPConfiguration is used to configure the topology of this
> +#     level.
> +#
> +# @core: core level.  The @cores option in SMPConfiguration is used
> +#     to configure the topology of this level.
> +#
> +# @module: module level.  The @modules option in SMPConfiguration is
> +#     used to configure the topology of this level.
> +#
> +# @cluster: cluster level.  The @clusters option in SMPConfiguration
> +#     is used to configure the topology of this level.
> +#
> +# @die: die level.  The @dies option in SMPConfiguration is used to
> +#     configure the topology of this level.
> +#
> +# @socket: socket level, which would also be called package level.
> +#     The @sockets option in SMPConfiguration is used to configure
> +#     the topology of this level.
> +#
> +# @book: book level.  The @books option in SMPConfiguration is used
> +#     to configure the topology of this level.
> +#
> +# @drawer: drawer level.  The @drawers option in SMPConfiguration is
> +#     used to configure the topology of this level.
> +#
> +# @default: default level.  Some architectures will have default
> +#     topology settings (e.g., cache topology), and this special
> +#     level means following the architecture-specific settings.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


