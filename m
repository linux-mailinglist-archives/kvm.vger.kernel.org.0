Return-Path: <kvm+bounces-4672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B75EE816710
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:10:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 59D04B218DE
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 07:10:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 391B5E563;
	Mon, 18 Dec 2023 07:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aNHzfiar"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E08DF65
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702883425; x=1734419425;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jsQQFovnOk0Yj1ZCnf654MpiRogEPvzD0bX1cs/ruzk=;
  b=aNHzfiarmAqSFG8Zhmf0WpGPsW/OkypaaVl97cDORBwdzCFk0biLgAMG
   YApYRo/YT15a3pIkKPxUXztZyQ5uoIUxeUFphhUYPSohlYwf+QIK8Hlfn
   kb432cm33QxT+WiJ9S5A41xgyeyZDv5UzjZYx5NCEGzoRlfTvftHz8Tr1
   9STFyztcxFsXN8s+KFoNFgfZvrFZeqyCqqIRBB6PVplnJFAWkEh5ZIp3U
   /w0Z6Mqkd4/YpxFwH80uTmsDlM3OzPPZU2jqenwozuG+44d5+XMPbe3Mb
   2ZaZxtjMjCa0pT4iTO4nQB/D5ZwrJRRhcF0zMSQvg8sMXyy8sYpVs0UWD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2667868"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="2667868"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2023 23:10:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="1106824687"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="1106824687"
Received: from pc.sh.intel.com ([10.238.200.75])
  by fmsmga005.fm.intel.com with ESMTP; 17 Dec 2023 23:10:21 -0800
From: Qian Wen <qian.wen@intel.com>
To: kvm@vger.kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	alexandru.elisei@arm.com,
	yu.c.zhang@intel.com,
	zhenzhong.duan@intel.com,
	isaku.yamahata@intel.com,
	chenyi.qiang@intel.com,
	ricarkol@google.com,
	qian.wen@intel.com
Subject: [kvm-unit-tests RFC v2 06/18] x86 TDX: Bypass wrmsr simulation on some specific MSRs
Date: Mon, 18 Dec 2023 15:22:35 +0800
Message-Id: <20231218072247.2573516-7-qian.wen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231218072247.2573516-1-qian.wen@intel.com>
References: <20231218072247.2573516-1-qian.wen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

In TDX scenario, some MSRs are initialized with expected value and not
expected to be changed in TD-guest.

Writing to MSR_IA32_TSC, MSR_IA32_APICBASE, MSR_EFER in TD-guest
triggers #VE. In #VE handler these MSR accesses are simulated with
tdvmcall. But in current TDX host side implementation, they are bypassed
and return failure.

In order to let test cases touching those MSRs run smoothly, bypass
writing to those MSRs in #VE handler just like writing succeed.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
Link: https://lore.kernel.org/r/20220303071907.650203-6-zhenzhong.duan@intel.com
Signed-off-by: Qian Wen <qian.wen@intel.com>
---
 lib/x86/tdx.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/lib/x86/tdx.c b/lib/x86/tdx.c
index 4f8bbad7..3909e283 100644
--- a/lib/x86/tdx.c
+++ b/lib/x86/tdx.c
@@ -144,8 +144,23 @@ static int read_msr(struct ex_regs *regs, struct ve_info *ve)
 	return ve_instr_len(ve);
 }
 
+static bool tdx_is_bypassed_msr(u32 index)
+{
+	switch (index) {
+	case MSR_IA32_TSC:
+	case MSR_IA32_APICBASE:
+	case MSR_EFER:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int write_msr(struct ex_regs *regs, struct ve_info *ve)
 {
+	if (tdx_is_bypassed_msr(regs->rcx))
+		goto finish_wrmsr;
+
 	struct tdx_module_args args = {
 		.r10 = TDX_HYPERCALL_STANDARD,
 		.r11 = hcall_func(EXIT_REASON_MSR_WRITE),
@@ -161,6 +176,7 @@ static int write_msr(struct ex_regs *regs, struct ve_info *ve)
 	if (__tdx_hypercall(&args))
 		return -EIO;
 
+finish_wrmsr:
 	return ve_instr_len(ve);
 }
 
-- 
2.25.1


