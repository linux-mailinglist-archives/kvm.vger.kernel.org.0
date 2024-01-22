Return-Path: <kvm+bounces-6516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 30597835D68
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 09:56:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB32B1F210D6
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 08:56:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 751BC39FF0;
	Mon, 22 Jan 2024 08:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SfTQsCB4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E8239FDB
	for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 08:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705913644; cv=none; b=CB6LaH5DPANqXCGrazKAUkedKvNPGdD7yiPiQ3pEKNjJ1mfPSGxOPSargbx5FH1hzhBRnOCp/ETrMqfZWt7EOhHhClXGWVXoJQCJb2UkCFWH1hVQrxtcPc/KOwR4v8X2vPSTQ03I1bJY1ovuOuwnXj0HOj0Nqi3IUS3r1ebyFCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705913644; c=relaxed/simple;
	bh=frwpTGgMSezeZ0vMWcnbys3sHXx7SiQwveJFiwqz2rY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l0PSZhz/lN/2/un0du5NvQqQDVBJ8+eHyHp6df9vMkiVKzLQr4uQ85L9rOab6/NVI901p4ZergngHbWeH2sQEQ7CNi0VJTs2N8VXPhj/uVlzJ/S5DFoPmf8RfVKLJxyZn/vubzHrIulBphxKeRJqRH3GaHTr+eXcSB2N8e5Go5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SfTQsCB4; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705913643; x=1737449643;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=frwpTGgMSezeZ0vMWcnbys3sHXx7SiQwveJFiwqz2rY=;
  b=SfTQsCB4C0HH8g0IWRu56cikBD2vBUehjcfoqipEuxc7KUX3VIF6W62r
   YsUHBtnPd6TYRpbtiiQx0du8DprVDmBn+ebZnTwo3cZU+bDehU2py05pR
   rvFm0NQEB5Jz2NGB2ALbJfqqS3twvTbjgeyE+ovYUmmZyu2Q58ZqSrYE0
   sNa6DloD6zT8KS2ekriL03il4uJkr0FjEIid6c1yytb038tjMZAynn9Hu
   Wpi9sgoTZ06VFmXnz501DbtNMdxBcV20RJb0LEGfbnpR+x4Q/ebpW51PC
   Fil3SjbO91mSRSgFtifthFk/HORqhKqFb6pi6s5edueea6f0wC6ZQpS8d
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="8536149"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="8536149"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 00:54:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="785611595"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="785611595"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO binbinwu-mobl.sh.intel.com) ([10.238.10.49])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 00:54:00 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	chao.gao@intel.com,
	robert.hu@linux.intel.com,
	binbin.wu@linux.intel.com
Subject: [kvm-unit-tests PATCH v6 1/4] x86: Allow setting of CR3 LAM bits if LAM supported
Date: Mon, 22 Jan 2024 16:53:51 +0800
Message-Id: <20240122085354.9510-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240122085354.9510-1-binbin.wu@linux.intel.com>
References: <20240122085354.9510-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If LINEAR ADDRESS MASKING (LAM) is supported, VM entry allows CR3.LAM_U48
(bit 62) and CR3.LAM_U57 (bit 61) to be set in CR3 field.

Change the test result expectations when setting CR3.LAM_U48 or CR3.LAM_U57
on vmlaunch tests when LAM is supported.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
 lib/x86/processor.h | 3 +++
 x86/vmx_tests.c     | 6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 44f4fd1e..ca8665b3 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -68,6 +68,8 @@
 #define X86_CR0_PG		BIT(X86_CR0_PG_BIT)
 
 #define X86_CR3_PCID_MASK	GENMASK(11, 0)
+#define X86_CR3_LAM_U57_BIT	(61)
+#define X86_CR3_LAM_U48_BIT	(62)
 
 #define X86_CR4_VME_BIT		(0)
 #define X86_CR4_VME		BIT(X86_CR4_VME_BIT)
@@ -262,6 +264,7 @@ static inline bool is_intel(void)
 #define	X86_FEATURE_FLUSH_L1D		(CPUID(0x7, 0, EDX, 28))
 #define	X86_FEATURE_ARCH_CAPABILITIES	(CPUID(0x7, 0, EDX, 29))
 #define	X86_FEATURE_PKS			(CPUID(0x7, 0, ECX, 31))
+#define	X86_FEATURE_LAM			(CPUID(0x7, 1, EAX, 26))
 
 /*
  * Extended Leafs, a.k.a. AMD defined
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index c1540d39..63080361 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7012,7 +7012,11 @@ static void test_host_ctl_regs(void)
 		cr3 = cr3_saved | (1ul << i);
 		vmcs_write(HOST_CR3, cr3);
 		report_prefix_pushf("HOST_CR3 %lx", cr3);
-		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+		if (this_cpu_has(X86_FEATURE_LAM) &&
+		    ((i == X86_CR3_LAM_U57_BIT) || (i == X86_CR3_LAM_U48_BIT)))
+			test_vmx_vmlaunch(0);
+		else
+			test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 		report_prefix_pop();
 	}
 
-- 
2.25.1


