Return-Path: <kvm+bounces-66692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B2D3CDDE11
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 16:14:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2AE04301AD37
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 15:14:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B57C3271F1;
	Thu, 25 Dec 2025 15:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YgD6Jq8z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B167A32570F
	for <kvm@vger.kernel.org>; Thu, 25 Dec 2025 15:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766675668; cv=none; b=dlVKBBRl4FhQ+Iidg4dxKcRuB9lzsDDD0Bz+oXw5/yLUOteREzB5ZNO8b15zjkKFwCYPJGBLNMj1DeWmPdMoTBNXHvY+YRrWs272fFAVUDKpULAGYlQwG85wNY1D/uHZQO+tSssMGYIISCC7kqNMjACueNtK66VvSmf8hqu19b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766675668; c=relaxed/simple;
	bh=zrRepONqIcsuxD2qRt8uUb3Hu7HQL9DjDNsFfLzb3qk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TUnjMbbTlm6jMc9xOPgdNMa4XfsNNg9nwJfZTZXiXNkwFG9jBngSnnHM+WPIkU3d84R8akS/cGuo1Q5ykcXY7R6MKUDclx8yaYHMo+faWziAg6XpCJxwK0XVWHfkN5Qugm+AZAB4DI5g/80ymB9QjxHRcA9Zhj9Ptr91/2ydZUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YgD6Jq8z; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-598f81d090cso7136908e87.2
        for <kvm@vger.kernel.org>; Thu, 25 Dec 2025 07:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766675665; x=1767280465; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CRsUoCK6ChAGV/EtS0TA3rEDcBe8J8WItk/OJdEL24A=;
        b=YgD6Jq8zrZsqpF4NOMl9jQEFwBAX8+3884k+WtluPtpk68qzYZ2Az9nw9tg9DyBz+E
         1RDn20zK1sJx6+gH4Ge9TiJ4HhTOsHfo1QXLzZRpvjLFTfdZIIVSr0a/JNr8m+7c8TcK
         1hSTOnGUT6AeF1PKwEd442wVOm6qnQlrIw1YYk6/7SxVP818lELy5II5F80EYnDhimcE
         ipbCe8nB4ZN0nuECE64Eh3f++o/CulBBwGR38kMwX6U5LhW/CtTcehd5V/aB9bdXmFv6
         4azVHQw1Mr0Chcu+gKWqAJgJI3wzdmpIlwsytXPCt5bMTr2KnesdKIuIPf8wAWjafxju
         XJVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766675665; x=1767280465;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CRsUoCK6ChAGV/EtS0TA3rEDcBe8J8WItk/OJdEL24A=;
        b=d+QI437QqVTZuuiOsZx7WY5WSlfVUs1NGeZ6yiuqATFBo7heRpSHGa4hXM+pq0nV4F
         t58Pb6lD7CBujhRzi2PuXddrLug9TFAr66smL52KI/b1qFBr3pv1q/QH1lov1qR8MKWv
         jMH7LwFCSBKL9aUmbvKGKmDhpX+deAeLHmCOoieL1VJS5UL3W5YCiMk045dnT7YV43Xt
         HpjMrxJLTw2uPbfdkyWYSQDVCCfvgqxfb4NEN8X/AZbDS2gokw+ogvWoS00vKKdRUafs
         AP1ei6DzEj4Rj1jiV6B2tTfinjF1klBYtP2tY3MyHwYGvabkeQ0Sb4B15V5Ei1pon2x2
         ytjg==
X-Forwarded-Encrypted: i=1; AJvYcCVo3e2RQKMz5H2NSWah9LjINd6JNVyeW6K4sViRiq5+CgTlYljqxngQl9CWRykSP4bXg/A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4Iez7XH8HcK0OLwE7ervKh2vl3ayzID9MSVfqyto8jjbt1xZb
	n5cHCjrTm34bvSwWgp6zI0db+lg8ADOt3jMOGmoBOoHh41ChET4xrJd6
