Return-Path: <kvm+bounces-7247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7823383E70A
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 00:38:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33FFB287CBD
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:38:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E97B5EE60;
	Fri, 26 Jan 2024 23:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R0KGBdX9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2065A7A2;
	Fri, 26 Jan 2024 23:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706312247; cv=none; b=fqhZRQ9rChwt3FzSpnZFchBVZNgrx6O8LrMlnW/L/3PbxqnggyT7RlNgQQARX7k+gIF97q0oUOfTWhLClFmH0EsXvoFM2vHb7aUsz2NdEwruKCDMcvOeybQWSG4plM+3xqZIdoQo9ZHfkxt+/Jjhf3wtReg57i9Cc0cOPfwDvJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706312247; c=relaxed/simple;
	bh=QJV30lNeix5myDOaVVsdK3RMyy1VcDvQ9cOpKGwrPwg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SbNrgXSESzomJSsD+2oeIZzRarAH+od2CCaXEiHhSN3YbtcQkZ3YvC3K5EC9G7mdpMASBaXX2PlBabghAZuhnyrWNMsFAksX9nCWIabEF5/sdcrawHqgPk9nbw3v6SZVzKqFrU8pnOr1PlF2cs7UKhm603z6yC7JZsUfn7nZO8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R0KGBdX9; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706312246; x=1737848246;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QJV30lNeix5myDOaVVsdK3RMyy1VcDvQ9cOpKGwrPwg=;
  b=R0KGBdX9thnwx1KkeuOUNNwybbsWww76snbTLVeujKIj/aVeBIcRF9yz
   YLtLNBvpyhifmvCUnBZhECmsT0jUajSx6CakdR/Yhy9YblOB0E31g96RM
   +/4+ivpABHmFNMfRySda3wFJi+2gCw42xj7baAeOaBRTNGrFfTvEPLXXQ
   dm1UWP2UasNS7HHdBwZsk+c+BBY9yHMKRP6xT1WVZu2WvtRRzfrvsAQzK
   6SLKSDunpCZ1l1msPj7YhtGvJ+XMG3MJAVsqdjJe5C/OELalHTvhRCSKb
   RDp8n5FcH3uSIk19WyQLqdUus0cIU1dPhTE4lvP8VO03WTHZw+niHNIRT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9990682"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="9990682"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 15:37:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="821290725"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="821290725"
Received: from srinivas-otcpl-7600.jf.intel.com (HELO jacob-builder.jf.intel.com) ([10.54.39.116])
  by orsmga001.jf.intel.com with ESMTP; 26 Jan 2024 15:37:21 -0800
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
Subject: [PATCH 05/15] x86/irq: Reserve a per CPU IDT vector for posted MSIs
Date: Fri, 26 Jan 2024 15:42:27 -0800
Message-Id: <20240126234237.547278-6-jacob.jun.pan@linux.intel.com>
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

When posted MSI is enabled, all device MSIs are multiplexed into a single
notification vector. MSI handlers will be de-multiplexed at run-time by
system software without IDT delivery.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/irq_vectors.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 3a19904c2db6..08329bef5b1d 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -99,9 +99,16 @@
 
 #define LOCAL_TIMER_VECTOR		0xec
 
+/*
+ * Posted interrupt notification vector for all device MSIs delivered to
+ * the host kernel.
+ */
+#define POSTED_MSI_NOTIFICATION_VECTOR	0xeb
 #define NR_VECTORS			 256
 
-#ifdef CONFIG_X86_LOCAL_APIC
+#ifdef X86_POSTED_MSI
+#define FIRST_SYSTEM_VECTOR		POSTED_MSI_NOTIFICATION_VECTOR
+#elif defined(CONFIG_X86_LOCAL_APIC)
 #define FIRST_SYSTEM_VECTOR		LOCAL_TIMER_VECTOR
 #else
 #define FIRST_SYSTEM_VECTOR		NR_VECTORS
-- 
2.25.1


