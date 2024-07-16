Return-Path: <kvm+bounces-21721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3227932C73
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 17:55:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF495284CBA
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 15:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAEED19F48D;
	Tue, 16 Jul 2024 15:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eX2jVF/a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B47F195B27
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 15:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145314; cv=none; b=IVQU+X5jEBaRkpXY5tnlQNOh+b6QcsPyTuHF2mlsCBTiYqgtctaXXwYyLBUdGu5blnxahGs/M9GZSvuiVfcPq6uNiwyK4b6r8qvK23ZmtiCRsZAslUrpTvRum7Rjc/uX8u0StKEIb8a3UUZbZwdw/Zne0G65ba/Z0G4hx+sKCoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145314; c=relaxed/simple;
	bh=M+INEDceyzqNpPErcKN6L7u48TTH5fEDjgdcYW5fAXE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Fr9bTp6OlXV19Vcc2CER+a9MVy64HfQIxzZjpmZIjJ+jQBa4cWWhPrvO/6luqNNzwYdyg437MOoIfKD+0E9twC9KgGOsKiJZCQa6+y19T21I3haX8I7jqc5Pves1XIA87mdJ6Ty1iHTxmmpp9u1dNxM8ZopooQfCxCy6JPecn6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eX2jVF/a; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721145312; x=1752681312;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M+INEDceyzqNpPErcKN6L7u48TTH5fEDjgdcYW5fAXE=;
  b=eX2jVF/aOfxJJZwZAK3fel6pcCsgvqd17Jk6G0oqVGixJZ+R4g4Tqa+O
   nfyPdzCofd2IEgP0iBuqZaymxWizGN0/TH9z2hRtcoT0Nz4EFRwc+jQ7m
   dzk7PmCIZ009/VzLMSLDtHMtWAa2qChzmFnveJUU5CI5xOJ/JVm0hzaKm
   c7jGaCgf5dxYxpfr3bvm47oUl6bGwZ31TMvMzqS1sJTyZPDpICpkA70Zi
   OHhiq/6ltJRGpKU5aoMO53TYNKyXO3/GFNeqOLtFwfljmS68Piyuy5im7
   HirO81Z77/w6SzmPcmobtJUWfiSNNBH70k8FvoVfLhvMhIRsqoBA1DKUr
   Q==;
X-CSE-ConnectionGUID: +kv9Y80jRaG+Dfmh8xRC6w==
X-CSE-MsgGUID: jnlnQ4h4TXOeo7hRSNm2DA==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18743722"
X-IronPort-AV: E=Sophos;i="6.09,212,1716274800"; 
   d="scan'208";a="18743722"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 08:54:58 -0700
X-CSE-ConnectionGUID: yaG6rVfWQRio/3iUZpNdng==
X-CSE-MsgGUID: NRCi32nqSbSgQyQJ9+MGCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,212,1716274800"; 
   d="scan'208";a="50788325"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 16 Jul 2024 08:54:55 -0700
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
Subject: [PATCH v4 4/9] target/i386/kvm: Save/load MSRs of kvmclock2 (KVM_FEATURE_CLOCKSOURCE2)
Date: Wed, 17 Jul 2024 00:10:10 +0800
Message-Id: <20240716161015.263031-5-zhao1.liu@intel.com>
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


