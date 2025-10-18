Return-Path: <kvm+bounces-60418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA13EBEC1F9
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 02:11:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05905407DAE
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 00:09:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5019D1805E;
	Sat, 18 Oct 2025 00:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G4MJr3Te"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF3F1862A
	for <kvm@vger.kernel.org>; Sat, 18 Oct 2025 00:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760746061; cv=none; b=Qv8H8FvCW/n7UCOXhSw+s5qZaI5b0+G0XMuTwhsW0wG7IYCjsNU+wqjVXcoA4LLhvX1MPyxrgRzRU9TpsP4R2x4MrOBxJKPRPUhD6HN/UUL3XYLFB/9MvNv+w+Fk93iG3XQmoDIeViP8tsNTD5CqhrlHRQF163QdQ4qSySfLKlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760746061; c=relaxed/simple;
	bh=V76LbfI6Ajfy7OIRb8JcXF9vRsTvCVLWBlvUz+UEmyg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a8PQLWS9hkCynBLd8j+yh33x5w3Twh+moEbBy/8Ixn1j61JSKYGrEQIGC7i/sOVnl8jfJeViEzRfbMEdEfzei8tZOjqwy3tRTNL5WOVmY47Lv392zSnPW8aHxdZHEN5rB7z8t7k9Etgk18QTw2WTUs8Up6F0saVbxtdePel2l58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G4MJr3Te; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b557abaad02so3907460a12.3
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 17:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760746059; x=1761350859; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GaQ2mjvzcYnMnP1cm0axc8iEarDnxUhNwXsWFDf7Cg4=;
        b=G4MJr3Tef5Amf3FG17p+7c4g/NBzHmwxyZsXr+P8rDwbgd0ogtRFXOHzZ3y8jdLMP2
         bQpIMmnBeUwnrmag100OIhfyB/K37VIMvuC9vEF1OKQAAmGYCuZS31CvbmJDgzJta+yx
         Aqtox1IkRo8Ce4A8ILiyYR6euo/OQ30eY8PHUcqw0pOSNS9sh0gBlDdndjBKNoSR2SIT
         mQunujn5/z+zngMmSwaKCL+MyCQ+mxCxEPTcjjhqj4b9tGsYy8Of+qRolMVw49L2elNy
         kHt/LcNFB9Q7lpdqIPEZBQuoPeRTcqT3VGlnKXd12DiIsVTdbxXoSpdSKsbS3lZNkQiT
         DP0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760746059; x=1761350859;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GaQ2mjvzcYnMnP1cm0axc8iEarDnxUhNwXsWFDf7Cg4=;
        b=pIDHORWaoxkZht5zKqLkhIbIkN/QMuNBo0zYLNRcRT0rl8M1JAFRM5ha153SIb1Wjh
         BvALP1Py0OT4DdJU6W672Gqw6XzeO/7x3MbxuFIuE0lr2dwUZXazOvnOJCLeRw7rIZoW
         41/L8EtaJxWTRbysAgAW3EofCpXTrHa7ZV6PvDYCaCaSVh+eDOFcudZwK0GJMELeWq5g
         8mEj8mfy7Ycg0kGg3j+ANZwKGcXt7Rf3Dod2KkbHKg8SECJE8IxQXnBlGNd7rJZaNdgj
         J3Wby07Y+gkCjd6tjnghSfqiq/Lea9egjScqf1aD6oJ5dDqC4bpcp+ql7l0zHPQJELN9
         vNhQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxFl1woPSyPWFa4p2ZDfYntHoEpnuJHpcv5ikRnTS03tM4cC+T9QbFqIhab/afXfL2wGI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyB5UrohRAc9q1B18TRG4eLtuXwfT7QuqkgtMmV38HiuPRL1jXG
	rsrgw/vz4MbJxalMYnvqObWgyL/GM5WRM1OZjLRP+PssX99DSOY9zKaHYaMZsEFW2elkcPDzGev
	O9tl/QgmjdQ==
X-Google-Smtp-Source: AGHT+IF9dj9Clef1an1TtVMDSsqxw8xp26H//zMhQIxwHrxbjHJhb8hDM1WzMLrsR8CmCfH4zUTMov9736X/
X-Received: from plri16.prod.google.com ([2002:a17:903:32d0:b0:268:11e:8271])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cf0b:b0:24c:cb60:f6f0
 with SMTP id d9443c01a7336-290cb66025amr69035715ad.58.1760746058804; Fri, 17
 Oct 2025 17:07:38 -0700 (PDT)
Date: Fri, 17 Oct 2025 17:07:01 -0700
In-Reply-To: <20251018000713.677779-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251018000713.677779-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251018000713.677779-10-vipinsh@google.com>
Subject: [RFC PATCH 09/21] vfio/pci: Add Live Update finish callback implementation
From: Vipin Sharma <vipinsh@google.com>
To: bhelgaas@google.com, alex.williamson@redhat.com, pasha.tatashin@soleen.com, 
	dmatlack@google.com, jgg@ziepe.ca, graf@amazon.com
Cc: pratyush@kernel.org, gregkh@linuxfoundation.org, chrisl@kernel.org, 
	rppt@kernel.org, skhawaja@google.com, parav@nvidia.com, saeedm@nvidia.com, 
	kevin.tian@intel.com, jrhilke@google.com, david@redhat.com, 
	jgowans@amazon.com, dwmw2@infradead.org, epetron@amazon.de, 
	junaids@google.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add finish() callback implentation in LUO file handler to free restored
folio. Reset the VFIO device if it is not reclaimed by userspace.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 drivers/vfio/pci/vfio_pci_liveupdate.c | 33 ++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index cb3ff097afbf..8e0ee01127b3 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -82,6 +82,38 @@ static int match_bdf(struct device *device, const void *bdf)
 	return *(u16 *)bdf == pci_dev_id(vdev->pdev);
 }
 
+static void vfio_pci_liveupdate_finish(struct liveupdate_file_handler *handler,
+				       struct file *file, u64 data, bool reclaimed)
+{
+	struct vfio_pci_core_device_ser *ser;
+	struct vfio_pci_core_device *vdev;
+	struct vfio_device *device;
+	struct folio *folio;
+
+	if (reclaimed) {
+		folio = virt_to_folio(phys_to_virt(data));
+		goto out_folio_put;
+	} else {
+		folio = kho_restore_folio(data);
+	}
+
+	if (!folio)
+		return;
+
+	ser = folio_address(folio);
+
+	device = vfio_find_device_in_cdev_class(&ser->bdf, match_bdf);
+	if (!device)
+		goto out_folio_put;
+
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+	pci_try_reset_function(vdev->pdev);
+	put_device(&device->device);
+
+out_folio_put:
+	folio_put(folio);
+}
+
 static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_handler *handler,
 					u64 data, struct file **file)
 {
@@ -156,6 +188,7 @@ static bool vfio_pci_liveupdate_can_preserve(struct liveupdate_file_handler *han
 static const struct liveupdate_file_ops vfio_pci_luo_fops = {
 	.prepare = vfio_pci_liveupdate_prepare,
 	.cancel = vfio_pci_liveupdate_cancel,
+	.finish = vfio_pci_liveupdate_finish,
 	.retrieve = vfio_pci_liveupdate_retrieve,
 	.can_preserve = vfio_pci_liveupdate_can_preserve,
 	.owner = THIS_MODULE,
-- 
2.51.0.858.gf9c4a03a3a-goog


