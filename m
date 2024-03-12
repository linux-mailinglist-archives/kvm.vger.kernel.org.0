Return-Path: <kvm+bounces-11649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E2254878FFA
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 09:50:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9820B1F21721
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 08:50:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DC2177F1B;
	Tue, 12 Mar 2024 08:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eWQkwrkV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5435D77F03
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 08:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710233438; cv=none; b=Mp5yNWgYQcy8ISzyxf2lwsomEoMHW8Bu2m+tsfjAvt7eOa1pqY3mj3mzZUF5UbIgjF542dCK6jMSfG4hmOnOkvsgtKreF3nno3S80cDEYdfd3GA6eTKMWuw0jdjFNW8+jpFoXwJfAj7u7IW7WceGZ34U/ndl7EKSoBqb6djgyYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710233438; c=relaxed/simple;
	bh=tA7oWp+GjC17n46OR1Cu4CFWGzTsKORFW9MJUrRGwSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zi9lU0rJiydSsMr0qnHuB2BqY81SyksvVRW08Sa1hS430CWS3RoDoGDJQNJWYxZCh+YC+doL3YA7E7RvJrCwsKbxn5vLdtdmU24v7lmR9ySM+ToR+mJu850vVcaIQbIXdGcWnmf6OREx81B91awyTRJNl/5z5hoQHQ6tZdjQZ54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eWQkwrkV; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710233437; x=1741769437;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tA7oWp+GjC17n46OR1Cu4CFWGzTsKORFW9MJUrRGwSc=;
  b=eWQkwrkVNBK9cOiZOintWsAuxf8b/zvKnm4DS73/UXgreN1x0DyW6Wxo
   gbmNRxFoDmVofBSje4S9yrNgkspiZrACs9ot6QvN8lZxQTk/IzODM1GM5
   6NGIYPpyCp4yz81IJs+9d624nuu6W8Y1FOZNCg9vdIFdO6U0xZeTurkk4
   oRodNPkRGgC4f1LzBYHUCx4Inu5Nz8YzqHCa6qzIMmrG/eGiJi/3kxuDW
   H8M221epNpyMTiArLlt3GeiglLKEAYI+zoMpcmbkh8ozSE4CwQU6168Ph
   pjD6rWeSdXqbA779g53wv03Yfu5RCxYQjb/XK18901WKW4HAcROf5K/vl
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="27403851"
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="27403851"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 01:50:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="16043565"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa003.fm.intel.com with ESMTP; 12 Mar 2024 01:50:31 -0700
Date: Tue, 12 Mar 2024 17:04:21 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>, Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Robert Hoo <robert.hu@linux.intel.com>
Subject: Re: [PATCH v9 06/21] i386/cpu: Use APIC ID info to encode cache topo
 in CPUID[4]
Message-ID: <ZfAalR49aErs2/M1@intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
 <20240227103231.1556302-7-zhao1.liu@linux.intel.com>
 <c88ee253-f212-4aa7-9db9-e90a99a9a1e3@intel.com>
 <Ze23y7UzGxnsyo6O@intel.com>
 <164e9fe1-c89d-4354-a7f7-a565c624934e@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164e9fe1-c89d-4354-a7f7-a565c624934e@intel.com>

On Mon, Mar 11, 2024 at 05:03:02PM +0800, Xiaoyao Li wrote:
> Date: Mon, 11 Mar 2024 17:03:02 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH v9 06/21] i386/cpu: Use APIC ID info to encode cache
>  topo in CPUID[4]
> 
> On 3/10/2024 9:38 PM, Zhao Liu wrote:
> > Hi Xiaoyao,
> > 
> > > >                case 3: /* L3 cache info */
> > > > -                die_offset = apicid_die_offset(&topo_info);
> > > >                    if (cpu->enable_l3_cache) {
> > > > +                    addressable_threads_width = apicid_die_offset(&topo_info);
> > > 
> > > Please get rid of the local variable @addressable_threads_width.
> > > 
> > > It is truly confusing.
> > 
> > There're several reasons for this:
> > 
> > 1. This commit is trying to use APIC ID topology layout to decode 2
> > cache topology fields in CPUID[4], CPUID.04H:EAX[bits 25:14] and
> > CPUID.04H:EAX[bits 31:26]. When there's a addressable_cores_width to map
> > to CPUID.04H:EAX[bits 31:26], it's more clear to also map
> > CPUID.04H:EAX[bits 25:14] to another variable.
> 
> I don't dislike using a variable. I dislike the name of that variable since
> it's misleading

Names are hard to choose...

> 
> > 2. All these 2 variables are temporary in this commit, and they will be
> > replaed by 2 helpers in follow-up cleanup of this series.
> 
> you mean patch 20?
> 
> I don't see how removing the local variable @addressable_threads_width
> conflicts with patch 20. As a con, it introduces code churn.

Yes...I prefer to wrap it in variables in advance, then the meaning of
the fields is clearer I think.

> > 3. Similarly, to make it easier to clean up later with the helper and
> > for more people to review, it's neater to explicitly indicate the
> > CPUID.04H:EAX[bits 25:14] with a variable here.
> 
> If you do want keeping the variable. Please add a comment above it to
> explain the meaning.
>

OK, I'll add comments for both 2 variables. Thanks!


