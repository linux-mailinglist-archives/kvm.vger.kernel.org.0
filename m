Return-Path: <kvm+bounces-52648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A4921B07B17
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 18:24:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E53B3BD134
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 16:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E1DD2F548A;
	Wed, 16 Jul 2025 16:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="YdrDG6Nv"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0F02F3C3E;
	Wed, 16 Jul 2025 16:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752683070; cv=none; b=IU7rXkQNA4lauaUZmlPuazYmY7TNtHPlBS4rqfQYSodrRmGm4xwkhyjGWZ/LGCbQfX2SX2hmxT+Vb2I1rEq2GJ0oOFGuHGR5qp5nLdGC3UOV8V3ygHIeLk2f/TFxK6n2YovSEutplzHFOxGmGAR5a00gqC2oSi7itAqJhExD61w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752683070; c=relaxed/simple;
	bh=kVoWv3/iwWNxGI8jNRCZPVMbIMQrh2BMtxaTtjHOzdA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=A03xwgHOlMIxSBtV8loomCdf0ShHrID1TYumq9ne0FXyr+aEqy2EVRfMH8xK09c8HXdHaNmypEu4CXAfZO0Nzw7q70Z9d4cRSNgfABU3WX6lPV6k2mYex7fPVOSBAWERVqTcGSFJ4a/6BGpZGd3w15iKanXzv5qLqEvlONTFzPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=YdrDG6Nv; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:d42b:0:640:f3fc:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id 5A3C060AFE;
	Wed, 16 Jul 2025 19:22:56 +0300 (MSK)
Received: from kniv-nix.yandex-team.ru (unknown [2a02:6bf:8080:a75::1:7])
	by mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id nMP7Db0GwW20-oO643L00;
	Wed, 16 Jul 2025 19:22:55 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1752682975;
	bh=/lRCgvKC2NqnnCP6neakgrl2Mgl3BpNaQQjJ8bFZqVM=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=YdrDG6NvtUApDy+jUsqDv7peLcj/w2Jxu3hDLFaZWAk1fINhDPP+RynnBH4Z/MdKI
	 Kmm90wBRxeiJWZCCI+UmC06pOQVwG+qJSQjZtw2ks8bNqWeqo22q3diIWf5R/HvODm
	 XoJC15jJgqoVUVeAhtnCNdOpPxpbG6+jCjup6MHw=
Authentication-Results: mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Nikolay Kuratov <kniv@yandex-team.ru>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	stable@vger.kernel.org,
	Andrey Ryabinin <arbn@yandex-team.com>,
	Andrey Smetanin <asmetanin@yandex-team.ru>
Subject: [PATCH] vhost/net: Replace wait_queue with completion in ubufs reference
Date: Wed, 16 Jul 2025 19:22:43 +0300
Message-Id: <20250716162243.1401676-1-kniv@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When operating on struct vhost_net_ubuf_ref, the following execution
sequence is theoretically possible:
CPU0 is finalizing DMA operation                   CPU1 is doing VHOST_NET_SET_BACKEND
                             // &ubufs->refcount == 2
vhost_net_ubuf_put()                               vhost_net_ubuf_put_wait_and_free(oldubufs)
                                                     vhost_net_ubuf_put_and_wait()
                                                       vhost_net_ubuf_put()
                                                         int r = atomic_sub_return(1, &ubufs->refcount);
                                                         // r = 1
int r = atomic_sub_return(1, &ubufs->refcount);
// r = 0
                                                      wait_event(ubufs->wait, !atomic_read(&ubufs->refcount));
                                                      // no wait occurs here because condition is already true
                                                    kfree(ubufs);
if (unlikely(!r))
  wake_up(&ubufs->wait);  // use-after-free

This leads to use-after-free on ubufs access. This happens because CPU1
skips waiting for wake_up() when refcount is already zero.

To prevent that use a completion instead of wait_queue as the ubufs
notification mechanism. wait_for_completion() guarantees that there will
be complete() call prior to its return.

We also need to reinit completion because refcnt == 0 does not mean
freeing in case of vhost_net_flush() - it then sets refcnt back to 1.
AFAIK concurrent calls to vhost_net_ubuf_put_and_wait() with the same
ubufs object aren't possible since those calls (through vhost_net_flush()
or vhost_net_set_backend()) are protected by the device mutex.
So reinit_completion() right after wait_for_completion() should be fine.

Cc: stable@vger.kernel.org
Fixes: 0ad8b480d6ee9 ("vhost: fix ref cnt checking deadlock")
Reported-by: Andrey Ryabinin <arbn@yandex-team.com>
Suggested-by: Andrey Smetanin <asmetanin@yandex-team.ru>
Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
---
 drivers/vhost/net.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 7cbfc7d718b3..454d179fffeb 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -94,7 +94,7 @@ struct vhost_net_ubuf_ref {
 	 * >1: outstanding ubufs
 	 */
 	atomic_t refcount;
-	wait_queue_head_t wait;
+	struct completion wait;
 	struct vhost_virtqueue *vq;
 };
 
@@ -240,7 +240,7 @@ vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
 	if (!ubufs)
 		return ERR_PTR(-ENOMEM);
 	atomic_set(&ubufs->refcount, 1);
-	init_waitqueue_head(&ubufs->wait);
+	init_completion(&ubufs->wait);
 	ubufs->vq = vq;
 	return ubufs;
 }
@@ -249,14 +249,15 @@ static int vhost_net_ubuf_put(struct vhost_net_ubuf_ref *ubufs)
 {
 	int r = atomic_sub_return(1, &ubufs->refcount);
 	if (unlikely(!r))
-		wake_up(&ubufs->wait);
+		complete_all(&ubufs->wait);
 	return r;
 }
 
 static void vhost_net_ubuf_put_and_wait(struct vhost_net_ubuf_ref *ubufs)
 {
 	vhost_net_ubuf_put(ubufs);
-	wait_event(ubufs->wait, !atomic_read(&ubufs->refcount));
+	wait_for_completion(&ubufs->wait);
+	reinit_completion(&ubufs->wait);
 }
 
 static void vhost_net_ubuf_put_wait_and_free(struct vhost_net_ubuf_ref *ubufs)
-- 
2.34.1


