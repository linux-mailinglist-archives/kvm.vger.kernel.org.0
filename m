Return-Path: <kvm+bounces-20761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D31AB91D8EA
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 09:29:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC2141C214FD
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 07:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02F077D095;
	Mon,  1 Jul 2024 07:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W30NN9i1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE00E76EEA
	for <kvm@vger.kernel.org>; Mon,  1 Jul 2024 07:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719818937; cv=none; b=knMorreUGhbTPcV3VGjvEbr7YecLMzgRrrvxh2zopo5/BRcZCAyGjj5FSCa+7zJyWmeYas567+roqjDnZlpBZl2k2VGpDWMunFUSFLmPCcF++awu6xPd1801fIPQOpMXCFly3p8WAlRHnaUg6yGyC9LJkiZoCl0hFPNVDJCnrP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719818937; c=relaxed/simple;
	bh=30JVOnpoaKDhlOtl8mzP0pku8g0yJvz3LLkq2KbgoaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoUvx53L+DHw69lxNefzVkMY/yaP9ZzOyM5HE+XQmKfK04iyvd+2Ds0ogbBbl3pJozkCWHp8qoept9xBS55s1OQPK4s8kCA8WdL4uJ6pYsggnmk5xTrViFNojTuBOwN6A7FPTk41P/1RNJK8k39Mn8IqrLO4vZD9qRq27DiGfPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W30NN9i1; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719818936; x=1751354936;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=30JVOnpoaKDhlOtl8mzP0pku8g0yJvz3LLkq2KbgoaE=;
  b=W30NN9i1yyaYHoIOyldICHsIlgl7HJFe2iN4lxSFATC033+XWVE4N4lm
   iRfRtr27htEdtNFkwvzfjjFHfIsVSjOMefZy5+TNw9l0jJNqBM57CPUmP
   pNwWbJSSsJXhJxM4e4xPu37jY8nl3HRatsaXoqcxqVQi87aQfxfewNjxC
   wrdQXFEKPHsmMyLVucBqkfi9DeaaEUNtU+P4R/9LYFnFAP2gSrBaQ1Z1g
   yhs+ccuUQS8CDwfNmez1V/R0vKZiqKtqBMuqVHOFaRKzeqzB+EgJEi4Go
   1NrjgjXlBJrMuAlq6Uc3XUtjOpdZI/JsEgqpPM+qI9MLgNozsyKFJ61ER
   w==;
X-CSE-ConnectionGUID: +SDcg682SnqrFrEX52juHg==
X-CSE-MsgGUID: 7+/kskTQR6yI6iKx5HGbyw==
X-IronPort-AV: E=McAfee;i="6700,10204,11119"; a="34466052"
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="34466052"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 00:28:56 -0700
X-CSE-ConnectionGUID: Bx1pa/dFQOq/tUJ7xsH2tg==
X-CSE-MsgGUID: 5VKhoQzZQr+yaSpsQtnw4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="45520753"
Received: from unknown (HELO litbin-desktop.sh.intel.com) ([10.239.156.93])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 00:28:53 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	chao.gao@intel.com,
	robert.hu@linux.intel.com,
	robert.hoo.linux@gmail.com,
	binbin.wu@linux.intel.com
Subject: [kvm-unit-tests PATCH v7 2/5] x86: Allow setting of CR3 LAM bits if LAM supported
Date: Mon,  1 Jul 2024 15:30:07 +0800
Message-ID: <20240701073010.91417-3-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240701073010.91417-1-binbin.wu@linux.intel.com>
References: <20240701073010.91417-1-binbin.wu@linux.intel.com>
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
index 85a1781b..f7f2df50 100644
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
  * KVM defined leafs
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index ffe7064c..4b161c3c 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7032,7 +7032,11 @@ static void test_host_ctl_regs(void)
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
2.43.2


