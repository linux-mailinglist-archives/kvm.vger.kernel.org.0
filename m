Return-Path: <kvm+bounces-56424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33A80B3DC1F
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 10:18:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C25CF17C0D2
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 08:18:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9222E23BCF8;
	Mon,  1 Sep 2025 08:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eBp90KTV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663BA2110E;
	Mon,  1 Sep 2025 08:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756714699; cv=none; b=FY8XDx8c3HJmpnaCZDlJYIBOxXwGF88VKQSsEqOplCC75o3d1z7fjQAkOVdFLYWKvJODeW0Bfoi/t0kAUt3hr9afNd/X6VWjHnw38yAN5aUWhyXPK4wz5y7wX57htX62RyKXmgcKsiFAs2dhjQQMwTV1bSVY4g6ddhsYKEHUTOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756714699; c=relaxed/simple;
	bh=n2mChHJOpuovt3EkOwskBKLM9hbBlkGgtvGxWx7OgZM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=F0/cfQLtis2fB06brZzZq8Okqkvm/BmAjrUvtQvSNpJUe2STRWQuRH1e+KNpvgol9upwob0CGRCL/CY5d5FwZTV7PLQt/QT7hu1ROqA505tuOKV41oNCRftXLhSdT/9+IHILPP4T2CGXuL6QmbOLodVGgnIsTfpSq92ec6+kN3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eBp90KTV; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-770530175a6so2397909b3a.3;
        Mon, 01 Sep 2025 01:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756714698; x=1757319498; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fhO72zhYOJiaCs0Sw3nOH7x/q+Nik5NH+Mprbd215KE=;
        b=eBp90KTVNT+b7sJbhfHoOGzh/vlSVIurwwOMkwxwkZf1dSkB5f4ULB3bGwGHP4awXY
         8GsjqUtSFp+HHaN/YNEMicpQkNu/R0kjA7urwzHrh5gubjkhGNOGlgABEVjbdtyM5b4q
         5cmY8XLD3TtunFaOPxn5XOtjvFQ7emV0Ki1bgPwa9UrTpue6rOvFTx9hx531Xky/rkeW
         u8peCNe884pOVe4R7c+6mNR9FZMosiw/gMlwEOrucYFQPl/mTDTTzLSEjQoeBqsGIF8Z
         +pmm++8uxdGmVtjrxcR6ltsaIFfEcKOSil3Po+zkzrhf4ziWELpehX6we17K35sWjiMP
         1Rzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756714698; x=1757319498;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fhO72zhYOJiaCs0Sw3nOH7x/q+Nik5NH+Mprbd215KE=;
        b=swBKuI96kwHq30qLnciIBBTibGDPPDH8JnuY188MNjy6WdEBn2T/3uJGshA5w4fOfP
         OgOOEjuVbSZS3Ec7PBynCq8+9OpbBDE+JIo9l389Y8GhZDn5I0rpM9j6MDMtcOOSXIYr
         i5ey0KSY4HoydetpEQd55lwxRXRT0RBgQYooGrNoEvTf/CXIKMClWstnF2o08sJq8mer
         izecf5PU/gdgHFpPznP9/z7PvtcCS7bnoNdK+RoC3b8YVfsm3j2WuxTMWulQc1Yn46p/
         nqMsOGDHAAebPoLLYzKhU5L9zZAD61vaH6c6Ggsy5bCCakDU/jGMzaeWjoZJR4oky0Sk
         KIkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqiFl/Q/UkFI55MstSUh9JKLkz2mcjtJf8UCNNT5LvxL3qqaaXnbDggWlhMdrsFzQx+SE=@vger.kernel.org, AJvYcCVKGNR5AxgwE/e21cfADU+jcBvmn8b1/LDX7eNwfvH4jwPNRFrq05k/Y1wv2PuneKM9cFASJ2olrddITQD2@vger.kernel.org, AJvYcCXuLc6lxHdBmog1vOlmFGfEVMoKatsWP2EjOpNbVQo5MfJGs8lxOZbJRTqJjk8avos7b+p9iRVS@vger.kernel.org
