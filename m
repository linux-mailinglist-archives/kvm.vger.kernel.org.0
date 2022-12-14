Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307F264CE10
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 17:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239085AbiLNQbz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 11:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239012AbiLNQbg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 11:31:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F413611C05
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 08:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671035446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MvzKkMsF15Ii2v8T6zm7fsybd7ToFL1MzDuE6XhV9TM=;
        b=gNF8H/fdC/1L/niO2UM3V5UTecFY9v8/5YEfdOiq/NJYjgSSBl0PRnJqX5xJy9u96cEjWq
        sB9KWmIjL1O843iXQHAeszhFz8zc6E9PbzEBygj/7ib9f9a+9JnKDMx62rSS4h6m1KCBK2
        a1xP2ajlO1Y2pyCdJtKf7ZdcR61U0Co=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-237-bo_0BMk3NuCIbMuww73mrQ-1; Wed, 14 Dec 2022 11:30:29 -0500
X-MC-Unique: bo_0BMk3NuCIbMuww73mrQ-1
Received: by mail-wm1-f70.google.com with SMTP id ay19-20020a05600c1e1300b003cf758f1617so7424065wmb.5
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 08:30:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MvzKkMsF15Ii2v8T6zm7fsybd7ToFL1MzDuE6XhV9TM=;
        b=xuXWjorf10aJfRnO1gfg2GZWfelndPqCH61QV6sxuecFnj4mazm7B9WwY2G+3AJUFV
         9StRBaheQWonKWE27Bs4SEuPHIQ7MWxEUVBU7NVDrdGHvuv4zV93/9SbUZJo9achdozd
         8Bl23zHEFY2GFyBPWsqHmazLGlRgc+tec4xSGZ5Dws4+BoevcqQdWDYq4/xkSeC1cf9y
         4T+TNRHDZ+CXcH27H+ECmBdpu4fDMxMAlOv4Om2Liw7T7Xh4ZGHYI0wa1i2Fy7NLtMI/
         80rB5ZiCMB6V6dBJYhe2K/8Y+ISI7m7nrbU0bv1xaEIQf3L/XFG1EAS3fCxAvaIdkquJ
         uj5A==
X-Gm-Message-State: ANoB5pkkDWbDNGeXR6TQk08MPDdCIyydPpEuGgH2uAy5rBlNv3y00Ifq
        9d8s4L6L9nI68isGgKhkhaxWFwEy+ChMRPofnbNIfQPkW28IKhvb39I02zpwwdW6gmMsFpUktrZ
        vsjeYuNntthJM
X-Received: by 2002:a5d:470a:0:b0:242:d4f:96c with SMTP id y10-20020a5d470a000000b002420d4f096cmr15025769wrq.0.1671035428443;
        Wed, 14 Dec 2022 08:30:28 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4GfaS136t9dUD0TzONcVTtwml5/pPsXD/CEUDFgE57pufF23Sy+4PdxYOWCLOsS1OfTnwS5w==
X-Received: by 2002:a5d:470a:0:b0:242:d4f:96c with SMTP id y10-20020a5d470a000000b002420d4f096cmr15025759wrq.0.1671035428229;
        Wed, 14 Dec 2022 08:30:28 -0800 (PST)
Received: from step1.redhat.com (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id e17-20020adffd11000000b002422816aa25sm3791759wrr.108.2022.12.14.08.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 08:30:27 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Jason Wang <jasowang@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, eperezma@redhat.com,
        stefanha@redhat.com, netdev@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [RFC PATCH 0/6] vdpa_sim: add support for user VA
Date:   Wed, 14 Dec 2022 17:30:19 +0100
Message-Id: <20221214163025.103075-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.38.1
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds support for the use of user virtual addresses in the
vDPA simulator devices.

The main reason for this change is to lift the pinning of all guest memory.
Especially with virtio devices implemented in software.

The next step would be to generalize the code in vdpa-sim to allow the
implementation of in-kernel software devices. Similar to vhost, but using vDPA
so we can reuse the same software stack (e.g. in QEMU) for both HW and SW
devices.

For example, we have never merged vhost-blk, and lately there has been interest.
So it would be nice to do it directly with vDPA to reuse the same code in the
VMM for both HW and SW vDPA block devices.

The main problem (addressed by this series) was due to the pinning of all
guest memory, which thus prevented the overcommit of guest memory.

There are still some TODOs to be fixed, but I would like to have your feedback
on this RFC.

Thanks,
Stefano

Note: this series is based on Linux v6.1 + couple of fixes (that I needed to
run libblkio tests) already posted but not yet merged.

Tree available here: https://gitlab.com/sgarzarella/linux/-/tree/vdpa-sim-use-va

Stefano Garzarella (6):
  vdpa: add bind_mm callback
  vhost-vdpa: use bind_mm device callback
  vringh: support VA with iotlb
  vdpa_sim: make devices agnostic for work management
  vdpa_sim: use kthread worker
  vdpa_sim: add support for user VA

 drivers/vdpa/vdpa_sim/vdpa_sim.h     |   7 +-
 include/linux/vdpa.h                 |   8 +
 include/linux/vringh.h               |   5 +-
 drivers/vdpa/mlx5/core/resources.c   |   3 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c    |   2 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 132 +++++++++++++-
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |   6 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c |   6 +-
 drivers/vhost/vdpa.c                 |  22 +++
 drivers/vhost/vringh.c               | 250 +++++++++++++++++++++------
 10 files changed, 370 insertions(+), 71 deletions(-)

-- 
2.38.1

