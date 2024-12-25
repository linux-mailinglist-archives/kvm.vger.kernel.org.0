Return-Path: <kvm+bounces-34371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF4549FC363
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2024 03:46:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E7261884A52
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2024 02:45:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92915149E0E;
	Wed, 25 Dec 2024 02:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I7ApPXJe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CA6145A19
	for <kvm@vger.kernel.org>; Wed, 25 Dec 2024 02:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735094705; cv=none; b=W2a/qjXzU/Gqob/wuaKCGvJVkce3IzFEtXPVy3YYtYRpvJgzo6OBhTfOHlyBLk1hm2U0VALWxs4C8dRHyWbwisTgoYo/0AvmpVOSNbjz+BYT6sLxqj8Qm6SFyPkb7n+SEsL7e8AbLXkeAi3STpU8KHI5gtUD5msFYLfJOO64hck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735094705; c=relaxed/simple;
	bh=5g8PCM2Z3gR7kKn4nqZKcBYpI8Dq7vpqMSZn8azuTKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ahv6OXhxdxDSlzsik/aws9RZ9UIJQNNNj1ILfu0rRho/aR6Exet68caDEJsjRafwN4kFh+qzQBCWIyApEw+8vcUvW3WXmxmerwKMP7LrIShYmT5YqWjnWzdCliBj3chh/HglhdNbQFypMHQooj7JVaQE3O/UxEa4CB9FIOI9xZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I7ApPXJe; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735094703; x=1766630703;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=5g8PCM2Z3gR7kKn4nqZKcBYpI8Dq7vpqMSZn8azuTKk=;
  b=I7ApPXJenm4MDvRT5w0JSONfaazVJeSasa8JovytmYRRsGcCKoc8/RH4
   1csEkZPCJ/TjcdYy2PSP37yeW9D9yMD08qtdSewcU8wL2IPf+c1VGYIpL
   yBkocIi53cFGOTXO7FOjPoENIusaswpcZ0UStpdP16gn0e+C2blBal8PK
   UG1Jgx9SERK+0T1Hi5jlqVqKojuWm6Tykd/FpIKhTV2laKvvJSwWC7G+1
   JbYMSTFNv2jBRetfKAzZN9U6+Z7Typ4mFGBvbmbobkwL6ZzzDbYBb40lA
   CTG0yNuKwtZ05rxOUp1BuPd3eUpvr8G/SYxoXoftwpkzWI93shfV0Sjn7
   Q==;
X-CSE-ConnectionGUID: 2M7HbKFeSAeHRjVDsr1xrw==
X-CSE-MsgGUID: xcoQk+9KSbaIeYG0vrQ+RA==
X-IronPort-AV: E=McAfee;i="6700,10204,11296"; a="52958761"
X-IronPort-AV: E=Sophos;i="6.12,262,1728975600"; 
   d="scan'208";a="52958761"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2024 18:45:03 -0800
X-CSE-ConnectionGUID: KURgmDzqSqq9HQYiFviMKA==
X-CSE-MsgGUID: uJFQ+NROSbyRcG0TWq0/Ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="104700387"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 24 Dec 2024 18:45:00 -0800
Date: Wed, 25 Dec 2024 11:03:42 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v6 0/4] i386: Support SMP Cache Topology
Message-ID: <Z2t2DuMBYb2mioB0@intel.com>
References: <20241219083237.265419-1-zhao1.liu@intel.com>
 <44212226-3692-488b-8694-935bd5c3a333@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44212226-3692-488b-8694-935bd5c3a333@redhat.com>

> > About smp-cache
> > ===============
> > 
> > The API design has been discussed heavily in [3].
> > 
> > Now, smp-cache is implemented as a array integrated in -machine. Though
> > -machine currently can't support JSON format, this is the one of the
> > directions of future.
> > 
> > An example is as follows:
> > 
> > smp_cache=smp-cache.0.cache=l1i,smp-cache.0.topology=core,smp-cache.1.cache=l1d,smp-cache.1.topology=core,smp-cache.2.cache=l2,smp-cache.2.topology=module,smp-cache.3.cache=l3,smp-cache.3.topology=die
> > 
> > "cache" specifies the cache that the properties will be applied on. This
> > field is the combination of cache level and cache type. Now it supports
> > "l1d" (L1 data cache), "l1i" (L1 instruction cache), "l2" (L2 unified
> > cache) and "l3" (L3 unified cache).
> > 
> > "topology" field accepts CPU topology levels including "thread", "core",
> > "module", "cluster", "die", "socket", "book", "drawer" and a special
> > value "default".
> 
> Looks good; just one thing, does "thread" make sense?  I think that it's
> almost by definition that threads within a core share all caches, but maybe
> I'm missing some hardware configurations.

Hi Paolo, merry Christmas. Yes, AFAIK, there's no hardware has thread
level cache.

I considered the thread case is that it could be used for vCPU
scheduling optimization (although I haven't rigorously tested the actual
impact). Without CPU affinity, tasks in Linux are generally distributed
evenly across different cores (for example, vCPU0 on Core 0, vCPU1 on
Core 1). In this case, the thread-level cache settings are closer to the
actual situation, with vCPU0 occupying the L1/L2 of Host core0 and vCPU1
occupying the L1/L2 of Host core1.


  ©°©¤©¤©¤©´        ©°©¤©¤©¤©´
  vCPU0        vCPU1
  ©¦   ©¦        ©¦   ©¦
  ©¸©¤©¤©¤©¼        ©¸©¤©¤©¤©¼
 ©°©°©¤©¤©¤©´©°©¤©¤©¤©´©´ ©°©°©¤©¤©¤©´©°©¤©¤©¤©´©´
 ©¦©¦T0 ©¦©¦T1 ©¦©¦ ©¦©¦T2 ©¦©¦T3 ©¦©¦
 ©¦©¸©¤©¤©¤©¼©¸©¤©¤©¤©¼©¦ ©¦©¸©¤©¤©¤©¼©¸©¤©¤©¤©¼©¦
 ©¸©¤©¤©¤©¤C0©¤©¤©¤©¤©¼ ©¸©¤©¤©¤©¤C1©¤©¤©¤©¤©¼


The L2 cache topology affects performance, and cluster-aware scheduling
feature in the Linux kernel will try to schedule tasks on the same L2
cache. So, in cases like the figure above, setting the L2 cache to be
per thread should, in principle, be better.

Thanks,
Zhao


