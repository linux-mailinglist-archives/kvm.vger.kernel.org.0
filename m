Return-Path: <kvm+bounces-53993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56351B1B481
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 15:14:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FBD21830F8
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A45BA2797B7;
	Tue,  5 Aug 2025 13:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="1UGnYPFj"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAE2275B0B;
	Tue,  5 Aug 2025 13:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399505; cv=none; b=tTTxkm3rApqFBrGey+3J0WxAICkHXlsEiC/QWSU02bY4CXr5oge1g1K4fkTt9WYBOV02ylLsa97DM2sqPQQVqf7cAH+j4/ACVdYcEMSB3HsTgtfSzWCG8j61DqkOSrgje+arvCjTZ72egY+XUEYrO5VFoxpimUFKEQQL7/vAx98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399505; c=relaxed/simple;
	bh=YLBQDy6eQNpuqYJmBuJHbdvk6W3dpGmVOLhbuzAjcJU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TTFSBvkJENWaUz/S69TWJHGe76mrBdi+XXxszLjeBBVk5HzkbptY5KZ3BFNp1Vb2d3pXOpLoTwRxB2xOICpRfXiy4W7AUDiLZXIT/wa0k9Hlhdf28EXMi0Ed37Epx0VH/si63qj0oapzcENH/g+SY4F9ZAAmr6XNQRH1rmavwbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=1UGnYPFj; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:29a1:0:640:5fbc:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id B5EF080627;
	Tue, 05 Aug 2025 16:10:23 +0300 (MSK)
Received: from kniv-nix.yandex-team.ru (unknown [2a02:6bf:8080:849::1:3b])
	by mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 6AgoJU9GpKo0-4ePcQdmN;
	Tue, 05 Aug 2025 16:10:22 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1754399422;
	bh=1fhMX3tvH9apZXuDu7nTQnIUMtDysNPzl2m86b8poH0=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=1UGnYPFjO7Zh2vLJEXLFw6uSfIpf/6yERIuID+XBynFeIndBMTP9ZIQV8adLQCrYi
	 lRenxXGknUS3kKJKSv+I6l0afbWZSX0c5Q7xrrvWC5xdnyWSlWI87G8RcF3PsSSCRy
	 fJbLHsR1l/ZhQSlyPSCnsDVbIp/secb0ROJWvGUc=
Authentication-Results: mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
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
	kniv@yandex-team.ru,
	stable@vger.kernel.org,
	Andrey Ryabinin <arbn@yandex-team.com>
Subject: [PATCH v3] vhost/net: Protect ubufs with rcu read lock in vhost_net_ubuf_put()
Date: Tue,  5 Aug 2025 16:09:17 +0300
Message-Id: <20250805130917.727332-1-kniv@yandex-team.ru>
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
                             // ubufs->refcount == 2
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

To prevent that use a read-side RCU critical section in vhost_net_ubuf_put(),
as suggested by Hillf Danton. For this lock to take effect, free ubufs with
kfree_rcu().

Cc: stable@vger.kernel.org
Fixes: 0ad8b480d6ee9 ("vhost: fix ref cnt checking deadlock")
Reported-by: Andrey Ryabinin <arbn@yandex-team.com>
Suggested-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
---
v2:
* move reinit_completion() into vhost_net_flush(), thanks
  to Hillf Danton
* add Tested-by: Lei Yang
* check that usages of put_and_wait() are consistent across
  LTS kernels
v3:
* use rcu_read_lock() with kfree_rcu() instead of completion,
  as suggested by Hillf Danton

 drivers/vhost/net.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 6edac0c1ba9b..c6508fe0d5c8 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -99,6 +99,7 @@ struct vhost_net_ubuf_ref {
 	atomic_t refcount;
 	wait_queue_head_t wait;
 	struct vhost_virtqueue *vq;
+	struct rcu_head rcu;
 };
 
 #define VHOST_NET_BATCH 64
@@ -250,9 +251,13 @@ vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
 
 static int vhost_net_ubuf_put(struct vhost_net_ubuf_ref *ubufs)
 {
-	int r = atomic_sub_return(1, &ubufs->refcount);
+	int r;
+
+	rcu_read_lock();
+	r = atomic_sub_return(1, &ubufs->refcount);
 	if (unlikely(!r))
 		wake_up(&ubufs->wait);
+	rcu_read_unlock();
 	return r;
 }
 
@@ -265,7 +270,7 @@ static void vhost_net_ubuf_put_and_wait(struct vhost_net_ubuf_ref *ubufs)
 static void vhost_net_ubuf_put_wait_and_free(struct vhost_net_ubuf_ref *ubufs)
 {
 	vhost_net_ubuf_put_and_wait(ubufs);
-	kfree(ubufs);
+	kfree_rcu(ubufs, rcu);
 }
 
 static void vhost_net_clear_ubuf_info(struct vhost_net *n)
-- 
2.34.1


