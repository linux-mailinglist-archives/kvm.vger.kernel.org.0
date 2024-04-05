Return-Path: <kvm+bounces-13762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1555B89A736
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 00:29:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38BE01C22EED
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 22:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 875EB17A915;
	Fri,  5 Apr 2024 22:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZmaRQILT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E607D17921A;
	Fri,  5 Apr 2024 22:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712356015; cv=none; b=MHRYe+gGTza7qckoXTUJaacjrPkr2Hv/rNefPpqocp2bamDliEU+1A9ipE9m8br6UQQW3Y+xNSpTAB1OXfeNDsRcNNLe5ajGMW/MDPRSMAEFf+SG+IgqQd/xBZGSjCwsaAySEwv+Eqp6qQ0nlRhucMZNPVgfUbS73daYxrVxV1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712356015; c=relaxed/simple;
	bh=ki4jrj4UXSWxXrhulX5LioleJEjgSCmUEPsdgUkrskk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hn35xc+rQjIwchCAscoy1Fl33kCMHN7pRrRxVsBMSzbjCTxeeT7ujj/C7dC8Xv1uQaV6z8Vz3PYjUb0kDjefGvJhpfW81r9iCHJAash3yUuCimXtXLIUDgiLH7xh5GlyvoQobhZNgxLZRxbhnoX81qgxAti2deApIr9vVYBR4XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZmaRQILT; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712356014; x=1743892014;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ki4jrj4UXSWxXrhulX5LioleJEjgSCmUEPsdgUkrskk=;
  b=ZmaRQILTndojmMC8iz7ZFpTo0yR49+M4j9dsSgykxS0slcQMFwcCS3zs
   3AGzitEnAjkoxha8HHXc7UhnV+7QH6SNVaKDgLOnyB/0VisdX35nBOWZQ
   PJvh5EgqBTD5NR5pjpSKiurbEa8s2oWaZStBkKav6VY5FsWESolWqWqDU
   oXBB6FbzTncSmpBXS54kWaf2xfB5JGJS9GiPed3TQT4FcJC7dFgXO5vxK
   gOP8+ZrDzs8TxFOMXCyRIGfRZh1LcX9COVCLgH17PcDOvxH6h/PTAYaD4
   w6bLeNg92xt9ZtOPIN41kT/MvAB7uyQW1RnOK55nqTs/fNrai5rge4d2T
   A==;
X-CSE-ConnectionGUID: m0PDuNw5Rt2EEzaTzsmJzA==
X-CSE-MsgGUID: i+hxoaDxSPW2N/Ujw3C2Zg==
X-IronPort-AV: E=McAfee;i="6600,9927,11035"; a="19062821"
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="19062821"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2024 15:26:52 -0700
X-CSE-ConnectionGUID: l268QKSvQXOxZq6H118Ylg==
X-CSE-MsgGUID: iNNQOOp0RZeFkQxr0/UccQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="23928343"
Received: from jacob-builder.jf.intel.com ([10.54.39.125])
  by fmviesa004.fm.intel.com with ESMTP; 05 Apr 2024 15:26:51 -0700
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
Subject: [PATCH v2 11/13] iommu/vt-d: Make posted MSI an opt-in cmdline option
Date: Fri,  5 Apr 2024 15:31:08 -0700
Message-Id: <20240405223110.1609888-12-jacob.jun.pan@linux.intel.com>
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

Add a command line opt-in option for posted MSI if CONFIG_X86_POSTED_MSI=y.

Also introduce a helper function for testing if posted MSI is supported on
the platform.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 Documentation/admin-guide/kernel-parameters.txt |  1 +
 arch/x86/include/asm/irq_remapping.h            | 11 +++++++++++
 drivers/iommu/irq_remapping.c                   | 13 ++++++++++++-
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index bb884c14b2f6..e5fd02423c4c 100644
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
index ee59647c2050..5672783c9f1f 100644
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
 
@@ -70,7 +74,14 @@ static __init int setup_irqremap(char *str)
 			no_x2apic_optout = 1;
 		else if (!strncmp(str, "nopost", 6))
 			disable_irq_post = 1;
-
+#ifdef CONFIG_X86_POSTED_MSI
+		else if (!strncmp(str, "posted_msi", 10)) {
+			if (disable_irq_post || disable_irq_remap)
+				pr_warn("Posted MSI not enabled due to conflicting options!");
+			else
+				enable_posted_msi = 1;
+		}
+#endif
 		str += strcspn(str, ",");
 		while (*str == ',')
 			str++;
-- 
2.25.1


