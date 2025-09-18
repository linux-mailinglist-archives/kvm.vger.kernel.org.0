Return-Path: <kvm+bounces-58004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 288D9B848C6
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 14:19:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 147E11C27FD6
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 12:20:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75CD82D0602;
	Thu, 18 Sep 2025 12:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R6yE+2r6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C113A256C9F
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 12:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758197980; cv=none; b=eZJDgD0ymHRN+l48gvqlhxrpjsWrmNF4YnTLyG1+sLeUMSIKMq4toTPeKBcQyIT4NJeiOYly3cNxXOBs7PJTFG7UpK0dPVu9MeQAU2q9JB8V/5e9M4N/yUMgOg3r7m9nGP8Ctl2lOwrCZWKIYJRJRxTamULhGpQiN58NQMLW9sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758197980; c=relaxed/simple;
	bh=OaCB53Z5SxqHSpEbGWruf27ccEnxMfEFjrfpUpX4zs8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MYjJDxlB49xCRNOErMqHgE2+KiCmHugRGQJZNtCaZ8aXTcQF9pQHPDDpCwqAa7hRqVarg+zhvwb6XTLRLXY9l4dnpDzLaU8RSJjI26CgiIczfTdFhVQLFvznOes5cLGgNgb7+tF+Wm3Ec1riEkAdV9T20BaT3d+WT/Xv76su0c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R6yE+2r6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758197976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oLHeVQ1V5+rlFvLH0NK0a8N3VCQk3wWRUgjhebQLwJ0=;
	b=R6yE+2r6dgfB60lJotB9aAjjzCOTl1lEWVelvXW1R/54eGsJJJnm/4ud65qLhJLP3uoOF0
	l6f3OvCInHXwT6mRF2c39Wdq3EkBqKp+QuYRr0C1ptgwbxsXpyKMa1sW97XsFoWjv78ei/
	JTqFiPl7iwVgb8FIeg7Z3aM1zGaQKzA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-496-GLAfXEgDNni5Jft2awUMDw-1; Thu,
 18 Sep 2025 08:19:33 -0400
X-MC-Unique: GLAfXEgDNni5Jft2awUMDw-1
X-Mimecast-MFC-AGG-ID: GLAfXEgDNni5Jft2awUMDw_1758197972
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 64ADD1955F0E;
	Thu, 18 Sep 2025 12:19:32 +0000 (UTC)
Received: from corto.redhat.com (unknown [10.45.224.90])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B75711955F19;
	Thu, 18 Sep 2025 12:19:30 +0000 (UTC)
From: =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>
Subject: [PATCH] vfio: Dump migration features under debugfs
Date: Thu, 18 Sep 2025 14:19:28 +0200
Message-ID: <20250918121928.1921871-1-clg@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

A debugfs directory was recently added for VFIO devices. Add a new
"features" file under the migration sub-directory to expose which
features the device supports.

Signed-off-by: Cédric Le Goater <clg@redhat.com>
---
 drivers/vfio/debugfs.c                 | 19 +++++++++++++++++++
 Documentation/ABI/testing/debugfs-vfio |  6 ++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/vfio/debugfs.c b/drivers/vfio/debugfs.c
index 298bd866f15766b50e342511d8a83f0621cb4f55..8b0ca7a09064072b3d489dab8072dbb1a2871d10 100644
--- a/drivers/vfio/debugfs.c
+++ b/drivers/vfio/debugfs.c
@@ -58,6 +58,23 @@ static int vfio_device_state_read(struct seq_file *seq, void *data)
 	return 0;
 }
 
+static int vfio_device_features_read(struct seq_file *seq, void *data)
+{
+	struct device *vf_dev = seq->private;
+	struct vfio_device *vdev = container_of(vf_dev, struct vfio_device, device);
+
+	if (vdev->migration_flags & VFIO_MIGRATION_STOP_COPY)
+		seq_puts(seq, "stop-copy\n");
+	if (vdev->migration_flags & VFIO_MIGRATION_P2P)
+		seq_puts(seq, "p2p\n");
+	if (vdev->migration_flags & VFIO_MIGRATION_PRE_COPY)
+		seq_puts(seq, "pre-copy\n");
+	if (vdev->log_ops)
+		seq_puts(seq, "dirty-tracking\n");
+
+	return 0;
+}
+
 void vfio_device_debugfs_init(struct vfio_device *vdev)
 {
 	struct device *dev = &vdev->device;
@@ -72,6 +89,8 @@ void vfio_device_debugfs_init(struct vfio_device *vdev)
 							vdev->debug_root);
 		debugfs_create_devm_seqfile(dev, "state", vfio_dev_migration,
 					    vfio_device_state_read);
+		debugfs_create_devm_seqfile(dev, "features", vfio_dev_migration,
+					    vfio_device_features_read);
 	}
 }
 
diff --git a/Documentation/ABI/testing/debugfs-vfio b/Documentation/ABI/testing/debugfs-vfio
index 90f7c262f591306bdb99295ab4e857ca0e0b537a..70ec2d454686290e13380340dfd6a5a67a642533 100644
--- a/Documentation/ABI/testing/debugfs-vfio
+++ b/Documentation/ABI/testing/debugfs-vfio
@@ -23,3 +23,9 @@ Contact:	Longfang Liu <liulongfang@huawei.com>
 Description:	Read the live migration status of the vfio device.
 		The contents of the state file reflects the migration state
 		relative to those defined in the vfio_device_mig_state enum
+
+What:		/sys/kernel/debug/vfio/<device>/migration/features
+Date:		Oct 2025
+KernelVersion:	6.18
+Contact:	Cédric Le Goater <clg@redhat.com>
+Description:	Read the migration features of the vfio device.
-- 
2.51.0


