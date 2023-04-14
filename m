Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3EA86E18FB
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 02:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbjDNA0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 20:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjDNA0d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 20:26:33 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE4540FD
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 17:26:01 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id w14so2459679qtv.13
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 17:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1681431960; x=1684023960;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AqiCSGbRn9fQNjLoKtsWJCL6VzfL/SXpL2kJq1LBwJY=;
        b=XKH+aecJClMmFZ/SeC2z779Hh6mM5IG879+Y0PuXEMAMz9DLNceMvYUDEhC6D+bzd0
         bvuixFg3uwX8YTtPhwBRsmOlRVr3OPraetw7DnoRKRHTX8Iq7K/GCo838uRXKFE2/fEb
         17dLLDUNtQjYRxfsn2L8zZ/EPfqdxO9bqpmpiaFz1rKdL10rE8xVpOzgHdGY0Dp/yHDn
         3lnbhSecgg91O9l2UasUz7ss8uFNi1NXA8C0fodCjXSPr5bK1Ga4KLRdlHVjnyQOLuZE
         bwnAU8uwQkdEKb/ZMOUu1LuFZm4ntaDTzVfsG6ie0Lj/K8QUOSSB3Lum3MonNrzMeovz
         xLPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681431960; x=1684023960;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AqiCSGbRn9fQNjLoKtsWJCL6VzfL/SXpL2kJq1LBwJY=;
        b=D8snLSMn/WNdRzp0hMJ6YpJKxWBqyfPPkJWKZjzDAqI5H3QPOQcZhjyA4hooysjaZ0
         rBhLb0v6XmBClAJ7HfGOwX6A0Hv507FQsBtTB2qu72dWkO6piNAB5iBoV6YvY/Y8SjLR
         BR6MN8qytVtyJ0YwvCCDQRJ3MSN/y8DBlMo158FXZz954CU1QOUg0LH7ks9dGhjSa2iD
         zrVn7GYgZGdXvsiDKk6EKz+3yABcfZswwNjyjGHeM9ODixJHMDBr8Idf0wYif10IYuVC
         0a79v7NAkiWSS42wq1D3VURIO1n8cRBtJfWdWsTX4+3139nudGtjNmhvc6usrGo/FuwF
         h1pA==
X-Gm-Message-State: AAQBX9dgwCH7dR0MrLJQVnuqnM5UOBp8Ji8x7I2lsb6xXNoi6UkSU0Qs
        c3m1R0Dkr0I5tjeOe9wUy+62nA==
X-Google-Smtp-Source: AKy350aMmG1PI/SAxDZ0aoArHhf4UHTRmaIdivxFvEH1IG83T+9nwiJAGZOS2MuQoGO1i6HztO01Xg==
X-Received: by 2002:a05:622a:249:b0:3e3:7ce1:e746 with SMTP id c9-20020a05622a024900b003e37ce1e746mr5845106qtx.15.1681431960570;
        Thu, 13 Apr 2023 17:26:00 -0700 (PDT)
Received: from [172.17.0.3] ([130.44.215.122])
        by smtp.gmail.com with ESMTPSA id a1-20020ac844a1000000b003eabcc29132sm309928qto.29.2023.04.13.17.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 17:26:00 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Subject: [PATCH RFC net-next v2 0/4] virtio/vsock: support datagrams
Date:   Fri, 14 Apr 2023 00:25:56 +0000
Message-Id: <20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJSdOGQC/z2NQQrCMBBFr1Jm7UBN0izcCh7ArbiYScc2iKlkS
 imU3t3ERZfvPx5/A5UcReHSbJBliRqnVMCcGggjpUEw9oXBtMa27myRHS46hTf2Q6YPWvbC5Mk
 76aBETCrImVIYa5ZkxiTrXNU3yyuu/68H3G/Xuh3+ue8/i5UPJ4wAAAA=
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
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
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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

This series first supports datagrams in a basic form for virtio, and
then optimizes the sendpath for all transports.

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

The device drops packets silently. There is room for improvement by
building into the device and driver some intelligence around how to
reduce frequency of kicking the virtqueue when packet loss is high. I
think there is a good discussion to be had on this.

In this series I am also proposing that fairness be reexamined as an
issue separate from datagrams, which differs from my previous series
that coupled these issues. After further testing and reflection on the
design, I do not believe that these need to be coupled and I do not
believe this implementation introduces additional unfairness or
exacerbates pre-existing unfairness.

I attempted to characterize vsock fairness by using a pool of processes
to stress test the shared resources while measuring the performance of a
lone stream socket. Given unfair preference for datagrams, we would
assume that a lone stream socket would degrade much more when a pool of
datagram sockets was stressing the system than when a pool of stream
sockets are stressing the system. The result, however, showed no
significant difference between the degradation of throughput of the lone
stream socket when using a pool of datagrams to stress the queue over
using a pool of streams. The absolute difference in throughput actually
favored datagrams as interfering least as the mean difference was +16%
compared to using streams to stress test (N=7), but it was not
statistically significant. Workloads were matched for payload size and
buffer size (to approximate memory consumption) and process count, and
stress workloads were configured to start before and last long after the
lifetime of the "lone" stream socket flow to ensure that competing flows
were continuously hot.

Given the above data, I propose that vsock fairness be addressed
independent of datagrams and to defer its implementation to a future
series.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
Bobby Eshleman (3):
      virtio/vsock: support dgram
      virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
      vsock: Add lockless sendmsg() support

Jiang Wang (1):
      tests: add vsock dgram tests

 drivers/vhost/vsock.c                   |  17 +-
 include/net/af_vsock.h                  |  20 ++-
 include/uapi/linux/virtio_vsock.h       |   2 +
 net/vmw_vsock/af_vsock.c                | 287 ++++++++++++++++++++++++++++----
 net/vmw_vsock/diag.c                    |  10 +-
 net/vmw_vsock/hyperv_transport.c        |  15 +-
 net/vmw_vsock/virtio_transport.c        |  10 +-
 net/vmw_vsock/virtio_transport_common.c | 221 ++++++++++++++++++++----
 net/vmw_vsock/vmci_transport.c          |  70 ++++++--
 tools/testing/vsock/util.c              | 105 ++++++++++++
 tools/testing/vsock/util.h              |   4 +
 tools/testing/vsock/vsock_test.c        | 193 +++++++++++++++++++++
 12 files changed, 859 insertions(+), 95 deletions(-)
---
base-commit: ed72bd5a6790a0c3747cb32b0427f921bd03bb71
change-id: 20230413-b4-vsock-dgram-3b6eba6a64e5

Best regards,
-- 
Bobby Eshleman <bobby.eshleman@bytedance.com>

