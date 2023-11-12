Return-Path: <kvm+bounces-1522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98EE07E8E26
	for <lists+kvm@lfdr.de>; Sun, 12 Nov 2023 05:12:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1EAF280D63
	for <lists+kvm@lfdr.de>; Sun, 12 Nov 2023 04:12:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03211442C;
	Sun, 12 Nov 2023 04:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nvaugRDI"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF0B1C3E
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 04:12:10 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0384130D5;
	Sat, 11 Nov 2023 20:12:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699762329; x=1731298329;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tKxaF+OKLwmoAMwaAxN7sL0lSOz2Mx8YYsRJLKhsXTQ=;
  b=nvaugRDIYksMdxA2eLgYkX2XNCqrWeg5zSV5+wv4fWN1s98wN899mftp
   EQN+Pj3YoLGtvplPY22ZJ4UbnWWdltEXo73tet2FD3qkiyymHj2h2P43O
   Ph1wjf5x8U7vZ+GaG4jTgBUTDN6c7GwKUtpjJAHF1c1CXlfc1OcouxnCu
   y4JQ5OkGQW02+dvMKm/LG0lj7woMQG+YnUk94JcrjC8CZ+fZYc9Oc3xdW
   80ITCXlOTBg3gRR4P1T4aGn05/GnNnea/LJobdXimASuHXY4vL5qZ7aXm
   cCTkSaN1UnyjjvmZLb47mbl9vdMWxOP03PogUCCmmEaVNM2dGGjquj4tm
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10891"; a="476533857"
X-IronPort-AV: E=Sophos;i="6.03,296,1694761200"; 
   d="scan'208";a="476533857"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2023 20:12:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10891"; a="713936740"
X-IronPort-AV: E=Sophos;i="6.03,296,1694761200"; 
   d="scan'208";a="713936740"
Received: from srinivas-otcpl-7600.jf.intel.com (HELO jacob-builder.jf.intel.com) ([10.54.39.116])
  by orsmga003.jf.intel.com with ESMTP; 11 Nov 2023 20:12:07 -0800
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
Subject: [PATCH RFC 02/13] x86: Add a Kconfig option for posted MSI
Date: Sat, 11 Nov 2023 20:16:32 -0800
Message-Id: <20231112041643.2868316-3-jacob.jun.pan@linux.intel.com>
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

This option will be used to support delivering MSIs as posted
interrupts. Interrupt remapping is required.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/Kconfig | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 66bfabae8814..f16882ddb390 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -463,6 +463,16 @@ config X86_X2APIC
 
 	  If you don't know what to do here, say N.
 
+config X86_POSTED_MSI
+	bool "Enable MSI and MSI-x delivery by posted interrupts"
+	depends on X86_X2APIC && X86_64 && IRQ_REMAP
+	help
+	  This enables MSIs that are under IRQ remapping to be delivered as posted
+	  interrupts to the host kernel. IRQ throughput can potentially be improved
+	  by coalescing CPU notifications during high frequency IRQ bursts.
+
+	  If you don't know what to do here, say N.
+
 config X86_MPPARSE
 	bool "Enable MPS table" if ACPI
 	default y
-- 
2.25.1


