Return-Path: <kvm+bounces-15699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 16F6A8AF5A3
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 19:38:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 480881C2430B
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 17:37:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D14121422A0;
	Tue, 23 Apr 2024 17:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C6N3vz2E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773151411E0;
	Tue, 23 Apr 2024 17:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713893809; cv=none; b=HsjchFWkW1vkxF0OMojYJsFTro32ilq0lOlPkURyVoBQL1CbTaaFDu7Ej67whDhVWR9HRdBFlXkThqYWcel58kcxkt89iR8ZVEFv/NKV17zRxSWld759vrf44/oENL8XxE65QA9DdrF4oERzsQD1JTw9pZ+UK0beytSCoJ4mv/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713893809; c=relaxed/simple;
	bh=o0Yjsx+6/KD/QeqpB4XlDWg/O40xkF5o3T8IHaOlHg0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FzkLoJUOiVasQkN08vQgpexpTGOmTxX7Oa4FRgvbfxn6KOt79wttZ4rjv+hfz+iahGwm1lJiGs5XD33tXUpdVb5A+APnNbtPlas540fKm7XKugu+DTLCVO10s9DQNW/ByIUcoNJyN45Q5oiHp1W5LmTHF9JW3pQeVtfZA4kHRP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C6N3vz2E; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713893808; x=1745429808;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o0Yjsx+6/KD/QeqpB4XlDWg/O40xkF5o3T8IHaOlHg0=;
  b=C6N3vz2ERIVbHgypwB+h0U64UN/1xOtosxwh4IVixfteeP7GuUcC7WGS
   X5zUwO9sQuXE5YAwihvJ7W60vz323octEG4iEFSXK2IY343g+oVxBQPpG
   q48xhO2/PF7i8zb50UnYUgijuP0n3espNhGQ/J7j8WbmM9PSrwiJjlB1a
   pEQ2Eco/TyNt8v3hTq2ExsmNVxJc/e/3t5svwXqtPVDwoTVmaU6HOuDz5
   +Fg3i1T35ukftqtuNEd2a+Ze9w/OmB1RiOWjJHUEGVwDeQQrj5y9WLcsf
   2c1mTAwctFij3oLlLuxRmkpN/fF0F66f9CVq1qIktCzi0yriuOy2jDYqE
   w==;
X-CSE-ConnectionGUID: DqHu+QLqSPygr3oy0Zjqpw==
X-CSE-MsgGUID: SriR6qjMRhWhIwtDQ2NDsA==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="9712349"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9712349"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 10:36:42 -0700
X-CSE-ConnectionGUID: sIljL0qNQeS8FAL/3+0B1w==
X-CSE-MsgGUID: YA4r9mSPQJqc2Auq4GGciQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="29097402"
Received: from jacob-builder.jf.intel.com ([10.54.39.125])
  by fmviesa004.fm.intel.com with ESMTP; 23 Apr 2024 10:36:41 -0700
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
Subject: [PATCH v3  04/12] x86/irq: Add a Kconfig option for posted MSI
Date: Tue, 23 Apr 2024 10:41:06 -0700
Message-Id: <20240423174114.526704-5-jacob.jun.pan@linux.intel.com>
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

This option will be used to support delivering MSIs as posted
interrupts. Interrupt remapping is required.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

---
v2: Remove x2apic dependency
---
 arch/x86/Kconfig | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4474bf32d0a4..fed22fc66217 100644
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


