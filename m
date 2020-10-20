Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C167428844F
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 10:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732681AbgJIIAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 04:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732644AbgJIH7x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 03:59:53 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C262C0613D6
        for <kvm@vger.kernel.org>; Fri,  9 Oct 2020 00:59:53 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id j136so8892645wmj.2
        for <kvm@vger.kernel.org>; Fri, 09 Oct 2020 00:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=immTPDdSm8V7ezbOteojXYm/j7WkY1f3P9Y0YpK7onQ=;
        b=DEazGm3//HS7eifrtPTNpv9gPNwxpuxjM7cgzXbcLG0mO5e39cJ73eX9iQKQEkxr4Y
         FwEAxZ/eknqujf87zOGqp6tESSOeL2I6VSIobgrZsNnXiWlr9VWW7WhVnV0GrVhO4vMj
         1v4YtSGCDuC7IGf+ELUEOwyj9sMdI3c9bq3Xg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=immTPDdSm8V7ezbOteojXYm/j7WkY1f3P9Y0YpK7onQ=;
        b=G1+KsQSFRyzXgrsPUwP7Vv48pN0hgb5Nr7yYQMoD8JSu+JqRXoRqAU9e3EahUzNHLe
         PdoR2mJU980NSDZVqFgfV97v9HDeW1/F6rf+getqtQpDD8sBRgLJRHMyYkSWy6AmONf/
         YR5IrTff9g0FYAtRCfV8xqnHODzcLI/7Z/akDsYtUrodDVd/gwBdagb9G4lJEsTq4QKU
         eLBEXhpH0DhdHR1gbGKkavLMKkGZ1aZY2Alw4a2xAe5qtxiOxE1Wk1kW5Uv5rG/rEKJr
         eL5VlA98qgrFclx5i4Po+qYDQE158dvks+4GjViHTmwZ0tJ+eL7kF23KyLW/FjM2W85B
         Dvbg==
X-Gm-Message-State: AOAM5323IuOSkgAX4FcgTIt7QRJ64GG7Cvr2CmCv65NKhRNnjHvlLTmV
        Jq0SifDk2iL1z/YKC2SqhWITJw==
X-Google-Smtp-Source: ABdhPJzyDJpFjA/Q+sv1RhX5gsGPQpkP/4WlxxT8RLqjQWQaBWIid1inU3iHz1dJQWF+W7VpBZ1zIA==
X-Received: by 2002:a1c:f311:: with SMTP id q17mr13703008wmq.168.1602230391713;
        Fri, 09 Oct 2020 00:59:51 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id u17sm11634118wri.45.2020.10.09.00.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 00:59:50 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH v2 00/17] follow_pfn and other iomap races
Date:   Fri,  9 Oct 2020 09:59:17 +0200
Message-Id: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

Round two of my patch series to clamp down a bunch of races and gaps
around follow_pfn and other access to iomem mmaps. Previous version:

v1: https://lore.kernel.org/dri-devel/20201007164426.1812530-1-daniel.vetter@ffwll.ch/

And the discussion that sparked this journey:

https://lore.kernel.org/dri-devel/20201007164426.1812530-1-daniel.vetter@ffwll.ch/

Changes in v2:
- tons of small polish&fixes all over, thanks to all the reviewers who
  spotted issues
- I managed to test at least the generic_access_phys and pci mmap revoke
  stuff with a few gdb sessions using our i915 debug tools (hence now also
  the drm/i915 patch to properly request all the pci bar regions)
- reworked approach for the pci mmap revoke: Infrastructure moved into
  kernel/resource.c, address_space mapping is now set up at open time for
  everyone (which required some sysfs changes). Does indeed look a lot
  cleaner and a lot less invasive than I feared at first.

The big thing I can't test are all the frame_vector changes in habanalbas,
exynos and media. Gerald has given the s390 patch a spin already.

Review, testing, feedback all very much welcome.

Cheers, Daniel

Daniel Vetter (17):
  drm/exynos: Stop using frame_vector helpers
  drm/exynos: Use FOLL_LONGTERM for g2d cmdlists
  misc/habana: Stop using frame_vector helpers
  misc/habana: Use FOLL_LONGTERM for userptr
  mm/frame-vector: Use FOLL_LONGTERM
  media: videobuf2: Move frame_vector into media subsystem
  mm: Close race in generic_access_phys
  s390/pci: Remove races against pte updates
  mm: Add unsafe_follow_pfn
  media/videbuf1|2: Mark follow_pfn usage as unsafe
  vfio/type1: Mark follow_pfn as unsafe
  PCI: Obey iomem restrictions for procfs mmap
  /dev/mem: Only set filp->f_mapping
  resource: Move devmem revoke code to resource framework
  sysfs: Support zapping of binary attr mmaps
  PCI: Revoke mappings like devmem
  drm/i915: Properly request PCI BARs

 arch/s390/pci/pci_mmio.c                      | 98 +++++++++++--------
 drivers/char/mem.c                            | 86 +---------------
 drivers/gpu/drm/exynos/Kconfig                |  1 -
 drivers/gpu/drm/exynos/exynos_drm_g2d.c       | 48 ++++-----
 drivers/gpu/drm/i915/intel_uncore.c           | 25 ++++-
 drivers/media/common/videobuf2/Kconfig        |  1 -
 drivers/media/common/videobuf2/Makefile       |  1 +
 .../media/common/videobuf2}/frame_vector.c    | 54 ++++------
 drivers/media/platform/omap/Kconfig           |  1 -
 drivers/media/v4l2-core/videobuf-dma-contig.c |  2 +-
 drivers/misc/habanalabs/Kconfig               |  1 -
 drivers/misc/habanalabs/common/habanalabs.h   |  3 +-
 drivers/misc/habanalabs/common/memory.c       | 50 ++++------
 drivers/pci/pci-sysfs.c                       |  4 +
 drivers/pci/proc.c                            |  6 ++
 drivers/vfio/vfio_iommu_type1.c               |  4 +-
 fs/sysfs/file.c                               | 11 +++
 include/linux/ioport.h                        |  6 +-
 include/linux/mm.h                            | 47 +--------
 include/linux/sysfs.h                         |  2 +
 include/media/videobuf2-core.h                | 42 ++++++++
 kernel/resource.c                             | 95 +++++++++++++++++-
 mm/Kconfig                                    |  3 -
 mm/Makefile                                   |  1 -
 mm/memory.c                                   | 76 +++++++++++++-
 mm/nommu.c                                    | 17 ++++
 security/Kconfig                              | 13 +++
 27 files changed, 412 insertions(+), 286 deletions(-)
 rename {mm => drivers/media/common/videobuf2}/frame_vector.c (85%)

-- 
2.28.0

