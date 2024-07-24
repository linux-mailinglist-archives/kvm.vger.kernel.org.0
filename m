Return-Path: <kvm+bounces-22160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B51D593B1E6
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 15:47:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69E42282E12
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 13:47:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED868158DA0;
	Wed, 24 Jul 2024 13:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c3zPuBB0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C805D2D030
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 13:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721828845; cv=none; b=qa4tdFWezc/HfBqlT74XAQE+DDtAI9bdAVMG/fvW+zCYxuNr8FoJ7udNDVO466M00t14QSDmFGIZjrUlJ5ODx8+qI4Ptr/YfnK26mhmqBzm3DekecSTAEaG4H6BcAD5E1uqihKLl/NQiRpLBXF8UTbMBzadJxAGj7dg5lDZtpqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721828845; c=relaxed/simple;
	bh=sxKpAl9rrbQ4Xx0Hyr/S+ZMPf6W0x+OqB+PPtAp9ArA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jPmhatqnIm2qIuO3PC65gSMRms3epA93zIHUvkj7OlFf44AS7u445zxG30kB+Keb58rGYU6ZFN0eKnTga84kxQN3niwJZCY67FuqFqcwkgi3EB6W3HD8nXhdvWdnvUpJyL9DuDL9OTw4U1T8RjmyTj94qUab8OohsJNAEN+kP3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c3zPuBB0; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721828844; x=1753364844;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=sxKpAl9rrbQ4Xx0Hyr/S+ZMPf6W0x+OqB+PPtAp9ArA=;
  b=c3zPuBB0a6R5390roseF3mJj0820ZlabczOjtlF8p9LQpLQ5zeYUyXiK
   r0Df5mGeVHhLfCqZS70edH6AhKQiRTyLakG2xVJyPL3wMwMI5juYlpyk9
   qjNLUkSgQrZ2njAURcYjtseE0yWWrANPsLWr2f76JAgKj9Y/XyQ9tT3r1
   HQ41Ly8dwPfEXUHOJR5WdLgIVJz9mmUFm0PmN25HUmnI8daakZAzToxem
   fTwb9TOh6m6IE7EwxQiLQ1RrTLn2HeflBwU/OtHH6oPRiKGIi7Do1YD2U
   40NzFgJkgufwTcmfXVTDXvK9RMO8BIhVIlhuxa4oPV8DscgHCvPFLO2RJ
   A==;
X-CSE-ConnectionGUID: uBp7NMQST5e09rkzOo91vg==
X-CSE-MsgGUID: j/pGijKuR4KWiiwIQCvqAQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11143"; a="19635302"
X-IronPort-AV: E=Sophos;i="6.09,233,1716274800"; 
   d="scan'208";a="19635302"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2024 06:47:23 -0700
X-CSE-ConnectionGUID: KcuozMCYQ2qc1TLMylTygw==
X-CSE-MsgGUID: SiPTLhqxQVi/C+OLS4Jj6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,233,1716274800"; 
   d="scan'208";a="52816196"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa006.jf.intel.com with ESMTP; 24 Jul 2024 06:47:18 -0700
Date: Wed, 24 Jul 2024 22:03:02 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: Markus Armbruster <armbru@redhat.com>,
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
Subject: Re: [PATCH 2/8] qapi/qom: Introduce smp-cache object
Message-ID: <ZqEJlmR3U6g8zq0z@intel.com>
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
 <20240704031603.1744546-3-zhao1.liu@intel.com>
 <87wmld361y.fsf@pond.sub.org>
 <Zp5tBHBoeXZy44ys@intel.com>
 <87h6cfowei.fsf@pond.sub.org>
 <ZqD31Oj5P0uDMs-I@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZqD31Oj5P0uDMs-I@redhat.com>

On Wed, Jul 24, 2024 at 01:47:16PM +0100, Daniel P. Berrangé wrote:
> Date: Wed, 24 Jul 2024 13:47:16 +0100
> From: "Daniel P. Berrangé" <berrange@redhat.com>
> Subject: Re: [PATCH 2/8] qapi/qom: Introduce smp-cache object
> 
> On Wed, Jul 24, 2024 at 01:35:17PM +0200, Markus Armbruster wrote:
> > Zhao Liu <zhao1.liu@intel.com> writes:
> > 
> > > Hi Markus,
> > >> SmpCachesProperties and SmpCacheProperties would put the singular
> > >> vs. plural where it belongs.  Sounds a bit awkward to me, though.
> > >> Naming is hard.
> > >
> > > For SmpCachesProperties, it's easy to overlook the first "s".
> > >
> > >> Other ideas, anybody?
> > >
> > > Maybe SmpCacheOptions or SmpCachesPropertyWrapper?
> > 
> > I wonder why we have a single QOM object to configure all caches, and
> > not one QOM object per cache.
> 
> Previous versions of this series were augmenting the existing
> -smp command line.

Ah, yes, since -smp, as a sugar option of -machine, doesn't support
JSON. In -smp, we need to use keyval's style to configure as:

-smp caches.0.name=l1i,caches.0.topo=core

I think JSON is the more elegant way to go, so I chose -object.

> Now the design has switched to use -object,
> I agree that it'd be simplest to just have one -object flag
> added per cache level we want to defnie.
> 

OK.

Thanks,
Zhao


