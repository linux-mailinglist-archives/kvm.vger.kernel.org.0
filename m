Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07747A17A6
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 09:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbjIOHmc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 03:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbjIOHmb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 03:42:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DE8A1
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 00:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694763746; x=1726299746;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=cDgMalxwmA0/rs78BBy/qTkAwU1CeKaTo0idZtPsVfs=;
  b=ji+GmwiVuYxCWIq0KLHmabkyqhnbEXI0fG/zAK+ktJH5FAQtkmZJTQ1Y
   EzCphrHcgzD3bNaz14sXznCK8uttopufbenZXAvJIU2cNylJ6PI/oSI5i
   y5NGe7Ru8d6Xq+p8yKSvupZAhrjPDl9wWvjjW/crSuC0iprJoSeDrL670
   /CvXxMW9iIyuNo6uI6T9HYTBBmYix28PxeoVl85fjA6ujRwtE0LHdagVb
   MnXCaJWIyAOwcP/5AZxe/qrqD41Y08CW/xys0xzGkW1TjopmAZYC5rz7I
   Qkph4WVEQY88E0fOcJzEjarbwL9G5t40CxiCRRohggjwQ1hvlnh6IPk1W
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="379104077"
X-IronPort-AV: E=Sophos;i="6.02,148,1688454000"; 
   d="scan'208";a="379104077"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2023 00:42:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="860059358"
X-IronPort-AV: E=Sophos;i="6.02,148,1688454000"; 
   d="scan'208";a="860059358"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmsmga002.fm.intel.com with ESMTP; 15 Sep 2023 00:42:22 -0700
Date:   Fri, 15 Sep 2023 15:53:25 +0800
From:   Zhao Liu <zhao1.liu@linux.intel.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc:     Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Zhao Liu <zhao1.liu@intel.com>,
        Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH v4 21/21] i386: Add new property to control L2 cache topo
 in CPUID.04H
Message-ID: <ZQQNddiCky/cImAz@liuzhao-OptiPlex-7080>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
 <20230914072159.1177582-22-zhao1.liu@linux.intel.com>
 <75ea5477-ca1b-7016-273c-abd6c36f4be4@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <75ea5477-ca1b-7016-273c-abd6c36f4be4@linaro.org>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Philippe,

On Thu, Sep 14, 2023 at 09:41:30AM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu, 14 Sep 2023 09:41:30 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: Re: [PATCH v4 21/21] i386: Add new property to control L2 cache
>  topo in CPUID.04H
> 
> On 14/9/23 09:21, Zhao Liu wrote:
> > From: Zhao Liu <zhao1.liu@intel.com>
> > 
> > The property x-l2-cache-topo will be used to change the L2 cache
> > topology in CPUID.04H.
> > 
> > Now it allows user to set the L2 cache is shared in core level or
> > cluster level.
> > 
> > If user passes "-cpu x-l2-cache-topo=[core|cluster]" then older L2 cache
> > topology will be overrode by the new topology setting.
> > 
> > Here we expose to user "cluster" instead of "module", to be consistent
> > with "cluster-id" naming.
> > 
> > Since CPUID.04H is used by intel CPUs, this property is available on
> > intel CPUs as for now.
> > 
> > When necessary, it can be extended to CPUID.8000001DH for AMD CPUs.
> > 
> > (Tested the cache topology in CPUID[0x04] leaf with "x-l2-cache-topo=[
> > core|cluster]", and tested the live migration between the QEMUs w/ &
> > w/o this patch series.)
> > 
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> > ---
> > Changes since v3:
> >   * Add description about test for live migration compatibility. (Babu)
> > 
> > Changes since v1:
> >   * Rename MODULE branch to CPU_TOPO_LEVEL_MODULE to match the previous
> >     renaming changes.
> > ---
> >   target/i386/cpu.c | 34 +++++++++++++++++++++++++++++++++-
> >   target/i386/cpu.h |  2 ++
> >   2 files changed, 35 insertions(+), 1 deletion(-)
> 
> 
> > @@ -8079,6 +8110,7 @@ static Property x86_cpu_properties[] = {
> >                        false),
> >       DEFINE_PROP_BOOL("x-intel-pt-auto-level", X86CPU, intel_pt_auto_level,
> >                        true),
> > +    DEFINE_PROP_STRING("x-l2-cache-topo", X86CPU, l2_cache_topo_level),
> 
> We use the 'x-' prefix for unstable features, is it the case here?

I thought that if we can have a more general CLI way to define cache
topology in the future, then this option can be removed.

I'm not sure if this option could be treated as unstable, what do you
think?


Thanks,
Zhao

> 
> >       DEFINE_PROP_END_OF_LIST()
> >   };
> 
