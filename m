Return-Path: <kvm+bounces-1301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C3C27E64AA
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 08:50:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0AEF280E63
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 07:50:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3ED9107A1;
	Thu,  9 Nov 2023 07:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c1Bz19Tf"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5ECFBE7
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 07:50:23 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8CB2D4F
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 23:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699516223; x=1731052223;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OTzIm8gCXp6Ung+Q+TxnUDKEdG2Zy3BQi6wounkD6Es=;
  b=c1Bz19TfDJorjX+uhB0wFrQeVs3AjebuKWtXh4Nc3ETvgBmQbNuyCC/Y
   XNCAth3qa/SNEgDKULxVUS0Ca3kwJZQ3zbRl+U9SggZ+q0Pr3xG7dRLqa
   VLyUGrqJQWdqortKvD7AqFrD0DgfFCIZlnkkqJkqFprCOsShWFETnPilp
   +aRFFtcqP8Ey9ET0L/B7kn5tC/tiB7EUMfr1jR7RokJM/I4GN2KVfVw+X
   MyddIV2qNFsf+G/j/fBdATiOYvYWUGLhd9Q/m6RAt33E0u9fz9arYIPQt
   1XQc/civQT2ZkJybEbJWWqmEgamwU50TQUCvFtCecI8hIIeqoynbHSjNh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="476165144"
X-IronPort-AV: E=Sophos;i="6.03,288,1694761200"; 
   d="scan'208";a="476165144"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 23:50:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="763329279"
X-IronPort-AV: E=Sophos;i="6.03,288,1694761200"; 
   d="scan'208";a="763329279"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga002.jf.intel.com with ESMTP; 08 Nov 2023 23:50:22 -0800
From: Xin Li <xin3.li@intel.com>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	pbonzini@redhat.com,
	eduardo@habkost.net,
	seanjc@google.com,
	chao.gao@intel.com,
	hpa@zytor.com,
	xiaoyao.li@intel.com,
	weijiang.yang@intel.com
Subject: [PATCH v3 3/6] target/i386: add the secondary VM exit controls MSR
Date: Wed,  8 Nov 2023 23:20:09 -0800
Message-ID: <20231109072012.8078-4-xin3.li@intel.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231109072012.8078-1-xin3.li@intel.com>
References: <20231109072012.8078-1-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the secondary VM exit controls MSR to prepare for KVM FRED enabling.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 scripts/kvm/vmxcap | 9 +++++++++
 target/i386/cpu.c  | 2 +-
 target/i386/cpu.h  | 1 +
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/scripts/kvm/vmxcap b/scripts/kvm/vmxcap
index 3fb4d5b342..7da1e00ca8 100755
--- a/scripts/kvm/vmxcap
+++ b/scripts/kvm/vmxcap
@@ -24,6 +24,7 @@ MSR_IA32_VMX_TRUE_EXIT_CTLS = 0x48F
 MSR_IA32_VMX_TRUE_ENTRY_CTLS = 0x490
 MSR_IA32_VMX_VMFUNC = 0x491
 MSR_IA32_VMX_PROCBASED_CTLS3 = 0x492
+MSR_IA32_VMX_EXIT_CTLS2 = 0x493
 
 class msr(object):
     def __init__(self):
@@ -219,11 +220,19 @@ controls = [
             23: 'Clear IA32_BNDCFGS',
             24: 'Conceal VM exits from PT',
             25: 'Clear IA32_RTIT_CTL',
+            31: 'Activate secondary VM-exit controls',
             },
         cap_msr = MSR_IA32_VMX_EXIT_CTLS,
         true_cap_msr = MSR_IA32_VMX_TRUE_EXIT_CTLS,
         ),
 
+    Allowed1Control(
+        name = 'secondary VM-Exit controls',
+        bits = {
+            },
+        cap_msr = MSR_IA32_VMX_EXIT_CTLS2,
+        ),
+
     Control(
         name = 'VM-Entry controls',
         bits = {
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 403c84177a..227ee1c759 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1270,7 +1270,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "vmx-exit-save-efer", "vmx-exit-load-efer",
                 "vmx-exit-save-preemption-timer", "vmx-exit-clear-bndcfgs",
             NULL, "vmx-exit-clear-rtit-ctl", NULL, NULL,
-            NULL, "vmx-exit-load-pkrs", NULL, NULL,
+            NULL, "vmx-exit-load-pkrs", NULL, "vmx-exit-secondary-ctls",
         },
         .msr = {
             .index = MSR_IA32_VMX_TRUE_EXIT_CTLS,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index e210957cba..a4d3702621 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -551,6 +551,7 @@ typedef enum X86Seg {
 #define MSR_IA32_VMX_TRUE_EXIT_CTLS      0x0000048f
 #define MSR_IA32_VMX_TRUE_ENTRY_CTLS     0x00000490
 #define MSR_IA32_VMX_VMFUNC             0x00000491
+#define MSR_IA32_VMX_EXIT_CTLS2         0x00000493
 
 #define XSTATE_FP_BIT                   0
 #define XSTATE_SSE_BIT                  1
-- 
2.42.0


