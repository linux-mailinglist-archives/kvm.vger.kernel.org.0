Return-Path: <kvm+bounces-21616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBFD7930D3D
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 06:34:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 47A77B20D5B
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 04:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2082B18309E;
	Mon, 15 Jul 2024 04:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="URoA88wm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C630B183098
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 04:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721018073; cv=none; b=B1KvjEaRffHSrVjr9DAKU2LP4VJmvM5TLLJPOlBSGmWG/M4RctKF4cuugyQexM//ikWU6mmLCks1IXIppcessWwF9XLEjLUTKd/BUi0Lypo/pKxIGzkj6hVnl5PLm0PguptuPS7YzzSWO9QYE5p0RVC7XbmsboU6N4wY0/8oL/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721018073; c=relaxed/simple;
	bh=M+INEDceyzqNpPErcKN6L7u48TTH5fEDjgdcYW5fAXE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JStAzSHdqHde5xNG0BmdOEv/Gp4cbbGyK7GQ1M1EL8DZ3i8IAflwHuoXUizs3jAtynBZ97ZOejEedFGJxaTrzNVpcUlvbt7yHl3//b/SjKR2mnd1wCSvcEg9zGAqDqoZ+9jI8UALBXm1kbed8c8d1EPTAb5vbCKk8Po/MzICI6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=URoA88wm; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721018071; x=1752554071;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M+INEDceyzqNpPErcKN6L7u48TTH5fEDjgdcYW5fAXE=;
  b=URoA88wmcOnPmEiS3vJs/2mG7z1KeXfC2+snKet/I6CvOmJgrZP473j+
   cgmoDZRJ7F7NQrlAlcUCz/ASiR7nOr6Eq4oP8+MePo4kaE9aYC3ZYiwda
   NpTs8iCC9jBoYwAMiyHTiMO59ZJnpn37wdNwGtLcoxs0AaSC+w/1Lb2eQ
   eDpbu3bJiDT8VTkieI3LYdjk8vyBjc1BeCduFvoG8RZadWWZ2+G2gcUE0
   HMlFWdEBHIYGnBvMMdQbm5M27bm6swcIPz9wCTvI/GTrjPgTgjcB+kp0u
   yU/WN59oZptW669eBa9HT3yBD3C9lkSKpDt0Kc6c8dX1Lun/GffJxPBbN
   Q==;
X-CSE-ConnectionGUID: ZC3yFnfhS5WcNEvzHR6bGQ==
X-CSE-MsgGUID: 5U59UDMXTBut2AF3sgZicg==
X-IronPort-AV: E=McAfee;i="6700,10204,11133"; a="35809835"
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="35809835"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2024 21:34:31 -0700
X-CSE-ConnectionGUID: IUZVOMfsSeuOAnE6OaYd3g==
X-CSE-MsgGUID: FrKreY+VTgumQl8oR9BvwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="54043083"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 14 Jul 2024 21:34:28 -0700
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
Subject: [PATCH v3 4/8] target/i386/kvm: Save/load MSRs of kvmclock2 (KVM_FEATURE_CLOCKSOURCE2)
Date: Mon, 15 Jul 2024 12:49:51 +0800
Message-Id: <20240715044955.3954304-5-zhao1.liu@intel.com>
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

MSR_KVM_SYSTEM_TIME_NEW and MSR_KVM_WALL_CLOCK_NEW are bound to
kvmclock2 (KVM_FEATURE_CLOCKSOURCE2).

Add the save/load support for these 2 MSRs just like kvmclock MSRs.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.h     |  2 ++
 target/i386/kvm/kvm.c | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index b59bdc1c9d9d..35dc68631989 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1826,6 +1826,8 @@ typedef struct CPUArchState {
 
     uint64_t system_time_msr;
     uint64_t wall_clock_msr;
+    uint64_t system_time_new_msr;
+    uint64_t wall_clock_new_msr;
     uint64_t steal_time_msr;
     uint64_t async_pf_en_msr;
     uint64_t async_pf_int_msr;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index ac434e83b64c..64e54beac7b3 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3423,6 +3423,12 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
             kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, env->system_time_msr);
             kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, env->wall_clock_msr);
         }
+        if (env->features[FEAT_KVM] & CPUID_KVM_CLOCK2) {
+            kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME_NEW,
+                              env->system_time_new_msr);
+            kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK_NEW,
+                              env->wall_clock_new_msr);
+        }
         if (env->features[FEAT_KVM] & CPUID_KVM_ASYNCPF_INT) {
             kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_INT, env->async_pf_int_msr);
         }
@@ -3901,6 +3907,10 @@ static int kvm_get_msrs(X86CPU *cpu)
         kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, 0);
         kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, 0);
     }
+    if (env->features[FEAT_KVM] & CPUID_KVM_CLOCK2) {
+        kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME_NEW, 0);
+        kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK_NEW, 0);
+    }
     if (env->features[FEAT_KVM] & CPUID_KVM_ASYNCPF_INT) {
         kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_INT, 0);
     }
@@ -4167,6 +4177,12 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_KVM_WALL_CLOCK:
             env->wall_clock_msr = msrs[i].data;
             break;
+        case MSR_KVM_SYSTEM_TIME_NEW:
+            env->system_time_new_msr = msrs[i].data;
+            break;
+        case MSR_KVM_WALL_CLOCK_NEW:
+            env->wall_clock_new_msr = msrs[i].data;
+            break;
         case MSR_MCG_STATUS:
             env->mcg_status = msrs[i].data;
             break;
-- 
2.34.1


