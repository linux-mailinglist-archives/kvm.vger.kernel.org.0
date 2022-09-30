Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D8B5F0F6B
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 18:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbiI3P7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 11:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbiI3P7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 11:59:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA82D14D05
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 08:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664553579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=s0VdZiYvqssIOHfeT/CymYAuFjYTWH/3Mag29BcynOs=;
        b=aNA2Nw+odSeMwJhvURHsMk2krnNf/xM6GzQfbhT0eNx41TeuYsSPl86SVs3dRv3PXgE4s8
        Kr20FXW9ttv7+FNcJBpwwEgwRhmy2/i0Wnv1N2e80rdYhxu3QhYN36qEeWouvRGLG2+rXj
        TRYP9BgGN+1bPXNMknvPGd0NF5LfzOA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-605-fSXhZvUtNyGc52zgDb1lHw-1; Fri, 30 Sep 2022 11:59:38 -0400
X-MC-Unique: fSXhZvUtNyGc52zgDb1lHw-1
Received: by mail-ed1-f70.google.com with SMTP id dz21-20020a0564021d5500b0045217702048so3833188edb.5
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 08:59:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=s0VdZiYvqssIOHfeT/CymYAuFjYTWH/3Mag29BcynOs=;
        b=7+4tUrPyb7b1GnAjM9pfnLTu0zhnryLxZ75ydq5cqiCqMXrJOcUyvuHG5NhqTggJFN
         UeX5iG0WoceIHcn2GBWpfiUpszOlAbV6vzIgL8OHtRM7TDXoA9Xa5z4OScsmqLiAs7LL
         TnX6Wwf3LszplFkgKwdXAnBBscqnIFlU/RX1gjqM0w/OuvYGg6cfTGINwj6gZepeNf28
         DCL9I/BKnKyyvoqOkOSnkZYccJGeInUesyLDUIoKdyaJGwWlzw7WaFVeGzM50jNcTlDk
         hEJtTTXh8wC9aVVdb1SvVSKNJy22xq7QgXKqYta4t50Tf92ST+nH4SgbgM6zIgrwmCyK
         bt0A==
X-Gm-Message-State: ACrzQf3HvIoI5Sed3E+VXbrzIaGYRisOclNiaBNQCXXiOSiOEl+HA5V3
        CpCif8Om5Ze0fD3VUyX7qucQt9ncJdKNfar9sQr1w8sQ1tkxq2xCRPZCOYCn1PsUWrNzrgGzYEL
        +KPp6CxYGHcIL
X-Received: by 2002:a17:907:9714:b0:783:954a:5056 with SMTP id jg20-20020a170907971400b00783954a5056mr6907765ejc.318.1664553577054;
        Fri, 30 Sep 2022 08:59:37 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7mz4/tv12OGuGnNdRMo9OH788yzGFfKJb5e2fxoM3bB4V0KuNZAwipaE4zg0MStjxYK9tRiA==
X-Received: by 2002:a17:907:9714:b0:783:954a:5056 with SMTP id jg20-20020a170907971400b00783954a5056mr6907749ejc.318.1664553576855;
        Fri, 30 Sep 2022 08:59:36 -0700 (PDT)
Received: from redhat.com ([2a06:c701:742e:6800:d12a:e12c:77cf:7dd6])
        by smtp.gmail.com with ESMTPSA id 14-20020a170906328e00b00787a6adab7csm1369697ejw.147.2022.09.30.08.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 08:59:36 -0700 (PDT)
Date:   Fri, 30 Sep 2022 11:59:33 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        acourbot@chromium.org, angus.chen@jaguarmicro.com, elic@nvidia.com,
        helei.sig11@bytedance.com, jasowang@redhat.com,
        lingshan.zhu@intel.com, maxime.coquelin@redhat.com, mst@redhat.com,
        stefanha@redhat.com, suwan.kim027@gmail.com,
        xuanzhuo@linux.alibaba.com
Subject: [GIT PULL] virtio: fixes
Message-ID: <20220930115933-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit f76349cf41451c5c42a99f18a9163377e4b364ff:

  Linux 6.0-rc7 (2022-09-25 14:01:02 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to a43ae8057cc154fd26a3a23c0e8643bef104d995:

  vdpa/mlx5: Fix MQ to support non power of two num queues (2022-09-27 18:32:45 -0400)

----------------------------------------------------------------
virtio: fixes

Some last minute fixes. virtio-blk is the most important one
since it was actually seen in the field, but the rest
of them are small and clearly safe, everything here has
been in next for a while.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Angus Chen (1):
      vdpa/ifcvf: fix the calculation of queuepair

Eli Cohen (1):
      vdpa/mlx5: Fix MQ to support non power of two num queues

Maxime Coquelin (1):
      vduse: prevent uninitialized memory accesses

Suwan Kim (1):
      virtio-blk: Fix WARN_ON_ONCE in virtio_queue_rq()

Xuan Zhuo (1):
      virtio_test: fixup for vq reset

lei he (1):
      virtio-crypto: fix memory-leak

 drivers/block/virtio_blk.c                          | 11 +++++------
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c |  4 ++++
 drivers/vdpa/ifcvf/ifcvf_base.c                     |  4 ++--
 drivers/vdpa/mlx5/net/mlx5_vnet.c                   | 17 ++++++++++-------
 drivers/vdpa/vdpa_user/vduse_dev.c                  |  9 +++++++--
 tools/virtio/linux/virtio.h                         |  3 +++
 tools/virtio/linux/virtio_config.h                  |  5 +++++
 7 files changed, 36 insertions(+), 17 deletions(-)

