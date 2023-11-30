Return-Path: <kvm+bounces-3018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D7877FFBEE
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 21:05:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0886C2819D4
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 20:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EB3D53E1D;
	Thu, 30 Nov 2023 20:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="JWvcC1pa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8E410EF
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 12:04:51 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id d75a77b69052e-423a9cb7e80so7780141cf.3
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 12:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1701374690; x=1701979490; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=fJ0QwjQQA2sBtrYbspl5aVVUOMzblP9BjaUBDTeLH4Y=;
        b=JWvcC1pal6xpzSMiXVKZ3LQWZozJh6A68OUbhMc5HRIydkr2zGclYGsoJMJXTZz/xs
         wBvXNrKMp+st2rF2sSrc4rm64ugrwZ6ftqedxwvgQcvemmg79FRklmKg33ZLoCybcAah
         DZSHbV3+bEYb0cFvieT7waWSk8+wi90inMdP+q29IYSfY6KgOjSDqdiENr34B2XtYvtm
         yB2gTK51h0fqJ8z31ZAhb7BcO3laOA0FGB1xwfLTh2Y2aa3hxOjBdgjdTXVGkqcpu7d0
         hDN/QRI+D7KA543aO91anP+nM0HHk5+pcVBuHKEDF0RgAohC9rYWJHld/+m1ZSoHeDiA
         bWQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701374690; x=1701979490;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fJ0QwjQQA2sBtrYbspl5aVVUOMzblP9BjaUBDTeLH4Y=;
        b=AthfxZKlRuARN5k0trcEIhoUbdZvc4+F6VyD0USdNndmLnQg3ALn9QMHCRLS21HIKA
         cZ3g7P+0yU6ziQ4Dh5GaLOsTGGRB1e8Kt6XR4ymcsZbYwG+46UgQGl6xglVqxpG2G3q3
         looY5I5/00e85PSocBX4d6cIfVxjOILBoRhtyMvJc2E73GBdPijcGFVeaiAaxn3+CjH+
         MePKyZbsnmaWJ5HwHEI690bYlEIptDSDN+pQNevLy26CrecbcX80swWXcKmd96jxSxi9
         U+jYfvmsbq9/BoLoELCMUAWorH/19d1QeXcC7KSMWphhBzG/VDBBby5d7Vu2CzfOchSo
         ehcg==
X-Gm-Message-State: AOJu0Yyp8Fe771uuDL477M4NP1RE/qkhhiUoYiiYaT/oY54cC1Eam0t9
	NiHWpKMRDR3c+X8ROPNfvN5i9/PzBdymFZTtDoI=
X-Google-Smtp-Source: AGHT+IFTod/Py9hcH5oQn6ff5l7Gu58O8B3tXKspAhOROVnCb0qH7k4XfRrSgp2nr3dD/2mySscuWA==
X-Received: by 2002:ac8:7c46:0:b0:423:8e6a:f7a with SMTP id o6-20020ac87c46000000b004238e6a0f7amr26732427qtv.64.1701374690104;
        Thu, 30 Nov 2023 12:04:50 -0800 (PST)
Received: from soleen.c.googlers.com.com (55.87.194.35.bc.googleusercontent.com. [35.194.87.55])
        by smtp.gmail.com with ESMTPSA id f27-20020ac86edb000000b0041ea59e639bsm787447qtv.70.2023.11.30.12.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 12:04:49 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	pasha.tatashin@soleen.com,
	mst@redhat.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] vhost-vdpa: account iommu allocations
Date: Thu, 30 Nov 2023 20:04:47 +0000
Message-ID: <20231130200447.2319543-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iommu allocations should be accounted in order to allow admins to
monitor and limit the amount of iommu memory.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 drivers/vhost/vdpa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

This patch is spinned of from the series:
https://lore.kernel.org/all/20231128204938.1453583-1-pasha.tatashin@soleen.com

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index da7ec77cdaff..a51c69c078d9 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -968,7 +968,8 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 			r = ops->set_map(vdpa, asid, iotlb);
 	} else {
 		r = iommu_map(v->domain, iova, pa, size,
-			      perm_to_iommu_flags(perm), GFP_KERNEL);
+			      perm_to_iommu_flags(perm),
+			      GFP_KERNEL_ACCOUNT);
 	}
 	if (r) {
 		vhost_iotlb_del_range(iotlb, iova, iova + size - 1);
-- 
2.43.0.rc2.451.g8631bc7472-goog


