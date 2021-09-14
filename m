Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4467040A63B
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 07:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239889AbhINF4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 01:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239673AbhINF4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 01:56:36 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA75CC061574
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 22:55:19 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id w19so6738241pfn.12
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 22:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6P3Hg4gutReG5Sbg1AE6RT45vebLhTpUQQ0b1X0Vkms=;
        b=MTzR0KmUJ1q87fdNpZpMK9h6XXbkg3fNZXH1AdkDVsoU3folKJwrb7SxjpFephEJ+s
         Co9XYjV55zRvYYAZqUnw6dO4OMIo8ugxiV0uPZtcCDCHNYWlF++UvRgPoWrYlnf3+3U0
         3Anob837AbiXEBBpPm/SKtgL2qJkxWYS9phkXAGetq1PZCNQZPdzkCxIx5xxDuDLQxN8
         3CbGgvObm98SUG0bw9brVu0UgqOsKtB11gRlqpzemoPM4lmQHqmIVG9OWn0XkMSRb79W
         nFTzBA0FqXd/Kd+xCv1JFnHJkeax4Z+gFbP9DwSy2dC0cdz6pCuDHdB+g7eumCL2TwRJ
         0j3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6P3Hg4gutReG5Sbg1AE6RT45vebLhTpUQQ0b1X0Vkms=;
        b=wxFxeI+jj3f9B3PhUINXAME+IN490CxAaWkFb9qOpRKw7x6wZrF8EUW51XESJuZOcd
         D/N6XqC+hQ1zAqjubPQEq824i8MAybDxFgmE4ZN6rO8R4wSACkMw86wxrRTCZ8fm8urk
         UFrOyPxnnBH/xfyB0kzVXkPOsmcROObZ2CtCnjDOlNEWYQme4yVogbTNACsU2FehEYB5
         DzefF+Enr6EDZMqWGeo3x/FWE6Ex3eYEluyq8QSkrYaerxdz8rPYcS1kbOL8f5o3bkGK
         RP3A3nHCGsva8sHt4p0pL5DJzn7ZjDF2CDy1BxGK0//WUsuLK/Nr9t9Vu7m131L5bh9y
         y1JQ==
X-Gm-Message-State: AOAM531O4+CZRSGUDQEl7sNGtJGB1DhM0e4Ba9h2RSnVOgKQKV2965oU
        j/7JydH5DKrtcKUVcWBr9fHbVA==
X-Google-Smtp-Source: ABdhPJw5fb14z2YynodbTwMlTVY7BcqTzJq0/T4qCik4yyJ5qrktWf11pHZnIZuysBAmwYQb055O/Q==
X-Received: by 2002:aa7:9115:0:b029:359:69db:bc89 with SMTP id 21-20020aa791150000b029035969dbbc89mr3185623pfh.32.1631598919355;
        Mon, 13 Sep 2021 22:55:19 -0700 (PDT)
Received: from ip-10-124-121-13.byted.org (ec2-54-241-92-238.us-west-1.compute.amazonaws.com. [54.241.92.238])
        by smtp.gmail.com with ESMTPSA id v14sm719432pfi.111.2021.09.13.22.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 22:55:18 -0700 (PDT)
From:   Jiang Wang <jiang.wang@bytedance.com>
To:     jiangleetcode@gmail.com
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        sgarzare@redhat.com, mst@redhat.com, arseny.krasnov@kaspersky.com,
        jhansen@vmware.com, cong.wang@bytedance.com,
        duanxiongchun@bytedance.com, xieyongji@bytedance.com,
        chaiwen.cc@bytedance.com, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC v2 0/5] virtio/vsock: introduce SOCK_DGRAM support
Date:   Tue, 14 Sep 2021 05:54:33 +0000
Message-Id: <20210914055440.3121004-1-jiang.wang@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset implements support of SOCK_DGRAM for virtio
transport.

Datagram sockets are connectionless and unreliable. To avoid unfair contention
with stream and other sockets, add two more virtqueues and
a new feature bit to indicate if those two new queues exist or not.

Dgram does not use the existing credit update mechanism for
stream sockets. When sending from the guest/driver, sending packets
synchronously, so the sender will get an error when the virtqueue is full.
When sending from the host/device, send packets asynchronously
because the descriptor memory belongs to the corresponding QEMU
process.

The virtio spec patch is here:
https://www.mail-archive.com/virtualization@lists.linux-foundation.org/msg47457.html

For those who prefer git repo, here is the link for the linux kernel：
https://github.com/Jiang1155/linux/tree/vsock-dgram-v2

qemu patch link:
https://lists.gnu.org/archive/html/qemu-devel/2021-09/msg03462.html


To do:
1. use skb when receiving packets
2. support multiple transport
3. support mergeable rx buffer
4. support disabling F_STREAM feature bit


v1 -> v2 :
  - fix migration bug in vhost-vsock
  - rename some variables
  - clean up some code in virtio-vsock
  - use le_to_cpu16 in virtio-vsock



Jiang Wang (5):
  virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
  virtio/vsock: add support for virtio datagram
  vhost/vsock: add support for vhost dgram.
  vsock_test: add tests for vsock dgram
  virtio/vsock: add sysfs for rx buf len for dgram

 drivers/vhost/vsock.c                         | 220 +++++++--
 include/linux/virtio_vsock.h                  |   9 +
 include/net/af_vsock.h                        |   1 +
 .../events/vsock_virtio_transport_common.h    |   2 +
 include/uapi/linux/virtio_vsock.h             |   3 +
 net/vmw_vsock/af_vsock.c                      |  12 +
 net/vmw_vsock/virtio_transport.c              | 463 +++++++++++++++---
 net/vmw_vsock/virtio_transport_common.c       | 181 ++++++-
 tools/testing/vsock/util.c                    | 105 ++++
 tools/testing/vsock/util.h                    |   4 +
 tools/testing/vsock/vsock_test.c              | 195 ++++++++
 11 files changed, 1083 insertions(+), 112 deletions(-)

-- 
2.20.1

