Return-Path: <kvm+bounces-1305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AFD6D7E64AF
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 08:51:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14B8128160B
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 07:51:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF58610A0A;
	Thu,  9 Nov 2023 07:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jragFRa+"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE6FFC01
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 07:50:24 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3BE2693
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 23:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699516223; x=1731052223;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MbIfcTx5Jpa1uax7o3pELRo6a1v5BYZchyQrtHIxi40=;
  b=jragFRa+Ns1SGMQAVXgG+ebU2PNEqyC7B/o+3cXyIj9TezgXzgMNWUXx
   CV/63V3dlPzGbVxzPlyf5rklCRbwIvS5FyUaaFXTDMshFVYxp0/XytOyD
   056FWeHi44pf8G8+XkcAB2OurMdsjNdqr6T5C/TVIWkWX0C9J8gG2BytN
   krgseFFUR9zR5gFqHMco75k5ZOl73tq/aAZklJGnKYhLQ4301++0XZIb+
   nSasWQS4cHxFEGUPIwx9mNF+C9uVUo8vmdBkE1JvEeMEZFH6sI1jHMiJB
   gzT0RC6YY+h6WyLJ1/KWZuIFurOOXlXzWi3fCct/2YBMi1Ukt2PeRmWwK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="476165161"
X-IronPort-AV: E=Sophos;i="6.03,288,1694761200"; 
   d="scan'208";a="476165161"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 23:50:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="763329289"
X-IronPort-AV: E=Sophos;i="6.03,288,1694761200"; 
   d="scan'208";a="763329289"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga002.jf.intel.com with ESMTP; 08 Nov 2023 23:50:23 -0800
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
Subject: [PATCH v3 5/6] target/i386: enumerate VMX nested-exception support
Date: Wed,  8 Nov 2023 23:20:11 -0800
Message-ID: <20231109072012.8078-6-xin3.li@intel.com>
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

Allow VMX nested-exception support to be exposed in KVM guests, thus
nested KVM guests can enumerate it.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 scripts/kvm/vmxcap | 1 +
 target/i386/cpu.c  | 1 +
 target/i386/cpu.h  | 1 +
 3 files changed, 3 insertions(+)

diff --git a/scripts/kvm/vmxcap b/scripts/kvm/vmxcap
index 44898d73c2..508be19c75 100755
--- a/scripts/kvm/vmxcap
+++ b/scripts/kvm/vmxcap
@@ -117,6 +117,7 @@ controls = [
             54: 'INS/OUTS instruction information',
             55: 'IA32_VMX_TRUE_*_CTLS support',
             56: 'Skip checks on event error code',
+            58: 'VMX nested exception support',
             },
         msr = MSR_IA32_VMX_BASIC,
         ),
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index dcf914a7ec..f7556621a5 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1343,6 +1343,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             [54] = "vmx-ins-outs",
             [55] = "vmx-true-ctls",
             [56] = "vmx-any-errcode",
+            [58] = "vmx-nested-exception",
         },
         .msr = {
             .index = MSR_IA32_VMX_BASIC,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index a4d3702621..cc3b4fefb8 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1054,6 +1054,7 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define MSR_VMX_BASIC_INS_OUTS                       (1ULL << 54)
 #define MSR_VMX_BASIC_TRUE_CTLS                      (1ULL << 55)
 #define MSR_VMX_BASIC_ANY_ERRCODE                    (1ULL << 56)
+#define MSR_VMX_BASIC_NESTED_EXCEPTION               (1ULL << 58)
 
 #define MSR_VMX_MISC_PREEMPTION_TIMER_SHIFT_MASK     0x1Full
 #define MSR_VMX_MISC_STORE_LMA                       (1ULL << 5)
-- 
2.42.0


