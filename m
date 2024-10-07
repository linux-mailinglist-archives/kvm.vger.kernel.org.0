Return-Path: <kvm+bounces-28057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 943EB99298E
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 12:56:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51E452840F8
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 10:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAA8D1D14EC;
	Mon,  7 Oct 2024 10:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BTOsG6BT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E22515D5C1
	for <kvm@vger.kernel.org>; Mon,  7 Oct 2024 10:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728298585; cv=none; b=U5NgyDhITU9b8MG2tC3TW81C/CXqVTxWlI1H9KmJU+E4lL6NcAwaG5atxOQa7P91yE8/s7ie3Zg/sUWo/2JvUvNuNdNu+zm8/YGm7kCI0Y/Qx8d6DiGpysZuGZFe+bWlQzG1BBwuIBm4HIbMvGpy/pZLmz97uQUA3EKuiFvzAH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728298585; c=relaxed/simple;
	bh=T1pqoP48M8l988CxvjsXIyPgrv7G7BxcyDze1mpyE/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JdekJno/7STg6c/To3T4U4pnlDTG5qTHZsIMNknFyC1JCipBZVKZTS7W2Q/1VCczWeSpHgZRreJh2Fst/8CZ61f269h1sib2wJd7uW8vosZljvgJt3SWXc5c8ll0FXh/Rvz7doBQgIULqtbBvE2OQaB9fLY6aiSn46Nr2SBl/oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BTOsG6BT; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728298583; x=1759834583;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=T1pqoP48M8l988CxvjsXIyPgrv7G7BxcyDze1mpyE/g=;
  b=BTOsG6BT5xYfq69u84CTXCdzvrd6AqTNg2vy3RzAHEM6dwV4W4DfTulg
   DXiBDtL38mTRBgQhViuzzGPBOd8NEd924fQj2hVB3idwxO05M54UaGtqf
   dFgqq/Ye+SHXFbYkVjaKFwOrzrJbEQkN8wyuDSCxDW7xN6APGk22XBDdG
   Du/K1G/HG45xVQjQ3msMviAIJ038I+HqW3Z2obsLa5U3e+CWYIkrXPm4j
   95cBYZXnxvKhN1pHV2EpHWIykjcyxFLgJeCWaJ/E5fqSIy1+fUVEHMLOY
   2xpH09CQj2rvK2s+Guwei+PVEDyMbKudXS4jiwHEUPvsthYEUK4K6S9LF
   Q==;
X-CSE-ConnectionGUID: AYw/q8NiRReaEpb/Yuj17A==
X-CSE-MsgGUID: rqVFngxQSqyvhAK7HtuGzA==
X-IronPort-AV: E=McAfee;i="6700,10204,11217"; a="27326407"
X-IronPort-AV: E=Sophos;i="6.11,184,1725346800"; 
   d="scan'208";a="27326407"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 03:56:23 -0700
X-CSE-ConnectionGUID: 2Af7pHfOTv2AjgyS9bkogA==
X-CSE-MsgGUID: g1Mh539KQ7ijgVOrKBrE7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,184,1725346800"; 
   d="scan'208";a="75109678"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa007.fm.intel.com with ESMTP; 07 Oct 2024 03:56:19 -0700
Date: Mon, 7 Oct 2024 19:12:29 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S.Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v2 4/7] hw/core: Check smp cache topology support for
 machine
Message-ID: <ZwPCHRRdYD6/S7GN@intel.com>
References: <20240908125920.1160236-1-zhao1.liu@intel.com>
 <20240908125920.1160236-5-zhao1.liu@intel.com>
 <20240917095612.00007b5a@Huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240917095612.00007b5a@Huawei.com>

On Tue, Sep 17, 2024 at 09:56:12AM +0100, Jonathan Cameron wrote:
> Date: Tue, 17 Sep 2024 09:56:12 +0100
> From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
> Subject: Re: [PATCH v2 4/7] hw/core: Check smp cache topology support for
>  machine
> X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
> 
> On Sun,  8 Sep 2024 20:59:17 +0800
> Zhao Liu <zhao1.liu@intel.com> wrote:
> 
> > Add cache_supported flags in SMPCompatProps to allow machines to
> > configure various caches support.
> > 
> > And check the compatibility of the cache properties with the
> > machine support in machine_parse_smp_cache().
> > 
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> 
> Just a few trivial comments inline.
> 
> FWIW with or without those changes.
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Thanks!

[snip]

> > +        /*
> > +         * Allow setting "default" topology level even though the cache
> > +         * isn't supported by machine.
> I'd flip the comment as the condition is doing the opposite.

OK, it's more intuitive.

>             * Reject non "default" topology level if the cache isn't
>             * supported by the machine.
> > +         */
> > +        if (props->topology != CPU_TOPOLOGY_LEVEL_DEFAULT &&
> > +            !mc->smp_props.cache_supported[props->cache]) {
> > +            error_setg(errp,
> > +                       "%s cache topology not supported by this machine",
> > +                       CacheLevelAndType_str(node->value->cache));
> > +            return false;
> > +        }
> > +
> > +        if (!machine_check_topo_support(ms, props->topology, errp)) {
> > +            return false;
> > +        }
> > +    }
> > +
> > +    if (smp_cache_topo_cmp(&ms->smp_cache,
> > +                           CACHE_LEVEL_AND_TYPE_L1D,
> 
> Short line wrap.  Maybe combine the two lines above and similar
> cases.

Like this?

smp_cache_topo_cmp(&ms->smp_cache, CACHE_LEVEL_AND_TYPE_L1D,
                   CACHE_LEVEL_AND_TYPE_L2)

> Up to you though, I don't feel that strongly.
> 
> > +                           CACHE_LEVEL_AND_TYPE_L2) ||
> > +        smp_cache_topo_cmp(&ms->smp_cache,
> > +                           CACHE_LEVEL_AND_TYPE_L1I,
> > +                           CACHE_LEVEL_AND_TYPE_L2)) {
> > +        error_setg(errp,
> > +                   "Invalid smp cache topology. "
> > +                   "L2 cache topology level shouldn't be lower than L1 cache");
> > +        return false;
> > +    }
> > +

Regards,
Zhao


