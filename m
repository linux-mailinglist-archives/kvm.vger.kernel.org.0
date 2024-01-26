Return-Path: <kvm+bounces-7248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EA14683E70B
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 00:38:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1E8F28776B
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:38:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A02F85EE62;
	Fri, 26 Jan 2024 23:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DE9ZUdGM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B95559144;
	Fri, 26 Jan 2024 23:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706312247; cv=none; b=shsk1Fbyk+tY6WCczf2ZEf+6298rSQ2zTLd4gQETGUdjM6N/PZcW8P4FPUB/OFoVEGIOuHZnW+0aTZgl2IC1zKNN/yb6udNJ+1KTLpPVRkiTNsdgy9szjIRHXBcQJk57+Qv0Ir2/CYe24UlYlYfiBF+75MT1x5jya6CNMx38QKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706312247; c=relaxed/simple;
	bh=TiUyHPWp/CruDSgiWpJ9abORXg7ueQkxnjZwsyBxeWU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q1K7qRMmBUcpTcpdYFJ/BO4rRHROcD080leQaPrhGG7aV0HShK8aFlyctAX3b5YdisHNs8lo/v+fya7iDhf8+fkceljbCV/TJxPY+nBcS1S1Tbldyz+Ym4CDdFf6e/ecv6Xc1SZM19Gg3lape9bss1N4E4usmJczvmps8av92E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DE9ZUdGM; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706312245; x=1737848245;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TiUyHPWp/CruDSgiWpJ9abORXg7ueQkxnjZwsyBxeWU=;
  b=DE9ZUdGMQ/IBVIsZi7to9I6IXbOkkwHBIiX5ltT9Pfll+r/wztVO8egh
   1fjb/6+5seJvjReJNoxAzfsqHJIhClGlP5e5NJYIP5N4eqjHokCj/p4YQ
   5zWfTwhmS+7XY8RZLu6CXISZMWr0IZ1DdvFya7oFHXMnreTHD6//Y2dG2
   tyxHMn2tJ8utBGXkCNMsp/SaW55mr/PY0RTWyMP6uNBW5BSt69fKQSsPZ
   67aZUKl0uxxpkXMXk4x40nNbVwoP3CsSGLLoMO3KGabMvto/oSjxKoDbp
   7eAEov6VHWpcxDErkVSI8Q5g9AdcR4II4NLi1AtVHhY5ffa8yj8Ca5GRq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9990661"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="9990661"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 15:37:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="821290722"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="821290722"
Received: from srinivas-otcpl-7600.jf.intel.com (HELO jacob-builder.jf.intel.com) ([10.54.39.116])
  by orsmga001.jf.intel.com with ESMTP; 26 Jan 2024 15:37:20 -0800
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
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 04/15] x86/irq: Add a Kconfig option for posted MSI
Date: Fri, 26 Jan 2024 15:42:26 -0800
Message-Id: <20240126234237.547278-5-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240126234237.547278-1-jacob.jun.pan@linux.intel.com>
References: <20240126234237.547278-1-jacob.jun.pan@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This option will be used to support delivering MSIs as posted
interrupts. Interrupt remapping is required.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/Kconfig | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5edec175b9bf..79f04ee2b91c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -463,6 +463,17 @@ config X86_X2APIC
 
 	  If you don't know what to do here, say N.
 
+config X86_POSTED_MSI
+	bool "Enable MSI and MSI-x delivery by posted interrupts"
+	depends on X86_X2APIC && X86_64 && IRQ_REMAP
+	help
+	  This enables MSIs that are under interrupt remapping to be delivered as
+	  posted interrupts to the host kernel. Interrupt throughput can
+	  potentially be improved by coalescing CPU notifications during high
+	  frequency bursts.
+
+	  If you don't know what to do here, say N.
+
 config X86_MPPARSE
 	bool "Enable MPS table" if ACPI
 	default y
-- 
2.25.1


