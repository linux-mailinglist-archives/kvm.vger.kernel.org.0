Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D6C6CA80E
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 16:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbjC0OqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 10:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbjC0OqL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 10:46:11 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDB43C0F
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 07:46:07 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id p3-20020a17090a74c300b0023f69bc7a68so9078259pjl.4
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 07:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679928367;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WyO156dQOa4nrRRrp9o61JeRohlnTbUgCnQnaqzKKFI=;
        b=MWxe8tDNfZkZmP+j8FlP+iAP6YkXjhiJOU8ZThJz7vpDT/1ROeHFd0Rg5by5dzjwr/
         lG5UanLOkyRDkT/V+boBeTts6mrFEjoVkLsW39sYC9DK5o+FWRoubkyYUCCOIHAVFbBq
         BoBCLeNAfE6iyqVsm1s74lOOQ3sFRzbimAc6Eb/icnJ5nmSh7n0hp2FgulsSc36P14Qe
         RcqHBcr9XU2FXrPUFHqu9mUVjRJTM9VGrdl0c3DlTSUlRpHnWJ3ARqEhsApNkWR5xqgb
         Gnx6K6epkJRBdPN4dbsEvkMODX8p1abQErl3wVUk9Kw023jKpslOy+hpq2sOlYcN8NbH
         smuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679928367;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WyO156dQOa4nrRRrp9o61JeRohlnTbUgCnQnaqzKKFI=;
        b=jZiPoBW6vLF8bT9ORePlQuBawTSnfEecroo4HAg3ssR6S3gxCyqhO2W9mBkiSPWZwR
         AXB6HqTazcAewRXqpov8xvLXDbHQY3yrBmdk5tWZg7SFwZ6MX9HNOCDARMmio9WpCl0Q
         clvR4VhlvzfjnM4EzOZG5d9V/6fWMdSGm9LT8wceptTkd1SCFtt4sQbIOeNAxSmVpinL
         ND50W75a62KRQ74SDPSrP026O2XEy09fesLpzsaCQwXz+s6wPWq5vZnKenFoT2gCBCFg
         tVSHIogl/asxIuEorbWPeTi2uoNXbHgxbvbw7aB98hUAq5bqbTDfJlXHqVByL1b/LaRC
         npbA==
X-Gm-Message-State: AAQBX9dnpXvAc/QLU1VOg+dhgIieTzCCf6azkZHZk2oV9KvTStpRnV55
        wtuyv25olhj/ALu4pFRaEcY=
X-Google-Smtp-Source: AKy350Yr+ALjPHrl3lCIju8vOpbTMlRt8F29e0yc28+rRemcldzgFDYCgDKAffOoNqH4LY8l/xrTbg==
X-Received: by 2002:a17:902:f906:b0:1a1:a7b6:e31e with SMTP id kw6-20020a170902f90600b001a1a7b6e31emr10608452plb.7.1679928366845;
        Mon, 27 Mar 2023 07:46:06 -0700 (PDT)
Received: from fedlinux.. ([106.84.130.102])
        by smtp.gmail.com with ESMTPSA id s21-20020a170902b19500b00183c6784704sm17368276plr.291.2023.03.27.07.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 07:46:06 -0700 (PDT)
From:   Sam Li <faithilikerun@gmail.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, dmitry.fomichev@wdc.com,
        kvm@vger.kernel.org, damien.lemoal@opensource.wdc.com,
        hare@suse.de, Kevin Wolf <kwolf@redhat.com>, qemu-block@nongnu.org,
        Sam Li <faithilikerun@gmail.com>
Subject: [PATCH v9 0/5] Add zoned storage emulation to virtio-blk driver
Date:   Mon, 27 Mar 2023 22:45:48 +0800
Message-Id: <20230327144553.4315-1-faithilikerun@gmail.com>
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

This patch adds zoned storage emulation to the virtio-blk driver. It
implements the virtio-blk ZBD support standardization that is
recently accepted by virtio-spec. The link to related commit is at

https://github.com/oasis-tcs/virtio-spec/commit/b4e8efa0fa6c8d844328090ad15db65af8d7d981

The Linux zoned device code that implemented by Dmitry Fomichev has been
released at the latest Linux version v6.3-rc1.

Aside: adding zoned=on alike options to virtio-blk device will be
considered in following-up plan.

Note: Sorry to send it again because of the previous incoherent patches caused
by network error.

v9:
- address review comments
  * add docs for zoned emulation use case [Matias]
  * add the zoned feature bit to qmp monitor [Matias]
  * add the version number for newly added configs of accounting [Markus]

v8:
- address Stefan's review comments
  * rm aio_context_acquire/release in handle_req
  * rename function return type
  * rename BLOCK_ACCT_APPEND to BLOCK_ACCT_ZONE_APPEND for clarity

v7:
- update headers to v6.3-rc1

v6:
- address Stefan's review comments
  * add accounting for zone append operation
  * fix in_iov usage in handle_request, error handling and typos

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

Sam Li (5):
  include: update virtio_blk headers to v6.3-rc1
  virtio-blk: add zoned storage emulation for zoned devices
  block: add accounting for zone append operation
  virtio-blk: add some trace events for zoned emulation
  docs/zoned-storage:add zoned emulation use case

 block/qapi-sysemu.c                          |  11 +
 block/qapi.c                                 |  18 +
 docs/devel/zoned-storage.rst                 |  17 +
 hw/block/trace-events                        |   7 +
 hw/block/virtio-blk-common.c                 |   2 +
 hw/block/virtio-blk.c                        | 405 +++++++++++++++++++
 hw/virtio/virtio-qmp.c                       |   2 +
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
 qapi/block-core.json                         |  68 +++-
 qapi/block.json                              |   4 +
 21 files changed, 794 insertions(+), 21 deletions(-)

-- 
2.39.2

