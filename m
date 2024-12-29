Return-Path: <kvm+bounces-34398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A3A249FDFCA
	for <lists+kvm@lfdr.de>; Sun, 29 Dec 2024 16:52:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A19CA7A1B45
	for <lists+kvm@lfdr.de>; Sun, 29 Dec 2024 15:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 341481917F1;
	Sun, 29 Dec 2024 15:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UFI7WU0V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E528D208D0;
	Sun, 29 Dec 2024 15:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735487509; cv=none; b=kRcYkBAEhflVgO90YUw56BDJHh3NAiiYwlfE8Hut7yMrD/fIs7DayPp8ZmEIvVguo7HY2uiXuC75Ny14UtYJFEsfsDBzP2ZcbO9v9LcS+Gq64hrTniCYpCO/rV3/cXjiCMWG6dTWqi/97my5XkTaVxs6CxfCCd//yNAP0OXaIOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735487509; c=relaxed/simple;
	bh=DNVcbCRh4x2zgia0s7gbQ6k84DKlZBb6gNg7bsPyBVw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K1G7R69FfNeqDEnAb20Lnju04Z+3cMOKzNWspvIvpE8/qGwldPSseR3quUsj/Ws7aAmrlgoXOsTcfj+0bavVr2oisO+i0ikHMdF9Au/BXU3tvcxlMVRmIf2KG7HI8St8ulNDX1zprR+q1R4G+bq/yV+Fbs2PhYFyuAVdq4npqZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UFI7WU0V; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-21619108a6bso100290375ad.3;
        Sun, 29 Dec 2024 07:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735487507; x=1736092307; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ijBpkDqZGXJNQMxE2jySXDIC33fYCLnTgnMq0ig2yv8=;
        b=UFI7WU0V8xO5EI7zK4S3m0+BPBJOClevB16UJ1gMOJYyC/+DPbCfGqVhpReVdABgJA
         4fTTdHHC2DJIxzx6ZZj+M3wBPWPRyE1EYkMrh+ebMtlDXVnM8IJ8qi5dMAVJpplrRiST
         lxBCAuWRW4osYJpyUdW4wNNsW0DUWQbkRDcI7zvz83SSfmKq4F3rL5hAW5ObWFC5tTVJ
         jbH4+Rsdk6J3WQTqLwS8FDORhjcIutZGpIQr/4gGswB/YOhk4c4dTcFhpLV5urVFf07L
         Q2zOTC6PVQ4qeEDo8GPmzQ1qwrN/lNTBgk7tg7F91vpLTPA1Qpvy8BTfWYeb0dTGQsor
         oDsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735487507; x=1736092307;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ijBpkDqZGXJNQMxE2jySXDIC33fYCLnTgnMq0ig2yv8=;
        b=GLJEKDrja7foAtPO0uDOvOU1qIKnbSp+qiltCiQVAnJAC2qVo6NG5bEtJKiY11rziw
         kQeK3EOEngtOLBgpwU03zbZYftzd5ecQLifnVlwUIHrJQnc/myS+Po+eYjJTaK+nNMVo
         UcwBaufHC8o3tz4hNWVXDtdiG1sbDmynSO22fHM8QcHvTJ0NCy27oY8ExYEKaQCLUjgb
         WjUgsqb6gM+1lsQQvgu0CvMmeAFf8r0JaEG2OudubQFxjh58nd/CCUiMtT+rBXrNbMHB
         1O13TQQ5l8xyh8kcm//gtO7IWfzI+rjVUNzQF1/82iE3dKECx2my2GgiwOWsLHntTwx6
         WmNg==
X-Forwarded-Encrypted: i=1; AJvYcCUh9xqabYKYvpKauochEBKsQ1oNuL58299M846xNfksvthwnkvAxyyei9FyBB+mZg1HE/Eb0bKxK//g1f52@vger.kernel.org, AJvYcCVXGUtjV81I93tvCfBTjyHy4c2KgFdaTsezuZr2Y/ueevXO49RqSq0y4dEcAF4mQ21jaSc=@vger.kernel.org
X-Gm-Message-State: AOJu0YynBiBxbrhLOesfrkzbiAoRC4/Pysitd4cI6G6W84kkXlpHW2JV
	rh8KFqL6ry9hkW4jxUnBsiFf43bCtOFgEuMjCRDiWemdKu1VnUc=
X-Gm-Gg: ASbGncvMMQTYqg97dXayxZ/XZcayJXsAeFQoB9CYdlwz1gdlq2GieKRnC0burLze1zY
	mQQMnFhgbmu33dwB4dZv4qL24s5+HdE53uiAyPoR2prgtak7X2XXHhPOFiswzRVhlnt+oO3rPxp
	y+8c+7+gLYwjk9sHhKtj1j0A+G+OA74rsE2XNeKb0K++EGfsN0WexemKiKZ3rUEnvSH8aR86EG2
	tv+jR22OxAkvxQJzMGKrqCPoQ16YCzieGTRBlrbbhm5L1K1v2xxtfVx2aOqYWn/IfWDLA==
X-Google-Smtp-Source: AGHT+IF+Q7MtTpwbAQh3NqR+z0D+CvUkzhuECNiyuJt72YjrMD2JK/qwIQef5j71dq4LV7cpSNrEnA==
X-Received: by 2002:a17:90b:51cd:b0:2ea:7329:43 with SMTP id 98e67ed59e1d1-2f452def21cmr46943875a91.6.1735487507105;
        Sun, 29 Dec 2024 07:51:47 -0800 (PST)
Received: from localhost.localdomain ([58.38.120.107])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f44779990csm19236343a91.6.2024.12.29.07.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 07:51:46 -0800 (PST)
From: Tomita Moeko <tomitamoeko@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Tomita Moeko <tomitamoeko@gmail.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] vfio/pci: update igd matching conditions
Date: Sun, 29 Dec 2024 23:51:40 +0800
Message-ID: <20241229155140.7434-1-tomitamoeko@gmail.com>
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
 drivers/vfio/pci/vfio_pci.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index e727941f589d..051ef4ad3f43 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -111,9 +111,11 @@ static int vfio_pci_open_device(struct vfio_device *core_vdev)
 	if (ret)
 		return ret;
 
-	if (vfio_pci_is_vga(pdev) &&
+	if (IS_ENABLED(CONFIG_VFIO_PCI_IGD) &&
 	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
-	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
+	    ((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA ||
+	     (pdev->class >> 8) == PCI_CLASS_DISPLAY_OTHER) &&
+	    pdev == pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(2, 0))) {
 		ret = vfio_pci_igd_init(vdev);
 		if (ret && ret != -ENODEV) {
 			pci_warn(pdev, "Failed to setup Intel IGD regions\n");
-- 
2.45.2


