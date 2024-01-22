Return-Path: <kvm+bounces-6519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D7A22835D6B
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 09:57:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EAB11C22F39
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 08:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C63253A1C7;
	Mon, 22 Jan 2024 08:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LxLNmZ2F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F79B3A1BA
	for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 08:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705913651; cv=none; b=Rr57KZoyFIbaPyez9TCG4UrnFd9jSD00QQV9Mpsf7tLO8VgCZmP3nrk855u7u6xKkqJLDlWBtS6DuN9RfwTc5PSAN3si4rHSHEJsxOvpQSHU9k5IFhO+Udktld6yEyDeqTRVlWpVQXi5f9bSWXHntppPZ0Zx+N4vhaRjcf+qfpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705913651; c=relaxed/simple;
	bh=zcz9i0X15s3PV0duA+ICGHzuXb7jOBap7F3wzrHILgQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G1ZUfkW6itaBbDdpCiaByiO7do3a1HlhMe2N4NFnJfhvVUC7/AxIrul4fNE60yvlQcAetJ9PzMJ9JC1avLk0dkyx9AxKc3oJ3iDihMoBZ4TAwQtcRduki3C3FV2IaJJhKFi5tlhyA++YxVTNOXs8mjof2uupYwQwglcEy86u5eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LxLNmZ2F; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705913650; x=1737449650;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zcz9i0X15s3PV0duA+ICGHzuXb7jOBap7F3wzrHILgQ=;
  b=LxLNmZ2F70SjpnT6eztezmA6vWRmNqDIM6qQIPyhx9zkmC0oR1pxG1+T
   XwqkLHl+xrkzBf9+cQlnqQLETYunAGQx7LTcHORSsjb3bTD6DzxC6qU2Z
   PRMf3Z5rRXm8S7YzcFOhbhTpn4adw5i6lJmHjyIMlRA44dLNlsNqQkyrM
   Srb58UWsAztxEQvf+LDlZ8jQNihjeYPmJre3lROgy3ny8bIbqTik5sf6C
   qE5gjVHzdwlrVRWhPCoHNx9AVJ5wy1ehRnTrkSzyW5bb1/Kvb4WpbQFGZ
   F4OETEe6HBMpA0r/8vs8H9ixEOflb3AVvgFBkbmwDX9V2X3pnsGEV2uZT
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="8536178"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="8536178"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 00:54:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="785611618"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="785611618"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO binbinwu-mobl.sh.intel.com) ([10.238.10.49])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 00:54:06 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	chao.gao@intel.com,
	robert.hu@linux.intel.com,
	binbin.wu@linux.intel.com
Subject: [kvm-unit-tests PATCH v6 4/4] x86: Add test case for INVVPID with LAM
Date: Mon, 22 Jan 2024 16:53:54 +0800
Message-Id: <20240122085354.9510-5-binbin.wu@linux.intel.com>
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

LAM applies to the linear address of INVVPID operand, however,
it doesn't apply to the linear address in the INVVPID descriptor.

The added cases use tagged operand or tagged target invalidation
address to make sure the behaviors are expected when LAM is on.

Also, INVVPID case using tagged operand can be used as the common
test cases for VMX instruction VMExits.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
 x86/vmx_tests.c | 46 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 63080361..a855bdcb 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -3220,6 +3220,48 @@ static void invvpid_test_not_in_vmx_operation(void)
 	TEST_ASSERT(!vmx_on());
 }
 
+/* LAM doesn't apply to the linear address inside the descriptor of invvpid */
+static void invvpid_test_lam(void)
+{
+	void *vaddr;
+	struct invvpid_operand *operand;
+	u64 lam_mask = LAM48_MASK;
+	bool fault;
+
+	if (!this_cpu_has(X86_FEATURE_LAM)) {
+		report_skip("LAM is not supported, skip INVVPID with LAM");
+		return;
+	}
+	write_cr4(read_cr4() | X86_CR4_LAM_SUP);
+
+	if (this_cpu_has(X86_FEATURE_LA57) && read_cr4() & X86_CR4_LA57)
+		lam_mask = LAM57_MASK;
+
+	vaddr = alloc_vpage();
+	install_page(current_page_table(), virt_to_phys(alloc_page()), vaddr);
+	/*
+	 * Since the stack memory address in KUT doesn't follow kernel address
+	 * space partition rule, reuse the memory address for descriptor and
+	 * the target address in the descriptor of invvpid.
+	 */
+	operand = (struct invvpid_operand *)vaddr;
+	operand->vpid = 0xffff;
+	operand->gla = (u64)vaddr;
+	operand = (struct invvpid_operand *)set_la_non_canonical((u64)operand,
+								 lam_mask);
+	fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
+	report(!fault, "INVVPID (LAM on): tagged operand");
+
+	/*
+	 * Verify that LAM doesn't apply to the address inside the descriptor
+	 * even when LAM is enabled. i.e., the address in the descriptor should
+	 * be canonical.
+	 */
+	try_invvpid(INVVPID_ADDR, 0xffff, (u64)operand);
+
+	write_cr4(read_cr4() & ~X86_CR4_LAM_SUP);
+}
+
 /*
  * This does not test real-address mode, virtual-8086 mode, protected mode,
  * or CPL > 0.
@@ -3269,8 +3311,10 @@ static void invvpid_test(void)
 	/*
 	 * The gla operand is only validated for single-address INVVPID.
 	 */
-	if (types & (1u << INVVPID_ADDR))
+	if (types & (1u << INVVPID_ADDR)) {
 		try_invvpid(INVVPID_ADDR, 0xffff, NONCANONICAL);
+		invvpid_test_lam();
+	}
 
 	invvpid_test_gp();
 	invvpid_test_ss();
-- 
2.25.1


