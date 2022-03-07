Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF6234CFCC7
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 12:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238300AbiCGL1b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 06:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236404AbiCGL1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 06:27:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F0A4A4B406
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 03:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646651022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=gNPPt7IcCgazViAJnPdJB9z9Owb+g+PUdYAZ9hinRqk=;
        b=V/Kot64+pJmhaGIV+uTpQRskZ1NbErh8D7kNb4orWTioIVOKo8/tHXV2bUJOh3oxpAbm47
        bcpV6iEGniSk6ASo+LqHDiKmC/CUkQpZ9KeJ4pgXibb33gmYuXF9Y6HoPmAU9F8jDcBj4M
        AdG1sCO+cwVVM5W06E310MCTJnL1ack=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-c4fxPisnMjGYuPer6M5Vzg-1; Mon, 07 Mar 2022 06:03:41 -0500
X-MC-Unique: c4fxPisnMjGYuPer6M5Vzg-1
Received: by mail-ed1-f69.google.com with SMTP id l8-20020a056402028800b0041636072ef0so2366537edv.13
        for <kvm@vger.kernel.org>; Mon, 07 Mar 2022 03:03:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=gNPPt7IcCgazViAJnPdJB9z9Owb+g+PUdYAZ9hinRqk=;
        b=EYeHWzMJbHM4teO3k+sxIiiYcylvM2ds7V2OH6XLPaWIfPgGQHtlMF5NBUa5gh/VTM
         coErRCurm8maGLdsFFNAarPP21RQdB0yWPn9AtQ3oNVipMf/666Sis+kQdAiZFTdpae9
         VN6hehVg7PH9UeAltAtooG83sO+PwagKsPixCpx+SjtgCetguyFM4+JYddXm7wBvPqSa
         RMWe4mPanELYJiIvPYdOWgrY4i4UIgPPETuM8W6CpKs4duqyunTaVKQMvlCBlGC6l1rL
         V/uqnuoybgnTd+JS0o8fOa5WiIubOGHyBhXxnouZpofTj0pvhs6+DJRqu8Etwxt0+HDr
         Mhaw==
X-Gm-Message-State: AOAM530f7xUxKgrvicaURl0sXiR881Io7s697yr5sTc+rlYgnh+4Ub5y
        XQY2symy64KyhSyo7UsB3waeenTP0GveFKAjOoCCPtT4m4tYXjxv6srEEVr7SgTXPFM5KCzBIQl
        ysPenJxzaagNK
X-Received: by 2002:a05:6402:1e91:b0:415:ecdb:bb42 with SMTP id f17-20020a0564021e9100b00415ecdbbb42mr10485775edf.367.1646651017437;
        Mon, 07 Mar 2022 03:03:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzm045HAXHomDdQ4eh2BMpTcblB2cVV+JVDBoNGC3+rpUKylFjFOJZk78RZ+xJFhn3Hw+5UaQ==
X-Received: by 2002:a05:6402:1e91:b0:415:ecdb:bb42 with SMTP id f17-20020a0564021e9100b00415ecdbbb42mr10485752edf.367.1646651017235;
        Mon, 07 Mar 2022 03:03:37 -0800 (PST)
Received: from redhat.com ([2.55.138.228])
        by smtp.gmail.com with ESMTPSA id er12-20020a056402448c00b00413d03ac4a2sm5718316edb.69.2022.03.07.03.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 03:03:36 -0800 (PST)
Date:   Mon, 7 Mar 2022 06:03:32 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, david@redhat.com, jasowang@redhat.com,
        lkp@intel.com, mail@anirudhrb.com, mst@redhat.com,
        pasic@linux.ibm.com, sgarzare@redhat.com, si-wei.liu@oracle.com,
        stable@vger.kernel.org,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        wang.yi59@zte.com.cn, xieyongji@bytedance.com,
        zhang.min9@zte.com.cn
Subject: [GIT PULL] virtio: last minute fixes
Message-ID: <20220307060332-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 7e57714cd0ad2d5bb90e50b5096a0e671dec1ef3:

  Linux 5.17-rc6 (2022-02-27 14:36:33 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 3dd7d135e75cb37c8501ba02977332a2a487dd39:

  tools/virtio: handle fallout from folio work (2022-03-06 06:06:50 -0500)

----------------------------------------------------------------
virtio: last minute fixes

Some fixes that took a while to get ready. Not regressions,
but they look safe and seem to be worth to have.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Anirudh Rayabharam (1):
      vhost: fix hung thread due to erroneous iotlb entries

Michael S. Tsirkin (6):
      virtio: unexport virtio_finalize_features
      virtio: acknowledge all features before access
      virtio: document virtio_reset_device
      virtio_console: break out of buf poll on remove
      virtio: drop default for virtio-mem
      tools/virtio: handle fallout from folio work

Si-Wei Liu (3):
      vdpa: factor out vdpa_set_features_unlocked for vdpa internal use
      vdpa/mlx5: should verify CTRL_VQ feature exists for MQ
      vdpa/mlx5: add validation for VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET command

Stefano Garzarella (2):
      vhost: remove avail_event arg from vhost_update_avail_event()
      tools/virtio: fix virtio_test execution

Xie Yongji (3):
      vduse: Fix returning wrong type in vduse_domain_alloc_iova()
      virtio-blk: Don't use MAX_DISCARD_SEGMENTS if max_discard_seg is zero
      virtio-blk: Remove BUG_ON() in virtio_queue_rq()

Zhang Min (1):
      vdpa: fix use-after-free on vp_vdpa_remove

 drivers/block/virtio_blk.c           | 20 ++++++-------
 drivers/char/virtio_console.c        |  7 +++++
 drivers/vdpa/mlx5/net/mlx5_vnet.c    | 34 ++++++++++++++++++++--
 drivers/vdpa/vdpa.c                  |  2 +-
 drivers/vdpa/vdpa_user/iova_domain.c |  2 +-
 drivers/vdpa/virtio_pci/vp_vdpa.c    |  2 +-
 drivers/vhost/iotlb.c                | 11 +++++++
 drivers/vhost/vdpa.c                 |  2 +-
 drivers/vhost/vhost.c                |  9 ++++--
 drivers/virtio/Kconfig               |  1 -
 drivers/virtio/virtio.c              | 56 ++++++++++++++++++++++++------------
 drivers/virtio/virtio_vdpa.c         |  2 +-
 include/linux/vdpa.h                 | 18 ++++++++----
 include/linux/virtio.h               |  1 -
 include/linux/virtio_config.h        |  3 +-
 tools/virtio/linux/mm_types.h        |  3 ++
 tools/virtio/virtio_test.c           |  1 +
 17 files changed, 127 insertions(+), 47 deletions(-)
 create mode 100644 tools/virtio/linux/mm_types.h