X-Gm-Gg: AY/fxX4f9orH7cRY76V9Vv02vzFH1Vf/qZnq5i0sV36/woE8BhUEvqEuAdXbIMjCSUo
	QSKAfaK6nYlkPae1x1HJlAFECvIbnNPiwqlDhqg6Z0XND5huD6+zLuJ5mJu9OhFosZtDW6I6QA7
	j4cOyYuBb7cVa0ZiHg8JRmhCEgk84D/V2WCqj4RqT4yywmVvhWawEqPGJdyq2GAjBIUhzcMpzCh
	80yKl901bCSslOOOXAzIo6zvdz1SA+TkYBB23AVul1YaH636PEfRtpQ9StyiA7zhkGbHFobgWKo
	tnJXOrKvP7Cig2SS+VVazG7t1k1iQDYUGqtbTWq4xHgh92cmbcur+Nfl+GjgJf6zEq6VAfEcbS5
	/Z9EoJ2efnIJz+Ty4+xBUIIdAEEA/KPxbS/+UHgl79J7F2uGMCqRHX9QR+4vMzyfr9GtfFuQ9T8
	VxYcORaw0oVHo3EM+6wQAlYOs1ShzTF8z6T7U4
X-Google-Smtp-Source: AGHT+IG3fUB1OsaIHa7q7zKQFUnyBJ8l/j3vz64gfQ66ecODeQkSk6h74hXbYooIM/aC2AokrIX88g==
X-Received: by 2002:ac2:4e0a:0:b0:594:2db8:312b with SMTP id 2adb3069b0e04-59a17cff3c1mr6593946e87.7.1766675664468;
        Thu, 25 Dec 2025 07:14:24 -0800 (PST)
Received: from localhost.localdomain ([176.33.67.19])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59a186203eesm5866402e87.77.2025.12.25.07.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Dec 2025 07:14:23 -0800 (PST)
From: Alper Ak <alperyasinak1@gmail.com>
To: michal.winiarski@intel.com
Cc: Alper Ak <alperyasinak1@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	kvm@vger.kernel.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] vfio/xe: Fix use-after-free in xe_vfio_pci_alloc_file()
Date: Thu, 25 Dec 2025 18:13:49 +0300
Message-ID: <20251225151349.360870-1-alperyasinak1@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

migf->filp is accessed after migf has been freed. Save the error
value before calling kfree() to prevent use-after-free.

Fixes: 1f5556ec8b9e ("vfio/xe: Add device specific vfio_pci driver variant for Intel graphics")
Signed-off-by: Alper Ak <alperyasinak1@gmail.com>
---
 drivers/vfio/pci/xe/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/xe/main.c b/drivers/vfio/pci/xe/main.c
index 0156b53c678b..8e1595e00e18 100644
--- a/drivers/vfio/pci/xe/main.c
+++ b/drivers/vfio/pci/xe/main.c
@@ -250,6 +250,7 @@ xe_vfio_pci_alloc_file(struct xe_vfio_pci_core_device *xe_vdev,
 	struct xe_vfio_pci_migration_file *migf;
 	const struct file_operations *fops;
 	int flags;
+	int ret;
 
 	migf = kzalloc(sizeof(*migf), GFP_KERNEL_ACCOUNT);
 	if (!migf)
@@ -259,8 +260,9 @@ xe_vfio_pci_alloc_file(struct xe_vfio_pci_core_device *xe_vdev,
 	flags = type == XE_VFIO_FILE_SAVE ? O_RDONLY : O_WRONLY;
 	migf->filp = anon_inode_getfile("xe_vfio_mig", fops, migf, flags);
 	if (IS_ERR(migf->filp)) {
+		ret = PTR_ERR(migf->filp);
 		kfree(migf);
-		return ERR_CAST(migf->filp);
+		return ERR_PTR(ret);
 	}
 
 	mutex_init(&migf->lock);
-- 
2.43.0


