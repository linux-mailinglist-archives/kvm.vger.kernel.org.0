Return-Path: <kvm+bounces-29827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42B889B2AC3
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 09:51:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 661C91C21C65
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 08:51:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D7CA192B75;
	Mon, 28 Oct 2024 08:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GQKhCRAU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2B91925B3
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 08:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730105495; cv=none; b=EF90opaddtuCUcTAjBn+bqUe8R5bdn/1cQk+2nst4pre/FsE7CkH8lEi/IiHiznUmeO2j+Ch6B/YESWBGfS+V1hLEL1jblJCQWdFTuVTCXP7HDsdIRDf7NKHRfcjkowsqTE+YbH7ov64JMNVw9fky70P3aKCYvtjwAYh3rxSK+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730105495; c=relaxed/simple;
	bh=8L1Qggk0cO/GX078OJ6a+iuYdWikW0TufL29lkP9RIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MdoR6arJtmH1Dg3g1TUlRVRMBzg1Z52i+9ib6uLgLRTF/pG/cjcTMxWcTQN1C0JoMYhSL8h3/cMibungdVfGTQVkp2UreP2ODGUYX7E5rTYVLnV19+3BQtQKgamC2WQiN86JqgAQonfr2zqcStLiPiL6YKZVgkSUMe5OOJEPA3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GQKhCRAU; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730105493; x=1761641493;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8L1Qggk0cO/GX078OJ6a+iuYdWikW0TufL29lkP9RIA=;
  b=GQKhCRAUXqzleXbzDl4I6P0h8yssjYJgPdc04NxyzwB7AZ6/RPVuVj5E
   wkXIZfvO9SeCJdS77161OZClZ5unJqyq/Scr+fVe0n+e7jMHfi8B63yfW
   BcKAdU3ZN7gbWj2zhWY9VXTWm24Tj4Z3BvUVZHEgj1nLj5ySzkfXSNihZ
   2b4/cdM3KAB89nEnDXBq/A4SqQBnYkzGQs9wqI4Yby3tWiwVapMIq2xwm
   XBBIV06JKqx5GOve8XK8NkN6QA8XDrfPgwlwRAD6OzGkaRmFeeo1D5LGm
   o2edeueDHSGiLgMesnoMNA9efkEg3MDh/43jAOxVNhgjFDNSUenXTNCUV
   A==;
X-CSE-ConnectionGUID: yNkOcyyFRheLMXsBxZNHPw==
X-CSE-MsgGUID: B3xk4tY6Qx2WByHpBK1QXg==
X-IronPort-AV: E=McAfee;i="6700,10204,11238"; a="40269537"
X-IronPort-AV: E=Sophos;i="6.11,238,1725346800"; 
   d="scan'208";a="40269537"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 01:51:33 -0700
X-CSE-ConnectionGUID: UYTJblKwRC616HMCP7KpUQ==
X-CSE-MsgGUID: WiGWNA21TKaiDYgaMfHyDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,238,1725346800"; 
   d="scan'208";a="112388082"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 28 Oct 2024 01:51:27 -0700
Date: Mon, 28 Oct 2024 17:07:46 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH v4 0/9] Introduce SMP Cache Topology
Message-ID: <Zx9UYrOeF5Jij0NB@intel.com>
References: <20241022135151.2052198-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241022135151.2052198-1-zhao1.liu@intel.com>

Kindly Ping.

(Hi miantainers, all the patches have received Jonathan's review. Could
this series be accepted?)

Thanks,
Zhao

