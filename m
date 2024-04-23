Return-Path: <kvm+bounces-15700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 542158AF5A6
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 19:38:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FD0228A751
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 17:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7801E1422DE;
	Tue, 23 Apr 2024 17:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WqmHe641"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4054E1420C4;
	Tue, 23 Apr 2024 17:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713893810; cv=none; b=aArvX4/sRPELndyAyRSa1AQtsA38GeiiZgx7UK1zGmgYT4of7W2MaZFEtYnkI2SQVQd1EXTrZNIhfFes+DH+KrV08MaLJhZtjlxVZWYd8hlM2OX/pT90PGvvYHIlyo2flYR2h9HiN5lzcZMIexrNYcLpuZXPu5+sEqnQS2nybYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713893810; c=relaxed/simple;
	bh=wwtTbhuG9ol8BPEiXLffBlM+fdPNlVyKnYnUxJG6aaY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tvQ4SAjmYT/frVq6rOV+7A0dJ5+APaCQjR7qlBFHDEqDux1HG89p2xjqFze01Sn31+Z6pRoOqmmBb7lixe/UL+V4TPGjGrbhkoTA8FD44ePLPGYXOi+iNDIJaxjhOE927Fv4rfwNzyrJowfQ1JeoDlyeJ7bWLC+wBkt2P8VGlEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WqmHe641; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713893809; x=1745429809;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wwtTbhuG9ol8BPEiXLffBlM+fdPNlVyKnYnUxJG6aaY=;
  b=WqmHe641G9XuwTH8KdFsWi2DuNKhV0JxAnfI3t1j2LFr5m8BJSOQWJKk
   7Gk3itH9S7VlJ+vULBMW38oCsus7fn+pcmVGb69YoTwnJliM0ewI7Acqj
   bNvcwizcV4/U+Z/ikjo787JAypw1hwHy3ev3mRlN2aKS2ZtbjARPr/6xe
   ukRsI6iIgtxDtX12Ulo5zkeMDtp4tVpldPcAU3NncFZ2MTMD5M+EozXw5
   EWhDAfeAoE9PLHj8/iVfVFyvaGyls2NQhKtK2Ac+zzZBF+pFA6hxRA5oH
   bQGZINLwNHylNNbHN++/xMJslQF6WGeKuqy3lh06Pl+49VsQ9QTqOfU7P
   w==;
X-CSE-ConnectionGUID: u3yeqmt5SSmP4X+HVPJodQ==
X-CSE-MsgGUID: RchKFx0uTpi4zU95rfwIYQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="9712377"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9712377"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 10:36:43 -0700
X-CSE-ConnectionGUID: YhBqTemiRjygoHUh40xHbg==
X-CSE-MsgGUID: QiSlDfWIQm6L85GckWH47A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="29097410"
Received: from jacob-builder.jf.intel.com ([10.54.39.125])
  by fmviesa004.fm.intel.com with ESMTP; 23 Apr 2024 10:36:42 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
	X86 Kernel <x86@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	iommu@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Lu Baolu" <baolu.lu@linux.intel.com>,
	kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Borislav Petkov" <bp@alien8.de>,
	"Ingo Molnar" <mingo@redhat.com>
Cc: Paul Luse <paul.e.luse@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jens Axboe <axboe@kernel.dk>,
	Raj Ashok <ashok.raj@intel.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	maz@kernel.org,
	seanjc@google.com,
	"Robin Murphy" <robin.murphy@arm.com>,
	jim.harris@samsung.com,
	a.manzanares@samsung.com,
	"Bjorn Helgaas" <helgaas@kernel.org>,
	guang.zeng@intel.com,
	robert.hoo.linux@gmail.com,
	oliver.sang@intel.com,
	acme@kernel.org,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v3  05/12] x86/irq: Reserve a per CPU IDT vector for posted MSIs
Date: Tue, 23 Apr 2024 10:41:07 -0700
Message-Id: <20240423174114.526704-6-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240423174114.526704-1-jacob.jun.pan@linux.intel.com>
References: <20240423174114.526704-1-jacob.jun.pan@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When posted MSI is enabled, all device MSIs are multiplexed into a single
notification vector. MSI handlers will be de-multiplexed at run-time by
system software without IDT delivery.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

---
v2:
 - Add missing CONFIG_ in #ifdef
 - Extend changes to x86 tools
---
 arch/x86/include/asm/irq_vectors.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index d18bfb238f66..13aea8fc3d45 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -97,10 +97,16 @@
 
 #define LOCAL_TIMER_VECTOR		0xec
 
+/*
+ * Posted interrupt notification vector for all device MSIs delivered to
+ * the host kernel.
+ */
+#define POSTED_MSI_NOTIFICATION_VECTOR	0xeb
+
 #define NR_VECTORS			 256
 
 #ifdef CONFIG_X86_LOCAL_APIC
-#define FIRST_SYSTEM_VECTOR		LOCAL_TIMER_VECTOR
+#define FIRST_SYSTEM_VECTOR		POSTED_MSI_NOTIFICATION_VECTOR
 #else
 #define FIRST_SYSTEM_VECTOR		NR_VECTORS
 #endif
-- 
2.25.1


