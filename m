Return-Path: <kvm+bounces-52881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9785B0A184
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 13:05:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5069EA8022D
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 11:04:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 525712BEC55;
	Fri, 18 Jul 2025 11:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="Hg/k6Xe4"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9195229B78C;
	Fri, 18 Jul 2025 11:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752836678; cv=none; b=pvCZMSKva/At86TO3pMEuAagGrscqsu788tZLEu4LkFca2HeqDv3QpV1ecf17KWBxFRSJoQA2OG2pphel2Xdm/dp23JZH20jkfIO+1rgwXTDGXKR5FWNooGQrZqjLwwuQgts+jXK9tUFJa9zkq8LJ9Ahg4Yf85NnoCyv3tgdu5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752836678; c=relaxed/simple;
	bh=cFORY9gb0sfHAI5NO7xSZ6xnWnAfgmRgOLUsTQ179wQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iMiQRorro7Z2kI+QOcSk51Dg3C+tReVwSs5RWlgRC1EhSvVWgnq3gtr4PPNPq8TkzrXiUJIYt9DthTpmOq97+J6VyhdKr8QO6UNN1E9Q2YDjQQzzJye9rJchfYG9t5fjRpb3KD87FOuaKlV7yrV8swN4b+KUVSzwhYFEBV+7WaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=Hg/k6Xe4; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c0f:4291:0:640:5ba1:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 01F6CC1324;
	Fri, 18 Jul 2025 14:04:30 +0300 (MSK)
Received: from kniv-nix.yandex-team.ru (unknown [2a02:6bf:8080:56e::1:20])
	by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id C4MJsn1G4eA0-22dOx9QF;
	Fri, 18 Jul 2025 14:04:29 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1752836669;
	bh=2qalnWYlQY+v6tyEg1CW//D2TKZDTcBnHEPVSwiWO/A=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=Hg/k6Xe4zn/33viN5WiQsuyi+GvR3boPyW3beCibPRrnN9PeNfOjcaMEITbrG2QnV
	 BMYj8L68OOlljHdI7jRvNfOgS5hpLhkVV4oAoQ+TasSL/KqJ8Zy9ooZ7eDELWGShQs
	 dB0e0QBbGTTCGiOH/v+X/rvIKBL7iZU6feUQpL7E=
Authentication-Results: mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Nikolay Kuratov <kniv@yandex-team.ru>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Lei Yang <leiyang@redhat.com>,
	Hillf Danton <hdanton@sina.com>,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	stable@vger.kernel.org,
	Andrey Ryabinin <arbn@yandex-team.com>,
	Andrey Smetanin <asmetanin@yandex-team.ru>
Subject: [PATCH v2] vhost/net: Replace wait_queue with completion in ubufs reference
Date: Fri, 18 Jul 2025 14:03:55 +0300
Message-Id: <20250718110355.1550454-1-kniv@yandex-team.ru>
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

We also need to reinit completion in vhost_net_flush(), because
refcnt == 0 does not mean freeing in that case.

Cc: stable@vger.kernel.org
Fixes: 0ad8b480d6ee9 ("vhost: fix ref cnt checking deadlock")
Reported-by: Andrey Ryabinin <arbn@yandex-team.com>
Suggested-by: Andrey Smetanin <asmetanin@yandex-team.ru>
Suggested-by: Hillf Danton <hdanton@sina.com>
Tested-by: Lei Yang <leiyang@redhat.com> (v1)
Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
---
v2:
* move reinit_completion() into vhost_net_flush(), thanks
  to Hillf Danton
* add Tested-by: Lei Yang
* check that usages of put_and_wait() are consistent across
  LTS kernels

 drivers/vhost/net.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 7cbfc7d718b3..69e1bfb9627e 100644
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
@@ -249,14 +249,14 @@ static int vhost_net_ubuf_put(struct vhost_net_ubuf_ref *ubufs)
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
 }
 
 static void vhost_net_ubuf_put_wait_and_free(struct vhost_net_ubuf_ref *ubufs)
@@ -1381,6 +1381,7 @@ static void vhost_net_flush(struct vhost_net *n)
 		mutex_lock(&n->vqs[VHOST_NET_VQ_TX].vq.mutex);
 		n->tx_flush = false;
 		atomic_set(&n->vqs[VHOST_NET_VQ_TX].ubufs->refcount, 1);
+		reinit_completion(&n->vqs[VHOST_NET_VQ_TX].ubufs->wait);
 		mutex_unlock(&n->vqs[VHOST_NET_VQ_TX].vq.mutex);
 	}
 }
-- 
2.34.1


