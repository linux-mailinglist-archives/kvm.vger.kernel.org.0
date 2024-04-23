Return-Path: <kvm+bounces-15706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48EA58AF5B3
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 19:39:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7AFD81C2434C
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 17:39:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5DDE1442EF;
	Tue, 23 Apr 2024 17:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b8dlkeyz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8890C143C72;
	Tue, 23 Apr 2024 17:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713893824; cv=none; b=OzA0kfCmcYH+hpEBRiK5We/rJsNcK9vb8EIIdxHgM2IE+n2ogl00ggTxiz4iA/TOgFYDT2r5vS3HMo/r0QSRyf8+KCQjQozROrU26OYuWh5x9FKMxyOjPcSS2gmf6zOwqNmhhiJ8jGTo7jOJOeIYBLQV7mSxQI802ZTbvAZFv70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713893824; c=relaxed/simple;
	bh=q8QeE6nuXSOURuZNt8kCfl8/JENOtnFrdLBjB61d8vI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hSV2p175aDMumVNDqbOR7uIMRiX1gbKCCGnHIiGUah8wqpD8+UlM2A3LBQieBy1lF45dvICZkid2YeRM71FHPqpjz1SwYv1uYW/ArcGx0fA4y+CJYI2YpkMMKd6eMdHEKV+FIrdlkpUEYA/hhsHtLEkOlvFPHLaqRkwM962IVLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b8dlkeyz; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713893823; x=1745429823;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q8QeE6nuXSOURuZNt8kCfl8/JENOtnFrdLBjB61d8vI=;
  b=b8dlkeyziG6JceAPiuz56PrYUEhB32XYTpYUXHrs1b14iz9nSXttS+g7
   evstaMpRh+eoZcqmWdeDOTVcn1kZlOPXxBAXJuXhQ0rLcss8C7Mzs7htu
   GOjL80l/tnAb214jxFbMNp7EMwDbH4wm3MaqGIb7CoQu+T/RT5oyXGSGH
   xuVnOnYVpe41XzEtNS8jXhkzvibhrbsLyeAJDAo8ysjEaDnX2M4JoHyLj
   hju95HNnj7XO+wQ3+hFp1SMRTbMj/tgzIjJsJSRXC0O/i3Bk8L2uFzloS
   dUAixkrF8E4oLiKGvzXkVJSn7hRPizxfsJa9bjsLesAOmYpMZnU0BaWOh
   Q==;
X-CSE-ConnectionGUID: 6jMtqhHgQV6NJKlsX+dQZQ==
X-CSE-MsgGUID: 4DJnnC5KRai7NrG4pxdS/Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="9712519"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9712519"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 10:36:47 -0700
X-CSE-ConnectionGUID: N+PPI++YTRe+eIgsHt7gXA==
X-CSE-MsgGUID: d9aKFJoFRweTt8pFQSr/GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="29097470"
Received: from jacob-builder.jf.intel.com ([10.54.39.125])
  by fmviesa004.fm.intel.com with ESMTP; 23 Apr 2024 10:36:46 -0700
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
Subject: [PATCH v3  11/12] iommu/vt-d: Make posted MSI an opt-in cmdline option
Date: Tue, 23 Apr 2024 10:41:13 -0700
Message-Id: <20240423174114.526704-12-jacob.jun.pan@linux.intel.com>
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

Add a command line opt-in option for posted MSI if CONFIG_X86_POSTED_MSI=y.

Also introduce a helper function for testing if posted MSI is supported on
the platform.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

---
v3: Delete unnecessary checks for disable_irq_post || disable_irq_remap.
    (Kevin)
---
 Documentation/admin-guide/kernel-parameters.txt |  1 +
 arch/x86/include/asm/irq_remapping.h            | 11 +++++++++++
 drivers/iommu/irq_remapping.c                   |  9 ++++++++-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 902ecd92a29f..6de1459bc312 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2251,6 +2251,7 @@
 			no_x2apic_optout
 				BIOS x2APIC opt-out request will be ignored
 			nopost	disable Interrupt Posting
+			posted_msi enable MSIs delivered as posted interrupts
 
 	iomem=		Disable strict checking of access to MMIO memory
 		strict	regions from userspace.
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 7a2ed154a5e1..e46bde61029b 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -50,6 +50,17 @@ static inline struct irq_domain *arch_get_ir_parent_domain(void)
 	return x86_vector_domain;
 }
 
+#ifdef CONFIG_X86_POSTED_MSI
+extern int enable_posted_msi;
+
+static inline bool posted_msi_supported(void)
+{
+	return enable_posted_msi && irq_remapping_cap(IRQ_POSTING_CAP);
+}
+#else
+static inline bool posted_msi_supported(void) { return false; };
+#endif
+
 #else  /* CONFIG_IRQ_REMAP */
 
 static inline bool irq_remapping_cap(enum irq_remap_cap cap) { return 0; }
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index ee59647c2050..eec3547dbf80 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -24,6 +24,10 @@ int no_x2apic_optout;
 
 int disable_irq_post = 0;
 
+#ifdef CONFIG_X86_POSTED_MSI
+int enable_posted_msi;
+#endif
+
 static int disable_irq_remap;
 static struct irq_remap_ops *remap_ops;
 
@@ -70,7 +74,10 @@ static __init int setup_irqremap(char *str)
 			no_x2apic_optout = 1;
 		else if (!strncmp(str, "nopost", 6))
 			disable_irq_post = 1;
-
+#ifdef CONFIG_X86_POSTED_MSI
+		else if (!strncmp(str, "posted_msi", 10))
+			enable_posted_msi = 1;
+#endif
 		str += strcspn(str, ",");
 		while (*str == ',')
 			str++;
-- 
2.25.1


