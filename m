Return-Path: <kvm+bounces-18644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EF6888D821A
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:20:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B7711F237F6
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 12:20:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E06B912C466;
	Mon,  3 Jun 2024 12:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EwBadnHW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3639D12D20D
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 12:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717417154; cv=none; b=AymwMsT5GVfL2u4btLh1DA9I5nMwqi4vSVDRJc2JDwcSAhxJjw8hRuQ5cprDU0Iba3Oyk4ANJx/Pf0qAnbWjUf8mwlKiu02VjPLOTqjTDt0xWFBJ1cMB9y7d4gIfJVMwGMO+yBm8RwLMCCTp19Z3oQSQFpiDTzo355yXdWV3uVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717417154; c=relaxed/simple;
	bh=JRGg6G9U6Jc0ICotwrJxAACHNlp/5AZ84dLcESgbomc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Aw4lDLuYcOHCIsdiJm/BbfcY22g/jxFMydpNW6o6ecrMAjdakuebbE7u14E+bUZJdmsbWiV+UPRGc+wZ1fxPoxc3MNn74LDjTgEquntcYMFMhjuoiqvud9UmMFvygr4qGRto1MvxsTJ7ZYM8nYz8Xk5e3srGG5fgWZK3rb8cRvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EwBadnHW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717417151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jpPGUxRfLC9lufqxPrIETHhm/prOnpC8Fj4J3nxx8w4=;
	b=EwBadnHWNTyiDl3HG3SbJCxBEAM8Gda/cUvmu9QbYz/MCDsMmiOSngqXsb+qp0w2bnIijg
	ZN+YJgF9nrWdxX52eMbbjS4fF7t4yo6Pfl8wP9hHLkMTdaY/Y91W6Zsy3UiRscxcfMFkvI
	GzSRnCihx9YowAV8zNZc4SIpprcdNyM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-118-Abl5ND4MMDyk-ELq31WW2w-1; Mon,
 03 Jun 2024 08:19:05 -0400
X-MC-Unique: Abl5ND4MMDyk-ELq31WW2w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E01023806703;
	Mon,  3 Jun 2024 12:19:03 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.93])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F3C6E402EB4;
	Mon,  3 Jun 2024 12:19:02 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 2063C21E66E5; Mon,  3 Jun 2024 14:19:02 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Daniel P . =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>,  Eduardo
 Habkost
 <eduardo@habkost.net>,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Yanan Wang
 <wangyanan55@huawei.com>,  "Michael S . Tsirkin" <mst@redhat.com>,  Paolo
 Bonzini <pbonzini@redhat.com>,  Richard Henderson
 <richard.henderson@linaro.org>,  Eric Blake <eblake@redhat.com>,  Marcelo
 Tosatti <mtosatti@redhat.com>,  Alex =?utf-8?Q?Benn=C3=A9e?=
 <alex.bennee@linaro.org>,
  Peter Maydell <peter.maydell@linaro.org>,  Jonathan Cameron
 <Jonathan.Cameron@huawei.com>,  Sia Jee Heng
 <jeeheng.sia@starfivetech.com>,  qemu-devel@nongnu.org,
  kvm@vger.kernel.org,  qemu-riscv@nongnu.org,  qemu-arm@nongnu.org,
  Zhenyu Wang <zhenyu.z.wang@intel.com>,  Dapeng Mi
 <dapeng1.mi@linux.intel.com>,  Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [RFC v2 1/7] hw/core: Make CPU topology enumeration arch-agnostic
In-Reply-To: <20240530101539.768484-2-zhao1.liu@intel.com> (Zhao Liu's message
	of "Thu, 30 May 2024 18:15:33 +0800")
References: <20240530101539.768484-1-zhao1.liu@intel.com>
	<20240530101539.768484-2-zhao1.liu@intel.com>
Date: Mon, 03 Jun 2024 14:19:02 +0200
Message-ID: <87y17mfccp.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Zhao Liu <zhao1.liu@intel.com> writes:

