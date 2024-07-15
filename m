Return-Path: <kvm+bounces-21615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CBD4930D3C
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 06:34:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E8131C209C7
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 04:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1C36157A42;
	Mon, 15 Jul 2024 04:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dAd3iVlK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDB413AA3E
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 04:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721018069; cv=none; b=eZve9kFsnl/MaVgRiZ4uRnEsgydygKYm3bJGjEI4ZkDUDcOMZJQ3mB0PkSyHhW4TbXFDwy0HYY0jIvPVn31aF49q5+iJ367He+02RgGYPH6zpzC/nfJq2888gxzDcSUrEXqCtmVi2opgDqSGx15X24A9ukg6dyHWxoCzo91yxd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721018069; c=relaxed/simple;
	bh=tKr89zQ0Ud3Nsxehy7urxxT9zgviuntFd5ByL5dN0Dg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Gkh7TLp9u9LIIqJt9bkaJHWtvLoy2FKgucbr2ScyR/FF97vXUbH5cZJtG/e7AMmI0vu+Gc1NVkacSDYfAVlf2R/LcKgx8ul4QECHBI7+9nOcv0laZSEOHvZzZKrLuv73/kyYDP41wvy+6g3WHKsHBk/zmHsagbvu0tbU6l6K+OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dAd3iVlK; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721018069; x=1752554069;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tKr89zQ0Ud3Nsxehy7urxxT9zgviuntFd5ByL5dN0Dg=;
  b=dAd3iVlKiZryJMnGveaR+BnRJeaGS4YtN4FUwNmIHCfShgOlOvhgDKVR
   3mpDQf4Nu34dkjYLna4tdpzYNiVEmJENHfDUESUqMcwvFdL9LYQdisqt2
   166uePvcUoYgiR9MenU6oSjksYdubWuSk0+fQ5unh6SyzWMSkbt36Zq79
   h7EB8N/IRm5YFg7zkkJLKjUmno5FF1QnUWEzmLH15dqd1lMrW5aa67Dun
   0K8niGMTEEcBCPDqLFYGgk92iLewR525u7oORb3NQH4/VeX4Ij3HQHJzB
   tF3eP3sTqZg+VU/FBa1t85BKa7mtm5f8QLrxPJTJRLU1tcu/1hhsGCkTM
   A==;
X-CSE-ConnectionGUID: Zbvug6AKT0iF9V0r8+AZ5g==
X-CSE-MsgGUID: VRwf282YQrm1833CEzxv3Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11133"; a="35809825"
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="35809825"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2024 21:34:28 -0700
X-CSE-ConnectionGUID: d46rdVzSQbq2gUIPsr/NmA==
X-CSE-MsgGUID: Bdj/zOvLSmGvktFde+KVAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="54043070"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 14 Jul 2024 21:34:25 -0700
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
Subject: [PATCH v3 3/8] target/i386/kvm: Only save/load kvmclock MSRs when kvmclock enabled
Date: Mon, 15 Jul 2024 12:49:50 +0800
Message-Id: <20240715044955.3954304-4-zhao1.liu@intel.com>
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


