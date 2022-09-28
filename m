Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85DBF5EDC57
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 14:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbiI1MLU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 08:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbiI1MLS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 08:11:18 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B637476760;
        Wed, 28 Sep 2022 05:11:16 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 14A6768BEB; Wed, 28 Sep 2022 14:11:11 +0200 (CEST)
Date:   Wed, 28 Sep 2022 14:11:10 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org
Subject: Re: simplify the mdev interface v8
Message-ID: <20220928121110.GA30738@lst.de>
References: <20220923092652.100656-1-hch@lst.de> <20220927140737.0b4c9a54.alex.williamson@redhat.com> <20220927155426.23f4b8e9.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927155426.23f4b8e9.alex.williamson@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 27, 2022 at 03:54:26PM -0600, Alex Williamson wrote:
> Oops, I had to drop this, I get a null pointer from gvt-g code:

Ok, this is a stupid bug in the second patch in the series.  I did not
hit it in my mdev testing as my script just uses the first type and
thus never hits these, but as your trace showed mdevctl and once I
used that I could reproduce it.  The fix for patch 2 is below, and
the git tree at:

   git://git.infradead.org/users/hch/misc.git mvdev-lifetime

has been updated with that folded in and the recent reviews.

---
diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c b/drivers/gpu/drm/i915/gvt/vgpu.c
index 1b67328c714f1..b0d5dafd013f4 100644
--- a/drivers/gpu/drm/i915/gvt/vgpu.c
+++ b/drivers/gpu/drm/i915/gvt/vgpu.c
@@ -123,7 +123,7 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
 
 		sprintf(gvt->types[i].name, "GVTg_V%u_%s",
 			GRAPHICS_VER(gvt->gt->i915) == 8 ? 4 : 5, conf->name);
-		gvt->types->conf = conf;
+		gvt->types[i].conf = conf;
 		gvt->types[i].avail_instance = min(low_avail / conf->low_mm,
 						   high_avail / conf->high_mm);
 
