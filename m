Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695B6758A36
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 02:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjGSAui (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 20:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjGSAug (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 20:50:36 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4EC13E
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 17:50:10 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id d75a77b69052e-403e7472b28so20684421cf.2
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 17:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1689727809; x=1692319809;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g4MQh0GVYvXxrf88kEVfj3RWJKvjT6rBvWGaToebS1k=;
        b=OlP5EF+DSJN59SkgdI1UB5eOS4em/1xb1WNYdfgYt2Ukkjivjm+QbZj65DjHzNYEyI
         QqIAVHDlSwzvNIMiBTfgbHTKBSZcgGY15vdPnsO9PLqnscYrYHchHIhlFLeibW6jejsZ
         dvyNtltzAvm8e3K49GaTAs/0qElRdNwn7qFGc4P+0Xzw6n746bakT/97EoDhZqkzDjbG
         F80kiMG6yPyD/JHuq+ejdvIj6wfg6lEFKl4ldHJHejg/bTLxA0CsA8YLiQFrhZ3yvinl
         e3AVdlCq6NRI5Rai+WUijlbOZNiluE/zuHqd2kOcGLJ+nJKAqlGjmaAcQRcpR5Wk1yCL
         d6/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689727809; x=1692319809;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g4MQh0GVYvXxrf88kEVfj3RWJKvjT6rBvWGaToebS1k=;
        b=lRAkevUbXJ0iXjZd8K0WLaePdwHW7Ybotv1Tiju0pKphiGvd2//iIOFrp/IPg82J+9
         3RY9uFROo1MUaFpRO2091HvNnwBDOqUs4Kc3S3MRGu6CjmQ5jwpXeUSVrFvZiD0L0TNn
         szI+uDUxZAlYz6k+JZjMtggU55DNELWcvhM7vvmOVotRdg6/4FN+QfBIKAOLsStOuZ/I
         Y9tlRwhFs3dir5UgdI4STRV2PCBvxaqdcjXUVSuRwf3BYxPTjusoaSFZ1W0lRymXX1Z3
         tv8SMFGUFMN0I7cEM272DjKMAkSyyZDdt67qDscdAyiEA8zmsQTUlrnNeu1taX1pxXHc
         Sitg==
X-Gm-Message-State: ABy/qLbBa5AOVBTNu4AwmlrZCNMAruKRFSMjV9fUZff0JzSCFfPFKimY
        gN3pRvlSHfPi4SFERZ0fd1hBfw==
X-Google-Smtp-Source: APBJJlFOdkeHFj6qm5QEEQlrf3UOfope2+h9d9vn4lyQAeDaZ7bAUYWfgXAYgxBXdf2oWu12n4kSdw==
X-Received: by 2002:ac8:5f0b:0:b0:404:e41c:616f with SMTP id x11-20020ac85f0b000000b00404e41c616fmr151778qta.68.1689727809469;
        Tue, 18 Jul 2023 17:50:09 -0700 (PDT)
Received: from [172.17.0.7] ([130.44.212.112])
        by smtp.gmail.com with ESMTPSA id c5-20020a05620a11a500b0076738337cd1sm968696qkk.1.2023.07.18.17.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 17:50:08 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Subject: [PATCH RFC net-next v5 00/14] virtio/vsock: support datagrams
Date:   Wed, 19 Jul 2023 00:50:04 +0000
Message-Id: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADwzt2QC/32OwQrCMBBEf6Xk7EpNY2s9CYIf4FU8ZNPRBmkqS
 QmK9N9Ne/Ag6HF2dt7MSwR4iyC22Ut4RBts75JYLzJhWu2uINskLWQui1ytCmJFMfTmRs3V644
 KLsG61KXCWqQQ6wBir51pp5jDQA6PYbLuHhf7mLtO4njYT7ePf06itWHo/XPeEuX89qs2Ssopr
 2pjKgOUEjt+DmhSLZam72ZcVP8RakIYMLPU2NT1N2Icxzf/7ETBHwEAAA==
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc:     Dan Carpenter <dan.carpenter@linaro.org>,
        Simon Horman <simon.horman@corigine.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        bpf@vger.kernel.org, Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey all!

This series introduces support for datagrams to virtio/vsock.

It is a spin-off (and smaller version) of this series from the summer:
  https://lore.kernel.org/all/cover.1660362668.git.bobby.eshleman@bytedance.com/

Please note that this is an RFC and should not be merged until
associated changes are made to the virtio specification, which will
follow after discussion from this series.

Another aside, the v4 of the series has only been mildly tested with a
run of tools/testing/vsock/vsock_test. Some code likely needs cleaning
up, but I'm hoping to get some of the design choices agreed upon before
spending too much time making it pretty.

This series first supports datagrams in a basic form for virtio, and
then optimizes the sendpath for all datagram transports.

The result is a very fast datagram communication protocol that
outperforms even UDP on multi-queue virtio-net w/ vhost on a variety
of multi-threaded workload samples.

For those that are curious, some summary data comparing UDP and VSOCK
DGRAM (N=5):

	vCPUS: 16
	virtio-net queues: 16
	payload size: 4KB
	Setup: bare metal + vm (non-nested)

	UDP: 287.59 MB/s
	VSOCK DGRAM: 509.2 MB/s

Some notes about the implementation...

This datagram implementation forces datagrams to self-throttle according
to the threshold set by sk_sndbuf. It behaves similar to the credits
used by streams in its effect on throughput and memory consumption, but
it is not influenced by the receiving socket as credits are.

The device drops packets silently.

As discussed previously, this series introduces datagrams and defers
fairness to future work. See discussion in v2 for more context around
datagrams, fairness, and this implementation.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
Changes in v5:
- teach vhost to drop dgram when a datagram exceeds the receive buffer
  - now uses MSG_ERRQUEUE and depends on Arseniy's zerocopy patch:
	"vsock: read from socket's error queue"
- replace multiple ->dgram_* callbacks with single ->dgram_addr_init()
  callback
- refactor virtio dgram skb allocator to reduce conflicts w/ zerocopy series
- add _fallback/_FALLBACK suffix to dgram transport variables/macros
- add WARN_ONCE() for table_size / VSOCK_HASH issue
- add static to vsock_find_bound_socket_common
- dedupe code in vsock_dgram_sendmsg() using module_got var
- drop concurrent sendmsg() for dgram and defer to future series
- Add more tests
  - test EHOSTUNREACH in errqueue
  - test stream + dgram address collision
- improve clarity of dgram msg bounds test code
- Link to v4: https://lore.kernel.org/r/20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com

Changes in v4:
- style changes
  - vsock: use sk_vsock(vsk) in vsock_dgram_recvmsg instead of
    &sk->vsk
  - vsock: fix xmas tree declaration
  - vsock: fix spacing issues
  - virtio/vsock: virtio_transport_recv_dgram returns void because err
    unused
- sparse analysis warnings/errors
  - virtio/vsock: fix unitialized skerr on destroy
  - virtio/vsock: fix uninitialized err var on goto out
  - vsock: fix declarations that need static
  - vsock: fix __rcu annotation order
- bugs
  - vsock: fix null ptr in remote_info code
  - vsock/dgram: make transport_dgram a fallback instead of first
    priority
  - vsock: remove redundant rcu read lock acquire in getname()
- tests
  - add more tests (message bounds and more)
  - add vsock_dgram_bind() helper
  - add vsock_dgram_connect() helper

Changes in v3:
- Support multi-transport dgram, changing logic in connect/bind
  to support VMCI case
- Support per-pkt transport lookup for sendto() case
- Fix dgram_allow() implementation
- Fix dgram feature bit number (now it is 3)
- Fix binding so dgram and connectible (cid,port) spaces are
  non-overlapping
- RCU protect transport ptr so connect() calls never leave
  a lockless read of the transport and remote_addr are always
  in sync
- Link to v2: https://lore.kernel.org/r/20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com

---
Bobby Eshleman (13):
      af_vsock: generalize vsock_dgram_recvmsg() to all transports
      af_vsock: refactor transport lookup code
      af_vsock: support multi-transport datagrams
      af_vsock: generalize bind table functions
      af_vsock: use a separate dgram bind table
      virtio/vsock: add VIRTIO_VSOCK_TYPE_DGRAM
      virtio/vsock: add common datagram send path
      af_vsock: add vsock_find_bound_dgram_socket()
      virtio/vsock: add common datagram recv path
      virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
      vhost/vsock: implement datagram support
      vsock/loopback: implement datagram support
      virtio/vsock: implement datagram support

Jiang Wang (1):
      test/vsock: add vsock dgram tests

 drivers/vhost/vsock.c                   |  64 ++-
 include/linux/virtio_vsock.h            |  10 +-
 include/net/af_vsock.h                  |  14 +-
 include/uapi/linux/virtio_vsock.h       |   2 +
 net/vmw_vsock/af_vsock.c                | 281 ++++++++++---
 net/vmw_vsock/hyperv_transport.c        |  13 -
 net/vmw_vsock/virtio_transport.c        |  26 +-
 net/vmw_vsock/virtio_transport_common.c | 190 +++++++--
 net/vmw_vsock/vmci_transport.c          |  60 +--
 net/vmw_vsock/vsock_loopback.c          |  10 +-
 tools/testing/vsock/util.c              | 141 ++++++-
 tools/testing/vsock/util.h              |   6 +
 tools/testing/vsock/vsock_test.c        | 680 ++++++++++++++++++++++++++++++++
 13 files changed, 1320 insertions(+), 177 deletions(-)
---
base-commit: 37cadc266ebdc7e3531111c2b3304fa01b2131e8
change-id: 20230413-b4-vsock-dgram-3b6eba6a64e5

Best regards,
-- 
Bobby Eshleman <bobby.eshleman@bytedance.com>

