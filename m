Return-Path: <kvm+bounces-36402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D8E6A1A7E8
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 17:34:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6ADDC3A3A96
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 16:34:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82F1B21325C;
	Thu, 23 Jan 2025 16:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bq7mjq5V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD5FF4F1;
	Thu, 23 Jan 2025 16:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737650076; cv=none; b=jYW9HozBjqofYaIjGm2d8ZqPBSA8b4bHfzyeYo6JepmbtozxsIpozWZKRSOJav1aUQY5Y8PPTotvs+fw6ctInmleTuEzV80v4pXv8uDeu7fSWSNyTH8c7cAu0Ptm7L0Oo6q70XcGi6ner7SZQazn4aSuHGAWGA3JcgQP3kQBpOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737650076; c=relaxed/simple;
	bh=Hg5RB7UpKRce3aj4onmff/gfMBSB9q6DnReFUcl4DFE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hmOYw6Cng4Qrw3k3PG4TQO9irofNS4ZoWgozvkwzwZl4vh+xKlHZaz5nZ66YQSTK8lqnk2x29GT7KnN8LK4gde9+hHjLHMb6etXQ1FNrNgjNLZQfiaOayv2XOPRCKL4hOUSDEtlL8+33FXqMcQfj0WktCXCZ0JIAYPAtRK04toY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bq7mjq5V; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-21631789fcdso31484775ad.1;
        Thu, 23 Jan 2025 08:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737650074; x=1738254874; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vfAYd0+bLlysrEnQ2PXnYZBaiFGKmawZpmxKg8FYLSI=;
        b=bq7mjq5VYtcLf4vcd8hiwksxBYyZGlsO/74f/xcy40NVbaaTfGrNn32eubhElBmLg/
         jTcU5YNHu82YyBuDTQxm1IhYI/mQwv4TrQQrDmg0/BKEBuz4LVpq1f9ehTYHwdAY5Lsx
         zfSpyh/dnUe4r97uQGxeLM8YggGqexwgl4HVICUxBSNWFuqg5nRrUs1kpLu4d1khI2hb
         4M87V895P5wyilasNBTh8OJ7Uabs8OrhqDsw7MYkiZrbiuEG09+qVrA6mqfD/XZpLVpl
         tA6Vo3ZF72vmBPbddWF4OaGIu2pNRrYQbXb5XJfTDPrU85pRKPiH1I/q7pKXRJHdsmYl
         yBag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737650074; x=1738254874;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vfAYd0+bLlysrEnQ2PXnYZBaiFGKmawZpmxKg8FYLSI=;
        b=Df6r6N3BsDDzVc9vgbUB66K6fnTn3zhO8L4NKvQqjiGu+3jFQMwyW4F6hGhYooZv1v
         O+iS14TIQHUDa/VKcS5TJjM9NsepX/Iy2ihGd4wLH4ykKOMXXYUzKUQKLOcE7RJMATPE
         39MCPIXMLvLTy7LfjZr75GBW4B9MCRVoh11AaRn+GmdAXgz78G4u+3HnzhWtVjvtioyn
         q+AzWwd1HNgV9PfFu3IU2EH+wWSR3zCr+82bEjDhfd+H4qPuxvQ2VJSmoZtwSO/u96+E
         BDnYv4gX5sOPBceYFbX0/c3UmRpU+lCJbI3T9J6ponPYXD1Wfc8ACdE5nxPGBvv+iCzV
         LYRg==
X-Forwarded-Encrypted: i=1; AJvYcCUW10/+727SZGJG9lzVwnn9eNBzXiukrkhxt90AOLQv10qizGvudevsttu6qc8x6lNgg9t7o3Chnaw9nVQC@vger.kernel.org, AJvYcCV/sntqWBUnqMeY206pSqyQPbcXYrXWZdHQlZ2V8cDf7RrZ6ElhO7ZVE3pZBbKSvPBjF9k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrWFaClqp1yLAOYCxxmswnTF4bKMr11Of7nFfYBZoKcKvPLL2J
	xGsoC0MGbt7eWaPrTWxeTFISPLI8S0Ati/d1zij8wEizXYS9kUU=
