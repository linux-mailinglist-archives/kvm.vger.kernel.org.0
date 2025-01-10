Return-Path: <kvm+bounces-35039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 329ABA08F9A
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 12:41:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48B933A623D
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 11:41:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5C3820B216;
	Fri, 10 Jan 2025 11:41:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52E31F5435
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 11:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736509269; cv=none; b=JHB0E9LPOJHgBSD2nOnWV82zIZ2Yyp/0zTt3wQQ02WU3kbjVZ/IKUVsy74kZqZopoS61DSXJ8uAq+/SqIGrSta+4XNzINstTVDkPMmaOh2adzdyMwzDn0Dv5k0fQaySkikUrx5QQQeM/74Kcrni7b4QZDzqd/NcNsPEsImXQfPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736509269; c=relaxed/simple;
	bh=E1eQHKQjUXsLvR6Q8wM0k3iv6ijgPu2Z+ZgMe2DR71g=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HqQ3A0RtuxFgVq2bzBuuIPQr1b+RrMH/xWaBvOlkxxbqkHtlW/l0P6pgQHv0WuENcv6tF0XR1WRwEh/+BKJS34aLMojc1OEUrrXPMRr0gW5ja1DmHMDdjp4jpemdWsDAgfuRjT9p7CKYtymQ6dH37p7/7UZbV9z383qD8AV6mUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YV0712p1Wz6GFfG;
	Fri, 10 Jan 2025 19:39:25 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 0D4E8140A08;
	Fri, 10 Jan 2025 19:41:03 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 10 Jan
 2025 12:41:02 +0100
Date: Fri, 10 Jan 2025 11:41:00 +0000
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Zhao Liu <zhao1.liu@intel.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Philippe =?ISO-8859-1?Q?Mathieu-D?=
 =?ISO-8859-1?Q?aud=E9?= <philmd@linaro.org>, "Daniel P . =?ISO-8859-1?Q?B?=
 =?ISO-8859-1?Q?errang=E9?=" <berrange@redhat.com>, Markus Armbruster
	<armbru@redhat.com>, Igor Mammedov <imammedo@redhat.com>, "Michael S.Tsirkin
 " <mst@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, Eduardo
 Habkost <eduardo@habkost.net>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>, Alireza Sanaee
	<alireza.sanaee@huawei.com>, "Sia Jee Heng" <jeeheng.sia@starfivetech.com>,
	<qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v7 0/5] i386: Support SMP Cache Topology
Message-ID: <20250110114100.00002296@huawei.com>
In-Reply-To: <20250108150150.1258529-1-zhao1.liu@intel.com>
References: <20250108150150.1258529-1-zhao1.liu@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Wed,  8 Jan 2025 23:01:45 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> Hi folks,
> 
> This is my v7.
> 
> Compared with v6 [1], v7 dropped the "thread" level cache topology
> (cache per thread):
> 
>  - Patch 1 is the new patch to reject "thread" parameter for smp-cache.
>  - Ptach 2 dropped cache per thread support.
>  (Others remain unchanged.)
> 
> There're several reasons:
> 
>  * Currently, neither i386 nor ARM have real hardware support for per-
>    thread cache.
>  * Supporting this special cache topology on ARM requires extra effort
>    [2].

Somewhat misleading perhaps and doesn't actually matter for this series.
QEMU describes SMT threads wrongly today in DT.
Fixing that shows the Linux kernel won't boot with the right description,
Ali is working on solving that at which point we'll fix DT in QEMU
and this will all work.

Longer term I don't think there is any way to describe thread private caches
in DT but as you observe, no one builds that hardware anyway. 

Hence I'm very much in favor of this change!

Resent as yet again my email client tripped over Daniel's name and scrambled the
header so a bunch of lists rejected it.
 
Jonathan


> 
> So it is unnecessary to support it at this moment, even though per-
> thread cache might have potential scheduling benefits for VMs without
> CPU affinity.
> 
> In the future, if there is a clear demand for this feature, the correct
> approach would be to add a new control field in MachineClass.smp_props
> and enable it only for the machines that require it.
> 
> 
> This series is based on the master branch at commit aa3a285b5bc5 ("Merge
> tag 'mem-2024-12-21' of https://github.com/davidhildenbrand/qemu into
> staging").
> 
> Smp-cache support of ARM side can be found at [3].
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
> The API design has been discussed heavily in [4].
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
> "topology" field accepts CPU topology levels including "core", "module",
> "cluster", "die", "socket", "book", "drawer" and a special value
> "default". (Note, now, in v7, smp-cache doesn't support "thread".)
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
> 
> [1]: Patch v6: https://lore.kernel.org/qemu-devel/20241219083237.265419-1-zhao1.liu@intel.com/
> [2]: Gap of cache per thread for ARM: https://lore.kernel.org/qemu-devel/Z3efFsigJ6SxhqMf@intel.com/#t
> [3]: ARM smp-cache: https://lore.kernel.org/qemu-devel/20250102152012.1049-1-alireza.sanaee@huawei.com/
> [4]: API disscussion: https://lore.kernel.org/qemu-devel/8734ndj33j.fsf@pond.sub.org/
> 
> Thanks and Best Regards,
> Zhao
> ---
> Alireza Sanaee (1):
>   i386/cpu: add has_caches flag to check smp_cache configuration
> 
> Zhao Liu (4):
>   hw/core/machine: Reject thread level cache
>   i386/cpu: Support module level cache topology
>   i386/cpu: Update cache topology with machine's configuration
>   i386/pc: Support cache topology in -machine for PC machine
> 
>  hw/core/machine-smp.c |  9 ++++++
>  hw/i386/pc.c          |  4 +++
>  include/hw/boards.h   |  3 ++
>  qemu-options.hx       | 30 +++++++++++++++++-
>  target/i386/cpu.c     | 71 ++++++++++++++++++++++++++++++++++++++++++-
>  5 files changed, 115 insertions(+), 2 deletions(-)
> 