On Tue, Oct 22, 2024 at 09:51:42PM +0800, Zhao Liu wrote:
> Date: Tue, 22 Oct 2024 21:51:42 +0800
> From: Zhao Liu <zhao1.liu@intel.com>
> Subject: [PATCH v4 0/9] Introduce SMP Cache Topology
> X-Mailer: git-send-email 2.34.1
> 
> Hi all,
> 
> Compared with v3 [1], the v4 mainly changes these places:
> 
>  * Don't expose "invalid" enumeration in QAPI and define it by a
>    macro instead. (new patch 1, and updated patch 2)
> 
>  * Check cache topology after the arch machine loads the user-
>    configured cache model from MachineState.smp_cache and consumes
>    the special "default" level by replacing it with the specific level.
>    (new patch 5, and updated patch 7)
> 
>  * Describ the omitting cache will use "default" level and describ
>    the default cache topology model of i386 PC machine. (updated
>    patch 8)
> 
> All the above changes are tested and the interface design has remained
> stable.
> 
> Meanwhile, ARM side has also worked a lot on the smp-cache based on
> this series [2].
> 
> This series is based on the commit cc5adbbd50d8 ("Merge tag
> 'pull-tpm-2024-10-18-1' of https://github.com/stefanberger/qemu-tpm into
> staging").
> 
> Welcome your feedback, and I appreciate your reviews. Hope our series
> can catch up with the 9.2 cycle. :)
> 
> 
> Background
> ==========
> 
> The x86 and ARM (RISCV) need to allow user to configure cache properties
> (current only topology):
>  * For x86, the default cache topology model (of max/host CPU) does not
>    always match the Host's real physical cache topology. Performance can
>    increase when the configured virtual topology is closer to the
>    physical topology than a default topology would be.
>  * For ARM, QEMU can't get the cache topology information from the CPU
>    registers, then user configuration is necessary. Additionally, the
>    cache information is also needed for MPAM emulation (for TCG) to
>    build the right PPTT. (Originally from Jonathan)
> 
> 
> About smp-cache
> ===============
> 
> The API design has been discussed heavily in [3].
> 
> Now, smp-cache is implemented as a array integrated in -machine. Though
> -machine currently can't support JSON format, this is the one of the
> directions of future.
> 
> An example is as follows:
> 
> smp_cache=smp-cache.0.cache=l1i,smp-cache.0.topology=core,smp-cache.1.cache=l1d,smp-cache.1.topology=core,smp-cache.2.cache=l2,smp-cache.2.topology=module,smp-cache.3.cache=l3,smp-cache.3.topology=die
> 
> "cache" specifies the cache that the properties will be applied on. This
> field is the combination of cache level and cache type. Now it supports
> "l1d" (L1 data cache), "l1i" (L1 instruction cache), "l2" (L2 unified
> cache) and "l3" (L3 unified cache).
> 
> "topology" field accepts CPU topology levels including "thread", "core",
> "module", "cluster", "die", "socket", "book", "drawer" and a special
> value "default".
> 
> The "default" is introduced to make it easier for libvirt to set a
> default parameter value without having to care about the specific
> machine (because currently there is no proper way for machine to
> expose supported topology levels and caches).
> 
> If "default" is set, then the cache topology will follow the
> architecture's default cache topology model. If other CPU topology level
> is set, the cache will be shared at corresponding CPU topology level.
> 
> Welcome your feedback and review!
> 
> [1]: Patch v3: https://lore.kernel.org/qemu-devel/20241012104429.1048908-1-zhao1.liu@intel.com/
> [2]: ARM smp-cache: https://lore.kernel.org/qemu-devel/20241010111822.345-1-alireza.sanaee@huawei.com/
> [3]: API disscussion: https://lore.kernel.org/qemu-devel/8734ndj33j.fsf@pond.sub.org/
> 
> Thanks and Best Regards,
> Zhao
> ---
> Changelog:
> 
> Main changes since Patch v3:
>  * Stopped exposing "invalid" enumeration in QAPI and define it by a
>    macro instead. (Dainel)
>  * Checked cache topology after the arch machine loads the
>    user-configured cache model from MachineState.smp_cache and consumes
>    the special "default" level by replacing it with the specific level.
>    (Daniel)
>  * Described the omitting cache will use "default" level and described
>    the default cache topology model of i386 PC machine. (Daniel)
> 
> Main changes since Patch v2:
>  * Updated version of new QAPI structures to v9.2. (Jonathan)
>  * Merged the QAPI change and smp-cache property support of machine
>    into one commit. (Jonathan)
>  * Picked Alireza's patch to add a has_caches flag.
>  * Polished english and coding style. (Jonathan)
> 
> Main changes since Patch v1:
>  * Dropped handwriten smp-cache object and integrated cache properties
>    list into MachineState and used -machine to configure SMP cache
>    properties. (Markus)
>  * Dropped prefix of CpuTopologyLevel enumeration. (Markus)
>  * Rename CPU_TOPO_LEVEL_* to CPU_TOPOLOGY_LEVEL_* to match the QAPI's
>    generated code. (Markus)
>  * Renamed SMPCacheProperty/SMPCacheProperties (QAPI structures) to
>    SmpCacheProperties/SmpCachePropertiesWrapper. (Markus)
>  * Renamed SMPCacheName (QAPI structure) to SmpCacheLevelAndType and
>    dropped prefix. (Markus)
>  * Renamed 'name' field in SmpCacheProperties to 'cache', since the
>    type and level of the cache in SMP system could be able to specify
>    all of these kinds of cache explicitly enough.
>  * Renamed 'topo' field in SmpCacheProperties to 'topology'. (Markus)
>  * Returned error information when user repeats setting cache
>    properties. (Markus)
>  * Renamed SmpCacheLevelAndType to CacheLevelAndType, since this
>    representation is general across SMP or hybrid system.
>  * Dropped machine_check_smp_cache_support() and did the check when
>    -machine parses smp-cache in machine_parse_smp_cache().
> 
> Main changes since RFC v2:
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
>  * Referred to Daniel's suggestion to introduce cache JSON list, though
>    as a standalone object since -smp/-machine can't support JSON.
>  * Linked machine's smp_cache to smp-cache object instead of a builtin
>    structure. This is to get around the fact that the keyval format of
>    -machine can't support JSON.
>  * Wrapped the cache topology level access into a helper.
>  * Split as a separate commit to just include compatibility checking and
>    topology checking.
>  * Allow setting "default" topology level even though the cache
>    isn't supported by machine. (Daniel)
>  * Rewrote the document of smp-cache object.
> 
> Main changes since RFC v1:
>  * Split CpuTopology renaimg out of this RFC.
>  * Use QAPI to enumerate CPU topology levels.
>  * Drop string_to_cpu_topo() since QAPI will help to parse the topo
>    levels.
>  * Set has_*_cache field in machine_get_smp(). (JeeHeng)
>  * Use "*_cache=topo_level" as -smp example as the original "level"
>    term for a cache has a totally different meaning. (Jonathan)
> ---
> Alireza Sanaee (1):
>   i386/cpu: add has_caches flag to check smp_cache configuration
> 
> Zhao Liu (8):
>   i386/cpu: Don't enumerate the "invalid" CPU topology level
>   hw/core: Make CPU topology enumeration arch-agnostic
>   qapi/qom: Define cache enumeration and properties for machine
>   hw/core: Check smp cache topology support for machine
>   hw/core: Add a helper to check the cache topology level
>   i386/cpu: Support thread and module level cache topology
>   i386/cpu: Update cache topology with machine's configuration
>   i386/pc: Support cache topology in -machine for PC machine
> 
>  hw/core/machine-smp.c      | 128 +++++++++++++++++++++
>  hw/core/machine.c          |  44 ++++++++
>  hw/i386/pc.c               |   4 +
>  hw/i386/x86-common.c       |   4 +-
>  include/hw/boards.h        |  19 ++++
>  include/hw/i386/topology.h |  22 +---
>  qapi/machine-common.json   |  94 +++++++++++++++-
>  qemu-options.hx            |  31 ++++-
>  target/i386/cpu.c          | 225 ++++++++++++++++++++++++-------------
>  target/i386/cpu.h          |   4 +-
>  10 files changed, 474 insertions(+), 101 deletions(-)
> 
> -- 
> 2.34.1
> 
> 

