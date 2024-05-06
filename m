Return-Path: <kvm+bounces-16693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 068BF8BC9AD
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 10:38:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 413741C217FB
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 08:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02A4C142659;
	Mon,  6 May 2024 08:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a2ksKhSH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC109142658
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 08:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714984676; cv=none; b=lIcdHAzBt3v246AOHfOdjlR5jSr/OBgyzOhgDi5lGGzrfqAR9OBqVX3chKtafarvr6cQlwV/qYenwPPlJt7GDPhDEoQntkbrjos1TY3uTLfdTWApDVBE61YW7jZ9QNEw4oF07jMzVIwsPtaNEh/zkz+pkATD21yT8pPWOp58QrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714984676; c=relaxed/simple;
	bh=qijGxXFvV8iZRXcREWHGG85ad89+AhgWWgpYseJlNhg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z7wknNxkplIJts0NbUydBIhw+3cg5IvVB/Y/+eEUGFYXSfb6jfM6PY/207FLSgAkzuf/aOIiE0rlJYIYY3PqmOsrz7dFZsM7znLf0BOy0rhh7dpetqIWXQ8JLdolJFYKtJcrTKZPqtgOGuveTmXuxEuQeX9FSwRgp7ZTuMkwrJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a2ksKhSH; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714984675; x=1746520675;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qijGxXFvV8iZRXcREWHGG85ad89+AhgWWgpYseJlNhg=;
  b=a2ksKhSH3+kj/BCYdXSfUDX4FjHEGLGWM2rHQmUdkAMH0fsJdu0s7TzG
   gglCfcBfxXV7NaJgNRfskRGAV1ome/cF+bBFr5jW4vgcEjTPtCG/EbYac
   2oRqaF9SUP6nHPrfqTDxr/TDgDO/onyoZyB8uVqyjguPAmvNGEGecO23J
   MIekJJlT/yOpRMGi/IKNI7SnKAC0nbyabI0wTjmmcjcKWWngymDG85VKk
   hkcm9H/GWfD1aKc4EWvtAddz3T+FewfXNbCywOPcp+oO4Z1UodiNPLCUv
   Xe45KSktRG/sK8sa7ulaMFqfjmJwRfAmfx2N+ZKXNQolsxqhI7mX1Z3sF
   w==;
X-CSE-ConnectionGUID: RwNL+7fbRQSVWMuKg8A10A==
X-CSE-MsgGUID: qfWQh+YNS8GmuIh2iA5RZg==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="14533341"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="14533341"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 01:37:55 -0700
X-CSE-ConnectionGUID: md3ea1NeT1KDBbZJPmP8vw==
X-CSE-MsgGUID: iR4hwVDPS8aBT7i5tcaJ7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="28186729"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa010.fm.intel.com with ESMTP; 06 May 2024 01:37:51 -0700
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
Subject: [PATCH v2 3/6] target/i386/kvm: Only save/load kvmclock MSRs when kvmclock enabled
Date: Mon,  6 May 2024 16:51:50 +0800
Message-Id: <20240506085153.2834841-4-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240506085153.2834841-1-zhao1.liu@intel.com>
References: <20240506085153.2834841-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MSR_KVM_SYSTEM_TIME and MSR_KVM_WALL_CLOCK are attached with the (old)
kvmclock feature (KVM_FEATURE_CLOCKSOURCE).

So, just save/load them only when kvmclock (KVM_FEATURE_CLOCKSOURCE) is
enabled.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/kvm.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index b2c52ec9561f..75d2091c4f8c 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3372,8 +3372,10 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
      */
     if (level >= KVM_PUT_RESET_STATE) {
         kvm_msr_entry_add(cpu, MSR_IA32_TSC, env->tsc);
-        kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, env->system_time_msr);
-        kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, env->wall_clock_msr);
+        if (env->features[FEAT_KVM] & CPUID_KVM_CLOCK) {
+            kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, env->system_time_msr);
+            kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, env->wall_clock_msr);
+        }
         if (env->features[FEAT_KVM] & CPUID_KVM_ASYNCPF_INT) {
             kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_INT, env->async_pf_int_msr);
         }
@@ -3837,8 +3839,10 @@ static int kvm_get_msrs(X86CPU *cpu)
         kvm_msr_entry_add(cpu, MSR_LSTAR, 0);
     }
 #endif
-    kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, 0);
-    kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, 0);
+    if (env->features[FEAT_KVM] & CPUID_KVM_CLOCK) {
+        kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, 0);
+        kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, 0);
+    }
     if (env->features[FEAT_KVM] & CPUID_KVM_ASYNCPF_INT) {
         kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_INT, 0);
     }
-- 
2.34.1


