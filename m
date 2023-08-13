Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D3777AED2
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 01:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbjHMXJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Aug 2023 19:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjHMXJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Aug 2023 19:09:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E34E8
        for <kvm@vger.kernel.org>; Sun, 13 Aug 2023 16:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691968096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=AUa1QX/mJ1ef9VxwUsegnOGKLjQxThmW1L4mbjRAl5o=;
        b=Y0Hv0gwMpY81XUsfy3s3cnd1XNWCwgArnfVu4Pj1N7Ebyeqivot2jtArFEpyIKEVXgkNUT
        SG2TP9P0EAZLqWheOifuW1mqS0fbjD8L2Be1C2zNeNVft0giKu50BYyUgLVzLHqYZOHseA
        WW539bvfJIYRTd9DNfKrXXuzJyqX5Gk=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-YymbDmMoM1yzKFORKmn-dg-1; Sun, 13 Aug 2023 19:08:12 -0400
X-MC-Unique: YymbDmMoM1yzKFORKmn-dg-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2b9bf49342dso36612541fa.1
        for <kvm@vger.kernel.org>; Sun, 13 Aug 2023 16:08:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691968091; x=1692572891;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AUa1QX/mJ1ef9VxwUsegnOGKLjQxThmW1L4mbjRAl5o=;
        b=jy+w7lHKMZ2D0uD/3nYe6Lox2BoX7BfhhezBtPs4+zSfA+lCHruCshTFQka0WltxOt
         EU1ku3QiuChCSPYjOsbstCLDD6PrQuY9RHW5sbiovgMPH4FjKofQIt66gxBjjzOlOKOb
         c2rS1VyYkh19Wn/TCs7fLMrCoQzpLHpOiYCfSP0+6P1RaIsNihWcNcdEdAT/Ststp3Oa
         htso9kaWlwXNu9/a3xJB1N2rIMhyCYFGPisqdK+dDvPstAzIwUgZnjuzKnt7P7RdnCsJ
         eGH3uCV9f2le8bE38tuo0RU50mEgQfJZHROVY7jtSndqDAgkjVnCJqI1inuf5zdms9hi
         OhOQ==
X-Gm-Message-State: AOJu0Yxiwnt1MwttF3/dnxZk1fBXojbZbaQIgJeLAJXlgZZ1Skkd+ZqX
        jUQ7X7dlf1rnjauvktysH3xPE06+93ClKyG1Kn73rC+32UUhJ4PsNFt3AAj3lwKiFsGHGVwC75b
        t8MZr4WQVO3Yt
X-Received: by 2002:a2e:8503:0:b0:2b7:1005:931b with SMTP id j3-20020a2e8503000000b002b71005931bmr5573399lji.0.1691968090805;
        Sun, 13 Aug 2023 16:08:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHfB6KQC44UtzTvTIQLTU6WSArsFvqwFM/tL9oeOdLXdw+TuyKztZH0mu5DyTnZ3c9/bKtQHw==
X-Received: by 2002:a2e:8503:0:b0:2b7:1005:931b with SMTP id j3-20020a2e8503000000b002b71005931bmr5573379lji.0.1691968090444;
        Sun, 13 Aug 2023 16:08:10 -0700 (PDT)
Received: from redhat.com ([2.55.42.146])
        by smtp.gmail.com with ESMTPSA id jo19-20020a170906f6d300b0099bcd1fa5b0sm5002759ejb.192.2023.08.13.16.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Aug 2023 16:08:09 -0700 (PDT)
Date:   Sun, 13 Aug 2023 19:08:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        allen.hubbe@amd.com, andrew@daynix.com, david@redhat.com,
        dtatulea@nvidia.com, eperezma@redhat.com, feliu@nvidia.com,
        gal@nvidia.com, jasowang@redhat.com, leiyang@redhat.com,
        linma@zju.edu.cn, maxime.coquelin@redhat.com,
        michael.christie@oracle.com, mst@redhat.com, rdunlap@infradead.org,
        sgarzare@redhat.com, shannon.nelson@amd.com,
        stable@vger.kernel.org, stable@vger.kernelorg, stefanha@redhat.com,
        wsa+renesas@sang-engineering.com, xieyongji@bytedance.com,
        yin31149@gmail.com
