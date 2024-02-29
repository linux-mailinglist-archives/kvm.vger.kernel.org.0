Return-Path: <kvm+bounces-10432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE75B86C19A
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 08:06:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC3F71C20E04
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0898446AC;
	Thu, 29 Feb 2024 07:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Eu6WbuO8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9757A42A9F
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 07:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709190364; cv=none; b=Fzkmj8ygtKjAx9t8DXyi7C/lwYhSRnpo1WCAaHkr8FXTCwTeasNZs868xRbWashc7xXMgF75d+0YYOnfKv+8Y9Py+HqvDPWUDC8+j9X4ICahGv7h1gR+uY1ZtcbdKamuVRbCpZWbtG7mLhP/gGmMIcibiO19XAUy7IqODYAIJCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709190364; c=relaxed/simple;
	bh=i9uq6y/awOo4nqggMPn0JAiBk7ClRoK07Pbq42o5yNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b0Uau0A4Qw+b+s/1qiX5w18osSptoFsn1yyTwGx5sQ2tJTxEKqu7k5k4jshrltbcm1tKUmwmGQVURnaTlb46d/9Yr02PKues0SicXMcU+BAexuU17w07Pb/WYv3riw5QuK7q+UkGE0K/a+PXHlBpdRDsRzVL1txCRLgoNCRQdCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Eu6WbuO8; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709190362; x=1740726362;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=i9uq6y/awOo4nqggMPn0JAiBk7ClRoK07Pbq42o5yNE=;
  b=Eu6WbuO8mEFpa9Z8JLJXFtQUz104Wy9G7lkV1lKjj6XGuZasnz7gceXx
   R1qPFxvc1LsQ24sLi4EEDA+yTCv+RVPUOEtvlE2xC8WgxuwHPVXHJKEfY
   m88BTjEaB6sjgZF+OAWjZcpeXC54WkzA1v1hHN/QD+AEXjh49al9XkHrF
   oDOiBRvNgCOsnpE9W/5k6bJ4nM2VfJ2JH6wEAlWeIhZzao29E01LehDZm
   HU6UAFVnEc6juzoGTQwt2WnOJ+9JrqWVim0BIr5T8K7r8w4pezLqjgj7A
   UGVzsM19THF5+LB/nthUIIs2A8T85vJKngsVxRaQ7PraFc/HfUk5UdU+J
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3764827"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3764827"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 23:06:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8082618"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 23:05:56 -0800
Date: Thu, 29 Feb 2024 15:19:40 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: JeeHeng Sia <jeeheng.sia@starfivetech.com>
Cc: Daniel P =?utf-8?B?LiBCZXJyYW5n77+9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?utf-8?B?TWF0aGlldS1EYXVk77+9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?utf-8?B?QmVubu+/vWU=?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"qemu-riscv@nongnu.org" <qemu-riscv@nongnu.org>,
	"qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [RFC 6/8] i386/cpu: Update cache topology with machine's
 configuration
Message-ID: <ZeAwDIDdJff6SiiB@intel.com>
References: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
 <20240220092504.726064-7-zhao1.liu@linux.intel.com>
 <BJSPR01MB0561F3D87C67D4BCCA9E9C8D9C58A@BJSPR01MB0561.CHNPR01.prod.partner.outlook.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BJSPR01MB0561F3D87C67D4BCCA9E9C8D9C58A@BJSPR01MB0561.CHNPR01.prod.partner.outlook.cn>

Hi JeeHeng,

> > diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> > index d7cb0f1e49b4..4b5c551fe7f0 100644
> > --- a/target/i386/cpu.c
> > +++ b/target/i386/cpu.c
> > @@ -7582,6 +7582,27 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
> > 
> >  #ifndef CONFIG_USER_ONLY
> >      MachineState *ms = MACHINE(qdev_get_machine());
> > +
> > +    if (ms->smp_cache.l1d != CPU_TOPO_LEVEL_INVALID) {
> > +        env->cache_info_cpuid4.l1d_cache->share_level = ms->smp_cache.l1d;
> > +        env->cache_info_amd.l1d_cache->share_level = ms->smp_cache.l1d;
> > +    }
> > +
> > +    if (ms->smp_cache.l1i != CPU_TOPO_LEVEL_INVALID) {
> > +        env->cache_info_cpuid4.l1i_cache->share_level = ms->smp_cache.l1i;
> > +        env->cache_info_amd.l1i_cache->share_level = ms->smp_cache.l1i;
> > +    }
> > +
> > +    if (ms->smp_cache.l2 != CPU_TOPO_LEVEL_INVALID) {
> > +        env->cache_info_cpuid4.l2_cache->share_level = ms->smp_cache.l2;
> > +        env->cache_info_amd.l2_cache->share_level = ms->smp_cache.l2;
> > +    }
> > +
> > +    if (ms->smp_cache.l3 != CPU_TOPO_LEVEL_INVALID) {
> > +        env->cache_info_cpuid4.l3_cache->share_level = ms->smp_cache.l3;
> > +        env->cache_info_amd.l3_cache->share_level = ms->smp_cache.l3;
> > +    }
> > +
>
> I think this block of code can be further optimized. Maybe we can create
> a function called updateCacheShareLevel() that takes a cache pointer and
> a share level as arguments. This function encapsulates the common
> pattern of updating cache share levels for different caches. You can define
> it like this:
> void updateCacheShareLevel(XxxCacheInfo *cache, int shareLevel) {
>     if (shareLevel != CPU_TOPO_LEVEL_INVALID) {
>         cache->share_level = shareLevel;
>     }
> }
>

Good idea! Will try this way.

Thanks,
Zhao


