Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66DDC6E93C1
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 14:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbjDTMKn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 08:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234497AbjDTMKl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 08:10:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E683A89
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 05:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681992594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6rnLKg3blOeRd/5UpvTNutjO0sWKe/Jf6iiNyydyiyk=;
        b=LGEF7Vv/ozGFccg2+nofvFzczh99lxXIQzS5nE+bm4jgcF32qKIsIgL3dF1wpY7n0pnbSH
        hUPyqfHHM2F0cXC764WoYwUT0f09AiuwNi5gTEsJE/9OgBoT5DwvLokWwozGxeOXxLlwKt
        aDcyiVyRxZM0EQnlCdK75388nrAyeyE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-66-KBVoZd6ZN9Sp0OHQfXF33g-1; Thu, 20 Apr 2023 08:09:51 -0400
X-MC-Unique: KBVoZd6ZN9Sp0OHQfXF33g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5052B3C1024D;
        Thu, 20 Apr 2023 12:09:51 +0000 (UTC)
Received: from localhost (unknown [10.39.193.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BB1E1121315;
        Thu, 20 Apr 2023 12:09:50 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Julia Suvorova <jusual@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>, qemu-block@nongnu.org,
        Cornelia Huck <cohuck@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
        virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>, Fam Zheng <fam@euphon.net>,
        Aarushi Mehta <mehta.aaru20@gmail.com>
Subject: [PULL 00/20] Block patches
Date:   Thu, 20 Apr 2023 08:09:28 -0400
Message-Id: <20230420120948.436661-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit c1eb2ddf0f8075faddc5f7c3d39feae3e8e9d6b4:

  Update version for v8.0.0 release (2023-04-19 17:27:13 +0100)

are available in the Git repository at:

  https://gitlab.com/stefanha/qemu.git tags/block-pull-request

for you to fetch changes up to 36e5e9b22abe56aa00ca067851555ad8127a7966:

  tracing: install trace events file only if necessary (2023-04-20 07:39:43 -0400)

----------------------------------------------------------------
Pull request

Sam Li's zoned storage work and fixes I collected during the 8.0 freeze.

----------------------------------------------------------------

Carlos Santos (1):
  tracing: install trace events file only if necessary

Philippe Mathieu-Daudé (1):
  block/dmg: Declare a type definition for DMG uncompress function

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

Thomas De Schampheleire (1):
  tracetool: use relative paths for '#line' preprocessor directives

 docs/devel/index-api.rst                     |   1 +
 docs/devel/zoned-storage.rst                 |  62 ++
 qapi/block-core.json                         |  68 +-
 qapi/block.json                              |   4 +
 meson.build                                  |   4 +
 block/dmg.h                                  |   8 +-
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
 block/block-backend.c                        | 193 ++++++
 block/dmg.c                                  |   7 +-
 block/file-posix.c                           | 677 +++++++++++++++++--
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
 scripts/tracetool/backend/ftrace.py          |   4 +-
 scripts/tracetool/backend/log.py             |   4 +-
 scripts/tracetool/backend/syslog.py          |   4 +-
 tests/qemu-iotests/tests/zoned               | 105 +++
 tests/qemu-iotests/tests/zoned.out           |  69 ++
 trace/meson.build                            |   2 +-
 46 files changed, 2353 insertions(+), 81 deletions(-)
 create mode 100644 docs/devel/zoned-storage.rst
 create mode 100755 tests/qemu-iotests/tests/zoned
 create mode 100644 tests/qemu-iotests/tests/zoned.out

-- 
2.39.2

