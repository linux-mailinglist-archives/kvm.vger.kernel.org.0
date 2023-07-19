Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB95758A32
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 02:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbjGSAuU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 20:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjGSAuP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 20:50:15 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125BF1719
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 17:50:11 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id d75a77b69052e-4039f0d140eso51238771cf.1
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 17:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1689727811; x=1692319811;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RRgj32iUYcRPQa7+gTgJIjnpPYuGFjIY/Kz/A8nTowk=;
        b=IXZ5R7IWCdcvitOGSq8k/EIMLrqwPMUB9D/Zi9EE+9sSo9Ibqe7l8BTzzztEfZzLWg
         B2G5CHGlUkVio9Re3XZr0aX1lfiEfU0+n5TSJiykLg5DMsjUemmLr97vWvbzPEH6VBPf
         wc6K6mPxmMC4VBezVPhsbsTL8crTwuA9GenLAUs2GbzMEAAnTjBwClQX40kOCEfno/vD
         rcs9gwkb9hLLHvZt5yWNJZejItpccGsrQ1MfVasQA+l2WX9ZDxvzqyQ5U2gycVRfZwT+
         kyaQKcjHLuSQxTbn52xpRG8wpj3PWrLi+kBY7lEhlwtPa+rBSATIlhwiR2U+jI7y9txa
         7ILA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689727811; x=1692319811;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RRgj32iUYcRPQa7+gTgJIjnpPYuGFjIY/Kz/A8nTowk=;
        b=d9bCi+8a2gVG43uWRQm/llkiwNaLLBHFs+Uwss4ZyYMkddWZcPfQW4LlP42781cQ6F
         j37lkYg5a/dsIfRQK5F432KxDRiFSNcikyl0EmnyvFg/ZgtTMTrrNFGYg+/4acgxFyqx
         dexbnZZrLzFGQ1B9dAc6OTRXxxUMaFSbjPBA0vAtNN+0/pdeozK/yO9JL84NIlyMUI+n
         5NxU7V4bNjmF+JsWphb4lafYqytW35nCGaIa05TNTPGQDF2Mi9eSa/JywTYSpToH9ZyY
         Uv2d9DkHutSAh6P6y3BwSQNyqQ0AtBlnvsgMmMEROvhuQLpLR2z4ln69PehtZJDjio1K
         443g==
X-Gm-Message-State: ABy/qLbbp/5AJHSNidXhyj5iifSDkuHmoedNY17Aefx18Wnv0MCWK27Q
        dfFti/lhAFoxL/8HFE4aODW43w==
X-Google-Smtp-Source: APBJJlEvlJmvRIDDpwkEKw4v7KpoikRir4zJOvvCYnu6BF16D2MR0pWE+MFE6NgcilOwhqBSSBZ3nA==
X-Received: by 2002:a05:622a:1788:b0:403:fe96:7af2 with SMTP id s8-20020a05622a178800b00403fe967af2mr2544945qtk.41.1689727811113;
        Tue, 18 Jul 2023 17:50:11 -0700 (PDT)
Received: from [172.17.0.7] ([130.44.212.112])
        by smtp.gmail.com with ESMTPSA id c5-20020a05620a11a500b0076738337cd1sm968696qkk.1.2023.07.18.17.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 17:50:10 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Wed, 19 Jul 2023 00:50:06 +0000
Subject: [PATCH RFC net-next v5 02/14] af_vsock: refactor transport lookup
 code
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230413-b4-vsock-dgram-v5-2-581bd37fdb26@bytedance.com>
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

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 net/vmw_vsock/af_vsock.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index ad71e084bf2f..ae5ac5531d96 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -423,6 +423,22 @@ static void vsock_deassign_transport(struct vsock_sock *vsk)
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
@@ -463,13 +479,8 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
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

