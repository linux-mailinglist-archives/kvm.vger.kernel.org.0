Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424F36E7AAB
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbjDSN1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbjDSN1q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:27:46 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F028430D4
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:44 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id ay3-20020a05600c1e0300b003f17289710aso1428021wmb.5
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681910863; x=1684502863;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kkkrGlU9guI0JvyD1T54QsTpahgEat/z1jkPIGHCfN4=;
        b=o30beV+jrmTwRJr1WMeQHULYfzQstzX18mq4baNeZpNbC4t1aFeeGw2XCvNrMwXIcg
         GUe6PKsMKZFz+H6Ym9YQI570jngeI5sGSR6MW7FoTYlmyckrdrt5v2Y2tomrBzotIK0G
         HepxX1bEzoYurneXhiTt+ELYg70YHNTZPtfJGahPzDh9+HPsXAxtrIoykN25J62MJVSw
         /8sGXeO/qnmT7fPNTOLj3wsD1rHIvPs/+fCk3cl+4ylSF/1B+UWz8e9+U1x3+JHJQd6m
         /jLJZsvg2wMMpawvYCrErb7pJExkIPL8G5mMArmwle0bbBmiVLDIhXs972a8q1W/QT8I
         hZGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681910863; x=1684502863;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kkkrGlU9guI0JvyD1T54QsTpahgEat/z1jkPIGHCfN4=;
        b=gAviWKXrcotM0WjshsHKdBBLZS+6QQ+Jmiid8VmnVs5Ao6VFdWK7SOx7dCMyByGWBc
         zGkYfDD1TnQrvP0J4KZe4530Qy5riCAcmSJykpQFIXXfNKvUCxrj5uo59gy4D6XgRrgO
         e4l2aMwixqxPjQ73YSpbAPJP+WZNvO0hL5PGll5evuT/87mc/WnhZAERwZP7rUvrOKcH
         UBOroytQr9A8lw1NK/z4/jtBvuc1qDxsX+zD+bNdQRK7qyaQpCYZFnomnxb0AXftqy+e
         fhymgJuKM9rGnqflC1qjBDUIk14SHo5/nwEFjgyZtTIRgNn7Aq+NFFDilds0+cBXzrGx
         ngFQ==
X-Gm-Message-State: AAQBX9dJ22ZIs5yIXOgf4jzn5UDJH6CJcAan6oXhpCFPoEdF8mS8xkHw
        GYZ1EgCEJ4vODRcZinOFP3nd476y7Ox87xd/3Do=
X-Google-Smtp-Source: AKy350aH4C3Cyuv9WMEgbdNXuzWtyqCljZ03/lZj/BA5xTGEwgqGc+xqiXukC4JMEqcy1q1dPZumgw==
X-Received: by 2002:a7b:c417:0:b0:3f1:70e8:c1ac with SMTP id k23-20020a7bc417000000b003f170e8c1acmr9664781wmi.8.1681910863290;
        Wed, 19 Apr 2023 06:27:43 -0700 (PDT)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b003f1738d0d13sm3497017wmq.1.2023.04.19.06.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:27:42 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     suzuki.poulose@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 00/16] Fix vhost-net, scsi and vsock
Date:   Wed, 19 Apr 2023 14:21:04 +0100
Message-Id: <20230419132119.124457-1-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.0
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

Kvmtool supports the three kernel vhost devices, but since they are not
trivial to test, that support has not followed kvmtool core changes over
time and is now severely broken. Restore vhost support to its former glory.

Patches 1-4 introduce virtio/vhost.c to gather common operations, and
patches 5-11 finish fixing the vhost devices.

Patch 12 adds documentation about testing all virtio devices, so that
vhost support can be kept up to date more easily in the future. 

Patches 13-16 add support for vhost when the device does not use MSIs
(virtio-mmio or virtio-pci without a MSI-capable irqchip). That's only
nice to have, but is easy enough to implement.

Patch 17 documents and fixes a possible issue which will appear when
enabling CCA or pKVM.

Jean-Philippe Brucker (16):
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
  Factor epoll thread
  virtio/vhost: Support line interrupt signaling
  virtio/vhost: Clear VIRTIO_F_ACCESS_PLATFORM

 Makefile                     |   2 +
 Documentation/io-testing.txt | 141 +++++++++++++++++++++++
 include/kvm/disk-image.h     |   7 +-
 include/kvm/epoll.h          |  17 +++
 include/kvm/virtio.h         |  16 +++
 disk/core.c                  |  15 +--
 epoll.c                      |  89 +++++++++++++++
 ioeventfd.c                  |  94 +++-------------
 kvm-ipc.c                    | 103 +++++------------
 virtio/core.c                |   1 +
 virtio/net.c                 | 120 +++-----------------
 virtio/scsi.c                | 118 ++++++--------------
 virtio/vhost.c               | 209 +++++++++++++++++++++++++++++++++++
 virtio/vsock.c               | 134 +++++-----------------
 14 files changed, 602 insertions(+), 464 deletions(-)
 create mode 100644 Documentation/io-testing.txt
 create mode 100644 include/kvm/epoll.h
 create mode 100644 epoll.c
 create mode 100644 virtio/vhost.c

-- 
2.40.0

