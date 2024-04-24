Return-Path: <kvm+bounces-15881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E2AD8B1767
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 01:48:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 53460B23CDC
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 23:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D9A516F269;
	Wed, 24 Apr 2024 23:48:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mout-y-111.mailbox.org (mout-y-111.mailbox.org [91.198.250.236])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450A216F0F0
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 23:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.198.250.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714002494; cv=none; b=ZFHQAhbPZp8Fzx3o6zMUKqxoFQiQ2b8iTu6ZflnyyX5F6Sn2Y4J7S5jTCAq+pH5C0L4k5+2L3I9U2HAoQf9M+D/zGdrHKic2jD4+ipDBGt+/RqmcuzQdfr3Ezm0gguqMHzSjElh1xwYyIm92AmRZXdnwjyMDHlDa4vQDadt3vfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714002494; c=relaxed/simple;
	bh=4F/kPXhqJxek1h7WYgjRk8EdnPlCYyBhxFEF4aj+fvw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZqFxct6oGPSbfse83L08t67EtNJ0e1vaKhYcuvwm+kNThA6Ps1xhq6lB9dSZRGcH1j36xII5WbjoI2nciMqA12rrF8c9ZszkrSFCHvXUQhe4ldvvClW8Jfya2DTz9BSU2gnwIMpMXhLqOO8FNgGTYIjwjJzlf67Sf0/lVroIgPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osuchow.ski; spf=none smtp.mailfrom=osuchow.ski; arc=none smtp.client-ip=91.198.250.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osuchow.ski
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=osuchow.ski
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-y-111.mailbox.org (Postfix) with ESMTPS id 4VPwWX5t4bz9v8R;
	Thu, 25 Apr 2024 01:42:16 +0200 (CEST)
From: Dawid Osuchowski <linux@osuchow.ski>
To: kvm@vger.kernel.org
Cc: alex.williamson@redhat.com,
	Dawid Osuchowski <linux@osuchow.ski>
Subject: [PATCH] vfio: Use anon_inode_getfile_fmode() in vfio_device_open_file()
Date: Thu, 25 Apr 2024 01:41:47 +0200
Message-ID: <20240424234147.7840-1-linux@osuchow.ski>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove TODO by using the anon_inode_getfile_fmode() instead of setting
the fmode directly in vfio_device_open_file().

Signed-off-by: Dawid Osuchowski <linux@osuchow.ski>
---
Depends on [1]

[1] https://lore.kernel.org/linux-fsdevel/20240424233859.7640-1-linux@osuchow.ski/T/#u
---
 drivers/vfio/group.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 610a429c6191..c9e7af2a1056 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -270,22 +270,15 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
 
 	/*
 	 * We can't use anon_inode_getfd() because we need to modify
-	 * the f_mode flags directly to allow more than just ioctls
+	 * the f_mode flags to allow more than just ioctls
 	 */
-	filep = anon_inode_getfile("[vfio-device]", &vfio_device_fops,
-				   df, O_RDWR);
+	filep = anon_inode_getfile_fmode("[vfio-device]", &vfio_device_fops,
+				   df, O_RDWR, FMODE_PREAD | FMODE_PWRITE);
 	if (IS_ERR(filep)) {
 		ret = PTR_ERR(filep);
 		goto err_close_device;
 	}
 
-	/*
-	 * TODO: add an anon_inode interface to do this.
-	 * Appears to be missing by lack of need rather than
-	 * explicitly prevented.  Now there's need.
-	 */
-	filep->f_mode |= (FMODE_PREAD | FMODE_PWRITE);
-
 	if (device->group->type == VFIO_NO_IOMMU)
 		dev_warn(device->dev, "vfio-noiommu device opened by user "
 			 "(%s:%d)\n", current->comm, task_pid_nr(current));
-- 
2.44.0


