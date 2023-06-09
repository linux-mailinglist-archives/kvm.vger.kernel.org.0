Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B4F729FF8
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 18:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242103AbjFIQSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 12:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241934AbjFIQSa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 12:18:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3A835BE
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 09:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686327462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=4M45gRnQ1u7hqy31r1Lf6wTaxv13BKes8mPSZrcPv2Y=;
        b=HV8dNv+jPAed3700iHy5eSGN4NcvCEDkrJVDpdFW2/Ff+kGFknl9FIaIF1DacB9XKSvy52
        XAvnW4ov4YL/EgJdnvnXOk2hm4jZULWIynXSzWUW4turBi+f9A8fqeFJFRGEXYLj2Os0kr
        iCYils6zuF4ZvL8Qef2pBaSl2JldrYg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-CypYzccEPiu3eBxON28_oA-1; Fri, 09 Jun 2023 12:17:41 -0400
X-MC-Unique: CypYzccEPiu3eBxON28_oA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-30793c16c78so2550456f8f.3
        for <kvm@vger.kernel.org>; Fri, 09 Jun 2023 09:17:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686327460; x=1688919460;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4M45gRnQ1u7hqy31r1Lf6wTaxv13BKes8mPSZrcPv2Y=;
        b=jV2l2nJEIGNZlEL349yiGGUcQJr0v7OKpZ0gjfvjvBcH0oR7gq7WsdaJ5Q3IS06pEd
         3Hz997+EWSPF1hHRecf5w/ygkjWv+170gqZDDT4onwKP/o5Oy4clRkn/pH103req5CSL
         6crsIaie6UsjPv68K4i/mLaQ2vndQ03o3r1IcJ4gLvEWg6m8mytQfA19RBvvPuCa7p8Y
         5R/+E6aN9cOQ0dM0JBxHJczQ435hYdXOdxkM4ghZS3gHefIrl6y8NqLpp6bTec6mxG9O
         ojGxXc/+FMB0MJC35dnwQDKok+Ri3oCd0JkCvxJCHwIKscy6c0EcftUVB4bLUPUnxFqM
         yPXw==
X-Gm-Message-State: AC+VfDwcKwASUHBdenj+sJr7hBdTfJphMdZTh0LmjqsQA/q0NxoNYejy
        JohZ6lJ1x9+5c2OaClHnTB83Lz2U1LHNj8jgIf56uiB1V0kzghleL8E5NXyrKPS54pg2OYRL+Kl
        mfJ80Z6MaOXFy
X-Received: by 2002:adf:e110:0:b0:307:2d0c:4036 with SMTP id t16-20020adfe110000000b003072d0c4036mr1422044wrz.66.1686327460472;
        Fri, 09 Jun 2023 09:17:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5MwccKZqMZmmQAMpaztP78KxQ/TadfL/ac1dUpnVsjT6zjT2OgsfcKy47axrXbgo+oojXt4w==
X-Received: by 2002:adf:e110:0:b0:307:2d0c:4036 with SMTP id t16-20020adfe110000000b003072d0c4036mr1422026wrz.66.1686327460126;
        Fri, 09 Jun 2023 09:17:40 -0700 (PDT)
Received: from redhat.com ([2a06:c701:7403:2800:22a6:7656:500:4dab])
        by smtp.gmail.com with ESMTPSA id u12-20020a5d6acc000000b003062b6a522bsm4864763wrw.96.2023.06.09.09.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 09:17:39 -0700 (PDT)
Date:   Fri, 9 Jun 2023 12:17:37 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        asmetanin@yandex-team.ru, dtatulea@nvidia.com, jasowang@redhat.com,
        michael.christie@oracle.com, mst@redhat.com,
        prathubaronia2011@gmail.com, rongtao@cestc.cn,
        shannon.nelson@amd.com, sheng.zhao@bytedance.com,
        syzbot+d0d442c22fa8db45ff0e@syzkaller.appspotmail.com,
        xieyongji@bytedance.com, zengxianjun@bytedance.com,
        zwisler@chromium.org, zwisler@google.com
Subject: [GIT PULL] virtio,vhost,vdpa: bugfixes
Message-ID: <20230609121737-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 9561de3a55bed6bdd44a12820ba81ec416e705a7:

  Linux 6.4-rc5 (2023-06-04 14:04:27 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 07496eeab577eef1d4912b3e1b502a2b52002ac3:

  tools/virtio: use canonical ftrace path (2023-06-09 12:08:08 -0400)

----------------------------------------------------------------
virtio,vhost,vdpa: bugfixes

A bunch of fixes all over the place

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Andrey Smetanin (1):
      vhost_net: revert upend_idx only on retriable error

Dragos Tatulea (1):
      vdpa/mlx5: Fix hang when cvq commands are triggered during device unregister

Mike Christie (2):
      vhost: Fix crash during early vhost_transport_send_pkt calls
      vhost: Fix worker hangs due to missed wake up calls

Prathu Baronia (1):
      vhost: use kzalloc() instead of kmalloc() followed by memset()

Rong Tao (2):
      tools/virtio: Fix arm64 ringtest compilation error
      tools/virtio: Add .gitignore for ringtest

Ross Zwisler (1):
      tools/virtio: use canonical ftrace path

Shannon Nelson (3):
      vhost_vdpa: tell vqs about the negotiated
      vhost: support PACKED when setting-getting vring_base
      vhost_vdpa: support PACKED when setting-getting vring_base

Sheng Zhao (1):
      vduse: avoid empty string for dev name

 drivers/vdpa/mlx5/net/mlx5_vnet.c       |  2 +-
 drivers/vdpa/vdpa_user/vduse_dev.c      |  3 ++
 drivers/vhost/net.c                     | 11 +++--
 drivers/vhost/vdpa.c                    | 34 +++++++++++++--
 drivers/vhost/vhost.c                   | 75 +++++++++++++++------------------
 drivers/vhost/vhost.h                   | 10 +++--
 kernel/vhost_task.c                     | 18 ++++----
 tools/virtio/ringtest/.gitignore        |  7 +++
 tools/virtio/ringtest/main.h            | 11 +++++
 tools/virtio/virtio-trace/README        |  2 +-
 tools/virtio/virtio-trace/trace-agent.c | 12 ++++--
 11 files changed, 120 insertions(+), 65 deletions(-)
 create mode 100644 tools/virtio/ringtest/.gitignore

