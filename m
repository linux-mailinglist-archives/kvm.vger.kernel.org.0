Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAEDC5664C6
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 10:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiGEICl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 04:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiGEICj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 04:02:39 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D340A46F;
        Tue,  5 Jul 2022 01:02:38 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B786868AA6; Tue,  5 Jul 2022 10:02:34 +0200 (CEST)
Date:   Tue, 5 Jul 2022 10:02:34 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org
Subject: Re: [PATCH 02/14] drm/i915/gvt: simplify vgpu configuration
 management
Message-ID: <20220705080234.GA17663@lst.de>
References: <20220704125144.157288-1-hch@lst.de> <20220704125144.157288-3-hch@lst.de> <20220704141536.GB1423020@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704141536.GB1423020@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 04, 2022 at 11:15:36AM -0300, Jason Gunthorpe wrote:
> > +		if (conf->weight < 1 || conf->weight > VGPU_MAX_WEIGHT)
> >  			goto out_free_types;
> 
> This is now clearly impossible right? Maybe a BUILD_BUG_ON is all that
> is needed:

It is not possible right now, but an incorrect addition to the array
can easily add the condition.  A BUILD_BUG_ON would be nice, but my
gcc doesn't see the expressons as const enough for that to actually work.

> 
>   #define VGPU_WEIGHT(vgpu_num)	\
>          (VGPU_MAX_WEIGHT + BUILD_BUG_ON_ZERO((vgpu_num) > VGPU_MAX_WEIGHT) / (vgpu_num))
> 
> > +		sprintf(gvt->types[i].name, "GVTg_V%u_%s",
> > +			GRAPHICS_VER(gvt->gt->i915) == 8 ? 4 : 5, conf->name);
> > +		gvt->types->conf = conf;
> > +		gvt->types[i].avail_instance = min(low_avail / conf->low_mm,
> > +						   high_avail / conf->high_mm);
> 
> snprintf and check for failure?

I'd rather just leave it as-is. intead of messing with these unrelated
bit.
