Return-Path: <kvm+bounces-13757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2769689A72B
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 00:27:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D10F01F22F14
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 22:27:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68962178CE9;
	Fri,  5 Apr 2024 22:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PVixcInh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0301176FB5;
	Fri,  5 Apr 2024 22:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712356011; cv=none; b=lnnuGC1UpMwD7cq1yI5/6I9Td1MspHrXc2jD27oL4hKX8NRYlxZC9X5zSKmuCcxJxpjVlHqP3q9DwdaWa49/O99e3EdlXLxab50jMfpMJv0Asj4uQqR5m7wOWxrHLtxh3L2i/eXX+BJBTo6PbJbxkW2UbmUrwXBvJaAA8WP6IPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712356011; c=relaxed/simple;
	bh=0w0uJEzA4z9kskjV3ew8MBQxd2yM5o3G1Z9OFkj0BDg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZMLuTeSDHxG2qw85hYgZDPsVII1xZaOjaDWElyuH+h8BAurh75Er3dcSsYguIDg8ARnn190DXVt09WoEj8nkKScP+gXnwxdcp8tdtQV9Hv3hEDECjiJyLNUmfpyeUMvbpTfT3d5mlaWSQDWyuAqmDnO65ZYAwP0jK6Ql1DMfURw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PVixcInh; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712356010; x=1743892010;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0w0uJEzA4z9kskjV3ew8MBQxd2yM5o3G1Z9OFkj0BDg=;
  b=PVixcInhTvo7UD1kYgCSxxz3PMCX389W6QOtoepLADiuhMSrPPvJoosX
   y0zfH60FAJykVgdvSAQzY54t32oM/rGTaudZ/h7DgA5YYwkAASfpr3SUj
   Mz0boQrM4lMrj34gbxBG1qy+SKirDHttOzNH1rfxU/zN3CnGTK7wC6f/s
   FVDEUBOLFDYTa+gkO93BAJNAsWGy301iiT9uNYtxD8QNqBGxpV40Lf+Ty
   lSTTl7OqQHXxcvsEkbp4PXpwKF/Q+UaB5r1whBKZC+Y6QLwYEciDecnsv
   IysCD+Mv+7Xjtc9X29TLWLCQHAB2zih5+gUx0tbHP3bHsKqeNUepunc/A
   Q==;
X-CSE-ConnectionGUID: a0RflBLhSiuG/eUi+5Nm9w==
X-CSE-MsgGUID: oQW3hgfwR067H4faxH9cHw==
X-IronPort-AV: E=McAfee;i="6600,9927,11035"; a="19062734"
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="19062734"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2024 15:26:48 -0700
X-CSE-ConnectionGUID: YpW3/WDlS+mgWCYtHA3Bjw==
X-CSE-MsgGUID: WoQPFCO3SEuXJvtd4IBqrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="23928320"
Received: from jacob-builder.jf.intel.com ([10.54.39.125])
  by fmviesa004.fm.intel.com with ESMTP; 05 Apr 2024 15:26:47 -0700
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
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v2 05/13] x86/irq: Reserve a per CPU IDT vector for posted MSIs
Date: Fri,  5 Apr 2024 15:31:02 -0700
Message-Id: <20240405223110.1609888-6-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
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
 arch/x86/include/asm/irq_vectors.h       | 9 ++++++++-
 tools/arch/x86/include/asm/irq_vectors.h | 9 ++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index d18bfb238f66..1ee00be8218d 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -97,9 +97,16 @@
 
 #define LOCAL_TIMER_VECTOR		0xec
 
+/*
+ * Posted interrupt notification vector for all device MSIs delivered to
+ * the host kernel.
+ */
+#define POSTED_MSI_NOTIFICATION_VECTOR	0xeb
 #define NR_VECTORS			 256
 
-#ifdef CONFIG_X86_LOCAL_APIC
+#ifdef CONFIG_X86_POSTED_MSI
+#define FIRST_SYSTEM_VECTOR		POSTED_MSI_NOTIFICATION_VECTOR
+#elif defined(CONFIG_X86_LOCAL_APIC)
 #define FIRST_SYSTEM_VECTOR		LOCAL_TIMER_VECTOR
 #else
 #define FIRST_SYSTEM_VECTOR		NR_VECTORS
diff --git a/tools/arch/x86/include/asm/irq_vectors.h b/tools/arch/x86/include/asm/irq_vectors.h
index 3f73ac3ed3a0..989816ca7c9e 100644
--- a/tools/arch/x86/include/asm/irq_vectors.h
+++ b/tools/arch/x86/include/asm/irq_vectors.h
@@ -99,9 +99,16 @@
 
 #define LOCAL_TIMER_VECTOR		0xec
 
+/*
+ * Posted interrupt notification vector for all device MSIs delivered to
+ * the host kernel.
+ */
+#define POSTED_MSI_NOTIFICATION_VECTOR	0xeb
 #define NR_VECTORS			 256
 
-#ifdef CONFIG_X86_LOCAL_APIC
+#ifdef CONFIG_X86_POSTED_MSI
+#define FIRST_SYSTEM_VECTOR		POSTED_MSI_NOTIFICATION_VECTOR
+#elif defined(CONFIG_X86_LOCAL_APIC)
 #define FIRST_SYSTEM_VECTOR		LOCAL_TIMER_VECTOR
 #else
 #define FIRST_SYSTEM_VECTOR		NR_VECTORS
-- 
2.25.1