> Cache topology needs to be defined based on CPU topology levels. Thus,
> define CPU topology enumeration in qapi/machine.json to make it generic
> for all architectures.
>
> To match the general topology naming style, rename CPU_TOPO_LEVEL_SMT
> and CPU_TOPO_LEVEL_PACKAGE to CPU_TOPO_LEVEL_THREAD and
> CPU_TOPO_LEVEL_SOCKET.
>
> Also, enumerate additional topology levels for non-i386 arches, and add
> helpers for topology enumeration and string conversion.
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changes since RFC v1:
>  * Use QAPI to enumerate CPU topology levels.
>  * Drop string_to_cpu_topo() since QAPI will help to parse the topo
>    levels.
> ---
>  MAINTAINERS                    |  2 ++
>  hw/core/cpu-topology.c         | 36 ++++++++++++++++++++++++++++++
>  hw/core/meson.build            |  1 +
>  include/hw/core/cpu-topology.h | 20 +++++++++++++++++
>  include/hw/i386/topology.h     | 18 +--------------
>  qapi/machine.json              | 40 ++++++++++++++++++++++++++++++++++
>  target/i386/cpu.c              | 30 ++++++++++++-------------
>  target/i386/cpu.h              |  4 ++--
>  8 files changed, 117 insertions(+), 34 deletions(-)
>  create mode 100644 hw/core/cpu-topology.c
>  create mode 100644 include/hw/core/cpu-topology.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 448dc951c509..09173e8c953d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1875,6 +1875,7 @@ R: Yanan Wang <wangyanan55@huawei.com>
>  S: Supported
>  F: hw/core/cpu-common.c
>  F: hw/core/cpu-sysemu.c
> +F: hw/core/cpu-topology.c
>  F: hw/core/machine-qmp-cmds.c
>  F: hw/core/machine.c
>  F: hw/core/machine-smp.c
> @@ -1886,6 +1887,7 @@ F: qapi/machine-common.json
>  F: qapi/machine-target.json
>  F: include/hw/boards.h
>  F: include/hw/core/cpu.h
> +F: include/hw/core/cpu-topology.h
>  F: include/hw/cpu/cluster.h
>  F: include/sysemu/numa.h
>  F: tests/unit/test-smp-parse.c
> diff --git a/hw/core/cpu-topology.c b/hw/core/cpu-topology.c
> new file mode 100644
> index 000000000000..20b5d708cb54
> --- /dev/null
> +++ b/hw/core/cpu-topology.c
> @@ -0,0 +1,36 @@
> +/*
> + * QEMU CPU Topology Representation
> + *
> + * Copyright (c) 2024 Intel Corporation
> + *
> + * Authors:
> + *  Zhao Liu <zhao1.liu@intel.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or
> + * later.  See the COPYING file in the top-level directory.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "hw/core/cpu-topology.h"
> +
> +typedef struct CPUTopoInfo {
> +    const char *name;
> +} CPUTopoInfo;
> +
> +CPUTopoInfo cpu_topo_descriptors[] = {
> +    [CPU_TOPO_LEVEL_INVALID] = { .name = "invalid", },
> +    [CPU_TOPO_LEVEL_THREAD]  = { .name = "thread",  },
> +    [CPU_TOPO_LEVEL_CORE]    = { .name = "core",    },
> +    [CPU_TOPO_LEVEL_MODULE]  = { .name = "module",  },
> +    [CPU_TOPO_LEVEL_CLUSTER] = { .name = "cluster", },
> +    [CPU_TOPO_LEVEL_DIE]     = { .name = "die",     },
> +    [CPU_TOPO_LEVEL_SOCKET]  = { .name = "socket",  },
> +    [CPU_TOPO_LEVEL_BOOK]    = { .name = "book",    },
> +    [CPU_TOPO_LEVEL_DRAWER]  = { .name = "drawer",  },
> +    [CPU_TOPO_LEVEL__MAX]    = { .name = NULL,      },
> +};

This looks redundant with generated

    const QEnumLookup CPUTopoLevel_lookup = {
        .array = (const char *const[]) {
            [CPU_TOPO_LEVEL_INVALID] = "invalid",
            [CPU_TOPO_LEVEL_THREAD] = "thread",
            [CPU_TOPO_LEVEL_CORE] = "core",
            [CPU_TOPO_LEVEL_MODULE] = "module",
            [CPU_TOPO_LEVEL_CLUSTER] = "cluster",
            [CPU_TOPO_LEVEL_DIE] = "die",
            [CPU_TOPO_LEVEL_SOCKET] = "socket",
            [CPU_TOPO_LEVEL_BOOK] = "book",
            [CPU_TOPO_LEVEL_DRAWER] = "drawer",
        },
        .size = CPU_TOPO_LEVEL__MAX
    };

> +
> +const char *cpu_topo_to_string(CPUTopoLevel topo)
> +{
> +    return cpu_topo_descriptors[topo].name;
> +}

And this with generated CPUTopoLevel_str().

> diff --git a/hw/core/meson.build b/hw/core/meson.build
> index a3d9bab9f42a..71dc396e9bfc 100644
> --- a/hw/core/meson.build
> +++ b/hw/core/meson.build
> @@ -13,6 +13,7 @@ hwcore_ss.add(files(
>  ))
>  
>  common_ss.add(files('cpu-common.c'))
> +common_ss.add(files('cpu-topology.c'))
>  common_ss.add(files('machine-smp.c'))
>  system_ss.add(when: 'CONFIG_FITLOADER', if_true: files('loader-fit.c'))
>  system_ss.add(when: 'CONFIG_GENERIC_LOADER', if_true: files('generic-loader.c'))
> diff --git a/include/hw/core/cpu-topology.h b/include/hw/core/cpu-topology.h
> new file mode 100644
> index 000000000000..0e21fe8a9bf8
> --- /dev/null
> +++ b/include/hw/core/cpu-topology.h
> @@ -0,0 +1,20 @@
> +/*
> + * QEMU CPU Topology Representation Header
> + *
> + * Copyright (c) 2024 Intel Corporation
> + *
> + * Authors:
> + *  Zhao Liu <zhao1.liu@intel.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or
> + * later.  See the COPYING file in the top-level directory.
> + */
> +
> +#ifndef CPU_TOPOLOGY_H
> +#define CPU_TOPOLOGY_H
> +
> +#include "qapi/qapi-types-machine.h"
> +
> +const char *cpu_topo_to_string(CPUTopoLevel topo);
> +
> +#endif /* CPU_TOPOLOGY_H */
> diff --git a/include/hw/i386/topology.h b/include/hw/i386/topology.h
> index dff49fce1154..c6ff75f23991 100644
> --- a/include/hw/i386/topology.h
> +++ b/include/hw/i386/topology.h
> @@ -39,7 +39,7 @@
>   *  CPUID Fn8000_0008_ECX[ApicIdCoreIdSize[3:0]] is set to apicid_core_width().
>   */
>  
> -
> +#include "hw/core/cpu-topology.h"
>  #include "qemu/bitops.h"
>  
>  /*
> @@ -62,22 +62,6 @@ typedef struct X86CPUTopoInfo {
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
>  /* Return the bit width needed for 'count' IDs */
>  static unsigned apicid_bitwidth_for_count(unsigned count)
>  {
> diff --git a/qapi/machine.json b/qapi/machine.json
> index bce6e1bbc412..7ac5a05bb9c9 100644
> --- a/qapi/machine.json
> +++ b/qapi/machine.json
> @@ -1667,6 +1667,46 @@
>       '*reboot-timeout': 'int',
>       '*strict': 'bool' } }
>  
> +##
> +# @CPUTopoLevel:
> +#
> +# An enumeration of CPU topology levels.
> +#
> +# @invalid: Invalid topology level, used as a placeholder.

