Return-Path: <kvm+bounces-20764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C473291D8ED
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 09:29:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 606BC1F21C40
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 07:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67A9781749;
	Mon,  1 Jul 2024 07:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FolxFVp7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0458376034
	for <kvm@vger.kernel.org>; Mon,  1 Jul 2024 07:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719818945; cv=none; b=B6/XlM9fnikoLWh+JVyNZVsXh+AYXzUHil8FMPkCBmb7ihBQETVPKEVjiRuPW+GOdLd/6OpSuh4NBVBDgtvbC0Y9cfJ6CBosMRcjS+rkrzl0z4teCoNpG6lkynt8aomRdVMIjcwVYX+c2DTEz0qlazBbOlbRuBTir1uZ6xBeH24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719818945; c=relaxed/simple;
	bh=ESTTZBAxhyXhfSLIweAOqULss1TM2TroIHOc7KMqQBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYhLyDaHAXBT1JV6hJZFgXQfGmRj+T0bxZWvRsYp2dVjY+63EuDtKaW3vVH2Jr4kbeTwiDnGCg3EspJRIZSl1fCid/LIz8Z3zZo14OaQAKA2kFNVXFPaTekbdv1BLGWcYgWCs+v46MnQ0cJ6yV93kku70B3c/THSMyrdsdIgbdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FolxFVp7; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719818944; x=1751354944;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ESTTZBAxhyXhfSLIweAOqULss1TM2TroIHOc7KMqQBE=;
  b=FolxFVp7tEVhq30lh5mz3mrzggJ1ryGIb6DfCaASpCWnSgS5nfCAche2
   p2RYsfCYaomDurkMaxXsJA3yjqPj3U0vpRzntRPCSJwXrXXYzAAUfpTid
   5GA5eYhxexlKbSiU67uJZ/hxLha2WdBbVdGQQiwEaMnn9YOrVVUuFJw6+
   pLHViO3OO9i69nXSXlTpwfFy21DirqVzJQmEKmwIFa808wxZUrZq3C4Lb
   c0l3imvIZFriu5YEDwTnrZQIT2wUOSvqUc680zGRQjVDh/DdzWrGIcf0P
   Ea4IZDY2vC4y9MnTNG6FyOXUJYcZdUKvlkwzqLsP7Ld7vlzQskNL/4qfm
   A==;
X-CSE-ConnectionGUID: LttvT3nJQE+eVI1lTC5W2g==
X-CSE-MsgGUID: 0OheEH19R56xcC85IMATSg==
X-IronPort-AV: E=McAfee;i="6700,10204,11119"; a="34466087"
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="34466087"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 00:29:03 -0700
X-CSE-ConnectionGUID: qzOWPE9qQP+7GdVhgj3FSw==
X-CSE-MsgGUID: dqWqJi6DRBGfq9CnGMtz7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="45520785"
Received: from unknown (HELO litbin-desktop.sh.intel.com) ([10.239.156.93])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 00:29:00 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	chao.gao@intel.com,
	robert.hu@linux.intel.com,
	robert.hoo.linux@gmail.com,
	binbin.wu@linux.intel.com
Subject: [kvm-unit-tests PATCH v7 5/5] x86: Add test case for INVVPID with LAM
Date: Mon,  1 Jul 2024 15:30:10 +0800
Message-ID: <20240701073010.91417-6-binbin.wu@linux.intel.com>
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

LAM applies to the linear address of INVVPID operand, however,
it doesn't apply to the linear address in the INVVPID descriptor.

The added cases use tagged operand or tagged target invalidation
address to make sure the behaviors are expected when LAM is on.

Also, INVVPID case using tagged operand can be used as the common
test cases for VMX instruction VMExits.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
v7:
- Drop the check of X86_FEATURE_LA57 when check LA57. (Sean)
---
 x86/vmx_tests.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 4b161c3c..758ab0d3 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -3233,6 +3233,47 @@ static void invvpid_test_not_in_vmx_operation(void)
 	TEST_ASSERT(!vmx_on());
 }
 
+/* LAM doesn't apply to the linear address inside the descriptor of invvpid */
+static void invvpid_test_lam(void)
+{
+	void *vaddr;
+	struct invvpid_operand *operand;
+	u64 lam_mask;
+	bool fault;
+
+	if (!this_cpu_has(X86_FEATURE_LAM)) {
+		report_skip("LAM is not supported, skip INVVPID with LAM");
+		return;
+	}
+
+	write_cr4(read_cr4() | X86_CR4_LAM_SUP);
+	lam_mask = is_la57_enabled() ? LAM57_MASK : LAM48_MASK;
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
+	report(!fault, "Expected INVVPID with tagged operand when LAM is enabled to succeed");
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
@@ -3282,8 +3323,10 @@ static void invvpid_test(void)
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
2.43.2


