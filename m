Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16B5846E9D
	for <lists+kvm@lfdr.de>; Sat, 15 Jun 2019 08:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfFOGml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Jun 2019 02:42:41 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35261 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfFOGml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Jun 2019 02:42:41 -0400
Received: by mail-pg1-f193.google.com with SMTP id s27so2791741pgl.2
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2019 23:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4hNHWrhfyzsV2n/wRn65uyM6GtYs6ZW3csZvNGHrW1M=;
        b=SmfdGKEs9uPX16YgUrEx8uxW6d74F8JSAWtvzcoD+gYAubt5m7kLbAo3yn13CuIbXC
         LcmpVrD/YFGRQ2uPnZ8E7HdD1vyh7X+TsUnB8/8s0kEQvA+Uy6XhVghwux+/uDWQMx6t
         CA0eE1B4NKJOQWPT4O7Z+fdXwYC/6Ykz2Z89A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4hNHWrhfyzsV2n/wRn65uyM6GtYs6ZW3csZvNGHrW1M=;
        b=MR/pflEMGygccknwzEZ5FcfvX94qwal6QTafpZ+WN9HQQawwrTcbB6ngzTs+1BtqmV
         /QRleqY1At/tZAYV7EF8Hmdvq7Z3MtyNk2rpwP5p+hPt4faf8/lAnLpHf+ONMvyKw0sR
         tdPn6s3Mxj4+L9iYJdXEsJetQ0JmmgCbn756zPM/1W+3foXvpeRII97podMEzSsHNS8Q
         UppjY+JhTTu58I5gkH+elWH1Cf6MujD3uyLs4mGJ6d90XQCVtQdZUKTARIqakGT65NtT
         Ffhy3tY/3tARKXT/vC8i3p+t/e2YLKqZLNQDnURnbymw4NOwJnhaSb6ONV0qdcmr3QWH
         +GKQ==
X-Gm-Message-State: APjAAAWVtRWErACLBlrTXEj5k4WaQC6HV90PrzHuzesZHZ9w3oqTbau7
        VFh9omtSRjywOEQuqsdi6MpMkg==
X-Google-Smtp-Source: APXvYqztVvlek2ciZ+0if+6HLcVw/2Jr58oCThu5McVtMseOVbl4zFUyuLV/sAQA79bZsV+yqr0xQg==
X-Received: by 2002:a63:eb55:: with SMTP id b21mr38365372pgk.67.1560580960622;
        Fri, 14 Jun 2019 23:42:40 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:942a:df4a:2beb:7e97])
        by smtp.gmail.com with ESMTPSA id z126sm7025201pfb.100.2019.06.14.23.42.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 23:42:40 -0700 (PDT)
From:   Stephen Barber <smbarber@chromium.org>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Barber <smbarber@chromium.org>
Subject: [PATCH] vsock/virtio: set SOCK_DONE on peer shutdown
Date:   Fri, 14 Jun 2019 23:42:37 -0700
Message-Id: <20190615064237.73586-1-smbarber@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set the SOCK_DONE flag to match the TCP_CLOSING state when a peer has
shut down and there is nothing left to read.

This fixes the following bug:
1) Peer sends SHUTDOWN(RDWR).
2) Socket enters TCP_CLOSING but SOCK_DONE is not set.
3) read() returns -ENOTCONN until close() is called, then returns 0.

Signed-off-by: Stephen Barber <smbarber@chromium.org>
---
 net/vmw_vsock/virtio_transport_common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index f3f3d06cb6d8..e30f53728725 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -871,8 +871,10 @@ virtio_transport_recv_connected(struct sock *sk,
 		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SHUTDOWN_SEND)
 			vsk->peer_shutdown |= SEND_SHUTDOWN;
 		if (vsk->peer_shutdown == SHUTDOWN_MASK &&
-		    vsock_stream_has_data(vsk) <= 0)
+		    vsock_stream_has_data(vsk) <= 0) {
+			sock_set_flag(sk, SOCK_DONE);
 			sk->sk_state = TCP_CLOSING;
+		}
 		if (le32_to_cpu(pkt->hdr.flags))
 			sk->sk_state_change(sk);
 		break;
-- 
2.22.0.410.gd8fdbe21b5-goog

