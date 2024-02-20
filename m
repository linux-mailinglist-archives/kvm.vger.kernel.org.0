Return-Path: <kvm+bounces-9227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2CEB85C580
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 21:07:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A796E283845
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 20:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FF9614AD2C;
	Tue, 20 Feb 2024 20:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wK4RoIdI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6482214A4E1
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 20:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708459648; cv=none; b=ZDQGYiTa+UNWBcL2f2orSqoHu6cFSixRbBHkIHYZey5mzAXZ959Vzl3D8LHAJafwMnbTvF8aqKOI5OsIHMVP5wbtv4saL8piBwDLQdb7eR04JRTDzi9f91t2dUBoXQT/dK3QpOpTDmfbqIRp79z97fygZ2cnC2l4nJlTg9zZUoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708459648; c=relaxed/simple;
	bh=NcGBFf6/8ExPxt83VguPvVgAd6PORW8gdFImbTO9FOo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qt2JSURTyngKBxKAEH/2gbC1EXraPZMY92YoVRB3qJ/+IcASdforpRAkAuRdGk/nYxtXrmm1DajGCWXSxGbps0rOZy/ZD+hrDne1xKws9KpmRBBhTEopnIuLguFz9W4KHevXgkZyCTVefrOnsnES9ExLxV81B/RgwPsFasZXwss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wK4RoIdI; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4127008decdso7413085e9.1
        for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 12:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708459644; x=1709064444; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k6QpmIrhO156cbOXHJUpDUKmevIjeRjpwIrR8hjtAbQ=;
        b=wK4RoIdIzIKp9Pb+l91gN80TTMpLTfUeCPBi2JGbcLfbmGeaPt3dCDgKg98ETNSURT
         LXRXdktUyTDOHv/Gfn3ediXNhKNVRZ5rzm6tHROSjvRmqG2cXn3VejptsDbR+87z9WQv
         7wx1ksL84vhjoX4nBFIzMQ/Ie0+MjZFHXmVhiELuiTz5Ra3QttHGszoHB9PacoIHWi8N
         u6Ca1MOV3NjGpPdKLVgVYY9pDX8FfYlAeOraVViStq04FkNFeLaucV01YYsa2hS5pWCE
         pie4vdEOzgYdR6MkBakUgh9MP4wVR+wrx+bwnA+O9z2/3Z56DJyBLOqmDLat88iEQCK1
         dJUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708459644; x=1709064444;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k6QpmIrhO156cbOXHJUpDUKmevIjeRjpwIrR8hjtAbQ=;
        b=PA24ix5ly4EbSxWj7GJMayeeVtswFtyzH2+tV/mnZatVTsppfMBUoxVreRYN5i9eI8
         VuoP2luTDCvPX9bLS6A1F1IGQOuqgk+QFjRBfcnKBbfESuXGODCMEW8H2ulnqNyAtRt/
         tpwURxLezDZyrpMxTGxiOH3zjhi4zkBhMqRE8yyfG3B2cnduz/d/aQY+smFt/XBbN1Xo
         HwAChaZ90YKGKWhIvi1hl0IjZ9OP04mP4biztE9cF9Gw3iD6gA2/8ENRkvRq74qUiYy/
         Cvebr1cBVnAqbTtZrSD04gVYMMlm+QbYkdJTQJkvlczVDO3QCEcRjhYjRQHm4qRgUxKC
         4EpQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/yGygmBvzsjvW+qmaNxM9kxPqq2N7VPZ6lvjSHBF6oCSfuTi6TPsHZAxPfrhFVJ32VNp20N5sT/bLioOH/pAnnbHB
X-Gm-Message-State: AOJu0YxjRakHsqsXPwmod/yqYv5yqPsfJ/L/8HSeZ4LdgYk5EAxNmhy+
	XZl56xHf0hvjEi36DnQnTL3t2hDdt5QJKeT4QcARON8WWKqj8lsdt3AZtfWt1gI=
X-Google-Smtp-Source: AGHT+IEK4McQ9T2zv4lpqwKdXmWgKuJpwjl6tPduodUX7Bi2cOqfM4N4H1y3ia21UAyHWI4vOXM/4A==
X-Received: by 2002:a05:600c:3550:b0:412:6e2f:5f9c with SMTP id i16-20020a05600c355000b004126e2f5f9cmr2164615wmq.7.1708459644586;
        Tue, 20 Feb 2024 12:07:24 -0800 (PST)
