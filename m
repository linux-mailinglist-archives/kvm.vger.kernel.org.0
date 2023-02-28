Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77886A5F3E
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 20:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjB1THD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 14:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjB1TGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 14:06:48 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9FD311E7
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 11:06:14 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id c19so11680022qtn.13
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 11:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1677611174;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C2LCecjy7A9+918lE3DRW32Ryv30Y7vZZQapOsMzhmY=;
        b=iNMKaikOUPeKg+b5uigJdEHzTAq3tnb0YbZ1a8yI0QniovFtY1IGU0K8tuz7Y0QLxn
         3r2K0T0pQPtdAWv+O8cdnvdfsQG3ynp+apctgWUW/517RL1QXYl1tknayLouIZ4xPG4O
         /Ajb24M0DzZIB+MSntw/oit4jW1gGuPYj+/7guz6K19na7gWIBCzdP/zZdu/AeyUpJmO
         7J2AHRcjV69SQhV8LxEonN8/ORn3l+7+YTd/ugFTMR7ay6++TY+c+La3v3OjWHuiYxRC
         fdKdg9aA86lOnkA2F6cEcySwEY92EZqGVf/2g2tnYlCkyIYYHC3t3+n1k8KLxotNj9I9
         dGhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677611174;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C2LCecjy7A9+918lE3DRW32Ryv30Y7vZZQapOsMzhmY=;
        b=wqaTNBPpQyoM111MGWBl1tj7mjLBySzpaXmei4/2aKrOHDH4fJAy/LPyF1HCzWN4cJ
         Zsm9HgDimOKtQ61xoFyA5//aJNUp40YP733bEylIdRhwx1BfR8aSFvaZIpYr7qH4xb5K
         hiv8hrFKmgnuYAvnEa+9qIlFvvE0EwbWR1Vw2t+0Bh+Ke72XWkCuNeQRq2RoohIoiN2X
         Lt50etEtdvX5Zmjieoh5FeO1ooXXCmJGnN1Xlv6Ospxdf46DaOg/pIykN+e3iJcZjGB1
         A7Jz7Zc34zQTuKlbveFbbru2IZ0RHLT3QvRK1wlJexJvdl5relZs5Y+aw0Q/hRxgPngY
         FnMw==
X-Gm-Message-State: AO0yUKVdtXKr81g9gMg+T945fmNOJnEM/x5iwoJgHOKK0zy6iQ0MYEdy
        AKZjxL1jZAnj2d0PJ5Fu2U0+sQ==
X-Google-Smtp-Source: AK7set9sCZMlVRHDjCMFyuuALOQUAsxwTBtlVx+tZsucfDe/QRuVokiOJI2KGD7IdaMr+XmshVNCTw==
X-Received: by 2002:ac8:5cc1:0:b0:3bf:e034:5f5e with SMTP id s1-20020ac85cc1000000b003bfe0345f5emr6422871qta.52.1677611173702;
        Tue, 28 Feb 2023 11:06:13 -0800 (PST)
Received: from n217-072-012.byted.org ([130.44.212.123])
        by smtp.gmail.com with ESMTPSA id p13-20020a05620a15ed00b006fed58fc1a3sm7242810qkm.119.2023.02.28.11.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 11:06:13 -0800 (PST)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Tue, 28 Feb 2023 19:04:35 +0000
Subject: [PATCH net-next v3 2/3] selftests/bpf: add vsock to vmtest.sh
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230227-vsock-sockmap-upstream-v3-2-7e7f4ce623ee@bytedance.com>
References: <20230227-vsock-sockmap-upstream-v3-0-7e7f4ce623ee@bytedance.com>
In-Reply-To: <20230227-vsock-sockmap-upstream-v3-0-7e7f4ce623ee@bytedance.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
X-Mailer: b4 0.12.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add vsock loopback to the test kernel.

This allows sockmap for vsock to be tested.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 tools/testing/selftests/bpf/config.aarch64 | 2 ++
 tools/testing/selftests/bpf/config.s390x   | 3 +++
 tools/testing/selftests/bpf/config.x86_64  | 3 +++
 3 files changed, 8 insertions(+)

diff --git a/tools/testing/selftests/bpf/config.aarch64 b/tools/testing/selftests/bpf/config.aarch64
index 1f0437644186..253821494884 100644
--- a/tools/testing/selftests/bpf/config.aarch64
+++ b/tools/testing/selftests/bpf/config.aarch64
@@ -176,6 +176,8 @@ CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y
 CONFIG_VIRTIO_MMIO=y
 CONFIG_VIRTIO_NET=y
 CONFIG_VIRTIO_PCI=y
+CONFIG_VIRTIO_VSOCKETS_COMMON=y
 CONFIG_VLAN_8021Q=y
 CONFIG_VSOCKETS=y
+CONFIG_VSOCKETS_LOOPBACK=y
 CONFIG_XFRM_USER=y
diff --git a/tools/testing/selftests/bpf/config.s390x b/tools/testing/selftests/bpf/config.s390x
index d49f6170e7bd..2ba92167be35 100644
--- a/tools/testing/selftests/bpf/config.s390x
+++ b/tools/testing/selftests/bpf/config.s390x
@@ -140,5 +140,8 @@ CONFIG_VIRTIO_BALLOON=y
 CONFIG_VIRTIO_BLK=y
 CONFIG_VIRTIO_NET=y
 CONFIG_VIRTIO_PCI=y
+CONFIG_VIRTIO_VSOCKETS_COMMON=y
 CONFIG_VLAN_8021Q=y
+CONFIG_VSOCKETS=y
+CONFIG_VSOCKETS_LOOPBACK=y
 CONFIG_XFRM_USER=y
diff --git a/tools/testing/selftests/bpf/config.x86_64 b/tools/testing/selftests/bpf/config.x86_64
index dd97d61d325c..b650b2e617b8 100644
--- a/tools/testing/selftests/bpf/config.x86_64
+++ b/tools/testing/selftests/bpf/config.x86_64
@@ -234,7 +234,10 @@ CONFIG_VIRTIO_BLK=y
 CONFIG_VIRTIO_CONSOLE=y
 CONFIG_VIRTIO_NET=y
 CONFIG_VIRTIO_PCI=y
+CONFIG_VIRTIO_VSOCKETS_COMMON=y
 CONFIG_VLAN_8021Q=y
+CONFIG_VSOCKETS=y
+CONFIG_VSOCKETS_LOOPBACK=y
 CONFIG_X86_ACPI_CPUFREQ=y
 CONFIG_X86_CPUID=y
 CONFIG_X86_MSR=y

-- 
2.30.2

