Return-Path: <kvm+bounces-13756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 139B889A729
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 00:27:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74592283D2C
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 22:27:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB03F178CCB;
	Fri,  5 Apr 2024 22:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PLtPgPC9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A235175578;
	Fri,  5 Apr 2024 22:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712356010; cv=none; b=D/HSW2cA+l1IzzLOORvSsqLyuf3cONF/rifnm/ufymF2sKkAngVr2tHyWNNsm/BMEyuUGZH+f1txkM7O+7vQ2cwpOa+VIJedfOGb7ZfyNQBq/0ukEXEaRZgY7KuOuzZFIpg3Nz8cxya88gyUAgFB/PaJ7AM3G/32r1h7EGj8vCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712356010; c=relaxed/simple;
	bh=BpLqiaNgpSDbcOwdg5E2m/UG/ZOHZCK4TD1uJoCRw+g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QSIAbDk0yNf/J4qT9eoL6ETFdp9pnLscW34kK/H+TnuILT+D6mTxwZVQkecWGsydauHsDNmBj5PsJQhTU9afBPIVbX7RjLYnSXHUwMON3MvFqlSMK+d9TsM0wY/1gktE5FHEKlmYV+PcXo/VUG5+dPJGrs2QuDjkGJZtE10Z5To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PLtPgPC9; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712356010; x=1743892010;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BpLqiaNgpSDbcOwdg5E2m/UG/ZOHZCK4TD1uJoCRw+g=;
  b=PLtPgPC9xIaiu1DdRgTXdhhZ11NBGsjO79wcZPY64j3DOuCSRUYN/NIT
   8T8xg6B8+Ul4ZZ09g4ud9lsHMui8Dux3ETYo1FK52+z6CxmNoajrmvAa6
   0olbukhECKM++n2pyWztdLRQvL130GxgozQlU3AJnzsjQSo+o0x3pMaeL
   7AAlD+Xlfv1QYoFOCfMy0p9v309Tn/UwdJw/PQzI7CB6JsmaRikUFiYLf
   DV1br842rvviPJkRLJntQz1htRYTnsguPWSyD4qrsiaMjp9OM9Us5kCsB
   uF6rQNeVkso5PtIpnZlYboa+HwpJHotm1i2ZsFyaamisdGujV97NcuNS6
   Q==;
X-CSE-ConnectionGUID: nXNelvspQQKeNW7KQz3CPg==
X-CSE-MsgGUID: PiFS6lxMRqWHzCS1C7FLnw==
X-IronPort-AV: E=McAfee;i="6600,9927,11035"; a="19062717"
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="19062717"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2024 15:26:47 -0700
X-CSE-ConnectionGUID: 13qTgNPtQAOkBjpU3IPkgQ==
X-CSE-MsgGUID: mpnrgrsBTUWcfeColep1OQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="23928317"
Received: from jacob-builder.jf.intel.com ([10.54.39.125])
  by fmviesa004.fm.intel.com with ESMTP; 05 Apr 2024 15:26:46 -0700
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
Subject: [PATCH v2 04/13] x86/irq: Add a Kconfig option for posted MSI
Date: Fri,  5 Apr 2024 15:31:01 -0700
Message-Id: <20240405223110.1609888-5-jacob.jun.pan@linux.intel.com>
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

This option will be used to support delivering MSIs as posted
interrupts. Interrupt remapping is required.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

---
v2: Remove x2apic dependency
---
 arch/x86/Kconfig | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 39886bab943a..f5688f4e299b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -464,6 +464,17 @@ config X86_X2APIC
 
 	  If you don't know what to do here, say N.
 
+config X86_POSTED_MSI
+	bool "Enable MSI and MSI-x delivery by posted interrupts"
+	depends on X86_64 && IRQ_REMAP
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


