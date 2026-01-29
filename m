Return-Path: <kvm+bounces-69615-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KDj3NKfQe2m0IgIAu9opvQ
	(envelope-from <kvm+bounces-69615-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:27:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B67AEB4A23
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:27:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E27E6301B40B
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 21:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B32635D5EE;
	Thu, 29 Jan 2026 21:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2b2iQaws"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11AF35CB84
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 21:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769721954; cv=none; b=u8h8hW0hgBqKwF2osUbRB7ZoTr8N1kuPQ0unbUcAqDxXUrwpXNuiHg8oklTwkfh5Z/aGJnvOiQKSCFmS/plxqyEVR/m+Ugj71jRInj6MU4tdaUyxTLPNEY7nz/nY1PKDkgVPJC3RhV6MmT5JeEKT97Jre6V/iTi8u9JnmK6V0Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769721954; c=relaxed/simple;
	bh=6IdtaI14wSLFnlm3AePOxVdQnZ5Ce/BaKfnD8oLedO0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hgdpJScsfvWRdVyYpHBbhHwIv5NUDacg+GlLiCbn+ScxdPk/4IHMsVs3Use+hm5U0SgR9RNkXbBBpPVzF6GwKICl7PZfQJRea24Ux3pRXJduSidQO0yMxQI/otLeG7jRKReP1BsznWaKB6IGDPKqJs2SsMGBFdDmDhRKLWz5zT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2b2iQaws; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34e5a9f0d6aso1508862a91.0
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 13:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721952; x=1770326752; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cEITHmxK+p0fg2PKlGTWLUl48Yr7XTXbjGIRUwhwM+A=;
        b=2b2iQawsuPGFdxNaG5DH0hw0rX+Sqvp6lcSMbvGtXOPbhnGelfqgN3xGH8EIEeaqLM
         MWu+vEK8CeOtWWmjKilHqHyrBwyaXmEe46T9N+cw5YAXzBwF9T8blgw1yE+JxCy/Jxco
         Pxo2hJ+Jxf/qwb9gO6AoYjGm1Z+iX+in76+iq2cuwkei8ZGaV3jevtB9ODT4pQuJ7re/
         6TFO29PI7rslUwKTqHnG1A524axdk9oAhdD5huZ2N8TOU+8yayQPfX/9fezyK9B5AkGU
         t3EE3LQcNqDBMJ5LYwz8P5dllqo0HzvspUHB/e/CXHBRon9adexg1bP5Oi1YIHovGq3u
         CbIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721952; x=1770326752;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cEITHmxK+p0fg2PKlGTWLUl48Yr7XTXbjGIRUwhwM+A=;
        b=EjbMuc169HBmvfMCzbwpk43VS6wa1/rzS3E5fpp+QBT266xBpEz0Ot++IqCXlw7Xgu
         wldxtL8KDshXT7jb1OFoCKC5GB2v9hSYWfzN5H6icQE9V4JQ0CoF0Iuet4m92bwuPJN2
         ixXbWADMrH1ImYXeA7wm/akv+F/xJ0+F7R/pqI3oSelKg7J4c8jQZ4He+nIf/5eVK1Hy
         Kb40RkxPLgMtbqvG9hdTAxdRhmwXPIrouT/dbbvhfiSqGyXy5tANUemcQMRJPHPrAKIx
         eYEJzb3b45aikq7KHmI35vamKlH/n5gxDBTXZkF6O2S73CFrUwpaATPjEFa4E4wbpAgK
         PzWA==
X-Forwarded-Encrypted: i=1; AJvYcCUCx4PB1/IvuHqMxIwRBaxA3b5ia0yNpxAQSMpzKXva8eN+Va7UH9qoJvx+lU4pOQBIO0o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKxdJXoGGeOHIXcxd+iDA00jWf8us71IlOh567hqGAwNjWPLcu
	edNflCTrLhOqOdt0sqRbfM0FkT4LIHDCEi9r+Y2LUNTYsjDDQ2o/oWU7f664Da6wjWAR94VZU8+
	vlPdPKr74gF0aUA==
X-Received: from pjk11.prod.google.com ([2002:a17:90b:558b:b0:34c:489a:f4c9])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3c10:b0:353:2972:74a4 with SMTP id 98e67ed59e1d1-35429af8f7amr3444629a91.13.1769721952367;
 Thu, 29 Jan 2026 13:25:52 -0800 (PST)
Date: Thu, 29 Jan 2026 21:24:56 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-10-dmatlack@google.com>
Subject: [PATCH v2 09/22] vfio/pci: Store incoming Live Update state in struct vfio_pci_core_device
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69615-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B67AEB4A23
X-Rspamd-Action: no action

Stash a pointer to a device's incoming Live Updated state in struct
vfio_pci_core_device. This will enable subsequent commits to use the
preserved state when initializing the device.

To enable VFIO to safely access this pointer during device enablement,
require that the device is fully enabled before returning true from
can_finish(). This is synchronized by vfio_pci_core.c setting
vdev->liveupdate_incoming_state to NULL under dev_set lock once it's
done using it.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/vfio/pci/vfio_pci_core.c       |  2 +-
 drivers/vfio/pci/vfio_pci_liveupdate.c | 17 ++++++++++++++++-
 include/linux/vfio_pci_core.h          |  1 +
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 3a11e6f450f7..b01b94d81e28 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -569,7 +569,7 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
 		vdev->has_vga = true;
 
-
+	vdev->liveupdate_incoming_state = NULL;
 	return 0;
 
 out_free_zdev:
diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index ad915352303f..1ad7379c70c4 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -131,6 +131,7 @@ static int match_device(struct device *dev, const void *arg)
 static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
 {
 	struct vfio_pci_core_device_ser *ser;
+	struct vfio_pci_core_device *vdev;
 	struct vfio_device *device;
 	struct file *file;
 	int ret;
@@ -160,6 +161,9 @@ static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
 		goto out;
 	}
 
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+	vdev->liveupdate_incoming_state = ser;
+
 	args->file = file;
 
 out:
@@ -171,7 +175,18 @@ static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
 
 static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_args *args)
 {
-	return args->retrieved;
+	struct vfio_pci_core_device *vdev;
+	struct vfio_device *device;
+
+	if (!args->retrieved)
+		return false;
+
+	device = vfio_device_from_file(args->file);
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+
+	/* Check that vdev->liveupdate_incoming_state is no longer in use. */
+	guard(mutex)(&device->dev_set->lock);
+	return !vdev->liveupdate_incoming_state;
 }
 
 static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 1ac86896875c..350c30f84a13 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -143,6 +143,7 @@ struct vfio_pci_core_device {
 	struct notifier_block	nb;
 	struct rw_semaphore	memory_lock;
 	struct list_head	dmabufs;
+	struct vfio_pci_core_device_ser *liveupdate_incoming_state;
 };
 
 enum vfio_pci_io_width {
-- 
2.53.0.rc1.225.gd81095ad13-goog


