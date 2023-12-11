Return-Path: <kvm+bounces-4072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A735880D126
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 17:24:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 365ACB20E4F
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 16:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C46054CB28;
	Mon, 11 Dec 2023 16:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="BJK5ocSU"
X-Original-To: kvm@vger.kernel.org
X-Greylist: delayed 7044 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 11 Dec 2023 08:23:46 PST
Received: from forwardcorp1c.mail.yandex.net (forwardcorp1c.mail.yandex.net [178.154.239.200])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC53A9;
	Mon, 11 Dec 2023 08:23:46 -0800 (PST)
Received: from mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net [IPv6:2a02:6b8:c12:5329:0:640:5ed5:0])
	by forwardcorp1c.mail.yandex.net (Yandex) with ESMTP id 3E4B160C91;
	Mon, 11 Dec 2023 19:23:44 +0300 (MSK)
Received: from kniv-nix.yandex-team.ru (unknown [2a02:6b8:b081:b718::1:2a])
	by mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id dNkT8A0IWuQ0-nnbTnYGE;
	Mon, 11 Dec 2023 19:23:43 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1702311823;
	bh=eeCkrSB3uFHx+QRJXvlLlycFFlbNNEdrpOCWz+C0kpk=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=BJK5ocSUmwBAXUWxnxRxQ9ZaPvc9/tH0wvTRNftWfHKzpX0ZrG1oMhu0CncAWC4SE
	 YqPLIYVe+91mVmsWIevlull4NeJhRrdaRu0yN+f5GJ4z4KGaJOwOsKJtae+RT1qah4
	 q13RtR9UNj5Y0Fa6kBmupOJynNc94YylHEhnzGw4=
Authentication-Results: mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Nikolay Kuratov <kniv@yandex-team.ru>
To: linux-kernel@vger.kernel.org
Cc: sgarzare@redhat.com,
	netdev@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	Nikolay Kuratov <kniv@yandex-team.ru>
Subject: [PATCH v2] vsock/virtio: Fix unsigned integer wrap around in virtio_transport_has_space()
Date: Mon, 11 Dec 2023 19:23:17 +0300
Message-Id: <20231211162317.4116625-1-kniv@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <t6mnn7lyusvwt4knlxkgaajphhs6es5xr6hr7iixtwrfcljw67@foceocwkayk2>
References: <t6mnn7lyusvwt4knlxkgaajphhs6es5xr6hr7iixtwrfcljw67@foceocwkayk2>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We need to do signed arithmetic if we expect condition
`if (bytes < 0)` to be possible

Found by Linux Verification Center (linuxtesting.org) with SVACE

Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
---

V1 -> V2: Added Fixes section

 net/vmw_vsock/virtio_transport_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index c8e162c9d1df..6df246b53260 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -843,7 +843,7 @@ static s64 virtio_transport_has_space(struct vsock_sock *vsk)
 	struct virtio_vsock_sock *vvs = vsk->trans;
 	s64 bytes;
 
-	bytes = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
+	bytes = (s64)vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
 	if (bytes < 0)
 		bytes = 0;
 
-- 
2.34.1


