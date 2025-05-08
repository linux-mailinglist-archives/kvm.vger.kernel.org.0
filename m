Return-Path: <kvm+bounces-45953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78CDCAAFEF0
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:19:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F3F7EB42848
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:12:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 922B6288513;
	Thu,  8 May 2025 15:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vdxs106Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2043727CB0D
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716851; cv=none; b=FIt8FKByx0XZJ7SnnJleapCwR1j6QTrYRI23xP2PpwUENbsvHF2tXARlUd34DUqf4Hx4ZoWdpmlYo+8lJAUPHXRFoRIfsVzb5xh7V4PAjcipf7awFnZ3PM+yo7t3ZuA/12GrWGbqpct3Tc8zVWcu9viyu4JjiLuBSDtWvxDQqJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716851; c=relaxed/simple;
	bh=JjSnyfe/tXL5LKPn1Vv9VsX+SGiMSu+B4m1uHEH+er8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCk8t4mNu/TmLaZc6JNtkKONvbv7udsGDT2S2SF1HURNHtC1L6rordoJC8qdQ+VInvlSrd+pJ8i+ptI622qXPZEqqmnSypbfqRAEP9lozZIO8k6fLp86WCvc6i4n3j8eQinG+T7fl3r6e/uHuumlzGPm5lCHO8t/RVKu3Bo98Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vdxs106Z; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716850; x=1778252850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JjSnyfe/tXL5LKPn1Vv9VsX+SGiMSu+B4m1uHEH+er8=;
  b=Vdxs106ZDdVDdi81XRt93SvwRmHjHJy5mzMcJkP8PgtdxI4BkDHPJD4X
   CSdfbe7uQvFIKzhvTb6gelEdwje8V6bF8z8UbppkbFw2zOBQP0fIw/ZPb
   PIDSl0m2JSdUY0JwGDZHY75evQXbDaWO1+thfMLevbPZkr1DIYMOK7c0S
   2P9XETuYEODy8BtYaEkmZxpaw/Pfh+xlFZj7hHFE+XuMQj8hOBi/tAUfj
   7Z3mYAcsoQm+Pm0fGgljjIzWEqGmNf9f72EEzwQeLtDXP+mV7/i2uCcEq
   SHqGL2gS7uLuMCFCchtZ/iP7Hv9Tl2IWiubyzKoZ4c16IzSHnd2FfxVvc
   A==;
X-CSE-ConnectionGUID: F/dE276YTf6DqS6op2kQ9A==
X-CSE-MsgGUID: l4Aptke0QA6/yUVDuMBrvg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="58716534"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="58716534"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:07:30 -0700
X-CSE-ConnectionGUID: A9R3aAj+QvObAsMV4Bs5rA==
X-CSE-MsgGUID: u+Gggfw8RO2WtqhYt4FEGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440540"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:07:26 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 50/55] i386/cgs: Introduce x86_confidential_guest_check_features()
Date: Thu,  8 May 2025 10:59:56 -0400
Message-ID: <20250508150002.689633-51-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To do cgs specific feature checking. Note the feature checking in
x86_cpu_filter_features() is valid for non-cgs VMs. For cgs VMs like
TDX, what features can be supported has more restrictions.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/confidential-guest.h | 13 +++++++++++++
 target/i386/kvm/kvm.c            |  8 ++++++++
 2 files changed, 21 insertions(+)

diff --git a/target/i386/confidential-guest.h b/target/i386/confidential-guest.h
index 777d43cc9688..48b88dbd3130 100644
--- a/target/i386/confidential-guest.h
+++ b/target/i386/confidential-guest.h
@@ -42,6 +42,7 @@ struct X86ConfidentialGuestClass {
     void (*cpu_instance_init)(X86ConfidentialGuest *cg, CPUState *cpu);
     uint32_t (*adjust_cpuid_features)(X86ConfidentialGuest *cg, uint32_t feature,
                                       uint32_t index, int reg, uint32_t value);
+    int (*check_features)(X86ConfidentialGuest *cg, CPUState *cs);
 };
 
 /**
@@ -91,4 +92,16 @@ static inline int x86_confidential_guest_adjust_cpuid_features(X86ConfidentialGu
     }
 }
 
+static inline int x86_confidential_guest_check_features(X86ConfidentialGuest *cg,
+                                                        CPUState *cs)
+{
+    X86ConfidentialGuestClass *klass = X86_CONFIDENTIAL_GUEST_GET_CLASS(cg);
+
+    if (klass->check_features) {
+        return klass->check_features(cg, cs);
+    }
+
+    return 0;
+}
+
 #endif
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 17d7bf6ae9aa..27b4a069d194 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2092,6 +2092,14 @@ int kvm_arch_init_vcpu(CPUState *cs)
     int r;
     Error *local_err = NULL;
 
+    if (current_machine->cgs) {
+        r = x86_confidential_guest_check_features(
+                X86_CONFIDENTIAL_GUEST(current_machine->cgs), cs);
+        if (r < 0) {
+            return r;
+        }
+    }
+
     memset(&cpuid_data, 0, sizeof(cpuid_data));
 
     cpuid_i = 0;
-- 
2.43.0


