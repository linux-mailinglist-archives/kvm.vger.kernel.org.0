Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C609D790EDF
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 00:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbjICWOh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Sep 2023 18:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbjICWOg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Sep 2023 18:14:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70CBF5
        for <kvm@vger.kernel.org>; Sun,  3 Sep 2023 15:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693779226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VjL9JGcLByfgPaZswLky26tlQQfEuGeRmQ8TWkF1Et8=;
        b=HbDxDHKD1MmabWjRGAoJpB15cqrCRVg6fNJChly9hPLTdLhcF6DTnHJZsrKY2HRu3j3FGl
        CaY6UJICcaAXDJ2WBiJ0Ec+VguPPPM4K6l7/fvAyl793UaOPyfZb/ZWQhPS4Vdc7zDCaN9
        jX7v/P88pUAwbixXGeDOAYBPhlHocns=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-K_MTuwC6Oi2x1iIENhsTdQ-1; Sun, 03 Sep 2023 18:13:45 -0400
X-MC-Unique: K_MTuwC6Oi2x1iIENhsTdQ-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2bcc5098038so7649481fa.2
        for <kvm@vger.kernel.org>; Sun, 03 Sep 2023 15:13:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693779223; x=1694384023;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VjL9JGcLByfgPaZswLky26tlQQfEuGeRmQ8TWkF1Et8=;
        b=ZWuIzF+8HRHOuQDfibWI/sgVxRhIH0PoQUx2GCzoX8pOTYxBPbwc6YDz3rsrsBMdfo
         BNimizDnGaH3YlyiHgnGT7Z4fyiwRXhQEu7IIs/wOl4no9XWprO+/eal4Vmu7N3G3zbn
         Gt2yr6UIFLGIX/zvApfCDhbenc40AUKmV/fHJdF4SYR/TVx4AJqonNfVHEeJc8pZUA9T
         nQWT4FbQi5A6X5By9CD1C20MrKfUyECQvald/FGjPKuACTHNf1BCz0XFeUCwZEf65aOj
         FmYByb+VEDnG9tCpI4SXTxnVpwRdkRkdJJDUybPL1AoOBTLCoPcUNTVdpjqJL6bgbqiv
         73YQ==
X-Gm-Message-State: AOJu0YzlYZxr3ZzTJcRBYjQ2FnGvDujSCWMkJV+6KhJhspuw9t0DtOUR
        DMIvRJtD61QixWXf8uYw0quTJCeuE/UGafm2GekjNMrT1CsvErY/8XwCXF7uvqJpDhcFOzNR360
        NI9YQ6FTTVhYY
X-Received: by 2002:a2e:b70d:0:b0:2bd:133c:58ff with SMTP id j13-20020a2eb70d000000b002bd133c58ffmr5371562ljo.48.1693779223759;
        Sun, 03 Sep 2023 15:13:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFt5eq/oqAhbyqYfgrqKLbNZZyl3X0ZXzNnLt/MouQMoz3QQr7CiE/cjPIeQZ0ta3ELUrf4kA==
X-Received: by 2002:a2e:b70d:0:b0:2bd:133c:58ff with SMTP id j13-20020a2eb70d000000b002bd133c58ffmr5371549ljo.48.1693779223406;
        Sun, 03 Sep 2023 15:13:43 -0700 (PDT)
Received: from redhat.com ([2.52.1.236])
        by smtp.gmail.com with ESMTPSA id gf20-20020a170906e21400b0099ce23c57e6sm5257536ejb.224.2023.09.03.15.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Sep 2023 15:13:42 -0700 (PDT)
Date:   Sun, 3 Sep 2023 18:13:38 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eperezma@redhat.com, jasowang@redhat.com, mst@redhat.com,
        shannon.nelson@amd.com, xuanzhuo@linux.alibaba.com,
        yuanyaogoog@chromium.org, yuehaibing@huawei.com
Subject: [GIT PULL] virtio: features
Message-ID: <20230903181338-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 2dde18cd1d8fac735875f2e4987f11817cc0bc2c:

  Linux 6.5 (2023-08-27 14:49:51 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 1acfe2c1225899eab5ab724c91b7e1eb2881b9ab:

  virtio_ring: fix avail_wrap_counter in virtqueue_add_packed (2023-09-03 18:10:24 -0400)

----------------------------------------------------------------
virtio: features

a small pull request this time around, mostly because the
vduse network got postponed to next relase so we can be sure
we got the security store right.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Eugenio Pérez (4):
      vdpa: add VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK flag
      vdpa: accept VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK backend feature
      vdpa: add get_backend_features vdpa operation
      vdpa_sim: offer VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK

Jason Wang (1):
      virtio_vdpa: build affinity masks conditionally

Xuan Zhuo (12):
      virtio_ring: check use_dma_api before unmap desc for indirect
      virtio_ring: put mapping error check in vring_map_one_sg
      virtio_ring: introduce virtqueue_set_dma_premapped()
      virtio_ring: support add premapped buf
      virtio_ring: introduce virtqueue_dma_dev()
      virtio_ring: skip unmap for premapped
      virtio_ring: correct the expression of the description of virtqueue_resize()
      virtio_ring: separate the logic of reset/enable from virtqueue_resize
      virtio_ring: introduce virtqueue_reset()
      virtio_ring: introduce dma map api for virtqueue
      virtio_ring: introduce dma sync api for virtqueue
      virtio_net: merge dma operations when filling mergeable buffers

Yuan Yao (1):
      virtio_ring: fix avail_wrap_counter in virtqueue_add_packed

Yue Haibing (1):
      vdpa/mlx5: Remove unused function declarations

 drivers/net/virtio_net.c           | 230 ++++++++++++++++++---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |   3 -
 drivers/vdpa/vdpa_sim/vdpa_sim.c   |   8 +
 drivers/vhost/vdpa.c               |  15 +-
 drivers/virtio/virtio_ring.c       | 412 ++++++++++++++++++++++++++++++++-----
 drivers/virtio/virtio_vdpa.c       |  17 +-
 include/linux/vdpa.h               |   4 +
 include/linux/virtio.h             |  22 ++
 include/uapi/linux/vhost_types.h   |   4 +
 9 files changed, 625 insertions(+), 90 deletions(-)

