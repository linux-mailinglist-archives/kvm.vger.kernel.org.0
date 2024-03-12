Return-Path: <kvm+bounces-11653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EEF1C87918C
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 10:59:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2ADAC1C21E8B
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 09:59:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDADE7866E;
	Tue, 12 Mar 2024 09:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BJYcvynb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAB97828B
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 09:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710237536; cv=none; b=FDJQD0dZ2F8FzmN03FAm0oJTvQ8urrziYRrQo4nY7oSnBq9TheUunH9IEMhKJqY6JCPF4uPf29FbgE7wvjzJL7FsFpH0fjgcjofBbP4KOILpAojV342WDQNzDHlbUEM8/gZvOwIEtKnvOs3xNTKoYeteK3fmpS0neq1A4bca/gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710237536; c=relaxed/simple;
	bh=Y6VdP9faqh72Mn6LhmNnwRXRt34XCvhHGJdaTZngvro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EUOVDD7eYzwPsdFPe7Fv17nSZl6UWXt7NyBiVz0XiqFX91BWaoBKYsuGh5A+dcyhmmpSktKJMpBl+PwhCNEdkNRAoRRpXNVftFaXoiIqZ9jL9M7BA85nB6rCjppWOnQgOLMno4EOGdc/ahR+KzN0keNlTj4i8AnbpRFUcD1D2zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BJYcvynb; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710237534; x=1741773534;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Y6VdP9faqh72Mn6LhmNnwRXRt34XCvhHGJdaTZngvro=;
  b=BJYcvynbODJvbB4/cfJu0e+W8VcsipoaPkzc6bmOCQamRsA9G26FYdUP
   ttXtI7IzVlzTkf7xXleDJ+1E1qTwGP/spjhuY6ReiicX8kjiqr6P/yOYo
   ZsbNqVIPuLOxBVwfojuH+v3nX+6qI4NhTH1X3io8HOSAwtFekbKsoiNBA
   CAlLHPHX4FbdfuzynOvs3eqseraO1az4lmQMWWTCpCl7ROsB92UjPCx1i
   5GwxAoS4t1sKMKYXvHhVgUlaq7Ljo18bercQ3UeGNA45Mxzs4IMGYRVvE
   bHEhT2DmVbAmWNYJIXr75+YYqaFHE9ALZUqhOKWTta/RWAfT7baLFCPSa
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="5109251"
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="5109251"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 02:58:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="11560026"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa006.fm.intel.com with ESMTP; 12 Mar 2024 02:58:48 -0700
Date: Tue, 12 Mar 2024 18:12:38 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
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
	Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>, Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v9 02/21] hw/core/machine: Support modules in -smp
Message-ID: <ZfAqltds4Bcr2Ruj@intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
 <20240227103231.1556302-3-zhao1.liu@linux.intel.com>
 <e730da3c-42be-45d0-aa11-279ee47bb933@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e730da3c-42be-45d0-aa11-279ee47bb933@linux.intel.com>

> > @@ -51,6 +51,10 @@ static char *cpu_hierarchy_to_string(MachineState *ms)
> >           g_string_append_printf(s, " * clusters (%u)", ms->smp.clusters);
> >       }
> > +    if (mc->smp_props.modules_supported) {
> > +        g_string_append_printf(s, " * modules (%u)", ms->smp.clusters);
> > +    }
> 
> smp.clusters -> smp.modules?
>

Good catch! Thanks!

-Zhao


