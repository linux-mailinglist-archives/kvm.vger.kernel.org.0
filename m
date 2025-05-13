Return-Path: <kvm+bounces-46295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DCC6AB4CA0
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 09:23:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7C791B414C3
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 07:23:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3629A1F1538;
	Tue, 13 May 2025 07:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OLObRHyx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25501F09B6
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 07:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747120990; cv=none; b=tFH/J5oRakRRZEMNf6Z+N00QRFeeV9JJPM9M/njfkWg21wRJInY6KbTs56OdKBfjfaFE0czK5R9BFnFHjzeaZGXjs4eaJCAnmIa0dIYLCEPxoCts+L5oB1tc+88ZHk9JyiH5xYaZQ0jBEmaVWP7UKLJ06waX6zqiZMqe8GQMePw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747120990; c=relaxed/simple;
	bh=ElufbUIvktIAaQZeenWiBAaG3rfxmtKgtmJt88z4Ioc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVbPXw61k5S9719pcXJRI7HoTW9c6q20jRMXJbOAQ9vlUERlJmSPLUDpvqZ4z43KBPmXwdZd+xE79VDVMyJt0iysNBpHGe0hiZA/31LC9mKxVvvRGAvLS6JMjJQJGVSGDRyyUc21lOR+4UY8Fek67tbJZl72xRp+AEkYFfLRk7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OLObRHyx; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747120989; x=1778656989;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ElufbUIvktIAaQZeenWiBAaG3rfxmtKgtmJt88z4Ioc=;
  b=OLObRHyxEJIJBD2d8JHgq9BXyttKpZZnmBv0KX9wHcR4Lv+I0CycOzwP
   weyh6CgDZqhRXh2GAIkn1AWyGZrPXps7TsuACkEq1iY/17yvQOOjCXGLm
   52c2IkC/X+Wrfq72XriYE4UhowHkXLA5/TIxvUwJ0yzLYXv0tdtJPuAl+
   pKK4XSdmfBJad4fgwc97NS4q+SxEvtbcWdWgt+XVW3U2B+/1uNK/5qX2J
   BMU9AUWgi/7Z3a3Un5q9YBSX9ZrXUpKfo284rKWH9GUuoOv7FTpfJa1B4
   VcHRXOnaEzZNEE1L2syLLxVj5FndVtxOek648Dd50yS4IiDVUy5ECfS6P
   g==;
X-CSE-ConnectionGUID: pHO61/e2TgeZk5+HUDXgiQ==
X-CSE-MsgGUID: +61o471PRnK3TJkLYSu83Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="48941009"
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="48941009"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 00:23:04 -0700
X-CSE-ConnectionGUID: U/Sp2KurR1GdluLui/pQrw==
X-CSE-MsgGUID: zcpC5pvzS/qQ8X1LShmB5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="142740610"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 00:23:03 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	Chao Gao <chao.gao@intel.com>
Subject: [kvm-unit-tests PATCH v1 4/8] x86: cet: Validate #CP error code
Date: Tue, 13 May 2025 00:22:46 -0700
Message-ID: <20250513072250.568180-5-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250513072250.568180-1-chao.gao@intel.com>
References: <20250513072250.568180-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The #CP exceptions include an error code that provides additional
information about how the exception occurred. Previously, CET tests simply
printed these error codes without validation.

Enhance the CET tests to validate the #CP error code.

This requires the run_in_user() infrastructure to catch the exception
vector, error code, and rflags, similar to what check_exception_table()
does.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 lib/x86/usermode.c | 4 ++++
 x86/cet.c          | 4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
index c3ec0ad7..f896e3bd 100644
--- a/lib/x86/usermode.c
+++ b/lib/x86/usermode.c
@@ -23,6 +23,10 @@ static void restore_exec_to_jmpbuf(void)
 
 static void restore_exec_to_jmpbuf_exception_handler(struct ex_regs *regs)
 {
+	this_cpu_write_exception_vector(regs->vector);
+	this_cpu_write_exception_rflags_rf((regs->rflags >> 16) & 1);
+	this_cpu_write_exception_error_code(regs->error_code);
+
 	/* longjmp must happen after iret, so do not do it now.  */
 	regs->rip = (unsigned long)&restore_exec_to_jmpbuf;
 	regs->cs = KERNEL_CS;
diff --git a/x86/cet.c b/x86/cet.c
index 3e18e3b4..3162b3da 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -92,13 +92,13 @@ int main(int ac, char **av)
 
 	printf("Unit test for CET user mode...\n");
 	run_in_user((usermode_func)cet_shstk_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
-	report(rvc, "Shadow-stack protection test.");
+	report(rvc && exception_error_code() == 1, "Shadow-stack protection test.");
 
 	/* Enable indirect-branch tracking */
 	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
 
 	run_in_user((usermode_func)cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
-	report(rvc, "Indirect-branch tracking test.");
+	report(rvc && exception_error_code() == 3, "Indirect-branch tracking test.");
 
 	write_cr4(read_cr4() & ~X86_CR4_CET);
 	wrmsr(MSR_IA32_U_CET, 0);
-- 
2.47.1


