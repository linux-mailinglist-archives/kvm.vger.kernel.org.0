Return-Path: <kvm+bounces-6129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA1FB82BB1D
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 07:01:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A64628A91A
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 06:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20C995C908;
	Fri, 12 Jan 2024 06:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HziLMtv3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099F55C8E4
	for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 06:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705039254; x=1736575254;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T7zTI2fBo/8VZG27Zg+D+2Lu+dRzE4jKGwoDwuPXqZs=;
  b=HziLMtv3cvP9DvA0B6pKT/yGwp9mIGp06fAJWZNBaBZV3GREUalBbziB
   nJpIfi0pC+PUkwXGHYxqTuGQ5QhUW2orBQc3jED4xwUtCuQbM1v7H14MM
   s44CTKFHpkiBGq7ZsHsGOPKBYKzqgxj52hVDa4z9AgbfijZIPw7gUQxfw
   14KYWjk6ekMfJ8ZMDT78QF5sH6Rga4q6XJsF6Qksd4ipg40TYstwYJ4Jf
   DOCVP7feXtSwXn+sV05MGfn7V+Lk0bvllZ/A7nWilK65u/Sr6Y4uy2JNf
   O+5iL5FJb2h+eUyYUOUjfQQMWAz6DarTE6mehIbNjgNOVpUyomFMGJaH+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="5815759"
X-IronPort-AV: E=Sophos;i="6.04,188,1695711600"; 
   d="scan'208";a="5815759"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 22:00:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="873274771"
X-IronPort-AV: E=Sophos;i="6.04,188,1695711600"; 
   d="scan'208";a="873274771"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO binbinwu-mobl.sh.intel.com) ([10.238.2.99])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 22:00:50 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	xiaoyao.li@intel.com,
	chao.gao@intel.com,
	robert.hu@linux.intel.com,
	binbin.wu@linux.intel.com
Subject: [PATCH v4 2/2] target/i386: add control bits support for LAM
Date: Fri, 12 Jan 2024 14:00:42 +0800
Message-Id: <20240112060042.19925-3-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240112060042.19925-1-binbin.wu@linux.intel.com>
References: <20240112060042.19925-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

LAM uses CR3[61] and CR3[62] to configure/enable LAM on user pointers.
LAM uses CR4[28] to configure/enable LAM on supervisor pointers.

For CR3 LAM bits, no additional handling needed:
- TCG
  LAM is not supported for TCG of target-i386.  helper_write_crN() and
  helper_vmrun() check max physical address bits before calling
  cpu_x86_update_cr3(), no change needed, i.e. CR3 LAM bits are not allowed
  to be set in TCG.
- gdbstub
  x86_cpu_gdb_write_register() will call cpu_x86_update_cr3() to update cr3.
  Allow gdb to set the LAM bit(s) to CR3, if vcpu doesn't support LAM,
  KVM_SET_SREGS will fail as other reserved bits.

For CR4 LAM bit, its reservation depends on vcpu supporting LAM feature or
not.
- TCG
  LAM is not supported for TCG of target-i386.  helper_write_crN() and
  helper_vmrun() check CR4 reserved bit before calling cpu_x86_update_cr4(),
  i.e. CR4 LAM bit is not allowed to be set in TCG.
- gdbstub
  x86_cpu_gdb_write_register() will call cpu_x86_update_cr4() to update cr4.
  Mask out LAM bit on CR4 if vcpu doesn't support LAM.
- x86_cpu_reset_hold() doesn't need special handling.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 target/i386/cpu.h    | 7 ++++++-
 target/i386/helper.c | 4 ++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 18ea755644..598a3fa140 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -261,6 +261,7 @@ typedef enum X86Seg {
 #define CR4_SMAP_MASK   (1U << 21)
 #define CR4_PKE_MASK   (1U << 22)
 #define CR4_PKS_MASK   (1U << 24)
+#define CR4_LAM_SUP_MASK (1U << 28)
 
 #define CR4_RESERVED_MASK \
 (~(target_ulong)(CR4_VME_MASK | CR4_PVI_MASK | CR4_TSD_MASK \
@@ -269,7 +270,8 @@ typedef enum X86Seg {
                 | CR4_OSFXSR_MASK | CR4_OSXMMEXCPT_MASK | CR4_UMIP_MASK \
                 | CR4_LA57_MASK \
                 | CR4_FSGSBASE_MASK | CR4_PCIDE_MASK | CR4_OSXSAVE_MASK \
-                | CR4_SMEP_MASK | CR4_SMAP_MASK | CR4_PKE_MASK | CR4_PKS_MASK))
+                | CR4_SMEP_MASK | CR4_SMAP_MASK | CR4_PKE_MASK | CR4_PKS_MASK \
+                | CR4_LAM_SUP_MASK))
 
 #define DR6_BD          (1 << 13)
 #define DR6_BS          (1 << 14)
@@ -2522,6 +2524,9 @@ static inline uint64_t cr4_reserved_bits(CPUX86State *env)
     if (!(env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_PKS)) {
         reserved_bits |= CR4_PKS_MASK;
     }
+    if (!(env->features[FEAT_7_1_EAX] & CPUID_7_1_EAX_LAM)) {
+        reserved_bits |= CR4_LAM_SUP_MASK;
+    }
     return reserved_bits;
 }
 
diff --git a/target/i386/helper.c b/target/i386/helper.c
index 2070dd0dda..1da7a7d315 100644
--- a/target/i386/helper.c
+++ b/target/i386/helper.c
@@ -219,6 +219,10 @@ void cpu_x86_update_cr4(CPUX86State *env, uint32_t new_cr4)
         new_cr4 &= ~CR4_PKS_MASK;
     }
 
+    if (!(env->features[FEAT_7_1_EAX] & CPUID_7_1_EAX_LAM)) {
+        new_cr4 &= ~CR4_LAM_SUP_MASK;
+    }
+
     env->cr[4] = new_cr4;
     env->hflags = hflags;
 
-- 
2.25.1