Subject: [GIT PULL] virtio: bugfixes
Message-ID: <20230813190803-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All small, fairly safe changes.

The following changes since commit 52a93d39b17dc7eb98b6aa3edb93943248e03b2f:

  Linux 6.5-rc5 (2023-08-06 15:07:51 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to f55484fd7be923b740e8e1fc304070ba53675cb4:

  virtio-mem: check if the config changed before fake offlining memory (2023-08-10 15:51:46 -0400)

----------------------------------------------------------------
virtio: bugfixes

just a bunch of bugfixes all over the place.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Allen Hubbe (2):
      pds_vdpa: reset to vdpa specified mac
      pds_vdpa: alloc irq vectors on DRIVER_OK

David Hildenbrand (4):
      virtio-mem: remove unsafe unplug in Big Block Mode (BBM)
      virtio-mem: convert most offline_and_remove_memory() errors to -EBUSY
      virtio-mem: keep retrying on offline_and_remove_memory() errors in Sub Block Mode (SBM)
      virtio-mem: check if the config changed before fake offlining memory

Dragos Tatulea (4):
      vdpa: Enable strict validation for netlinks ops
      vdpa/mlx5: Correct default number of queues when MQ is on
      vdpa/mlx5: Fix mr->initialized semantics
      vdpa/mlx5: Fix crash on shutdown for when no ndev exists

Eugenio Pérez (1):
      vdpa/mlx5: Delete control vq iotlb in destroy_mr only when necessary

Feng Liu (1):
      virtio-pci: Fix legacy device flag setting error in probe

Gal Pressman (1):
      virtio-vdpa: Fix cpumask memory leak in virtio_vdpa_find_vqs()

Hawkins Jiawei (1):
      virtio-net: Zero max_tx_vq field for VIRTIO_NET_CTRL_MQ_HASH_CONFIG case

Lin Ma (3):
      vdpa: Add features attr to vdpa_nl_policy for nlattr length check
      vdpa: Add queue index attr to vdpa_nl_policy for nlattr length check
      vdpa: Add max vqp attr to vdpa_nl_policy for nlattr length check

Maxime Coquelin (1):
      vduse: Use proper spinlock for IRQ injection

Mike Christie (3):
      vhost-scsi: Fix alignment handling with windows
      vhost-scsi: Rename vhost_scsi_iov_to_sgl
      MAINTAINERS: add vhost-scsi entry and myself as a co-maintainer

Shannon Nelson (4):
      pds_vdpa: protect Makefile from unconfigured debugfs
      pds_vdpa: always allow offering VIRTIO_NET_F_MAC
      pds_vdpa: clean and reset vqs entries
      pds_vdpa: fix up debugfs feature bit printing

Wolfram Sang (1):
      virtio-mmio: don't break lifecycle of vm_dev

 MAINTAINERS                        |  11 ++-
 drivers/net/virtio_net.c           |   2 +-
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |   2 +
 drivers/vdpa/mlx5/core/mr.c        | 105 +++++++++++++++------
 drivers/vdpa/mlx5/net/mlx5_vnet.c  |  26 +++---
 drivers/vdpa/pds/Makefile          |   3 +-
 drivers/vdpa/pds/debugfs.c         |  15 ++-
 drivers/vdpa/pds/vdpa_dev.c        | 176 ++++++++++++++++++++++++----------
 drivers/vdpa/pds/vdpa_dev.h        |   5 +-
 drivers/vdpa/vdpa.c                |   9 +-
 drivers/vdpa/vdpa_user/vduse_dev.c |   8 +-
 drivers/vhost/scsi.c               | 187 ++++++++++++++++++++++++++++++++-----
 drivers/virtio/virtio_mem.c        | 168 ++++++++++++++++++++++-----------
 drivers/virtio/virtio_mmio.c       |   5 +-
 drivers/virtio/virtio_pci_common.c |   2 -
 drivers/virtio/virtio_pci_legacy.c |   1 +
 drivers/virtio/virtio_vdpa.c       |   2 +
 17 files changed, 519 insertions(+), 208 deletions(-)

