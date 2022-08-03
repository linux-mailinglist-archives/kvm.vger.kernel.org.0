Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AECE58925B
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 20:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238292AbiHCSoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 14:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236531AbiHCSo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 14:44:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 730845A2F8
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 11:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659552267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=U8EUYy/P7OgZO9+1Wcw1rrhb6TEqaeAZQCtBBJon6dM=;
        b=V9+YXLDaT6tTTA+mucKxVrpZo4pRk2Rx38wHfVXLV1zsLcgikjm7nd9fGHZ/ygrkBW/nTV
        uK9a8CWuuNOb6eow9iB/7+u4dT4XsJazPy0Ka/YzEvXJGN3VKqbp99I+tiAHcMhtGdSm6g
        QbDj0JuLXIm7fV5ZT62OEn/9UBq66Os=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-E1M2-ECeOxG_Pq7SQw3p6Q-1; Wed, 03 Aug 2022 14:44:26 -0400
X-MC-Unique: E1M2-ECeOxG_Pq7SQw3p6Q-1
Received: by mail-io1-f72.google.com with SMTP id m9-20020a6b7b49000000b0067c0331524cso7328818iop.21
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 11:44:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:organization
         :mime-version:content-transfer-encoding;
        bh=U8EUYy/P7OgZO9+1Wcw1rrhb6TEqaeAZQCtBBJon6dM=;
        b=d+3gkALwIo7xFhUHz5oxaUeuZZePdpu8AU46OCN/PwgDv0pHRRg4Xjo/6ZC3HLBM9S
         1cPgrN4dSJXsAML4oPZWAGaXBay819GY9RfZJpjwBlt2v1OOtq1tv8I36nHH6uIjN+hp
         JDQ3SxvhEFoliaoVWkIkVsZ1AiF8McHNpQqmvCDyNJHCZGpNEXMJh/YPemPncoeGsk1p
         KTait5ICXMhofTtW61YMjwZ2zuRwC1O+RqK8HHmAM6AFcuROlfR/L2i0txKFreQa5lDy
         8gIuq/FVidAkLy3VwToBTjasWyBvfgqyKCUQnPOB+WVJOo1PxUm0Kk79QC9t63wLbju/
         2uow==
X-Gm-Message-State: AJIora8c12Dfse0eQVx8DjSXPHhDd/olCttWRjD9ybAMEWJDgoJQvJa7
        hLLM0H0HAwWAxysqGHWs4dPd1Tleo56VXDK1LHwqFn0OGxqazIBPrj4eBjjZp1v+Xy/VpQGMZ2z
        kiZDvMd7gmu7Y
X-Received: by 2002:a05:6638:260a:b0:341:4bda:9c2c with SMTP id m10-20020a056638260a00b003414bda9c2cmr10861544jat.160.1659552265241;
        Wed, 03 Aug 2022 11:44:25 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sy54fTq0AJMywwqMhnddcU6b0xzHffbawr6hR2leJVeWdV3i4j496emvaJ/VQOYfBD+9OWSw==
X-Received: by 2002:a05:6638:260a:b0:341:4bda:9c2c with SMTP id m10-20020a056638260a00b003414bda9c2cmr10861537jat.160.1659552264932;
        Wed, 03 Aug 2022 11:44:24 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id o24-20020a02c6b8000000b003428c21ed12sm1355087jan.167.2022.08.03.11.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 11:44:24 -0700 (PDT)
Date:   Wed, 3 Aug 2022 12:44:23 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v6.0-rc1
Message-ID: <20220803124423.7ad06882.alex.williamson@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

There's a minor merge conflict between commit:

  afe4e376ac5d ("vfio: Move IOMMU_CAP_CACHE_COHERENCY test to after we know we have a group")

added in v5.19-rc7 and commit:

  3b498b665621 ("vfio: Use device_iommu_capable()")

as noted[1] by Stephen Rothwell, with a resolution provided in his next build.

There are also addition potential conflicts with kvm390[2] and s390[3]
trees, but I don't currently see pull requests on list for those yet.
Thanks!

Alex

[1] https://lore.kernel.org/all/20220706144652.1b254c76@canb.auug.org.au/
[2] https://lore.kernel.org/all/20220711171353.2b8eb09a@canb.auug.org.au/
[3] https://lore.kernel.org/all/20220725163356.4f2b507e@canb.auug.org.au/

The following changes since commit 03c765b0e3b4cb5063276b086c76f7a612856a9a:

  Linux 5.19-rc4 (2022-06-26 14:22:10 -0700)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.0-rc1

for you to fetch changes up to 099fd2c2020751737d9288f923d562e0e05977eb:

  vfio/pci: fix the wrong word (2022-08-01 13:37:42 -0600)

----------------------------------------------------------------
VFIO updates for v6.0-rc1

 - Cleanup use of extern in function prototypes (Alex Williamson)

 - Simplify bus_type usage and convert to device IOMMU interfaces
   (Robin Murphy)

 - Check missed return value and fix comment typos (Bo Liu)

 - Split migration ops from device ops and fix races in mlx5 migration
   support (Yishai Hadas)

 - Fix missed return value check in noiommu support (Liam Ni)

 - Hardening to clear buffer pointer to avoid use-after-free (Schspa Shi)

 - Remove requirement that only the same mm can unmap a previously
   mapped range (Li Zhe)

 - Adjust semaphore release vs device open counter (Yi Liu)

 - Remove unused arg from SPAPR support code (Deming Wang)

 - Rework vfio-ccw driver to better fit new mdev framework (Eric Farman,
   Michael Kawano)

 - Replace DMA unmap notifier with callbacks (Jason Gunthorpe)

 - Clarify SPAPR support comment relative to iommu_ops (Alexey Kardashevskiy)

 - Revise page pinning API towards compatibility with future iommufd support
   (Nicolin Chen)

 - Resolve issues in vfio-ccw, including use of DMA unmap callback
   (Eric Farman)

