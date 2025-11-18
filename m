Return-Path: <kvm+bounces-63480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 126B5C6721C
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 04:22:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 690EC4EDF68
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:21:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ECF4328B79;
	Tue, 18 Nov 2025 03:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HcuqtfhZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795B5329367
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 03:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763436089; cv=none; b=igFKCZQ78kAIPpS50cR6+w+V4zXBavKtEMTZ/vPAERJV3CHF2VSjgJ8IRiKcz60DG6gbrbpE6K726Z6PU22DrAzX1pYh5K3nIqNUMiLhI/13uQ/u8zgm5jA0ivz2Kl77XRB0pdn0PYrv0CHj7xQIXR4z0F2cVvBktxzt29rvty4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763436089; c=relaxed/simple;
	bh=4vj3rkIIm3fua4GI9Ec2JhmAZvhM0BpAu+/cVsnfP9Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oTryzr43t+W8LXfW99E1m1IQIw43GhITYk+v2ile/jYhS78wio6qbfrG3AC36VV4GHwyUdu1u1JmMrbSMGh3T/0AyzI1gTgb2VWNcJ6p1oEOCzCxy3zb3Rl6576rcG3iR/IEqSiL7n3Kz42lFu45U4pG0zea8G1jg60QrXgZmpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HcuqtfhZ; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763436088; x=1794972088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4vj3rkIIm3fua4GI9Ec2JhmAZvhM0BpAu+/cVsnfP9Q=;
  b=HcuqtfhZ8CfxhFl3b9XWGzaUIwECFc/7LAKzto0rQ9b8mQa8rPFOitME
   /sZxqhcdJyvx2uf7GNlE0ePiPyxHxboTYBepsv+dFO94ZRJ68bv7XyOho
   U+YIG8DfYSqnwKzkbbMxQwCqZNSEQqXLFbYeR8VQgAjhhTkgHkAnDAm5h
   gncmcS3pwhFqi9WbW4IHHiQWiHfTPuT09ceJJdvwPRKtu7gJ/XggID8zr
   ElcYzY1vH4o7qUOBaB0XGf97ypTAl2B0M8a6kGCX+FKi6+rsfc4LDfspc
   HzgICxy7PBCgjBHCSJsQf6YmL410wfTKxBpyRV5tLPRhIaIXkzO0D6Tdr
   g==;
X-CSE-ConnectionGUID: wBOACvx3ShuO2FPVI3/Z1w==
X-CSE-MsgGUID: U6BcBgO1QkyAev81cJOacg==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="68053929"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="68053929"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 19:21:28 -0800
X-CSE-ConnectionGUID: xCTmfrJJTi2+2N0h9sQ0dg==
X-CSE-MsgGUID: 3QO/yUuuQHKPVb9FKysCmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="221537395"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 17 Nov 2025 19:21:23 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>,
	Xin Li <xin@zytor.com>,
	John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v4 20/23] i386/cpu: Advertise CET related flags in feature words
Date: Tue, 18 Nov 2025 11:42:28 +0800
Message-Id: <20251118034231.704240-21-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118034231.704240-1-zhao1.liu@intel.com>
References: <20251118034231.704240-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Add SHSTK and IBT flags in feature words with entry/exit
control flags.

CET SHSTK and IBT feature are enumerated via CPUID(EAX=7,ECX=0)
ECX[bit 7] and EDX[bit 20]. CET states load/restore at vmentry/
vmexit are controlled by VMX_ENTRY_CTLS[bit 20] and VMX_EXIT_CTLS[bit 28].
Enable these flags so that KVM can enumerate the features properly.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v2:
 - Rename "shstk"/"ibt" to "cet-ss"/"cet-ibt" to match feature names
   in SDM & APM.
 - Rename "vmx-exit-save-cet-ctl"/"vmx-entry-load-cet-ctl" to
   "vmx-exit-save-cet"/"vmx-entry-load-cet".
 - Define the feature mask macro for easier double check.
---
 target/i386/cpu.c | 8 ++++----
 target/i386/cpu.h | 2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 848e3ccbb8e3..a65fd4111c31 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1221,7 +1221,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .type = CPUID_FEATURE_WORD,
         .feat_names = {
             NULL, "avx512vbmi", "umip", "pku",
-            NULL /* ospke */, "waitpkg", "avx512vbmi2", NULL,
+            NULL /* ospke */, "waitpkg", "avx512vbmi2", "cet-ss",
             "gfni", "vaes", "vpclmulqdq", "avx512vnni",
             "avx512bitalg", NULL, "avx512-vpopcntdq", NULL,
             "la57", NULL, NULL, NULL,
@@ -1244,7 +1244,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "avx512-vp2intersect", NULL, "md-clear", NULL,
             NULL, NULL, "serialize", NULL,
             "tsx-ldtrk", NULL, NULL /* pconfig */, "arch-lbr",
-            NULL, NULL, "amx-bf16", "avx512-fp16",
+            "cet-ibt", NULL, "amx-bf16", "avx512-fp16",
             "amx-tile", "amx-int8", "spec-ctrl", "stibp",
             "flush-l1d", "arch-capabilities", "core-capability", "ssbd",
         },
@@ -1666,7 +1666,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "vmx-exit-save-efer", "vmx-exit-load-efer",
                 "vmx-exit-save-preemption-timer", "vmx-exit-clear-bndcfgs",
             NULL, "vmx-exit-clear-rtit-ctl", NULL, NULL,
-            NULL, "vmx-exit-load-pkrs", NULL, "vmx-exit-secondary-ctls",
+            "vmx-exit-save-cet", "vmx-exit-load-pkrs", NULL, "vmx-exit-secondary-ctls",
         },
         .msr = {
             .index = MSR_IA32_VMX_TRUE_EXIT_CTLS,
@@ -1681,7 +1681,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             NULL, "vmx-entry-ia32e-mode", NULL, NULL,
             NULL, "vmx-entry-load-perf-global-ctrl", "vmx-entry-load-pat", "vmx-entry-load-efer",
             "vmx-entry-load-bndcfgs", NULL, "vmx-entry-load-rtit-ctl", NULL,
-            NULL, NULL, "vmx-entry-load-pkrs", "vmx-entry-load-fred",
+            "vmx-entry-load-cet", NULL, "vmx-entry-load-pkrs", "vmx-entry-load-fred",
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
         },
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index c4412012c780..d8bdf342f98d 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1373,6 +1373,7 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define VMX_VM_EXIT_CLEAR_BNDCFGS                   0x00800000
 #define VMX_VM_EXIT_PT_CONCEAL_PIP                  0x01000000
 #define VMX_VM_EXIT_CLEAR_IA32_RTIT_CTL             0x02000000
+#define VMX_VM_EXIT_SAVE_CET                        0x10000000
 #define VMX_VM_EXIT_LOAD_IA32_PKRS                  0x20000000
 #define VMX_VM_EXIT_ACTIVATE_SECONDARY_CONTROLS     0x80000000
 
@@ -1386,6 +1387,7 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define VMX_VM_ENTRY_LOAD_BNDCFGS                   0x00010000
 #define VMX_VM_ENTRY_PT_CONCEAL_PIP                 0x00020000
 #define VMX_VM_ENTRY_LOAD_IA32_RTIT_CTL             0x00040000
+#define VMX_VM_ENTRY_LOAD_CET                       0x00100000
 #define VMX_VM_ENTRY_LOAD_IA32_PKRS                 0x00400000
 
 /* Supported Hyper-V Enlightenments */
-- 
2.34.1