X-Gm-Gg: ASbGncvYapjj06fBH4NYCcKdgz2NFHA0UyW7zyQrL2ZMiB8J9799L8UJj0ZMCQKtyIz
	Hp9DeNYBjvq6UPmcAW5XkBB0dR4HFr1VPZEKmP/n2phmVn+ifXdzdEFKNgyTEtO/at4I6l5hbHC
	Iw+MaPbhZPr5w944UeTyn6fGHayzdWGkssvwmWn5zmhOR3FA3fuzcJX0LAD2MlqHnGgMEKrlVpF
	GxYD9/vOEcrMkBGGSVkPsteSgrL0FUJ2Dn7y+lEgrrCWbugiX3PV7xRqlboddUNIO2M4Ba3hd6S
	Pm29KqlatvwaYcIJsw==
X-Google-Smtp-Source: AGHT+IG0kZzcy1BA/flXibrV7aQWSpL3oHz9BKFUcqiDLBTpMepuh7S6Z0U1RZMVaHudJUlRhRPuwA==
X-Received: by 2002:a05:6a21:32a6:b0:1e0:d0b9:9a90 with SMTP id adf61e73a8af0-1eb6978f712mr6219586637.13.1737650072924;
        Thu, 23 Jan 2025 08:34:32 -0800 (PST)
Received: from localhost.localdomain ([58.37.175.151])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ac495d56669sm59315a12.58.2025.01.23.08.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 08:34:32 -0800 (PST)
From: Tomita Moeko <tomitamoeko@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Tomita Moeko <tomitamoeko@gmail.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] vfio/pci: match IGD devices in display controller class
Date: Fri, 24 Jan 2025 00:34:15 +0800
Message-ID: <20250123163416.7653-1-tomitamoeko@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IGD device can either expose as a VGA controller or display controller
depending on whether it is configured as the primary display device in
BIOS. In both cases, the OpRegion may be present. A new helper function
vfio_pci_is_intel_display() is introduced to check if the device might
be an IGD device.

Signed-off-by: Tomita Moeko <tomitamoeko@gmail.com>
---
Changelog:
v3:
* Removed BDF condition as Intel discrete GPUs does not have OpRegion
* Added a helper function to match all possible devices with base class
* Renamed from "vfio/pci: update igd matching conditions"
Link: https://lore.kernel.org/lkml/20241230161054.3674-2-tomitamoeko@gmail.com/

v2:
Fix misuse of pci_get_domain_bus_and_slot(), now only compares bdf
without touching device reference count.
Link: https://lore.kernel.org/all/20241229155140.7434-1-tomitamoeko@gmail.com/

 drivers/vfio/pci/vfio_pci.c      | 4 +---
 drivers/vfio/pci/vfio_pci_igd.c  | 6 ++++++
 drivers/vfio/pci/vfio_pci_priv.h | 6 ++++++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index e727941f589d..5f169496376a 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -111,9 +111,7 @@ static int vfio_pci_open_device(struct vfio_device *core_vdev)
 	if (ret)
 		return ret;
 
-	if (vfio_pci_is_vga(pdev) &&
-	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
-	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
+	if (vfio_pci_is_intel_display(pdev)) {
 		ret = vfio_pci_igd_init(vdev);
 		if (ret && ret != -ENODEV) {
 			pci_warn(pdev, "Failed to setup Intel IGD regions\n");
diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index dd70e2431bd7..ef490a4545f4 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -435,6 +435,12 @@ static int vfio_pci_igd_cfg_init(struct vfio_pci_core_device *vdev)
 	return 0;
 }
 
+bool vfio_pci_is_intel_display(struct pci_dev *pdev)
+{
+	return (pdev->vendor == PCI_VENDOR_ID_INTEL) &&
+	       ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY);
+}
+
 int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
 {
 	int ret;
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 5e4fa69aee16..a9972eacb293 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -67,8 +67,14 @@ void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_device *vdev,
 					u16 cmd);
 
 #ifdef CONFIG_VFIO_PCI_IGD
+bool vfio_pci_is_intel_display(struct pci_dev *pdev);
 int vfio_pci_igd_init(struct vfio_pci_core_device *vdev);
 #else
+static inline bool vfio_pci_is_intel_display(struct pci_dev *pdev)
+{
+	return false;
+}
+
 static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
 {
 	return -ENODEV;
-- 
2.45.2


