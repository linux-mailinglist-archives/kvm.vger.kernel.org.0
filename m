Return-Path: <kvm+bounces-47549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 46E6CAC204D
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:58:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA3CC1BC1848
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 064C024337C;
	Fri, 23 May 2025 09:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WDWJfPqH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF8C23D2B9;
	Fri, 23 May 2025 09:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747994036; cv=none; b=JM3izUmPFGnQHkLOKX0z9H2pKjA3CYXJZBj921SCiPsjXfOWmDl7KZuZ9DSDcX5ezlY9kCoKNB+tMzuUMT93+zaoBj8mcK29KMr4B503SRBM+87SL0SzZxRQEmaSMoIWwn4ocu43HHuLme7+qkz0UVDhgJPwkMQjcvFr6AKGk+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747994036; c=relaxed/simple;
	bh=nLB//jXSfhIU7YPwnLTRK4m1UCg/JGEcEi2LTwa2dRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqf9RMon8TkLlszF3UbLtCXwP/ZDeXcQCnKjq15E9MuF4PbQlN1kpZiHC5V0qq0TAl8glHsUzKlM+wal73B6+tT27o8sitL62ZtblGIesPgvQw+cJfV4svHCJaKYwzRMyLLX29vbC0Mfgi11hdBhkSIante17DZJA1vO7RDQJQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WDWJfPqH; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747994035; x=1779530035;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nLB//jXSfhIU7YPwnLTRK4m1UCg/JGEcEi2LTwa2dRs=;
  b=WDWJfPqH2L86Jx3k32N95JVf9kA/fyZTg53H96M8K5/tkUJtMlShcyQW
   FMCWJfOR8sdsB1dc0Ln2VHCEdP3SsSEBmOfJhgCwn/n9FsRu90hLoFs7N
   E1YP74bLMs5OZcnvsubsQAbftsWFpDbP+LylhSE89Kk7Z9rpTzgxI1+Qu
   TFBHEpMnQhpZA2NpdTyaX7WmpXYxJAKu0AFyrhMwJIWe9eorzZCBvUpLl
   v87cRqV+eV1zGMpox29MeF5JMcUYkn68CC0+GZkslDlYmFKl2QZV8WuXw
   RjKyCHQN0lk7Mt6RL2phsAscQVAK3alpN/nSivR2NuquzsEb6UdEPVIlX
   Q==;
X-CSE-ConnectionGUID: 2uWP0PGaQo2rk61gD5PClw==
X-CSE-MsgGUID: zwY9c/vJTnapiBp7qmW7bg==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="75444216"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="75444216"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:54 -0700
X-CSE-ConnectionGUID: i77PidjWROaIyAU85Yh0sg==
X-CSE-MsgGUID: dMaWjCigTjOAMpad/vo+XA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="164315081"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:54 -0700
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	x86@kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	eddie.dong@intel.com,
	kirill.shutemov@intel.com,
	dave.hansen@intel.com,
	dan.j.williams@intel.com,
	kai.huang@intel.com,
	isaku.yamahata@intel.com,
	elena.reshetova@intel.com,
	rick.p.edgecombe@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 14/20] x86/virt/seamldr: Install a new TDX module
Date: Fri, 23 May 2025 02:52:37 -0700
Message-ID: <20250523095322.88774-15-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250523095322.88774-1-chao.gao@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Invoke the P_SEAMLDR_INSTALL API serially on all online CPUs to install a
new TDX module. "Serially" is a requirement of P-SEAMLDR and is enforced by
a new spinlock.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
 arch/x86/virt/vmx/tdx/seamldr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index 11c0c5a93c32..1ecb5d3088af 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -23,6 +23,7 @@
 
  /* P-SEAMLDR SEAMCALL leaf function */
 #define P_SEAMLDR_INFO			0x8000000000000000
+#define P_SEAMLDR_INSTALL		0x8000000000000001
 
 struct seamldr_info {
 	u32	version;
@@ -68,6 +69,7 @@ struct seamldr_params {
 struct fw_upload *tdx_fwl;
 static struct tdx_status tdx_status;
 static struct seamldr_info seamldr_info __aligned(256);
+static DEFINE_RAW_SPINLOCK(seamldr_lock);
 
 static inline int seamldr_call(u64 fn, struct tdx_module_args *args)
 {
@@ -242,6 +244,7 @@ static struct seamldr_params *init_seamldr_params(const u8 *data, u32 size)
 enum tdp_state {
 	TDP_START,
 	TDP_SHUTDOWN,
+	TDP_CPU_INSTALL,
 	TDP_DONE,
 };
 
@@ -281,6 +284,7 @@ static void ack_state(void)
  */
 static int do_seamldr_install_module(void *params)
 {
+	struct tdx_module_args args = { .rcx = __pa(params) };
 	enum tdp_state newstate, curstate = TDP_START;
 	int cpu = smp_processor_id();
 	bool primary;
@@ -302,6 +306,10 @@ static int do_seamldr_install_module(void *params)
 
 				ret = tdx_module_shutdown();
 				break;
+			case TDP_CPU_INSTALL:
+				scoped_guard(raw_spinlock, &seamldr_lock)
+					ret = seamldr_call(P_SEAMLDR_INSTALL, &args);
+				break;
 			default:
 				break;
 			}
-- 
2.47.1


