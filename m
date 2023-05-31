Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96032718A6D
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 21:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjEaTsG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 15:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjEaTri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 15:47:38 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D990126
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 12:47:36 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id af79cd13be357-75b08639930so75351585a.0
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 12:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685562455; x=1688154455;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5UHjssLfpQql1l3N+JsL18/1F1d999v0IG8ev+FPKU0=;
        b=QBGy63ayVDOIEDr61JPl6x9JZIt2/yzTyij1oy+yiAf6AvimKdOcvilem3A3EkcZQI
         EupN6mOO/PgxYIwOuGGgR84K5XibFhS4pcmWcw6V7zW1BC5pQX7KOGeh/GbTurcQsU4D
         nLlk9fzSwX6IYXjISvS3a8pyN+wqVIrQGgrJF8kBqO7aBVs3BfVU+uSFdjeNxXGHeZy0
         el00WiQ67dGV/JJ0/iVHod74DxIz6vHfbdDlEaCZLvQ1tvxRSsnhGSQrd4PLfWzkAg+1
         Ie2Gjj3lwILw+d4IIbOsROJjhcyYK74hKiW6I4ac5g9ofmeN2XSMtxdgQEm38g4PXH18
         4E9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685562455; x=1688154455;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5UHjssLfpQql1l3N+JsL18/1F1d999v0IG8ev+FPKU0=;
        b=EvKuxkI6k33VyN18y7ZK7yPBn+5UT7546vAO1SaH5Sso9Ej07quX2+z/04+ClPQJl3
         mi6aQUCrrR/7KkAbo1vvpNVYQ0/ivnq4GRhpX76JE3wUqASMCKA931mLkYCf/zhEdrNU
         g4gqI7Se3FjkM3gPqw3jobGBEP4aqsv5I7k6VOAkrczpEdqBm3IYaYIOfpJ/PlmbpakN
         E6M2BYUQyZEKcAWa/ruEPH/nDTfmyt3I1KDi4ocV+ECILB3bigCwUVwpNT/YsMGtI4/i
         +tPW6lf6ru+7Zdo/SaENnEAYD6pQns8iHnWO9Ykx5Loji/Ag9X1JLwCblOkUMqNqpUGN
         uRfg==
X-Gm-Message-State: AC+VfDy3wWjsJc+VGzdRVZ50LaHtNnBmb4K03mw6ZAPk/53XtT8zyi1j
        cZRpaj0kmDugdZxORa1NHxnyEQ==
X-Google-Smtp-Source: ACHHUZ4JNtGa83cjas7CRuFuK8jR5kEN4roSCtdDc/sHLbvPA8Mqb1DPmOPmfgxEAETPuEU4dT9f9A==
X-Received: by 2002:a05:6214:27e9:b0:5e9:48da:9938 with SMTP id jt9-20020a05621427e900b005e948da9938mr12692252qvb.11.1685562455358;
        Wed, 31 May 2023 12:47:35 -0700 (PDT)
Received: from [172.17.0.2] ([147.160.184.87])
        by smtp.gmail.com with ESMTPSA id a2-20020a0ce342000000b006238888dbffsm6287377qvm.139.2023.05.31.12.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 12:47:34 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Wed, 31 May 2023 19:47:32 +0000
Subject: [PATCH net] virtio/vsock: fix sock refcnt bug on owner set failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230531-b4-vsock-fix-refcnt-v1-1-0ed7b697cca5@bytedance.com>
X-B4-Tracking: v=1; b=H4sIAFOkd2QC/x2NQQrDIBAAvxL23AU1lYR+pfTg2k2yFDZFJQghf
 6/2OAzDnJA5CWd4DCckPiTLrg3sbYC4BV0Z5d0YnHGj8aNFuuOR9/jBRSomXqIWpIms93M0szP
 QSgqZkVLQuPVWuaByLV19WyL1P3x2Aa/r+gEx73aXhQAAAA==
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
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

Previous to setting the owner the socket is found via
vsock_find_connected_socket(), which returns sk after a call to
sock_hold().

If setting the owner fails, then sock_put() needs to be called.

Fixes: f9d2b1e146e0 ("virtio/vsock: fix leaks due to missing skb owner")
Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 net/vmw_vsock/virtio_transport_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index b769fc258931..f01cd6adc5cb 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1343,6 +1343,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 
 	if (!skb_set_owner_sk_safe(skb, sk)) {
 		WARN_ONCE(1, "receiving vsock socket has sk_refcnt == 0\n");
+		sock_put(sk);
 		goto free_pkt;
 	}
 

---
base-commit: 60cbd38bb0ad9e4395fba9c6994f258f1d6cad51
change-id: 20230531-b4-vsock-fix-refcnt-b7b1558c0820

Best regards,
-- 
Bobby Eshleman <bobby.eshleman@bytedance.com>