Placeholder for what?

> +#
> +# @thread: thread level, which would also be called SMT level or logical
> +#     processor level. The @threads option in -smp is used to configure
> +#     the topology of this level.
> +#
> +# @core: core level. The @cores option in -smp is used to configure the
> +#     topology of this level.
> +#
> +# @module: module level. The @modules option in -smp is used to
> +#     configure the topology of this level.
> +#
> +# @cluster: cluster level. The @clusters option in -smp is used to
> +#     configure the topology of this level.
> +#
> +# @die: die level. The @dies option in -smp is used to configure the
> +#     topology of this level.
> +#
> +# @socket: socket level, which would also be called package level. The
> +#     @sockets option in -smp is used to configure the topology of this
> +#     level.
> +#
> +# @book: book level. The @books option in -smp is used to configure the
> +#     topology of this level.
> +#
> +# @drawer: drawer level. The @drawers option in -smp is used to
> +#     configure the topology of this level.

As far as I can tell, -smp is sugar for machine property "smp" of QAPI
type SMPConfiguration.  Should we refer to SMPConfiguration instead of
-smp?

> +#
> +# Since: 9.1
> +##
> +{ 'enum': 'CPUTopoLevel',
> +  'prefix': 'CPU_TOPO_LEVEL',
> +  'data': [ 'invalid', 'thread', 'core', 'module', 'cluster',
> +            'die', 'socket', 'book', 'drawer' ] }
> +
>  ##
>  # @SMPConfiguration:
>  #

[...]


