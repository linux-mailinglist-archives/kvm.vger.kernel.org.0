Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA6A724399
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 15:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237969AbjFFNF2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 09:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238038AbjFFNFP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 09:05:15 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AE6F4
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 06:05:13 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-30c4775d05bso4510047f8f.2
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 06:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686056712; x=1688648712;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bLuEDIZcno8cTj1BzYY+tPPupVpKP/v0PeOotr1hL3g=;
        b=CCke+IQyaL1oZ2hRgzCpwSl1+0JvS/WdbKu6iTuQ69M2NVRvbuXBIitkQi0j6tg1hC
         zp/ivQWTnO0xWNjC3BlNlZBCniyZuvEeCAzy5ard0Z1EroavYM2dCTYijy7d7m3XhHr1
         ze1T5DYWlVPRr/noX30yUEuScU7WyPkhVgn8zJbn6X0jrxNfrb1bNyDPsa84U+LS40C6
         j8H9Sx1GZCckx62czuuhuoWGesEH9O/2e7/pYpU6NGiFjuZMDRF5NOB+n+3tm7opDzoc
         wvyXqok8x6CbHeLBhrrn2kbucKiee1D0S4n7B3MgzK2jJstXN2TfNl23/QVTvfp3bCIC
         /gSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686056712; x=1688648712;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bLuEDIZcno8cTj1BzYY+tPPupVpKP/v0PeOotr1hL3g=;
        b=isq05J/KbNZHau7F5YMbf1IWisDzTVRlgpl0bpRRhyvw+r/QlMpgmsqyJPBbLtpw0i
         TrBFHL159YDLcTXoMThfffQ31hjRsSDKOeIwnQFD2xCxwmQNgu31ZZ8paOaMA1sAQJSx
         Id4LC3JjkAW7cJIkjD9BZ0aW87moCAPLR5nvfd6IXy/uez1CImwC9ytxDf8cp3Blh+sg
         OBP4+f9a2+RzOgYtCMqH/B+a3hwN3ifNE0fZRBlaM9c01kxPEp6ycrDZNvGUdmEno+I2
         OFeMK28vYuu98ajFiAOpK5LXDOqVgOlHvl+hzHM1PQhzWNjnLp/+wlQmy9qFwOlQNMDm
         1G4g==
X-Gm-Message-State: AC+VfDx1pGihsRdzrSpRLeQbj5OxGm2GIDMCc4ab98HsrkHIBAqeqx6p
        7gRTp2i89tIMqOIY05u5V0yC3LD5Osd8LDAFe+lXbA==
X-Google-Smtp-Source: ACHHUZ6LWXesJDo5qGGCtpWCHoo32RZMiLpYBOMX9iTPBh+F0EZa13pCKYN7c+FvQlrM4kPye7+FEA==
X-Received: by 2002:adf:f512:0:b0:307:7f38:37f with SMTP id q18-20020adff512000000b003077f38037fmr1730637wro.66.1686056712343;
        Tue, 06 Jun 2023 06:05:12 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id h14-20020a5d504e000000b00300aee6c9cesm12636125wrt.20.2023.06.06.06.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 06:05:11 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     andre.przywara@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool v2 00/17] Fix vhost-net, scsi and vsock
Date:   Tue,  6 Jun 2023 14:04:09 +0100
Message-Id: <20230606130426.978945-1-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is version 2 of the vhost fixes for kvmtool posted here:
https://lore.kernel.org/all/20230419132119.124457-1-jean-philippe@linaro.org/

Since v1:
* Added review tags from Andre
* Fixed issues reported by Andre, and the max_target size found while
  rebasing patch 8
* Added patch 14 (warn and disable an unsupported configuration)

Jean-Philippe Brucker (17):
  virtio: Factor vhost initialization
  virtio/vhost: Factor vring operation
  virtio/vhost: Factor notify_vq_eventfd()
  virtio/vhost: Factor notify_vq_gsi()
  virtio/scsi: Move VHOST_SCSI_SET_ENDPOINT to device start
  virtio/scsi: Fix and simplify command-line
  disk/core: Fix segfault on exit with SCSI
  virtio/scsi: Initialize max_target
  virtio/scsi: Fix feature selection
  virtio/vsock: Fix feature selection
  virtio/net: Fix feature selection
  virtio: Document how to test the devices
  virtio: Fix messages about missing Linux config
  virtio/net: Warn about enabling multiqueue with vhost
  Factor epoll thread
  virtio/vhost: Support line interrupt signaling
  virtio/vhost: Clear VIRTIO_F_ACCESS_PLATFORM

 Makefile                     |   2 +
 Documentation/io-testing.txt | 141 +++++++++++++++++++++++
 include/kvm/disk-image.h     |   7 +-
 include/kvm/epoll.h          |  17 +++
 include/kvm/virtio.h         |  16 +++
 disk/core.c                  |  15 +--
 epoll.c                      |  91 +++++++++++++++
 ioeventfd.c                  |  94 +++-------------
 kvm-ipc.c                    | 103 +++++------------
 virtio/core.c                |   1 +
 virtio/net.c                 | 129 +++++----------------
 virtio/scsi.c                | 118 ++++++--------------
 virtio/vhost.c               | 209 +++++++++++++++++++++++++++++++++++
 virtio/vsock.c               | 134 +++++-----------------
 14 files changed, 611 insertions(+), 466 deletions(-)
 create mode 100644 Documentation/io-testing.txt
 create mode 100644 include/kvm/epoll.h
 create mode 100644 epoll.c
 create mode 100644 virtio/vhost.c

-- 
2.40.1

