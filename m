Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F35356C704
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 06:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiGIEzS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 00:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGIEzQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 00:55:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1079B140D5;
        Fri,  8 Jul 2022 21:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=bJ/2mjvztYAzYKekFyqBsdfuFu74OvSupsxhbe+N+7Q=; b=NrxSxJgm2XVKPMFKgjKv+cYNj4
        AUo2GakyCY70OTG2Ed937aWrNVI2kj394GhDMicgYtw3+ZnJc0O3V0nID2qYXLBuGomyuSPK/9EdO
        LLdHNHXzMEmLIkroa8iP5ri+BPLoG7g/ttNuEI8Ttk4GEQwLQ41JfmQFC8aruZH3P/Wl/RwTs+sem
        6K0Vy1S9S/MPfX4/dS7zD6UXNszn6R+j81VktRQ+VmIz405bq2RtC0x193n0IIpnuguIpowqjB2g5
        suELu6zshYZs+efd10GIAKXp++30WRNhBmf9cGQJZR33ngmgqSt/RKr1FUvi7IpVc70BPOvvL1BUT
        1+jbKL0w==;
Received: from 213-225-4-185.nat.highway.a1.net ([213.225.4.185] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oA2Ub-006ztv-WD; Sat, 09 Jul 2022 04:54:58 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 01/14] drm/i915/gvt: fix a memory leak in intel_gvt_init_vgpu_types
Date:   Sat,  9 Jul 2022 06:54:37 +0200
Message-Id: <20220709045450.609884-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220709045450.609884-1-hch@lst.de>
References: <20220709045450.609884-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

gvt->types needs to be freed on error.

Fixes: c90d097ae144 ("drm/i915/gvt: define weight according to vGPU type")
Reported-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
 drivers/gpu/drm/i915/gvt/vgpu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c b/drivers/gpu/drm/i915/gvt/vgpu.c
index 46da19b3225d2..5c828556cefd7 100644
--- a/drivers/gpu/drm/i915/gvt/vgpu.c
+++ b/drivers/gpu/drm/i915/gvt/vgpu.c
@@ -142,7 +142,7 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
 
 		if (vgpu_types[i].weight < 1 ||
 					vgpu_types[i].weight > VGPU_MAX_WEIGHT)
-			return -EINVAL;
+			goto out_free_types;
 
 		gvt->types[i].weight = vgpu_types[i].weight;
 		gvt->types[i].resolution = vgpu_types[i].edid;
@@ -167,6 +167,10 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
 
 	gvt->num_types = i;
 	return 0;
+
+out_free_types:
+	kfree(gvt->types);
+	return -EINVAL;
 }
 
 void intel_gvt_clean_vgpu_types(struct intel_gvt *gvt)
-- 
2.30.2

