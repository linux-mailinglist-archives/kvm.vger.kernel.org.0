Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E1954A858
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 06:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239184AbiFNEyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 00:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiFNEyp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 00:54:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA15B37BD6;
        Mon, 13 Jun 2022 21:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=CPcuQGJ8u4Jy0B6sriKitXk9Z5PFXAtCX9f68K5wl1A=; b=mUfbeiR89N4DsxNp6xXOH41i6Y
        JmtqblFYQ4hQGF0fmFwHUye5cQJeGWzSt6b16HZEhcjTN4z901V6X4j0zUdTyxqe4fHe1Z3+Zk/tl
        E54UlgsHkEsAnlXtiHdxA8PfqYDM352o5h239lCiulcNUHeh8taU4z+nhIqROXdaXMxbJN5Xhysvp
        JylXTOMt78ZlKNirLVWZLj10TSzdPgbe7rBrhEpCGYbyjOj5fa2DJn9FEr0bu+MPUZerflgvD1FYM
        yfN1Ul2LmLSK7zpPfpyCLr9H4JFJqAN/TxrPiWcA4URVnHMkhckT9gwPe7BlphpA8BfL3nqfKjmyJ
        Wtkrw3Sw==;
Received: from [2001:4bb8:180:36f6:1fed:6d48:cf16:d13c] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o0yZS-0072dn-Ep; Tue, 14 Jun 2022 04:54:30 +0000
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
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org
Subject: simplify the mdev interface v2
Date:   Tue, 14 Jun 2022 06:54:15 +0200
Message-Id: <20220614045428.278494-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

this series signigicantly simplies the mdev driver interface by following
the patterns for device model interaction used elsewhere in the kernel.

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
 drivers/gpu/drm/i915/gvt/gvt.h                    |    6 
 drivers/gpu/drm/i915/gvt/kvmgt.c                  |  158 +++------------
 drivers/gpu/drm/i915/gvt/vgpu.c                   |   60 +----
 drivers/s390/cio/cio.h                            |    4 
 drivers/s390/cio/vfio_ccw_drv.c                   |    3 
 drivers/s390/cio/vfio_ccw_ops.c                   |   60 -----
 drivers/s390/cio/vfio_ccw_private.h               |    2 
 drivers/s390/crypto/vfio_ap_ops.c                 |   68 ------
 drivers/s390/crypto/vfio_ap_private.h             |    6 
 drivers/vfio/mdev/mdev_core.c                     |  214 ++++++--------------
 drivers/vfio/mdev/mdev_driver.c                   |    7 
 drivers/vfio/mdev/mdev_private.h                  |   39 ---
 drivers/vfio/mdev/mdev_sysfs.c                    |  230 ++++++++--------------
 include/linux/mdev.h                              |   77 +++----
 samples/vfio-mdev/mbochs.c                        |  103 ++-------
 samples/vfio-mdev/mdpy.c                          |  115 ++---------
 samples/vfio-mdev/mtty.c                          |   94 +++-----
 20 files changed, 389 insertions(+), 887 deletions(-)
