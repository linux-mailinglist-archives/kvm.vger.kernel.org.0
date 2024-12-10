Return-Path: <kvm+bounces-33353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3CBF9EA3CA
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 01:49:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74C2A283C33
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 00:49:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E432A19ABCE;
	Tue, 10 Dec 2024 00:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HxT5aiOP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5681632FB;
	Tue, 10 Dec 2024 00:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733791685; cv=none; b=gWXeHOzYyXZH4rYKDJAkBFVSxI/ITnbInMc2zlUiqrtG/a/EkrX0ZWyImJVLxSi9sExHOqTGaVl8F/nyP8NIvg1cwAE7q/SsNbQ/TiDJ0xlVIf//SZNnUcdYjU7vTBZRoxuFWMA+l9nejbpZyMi93Jg20j9P8yOO4oKi1mr7mMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733791685; c=relaxed/simple;
	bh=27fiCt6h2LdRcruWOgtZdm64bm9I78m5Xkchkn9Mrfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkHl6HbTqKYtvHlrNv8DxCFk0IYXX4J5IGlt+crgsZzTLHPBZJk8BNMKd3vkY9XCWPuVJF5obJ3g/8jMIxVGnj5hBwxNvSsKuhiA9zoizjDLefT8/GaEmL8m5fh0bgJ5AnxSC7nkpvTv5pvO4wosRAWxzijTpMXbnAOpnf69p7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HxT5aiOP; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733791683; x=1765327683;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=27fiCt6h2LdRcruWOgtZdm64bm9I78m5Xkchkn9Mrfs=;
  b=HxT5aiOPIf2E0dEankFLE50yXjasP01G0orz9n0NNIt2Vgs8dHeyiiDu
   BI0D7fm+EoUR0QHhqlj4WVKIBSMHPtT4xcoCILPauRwGNjPMrPoyOP/Lu
   6k3I3sYGj6eJCRD8X6nOQ1WM9WJYFZMwP+d9Npw+nAxakTXwtLdQ3C3Pw
   cWZFeZOWYCslzlLdXUyDlwNrSCx/ZxIsA2rrYlNklryEFB8EEnYPAEHbW
   JP/XX6PgSQt+e7D/KVBFmp8oMf6gCNjbHiB12rTB1aYBOUgZoBV7yKnUn
   4jE9nH6CiBk09pihN7eyHcJAYctr3+nl5S2a+vbugyp6t3OiNY6z0m0fy
   Q==;
X-CSE-ConnectionGUID: sBnmWoTxRdahhADLrpGBYA==
X-CSE-MsgGUID: 09idXb/nQ4SMp8Ga4yPnHg==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="44793701"
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="44793701"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:03 -0800
X-CSE-ConnectionGUID: F3peKpcIQp+7gbQdnkxqUQ==
X-CSE-MsgGUID: mGgRAXP9SZOBR59jaeBLIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="96033020"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:47:59 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 04/18] KVM: TDX: Handle TDX PV CPUID hypercall
Date: Tue, 10 Dec 2024 08:49:30 +0800
Message-ID: <20241210004946.3718496-5-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
References: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Handle TDX PV CPUID hypercall for the CPUIDs virtualized by VMM
according to TDX Guest Host Communication Interface (GHCI).

For TDX, most CPUID leaf/sub-leaf combinations are virtualized by
the TDX module while some trigger #VE.  On #VE, TDX guest can issue
TDG.VP.VMCALL<INSTRUCTION.CPUID> (same value as EXIT_REASON_CPUID)
to request VMM to emulate CPUID operation.

Wire up TDX PV CPUID hypercall to the KVM backend function.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[binbin: rewrite changelog]
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" breakout:
- Rewrite changelog.
- Use TDVMCALL_STATUS prefix for TDX call status codes (Binbin)
---
 arch/x86/kvm/vmx/tdx.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 96b05e445837..62dbb47ead21 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1274,6 +1274,26 @@ static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
+{
+	u32 eax, ebx, ecx, edx;
+
+	/* EAX and ECX for cpuid is stored in R12 and R13. */
+	eax = tdvmcall_a0_read(vcpu);
+	ecx = tdvmcall_a1_read(vcpu);
+
+	kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, false);
+
+	tdvmcall_a0_write(vcpu, eax);
+	tdvmcall_a1_write(vcpu, ebx);
+	tdvmcall_a2_write(vcpu, ecx);
+	tdvmcall_a3_write(vcpu, edx);
+
+	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
+
+	return 1;
+}
+
 static int tdx_complete_pio_out(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.pio.count = 0;
@@ -1455,6 +1475,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_map_gpa(vcpu);
 	case TDVMCALL_REPORT_FATAL_ERROR:
 		return tdx_report_fatal_error(vcpu);
+	case EXIT_REASON_CPUID:
+		return tdx_emulate_cpuid(vcpu);
 	case EXIT_REASON_IO_INSTRUCTION:
 		return tdx_emulate_io(vcpu);
 	case EXIT_REASON_EPT_VIOLATION:
-- 
2.46.0


