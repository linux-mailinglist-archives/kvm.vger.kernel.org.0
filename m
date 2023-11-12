Return-Path: <kvm+bounces-1527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 818CD7E8E32
	for <lists+kvm@lfdr.de>; Sun, 12 Nov 2023 05:13:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2F2C1C20821
	for <lists+kvm@lfdr.de>; Sun, 12 Nov 2023 04:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 209538473;
	Sun, 12 Nov 2023 04:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YCQghsjy"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D76323B7
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 04:12:12 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF31F30E6;
	Sat, 11 Nov 2023 20:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699762329; x=1731298329;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DCQy9ziTOxUJmllg1ZKA+yDNfB6XKqM3GiK9nVcKCAU=;
  b=YCQghsjykYPIODV/cTAWzVgUuAeAK8PDeSLxVJshMN5xAqY1ATLNgBCd
   luG9Xl3TJ2tjOZPzcPU/rpHasoRoeIiVxWoL8zEQJ0guBBnj2UbKU4Vwt
   83WORiv0QzLXv6LXPDrnX/bFBjRjlJjNI5XY3b+caDHQvAP1KmlaMPyGc
   KCpZfyxiPaAb5XA326wg4XmR8Xt42Udl1f7jHZHZyfsqK4AcVBBGuAAhs
   9ME1w6nVMSLdhz6ndICtAbTYoW3HLYjeUDF8PDOXEpisMYuNT5bkrfetS
   ykd62ZjqlYqrvCSv1bDF6441cD914ppwJ+heh5bEgyQfo8Yx2jRvtbcZf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10891"; a="476533880"
X-IronPort-AV: E=Sophos;i="6.03,296,1694761200"; 
   d="scan'208";a="476533880"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2023 20:12:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10891"; a="713936747"
X-IronPort-AV: E=Sophos;i="6.03,296,1694761200"; 
   d="scan'208";a="713936747"
Received: from srinivas-otcpl-7600.jf.intel.com (HELO jacob-builder.jf.intel.com) ([10.54.39.116])
  by orsmga003.jf.intel.com with ESMTP; 11 Nov 2023 20:12:08 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
	X86 Kernel <x86@kernel.org>,
	iommu@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Lu Baolu" <baolu.lu@linux.intel.com>,
	kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Borislav Petkov" <bp@alien8.de>,
	"Ingo Molnar" <mingo@redhat.com>
Cc: Raj Ashok <ashok.raj@intel.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	maz@kernel.org,
	peterz@infradead.org,
	seanjc@google.com,
	"Robin Murphy" <robin.murphy@arm.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH RFC 04/13] iommu/vt-d: Add helper and flag to check/disable posted MSI
Date: Sat, 11 Nov 2023 20:16:34 -0800
Message-Id: <20231112041643.2868316-5-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow command line opt-out posted MSI under CONFIG_X86_POSTED_MSI=y.
And add a helper function for testing if posted MSI is supported on the
CPU side.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/irq_remapping.h | 11 +++++++++++
 drivers/iommu/irq_remapping.c        | 17 +++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 7a2ed154a5e1..706f58900962 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -50,6 +50,17 @@ static inline struct irq_domain *arch_get_ir_parent_domain(void)
 	return x86_vector_domain;
 }
 
+#ifdef CONFIG_X86_POSTED_MSI
+extern unsigned int posted_msi_off;
+
+static inline bool posted_msi_supported(void)
+{
+	return !posted_msi_off && irq_remapping_cap(IRQ_POSTING_CAP);
+}
+#else
+static inline bool posted_msi_supported(void) { return false; };
+#endif
+
 #else  /* CONFIG_IRQ_REMAP */
 
 static inline bool irq_remapping_cap(enum irq_remap_cap cap) { return 0; }
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 83314b9d8f38..00de6963bb07 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -24,6 +24,23 @@ int no_x2apic_optout;
 
 int disable_irq_post = 0;
 
+#ifdef CONFIG_X86_POSTED_MSI
+
+unsigned int posted_msi_off;
+
+static int __init cmdl_posted_msi_off(char *str)
+{
+	int value = 0;
+
+	get_option(&str, &value);
+	posted_msi_off = value;
+
+	return 1;
+}
+
+__setup("posted_msi_off=", cmdl_posted_msi_off);
+#endif
+
 static int disable_irq_remap;
 static struct irq_remap_ops *remap_ops;
 
-- 
2.25.1


