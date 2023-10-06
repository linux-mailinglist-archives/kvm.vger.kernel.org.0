Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4FC7BBC9D
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 18:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbjJFQZi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 12:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjJFQZg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 12:25:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76B29E
        for <kvm@vger.kernel.org>; Fri,  6 Oct 2023 09:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696609534; x=1728145534;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kGaOmkN7wx/FNRMLNQsW/9Woh6neBgW5Hw506XpfW9A=;
  b=AlnIWBnTQYhSYIyff2hDCVu8MxJ0HfwFxsiRCsiwd4v40PfdtxlXhuFD
   M1iyuTbb9mAKPBe9lIBmkzs1Xr8ADPsf5w3jPXMHPp3vci/ArD8hic8Hu
   mvz9nTv46axSCi5KHFR4FymuvYgtH1RkrHBca1EyuYkGGCrMtA/+j/z7c
   BGmGI3YInEc2JaabNcpzFlAmqOod919sucpSN3NsTU1ZvXlOoeOjllFpZ
   nNn7aMAnoBiGIhJWa87ThAIpjunRe/zhkXLmk0G8iPKk1SVoJpUNJ6Eui
   VC5QlNTJOUWGgehNmmQuk8yhdO45n3tQMopidqVzGHQpFQHjoMF+u0Udy
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="447969950"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="447969950"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:25:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="781699510"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="781699510"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orsmga008.jf.intel.com with ESMTP; 06 Oct 2023 09:25:29 -0700
Date:   Sat, 7 Oct 2023 00:36:41 +0800
From:   Zhao Liu <zhao1.liu@linux.intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Philippe =?utf-8?B?TWF0aGlldS1EYXVk77+9?= <philmd@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Zhao Liu <zhao1.liu@intel.com>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v4 21/21] i386: Add new property to control L2 cache topo
 in CPUID.04H
Message-ID: <ZSA3mfmOz+RZcmct@liuzhao-OptiPlex-7080>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
 <20230914072159.1177582-22-zhao1.liu@linux.intel.com>
 <75ea5477-ca1b-7016-273c-abd6c36f4be4@linaro.org>
 <ZQQNddiCky/cImAz@liuzhao-OptiPlex-7080>
 <20231003085516-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231003085516-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Michael,

On Tue, Oct 03, 2023 at 08:57:27AM -0400, Michael S. Tsirkin wrote:
> Date: Tue, 3 Oct 2023 08:57:27 -0400
> From: "Michael S. Tsirkin" <mst@redhat.com>
> Subject: Re: [PATCH v4 21/21] i386: Add new property to control L2 cache
>  topo in CPUID.04H
> 
> On Fri, Sep 15, 2023 at 03:53:25PM +0800, Zhao Liu wrote:
> > Hi Philippe,
> > 
> > On Thu, Sep 14, 2023 at 09:41:30AM +0200, Philippe Mathieu-Daud? wrote:
> > > Date: Thu, 14 Sep 2023 09:41:30 +0200
> > > From: Philippe Mathieu-Daud? <philmd@linaro.org>
> > > Subject: Re: [PATCH v4 21/21] i386: Add new property to control L2 cache
> > >  topo in CPUID.04H
> > > 
> > > On 14/9/23 09:21, Zhao Liu wrote:
> > > > From: Zhao Liu <zhao1.liu@intel.com>
> > > > 
> > > > The property x-l2-cache-topo will be used to change the L2 cache
> > > > topology in CPUID.04H.
> > > > 
> > > > Now it allows user to set the L2 cache is shared in core level or
> > > > cluster level.
> > > > 
> > > > If user passes "-cpu x-l2-cache-topo=[core|cluster]" then older L2 cache
> > > > topology will be overrode by the new topology setting.
> > > > 
> > > > Here we expose to user "cluster" instead of "module", to be consistent
> > > > with "cluster-id" naming.
> > > > 
> > > > Since CPUID.04H is used by intel CPUs, this property is available on
> > > > intel CPUs as for now.
> > > > 
> > > > When necessary, it can be extended to CPUID.8000001DH for AMD CPUs.
> > > > 
> > > > (Tested the cache topology in CPUID[0x04] leaf with "x-l2-cache-topo=[
> > > > core|cluster]", and tested the live migration between the QEMUs w/ &
> > > > w/o this patch series.)
> > > > 
> > > > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > > > Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> > > > ---
> > > > Changes since v3:
> > > >   * Add description about test for live migration compatibility. (Babu)
> > > > 
> > > > Changes since v1:
> > > >   * Rename MODULE branch to CPU_TOPO_LEVEL_MODULE to match the previous
> > > >     renaming changes.
> > > > ---
> > > >   target/i386/cpu.c | 34 +++++++++++++++++++++++++++++++++-
> > > >   target/i386/cpu.h |  2 ++
> > > >   2 files changed, 35 insertions(+), 1 deletion(-)
> > > 
> > > 
> > > > @@ -8079,6 +8110,7 @@ static Property x86_cpu_properties[] = {
> > > >                        false),
> > > >       DEFINE_PROP_BOOL("x-intel-pt-auto-level", X86CPU, intel_pt_auto_level,
> > > >                        true),
> > > > +    DEFINE_PROP_STRING("x-l2-cache-topo", X86CPU, l2_cache_topo_level),
> > > 
> > > We use the 'x-' prefix for unstable features, is it the case here?
> > 
> > I thought that if we can have a more general CLI way to define cache
> > topology in the future, then this option can be removed.
> > 
> > I'm not sure if this option could be treated as unstable, what do you
> > think?
> > 
> > 
> > Thanks,
> > Zhao
> 
> Then, please work on this new generic thing.
> What we don't want is people relying on unstable options.
> 

Okay, I'll remove this option in the next refresh.

BTW, about the generic cache topology, what about porting this option to
smp? Just like:

-smp cpus=4,sockets=2,cores=2,threads=1, \
     l3-cache=socket,l2-cache=core,l1-i-cache=core,l1-d-cache=core

From the previous discussion [1] with Jonathan, it seems this format
could also meet the requirement for ARM.

If you like this, I'll move forward in this direction. ;-)

[1]: https://lists.gnu.org/archive/html/qemu-devel/2023-08/msg03997.html

Thanks,
Zhao