X-Gm-Message-State: AOJu0Yyylr7NdzVEu1gRuhi9Saslbm1LxVKeQbXZU8ixRRGRC6wfCJUY
	/VFC0q5v/3ONmUgWkab2lU8voOxiEzezDhOuqAF/NRr689xe2aIi0Q5B
X-Gm-Gg: ASbGncu3XdhXlP3ue2GWshbN6vAIr+AYmWWRUqbm79890sdOCylMXffrDZsZ2DK9xoN
	qyk50UzMxtHgv0s9Fyp0kYoVZczkDM/Vv23GvY6+vtpoFT9HF8URT8aIFSKAMvodt+fOBviFPmI
	PBcpoWqg5AaOqhT5UEQjSUv471l6EiKks9nQUvBQaVhwgzXs++5FoypeCtRsvhlBo/e288JNFEP
	DA94g0LILVpB6LPHKHnLQBbbPBq3tiqDo5LYIDJWAeoNRQJJOQDBnMlegtbW6cfRjR7UbvQ8+y5
	URycY75JXyX4NWm+kXmV3fDtO07RoeIbNRLp8c8BypX4HJaEPO8cW9B8ttnoNMfsVAR7mwvjI9P
	QSLQcPHvIX/KE/uYXRek14UKRAtZb5I/hliLTtVki3DvT+X4MNWt6xnnBa1BBQHOH2oi9XQrRtM
	UfNjqi8RueWk3Bam6nP9kfwRdZVMFkjP0ctXGOMycL+wnU6w==
X-Google-Smtp-Source: AGHT+IFlIp5XtLRMTgGoktobYhmw4UEb9uqheDBPPdgtLTkETP+vGDUp6jU8cTUi1l23ljJmw1JTGg==
X-Received: by 2002:a05:6a20:6a1b:b0:243:a7f1:ffd3 with SMTP id adf61e73a8af0-243d6f3a6e1mr9609890637.48.1756714697622;
        Mon, 01 Sep 2025 01:18:17 -0700 (PDT)
Received: from vickymqlin-1vvu545oca.codev-2.svc.cluster.local ([14.116.239.35])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-b4f8a0a2851sm868312a12.37.2025.09.01.01.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 01:18:17 -0700 (PDT)
From: Miaoqian Lin <linmq006@gmail.com>
To: Longfang Liu <liulongfang@huawei.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Yishai Hadas <yishaih@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: linmq006@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH] hisi_acc_vfio_pci: Fix reference leak in hisi_acc_vfio_debug_init
Date: Mon,  1 Sep 2025 16:18:08 +0800
Message-Id: <20250901081809.2286649-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The debugfs_lookup() function returns a dentry with an increased reference
count that must be released by calling dput().

Fixes: b398f91779b8 ("hisi_acc_vfio_pci: register debugfs for hisilicon migration driver")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 2149f49aeec7..1710485cbbec 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1611,8 +1611,10 @@ static void hisi_acc_vfio_debug_init(struct hisi_acc_vf_core_device *hisi_acc_vd
 	}
 
 	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
-	if (!migf)
+	if (!migf) {
+		dput(vfio_dev_migration);
 		return;
+	}
 	hisi_acc_vdev->debug_migf = migf;
 
 	vfio_hisi_acc = debugfs_create_dir("hisi_acc", vfio_dev_migration);
@@ -1622,6 +1624,8 @@ static void hisi_acc_vfio_debug_init(struct hisi_acc_vf_core_device *hisi_acc_vd
 				    hisi_acc_vf_migf_read);
 	debugfs_create_devm_seqfile(dev, "cmd_state", vfio_hisi_acc,
 				    hisi_acc_vf_debug_cmd);
+
+	dput(vfio_dev_migration);
 }
 
 static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device *hisi_acc_vdev)
-- 
2.35.1


