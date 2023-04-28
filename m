Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D9D6F182A
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 14:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346055AbjD1Mk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 08:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346049AbjD1Mku (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 08:40:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DD0180
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 05:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682685600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ng8eWAIIyXfXdpxMmqBynomNwGn34TJbzesREd0EyJ0=;
        b=AVN/7ml6nda/ijI5cC+lHYeWpzLLSj9+FWEarckeGB7DnqlGxlCmvsCYsGKKYUL/7vuiJd
        VIgt0ntZhk6z0FpIW0szsqwhdaEAvg2MVmArsCl87rDlX8v3W008kYcrmA8toGgm38Rjes
        lD5lPgno46mHn0iD8Eod+Hkv8/zHBO8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-BPI9S3GhNoCGKkrBkGwlYw-1; Fri, 28 Apr 2023 08:39:57 -0400
X-MC-Unique: BPI9S3GhNoCGKkrBkGwlYw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E176D280A32C;
        Fri, 28 Apr 2023 12:39:56 +0000 (UTC)
Received: from localhost (unknown [10.39.192.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D6BC400F4D;
        Fri, 28 Apr 2023 12:39:55 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Julia Suvorova <jusual@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aarushi Mehta <mehta.aaru20@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Kevin Wolf <kwolf@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        qemu-block@nongnu.org, Hanna Reitz <hreitz@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PULL 00/17] Block patches
Date:   Fri, 28 Apr 2023 08:39:37 -0400
Message-Id: <20230428123954.179035-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 05d50ba2d4668d43a835c5a502efdec9b92646e6:

  Merge tag 'migration-20230427-pull-request' of https://gitlab.com/juan.quintela/qemu into staging (2023-04-28 08:35:06 +0100)

are available in the Git repository at:

  https://gitlab.com/stefanha/qemu.git tags/block-pull-request

for you to fetch changes up to d3c760be786571d83d5cea01953e543df4d76f51:

  docs/zoned-storage:add zoned emulation use case (2023-04-28 08:34:07 -0400)

----------------------------------------------------------------
Pull request

This pull request contains Sam Li's virtio-blk zoned storage work. These
patches were dropped from my previous block pull request due to CI failures.

----------------------------------------------------------------

Sam Li (17):
  block/block-common: add zoned device structs
  block/file-posix: introduce helper functions for sysfs attributes
  block/block-backend: add block layer APIs resembling Linux
    ZonedBlockDevice ioctls
  block/raw-format: add zone operations to pass through requests
  block: add zoned BlockDriver check to block layer
  iotests: test new zone operations
  block: add some trace events for new block layer APIs
  docs/zoned-storage: add zoned device documentation
  file-posix: add tracking of the zone write pointers
  block: introduce zone append write for zoned devices
  qemu-iotests: test zone append operation
  block: add some trace events for zone append
  include: update virtio_blk headers to v6.3-rc1
  virtio-blk: add zoned storage emulation for zoned devices
  block: add accounting for zone append operation
  virtio-blk: add some trace events for zoned emulation
  docs/zoned-storage:add zoned emulation use case

 docs/devel/index-api.rst                     |   1 +
 docs/devel/zoned-storage.rst                 |  62 ++
 qapi/block-core.json                         |  68 +-
 qapi/block.json                              |   4 +
 meson.build                                  |   4 +
 include/block/accounting.h                   |   1 +
 include/block/block-common.h                 |  57 ++
 include/block/block-io.h                     |  13 +
 include/block/block_int-common.h             |  37 +
 include/block/raw-aio.h                      |   8 +-
 include/standard-headers/drm/drm_fourcc.h    |  12 +
 include/standard-headers/linux/ethtool.h     |  48 +-
 include/standard-headers/linux/fuse.h        |  45 +-
 include/standard-headers/linux/pci_regs.h    |   1 +
 include/standard-headers/linux/vhost_types.h |   2 +
 include/standard-headers/linux/virtio_blk.h  | 105 +++
 include/sysemu/block-backend-io.h            |  27 +
 linux-headers/asm-arm64/kvm.h                |   1 +
 linux-headers/asm-x86/kvm.h                  |  34 +-
 linux-headers/linux/kvm.h                    |   9 +
 linux-headers/linux/vfio.h                   |  15 +-
 linux-headers/linux/vhost.h                  |   8 +
 block.c                                      |  19 +
 block/block-backend.c                        | 198 ++++++
 block/file-posix.c                           | 696 +++++++++++++++++--
 block/io.c                                   |  68 ++
 block/io_uring.c                             |   4 +
 block/linux-aio.c                            |   3 +
 block/qapi-sysemu.c                          |  11 +
 block/qapi.c                                 |  18 +
 block/raw-format.c                           |  26 +
 hw/block/virtio-blk-common.c                 |   2 +
 hw/block/virtio-blk.c                        | 405 +++++++++++
 hw/virtio/virtio-qmp.c                       |   2 +
 qemu-io-cmds.c                               | 224 ++++++
 block/trace-events                           |   4 +
 docs/system/qemu-block-drivers.rst.inc       |   6 +
 hw/block/trace-events                        |   7 +
 tests/qemu-iotests/tests/zoned               | 105 +++
 tests/qemu-iotests/tests/zoned.out           |  69 ++
 40 files changed, 2361 insertions(+), 68 deletions(-)
 create mode 100644 docs/devel/zoned-storage.rst
 create mode 100755 tests/qemu-iotests/tests/zoned
 create mode 100644 tests/qemu-iotests/tests/zoned.out

-- 
2.40.0

