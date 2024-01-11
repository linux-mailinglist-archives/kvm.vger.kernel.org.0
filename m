Return-Path: <kvm+bounces-6059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AE86C82A92E
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 09:33:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCFF41C23611
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 08:33:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D2B1125B5;
	Thu, 11 Jan 2024 08:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iw75YLNe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101AE125C7
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 08:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704962027; x=1736498027;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=larED5ocgA7/Xweo3DyaTLQk2Fdwzv9gml6jTTCp4KM=;
  b=iw75YLNerk7JdjAv01x5nPcmJK3+E55beSrIKkhqNFA8Pi9LS4O1GtX8
   1eEUA5xJxSWZcgSslHY7QggXDdKTc44DuXq8jWAceHyC1PFLjLX9OdJkZ
   QAEWIdHcSclV35ZHB8BidoCF9GYXsSJlg9qLPi2u34aFZG2oBNwnXiuu7
   cMctqebOzot45/L3Ya98bVKPRXcGXUWOEPFIDRc1eTrlzoKig55/Sp6CE
   Km1fCgBgsO5rANnUFo8Y1FkY7KyULg+DqwNLMPdOiJZcPTFitz7IGhQ+o
   ZzK6xXzACsw/LwBnr/VXwlKqmpxasWmiatgaRr5CH5kfJkQHPWUy7gPJg
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10949"; a="12135452"
X-IronPort-AV: E=Sophos;i="6.04,185,1695711600"; 
   d="scan'208";a="12135452"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 00:33:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10949"; a="732142769"
X-IronPort-AV: E=Sophos;i="6.04,185,1695711600"; 
   d="scan'208";a="732142769"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orsmga003.jf.intel.com with ESMTP; 11 Jan 2024 00:33:41 -0800
Date: Thu, 11 Jan 2024 16:46:37 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Robert Hoo <robert.hu@linux.intel.com>,
	Babu Moger <babu.moger@amd.com>, Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH v7 03/16] i386/cpu: Consolidate the use of topo_info in
 cpu_x86_cpuid()
Message-ID: <ZZ+q7d9+ZOwOum2F@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-4-zhao1.liu@linux.intel.com>
 <ddb911d0-6054-43ab-a763-242216b9c8d9@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddb911d0-6054-43ab-a763-242216b9c8d9@intel.com>

Hi Xiaoyao,

On Wed, Jan 10, 2024 at 07:52:38PM +0800, Xiaoyao Li wrote:
> Date: Wed, 10 Jan 2024 19:52:38 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH v7 03/16] i386/cpu: Consolidate the use of topo_info in
>  cpu_x86_cpuid()
> 
> On 1/8/2024 4:27 PM, Zhao Liu wrote:
> > From: Zhao Liu <zhao1.liu@intel.com>
> > 
> > In cpu_x86_cpuid(), there are many variables in representing the cpu
> > topology, e.g., topo_info, cs->nr_cores/cs->nr_threads.
> 
> Please use comma instead of slash. cs->nr_cores/cs->nr_threads looks like
> one variable.

Okay.

> 
> > Since the names of cs->nr_cores/cs->nr_threads does not accurately
> > represent its meaning, the use of cs->nr_cores/cs->nr_threads is prone
> > to confusion and mistakes.
> > 
> > And the structure X86CPUTopoInfo names its members clearly, thus the
> > variable "topo_info" should be preferred.
> > 
> > In addition, in cpu_x86_cpuid(), to uniformly use the topology variable,
> > replace env->dies with topo_info.dies_per_pkg as well.
> > 
> > Suggested-by: Robert Hoo <robert.hu@linux.intel.com>
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > Tested-by: Babu Moger <babu.moger@amd.com>
> > Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > Changes since v3:
> >   * Fix typo. (Babu)
> > 
> > Changes since v1:
> >   * Extract cores_per_socket from the code block and use it as a local
> >     variable for cpu_x86_cpuid(). (Yanan)
> >   * Remove vcpus_per_socket variable and use cpus_per_pkg directly.
> >     (Yanan)
> >   * Replace env->dies with topo_info.dies_per_pkg in cpu_x86_cpuid().
> > ---
> >   target/i386/cpu.c | 31 ++++++++++++++++++-------------
> >   1 file changed, 18 insertions(+), 13 deletions(-)
> > 
> > diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> > index c8d2a585723a..6f8fa772ecf8 100644
> > --- a/target/i386/cpu.c
> > +++ b/target/i386/cpu.c
> > @@ -6017,11 +6017,16 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
> >       uint32_t limit;
> >       uint32_t signature[3];
> >       X86CPUTopoInfo topo_info;
> > +    uint32_t cores_per_pkg;
> > +    uint32_t cpus_per_pkg;
> 
> I prefer to lps_per_pkg or threads_per_pkg.

Okay, lp is not common in QEMU code, so I would change this to
threads_per_pkg.

> 
> Other than it,
> 
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

Thanks!

-Zhao


