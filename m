Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB516C7C4A
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 11:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjCXKOJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 06:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjCXKOH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 06:14:07 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276EF5275
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 03:14:06 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id l14so910618pfc.11
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 03:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679652845;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N6Vxj015pqt1W0XnDOUHqu9GT8QgN1kOUZXj43n+nL4=;
        b=aNXD+gPhl0LovONOf1Ciny+jDjKrI0XAnkljSuC+eo9XKlqfr0dZKJYb5r0UgZSOfS
         3ety6MLjXWM+LIySBBeCcpijAJlS4obf2d1Kg1Bp0ymqOG50Vq/6opk7tIZS6Ir8tT6a
         Mvy92qYBhhC7n3FnAbZgPKUP+RUIaYV0u/AA5I7XrGPcd+mBWuyT3xyqOT78CWrDZEPu
         WCEPFZl53V+7/NmSzqR6W5jdtcHxlx4HAdEInQKtKumAxXI/awGeGYm/We7/+8m4Znbl
         7vzEGT9rc0tUaalANdeSdu/1hW4Ysii51+mgU0IG67YLmf1vNYoqmUuqwpPuoeHGvlUb
         Q+JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679652845;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N6Vxj015pqt1W0XnDOUHqu9GT8QgN1kOUZXj43n+nL4=;
        b=aPAJFJ2tReMhHyCCYWmLUvCsBVGS4vKPT7MZ2My92htF4QdIXBluQ/4dbSJPDZWlXh
         cBdgnJZZK6fkmOmbyJCSu8epcZQlrZKSiBMxzuqJiaMTS4ZacFx8f8d3whCLTySSdwtL
         bjnuBm5HMJm3Ns7SaOGrNxp7G9KD/8Fj8kQJEfUZSFtKETvc4JS31gEBG0wtNey1yh5q
         tVQmTluRXMu8w/IGqsDjr4/VsRceBB+KJCuKjhhslyAfvQW8aGSiKsXtf86AOyibpEuV
         C3+gdKYI8EhxOCY1QuWwtHGUM7GhHFtHNjRw5YK74+OvEFqNLns7NXgZMIFORXLm/SZU
         2QtQ==
X-Gm-Message-State: AAQBX9fOnie6LrMDIxhb6OgLrz1Pp+dfT8oD2FMWXIldpV27nnIZIB8F
        I49/PSAe+2gbv/6Vff2K7cE=
X-Google-Smtp-Source: AKy350YVnV5iibdqwKaOIdDBk44LbQ0nGJPEal8htAtmGVh3WGiP7GDTSfJcPSuPsuOnQfkztwY10A==
X-Received: by 2002:aa7:9f8f:0:b0:628:9b4:a6a2 with SMTP id z15-20020aa79f8f000000b0062809b4a6a2mr2370516pfr.15.1679652845009;
        Fri, 24 Mar 2023 03:14:05 -0700 (PDT)
Received: from fedlinux.. ([106.84.130.185])
        by smtp.gmail.com with ESMTPSA id h24-20020a63df58000000b0050f85ef50d1sm8282421pgj.26.2023.03.24.03.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 03:14:04 -0700 (PDT)
From:   Sam Li <faithilikerun@gmail.com>
To:     qemu-devel@nongnu.org
Cc:     stefanha@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
        hare@suse.de, Cornelia Huck <cohuck@redhat.com>,
        dmitry.fomichev@wdc.com, qemu-block@nongnu.org,
        Markus Armbruster <armbru@redhat.com>,
        damien.lemoal@opensource.wdc.com,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>, kvm@vger.kernel.org,
        Eric Blake <eblake@redhat.com>,
        Sam Li <faithilikerun@gmail.com>
Subject: [PATCH v9 0/5] Add zoned storage emulation to virtio-blk driver
Date:   Fri, 24 Mar 2023 18:13:52 +0800
Message-Id: <20230324101357.2717-1-faithilikerun@gmail.com>
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

