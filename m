Return-Path: <kvm+bounces-69613-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IHDED4jQe2m0IgIAu9opvQ
	(envelope-from <kvm+bounces-69613-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:26:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C95B7B49E9
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:26:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 265383017CB9
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 21:26:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51E8135BDC7;
	Thu, 29 Jan 2026 21:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MjNid7Wr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC2935E530
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 21:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769721952; cv=none; b=jR4JMIBCttTlvqYC6mQLT34BAj2Rm4BlIEcaL76cdCbjo2DjbuoxCVhaj1zGX1wtdXi+81cUrv0veTKBxk4yaU3ZBT8xEg6AynIkHdtcdHDQ6cwYe1MNNdR4/vVFPRKf1nOvl1VwJmNE6hYGX4+7kfDA9oxUGPbEj05yEJeRDUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769721952; c=relaxed/simple;
	bh=s2EF+0wW+b5BmyDvXoLeRzuJ8QMd8hJHZ8kLYdzRY0Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W728IjMwNOk1Vwz+jCWLjrULVTYeoSujBfJPsIV9m6uSqA6FWpLvSnCZzImw1Zv8lnEnLWc3Y2e2Qwj8HS+7uRqiR0OytZ/6CAWH84PLK+UyKdjlgXuUGz251o3qkezBM4EI5Bmatm+jZr0AcMnIYWaLCkHOILgflpfbG09Gzrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MjNid7Wr; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0a0bad5dfso30902955ad.0
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 13:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721949; x=1770326749; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AVUDzL5NEoLRiR0kq4rtjTLHEzT2c4a+QSQgWmkEpoo=;
        b=MjNid7WrOyEJT1IuYZdcgcGfdihVHcDFOUlYLCAAuNkFKHRth/gQaAA5frJ1KHYwur
         kM5Z22z3Y2+cE4N4p8JS27nWJCBRsTo15KFDUdzKxCnr6PYbR/4o9j8xOK8jCAyIoh4A
         KE1IC+P4h9JuZCG5aOio+d3OVeBq448eX7STBsLxM839FCDNyTuzboldeBZWoY/cx3EN
         N/RyJkYmSyCdlyGvL3fffoA8tswrFrLYVO9wRG1b1ygGrn4YWuT4DmmqPFuE/rKfHO9c
         kc2UW9GgqiJvZcyH9VAK1bNVrAQnAM+CshOPTrugIaT00cEpaW/uHFdi20QfcdmEl8bA
         Ovrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721949; x=1770326749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AVUDzL5NEoLRiR0kq4rtjTLHEzT2c4a+QSQgWmkEpoo=;
        b=r5yZLcoPLG7SmiPTvMkzktgHVZjNuGZqJddiGEF8YR+jAzkyCv0OOY2fm4RhXHRqMZ
         p8/nIfn4mWkGvlbtpVeYCxwt9GD/gCX8Bhg7Lrb30Qnhgs9XH9wddcudCLT+cvPDEf83
         pCxTTTl7OLaaVmndFMdOb/dCOXICAmZE7FS9IQkleZonn0W7nxkYndSD4H1dULswSpzP
         SIoK/rY+3AV0DIHeAZpv7pc7vHbJ/PF6sLcfJO/QCJ8nrt3L7WNZ0+bqUC8yOWzWQnWY
         GyM7WBgWHaJ+ainkWmkjss9BUws4bH9Y2E4Go1HpEQQKD7cUP63G7dU1g2OZezBK3lfx
         q8gg==
X-Forwarded-Encrypted: i=1; AJvYcCUXZ4ixO8VpqEi5AXW20LqPfThWSLiA6hOSwPD+fsqfxXguKidr5q/LxwQOiQb+/wPzFvc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzpunh7G2w2eA2UR5RfFKt9jIHuUVoY94x11YOcOErchup4H0wF
	quz3A3WKv/ljnwMUxLsDzbut9Q3A/0oWFmtjIwgroa5hvEjoOp2jFavQCVVug/9cDH7ihIIokeJ
	WG8xm+/qFmgttXg==
X-Received: from pllm10.prod.google.com ([2002:a17:902:768a:b0:2a0:a0e0:a9c3])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:124c:b0:2a1:3ade:c351 with SMTP id d9443c01a7336-2a8d959a4bamr5657375ad.2.1769721949051;
 Thu, 29 Jan 2026 13:25:49 -0800 (PST)
Date: Thu, 29 Jan 2026 21:24:54 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-8-dmatlack@google.com>
Subject: [PATCH v2 07/22] vfio/pci: Notify PCI subsystem about devices
 preserved across Live Update
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
	TAGGED_FROM(0.00)[bounces-69613-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: C95B7B49E9
X-Rspamd-Action: no action

Notify the PCI subsystem about devices vfio-pci is preserving across
Live Update by registering the vfio-pci liveupdate file handler with the
PCI subsystem's FLB handler.

Notably this will ensure that devices preserved through vfio-pci will
have their PCI bus numbers preserved across Live Update, allowing VFIO
to use BDF as a key to identify the device across the Live Update and
(in the future) allow the device to continue DMA operations across
the Live Update.

This also enables VFIO to detect that a device was preserved before
userspace first retrieves the file from it, which will be used in
subsequent commits.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/vfio/pci/vfio_pci_liveupdate.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index 7f4117181fd0..ad915352303f 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -53,6 +53,8 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
 	if (IS_ERR(ser))
 		return PTR_ERR(ser);
 
+	pci_liveupdate_outgoing_preserve(pdev);
+
 	ser->bdf = pci_dev_id(pdev);
 	ser->domain = pci_domain_nr(pdev->bus);
 
@@ -62,6 +64,9 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
 
 static void vfio_pci_liveupdate_unpreserve(struct liveupdate_file_op_args *args)
 {
+	struct vfio_device *device = vfio_device_from_file(args->file);
+
+	pci_liveupdate_outgoing_unpreserve(to_pci_dev(device->dev));
 	kho_unpreserve_free(phys_to_virt(args->serialized_data));
 }
 
@@ -171,6 +176,9 @@ static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_args *args)
 
 static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
 {
+	struct vfio_device *device = vfio_device_from_file(args->file);
+
+	pci_liveupdate_incoming_finish(to_pci_dev(device->dev));
 	kho_restore_free(phys_to_virt(args->serialized_data));
 }
 
@@ -192,10 +200,24 @@ static struct liveupdate_file_handler vfio_pci_liveupdate_fh = {
 
 int __init vfio_pci_liveupdate_init(void)
 {
+	int ret;
+
 	if (!liveupdate_enabled())
 		return 0;
 
-	return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
+	ret = liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
+	if (ret)
+		return ret;
+
+	ret = pci_liveupdate_register_fh(&vfio_pci_liveupdate_fh);
+	if (ret)
+		goto error;
+
+	return 0;
+
+error:
+	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
+	return ret;
 }
 
 void vfio_pci_liveupdate_cleanup(void)
@@ -203,5 +225,6 @@ void vfio_pci_liveupdate_cleanup(void)
 	if (!liveupdate_enabled())
 		return;
 
+	WARN_ON_ONCE(pci_liveupdate_unregister_fh(&vfio_pci_liveupdate_fh));
 	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
 }
-- 
2.53.0.rc1.225.gd81095ad13-goog


