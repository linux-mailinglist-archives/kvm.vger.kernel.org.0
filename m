Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C587A1796
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 09:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbjIOHjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 03:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbjIOHjV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 03:39:21 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DD0A1
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 00:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694763556; x=1726299556;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=/L5js5y+5VD6VJOtk0WYiYTY/emloq6pGvAJxw3+EWg=;
  b=AW1zytXOqCqM51AjZwcRP9ojDVcfKh01xoWcpE/MsVnzllKuM3/yFwkV
   slubvbGkTx1F4glpF8979pgFS2p0fTNuL/a51mmVeSzEAsF/2PbqWRA1T
   HVGFYRxdN1HwuKXocjJWb1ME5fwps+tzRz2T8IGn80rwQwmx+f+VeUYp2
   oN8f7awzYb39nVI/gUZbX2m/cENVdmXfHzfOb3Unhi4i2BB4LyneWJs7P
   /6CqlTnAI5mgjTtR4RKvzhuw9FlQswB5yl0JFXuZhbSazEyUNmFkRrMRW
   OuUxOGmE/13om9m8gHgpS12+fp817uAnrV6OLX8kNjYII3qmVzR12k01g
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="378101882"
X-IronPort-AV: E=Sophos;i="6.02,148,1688454000"; 
   d="scan'208";a="378101882"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2023 00:39:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="744876439"
X-IronPort-AV: E=Sophos;i="6.02,148,1688454000"; 
   d="scan'208";a="744876439"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orsmga002.jf.intel.com with ESMTP; 15 Sep 2023 00:39:12 -0700
Date:   Fri, 15 Sep 2023 15:50:14 +0800
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
        Zhuocheng Ding <zhuocheng.ding@intel.com>
Subject: Re: [PATCH v4 10/21] i386: Introduce module-level cpu topology to
 CPUX86State
Message-ID: <ZQQMtqYqIVXt++s+@liuzhao-OptiPlex-7080>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
 <20230914072159.1177582-11-zhao1.liu@linux.intel.com>
 <b98d2eb3-7228-5a78-3c91-d347f160bc8a@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b98d2eb3-7228-5a78-3c91-d347f160bc8a@linaro.org>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Philippe,

On Thu, Sep 14, 2023 at 09:38:46AM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu, 14 Sep 2023 09:38:46 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: Re: [PATCH v4 10/21] i386: Introduce module-level cpu topology to
>  CPUX86State
> 
> On 14/9/23 09:21, Zhao Liu wrote:
> > From: Zhuocheng Ding <zhuocheng.ding@intel.com>
> > 
> > smp command has the "clusters" parameter but x86 hasn't supported that
> > level. "cluster" is a CPU topology level concept above cores, in which
> > the cores may share some resources (L2 cache or some others like L3
> > cache tags, depending on the Archs) [1][2]. For x86, the resource shared
> > by cores at the cluster level is mainly the L2 cache.
> > 
> > However, using cluster to define x86's L2 cache topology will cause the
> > compatibility problem:
> > 
> > Currently, x86 defaults that the L2 cache is shared in one core, which
> > actually implies a default setting "cores per L2 cache is 1" and
> > therefore implicitly defaults to having as many L2 caches as cores.
> > 
> > For example (i386 PC machine):
> > -smp 16,sockets=2,dies=2,cores=2,threads=2,maxcpus=16 (*)
> > 
> > Considering the topology of the L2 cache, this (*) implicitly means "1
> > core per L2 cache" and "2 L2 caches per die".
> > 
> > If we use cluster to configure L2 cache topology with the new default
> > setting "clusters per L2 cache is 1", the above semantics will change
> > to "2 cores per cluster" and "1 cluster per L2 cache", that is, "2
> > cores per L2 cache".
> > 
> > So the same command (*) will cause changes in the L2 cache topology,
> > further affecting the performance of the virtual machine.
> > 
> > Therefore, x86 should only treat cluster as a cpu topology level and
> > avoid using it to change L2 cache by default for compatibility.
> > 
> > "cluster" in smp is the CPU topology level which is between "core" and
> > die.
> > 
> > For x86, the "cluster" in smp is corresponding to the module level [2],
> > which is above the core level. So use the "module" other than "cluster"
> > in i386 code.
> > 
> > And please note that x86 already has a cpu topology level also named
> > "cluster" [3], this level is at the upper level of the package. Here,
> > the cluster in x86 cpu topology is completely different from the
> > "clusters" as the smp parameter. After the module level is introduced,
> > the cluster as the smp parameter will actually refer to the module level
> > of x86.
> > 
> > [1]: 864c3b5c32f0 ("hw/core/machine: Introduce CPU cluster topology support")
> > [2]: Yanan's comment about "cluster",
> >       https://lists.gnu.org/archive/html/qemu-devel/2023-02/msg04051.html
> > [3]: SDM, vol.3, ch.9, 9.9.1 Hierarchical Mapping of Shared Resources.
> > 
> > Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
> > Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > Changes since v1:
> >   * The background of the introduction of the "cluster" parameter and its
> >     exact meaning were revised according to Yanan's explanation. (Yanan)
> > ---
> >   hw/i386/x86.c     | 1 +
> >   target/i386/cpu.c | 1 +
> >   target/i386/cpu.h | 5 +++++
> >   3 files changed, 7 insertions(+)
> 
> 
> > diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> > index 470257b92240..556e80f29764 100644
> > --- a/target/i386/cpu.h
> > +++ b/target/i386/cpu.h
> > @@ -1903,6 +1903,11 @@ typedef struct CPUArchState {
> >       /* Number of dies within this CPU package. */
> >       unsigned nr_dies;
> > +    /*
> > +     * Number of modules within this CPU package.
> > +     * Module level in x86 cpu topology is corresponding to smp.clusters.
> > +     */
> > +    unsigned nr_modules;
> >   } CPUX86State;
> 
> It would be really useful to have an ASCII art comment showing
> the architecture topology.

Good idea, I could consider how to show that.

> Also for clarity the topo fields from
> CPU[Arch]State could be moved into a 'topo' sub structure, or even
> clearer would be to re-use the X86CPUTopoIDs structure?

Yeah, I also have the plan to do further cleanup about these topology
structures [1]. X86CPUTopoInfo is not suitable for hybrid topology case,
(hybrid case needs another structure to store the max number elements
for each level), so I will try to move that X86CPUTopoInfo into
CPU[Arch]State.

[1]: https://lists.gnu.org/archive/html/qemu-devel/2023-08/msg01032.html

Thanks,
Zhao
