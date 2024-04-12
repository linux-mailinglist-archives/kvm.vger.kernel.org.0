Return-Path: <kvm+bounces-14492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EB508A2C69
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:35:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 233911F22F63
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 587E3548E4;
	Fri, 12 Apr 2024 10:34:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A16753D3A5
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918072; cv=none; b=F4OUZPtDKQqXXyNg2qMP2qO3hkLVFDgRIxDs7giIhWaGrBJdrP/kLQJUxnM8/bi2/PFioJ0EXqWmv30apQz7e3hDYPEIGJ/GrkPUA8bsaDxIJgnnKR6N09VOYGByP1r8Y7hafqdBt05hPI5J9vbxOIe+gKQaSOaBI+DQnQZ1VO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918072; c=relaxed/simple;
	bh=wGw6CcIJAysOApAC+Vfzho1XvYBd6h7CzTUlgE3tGXU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rU0rVNBeHRu+0fgw5P4ZL2+1hiERglQ8z4XNz05aXB9/7PgUcqZYmrO9oCkqKCz61favZB8zIJYhVjMU6JOv8CisfJApO9jJ4Q9jeuL9xRiuVj0xRb4EsOPp95FTFiZNyVleUmn81ioJci5zYWs7EURQOCDbwPWdThkK7pYhfk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D324113E;
	Fri, 12 Apr 2024 03:35:00 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7C6C83F64C;
	Fri, 12 Apr 2024 03:34:29 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 06/33] arm: Move io_init after vm initialization
Date: Fri, 12 Apr 2024 11:33:41 +0100
Message-Id: <20240412103408.2706058-7-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

To create shared pages, the NS_SHARED bit must be written into the
idmap. Before VM initializations, idmap hasn't necessarily been created.
To write shared pages, access must be done on a IPA with the NS_SHARED
bit. When the stage-1 MMU is enabled, that bit is set in the PTE. But
when the stage-1 MMU is disabled, then the realm must write to the IPA
with NS_SHARED directly.

To avoid changing the whole virtio infrastructure to support pre-MMU in
a realm, move the IO initialization after MMU enablement.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 lib/arm/setup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 34381218..fbb8f523 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -262,9 +262,6 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 	/* cpu_init must be called before thread_info_init */
 	thread_info_init(current_thread_info(), 0);
 
-	/* mem_init must be called before io_init */
-	io_init();
-
 	timer_save_state();
 
 	ret = dt_get_bootargs(&bootargs);
@@ -275,6 +272,9 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 
 	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
 		setup_vm();
+
+	/* mem_init and setup_vm must be called before io_init */
+	io_init();
 }
 
 #ifdef CONFIG_EFI
-- 
2.34.1


