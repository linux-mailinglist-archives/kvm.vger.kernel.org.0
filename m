Return-Path: <kvm+bounces-36106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E16A0A17D08
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 12:29:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E034160F99
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 11:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B2911F1520;
	Tue, 21 Jan 2025 11:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SmeCijyD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E941BBBEA;
	Tue, 21 Jan 2025 11:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737458956; cv=none; b=gRuHx0Zc43ffsOewse/5eowZd7+W/ezeyRv+AcbUPq9o1hxT16eL6grWiWSOEJ5XAqkz9Yycf4J/Oa3dY/akKHjzCwt0iDt0AwmyUoI8VKPZq4RGV3C1suDrSOpoQwWTTkRCu4xQFXW60VxVAxaJa+B4aJDz+b/dhz4/ylCLaC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737458956; c=relaxed/simple;
	bh=nh9WsxIxeYysaVr6MxXvDi1AaHkf78v6tjemOkhShrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNV1k0/KMut5Dzo7QjlQWj7LqN9cI4pM9MPrrrJaATqUm7I1A/Y7knh1VfObHs6T/+P35dS18ANGolALuYxVSVq2VwTPNndWPNYnwJmyoBpfn6bMNhvH8m0uZuIvobrAU+gfApkbl6y0E+naWDXSWG3BOdWvujhCLQkvy6AkNyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SmeCijyD; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-216281bc30fso124775405ad.0;
        Tue, 21 Jan 2025 03:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737458954; x=1738063754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xMeTfRxhl9BwEfA37y5uSqDF2UTPmXajFpszd0Y6s+U=;
        b=SmeCijyDOkZIiPeRtg39+fgCjFWhIKlVPhNW5gVmNXIbtdjaGTKQxoCkov2lYldDxM
         7kjYXmif6U/fhadW0WF5jJ7e/qjMJWb8Ycr+LBpD2SB8rlBUenDGj9KfjsNv/w/eonOr
         d+yKRQPsKk4obH95hG5RYDo3ktY1Du9XPtT+85wK9tct5CN5LKxi1vij4BJ+4PM1smCH
         6KgUMObcM2ylDSo6rhjZVzm7lp9Eclk+kwTe2hAqTtFqtuV0i17NQFoS8MI3k2ZAAvVg
         BcewU4i4VM/4fw2YFkOyU0TAtzNU5UEOP95NgUXlUDFGc/draLr1qPFy8AGEXdhagXLG
         rFiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737458954; x=1738063754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xMeTfRxhl9BwEfA37y5uSqDF2UTPmXajFpszd0Y6s+U=;
        b=YSuaPORt9aMNsOGtp2iQ2j7iwKet5vA1Qhz13c5lfvuCfNEEXBDRzWS8sKTC7jpfuB
         UGPFBPUpj9o+vBKVEbQfpr0hj1dE3cup/up9LlDBzQotqpOUzV1eE+TPpKA+6x2qc04U
         Pg8JRrjfZyjsiVyHpQL9+U5ks82Odv5hqlWOivIdwJj11z61UFnc1fZUs2S+cXTuxRLM
         uJz4N5dnPZTWp9cIALJwiNrS+cKAhFfWIH6c9iQNBn5fH96tFK4jLZ7u9PNqHFYeeT8A
         FEvnIPbqszIxZV5Ot1/iw2CHpr9QKvPP3vgCCvwCBznV9+eggdnsg0cd4Mu6IaH/gTkI
         1FeA==
X-Forwarded-Encrypted: i=1; AJvYcCUgxWsODTfrbmB2Xmg9dIr5U6KxrAoFOxen24PL31Slhjqp67Fe0VbDv4G2tdh7tIWJmnw=@vger.kernel.org, AJvYcCWNr0106ZKFB1KHp+3IV+tmCgzD6QypUXkkryZ6ECCuJkOTPNm/xpSGryMURABOb3ecGsAI1UXR1QFXvBdD@vger.kernel.org
X-Gm-Message-State: AOJu0YxQsrl0cHAg4s//cSp7SWz438MP3LeDrXdb8YF4zEx8nSJFInId
	EqP8drDs2CiWWbpx2ogQSTiMxjMD/XwkbSzdxblpxnlhPZs85+Pp
X-Gm-Gg: ASbGncuaNZB+RY55kUinOP+Hacw3XKsgMxo34itTxmHeTj4k65EtG3PNWMqoW42Lk8e
	uuq+Ws7jVjlP18ZXDEG9C8NpZGbw6CbmVwsirR6IMoH7RdRvFdwO1/07HBqho1T27ZXMt8MUiOL
	9/wDYFR6ICr/pJb0yrUR2zohaCFQXAMUktUZhOHzyg5a08k/hE0NVmbCO1EcWDPuBAmFh4nBwcr
	irez1l79Pfwl1JQ+pQpilOXh7UZ+vA4lTsdFRCDYU2Xo2McBws7H/qwjToo6ZMXbCiV0UvhDhzM
	gi/7lDsm
