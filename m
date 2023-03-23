Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931AB6C5EC6
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 06:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjCWF3o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 01:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjCWF3n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 01:29:43 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8CD1E1E0
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 22:29:41 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id le6so21288302plb.12
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 22:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679549381;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dClqQIcuf7R3eW9pGWVcMwJ53uA3LgBf03DG2n4TMgk=;
        b=OvvMifh3GPgoXCwK0t9PVEra8hGxbOrnymGpGWknTvFfQAoWfVg9xHEOLoQT1+bkoe
         c7gsSV+KAnwsDhu0nfn8CbXaqhUds9P8atmHcgoEqVcRDVB8Wsqbu/3FcFIqRVf/LRo5
         eN4N7MJ0iHz2Q3Pj9F2RlfN5cksbRQZzeFlWUaLvGe0kyab4bkDScwXZe3/ppK+Pf58I
         2MCsvj51Ltc/ygX7b/Fya7yGiE40FJ6I8GqABck9Ib5JRPmX/zixQ1YmbYrrXjtv8zrM
         0enjnD3SZwTpodkBtlYtNRXqS0YC1Se1ZV/FxNlCphCgzigPCMHeDfs4LNvyPU40Zdgb
         a8Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679549381;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dClqQIcuf7R3eW9pGWVcMwJ53uA3LgBf03DG2n4TMgk=;
        b=5EI7IhkYamWnwr2lU4XfERRmX5jUEzf1eMk2DftVuOSdfsehWQMMSfLkk6TfIM0ohn
         uynsQfZx/bF8Pcyduh/0MhifwPMx80hGA0mJcDUUXpUJfROmkjkB7OMw/4DpDhov2WnO
         CTvdmwBQpolkK5EV0vZclzgLbXG7OSG1sCe5vxlNrqpcPJmYeuuRiNotzYeyD2Fg8J3S
         FIQtQRrRd9yLlBTT4qZTfSPf0fHwiwxyeLx5jhZ0raj9x7Uvt2aZMriHOQzbunoXM6sd
         GkuzRcsS86orn4wDpOaXGe3F2Yf7+Rzf58LJclfxrA9cTh/+yz/xvnXTy1H896o3dxHV
         jyRg==
X-Gm-Message-State: AO0yUKWWkeeRdDYumdFEbiHF1iO7l0Yb0h453nWC5KDa6rMyJhCynqHS
        MPvcdH0rd3LP4y5pPKVdbg8=
X-Google-Smtp-Source: AK7set81UMgrkGZdNmPQRp61GqSqtcnk49PPSWO5x/DKL5eMUuPAW4fonH4vWXGtuhtChdG64cJAjg==
X-Received: by 2002:a17:902:ce91:b0:19f:2dff:2199 with SMTP id f17-20020a170902ce9100b0019f2dff2199mr6334539plg.68.1679549380970;
        Wed, 22 Mar 2023 22:29:40 -0700 (PDT)
Received: from fedlinux.. ([106.84.129.82])
        by smtp.gmail.com with ESMTPSA id r18-20020a63ce52000000b00502f4c62fd3sm3302965pgi.33.2023.03.22.22.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 22:29:40 -0700 (PDT)
From:   Sam Li <faithilikerun@gmail.com>
To:     qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>,
        damien.lemoal@opensource.wdc.com, kvm@vger.kernel.org,
        hare@suse.de, Paolo Bonzini <pbonzini@redhat.com>,
        dmitry.fomichev@wdc.com, Hanna Reitz <hreitz@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sam Li <faithilikerun@gmail.com>
Subject: [PATCH v8 0/4] Add zoned storage emulation to virtio-blk driver
Date:   Thu, 23 Mar 2023 13:28:24 +0800
Message-Id: <20230323052828.6545-1-faithilikerun@gmail.com>
X-Mailer: git-send-email 2.39.2
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds zoned storage emulation to the virtio-blk driver.

The patch implements the virtio-blk ZBD support standardization that is
recently accepted by virtio-spec. The link to related commit is at

https://github.com/oasis-tcs/virtio-spec/commit/b4e8efa0fa6c8d844328090ad15db65af8d7d981

The Linux zoned device code that implemented by Dmitry Fomichev has been
released at the latest Linux version v6.3-rc1.

Aside: adding zoned=on alike options to virtio-blk device will be
considered in following-up plan.

v7:
- address Stefan's review comments
  * rm aio_context_acquire/release in handle_req
  * rename function return type
  * rename BLOCK_ACCT_APPEND to BLOCK_ACCT_ZONE_APPEND for clarity

v6:
- update headers to v6.3-rc1

v5:
- address Stefan's review comments
  * restore the way writing zone append result to buffer
  * fix error checking case and other errands

v4:
- change the way writing zone append request result to buffer
- change zone state, zone type value of virtio_blk_zone_descriptor
- add trace events for new zone APIs

v3:
- use qemuio_from_buffer to write status bit [Stefan]
- avoid using req->elem directly [Stefan]
- fix error checkings and memory leak [Stefan]

v2:
- change units of emulated zone op coresponding to block layer APIs
- modify error checking cases [Stefan, Damien]

v1:
- add zoned storage emulation

Sam Li (4):
  include: update virtio_blk headers to v6.3-rc1
  virtio-blk: add zoned storage emulation for zoned devices
  block: add accounting for zone append operation
  virtio-blk: add some trace events for zoned emulation

 block/qapi-sysemu.c                          |  11 +
 block/qapi.c                                 |  18 +
 hw/block/trace-events                        |   7 +
 hw/block/virtio-blk-common.c                 |   2 +
 hw/block/virtio-blk.c                        | 405 +++++++++++++++++++
 include/block/accounting.h                   |   1 +
 include/standard-headers/drm/drm_fourcc.h    |  12 +
 include/standard-headers/linux/ethtool.h     |  48 ++-
 include/standard-headers/linux/fuse.h        |  45 ++-
 include/standard-headers/linux/pci_regs.h    |   1 +
 include/standard-headers/linux/vhost_types.h |   2 +
 include/standard-headers/linux/virtio_blk.h  | 105 +++++
 linux-headers/asm-arm64/kvm.h                |   1 +
 linux-headers/asm-x86/kvm.h                  |  34 +-
 linux-headers/linux/kvm.h                    |   9 +
 linux-headers/linux/vfio.h                   |  15 +-
 linux-headers/linux/vhost.h                  |   8 +
 qapi/block-core.json                         |  62 ++-
 qapi/block.json                              |   4 +
 19 files changed, 769 insertions(+), 21 deletions(-)

-- 
2.39.2

