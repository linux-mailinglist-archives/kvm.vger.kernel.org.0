Return-Path: <kvm+bounces-28168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FEEB995FCC
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 08:30:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE1252857EB
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 06:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F9F342070;
	Wed,  9 Oct 2024 06:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h8oanFgb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C157D1DA5F
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 06:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728455425; cv=none; b=TEfvpKKMTlD/xmjp/LReuDiDQfSq9qBAMXUck8+ejjY+a8LaXKuKjrUmGUhYZDdkiQmAvkOe3TzzNmeaxOeSCmkRi9i7vQo+jj0MEF4Fv5sVdgA5LuNs2UNnmSZ5N9/Uup8aD7YmGlaWa21H+MR+XQpMak6gWolDRpjmquzAXbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728455425; c=relaxed/simple;
	bh=8Oj98Uxc6eq05Llc2jkbHDeCDUw7ET0i2OlqlNyHDGM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SpjhEq64gPTRkhBTm9u024/G2inEbXppHoWTqBkF5H4kVmg/LLGWh+pS/JdUd+uJ5UpkrftdkCtmwYrFz5sm3vRdQx9z6wouO8PNCxOk3Oa9pG1fWFkHA4SuW85Z89Vl2noVc6FIh9/QW1RPJLCXNenMYY/g3lYI7PqSkoHlshk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h8oanFgb; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728455424; x=1759991424;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8Oj98Uxc6eq05Llc2jkbHDeCDUw7ET0i2OlqlNyHDGM=;
  b=h8oanFgbpsanb2eWZ54nmBB4ZtJVj+AfBRuVzf1jThqK9+1POf1vseZh
   Rt0ou00u8r546oFfDPqk/W3383sATgMB1k+CSNHsXl7prOFvnKzmkCb0a
   2mN5vVgrcM6GzfSxZPVye6FxF+CKVxL1Xq8DfO45+lTNSTgm9oXEFN2UE
   6I5ZVAddjlI12jGsjQcqMl4mKja95PqxABcT9SoNvWSoOnBMEVPAkYz5x
   5cPQufqSMp/GA2LfNH4M9/VTClaKVeQ6X2uGcn/D8M55e1XGrnJ7SOrKl
   LfMQNR7ahGa0ZsOgbUJtr+LFi0ZiZvU4ZNrhrHBI9b97Q2Wb8tPaq5ykv
   w==;
X-CSE-ConnectionGUID: VRmirRHgT2O99xLS3Ap6/g==
X-CSE-MsgGUID: 2+cqcIRXSayqEmG5vKPNsA==
X-IronPort-AV: E=McAfee;i="6700,10204,11219"; a="27820289"
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="27820289"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 23:30:23 -0700
X-CSE-ConnectionGUID: 7AY6nrLnSbiismYVr75Unw==
X-CSE-MsgGUID: WKYSmQ/hQLO3QpcWbNAMlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="80127512"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa003.fm.intel.com with ESMTP; 08 Oct 2024 23:30:16 -0700
Date: Wed, 9 Oct 2024 14:46:28 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Daniel P =?utf-8?B?LiBCZXJyYW5n77+9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?utf-8?B?TWF0aGlldS1EYXVk77+9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Sergio Lopez <slp@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
	"Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Alex =?utf-8?B?QmVubu+/vWU=?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
	""@web.codeaurora.org
Subject: Re: [RFC v2 05/12] hw/core/machine: Introduce custom CPU topology
 with max limitations
Message-ID: <ZwYmxH8sl5v8ZpNZ@intel.com>
References: <20240919061128.769139-1-zhao1.liu@intel.com>
 <20240919061128.769139-6-zhao1.liu@intel.com>
 <20241008111651.000025ab@Huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241008111651.000025ab@Huawei.com>

> A few code style comments inline.
> 
> J
> > diff --git a/hw/cpu/cpu-slot.c b/hw/cpu/cpu-slot.c
> > index 1cc3b32ed675..2d16a2729501 100644
> > --- a/hw/cpu/cpu-slot.c
> > +++ b/hw/cpu/cpu-slot.c
> 
> > +
> > +bool machine_parse_custom_topo_config(MachineState *ms,
> > +                                      const SMPConfiguration *config,
> > +                                      Error **errp)
> > +{
> > +    MachineClass *mc = MACHINE_GET_CLASS(ms);
> > +    CPUSlot *slot = ms->topo;
> > +    bool is_valid;
> > +    int maxcpus;
> > +
> > +    if (!slot) {
> > +        return true;
> > +    }
> > +
> > +    is_valid = config->has_maxsockets && config->maxsockets;
> > +    if (mc->smp_props.custom_topo_supported) {
> > +        slot->stat.entries[CPU_TOPOLOGY_LEVEL_SOCKET].max_limit =
> > +            is_valid ? config->maxsockets : ms->smp.sockets;
> > +    } else if (is_valid) {
> > +        error_setg(errp, "maxsockets > 0 not supported "
> > +                   "by this machine's CPU topology");
> > +        return false;
> > +    } else {
> > +        slot->stat.entries[CPU_TOPOLOGY_LEVEL_SOCKET].max_limit =
> > +            ms->smp.sockets;
> > +    }
> Having the error condition in the middle is rather confusing to
> read to my eyes. Playing with equivalents I wonder what works best..

Figuring out how to clearly express the logic here was indeed a bit of a
struggle for me at first. :-)

>     if (!is_valid) {
>         slot->stat.entries[CPU_TOPOLOGY_LEVEL_SOCKET].max_limit =
>             ms->smp.sockets;
>     } else if (mc->smp_props.custom_topo_supported) {
>         slot->stat.entries[CPU_TOPOLOGY_LEVEL_SOCKET].max_limit =
>             config->max_sockets;
>     } else {
>         error_setg...
>         return false;
>     }
> 
> or take the bad case out first.  Maybe this is a little obscure
> though (assuming I even got it right) as it relies on the fact
> that is_valid must be false for the legacy path.
> 
>     if (!mc->smp_props.custom_topo_supported && is_valid) {
>         error_setg();
>         return false;
>     }
> 
>     slot->stat.entries[CPU_TOPOLOGY_LEVEL_SOCKET].max_limit =
>           is_valid ? config->maxsockets : ms->smp.sockets;
> 
> Similar for other cases.

I prefer the first style, as it's more natural and clear enough!

Many thanks!

[snip]

> > +    maxcpus = 1;
> > +    /* Initizlize max_limit to 1, as members of CpuTopology. */
> > +    for (int i = 0; i < CPU_TOPOLOGY_LEVEL__MAX; i++) {
> > +        maxcpus *= slot->stat.entries[i].max_limit;
> > +    }
> > +
> > +    if (!config->has_maxcpus) {
> > +        ms->smp.max_cpus = maxcpus;
> Maybe early return here to get rid of need for the else?

Yes, it's better to reduce else.

> > +    } else {
> > +        if (maxcpus != ms->smp.max_cpus) {
> 
> Unless this is going to get more complex later,  else if probably appropriate here
> (if you don't drop the else above.


I can organize it like:

if (!config->has_maxcpus) {
    ...
    return true;
}

if (maxcpus != ms->smp.max_cpus) {
    error_steg...
    return false;
}

return true;

As you suggested to get rid of a "else". :)

> > +            error_setg(errp, "maxcpus (%d) should be equal to "
> > +                       "the product of the remaining max parameters (%d)",
> > +                       ms->smp.max_cpus, maxcpus);
> > +            return false;
> > +        }
> > +    }
> > +
> > +    return true;
> > +}

Regards,
Zhao




