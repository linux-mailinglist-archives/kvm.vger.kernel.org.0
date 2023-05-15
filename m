Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F091870322D
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 18:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242491AbjEOQGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 12:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242509AbjEOQGl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 12:06:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9151706
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 09:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684166712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=lcQUWH2Bg0LeZN3EAXHkDBBz74AC6jKu2ky3WAA/zwY=;
        b=NrytPKqm/UWDhmnex+2ny925nxStafwRQQ0bWbBDn2X6U7l6hisKmNrfsoMz0z0vZojdtd
        5NPcLvUDyYwwL9hYFXCr5aTAreuU15WIfPWDUB9hQ5BMkci2QptxP6EH4ADO39pZX0mkmo
        tSyM++cEAF9ElC1hym6bAumeq8yBTSE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-ROeSGZqQOD-a-c7Wpgk-Nw-1; Mon, 15 May 2023 12:05:09 -0400
X-MC-Unique: ROeSGZqQOD-a-c7Wpgk-Nw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80A381C00046;
        Mon, 15 May 2023 16:05:08 +0000 (UTC)
Received: from localhost (unknown [10.39.192.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DEAB920268C4;
        Mon, 15 May 2023 16:05:07 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Julia Suvorova <jusual@redhat.com>,
        Aarushi Mehta <mehta.aaru20@gmail.com>,
        Kevin Wolf <kwolf@redhat.com>, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Hanna Reitz <hreitz@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Fam Zheng <fam@euphon.net>
Subject: [PULL v2 00/16] Block patches
Date:   Mon, 15 May 2023 12:04:50 -0400
Message-Id: <20230515160506.1776883-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 8844bb8d896595ee1d25d21c770e6e6f29803097:

  Merge tag 'or1k-pull-request-20230513' of https://github.com/stffrdhrn/qemu into staging (2023-05-13 11:23:14 +0100)

are available in the Git repository at:

  https://gitlab.com/stefanha/qemu.git tags/block-pull-request

for you to fetch changes up to 01562fee5f3ad4506d57dbcf4b1903b565eceec7:

  docs/zoned-storage:add zoned emulation use case (2023-05-15 08:19:04 -0400)

----------------------------------------------------------------
Pull request

This pull request contain's Sam Li's zoned storage support in the QEMU block
layer and virtio-blk emulation.

v2:
- Sam fixed the CI failures. CI passes for me now. [Richard]

----------------------------------------------------------------

Sam Li (16):
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
  virtio-blk: add zoned storage emulation for zoned devices
  block: add accounting for zone append operation
  virtio-blk: add some trace events for zoned emulation
  docs/zoned-storage:add zoned emulation use case

 docs/devel/index-api.rst               |   1 +
 docs/devel/zoned-storage.rst           |  62 +++
 qapi/block-core.json                   |  68 ++-
 qapi/block.json                        |   4 +
 meson.build                            |   5 +
 include/block/accounting.h             |   1 +
 include/block/block-common.h           |  57 ++
 include/block/block-io.h               |  13 +
 include/block/block_int-common.h       |  37 ++
 include/block/raw-aio.h                |   8 +-
 include/sysemu/block-backend-io.h      |  27 +
 block.c                                |  19 +
 block/block-backend.c                  | 198 +++++++
 block/file-posix.c                     | 692 +++++++++++++++++++++++--
 block/io.c                             |  68 +++
 block/io_uring.c                       |   4 +
 block/linux-aio.c                      |   3 +
 block/qapi-sysemu.c                    |  11 +
 block/qapi.c                           |  18 +
 block/raw-format.c                     |  26 +
 hw/block/virtio-blk-common.c           |   2 +
 hw/block/virtio-blk.c                  | 405 +++++++++++++++
 hw/virtio/virtio-qmp.c                 |   2 +
 qemu-io-cmds.c                         | 224 ++++++++
 block/trace-events                     |   4 +
 docs/system/qemu-block-drivers.rst.inc |   6 +
 hw/block/trace-events                  |   7 +
 tests/qemu-iotests/227.out             |  18 +
 tests/qemu-iotests/tests/zoned         | 105 ++++
 tests/qemu-iotests/tests/zoned.out     |  69 +++
 30 files changed, 2106 insertions(+), 58 deletions(-)
 create mode 100644 docs/devel/zoned-storage.rst
 create mode 100755 tests/qemu-iotests/tests/zoned
 create mode 100644 tests/qemu-iotests/tests/zoned.out

-- 
2.40.1