----------------------------------------------------------------
Alex Williamson (3):
      vfio: de-extern-ify function prototypes
      Merge branches 'v5.20/vfio/migration-enhancements-v3', 'v5.20/vfio/simplify-bus_type-determination-v3', 'v5.20/vfio/check-vfio_register_iommu_driver-return-v2', 'v5.20/vfio/check-iommu_group_set_name_return-v1', 'v5.20/vfio/clear-caps-buf-v3', 'v5.20/vfio/remove-useless-judgement-v1' and 'v5.20/vfio/move-device_open-count-v2' into v5.20/vfio/next
      Merge branches 'v5.20/vfio/spapr_tce-unused-arg-v1', 'v5.20/vfio/comment-typo-v1' and 'v5.20/vfio/vfio-ccw-rework-v4' into v5.20/vfio/next

Alexey Kardashevskiy (1):
      vfio/spapr_tce: Fix the comment

Bo Liu (3):
      vfio: check vfio_register_iommu_driver() return value
      vfio/pci: fix the wrong word
      vfio/pci: fix the wrong word

Deming Wang (1):
      vfio/spapr_tce: Remove the unused parameters container

Eric Farman (13):
      vfio/ccw: Fix FSM state if mdev probe fails
      vfio/ccw: Do not change FSM state in subchannel event
      vfio/ccw: Remove private->mdev
      vfio/ccw: Pass enum to FSM event jumptable
      vfio/ccw: Flatten MDEV device (un)register
      vfio/ccw: Update trace data for not operational event
      vfio/ccw: Create an OPEN FSM Event
      vfio/ccw: Create a CLOSE FSM event
      vfio/ccw: Refactor vfio_ccw_mdev_reset
      vfio/ccw: Move FSM open/close to MDEV open/close
      vfio/ccw: Add length to DMA_UNMAP checks
      vfio/ccw: Remove FSM Close from remove handlers
      vfio/ccw: Check return code from subchannel quiesce

Jason Gunthorpe (2):
      vfio: Replace the DMA unmapping notifier with a callback
      vfio: Replace the iommu notifier with a device list

Li Zhe (1):
      vfio: remove useless judgement

Liam Ni (1):
      vfio: check iommu_group_set_name() return value

Michael Kawano (1):
      vfio/ccw: Remove UUID from s390 debug log

Nicolin Chen (10):
      vfio: Make vfio_unpin_pages() return void
      drm/i915/gvt: Replace roundup with DIV_ROUND_UP
      vfio/ap: Pass in physical address of ind to ap_aqic()
      vfio/ccw: Only pass in contiguous pages
      vfio: Pass in starting IOVA to vfio_pin/unpin_pages API
      vfio/ap: Change saved_pfn to saved_iova
      vfio/ccw: Change pa_pfn list to pa_iova list
      vfio: Rename user_iova of vfio_dma_rw()
      vfio/ccw: Add kmap_local_page() for memcpy
      vfio: Replace phys_pfn with pages for vfio_pin_pages()

Robin Murphy (2):
      vfio/type1: Simplify bus_type determination
      vfio: Use device_iommu_capable()

Schspa Shi (1):
      vfio: Clear the caps->buf to NULL after free

Yi Liu (1):
      vfio: Move "device->open_count--" out of group_rwsem in vfio_device_open()

Yishai Hadas (2):
      vfio/mlx5: Protect mlx5vf_disable_fds() upon close device
      vfio: Split migration ops from main device ops

 Documentation/driver-api/vfio-mediated-device.rst |  16 +-
 arch/s390/include/asm/ap.h                        |   6 +-
 drivers/gpu/drm/i915/gvt/gvt.h                    |   1 -
 drivers/gpu/drm/i915/gvt/kvmgt.c                  | 120 ++++---------
 drivers/s390/cio/vfio_ccw_async.c                 |   1 -
 drivers/s390/cio/vfio_ccw_cp.c                    | 205 +++++++++++++---------
 drivers/s390/cio/vfio_ccw_cp.h                    |  12 +-
 drivers/s390/cio/vfio_ccw_drv.c                   |  58 ++----
 drivers/s390/cio/vfio_ccw_fsm.c                   |  99 +++++++++--
 drivers/s390/cio/vfio_ccw_ops.c                   | 114 +++---------
 drivers/s390/cio/vfio_ccw_private.h               |  13 +-
 drivers/s390/crypto/ap_queue.c                    |   2 +-
 drivers/s390/crypto/vfio_ap_ops.c                 | 103 +++--------
 drivers/s390/crypto/vfio_ap_private.h             |   7 +-
 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h         |   2 +-
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  11 +-
 drivers/vfio/pci/mlx5/cmd.c                       |  14 +-
 drivers/vfio/pci/mlx5/cmd.h                       |   4 +-
 drivers/vfio/pci/mlx5/main.c                      |  11 +-
 drivers/vfio/pci/vfio_pci_config.c                |   4 +-
 drivers/vfio/pci/vfio_pci_core.c                  |   7 +
 drivers/vfio/platform/vfio_platform_private.h     |  21 ++-
 drivers/vfio/vfio.c                               | 192 +++++++-------------
 drivers/vfio/vfio.h                               |  17 +-
 drivers/vfio/vfio_iommu_spapr_tce.c               |  14 +-
 drivers/vfio/vfio_iommu_type1.c                   | 197 ++++++++++++---------
 include/linux/mdev.h                              |   5 -
 include/linux/vfio.h                              | 106 ++++++-----
 include/linux/vfio_pci_core.h                     |  65 ++++---
 29 files changed, 659 insertions(+), 768 deletions(-)

