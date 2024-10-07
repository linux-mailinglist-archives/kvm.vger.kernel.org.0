Return-Path: <kvm+bounces-28054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D3DD299293F
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 12:32:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9ADCD283341
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 10:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C32B21C6F6D;
	Mon,  7 Oct 2024 10:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QP7zYerZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117B71C2324
	for <kvm@vger.kernel.org>; Mon,  7 Oct 2024 10:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728297128; cv=none; b=brJVd19yD+SkDn1/id9w9MtuavOMtPuTBJPZNp1VygQiSL3yYzH3NF8nl1pmPcNOOGjeeN/GIYAvmbTA3qEC0aAT09pK6ALpaOMjLRZZcU4dV1xzb3ve3Mn66PtOaP3nN0XRS62miEWeW5V7Z38iHGmD8Pq7fzQAN+1E2mMbyys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728297128; c=relaxed/simple;
	bh=jhJUK+AWFll4gfSxpcVeHGVJ440uyTmTNkzlK2H16Kk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bl+hAffPaqrqU/JWfICO4YQHxTQG60umKWeo+dG4KqpCJMjUHJ1s3jdUiad3pagyZA8dJxsynGnSWdym+KFqs0Y/tfSo+8Lnse8n4wh6vWKqqnLarB6lgE4SqSsENdkuWJm+hY5HskFufYHyOZgsFxVgj3UbBXH/U7WQEQaKE0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QP7zYerZ; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728297125; x=1759833125;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jhJUK+AWFll4gfSxpcVeHGVJ440uyTmTNkzlK2H16Kk=;
  b=QP7zYerZP6BlQFHnSTkApqhsbj/ahBc/yAy0IDBx30/QAx8miatLHwOa
   /mxC0eQUAgmMjkrnEG6TScSL0PLheZVNFo3q63m7f+sHvpzzp/O3y9S8+
   dQiH4YYeW4qGAcZhXdyX9Sn+F9KKNsdbY8CKbJE6nKV6TCGys8/26rN1N
   nPIrO8O+/9OmIrcVcRL8n5/Wugcsu1QDsshlYvbCl9YcR3d3U6kE6yyHY
   wtXcB06a8vRWDPRGFDbnEtTY567tu7hPsPE/g+aiwLHDIm6zg3cLxbVHb
   yLOjW7z+XjPsuTSCuEK9M2psJpm8lbIIIg/ob6wn9iVtM8JB/fdlZQkHB
   A==;
X-CSE-ConnectionGUID: 1KBV4i3iTBagkcSp1Rtr5A==
X-CSE-MsgGUID: 7qPFi31PS4qNaZHSBTvj4w==
X-IronPort-AV: E=McAfee;i="6700,10204,11217"; a="38044281"
X-IronPort-AV: E=Sophos;i="6.11,184,1725346800"; 
   d="scan'208";a="38044281"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 03:32:02 -0700
X-CSE-ConnectionGUID: o2wxnFLcQ8aCs2GXkI/Wpg==
X-CSE-MsgGUID: 9taj1YQOS2OUtO3z+NOWIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,184,1725346800"; 
   d="scan'208";a="80401926"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa004.jf.intel.com with ESMTP; 07 Oct 2024 03:31:56 -0700
Date: Mon, 7 Oct 2024 18:48:07 +0800
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
Subject: Re: [PATCH v2 2/7] qapi/qom: Define cache enumeration and properties
Message-ID: <ZwO8Z6pABtp2Zfi3@intel.com>
References: <20240908125920.1160236-1-zhao1.liu@intel.com>
 <20240908125920.1160236-3-zhao1.liu@intel.com>
 <20240917095126.000036f1@Huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240917095126.000036f1@Huawei.com>

Hi Jonathan,

Thanks for your review and feedback!

[snip]

> > Note, define cache topology based on CPU topology level with two
> > reasons:
> > 
> >  1. In practice, a cache will always be bound to the CPU container
> >     (either private in the CPU container or shared among multiple
> >     containers), and CPU container is often expressed in terms of CPU
> >     topology level.
> >  2. The x86's cache-related CPUIDs encode cache topology based on APIC
> >     ID's CPU topology layout. And the ACPI PPTT table that ARM/RISCV
> >     relies on also requires CPU containers to help indicate the private
> 
> Really trivial but CPU Containers are a different ACPI concept.
> For PPTT they are referred to as Processor Groups. Wonderfully they
> 'might match a Processor Container in the namespace' which rather implies
> they might not.  In QEMU they always will because the next bit of the
> spec matters. "In that case this entry will match the value of the _UID
> method of the associated processor container. Where there is a match it must
> be represented."
> 
> So having said all that, CPU container is probably fine as a description.

Thanks for the explanation!

> >     shared hierarchy of the cache. Therefore, for SMP systems, it is
> >     natural to use the CPU topology hierarchy directly in QEMU to define
> >     the cache topology.
> > 
> > Suggested-by: Daniel P. Berrange <berrange@redhat.com>
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > Tested-by: Yongwei Ma <yongwei.ma@intel.com>
>
> Seems fine but my gut would be to combine this and next patch so we can
> see how it is used (assuming no one asked for it to be separate!)

No problem. I intended to make it easier to review the QAPI part, but
these two patches were simple enough that I was happy to combine them.

> Version numbers need an update I guess.

Ah, yes!

> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Thanks!

> > +##
> > +# @SmpCachePropertiesWrapper:
> > +#
> > +# List wrapper of SmpCacheProperties.
> > +#
> > +# @caches: the list of SmpCacheProperties.
> > +#
> > +# Since 9.1
> 
> Needs updating to 9.2 I guess.

Yes, I think so, too.

Thanks,
Zhao

> > +##
> > +{ 'struct': 'SmpCachePropertiesWrapper',
> > +  'data': { 'caches': ['SmpCacheProperties'] } }
> 