X-Google-Smtp-Source: AGHT+IHqVYYJ45lIlWyRx33N4odTV9sw1wF9+nrODrrB/LpvgiOepFLlCXIlPAeAhhX+P42rZbOKUw==
X-Received: by 2002:a17:903:1cc:b0:216:2474:3c9f with SMTP id d9443c01a7336-21c357b6a7bmr218434175ad.52.1737458954143;
        Tue, 21 Jan 2025 03:29:14 -0800 (PST)
Received: from tiger.hygon.cn ([112.64.138.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2cea1fdesm75385965ad.26.2025.01.21.03.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 03:29:12 -0800 (PST)
From: Wencheng Yang <east.moutain.yang@gmail.com>
To: east.moutain.yang@gmail.com,
	alex.williamson@redhat.com,
	jgg@ziepe.ca
Cc: iommu@lists.linux.dev,
	joro@8bytes.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	robin.murphy@arm.com,
	suravee.suthikulpanit@amd.com,
	will@kernel.org
Subject: [PATCH v3 3/3] iommu/amd:Clear encryption bit if the mapping is for device MMIO
Date: Tue, 21 Jan 2025 19:28:36 +0800
Message-ID: <20250121112836.525046-3-east.moutain.yang@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250121112836.525046-1-east.moutain.yang@gmail.com>
References: <CALrP2iW11zHNVWCz3JXjPHxyJ=j3FsVdTGetMoxQvmNZo2X_yQ@mail.gmail.com>
 <20250121112836.525046-1-east.moutain.yang@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When SME is enabled, memory encryption bit is set in IOMMU page table
pte entry, it works fine if the pfn of the pte entry is memory.
However, if the pfn is MMIO address, for example, map other device's mmio
space to its io page table, in such situation, setting memory encryption
bit in pte would cause P2P failure.

Clear memory encryption bit in io page table if the mapping is MMIO
rather than memory.

Signed-off-by: Wencheng Yang <east.moutain.yang@gmail.com>
---
 drivers/iommu/amd/amd_iommu_types.h | 7 ++++---
 drivers/iommu/amd/io_pgtable.c      | 2 ++
 drivers/iommu/amd/io_pgtable_v2.c   | 5 ++++-
 drivers/iommu/amd/iommu.c           | 2 ++
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index fdb0357e0bb9..b0f055200cf3 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -434,9 +434,10 @@
 #define IOMMU_PTE_PAGE(pte) (iommu_phys_to_virt((pte) & IOMMU_PAGE_MASK))
 #define IOMMU_PTE_MODE(pte) (((pte) >> 9) & 0x07)
 
-#define IOMMU_PROT_MASK 0x03
-#define IOMMU_PROT_IR 0x01
-#define IOMMU_PROT_IW 0x02
+#define IOMMU_PROT_MASK 0x07
+#define IOMMU_PROT_IR   0x01
+#define IOMMU_PROT_IW   0x02
+#define IOMMU_PROT_MMIO 0x04
 
 #define IOMMU_UNITY_MAP_FLAG_EXCL_RANGE	(1 << 2)
 
diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index f3399087859f..dff887958a56 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -373,6 +373,8 @@ static int iommu_v1_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 			__pte |= IOMMU_PTE_IR;
 		if (prot & IOMMU_PROT_IW)
 			__pte |= IOMMU_PTE_IW;
+		if (prot & IOMMU_PROT_MMIO)
+			__pte = __sme_clr(__pte);
 
 		for (i = 0; i < count; ++i)
 			pte[i] = __pte;
diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index c616de2c5926..55f969727dea 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -65,7 +65,10 @@ static u64 set_pte_attr(u64 paddr, u64 pg_size, int prot)
 {
 	u64 pte;
 
-	pte = __sme_set(paddr & PM_ADDR_MASK);
+	pte = paddr & PM_ADDR_MASK;
+	if (!(prot & IOMMU_PROT_MMIO))
+		pte = __sme_set(pte);
+
 	pte |= IOMMU_PAGE_PRESENT | IOMMU_PAGE_USER;
 	pte |= IOMMU_PAGE_ACCESS | IOMMU_PAGE_DIRTY;
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 16f40b8000d7..9194ad681504 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2578,6 +2578,8 @@ static int amd_iommu_map_pages(struct iommu_domain *dom, unsigned long iova,
 		prot |= IOMMU_PROT_IR;
 	if (iommu_prot & IOMMU_WRITE)
 		prot |= IOMMU_PROT_IW;
+	if (iommu_prot & IOMMU_MMIO)
+		prot |= IOMMU_PROT_MMIO;
 
 	if (ops->map_pages) {
 		ret = ops->map_pages(ops, iova, paddr, pgsize,
-- 
2.43.0


