Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F8366DF58
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 14:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjAQNug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 08:50:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbjAQNuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 08:50:01 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8CF3B65F
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 05:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673963393; x=1705499393;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CpwZVJplIyYSK1nrLUTtDPHHHdMW/9c8QLMcMf23i4g=;
  b=Z7bLEu7OO0oK6/Udhw51u95AwIweDKbv4d1M6zqjeG07GGblTTW/ZMft
   WcyQhoLhtCWB/AomPY9gUu5DPLnTeMPM746jd5ZWIRgQAe2hw6GfTWqQi
   m1l41jb8X3+G2dhJ8eUAkIePzaKNOYLbyQsFxn0z97bw2rcpfYS3tTnJ4
   i2ENIHq2kK1y/aGIMdI1RBEc8yP1SxiXrQnPGfIV738XMMoELYdrhcTC4
   5Tl+m+Iu/ijRnL5wZB26JIYbGNoJgkNZUv20rR3lWhvn2XD4fEJnWatSq
   Jfb2aQxl9gcZMi1QAeuckBnHOXQVqmYtsBFeNQc6A2B3gd2Nrd3DS/JJe
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="326766408"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="326766408"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 05:49:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="652551036"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="652551036"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 17 Jan 2023 05:49:51 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
Subject: [PATCH 05/13] kvm/vfio: Provide struct kvm_device_ops::release() insted of ::destroy()
Date:   Tue, 17 Jan 2023 05:49:34 -0800
Message-Id: <20230117134942.101112-6-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117134942.101112-1-yi.l.liu@intel.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is to avoid a circular refcount problem between the kvm struct and
the device file. KVM modules holds device/group file reference when the
device/group is added and releases it per removal or the last kvm reference
is released. This reference model is ok for the group since there is no
kvm reference in the group paths.

But it is a problem for device file since the vfio devices may get kvm
reference in the device open path and put it in the device file release.
e.g. Intel kvmgt. This would result in a circular issue since the kvm
side won't put the device file reference if kvm reference is not 0, while
the vfio device side needs to put kvm reference in the release callback.

To solve this problem for device file, let vfio provide release() which
would be called once kvm file is closed, it won't depend on the last kvm
reference. Hence avoid circular refcount problem.

Suggested-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 virt/kvm/vfio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 0f54b9d308d7..525efe37ab6d 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -364,7 +364,7 @@ static int kvm_vfio_create(struct kvm_device *dev, u32 type);
 static struct kvm_device_ops kvm_vfio_ops = {
 	.name = "kvm-vfio",
 	.create = kvm_vfio_create,
-	.destroy = kvm_vfio_destroy,
+	.release = kvm_vfio_destroy,
 	.set_attr = kvm_vfio_set_attr,
 	.has_attr = kvm_vfio_has_attr,
 };
-- 
2.34.1

