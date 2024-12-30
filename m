Return-Path: <kvm+bounces-34413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 506B79FE8EF
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2024 17:11:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D596D1882AF5
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2024 16:11:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58BCC1ACEA5;
	Mon, 30 Dec 2024 16:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JkzAr1V1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF5F1AA1F1;
	Mon, 30 Dec 2024 16:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735575072; cv=none; b=hot08KhED9xGc8Ry4TC8h4knJp4yRfXCDSYW0Yo+etzZQBKJEvRFEZ4KdmSVdy0KmOLg1g1eeanTnoUhgLwTmD3XbAvnNgc0mq5RNuMB1XWIblVTUjMe3FU40kgdEO4M/K998tGVAbLc5xOifuDMFXqEz0FjpsQ4t9TgPNs/ovQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735575072; c=relaxed/simple;
	bh=1AVPAYoXslvavTPivZNky0rzLp0dAJkxcuVUsczJU78=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OB5wprLY2B3f6OaGLw6qoywWmiXTZFCFUyKCN/Nz+P/zMqpaKl7e7jqyXAeFkd/IERQjpCFVyqspiwmYLD6Oq9XQWrDm8l3mVmK64FkH0Bcw83IgS08H1Yyi19grdoosGjppK9w718IBrHWM72KmeeRF8yiT2VhnkyVYdj0JKC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JkzAr1V1; arc=none smtp.client-ip=209.85.214.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-21a1e6fd923so66155075ad.1;
        Mon, 30 Dec 2024 08:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735575070; x=1736179870; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ETJHS6ckaBqe0qYPt6TMRIUqoDCklxygA6Q1jLCfsZc=;
        b=JkzAr1V1sUkQGIpJA3MAl3578Itp0/ZH4Z5QqN0lgtu8igyGw1TYvTKMOBZLl/qZD5
         TuMr5BkFDtKYa07Dp8DoxgvUaiQqdXeYJdwD48E+Qm2+s2TRH57Khh6sioH5R9AfiPMf
         JV8fDWl3qz4N/ogXo0qOQxz1odsF8qK3F8DurpNLml/RFEnGhx2kEK2tFjThroFplYvR
         tiU6OCnwk2GZHabsAaps4t2OHuiOR8d6+XmU5dijZP954lvC8coJWUOL81BPGk13+nm6
         fEKUByF2S5sZtWVa6H63cTgkLvMe/fkvqo/9Cj1YhQRgvRHfLbPTBMcbPeOWzbThY1+R
         QkQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735575070; x=1736179870;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ETJHS6ckaBqe0qYPt6TMRIUqoDCklxygA6Q1jLCfsZc=;
        b=FgA3jvhLxG7hvhdfBPMXvYVlCKg5qK4SHsjHXEYa5jBLJtHM6iSlSAl/weYSfwnrEG
         dLa0ap3Jxm86NSSonZuPfGOcjgxShhaCJaC0YWeGv/fZwmtPgeGP52lNV2EnM03Bn0pF
         oZ8D/49D8wtf9piP91nR02qvbhy5Li5+BhyPvpVm7ED85Q5CZSgRCsXR3iJUurYqEp8K
         sbIEsgzmdqwzKO/qL8WhUyvO0m9yBMktfEZIhfDFTCFzW4KA1XwAGbJA8acJiAqaLMzK
         xBOmVp8iYGz6pZnikF+d3qoCOeL+xUoSSnDT2onVUZA1/v7pMUl3VdJtUzKvKE37v2nl
         Ti7g==
X-Forwarded-Encrypted: i=1; AJvYcCUXt+jUrzXsGWt7A8zVjM+KFAj8DJZFYDZd+uyhITwBkv1sdVKUvOfLjJxdYpoIdb7QWyE=@vger.kernel.org, AJvYcCWJMTEMDEDv0ayuNt5wCzUxqQj6bi7pJ5XLmr1NnMU4t1yUSEKSDhHcraV1K663l/JLFBMBCgk7sMcdSQXi@vger.kernel.org
X-Gm-Message-State: AOJu0YwyH7y/5Gd7sUBIh8H4gxiu9yb7l/kCHwhJIAYAVLgnkOVRMSew
	6/FAK9nNwb4yG8KbtpqlQK1M/mZYmtakVVa2yjkuTKOQ7QI4fk8=
X-Gm-Gg: ASbGncsELX0n8/w/Z0lUaanFQhNITMHO39AEiJk8Iib6Dn7yvFxMwtG7B3gdQvkQK6G
	DttOQpZ2CCNqIKrV5/Mguzw0mqnm1QxVl3iuIiSx5/hGmCfxsWDShtUj4Z7cqe3YvTgxAE5CxW/
	qcb4JTYq4fZYQb1997KxmQSoJw3E9w1PVDb/QlKRnPM6uSvre7SAAhwg+tztUYdBt32KjXwQ6BX
	XtCv99t1NIfHbEmJW1g71rKMt2XlwXUh7GpncJMI8sjYdHH5vf1W718Ax8UikD+NM6hEw==
X-Google-Smtp-Source: AGHT+IEA3RYx7YTGeV2m6sPtIvxG+ypNTltHJtyioUG+H0d09tfNsyz8a/qWRkiBgGNqv7Jl+FbfDQ==
X-Received: by 2002:a05:6a00:1144:b0:72a:8b8f:a0f1 with SMTP id d2e1a72fcca58-72abde8462dmr55616347b3a.20.1735575070361;
        Mon, 30 Dec 2024 08:11:10 -0800 (PST)
Received: from localhost.localdomain ([58.38.120.107])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad90c149sm19389389b3a.191.2024.12.30.08.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Dec 2024 08:11:10 -0800 (PST)
From: Tomita Moeko <tomitamoeko@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Tomita Moeko <tomitamoeko@gmail.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] vfio/pci: update igd matching conditions
Date: Tue, 31 Dec 2024 00:10:54 +0800
Message-ID: <20241230161054.3674-2-tomitamoeko@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

igd device can either expose as a VGA controller or display controller
depending on whether it is configured as the primary display device in
BIOS. In both cases, the OpRegion may be present. Also checks if the
device is at bdf 00:02.0 to avoid setting up igd-specific regions on
Intel discrete GPUs.

Signed-off-by: Tomita Moeko <tomitamoeko@gmail.com>
---
Changelog:
v2:
Fix misuse of pci_get_domain_bus_and_slot(), now only compares bdf
without touching device reference count.
Link: https://lore.kernel.org/all/20241229155140.7434-1-tomitamoeko@gmail.com/

 drivers/vfio/pci/vfio_pci.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index e727941f589d..906a1db46d15 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -111,9 +111,11 @@ static int vfio_pci_open_device(struct vfio_device *core_vdev)
 	if (ret)
 		return ret;
 
-	if (vfio_pci_is_vga(pdev) &&
-	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
-	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
+	if (IS_ENABLED(CONFIG_VFIO_PCI_IGD) &&
+	    (pdev->vendor == PCI_VENDOR_ID_INTEL) &&
+	    (((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA) ||
+	     ((pdev->class >> 8) == PCI_CLASS_DISPLAY_OTHER)) &&
+	    (pci_dev_id(pdev) == PCI_DEVID(0, PCI_DEVFN(2, 0)))) {
 		ret = vfio_pci_igd_init(vdev);
 		if (ret && ret != -ENODEV) {
 			pci_warn(pdev, "Failed to setup Intel IGD regions\n");
-- 
2.45.2


