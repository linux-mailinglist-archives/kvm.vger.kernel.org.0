Return-Path: <kvm+bounces-18736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F096D8FAD7E
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 10:24:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FE2C1C22D47
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 08:24:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF888142652;
	Tue,  4 Jun 2024 08:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XceCHVZN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E0413C672
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 08:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717489467; cv=none; b=XY6wtEDPYh3tTJR78R86l79eLL6thL8yvj4xsbbDNjn/N2YQtnfjuMrW3oD7A1NuHJsuqzjXNFB3CEyz+z75/NFb56zwPZBq6XXRJa8BEOaPGvYnGiI9N4+5htTQrIEmU7QQkpWhnZhfcNiKZ2SdokQMNOUEEEk0WJydJNKpO9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717489467; c=relaxed/simple;
	bh=atOfj9kWdFuVI1HtcdHLArsthwrM8mfXmtw15855REQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HWGXd9sjTn6Qhbc11TFo7FJ79gI6TwpYIPAS5ZRwmR4FqYQbNQfAT9B5UJQ9AaDK/bEL2qO0MwNAQWH2D/P70pBDmAkUBn4NKPN8lGdBLPEaB+1I6kQr3MrBK/b9ZEwiEsr4s8ZsoF65t2L0RP+4YGEAIVaFNrk3cElOAPIal1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XceCHVZN; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717489466; x=1749025466;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=atOfj9kWdFuVI1HtcdHLArsthwrM8mfXmtw15855REQ=;
  b=XceCHVZNpIUmWHijqoi5/HuJ4VuBvsZ8cmMUEBd9YGD5X/ZMtkVIYjXm
   CSyQ37rEa/rfYPifLb7ZIFxkbQZ27C6PciUD0OHuus1mPvEGnGKPFv7bc
   3lNMb9mOh6OOnxBsCM5cr3kYkeOSNoU+tlRjPZhWcZCIy0/U90hxnvQis
   h3tVxZAcMp7IhWswnxF88s8VBg1ZWzdlphWy+3HWUxLMG1AhFjQim360Z
   WRTdCxc7Bal1oHSvOmKv5x5yQ7iHASqpa6ZeHOzTP5VsQTYEgU6sqY4uR
   9ZND3KUaUZK8bNu/+pQ1NcgTlKo7j3qduLldPbdAKoTN1kwO9gP2D7p7C
   A==;
X-CSE-ConnectionGUID: uHmM5tIAS6+Q+cVX0Hsx9A==
X-CSE-MsgGUID: KO7Xx3BLQKadd1NQVBUwAg==
X-IronPort-AV: E=McAfee;i="6600,9927,11092"; a="24644302"
X-IronPort-AV: E=Sophos;i="6.08,213,1712646000"; 
   d="scan'208";a="24644302"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2024 01:24:24 -0700
X-CSE-ConnectionGUID: zjJrKqpcS86f3Y2Vz9QwYA==
X-CSE-MsgGUID: jwlQwP8FTJCMn3VANeHNmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,213,1712646000"; 
   d="scan'208";a="37152758"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa008.fm.intel.com with ESMTP; 04 Jun 2024 01:24:19 -0700
Date: Tue, 4 Jun 2024 16:39:44 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [RFC v2 1/7] hw/core: Make CPU topology enumeration arch-agnostic
Message-ID: <Zl7S0IOlLvnua319@intel.com>
References: <20240530101539.768484-1-zhao1.liu@intel.com>
 <20240530101539.768484-2-zhao1.liu@intel.com>
 <87y17mfccp.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y17mfccp.fsf@pond.sub.org>

[snip]

> > +CPUTopoInfo cpu_topo_descriptors[] = {
> > +    [CPU_TOPO_LEVEL_INVALID] = { .name = "invalid", },
> > +    [CPU_TOPO_LEVEL_THREAD]  = { .name = "thread",  },
> > +    [CPU_TOPO_LEVEL_CORE]    = { .name = "core",    },
> > +    [CPU_TOPO_LEVEL_MODULE]  = { .name = "module",  },
> > +    [CPU_TOPO_LEVEL_CLUSTER] = { .name = "cluster", },
> > +    [CPU_TOPO_LEVEL_DIE]     = { .name = "die",     },
> > +    [CPU_TOPO_LEVEL_SOCKET]  = { .name = "socket",  },
> > +    [CPU_TOPO_LEVEL_BOOK]    = { .name = "book",    },
> > +    [CPU_TOPO_LEVEL_DRAWER]  = { .name = "drawer",  },
> > +    [CPU_TOPO_LEVEL__MAX]    = { .name = NULL,      },
> > +};
> 
> This looks redundant with generated
> 
>     const QEnumLookup CPUTopoLevel_lookup = {
>         .array = (const char *const[]) {
>             [CPU_TOPO_LEVEL_INVALID] = "invalid",
>             [CPU_TOPO_LEVEL_THREAD] = "thread",
>             [CPU_TOPO_LEVEL_CORE] = "core",
>             [CPU_TOPO_LEVEL_MODULE] = "module",
>             [CPU_TOPO_LEVEL_CLUSTER] = "cluster",
>             [CPU_TOPO_LEVEL_DIE] = "die",
>             [CPU_TOPO_LEVEL_SOCKET] = "socket",
>             [CPU_TOPO_LEVEL_BOOK] = "book",
>             [CPU_TOPO_LEVEL_DRAWER] = "drawer",
>         },
>         .size = CPU_TOPO_LEVEL__MAX
>     };
> 
> > +
> > +const char *cpu_topo_to_string(CPUTopoLevel topo)
> > +{
> > +    return cpu_topo_descriptors[topo].name;
> > +}
> 
> And this with generated CPUTopoLevel_str().

Thanks! I missed these generated helpers.

[snip]

> > +##
> > +# @CPUTopoLevel:
> > +#
> > +# An enumeration of CPU topology levels.
> > +#
> > +# @invalid: Invalid topology level, used as a placeholder.
> 
> Placeholder for what?

I was trying to express that when no specific topology level is
specified, it will be initialized to this value by default.

Or what about just deleting this placeholder related words and just
saying it's "Invalid topology level"?

> > +#
> > +# @thread: thread level, which would also be called SMT level or logical
> > +#     processor level. The @threads option in -smp is used to configure
> > +#     the topology of this level.
> > +#
> > +# @core: core level. The @cores option in -smp is used to configure the
> > +#     topology of this level.
> > +#
> > +# @module: module level. The @modules option in -smp is used to
> > +#     configure the topology of this level.
> > +#
> > +# @cluster: cluster level. The @clusters option in -smp is used to
> > +#     configure the topology of this level.
> > +#
> > +# @die: die level. The @dies option in -smp is used to configure the
> > +#     topology of this level.
> > +#
> > +# @socket: socket level, which would also be called package level. The
> > +#     @sockets option in -smp is used to configure the topology of this
> > +#     level.
> > +#
> > +# @book: book level. The @books option in -smp is used to configure the
> > +#     topology of this level.
> > +#
> > +# @drawer: drawer level. The @drawers option in -smp is used to
> > +#     configure the topology of this level.
> 
> As far as I can tell, -smp is sugar for machine property "smp" of QAPI
> type SMPConfiguration.  Should we refer to SMPConfiguration instead of
> -smp?

Yes, SMPConfiguration is better.

Thanks,
Zhao


