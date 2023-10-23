Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968147D2988
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 07:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjJWFDJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 01:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjJWFDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 01:03:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F28AF
        for <kvm@vger.kernel.org>; Sun, 22 Oct 2023 22:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698037339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=VYWewINA58ufsweAbU1fUSU48ieD3onMLop08pEtwvU=;
        b=YLYvH7mwQZa3vlqNv8F44T1TBrq3pq+hONJicoCQlmM9nHnFj2RYKFhADPAwMG6slpa+pc
        KKiWNGrASS4dwENbxigdKKiLkckx6ciu8NLpXM28S89DGZYj/na/s6sLVkjLJkorC33iuh
        2ZrntvHkhI84OIG+7aoTrtuVlusvjbQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-3YqoIy0fO-mLMLvyEtS2Jg-1; Mon, 23 Oct 2023 01:02:17 -0400
X-MC-Unique: 3YqoIy0fO-mLMLvyEtS2Jg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4084001846eso20723295e9.1
        for <kvm@vger.kernel.org>; Sun, 22 Oct 2023 22:02:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698037336; x=1698642136;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VYWewINA58ufsweAbU1fUSU48ieD3onMLop08pEtwvU=;
        b=IwoMzbhm5lm6cva4elZEjvZQAAPIfg+EljSAEY4IbUhJz2Gr+n8Wzwcnp+9Ztd78Wl
         Lbufc7gTHUrABGff8eSmt+30Tx5EXR8Rod7jmvL5jj3adH2WHNmOIKGm0b6ccykygjiU
         66WNlBixmXvB4a8bbBsyLxBMH2mR3nG9oO3vxf+yiorzgI9Z1u7SbCHxln8Wzjx5L96Q
         F7nC7Lxa8ndHD8WjdTWUqszcgmIAMkhC3oGFLYdRe7ApTT1GH+uFrqmuqwvxXYeEET/N
         +J+lkd4vcBKcnh6JX9rl1gz/rUbmpH/GU3LWCmr9L/JzcxlIHeldlNt/1ua0CrIqIeb3
         kfEg==
X-Gm-Message-State: AOJu0Yw75I8Frfd1NT/0omKqRL3x4spMdJ/KKk3LgWuPIet0WWThs7rG
        dbazYDN+wgsJefLTSONUQhSeD2cOE31A0HJyHv9dBjL2w1T2rRP3xUXFj4jSNk/yBUK17Vy62R0
        P2a42FDcHJs2p
X-Received: by 2002:a05:600c:188a:b0:406:7021:7d8 with SMTP id x10-20020a05600c188a00b00406702107d8mr6243041wmp.20.1698037335961;
        Sun, 22 Oct 2023 22:02:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEEE93zO060dPvm0mbGcpCvz5k2sh+CIGfA4Q3Qp53GzxNdWjPayH2r0nxenrW1QoZUESLwnA==
X-Received: by 2002:a05:600c:188a:b0:406:7021:7d8 with SMTP id x10-20020a05600c188a00b00406702107d8mr6242988wmp.20.1698037335303;
        Sun, 22 Oct 2023 22:02:15 -0700 (PDT)
Received: from redhat.com ([2a02:14f:1f2:e88f:2c2c:db43:583d:d30e])
        by smtp.gmail.com with ESMTPSA id 1-20020a05600c028100b004077219aed5sm13079549wmk.6.2023.10.22.22.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Oct 2023 22:02:14 -0700 (PDT)
Date:   Mon, 23 Oct 2023 01:02:07 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        arei.gonglei@huawei.com, catalin.marinas@arm.com,
        dtatulea@nvidia.com, eric.auger@redhat.com, gshan@redhat.com,
        jasowang@redhat.com, liming.wu@jaguarmicro.com, mheyne@amazon.de,
        mst@redhat.com, pasic@linux.ibm.com, pizhenwei@bytedance.com,
        shawn.shao@jaguarmicro.com, xuanzhuo@linux.alibaba.com,
        zhenyzha@redhat.com
Subject: [GIT PULL] virtio: last minute fixes
Message-ID: <20231023010207-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 58720809f52779dc0f08e53e54b014209d13eebb:

  Linux 6.6-rc6 (2023-10-15 13:34:39 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 061b39fdfe7fd98946e67637213bcbb10a318cca:

  virtio_pci: fix the common cfg map size (2023-10-18 11:30:12 -0400)

----------------------------------------------------------------
virtio: last minute fixes

a collection of small fixes that look like worth having in
this release.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Dragos Tatulea (2):
      vdpa/mlx5: Fix double release of debugfs entry
      vdpa/mlx5: Fix firmware error on creation of 1k VQs

Eric Auger (1):
      vhost: Allow null msg.size on VHOST_IOTLB_INVALIDATE

Gavin Shan (1):
      virtio_balloon: Fix endless deflation and inflation on arm64

Liming Wu (1):
      tools/virtio: Add dma sync api for virtio test

Maximilian Heyne (1):
      virtio-mmio: fix memory leak of vm_dev

Shawn.Shao (1):
      vdpa_sim_blk: Fix the potential leak of mgmt_dev

Xuan Zhuo (1):
      virtio_pci: fix the common cfg map size

zhenwei pi (1):
      virtio-crypto: handle config changed by work queue

 drivers/crypto/virtio/virtio_crypto_common.h |  3 ++
 drivers/crypto/virtio/virtio_crypto_core.c   | 14 +++++-
 drivers/vdpa/mlx5/net/debug.c                |  5 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c            | 70 ++++++++++++++++++++++------
 drivers/vdpa/mlx5/net/mlx5_vnet.h            | 11 ++++-
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c         |  5 +-
 drivers/vhost/vhost.c                        |  4 +-
 drivers/virtio/virtio_balloon.c              |  6 ++-
 drivers/virtio/virtio_mmio.c                 | 19 ++++++--
 drivers/virtio/virtio_pci_modern_dev.c       |  2 +-
 tools/virtio/linux/dma-mapping.h             | 12 +++++
 11 files changed, 121 insertions(+), 30 deletions(-)

