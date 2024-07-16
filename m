Return-Path: <kvm+bounces-21720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9807932C71
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 17:55:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB8A61C219D0
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 15:55:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1E1819EED7;
	Tue, 16 Jul 2024 15:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jYDRIPRG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130FE19E7D3
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 15:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145312; cv=none; b=d0KgucIKzYrcumGFRkov9KkmJy10Y5pQDqvsNZtHy6UaoCM5bWS7B2vdxYsQtY3wiB74nZHfB9DIkcGiG7Yni169w37ei5uU9o9kpX4NQ/1pS82AON/LS3N1vidKXobWXQ4IpXxi05PnDgYlbd0HT+wCgaEaacHk5Pzou3bXhUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145312; c=relaxed/simple;
	bh=tKr89zQ0Ud3Nsxehy7urxxT9zgviuntFd5ByL5dN0Dg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BdJO6cAczYS3jtBPDMf95AbmqURhofJwTDIp5eBrpfJGY8lP+rTsthB+0HcwYJOE+aVMIoII+nQHdlb0wUvZoxJ6+Id8JTmJQKukiy8Uz9SpbITKT1peOjZAUFEZIrfZtOieWNaSdD4s2F+dJxErEg9hy30cnp/GECw5LCAM5KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jYDRIPRG; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721145311; x=1752681311;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tKr89zQ0Ud3Nsxehy7urxxT9zgviuntFd5ByL5dN0Dg=;
  b=jYDRIPRGmutukpZFARK5urAIfPnaCfLzzsfJ9l92d17CwQ4xCHP4AlFl
   4KnZTACD1cePaWZmPR32UXsUL7Q1g2nJAKRaRgO/KBMvLio8KW4/3Z6uG
   gSC5JmY0Emwvg1YymWPVgQOs5FuZiaPAeCAiWc56CT76ZFDi7icgRc4Cl
   N7n980fHFHZQP973pfYDUKKyVyjbjYi0nZ0ibw/XIsEIvlGJdg//tDcIi
   rWS1WkhUA6YWGqEGAw2HOyWT71lqAOgesGRWTIpCdozAt3QG3ES5b5Gnw
   qlDQot53+Zsl7f1tSz3OIBmg3uZklDm2FZTBRfXfHKz+uPbEB2iHDVCq5
   A==;
X-CSE-ConnectionGUID: YQmKdp15SMuldVD9/c2hVw==
X-CSE-MsgGUID: GkG5W2ZGS9uwZt258m79kg==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18743711"
X-IronPort-AV: E=Sophos;i="6.09,212,1716274800"; 
   d="scan'208";a="18743711"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 08:54:55 -0700
X-CSE-ConnectionGUID: j3gcA0gTTA2+0HOhBi+S3A==
X-CSE-MsgGUID: YP2sYcn8QyKJ8X4hGTs2/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,212,1716274800"; 
   d="scan'208";a="50788304"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 16 Jul 2024 08:54:52 -0700
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
Subject: [PATCH v4 3/9] target/i386/kvm: Only save/load kvmclock MSRs when kvmclock enabled
Date: Wed, 17 Jul 2024 00:10:09 +0800
Message-Id: <20240716161015.263031-4-zhao1.liu@intel.com>
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

MSR_KVM_SYSTEM_TIME and MSR_KVM_WALL_CLOCK are attached with the (old)
kvmclock feature (KVM_FEATURE_CLOCKSOURCE).

So, just save/load them only when kvmclock (KVM_FEATURE_CLOCKSOURCE) is
enabled.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/kvm.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 6ad5a7dbf1fd..ac434e83b64c 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3419,8 +3419,10 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
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
@@ -3895,8 +3897,10 @@ static int kvm_get_msrs(X86CPU *cpu)
         }
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


