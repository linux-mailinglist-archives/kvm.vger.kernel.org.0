Return-Path: <kvm+bounces-28052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DBB39928C7
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 12:07:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C65A01F24BF2
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 10:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E7451C174B;
	Mon,  7 Oct 2024 10:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LVk8pTD4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76171AF4DC
	for <kvm@vger.kernel.org>; Mon,  7 Oct 2024 10:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728295521; cv=none; b=nLwfVz9WYvoqdVUqWXqU9ehKD2WPd7WVBI8h9FtuE9p4t4Ab1hdkgaVu0D+iUI3XQasMuJHYDlLWyC4adewN5CG6Dt1AK4vucPySvxFGwSs5QB56W44s623jhqhqSLhZAcpVDSDikMh4zC/xTAqr8AgJ4U3z6Y5cJkkA087/oFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728295521; c=relaxed/simple;
	bh=AnOcALsZJg/wxyrcnpW+cGt1cV5NfTexgZo0XTBcLLw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i3w6cIHrGLWqIJ4/FriEF9ff5OGPsqSiCQRHc2r2LOGAjSqVuumjBt0H+J5DGw7p35wBiY1ao2pbRQkUlYygVy2s8kskgndZ3FHxIhzCtjO5Hj701uzNMYZUAU0eudbCq2sBY2AKuElbBzL/qz7KUjLhAKcYkR2jCne9p2iRg0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LVk8pTD4; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728295520; x=1759831520;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AnOcALsZJg/wxyrcnpW+cGt1cV5NfTexgZo0XTBcLLw=;
  b=LVk8pTD41pTxqGJ6Hr40+Fb2Z0KbVUx6DzrZHI+6SsE+larhlpeW/y2i
   TB9MTCA2BXMDPkfIJG+mluhQPRaPA3cMyLpiR55HYI4RLjN4MDMFaExgH
   iDj3mK8w8ihCuNay/9jWdwQWTzvLrTIdQhzgqrgL2vP5aghno9wK2/5g2
   VnXJeArlMKbJF09J2gHDzKr/rbZ5EYEKuExEd6w+JlrlW3PLvcJHVQqcr
   zWMUzAGUX/bT72epzMKejt2EXn2yKi7splbCDSLhLklUh5FfC+13clkoL
   iMho02x0qmCCMy7m6/WzYJMFYWsj3Sj6i7tEJLBjjumFnc85fyzWfHYih
   A==;
X-CSE-ConnectionGUID: q6H7Yf3LRZqQ1fMpZgjIug==
X-CSE-MsgGUID: Fz8mK0qVTWWJnuPkoFrdSQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11217"; a="27319851"
X-IronPort-AV: E=Sophos;i="6.11,184,1725346800"; 
   d="scan'208";a="27319851"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 03:05:19 -0700
X-CSE-ConnectionGUID: 7gJQIEZzT8mpzKFWqrHFdQ==
X-CSE-MsgGUID: ogeD7LVYT4KOliHP51MW6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,184,1725346800"; 
   d="scan'208";a="75258677"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa010.jf.intel.com with ESMTP; 07 Oct 2024 03:05:13 -0700
Date: Mon, 7 Oct 2024 18:21:24 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Alireza Sanaee <alireza.sanaee@huawei.com>
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
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v2 6/7] i386/cpu: Update cache topology with machine's
 configuration
Message-ID: <ZwO2JIMJ+lX0N61h@intel.com>
References: <20240908125920.1160236-1-zhao1.liu@intel.com>
 <20240908125920.1160236-7-zhao1.liu@intel.com>
 <20240911110028.00001d3d@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911110028.00001d3d@huawei.com>

Hi Ali,

[snip]

> > +
> > +    /*
> > +     * TODO: Add a SMPCompatProps.has_caches flag to avoid useless
> > Updates
> > +     * if user didn't set smp_cache.
> > +     */
> Hi Zhao,
> 
> Thanks for sending this patchset so quickly. I really appreciate the
> TODO already :)

Welcome! And I'm also sorry for a long silence. Now I'm back from the
vacation and will keep pushing this series forward.

> It also helps me avoid going through every single
> layer, especially when I want to avoid matching system registers in
> ARM, particularly when there's no description in the command line.

Great! I also noticed your patch for this "TODO" and will help you
review it soon.

Regards,
Zhao

> > +    x86_cpu_update_smp_cache_topo(ms, cpu);
> > +
> >      qemu_register_reset(x86_cpu_machine_reset_cb, cpu);
> >  
> >      if (cpu->env.features[FEAT_1_EDX] & CPUID_APIC || ms->smp.cpus >
> > 1) {
> 