Received: from [192.168.69.100] (mek33-h02-176-184-23-7.dsl.sta.abo.bbox.fr. [176.184.23.7])
        by smtp.gmail.com with ESMTPSA id v16-20020a05600c471000b004126f8c68eesm3020698wmo.3.2024.02.20.12.07.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 12:07:23 -0800 (PST)
Message-ID: <66cf4c35-5f19-4e5e-a0a1-adb1ab7cf8f4@linaro.org>
Date: Tue, 20 Feb 2024 21:07:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/8] Introduce SMP Cache Topology
Content-Language: en-US
To: Zhao Liu <zhao1.liu@linux.intel.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Peter Maydell <peter.maydell@linaro.org>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Sia Jee Heng <jeeheng.sia@starfivetech.com>,
 Igor Mammedov <imammedo@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-riscv@nongnu.org,
 qemu-arm@nongnu.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>,
 Zhao Liu <zhao1.liu@intel.com>
References: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

+Igor

On 20/2/24 10:24, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> Hi list,
> 
> This's our proposal for supporting (SMP) cache topology in -smp as
> the following example:
> 
> -smp 32,sockets=2,dies=2,modules=2,cores=2,threads=2,maxcpus=32,\
>       l1d-cache=core,l1i-cache=core,l2-cache=core,l3-cache=die
> 
> With the new cache topology options ("l1d-cache", "l1i-cache",
> "l2-cache" and "l3-cache"), we could adjust the cache topology via -smp.
> 
> This patch set is rebased on our i386 module series:
> https://lore.kernel.org/qemu-devel/20240131101350.109512-1-zhao1.liu@linux.intel.com/
> 
> Since the ARM [1] and RISC-V [2] folks have similar needs for the cache
> topology, I also cc'd the ARM and RISC-V folks and lists.
> 
> 
> Welcome your feedback!
> 
> 
> Introduction
> ============
> 
> Background
> ----------
> 
> Intel client platforms (ADL/RPL/MTL) and E core server platforms (SRF)
> share the L2 cache domain among multiple E cores (in the same module).
> 
> Thus we need a way to adjust the cache topology so that users could
> create the cache topology for Guest that is nearly identical to Host.
> 
> This is necessary in cases where there are bound vCPUs, especially
> considering that Guest scheduling often takes into account the cache
> topology as well (e.g. Linux cluster aware scheduling, i.e. L2 cache
> scheduling).
> 
> Previously, we introduced a x86 specific option to adjust the cache
> topology:
> 
> -cpu x-l2-cache-topo=[core|module] [3]
> 
> However, considering the needs of other arches, we re-implemented the
> generic cache topology (aslo in response to Michael's [4] and Daniel's
> comment [5]) in this series.
> 
> 
> Cache Topology Representation
> -----------------------------
> 
> We consider to define the cache topology based on CPU topology level for
> two reasons:
> 
> 1. In practice, a cache will always be bound to the CPU container -
>     "CPU container" indicates to a set of CPUs that refer to a certain
>     level of CPU topology - where the cache is either private in that
>     CPU container or shared among multiple containers.
> 
> 2. The x86's cache-related CPUIDs encode cache topology based on APIC
>     ID's CPU topology layout. And the ACPI PPTT table that ARM/RISCV
>     relies on also requires CPU containers (CPU topology) to help
>     indicate the private shared hierarchy of the cache.
> 
> Therefore, for SMP systems, it is natural to use the CPU topology
> hierarchy directly in QEMU to define the cache topology.
> 
> And currently, separated L1 cache (L1 data cache and L1 instruction
> cache) with unified higher-level caches (e.g., unified L2 and L3
> caches), is the most common cache architectures.
> 
> Thus, we define the topology for L1 D-cache, L1 I-cache, L2 cache and L3
> cache in MachineState as the basic cache topology support:
> 
> typedef struct CacheTopology {
>      CPUTopoLevel l1d;
>      CPUTopoLevel l1i;
>      CPUTopoLevel l2;
>      CPUTopoLevel l3;
> } CacheTopology;
> 
> Machines may also only support a subset of the cache topology
> to be configured in -smp by setting the SMP property of MachineClass:
> 
> typedef struct {
>      ...
>      bool l1_separated_cache_supported;
>      bool l2_unified_cache_supported;
>      bool l3_unified_cache_supported;
> } SMPCompatProps;
> 
> 
> Cache Topology Configuration in -smp
> ------------------------------------
> 
> Further, we add new parameters to -smp:
> * l1d-cache=level
> * l1i-cache=level
> * l2-cache=level
> * l3-cache=level
> 
> These cache topology parameters accept the strings of CPU topology
> levels (such as "drawer", "book", "socket", "die", "cluster", "module",
> "core" or "thread"). Exactly which topology level strings could be
> accepted as the parameter depends on the machine's support for the
> corresponding CPU topology level.
> 
> Unsupported cache topology parameters will be omitted, and
> correspondingly, the target CPU's cache topology will use the its
> default cache topology setting.
> 
> In this series, we add the cache topology support in -smp for x86 PC
> machine.
> 
> The following example defines a 3-level cache topology hierarchy (L1
> D-cache per core, L1 I-cache per core, L2 cache per core and L3 cache per
> die) for PC machine.
> 
> -smp 32,sockets=2,dies=2,modules=2,cores=2,threads=2,maxcpus=32,\
>       l1d-cache=core,l1i-cache=core,l2-cache=core,l3-cache=die
> 
> 
> Reference
> ---------
> 
> [1]: [ARM] Jonathan's proposal to adjust cache topology:
>       https://lore.kernel.org/qemu-devel/20230808115713.2613-2-Jonathan.Cameron@huawei.com/
> [2]: [RISC-V] Discussion between JeeHeng and Jonathan about cache
>       topology:
>       https://lore.kernel.org/qemu-devel/20240131155336.000068d1@Huawei.com/
> [3]: Previous x86 specific cache topology option:
>       https://lore.kernel.org/qemu-devel/20230914072159.1177582-22-zhao1.liu@linux.intel.com/
> [4]: Michael's comment about generic cache topology support:
>       https://lore.kernel.org/qemu-devel/20231003085516-mutt-send-email-mst@kernel.org/
> [5]: Daniel's question about how x86 support L2 cache domain (cluster)
>       configuration:
>       https://lore.kernel.org/qemu-devel/ZcUG0Uc8KylEQhUW@redhat.com/
> 
> Thanks and Best Regards,
> Zhao
> 
> ---
> Zhao Liu (8):
>    hw/core: Rename CpuTopology to CPUTopology
>    hw/core: Move CPU topology enumeration into arch-agnostic file
>    hw/core: Define cache topology for machine
>    hw/core: Add cache topology options in -smp
>    i386/cpu: Support thread and module level cache topology
>    i386/cpu: Update cache topology with machine's configuration
>    i386/pc: Support cache topology in -smp for PC machine
>    qemu-options: Add the cache topology description of -smp
> 
>   MAINTAINERS                     |   2 +
>   hw/core/cpu-topology.c          |  56 ++++++++++++++
>   hw/core/machine-smp.c           | 128 ++++++++++++++++++++++++++++++++
>   hw/core/machine.c               |   9 +++
>   hw/core/meson.build             |   1 +
>   hw/i386/pc.c                    |   3 +
>   hw/s390x/cpu-topology.c         |   6 +-
>   include/hw/boards.h             |  33 +++++++-
>   include/hw/core/cpu-topology.h  |  40 ++++++++++
>   include/hw/i386/topology.h      |  18 +----
>   include/hw/s390x/cpu-topology.h |   6 +-
>   qapi/machine.json               |  14 +++-
>   qemu-options.hx                 |  54 ++++++++++++--
>   system/vl.c                     |  15 ++++
>   target/i386/cpu.c               |  55 ++++++++++----
>   target/i386/cpu.h               |   2 +-
>   tests/unit/meson.build          |   3 +-
>   tests/unit/test-smp-parse.c     |  14 ++--
>   18 files changed, 399 insertions(+), 60 deletions(-)
>   create mode 100644 hw/core/cpu-topology.c
>   create mode 100644 include/hw/core/cpu-topology.h
> 


