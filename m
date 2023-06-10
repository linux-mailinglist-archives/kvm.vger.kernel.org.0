Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29FA472A73F
	for <lists+kvm@lfdr.de>; Sat, 10 Jun 2023 03:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbjFJA7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 20:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbjFJA7P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 20:59:15 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273CF3585
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 17:58:47 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id d75a77b69052e-3f9cf20da1dso19670921cf.3
        for <kvm@vger.kernel.org>; Fri, 09 Jun 2023 17:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1686358726; x=1688950726;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EPbFW7iZxMvtqbmK4J1z/miwrV0fMapcvT6vEzi4BQ0=;
        b=eHIaq50noFLOTfklzASCj2kkioU8QAZElobxZznaqVwCR+W0ZXU3bcPNgvc+WQtA4V
         ZPh99Ldk0TcosIYZJPhQcTKxuga8iR/gP2SlRfSF/FXq8qouuVLQEsvyDEM1zPWWBJkx
         hn7nWcxMz2c+xwvGdDgizok4EVHbTFiyq5QCVqNCKK6jxRyu1TMqWnnTzsKU8WOvy3+s
         SctSa77Chu2Ul63vM3KhNb3YEXgAXN6A4L0LtRz+e/cWMr+oRB4J33cwIds5xkVmkNCR
         6MA/4rN3clrZtTnCTJSBUyzkmkGrwcx3x3L6DJl/fPcZ089lMjkv3tCg+HkV4kISDjXE
         WTDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686358726; x=1688950726;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EPbFW7iZxMvtqbmK4J1z/miwrV0fMapcvT6vEzi4BQ0=;
        b=dnjOTd+4WByMy0eWU3y9UV2nCBWqsd1OL+DC/7XPwHuvQ3E75gY6d3ZuI85jma8ZA1
         omBpQv2crq+JaOsJel3kUyL98oo++ttgD/TNHC99ppIuwPzQyDw3jomtda1yy/hOaqKZ
         QxDERFjxlbQIXEswDJQTLPyFOFfkh9K7ZuHbWoR5MJsBUpXHdr+7khQgVpl1lpSbRFA0
         mpxoEalQwG1N7sWp4627f+CIOKAYqEpkEcyykwwbd92bSy5C3FI47CtS2NHn9F6l5yn/
         YjfMhKdfT0cqP0pSjXhboqevLs8PL6bzQEl4V0t1ltsCJzIJrgBJV7F4hGBZfHca0ZkA
         jytg==
X-Gm-Message-State: AC+VfDyXhtV8LipjlT/rw3VzlbT8fww1kwLjPKCDa9vQ1ui2Vc1/mbfr
        ITkCtgBw2UyYxy0WsHCTT0UOoQ==
X-Google-Smtp-Source: ACHHUZ4Jsgb36N9GZ4JniC/b/qrfHGSveGUk7BVpmwnK/7J/2seTE4pOmsKxx6vZojSu2m7QHfg5og==
X-Received: by 2002:a05:6214:509b:b0:625:b3a2:f655 with SMTP id kk27-20020a056214509b00b00625b3a2f655mr3585747qvb.30.1686358726197;
        Fri, 09 Jun 2023 17:58:46 -0700 (PDT)
Received: from [172.17.0.4] ([130.44.212.126])
        by smtp.gmail.com with ESMTPSA id x17-20020a0ce251000000b00606750abaf9sm1504075qvl.136.2023.06.09.17.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 17:58:45 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Sat, 10 Jun 2023 00:58:29 +0000
Subject: [PATCH RFC net-next v4 2/8] vsock: refactor transport lookup code
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230413-b4-vsock-dgram-v4-2-0cebbb2ae899@bytedance.com>
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
In-Reply-To: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
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
        bpf@vger.kernel.org, Bobby Eshleman <bobby.eshleman@bytedance.com>
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

Introduce new reusable function vsock_connectible_lookup_transport()
that performs the transport lookup logic.

No functional change intended.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 net/vmw_vsock/af_vsock.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index ffb4dd8b6ea7..74358f0b47fa 100644
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

