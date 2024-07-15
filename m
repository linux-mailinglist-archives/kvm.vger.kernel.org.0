Return-Path: <kvm+bounces-21620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FB05930D41
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 06:35:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B4441F211C7
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 04:35:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F1181836E4;
	Mon, 15 Jul 2024 04:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C+Cv0KcA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1B354660
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 04:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721018083; cv=none; b=eZUkR5FP2rvNndKNJodfLF2R6+BBnaPT6lSb3rcTVtQA6mibO0NtYdKb9tQkylVOapt8nYJXRvdDP/ptYUwAvaf+8LDRWoSPkIBDaDYv9JAk5pe1q7bsR4r01pWCWVkgFFZAvqC2Y4dQckn8dHS+P03DUUZj+ouHIkroz81Uv+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721018083; c=relaxed/simple;
	bh=zkaR53NTxYfZ7vr3XibkLp9FDRnY38s2Fxjaq5MK80o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f7WrLkTAcdqp30cHPA2yeqVZfJ0dfB/A4OVqJTBCWKyS4CQTJM5XJdSXdkzUrSiIBSaWeoDtjoCa0O+E1qIYsVncoxSI3dmpSh+653Av4Ex9hgdULBjWyHekgvb8zVQUIyFHfnltKtku3c6BKl8SQLe+/Uw/sn06Aew3oPH1pD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C+Cv0KcA; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721018083; x=1752554083;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zkaR53NTxYfZ7vr3XibkLp9FDRnY38s2Fxjaq5MK80o=;
  b=C+Cv0KcA2ac42iK+5eu/HurcikuPYVpnC24H1uL5E9Bs35tx7Yd55hAD
   Hsn229q6bHl0Jq8c5KBXgXMRCJmsH6ytPT23r8KpRsfhwnwNo5ad7bVfE
   6JfXXUkfm/ntIp81fAMEKSENBmm9TJvMJPedTHS5Me1A/H8S+/IZwlcrW
   pZzwH47yhdJQbgTt50CaccqFn+9+oYZqx6ajwkBdEzVdDz5vNAAmUXZ4Y
   qX7zBiG5h5e2zwWp9xAA1TzamJ3pB7fvxYwthNYG9TBUCNlMKT95wAhey
   SwBGpZeDoGR99yXIDykhzDCWLwYsLK2aoJUPam1zIWz+ePja+QeuFGrET
   w==;
X-CSE-ConnectionGUID: 1YVoi8t8SxSmmbwMc5imZw==
X-CSE-MsgGUID: z7dT8wGGQLyTT2mLdQtMLw==
X-IronPort-AV: E=McAfee;i="6700,10204,11133"; a="35809865"
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="35809865"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2024 21:34:43 -0700
X-CSE-ConnectionGUID: k7iJzDdDTD2Rgyq/0IMfyw==
X-CSE-MsgGUID: 1K2khsfRRb6jkzlWCBsdZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="54043151"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 14 Jul 2024 21:34:39 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v3 8/8] target/i386/kvm: Clean up error handling in kvm_arch_init()
Date: Mon, 15 Jul 2024 12:49:55 +0800
Message-Id: <20240715044955.3954304-9-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240715044955.3954304-1-zhao1.liu@intel.com>
References: <20240715044955.3954304-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, there're following incorrect error handling cases in
kvm_arch_init():
* Missed to handle failure of kvm_get_supported_feature_msrs().
* Missed to return when KVM_CAP_X86_DISABLE_EXITS enabling fails.
* MSR filter related cases called exit() directly instead of returning
  to kvm_init().

Fix the above cases.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/kvm.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 0fd1d099ae4c..246fe12ae411 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2682,7 +2682,10 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         return ret;
     }
 
-    kvm_get_supported_feature_msrs(s);
+    ret = kvm_get_supported_feature_msrs(s);
+    if (ret < 0) {
+        return ret;
+    }
 
     uname(&utsname);
     lm_capable_kernel = strcmp(utsname.machine, "x86_64") == 0;
@@ -2740,6 +2743,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         if (ret < 0) {
             error_report("kvm: guest stopping CPU not supported: %s",
                          strerror(-ret));
+            return ret;
         }
     }
 
@@ -2785,7 +2789,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         if (ret) {
             error_report("Could not enable user space MSRs: %s",
                          strerror(-ret));
-            exit(1);
+            return ret;
         }
 
         ret = kvm_filter_msr(s, MSR_CORE_THREAD_COUNT,
@@ -2793,7 +2797,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         if (ret) {
             error_report("Could not install MSR_CORE_THREAD_COUNT handler: %s",
                          strerror(-ret));
-            exit(1);
+            return ret;
         }
     }
 
-- 
2.34.1


