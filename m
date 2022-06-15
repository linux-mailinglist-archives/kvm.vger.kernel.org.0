Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136C954C1D6
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 08:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352606AbiFOG2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 02:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236311AbiFOG2q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 02:28:46 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BEB36E39;
        Tue, 14 Jun 2022 23:28:44 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 37FB567373; Wed, 15 Jun 2022 08:28:41 +0200 (CEST)
Date:   Wed, 15 Jun 2022 08:28:40 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 03/13] vfio/mdev: simplify mdev_type handling
Message-ID: <20220615062840.GB22728@lst.de>
References: <20220614045428.278494-1-hch@lst.de> <20220614045428.278494-4-hch@lst.de> <BN9PR11MB5276A3DCE429292860FD85F58CAA9@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276A3DCE429292860FD85F58CAA9@BN9PR11MB5276.namprd11.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022 at 10:06:16AM +0000, Tian, Kevin wrote:
> > +	gvt->mdev_types = kcalloc(num_types, sizeof(*gvt->mdev_types),
> > +			     GFP_KERNEL);
> > +	if (!gvt->mdev_types) {
> > +		kfree(gvt->types);
> > +		return -ENOMEM;
> > +	}
> > +
> >  	min_low = MB_TO_BYTES(32);
> >  	for (i = 0; i < num_types; ++i) {
> >  		if (low_avail / vgpu_types[i].low_mm == 0)
> > @@ -150,19 +157,21 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
> >  						   high_avail /
> > vgpu_types[i].high_mm);
> 
> there is a memory leak a few lines above:
> 
> if (vgpu_types[i].weight < 1 ||
> 	vgpu_types[i].weight > VGPU_MAX_WEIGHT)
> 	return -EINVAL;
> 
> both old code and this patch forgot to free the buffers upon error.

Yeah.  I'll add a patch to the beginning of the series to fix the
existing leak and will then make sure to not leak the new allocation
either.
