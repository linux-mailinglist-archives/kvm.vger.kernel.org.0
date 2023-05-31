Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A2571728F
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 02:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbjEaAgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 20:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233621AbjEaAgM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 20:36:12 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8E5E4F
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 17:35:19 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-64d4e4598f0so5744755b3a.2
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 17:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685493308; x=1688085308;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xyPVmcVtXqwbPWrU4CXncdNHyJXf/QZjqVsNgbEPnro=;
        b=M/Ht7dI5kR7S3Pp3LWf8jzAkFhfNDqeCqkoON2LR0mY0zoEnUOpxlPGclMHY+tIK6r
         4rEvtdl/EVqdTwzEhhakEXmpdKpY0MNeWy20XfvXiVYey9c7KY+gdRqF1tE2VM3BqcDp
         wxKnTvZpQueVv6yzT1BT3Aq71eK4sURh//HAR4aGbU2uMrHm1anjx9o4t9eDYJRbYqRX
         EeAxKbe2diiLhXCQDd8zbMMOk3BiWnTJ4KfK4FipReZMzakVgdbTXp/k1reL4ruAquw/
         nwdrUBUhomZSb6kgdQ9rQ3cFY7SJa3/xFEN9nCfYfaySK3RtPLXeD6pNrtLQrio8toqT
         xF/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685493308; x=1688085308;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xyPVmcVtXqwbPWrU4CXncdNHyJXf/QZjqVsNgbEPnro=;
        b=hAY2sLvCgeEiDA81B+Oz0p79wsYrP0agiBOe7y3czZ+JKNVlfxYz93EdL5woiQX1P5
         0FY58pXLkMfZ7jCRSvNPuhWhZ+jCSmXQwZikEVV/qWZypGNSNBW83bapPyCB2CnCp6pQ
         EoQ9p4C7o7OZUtzud+rWEbuyEcTI8W4A/CWw5bHbBoAjLMe1IbtSR0e+CrcP9+Xh8/e6
         cAnNluH1FVOPuEb6KUCJSKSABxfFLXigpQTsN4qqdeCMqn2iNgMtpaEDR5Nw/qH/Kgz5
         jWXj5uldVPQOQYuNODx8VbnLKS41DGLDARQs6pQRr5JXc+56ZN2N7mpkck1VgnYBh6so
         pdeA==
X-Gm-Message-State: AC+VfDxTYpyQVsZ4dwblMi8lHI5XTuSVVTScR56xnnSwSI3mlfUInJPc
        qy44RyEW75lNihC1mvlulbWXx0i38mfUVqgagc1t3w==
X-Google-Smtp-Source: ACHHUZ7F9nwTmBBAljcZs+/hqk8QS+6xsOVMmtuise4Li18N+hL7dowP5Ri0jqFjV8J1ovTm+x2g5Q==
X-Received: by 2002:a05:6a00:b50:b0:64c:a554:f577 with SMTP id p16-20020a056a000b5000b0064ca554f577mr4877926pfo.11.1685493308503;
        Tue, 30 May 2023 17:35:08 -0700 (PDT)
Received: from [172.17.0.2] (c-67-170-131-147.hsd1.wa.comcast.net. [67.170.131.147])
        by smtp.gmail.com with ESMTPSA id j12-20020a62b60c000000b0064cb0845c77sm2151340pff.122.2023.05.30.17.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 17:35:08 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Subject: [PATCH RFC net-next v3 0/8] virtio/vsock: support datagrams
Date:   Wed, 31 May 2023 00:35:04 +0000
Message-Id: <20230413-b4-vsock-dgram-v3-0-c2414413ef6a@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADiWdmQC/3WOQQrCMBBFryKzdiQmNUVXguAB3EoXSTq2QZpIE
 kJL6d1Nu3Dn8s3/nzczRAqWIlx2MwTKNlrvCoj9DkyvXEdo28LAGResOgrUFebozRvbLqgBhZa
 klVSyohOUkVaRUAflTL/OHCV0NKY1+gR62XFzPeFxv623X94U6G1MPkzbL5lvtX/azJEhq8/G1
 IZIcrrqKVFbtHQwfoBmWZYvsS2PotwAAAA=
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

The device drops packets silently.

As discussed previously, this series introduces datagrams and defers
fairness to future work. See discussion in v2 for more context around
datagrams, fairness, and this implementation.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
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
Bobby Eshleman (7):
      vsock/dgram: generalize recvmsg and drop transport->dgram_dequeue
      vsock: refactor transport lookup code
      vsock: support multi-transport datagrams
      vsock: make vsock bind reusable
      virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
      virtio/vsock: support dgrams
      vsock: Add lockless sendmsg() support

Jiang Wang (1):
      tests: add vsock dgram tests

 drivers/vhost/vsock.c                   |  44 ++-
 include/linux/virtio_vsock.h            |  13 +-
 include/net/af_vsock.h                  |  53 ++-
 include/uapi/linux/virtio_vsock.h       |   2 +
 net/vmw_vsock/af_vsock.c                | 615 ++++++++++++++++++++++++++------
 net/vmw_vsock/diag.c                    |  10 +-
 net/vmw_vsock/hyperv_transport.c        |  42 ++-
 net/vmw_vsock/virtio_transport.c        |  28 +-
 net/vmw_vsock/virtio_transport_common.c | 227 +++++++++---
 net/vmw_vsock/vmci_transport.c          | 152 ++++----
 net/vmw_vsock/vsock_bpf.c               |  10 +-
 net/vmw_vsock/vsock_loopback.c          |  13 +-
 tools/testing/vsock/util.c              | 105 ++++++
 tools/testing/vsock/util.h              |   4 +
 tools/testing/vsock/vsock_test.c        | 193 ++++++++++
 15 files changed, 1259 insertions(+), 252 deletions(-)
---
base-commit: ed72bd5a6790a0c3747cb32b0427f921bd03bb71
change-id: 20230413-b4-vsock-dgram-3b6eba6a64e5

Best regards,
-- 
Bobby Eshleman <bobby.eshleman@bytedance.com>

