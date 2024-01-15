Return-Path: <kvm+bounces-6282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 91C2882E1DA
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 21:36:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30C271F22D36
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 20:36:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C0EF1AACE;
	Mon, 15 Jan 2024 20:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="crIDZxkV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-23.smtpout.orange.fr [80.12.242.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB431A716
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 20:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from fedora.home ([92.140.202.140])
	by smtp.orange.fr with ESMTPA
	id PTgYrIbDj9TFdPTgYrCsdD; Mon, 15 Jan 2024 21:35:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1705350958;
	bh=RzPoGp/tpKwUV6J2m7F/ChKKY33YyoyaYVUsLe/NOrA=;
	h=From:To:Cc:Subject:Date;
	b=crIDZxkVsvRRgoM4QE6wFLEjnsbeL4mCoTxXi0nzroXsopuYsC9MuN7/SMLzMDMl+
	 +ONLtm6NaS1G2zYyR4T8yHq83QNwAkOV1dcTCWdhiFXWMXM71PUkmTuk0xsublfOXR
	 CQF3Xer8zFOUn7MxW+CP3/g5wu4tRDlAN4eczas4tkT+4eYvi1/+7xmoTZj+SfFJt9
	 eD4UUstx3So1LO55nB2mSnMA/wRuie20L3w7RuJzmjLlU6Qjkq7Ssun78WiSz0rXGS
	 NDEq98gNbu3W4UjnZ5yBSutr7Vh+/jqXULenRmKLdaNSt73dIDwkefstUFPHEeQeAy
	 agWlTIKpET0lQ==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 15 Jan 2024 21:35:58 +0100
X-ME-IP: 92.140.202.140
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH] vhost-vdpa: Remove usage of the deprecated ida_simple_xx() API
Date: Mon, 15 Jan 2024 21:35:50 +0100
Message-ID: <bd27d4066f7749997a75cf4111fbf51e11d5898d.1705350942.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

Note that the upper limit of ida_simple_get() is exclusive, buInputt the one of
ida_alloc_max() is inclusive. So a -1 has been added when needed.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/vhost/vdpa.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index bc4a51e4638b..849b9d2dd51f 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1534,7 +1534,7 @@ static void vhost_vdpa_release_dev(struct device *device)
 	struct vhost_vdpa *v =
 	       container_of(device, struct vhost_vdpa, dev);
 
-	ida_simple_remove(&vhost_vdpa_ida, v->minor);
+	ida_free(&vhost_vdpa_ida, v->minor);
 	kfree(v->vqs);
 	kfree(v);
 }
@@ -1557,8 +1557,8 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	if (!v)
 		return -ENOMEM;
 
-	minor = ida_simple_get(&vhost_vdpa_ida, 0,
-			       VHOST_VDPA_DEV_MAX, GFP_KERNEL);
+	minor = ida_alloc_max(&vhost_vdpa_ida, VHOST_VDPA_DEV_MAX - 1,
+			      GFP_KERNEL);
 	if (minor < 0) {
 		kfree(v);
 		return minor;
-- 
2.43.0


