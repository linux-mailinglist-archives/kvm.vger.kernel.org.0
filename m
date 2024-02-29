Return-Path: <kvm+bounces-10422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE89D86C153
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:51:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF35A1C21345
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:51:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 202223DB86;
	Thu, 29 Feb 2024 06:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fd/8RqVQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE50C2E415
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709189466; cv=none; b=HEdhl5Vy0T68shLHFeusacl4NWp52+HE2gsWFPoWAWYgENDuA7G0boum308KZeH+zRZpoIqNIGgEY8TLVpaEx/aLGdsM2oZhNV6TVLGpCk2M3Yv3UvSfTyJ35DP/o8shwiKriUXFRRh9CHzkx26dvFjYd0tnGCvMaG+FIBBLtS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709189466; c=relaxed/simple;
	bh=GS2K/1elXcA90zDdKMXQSx9HqJcMQIF3eoynkMWLosE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bzuS3O+QASuUg3L9/7M8P6buVwufvFnBgZ7Y9JbH7eUDWyWR6IU2OOULbs8R9/byPG5aH2DAwbcG5Ziw3J7mUs6I3o0IcUzN1XmxUb5GByBmtx1nDpqnUx3aCKCxdlWsAlP2BbjtbNrIWT90/h3rtJNPyy0yRCGgKGNLfbgVySU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fd/8RqVQ; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709189464; x=1740725464;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GS2K/1elXcA90zDdKMXQSx9HqJcMQIF3eoynkMWLosE=;
  b=fd/8RqVQDvh68oHMsqZGbaQsF2GmMKelEIIT+1WAKNqDCqvyhWW0IxE0
   PNy9uMPAJhW0Sn5JYM3X0IzC/AjJ6Ew7deb9VFwH88QkVI/+Ou8N3E81M
   0cmtdGs7ZLDK3nObkD7dcLrxeuujZmwA+BDxLatneTaO/3pkJ9RTAL3cb
   XfMuPHd/ms++8gv6vKHAUqPqJMbCeGucSHIgbt6nP/CDXmwiLrht3Kmx4
   630CfDSgkoaarW4z4hw8xmF4UNFbKCPIySwAVxJKNsEnQPLdWh1pX40tX
   9arcyySVfZR7krdDKSYyyESAtFTcwqyOlNrWMKbTdW7IU353npBE8R2P/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3755282"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3755282"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:51:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="7638819"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 28 Feb 2024 22:50:58 -0800
Date: Thu, 29 Feb 2024 15:04:42 +0800
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
Subject: Re: [RFC 4/8] hw/core: Add cache topology options in -smp
Message-ID: <ZeAsijVdx6DO+1pP@intel.com>
References: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
 <20240220092504.726064-5-zhao1.liu@linux.intel.com>
 <BJSPR01MB05618A7D409C2DE3E408345C9C58A@BJSPR01MB0561.CHNPR01.prod.partner.outlook.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BJSPR01MB05618A7D409C2DE3E408345C9C58A@BJSPR01MB0561.CHNPR01.prod.partner.outlook.cn>

Hi JeeHeng,

> > diff --git a/hw/core/machine.c b/hw/core/machine.c
> > index 426f71770a84..cb5173927b0d 100644
> > --- a/hw/core/machine.c
> > +++ b/hw/core/machine.c
> > @@ -886,6 +886,10 @@ static void machine_get_smp(Object *obj, Visitor *v, const char *name,
> >          .has_cores = true, .cores = ms->smp.cores,
> >          .has_threads = true, .threads = ms->smp.threads,
> >          .has_maxcpus = true, .maxcpus = ms->smp.max_cpus,
> > +        .l1d_cache = g_strdup(cpu_topo_to_string(ms->smp_cache.l1d)),
> > +        .l1i_cache = g_strdup(cpu_topo_to_string(ms->smp_cache.l1i)),
> > +        .l2_cache = g_strdup(cpu_topo_to_string(ms->smp_cache.l2)),
> > +        .l3_cache = g_strdup(cpu_topo_to_string(ms->smp_cache.l3)),
>
> Let's standardize the code by adding the 'has_' prefix.

SMPConfiguration is automatically generated in the compilation, and its
prototype is defined in qapi/machine.json like the following code:


> > diff --git a/qapi/machine.json b/qapi/machine.json
> > index d0e7f1f615f3..0a923ac38803 100644
> > --- a/qapi/machine.json
> > +++ b/qapi/machine.json
> > @@ -1650,6 +1650,14 @@
> >  #
> >  # @threads: number of threads per core
> >  #
> > +# @l1d-cache: topology hierarchy of L1 data cache (since 9.0)
> > +#
> > +# @l1i-cache: topology hierarchy of L1 instruction cache (since 9.0)
> > +#
> > +# @l2-cache: topology hierarchy of L2 unified cache (since 9.0)
> > +#
> > +# @l3-cache: topology hierarchy of L3 unified cache (since 9.0)
> > +#
> >  # Since: 6.1
> >  ##
> >  { 'struct': 'SMPConfiguration', 'data': {
> > @@ -1662,7 +1670,11 @@
> >       '*modules': 'int',
> >       '*cores': 'int',
> >       '*threads': 'int',
> > -     '*maxcpus': 'int' } }
> > +     '*maxcpus': 'int',
> > +     '*l1d-cache': 'str',
> > +     '*l1i-cache': 'str',
> > +     '*l2-cache': 'str',
> > +     '*l3-cache': 'str' } }
> >

The gnerated complete structure is (will in build/qapi/qapi-types-machine.h):

struct SMPConfiguration {
    bool has_cpus;
    int64_t cpus;
    bool has_drawers;
    int64_t drawers;
    bool has_books;
    int64_t books;
    bool has_sockets;
    int64_t sockets;
    bool has_dies;
    int64_t dies;
    bool has_clusters;
    int64_t clusters;
    bool has_modules;
    int64_t modules;
    bool has_cores;
    int64_t cores;
    bool has_threads;
    int64_t threads;
    bool has_maxcpus;
    int64_t maxcpus;
    char *l1d_cache;
    char *l1i_cache;
    char *l2_cache;
    char *l3_cache;
};

The int member defined in qapi/machine.json will get their corresponding
status fields as has_* to indicate if user sets those int fields.

For str type, the status field is not needed since NULL is enough to
indicate no user sets that.

Thanks,
Zhao


