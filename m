Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F204F5655E3
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 14:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbiGDMv6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 08:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbiGDMv5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 08:51:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5ED1054D;
        Mon,  4 Jul 2022 05:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=mQaCY3+Mowg2tD0+KKloxT+uQZbU8L2SJHLKrJJOWT4=; b=ObYVjvUtNKGv3K16cc1tk+NwbB
        L2dPyo3RXPGZczkyv458MCfPNX9P1v5RIQxdTOKsW4/fnVMyYQF2/uA3vgAW+ymNqx8s9tL1kMiRd
        EevJp9VeOrlSztCmbUcwCtfw/nmR7vhOypzzklONFvpUgDYnfApM/kE/9ivx1b7NhqtaU4nTXTxwy
        eun8DAZJd0NztlViFrZNUix4XmYM/cPSjEHfqFanVNXU2BNVSBPHiGlCO+5omAMpgw/B6rKL/PsjN
        f14wCVw8vBK8n0hMetokZCqqIpsJhNo0qVKaTJvWbmk31cUex3q1fOlPrsa2gMlbg0Mxn5DCwfMUq
        uIEK2tqQ==;
Received: from [2001:4bb8:189:3c4a:8758:74d9:4df6:6417] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8LYI-008wAp-CW; Mon, 04 Jul 2022 12:51:46 +0000
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
Subject: simplify the mdev interface v4
Date:   Mon,  4 Jul 2022 14:51:30 +0200
Message-Id: <20220704125144.157288-1-hch@lst.de>
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
 drivers/vfio/mdev/mdev_core.c                     |  185 ++++---------------
 drivers/vfio/mdev/mdev_driver.c                   |    7 
 drivers/vfio/mdev/mdev_private.h                  |   32 ---
 drivers/vfio/mdev/mdev_sysfs.c                    |  186 ++++++++++---------
 include/linux/mdev.h                              |   77 ++++----
 samples/vfio-mdev/mbochs.c                        |  103 +++-------
 samples/vfio-mdev/mdpy.c                          |  115 +++---------
 samples/vfio-mdev/mtty.c                          |   94 +++------
 21 files changed, 458 insertions(+), 954 deletions(-)
