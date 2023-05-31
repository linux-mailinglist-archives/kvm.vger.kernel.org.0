Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9483C717292
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 02:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbjEaAgX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 20:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233626AbjEaAgR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 20:36:17 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56882E59
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 17:35:22 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-64d2c865e4eso3897953b3a.0
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 17:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685493311; x=1688085311;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2mLaP7sR8YQ85tKDJtrowu0OZeTDnTVHBsPa3lq9ex0=;
        b=F3LYU0KCEVEyeO73qa8kNcgsEFHTjyCBUlVuylZXzqwEuCuD/5VVkg13vBR70tcOex
         xiXxOgLEUJDpbUkWKrcLTM2Y0HNCZHAXjow5BEyXJIKKQcM6GUHy1jobrJzUJV0CCV7B
         e3tER2nkLtU3O2jBKudUvOTH6D092x2dF0x+YYHrG65yFT7cr/la1D/zKxL2p8oJJNSP
         t2HhOFBEZPLV0mx8OzH394a0vczH9HjTWwnezAQjbQR+Inru6jr/6xYWqJPaSwl4L0O0
         pYMT8+XdL40SC3W6P5RHpzYkdym14DqA6MCEiwt7psFOs7DepiLs7Ir/Wv38VOPkFPBK
         r0jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685493311; x=1688085311;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2mLaP7sR8YQ85tKDJtrowu0OZeTDnTVHBsPa3lq9ex0=;
        b=BN8ZxP1g8VLXBmvOYFiczlxGwNCE/b/uVxXrDzHWF2K2WmvVYU9wxMnfrsR5AjCHPO
         HUDBbG9+xuCG4XLBPdmSpZlj2lrZQYL196mQJHCsZhKF6KpRQ8cV9R2X8+asApLcGO5P
         56Lj9FPwTt+cBIY6KZEWxIDuXSGIYgDJY0zK9QR64oeJvCNqbyoRflqqEQThjx1uZkSB
         7BGZxuh1fM9R0l4Fskog57nwfiy1bbjfTEsQedcWip+tLTx3+8t/HhA9z8P+PmSUHKX6
         6RMifvUuHyx8xrcX9Nq7lx0KkCd2cCPq1IUcO4qt7SlhDeoh4b3LRwfHRQjP0k0i391h
         Qwtw==
X-Gm-Message-State: AC+VfDwVFVC3SUGrHVeULfXerB0oXWwZPq8jF6vgoW4wJO1Z0qe3n0A1
        M2eHvlW2EbHpBMMclW+Q7mDxhQ==
X-Google-Smtp-Source: ACHHUZ6w0x1oqnDz4GvJ2Z/umZn3PP0nKQeWMeGuQdZa7GKOoy4woshP0yvZ7er+rI4umWv+hh8SHg==
X-Received: by 2002:a05:6a00:2d04:b0:64d:88b:a342 with SMTP id fa4-20020a056a002d0400b0064d088ba342mr4177965pfb.30.1685493310847;
        Tue, 30 May 2023 17:35:10 -0700 (PDT)
Received: from [172.17.0.2] (c-67-170-131-147.hsd1.wa.comcast.net. [67.170.131.147])
        by smtp.gmail.com with ESMTPSA id j12-20020a62b60c000000b0064cb0845c77sm2151340pff.122.2023.05.30.17.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 17:35:10 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Wed, 31 May 2023 00:35:06 +0000
Subject: [PATCH RFC net-next v3 2/8] vsock: refactor transport lookup code
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230413-b4-vsock-dgram-v3-2-c2414413ef6a@bytedance.com>
References: <20230413-b4-vsock-dgram-v3-0-c2414413ef6a@bytedance.com>
In-Reply-To: <20230413-b4-vsock-dgram-v3-0-c2414413ef6a@bytedance.com>
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
        Bobby Eshleman <bobby.eshleman@bytedance.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce new reusable function vsock_connectible_lookup_transport()
that performs the transport lookup logic.

No functional change intended.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 net/vmw_vsock/af_vsock.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 7ec0659c6ae5..67dd9d78272d 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -422,6 +422,22 @@ static void vsock_deassign_transport(struct vsock_sock *vsk)
 	vsk->transport = NULL;
 }
 
+static const struct vsock_transport *
+vsock_connectible_lookup_transport(unsigned int cid, __u8 flags)
+{
+	const struct vsock_transport *transport;
+
+	if (vsock_use_local_transport(cid))
+		transport = transport_local;
+	else if (cid <= VMADDR_CID_HOST || !transport_h2g ||
+		 (flags & VMADDR_FLAG_TO_HOST))
+		transport = transport_g2h;
+	else
+		transport = transport_h2g;
+
+	return transport;
+}
+
 /* Assign a transport to a socket and call the .init transport callback.
  *
  * Note: for connection oriented socket this must be called when vsk->remote_addr
@@ -462,13 +478,8 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 		break;
 	case SOCK_STREAM:
 	case SOCK_SEQPACKET:
-		if (vsock_use_local_transport(remote_cid))
-			new_transport = transport_local;
-		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g ||
-			 (remote_flags & VMADDR_FLAG_TO_HOST))
-			new_transport = transport_g2h;
-		else
-			new_transport = transport_h2g;
+		new_transport = vsock_connectible_lookup_transport(remote_cid,
+								   remote_flags);
 		break;
 	default:
 		return -ESOCKTNOSUPPORT;

-- 
2.30.2

