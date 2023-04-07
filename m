Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DACBF6DAA01
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 10:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbjDGIZj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 04:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbjDGIZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 04:25:37 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6D76EAB
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 01:25:36 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id c10-20020a17090abf0a00b0023d1bbd9f9eso917459pjs.0
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 01:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680855936;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f36nO7o88eBlIdNJ8rqi2y7Ot3HHYbfyYZb9EEBi1c4=;
        b=DuyiTXMN1YSli4ShQxDowGTPSDXXhEeUjycrQQ4cZOExpMv3FWXVjHWppdlB7vdGN1
         ivA8dxwQGwdXz7oHav7cQt8MT1B9BEymlzSrfIdMUefOoIMtETdW6iZQ2dZ7CFM9hdza
         KPwakUhiPqzOdlo+sUHK5cUxqrvsybL9yvmUqrjfnXQz5R/c8wgbdAnhhKY8krukDz4V
         P/0r53FWyF2ekifauY4/atBvRgO5CHgE/DekqOrep7eJuhHwFIcxG2KTfFisAcJCrlAQ
         aeiFBqVC1S+uXgGCsRVcIPQD3mdLwBLZWwRhUQgjaTau4N5EBvCoTloX0ofzCn07DVXe
         kSRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680855936;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f36nO7o88eBlIdNJ8rqi2y7Ot3HHYbfyYZb9EEBi1c4=;
        b=5k68aDIMy5HtqSqVoNrRhel/0etr1mKQ9x7MvEO3+q+I3r8F+cCyp+Lba6+ZSDXnS4
         wMnU8Fcy3OWsiOzEaf0V5i8THap6+J3YISd8hMB8dkRFBmI55+s9C5GaGW7WPtc4v0ZP
         RznuDW7a53RAzaBWFbIxzN6ObxOV4rmbEvSbq7jhK+gnWzFLsOeATuNwCnp8qsCL2uPE
         sBB/SPF1lND5F/HoWSqO7cGckWHQ+/V9YzvGp0PzHQJ9nGmFaxe9InHqtc94hz6MBN8Z
         G5W8Sr14wr2KXIRivfFo++xIkmj3REZSFEaXnGcHza1rmK5rSs8MMQi7W0mUPgGDBnYL
         MNUg==
X-Gm-Message-State: AAQBX9d8mVXzGOp08e+/ibwx318FsN49AbCfyV7OCSxzXiVxn8y9p332
        d4MAjKG157QtUmj3XnUG9dg=
X-Google-Smtp-Source: AKy350ZfIpSMqKjKOdQHFM/BDzrSnk3gKnr/5XWjajhTwrjV2heIpwKCD9hXw0rUCVxLnIzytfNfBw==
X-Received: by 2002:a05:6a20:9321:b0:d4:fd7e:c8b0 with SMTP id r33-20020a056a20932100b000d4fd7ec8b0mr1991535pzh.7.1680855936060;
        Fri, 07 Apr 2023 01:25:36 -0700 (PDT)
Received: from fedlinux.. ([106.84.131.166])
        by smtp.gmail.com with ESMTPSA id fe12-20020a056a002f0c00b0062dcaa50a9asm2521331pfb.58.2023.04.07.01.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 01:25:35 -0700 (PDT)
From:   Sam Li <faithilikerun@gmail.com>
To:     qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        damien.lemoal@opensource.wdc.com, qemu-block@nongnu.org,
        Eric Blake <eblake@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, hare@suse.de,
        "Michael S. Tsirkin" <mst@redhat.com>, dmitry.fomichev@wdc.com,
        kvm@vger.kernel.org, Sam Li <faithilikerun@gmail.com>
Subject: [PATCH v10 0/5] Add zoned storage emulation to virtio-blk driver
Date:   Fri,  7 Apr 2023 16:25:23 +0800
Message-Id: <20230407082528.18841-1-faithilikerun@gmail.com>
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

v10:
- adapt to the latest zone-append patches: rename bs->bl.wps to bs->wps

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

