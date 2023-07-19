Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E37758A41
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 02:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjGSAup (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 20:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjGSAuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 20:50:39 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4FA1BE3
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 17:50:18 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id af79cd13be357-765a7768f1dso624600985a.0
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 17:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1689727818; x=1692319818;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lELx1Jor3ryyghgQ+HYk7Hk999TnyRY5ELpyAOdCAo8=;
        b=kh51wAObPhNEmOAF6xUu3EksFG8Jzcd7WXjvKK6sY85ydx0oCAjbKfJr7SfAn8ZIn3
         OGDI5Sza40VPT51V90ZS6M8PG8voBghdWBcI5NkF1Ln/E2NjdGFfN7ylSyhZB3H/2qSs
         Eux2cQM7uyHorES3YiVvkdVicwQZiumEj2S/+chWRKgcpZyK9fkMR/CLDlpe+s84ardD
         AKBPhERrtDXd34zmfEnd3tYdQcRIeQYrqvfg1/Y0DzpVit92JSl6lqih2sFM3FuYrzAZ
         fDskheDYTg3t3x7D1pKzM5RwsL+n/HiUxZZYtcVnsMAhT0q+Xp+oLec11WIcU0wG0jf8
         03Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689727818; x=1692319818;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lELx1Jor3ryyghgQ+HYk7Hk999TnyRY5ELpyAOdCAo8=;
        b=ZKV63twlDByEWxg0KbmWTlIbchnU5N/s9tH4sSrBO6EEmi5SUD/OBo3kt28p3fF0yi
         9We/6Rh2YZvgLaPmPnaR32eMc6NazwE+eTvKh8/Y1x1LZ1rNp4i603Dm/LQOXkKFEET1
         PsHbXTcxNfSMq6hM9KdoV2mc+dnJOnUAb6GisCMu1xNmR9e6fG6YYP58g0s10NZIGh3Q
         yzOnASijqJWZUuJjE71V1kWHDSaQaYCNd8U9lDhPppH7g88Ul6iB99UXYCB7tHc1ONNO
         1s8d62dJV/AjuHtDIzRS7CUeKAto+YRTjZ/I7R8Sge1FI0MDvnz3bPlsuAvSzyX/tmmM
         IQZA==
X-Gm-Message-State: ABy/qLbwEpcFrjDQgz4gERzcZS/S/tKAOaoHZtESBiJbTHMm2MrWzyIR
        psHORRWpy2l5W3vstolDwiwWsQ==
X-Google-Smtp-Source: APBJJlHUp6yi3x2n9nRDT4fU8CPFc7u1hcZSiQvsFocXnMLLx8X+n9M7kAdjrUgvmbOkC1g5qOsF3Q==
X-Received: by 2002:a05:620a:8c13:b0:765:9e6b:139e with SMTP id qz19-20020a05620a8c1300b007659e6b139emr1162065qkn.16.1689727817783;
        Tue, 18 Jul 2023 17:50:17 -0700 (PDT)
Received: from [172.17.0.7] ([130.44.212.112])
        by smtp.gmail.com with ESMTPSA id c5-20020a05620a11a500b0076738337cd1sm968696qkk.1.2023.07.18.17.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 17:50:17 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Wed, 19 Jul 2023 00:50:14 +0000
Subject: [PATCH RFC net-next v5 10/14] virtio/vsock: add
 VIRTIO_VSOCK_F_DGRAM feature bit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230413-b4-vsock-dgram-v5-10-581bd37fdb26@bytedance.com>
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
In-Reply-To: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
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
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit adds a feature bit for virtio vsock to support datagrams.

Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 include/uapi/linux/virtio_vsock.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
index 331be28b1d30..27b4b2b8bf13 100644
--- a/include/uapi/linux/virtio_vsock.h
+++ b/include/uapi/linux/virtio_vsock.h
@@ -40,6 +40,7 @@
 
 /* The feature bitmap for virtio vsock */
 #define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
+#define VIRTIO_VSOCK_F_DGRAM		3	/* SOCK_DGRAM supported */
 
 struct virtio_vsock_config {
 	__le64 guest_cid;

-- 
2.30.2

