Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7466856803D
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 09:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbiGFHmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 03:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbiGFHmb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 03:42:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D2922BDB;
        Wed,  6 Jul 2022 00:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=APwZI5zTI8OXDrpdbBQJyT9zkz9cR40LuR3/lE1oLHM=; b=rqqJPPc+Haae4D6pFHZcRSJJZu
        r050atjv/vrNAghE8rlCybAbNZQsMSbbKR0nEg3XS3xryUT37UlwJcxzEhwE0mTQVa75R2tb2/dE/
        t510uNYaWoer+Cht6IIY0M1Avi1x321cNVibsLpmFFNR5wdhY9AIYrKfPfUOXv6Wb3F+/bsKarqLr
        7eXAZsbT1hnrWvAw1rZROg2lUrAOMz37LTOSCybkY3/40GcOz/rwsYKT1dYUZ8xjUltcApHT/3Xae
        PUugLwsCTclviTl9hY1BK98VclyRl2yWkCWmOxm/5LQg5N0+pPhsK+7K5Ien5+Bh5noitZ1k+T40e
        l84aILoA==;
Received: from [2001:4bb8:189:3c4a:34cd:2d1d:8766:aad] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8zfx-0079iQ-9L; Wed, 06 Jul 2022 07:42:21 +0000
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
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org
Subject: simplify the mdev interface v5
Date:   Wed,  6 Jul 2022 09:42:04 +0200
Message-Id: <20220706074219.3614-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
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

Hi all,

this series signigicantly simplies the mdev driver interface by following
the patterns for device model interaction used elsewhere in the kernel.

Changes since v4:
 - move the kobject_put later in mdev_device_release 
 - add a Fixes tag for the first patch
 - add another patch to remove an extra kobject_get/put

Changes since v3:
 - make the sysfs_name and pretty_name fields pointers instead of arrays
 - add an i915 cleanup to prepare for the above

Changes since v2:
 - rebased to vfio/next
 - fix a pre-existing memory leak in i915 instead of making it worse
 - never manipulate if ->available_instances if drv->get_available is
   provided
 - keep a parent reference for the mdev_type
 - keep a few of the sysfs.c helper function around
 - improve the documentation for the parent device lifetime
 - minor spellig / formatting fixes

Changes since v1:
 - embedd the mdev_parent into a different sub-structure in i916
 - remove headers now inclued by mdev.h from individual source files
 - pass an array of mdev_types to mdev_register_parent
 - add additional patches to implement all attributes on the
   mdev_type in the core code

Diffstat:
 Documentation/driver-api/vfio-mediated-device.rst |   26 +-
 Documentation/s390/vfio-ap.rst                    |    2 
 Documentation/s390/vfio-ccw.rst                   |    2 
 drivers/gpu/drm/i915/gvt/aperture_gm.c            |   20 +-
 drivers/gpu/drm/i915/gvt/gvt.h                    |   42 ++--
 drivers/gpu/drm/i915/gvt/kvmgt.c                  |  168 ++++-------------
 drivers/gpu/drm/i915/gvt/vgpu.c                   |  210 +++++++---------------
 drivers/s390/cio/cio.h                            |    4 
 drivers/s390/cio/vfio_ccw_drv.c                   |    3 
 drivers/s390/cio/vfio_ccw_ops.c                   |   60 ------
 drivers/s390/cio/vfio_ccw_private.h               |    2 
 drivers/s390/crypto/vfio_ap_ops.c                 |   68 +------
 drivers/s390/crypto/vfio_ap_private.h             |    6 
 drivers/vfio/mdev/mdev_core.c                     |  191 ++++----------------
 drivers/vfio/mdev/mdev_driver.c                   |    7 
 drivers/vfio/mdev/mdev_private.h                  |   32 ---
 drivers/vfio/mdev/mdev_sysfs.c                    |  189 ++++++++++---------
 include/linux/mdev.h                              |   77 ++++----
 samples/vfio-mdev/mbochs.c                        |  103 +++-------
 samples/vfio-mdev/mdpy.c                          |  115 +++---------
 samples/vfio-mdev/mtty.c                          |   94 +++------
 21 files changed, 459 insertions(+), 962 deletions(-)
