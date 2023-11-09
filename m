Return-Path: <kvm+bounces-1303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3E3C7E64AD
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 08:50:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 761C6B2116E
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 07:50:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8944910949;
	Thu,  9 Nov 2023 07:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OK2pgU+z"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF62CFBF1
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 07:50:23 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2E62D50
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 23:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699516223; x=1731052223;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MRaXk3shPh7gkjPfs7QFU/AG2qwffhxmzb8OZqrofHo=;
  b=OK2pgU+zV0KOQa8MyHhGVA8sGeTrYqpgg6/lhAYmKeg/m48Kn8AIV7an
   GFLf0/E4dFHsEvDDJzwM7i2u9df0lEgXf/1eckRJpFMoOSHiOt4JHs9ql
   lgBBUg18JzRhFsWT/5oGHNTYDggZev8dJEIMhbYxuW0bpEbOkX71ALR6V
   3A9pu+bjOyatZrlSW/+xIyThD7ijpD2XlGX632yty1moOvnSHG4815eta
   9A5xKVTg2js5EOE9b4UfH03OfKUc1u1guWwsgAciFpxfldsbfZ1rawFwC
   xkeBBPTKjGwCM4ge0rBjTCakJ2GADA2aQnQqOibnAT9w7qQqlceUF4dK2
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="476165153"
X-IronPort-AV: E=Sophos;i="6.03,288,1694761200"; 
   d="scan'208";a="476165153"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 23:50:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="763329284"
X-IronPort-AV: E=Sophos;i="6.03,288,1694761200"; 
   d="scan'208";a="763329284"
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
Subject: [PATCH v3 4/6] target/i386: add support for VMX FRED controls
Date: Wed,  8 Nov 2023 23:20:10 -0800
Message-ID: <20231109072012.8078-5-xin3.li@intel.com>
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

Add VMX FRED controls used to enable save/load of FRED MSRs.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 scripts/kvm/vmxcap | 3 +++
 target/i386/cpu.c  | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/scripts/kvm/vmxcap b/scripts/kvm/vmxcap
index 7da1e00ca8..44898d73c2 100755
--- a/scripts/kvm/vmxcap
+++ b/scripts/kvm/vmxcap
@@ -229,6 +229,8 @@ controls = [
     Allowed1Control(
         name = 'secondary VM-Exit controls',
         bits = {
+            0: 'Save IA32 FRED MSRs',
+            1: 'Load IA32 FRED MSRs',
             },
         cap_msr = MSR_IA32_VMX_EXIT_CTLS2,
         ),
@@ -246,6 +248,7 @@ controls = [
             16: 'Load IA32_BNDCFGS',
             17: 'Conceal VM entries from PT',
             18: 'Load IA32_RTIT_CTL',
+            23: 'Load IA32 FRED MSRs',
             },
         cap_msr = MSR_IA32_VMX_ENTRY_CTLS,
         true_cap_msr = MSR_IA32_VMX_TRUE_ENTRY_CTLS,
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 227ee1c759..dcf914a7ec 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1285,7 +1285,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             NULL, "vmx-entry-ia32e-mode", NULL, NULL,
             NULL, "vmx-entry-load-perf-global-ctrl", "vmx-entry-load-pat", "vmx-entry-load-efer",
             "vmx-entry-load-bndcfgs", NULL, "vmx-entry-load-rtit-ctl", NULL,
-            NULL, NULL, "vmx-entry-load-pkrs", NULL,
+            NULL, NULL, "vmx-entry-load-pkrs", "vmx-entry-load-fred",
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
         },
-- 
2.42.0


