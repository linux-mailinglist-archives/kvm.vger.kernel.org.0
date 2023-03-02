Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6F26A8127
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 12:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjCBLff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 06:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjCBLfZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 06:35:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE92E13D75
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 03:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677756869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VN5H8jXkUyi7b3gGlXy5t9+JY6Ep4JlnJplI0XClENQ=;
        b=TfyNVyTq0bd/Hsk9NFkWTNTl7hbnJNoRCbq0nZ5oChb+1pT0T1fNc1jbhC9JKFJ+eZ2Voo
        Zr32PHjmORyQTtSydm/+fwz8sCTxHrRo9PmU9URFujs4dQsoQIz5J/pR+KbZ/sqdkcRy4d
        h4PZFtoV3pyZnrJ26WG8qrbcbX4hDew=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-548-puFNze16Opu1MGxwQ7_aBw-1; Thu, 02 Mar 2023 06:34:28 -0500
X-MC-Unique: puFNze16Opu1MGxwQ7_aBw-1
Received: by mail-qt1-f197.google.com with SMTP id ga17-20020a05622a591100b003bfdf586476so6173026qtb.7
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 03:34:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677756868;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VN5H8jXkUyi7b3gGlXy5t9+JY6Ep4JlnJplI0XClENQ=;
        b=Dxn8TV8qFPF3nslN3Nrzb6H0dVM6qRbAJd6kUFsIO9vkyaJP8SbXhSHf++6AJF2lQc
         Hv6VI8cVvVs4hhszYlHnMDHqS4O0drSSE+5R52nzfLg8NEwQt6Qvwo0v5CVG3IenfHaP
         TZRqpg8dTIMVL6kjBXvzHrKu3Fv068in756M7XlElCiC9gpgMO8MJjutqb5oQdi2lO9P
         N216jh35uTfGzuDOtO2XOav/ORU6ykrsk28t4uXkOWncfg0oFDlkwbWYhjnL4CLawAYZ
         bSbTSJ7RmasNP/N1sYTT46fcwr8jJGU55/KVHlyGReipfEBgWU+0X+uLoOPECF3wvPaC
         sQqA==
X-Gm-Message-State: AO0yUKXZ3eHpc7V9Eee9ReD+JXPCa7QqqxHVwW3aFYAnkn1cUyv6gFFZ
        Y6ySnEqjZcqnOU16EQpYhxZfPDvbGGrFTF3p2GoaAL26n86mp6DXDY0WbFcCvwsXi2XJ8pVE8vm
        HxxJ5JxUYz/ZB
X-Received: by 2002:ac8:5784:0:b0:3b9:bd05:bde1 with SMTP id v4-20020ac85784000000b003b9bd05bde1mr17927061qta.8.1677756868185;
        Thu, 02 Mar 2023 03:34:28 -0800 (PST)
X-Google-Smtp-Source: AK7set/2/Vd4OA7axFE8KFaebdPNos2qTeW2fYUlVEyXvnFpPWZ0y0QARAa9MZDYbM3lH3FNvX4jMA==
X-Received: by 2002:ac8:5784:0:b0:3b9:bd05:bde1 with SMTP id v4-20020ac85784000000b003b9bd05bde1mr17927037qta.8.1677756867876;
        Thu, 02 Mar 2023 03:34:27 -0800 (PST)
Received: from step1.redhat.com (c-115-213.cust-q.wadsl.it. [212.43.115.213])
        by smtp.gmail.com with ESMTPSA id o12-20020ac8698c000000b003ba19e53e43sm10084156qtq.25.2023.03.02.03.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:34:27 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v2 0/8] vdpa_sim: add support for user VA
Date:   Thu,  2 Mar 2023 12:34:13 +0100
Message-Id: <20230302113421.174582-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2:
- rebased on Linus' tree, commit ae3419fbac84 ("vc_screen: don't clobber
  return value in vcs_read")
- removed `struct task_struct *owner` param (unused for now, maybe
  useful to support cgroups) [Jason]
- add unbind_mm callback [Jason]
- call the new unbind_mm callback during the release [Jason]
- avoid to call bind_mm callback after the reset, since the device
  is not detaching it now during the reset
- added new patch replace kmap_atomic() with kmap_local_page() since
  checkpatch.pl complained about deprecation of kmap_atomic() touched
  by a patch in this series
- fix cast warnings when build with W=1 C=1
- added new patch to replace the spinlock with a mutex [Jason]
- `use_va` set to true by default [Eugenio]
- supported the new unbind_mm callback [Jason]
- removed the unbind_mm call in vdpasim_do_reset() [Jason]
- avoided to release the lock while call kthread_flush_work() since
  we are now using a mutex to protect the device state

RFC v1: https://lore.kernel.org/lkml/20221214163025.103075-1-sgarzare@redhat.com/

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

Thanks,
Stefano

Stefano Garzarella (8):
  vdpa: add bind_mm/unbind_mm callbacks
  vhost-vdpa: use bind_mm/unbind_mm device callbacks
  vringh: replace kmap_atomic() with kmap_local_page()
  vringh: support VA with iotlb
  vdpa_sim: make devices agnostic for work management
  vdpa_sim: use kthread worker
  vdpa_sim: replace the spinlock with a mutex to protect the state
  vdpa_sim: add support for user VA

 drivers/vdpa/vdpa_sim/vdpa_sim.h     |  11 +-
 include/linux/vdpa.h                 |  10 ++
 include/linux/vringh.h               |   5 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c    |   2 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 160 ++++++++++++++---
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  10 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  10 +-
 drivers/vhost/vdpa.c                 |  30 ++++
 drivers/vhost/vringh.c               | 247 +++++++++++++++++++++------
 9 files changed, 395 insertions(+), 90 deletions(-)

-- 
2.39.2

