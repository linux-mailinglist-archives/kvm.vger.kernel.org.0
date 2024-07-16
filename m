Return-Path: <kvm+bounces-21725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9079B932C78
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 17:56:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31327281208
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 15:56:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCC631A00E6;
	Tue, 16 Jul 2024 15:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hqQTMDnc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7CE19F487
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 15:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145316; cv=none; b=TiOGdoUD+n+CrBO5zyUwyl5L01E4JpD/HsghS0GFCkzfhrjCgPrZ1ghe7FDTJa1NpEe5VFQt/BhNXfrXos4h10OXH2Xec5eqKUkcUpAAN3jD5SlySuQyfxkKc5jvFmvQ+2cf6Cu59zWmcpAk3s+dMGbWRjIj8qxXGPqjr4G5dDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145316; c=relaxed/simple;
	bh=vTmyNpbDyAccpoxjesc1nPYTdmEkK+BCLqrSMM8iBwc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A3JdbykQws9h8iJtfGJ5TW9lN7NOAZgskDmPYLxvHS7EGv/APH1LNnCPjlZthEimP1re18NVxK6FXMn5eDad9I6pjnNMKuAFYorJvKkHU6EaZmn0/oxLPlYb3Hx3zF9hvJf3/ptU7Z3TYnKvOCpjDJYR5I2vhOnEVcMNEyuuL3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hqQTMDnc; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721145315; x=1752681315;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vTmyNpbDyAccpoxjesc1nPYTdmEkK+BCLqrSMM8iBwc=;
  b=hqQTMDncjEMPqcO9clhxQuvkVlckq6bNdnOfdyDwy9oq/lFoacKNGKik
   NrMiGQTPjDc/9cJQxkSTgJ6IFg84GtrAua3cy0MP10JQUKmJe6/ww3kXf
   zVnz/HftAa+SXDt2MZCb0eX0CbaoLMYPWXTgNTlEQB39yGKzjo43hsZRk
   aUc2JRlAVWHTTINyIczAQGn+OgC3ux5/qbc3HBcDUb0MRhHrW7q+QHLWP
   e05Fgyox/7DxGmT7ZgPbSrrJ2JOgE0folQjpJnA30pULOrU/S9N1mVaUt
   u9W9NPNO1BB/3BSx4VtfFxeNmE6lXmW53oulRG9GBQW1qVByBWxpE9T9m
   Q==;
X-CSE-ConnectionGUID: am0eGSYuQUyeGb+rn01NtQ==
X-CSE-MsgGUID: bSXhh4MgRi+cZj7VBZcqeA==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18743788"
X-IronPort-AV: E=Sophos;i="6.09,212,1716274800"; 
   d="scan'208";a="18743788"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 08:55:10 -0700
X-CSE-ConnectionGUID: EyfZj4RlTmiRaGugfiETwg==
X-CSE-MsgGUID: Wo36Cj7EQ5S5E4YUst8iYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,212,1716274800"; 
   d="scan'208";a="50788450"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 16 Jul 2024 08:55:07 -0700
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
Subject: [PATCH v4 8/9] target/i386/kvm: Clean up error handling in kvm_arch_init()
Date: Wed, 17 Jul 2024 00:10:14 +0800
Message-Id: <20240716161015.263031-9-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240716161015.263031-1-zhao1.liu@intel.com>
References: <20240716161015.263031-1-zhao1.liu@intel.com>
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
v3: new commit.
---
 target/i386/kvm/kvm.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index f68be68eb411..d47476e96813 100644
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


