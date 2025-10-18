Return-Path: <kvm+bounces-60426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id EEE0CBEC20E
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 02:11:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 921D0356134
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 00:11:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD78323D7F3;
	Sat, 18 Oct 2025 00:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HEcscv1V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CA6235C01
	for <kvm@vger.kernel.org>; Sat, 18 Oct 2025 00:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760746075; cv=none; b=iA4P8ZUPMRhyzZJ7YgqWwpRJaRGlRy1ruyoVa5UsYjMhcF9VepRgbWh/ZPUPOdvdNP7l9GLsggptMwSoyhmrKSnrDm0u02UruDczWORlmaM6N15R1B/MPvhDjXCFkpazF2WiYYAdUq5PUFiuSkZFZuxDVyLvcajcFbBE2zDZUok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760746075; c=relaxed/simple;
	bh=rJ9Cp8jLPZnMO/vyHJOv9CStAj+XeO61+5EG/UnxQ6I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z964qGPOxflUnSf02eGkoX/lnc+YASMwci5TcWYezpStL9SEP560x6/FqIxN5WFkRvz9iTECtC7R14zVl+P7XgSxeeJsU/j0go8O5QCcdxUmcIBf6KmkMLjN93vmV8SDHPgu3fdQrSj0CB0Z1a5NtBmngQ0xqjWfTNW515xS27s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HEcscv1V; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33bcb7796d4so1861887a91.0
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 17:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760746073; x=1761350873; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HFNocetE2VbIEufyY6J89R9nWXx5czYypprM6ljkXqw=;
        b=HEcscv1Vg1+LRceN8YgebXldMH2/AFKMrI6eoN/gcTkQuTWVNq1/xZySMxDg10e1+i
         qx1QZZe51Dk9YVjcMoWtJKxpiwwx8gArfuOnc0EEp9UtBi3tV/SVhpYNX8x3T1KH3Lwf
         wefV/qAgxXxeBcPy/fk40s3vJZKF8oS74kzq02fKl/mQI6j+DfUwrFW9mSmOKszrcbC/
         kWz9zKGdCrakboBOQDWg5sBaTQ2nt/7pV6V2y+ORY6Wu9HH9ENX+6tsjQU2H6JVS/00q
         GAnMx0ia6w6Eq59/PhCLg1MoGhhwR1wyZdeuRiCVZloBWyVC5H4mWmUkYlsmMICuhwHk
         cRlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760746073; x=1761350873;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HFNocetE2VbIEufyY6J89R9nWXx5czYypprM6ljkXqw=;
        b=ss5ed3Rf67E2i4YX8LuVQaX1LGCe1yxR/GiVTX1123OSHPZc/BSJvqhSGVB5NgixuD
         seeCXmpGkx/rJzGWs0IbRWqOntEwqbHjjB9lCvwvB1p2F68tnDWnubN0PndOzOPCC0BQ
         h8DkCJUSvAC2qEoitUxq4Je3HJoHoCGjVHCDg82CBYTz6OdTv7vU2md6vztuNNNQuKPn
         ueHupg9WOBSkRmeA5WdrMQWZwUXNjxKb2Rik/RmtBhcizjO2+yPyDk2aM1UjLzDlzp6C
         Wckkx2wjPUqO6qgz/kM/n3ACBzqm4R0YKn6T7HHuJTZSDGMO9PHXUcXUVddEGBQF8fRJ
         KyKg==
X-Forwarded-Encrypted: i=1; AJvYcCXktZ5nQFUoW8n7TKsXzMfSQFM0ahwOqCex0jr0BMUBpKrnTy/LKV1VoyRhxF6T+b/JqOI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyedpt1QcEdS2QomNCBRAUY8XWvWWfQHNfHJqNfn1mc3xAbBEAN
	WXLVoJfL0gtfnRsYyDGw6EchR6b1B7GP31kUGPAy4bg8UJEeQD0HrljDRZylOr2xytVrFgWglC7
	tadV3IlHs9w==
X-Google-Smtp-Source: AGHT+IFd2MPckrXbHJ+w3m/Sn9+Vb5obFxexWw8NG67z05PyUq/AF1LputymSag3PeWe72e5aqm74u1/N/Zh
X-Received: from pjis18.prod.google.com ([2002:a17:90a:5d12:b0:33b:cf89:6fe6])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2411:b0:33b:cfac:d5c6
 with SMTP id 98e67ed59e1d1-33bcfacd677mr4259016a91.29.1760746072971; Fri, 17
 Oct 2025 17:07:52 -0700 (PDT)
Date: Fri, 17 Oct 2025 17:07:09 -0700
In-Reply-To: <20251018000713.677779-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251018000713.677779-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251018000713.677779-18-vipinsh@google.com>
Subject: [RFC PATCH 17/21] vfio/pci: Disable interrupts before going live
 update kexec
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

Disable VFIO interrupts configured on device during live update
freeze callback. As there is no way for those interrupts to be handled
during kexec, better stop the interrupts and let userspace reconfigure
them after kexec.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 drivers/vfio/pci/vfio_pci_liveupdate.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index caef023d007a..5d786ace6bde 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -248,6 +248,22 @@ static int vfio_pci_liveupdate_prepare(struct liveupdate_file_handler *handler,
 	return err;
 }
 
+static int vfio_pci_liveupdate_freeze(struct liveupdate_file_handler *handler,
+				      struct file *file, u64 *data)
+{
+	struct vfio_pci_core_device *vdev;
+	struct vfio_device *device;
+
+	device = vfio_device_from_file(file);
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+
+	guard(mutex)(&vdev->igate);
+	if (vdev->irq_type == VFIO_PCI_NUM_IRQS)
+		return 0;
+	return vfio_pci_set_irqs_ioctl(vdev, VFIO_IRQ_SET_DATA_NONE | VFIO_IRQ_SET_ACTION_TRIGGER,
+				       vdev->irq_type, 0, 0, NULL);
+}
+
 static void vfio_pci_liveupdate_cancel(struct liveupdate_file_handler *handler,
 				       struct file *file, u64 data)
 {
@@ -403,6 +419,7 @@ static bool vfio_pci_liveupdate_can_preserve(struct liveupdate_file_handler *han
 
 static const struct liveupdate_file_ops vfio_pci_luo_fops = {
 	.prepare = vfio_pci_liveupdate_prepare,
+	.freeze = vfio_pci_liveupdate_freeze,
 	.cancel = vfio_pci_liveupdate_cancel,
 	.finish = vfio_pci_liveupdate_finish,
 	.retrieve = vfio_pci_liveupdate_retrieve,
-- 
2.51.0.858.gf9c4a03a3a-goog


