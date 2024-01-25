Return-Path: <kvm+bounces-6921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7960F83B7E6
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:30:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C24C1C2241D
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1E2C125DB;
	Thu, 25 Jan 2024 03:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U9ClQqkC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577B5125AC
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153311; cv=none; b=XlumYo9dTc+AdT21n2TYt+QYWfAsWQmsHySQBjUwJypQXteG59MjxqxydQE6SN5zHkfFYpkp7aN3bV2rLRhYC3IGWVaylk05JTObpBx4pXE1lRP51In5PVq+B0aJcsyPrrxyj23GDr/6Jj98oAdSvJwJgZqI/7JYBnn4aLgxV+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153311; c=relaxed/simple;
	bh=aKx76GEDnWqevQGtQVWwRbzYVLv0CmACuepOhLKyRX8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ChqwT1PIr4Xb9UHfK8w4JMP5ktIG/zu1L7u4iPDl9shkHEvgxJJwIeD9uNg+0VYZkiI8hqY03rdasAa5UnueEE3dMEaINFbp/37NN9QM18Ej5YjhRJ8oad0CXM53vhzx2qPDMlKTTBR0s56NaMslLSCYahfFZWkA16218PSkExs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U9ClQqkC; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153309; x=1737689309;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aKx76GEDnWqevQGtQVWwRbzYVLv0CmACuepOhLKyRX8=;
  b=U9ClQqkCb0DButo6+5MiS5l+OJQL2gr0HpHKnC/bQUq2XkGQUbNUObMx
   6C5NzRzAna4ONNufftGaj0gK/LHL2EgFBEoS6AQgSPcM7HPZVCTnfz997
   o5sFlcetffhZOXQ+3Y5JlvmP+R1T7/E425OeKfzt3bcJGI+Hi4HbGBZhS
   WyeNDazL8uwktmAe6WYMEQy2rqBFenI3s+09+DA3W5JT7hHG8lizf5Jmd
   GVdI9pHARyJ3sCNx2J/6NnsGoe4KFBhKVuxEndPj7w7XDRzV/C6+NlldK
   o0tfy0oysCTDRYrJN8jgM5+6U11AaIKNOIvPy/IJ0Cvk+E33W2ZTuIwIP
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9428554"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9428554"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:25:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2085422"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:25:22 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v4 20/66] i386/tdx: Integrate tdx_caps->xfam_fixed0/1 into tdx_cpuid_lookup
Date: Wed, 24 Jan 2024 22:22:42 -0500
Message-Id: <20240125032328.2522472-21-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125032328.2522472-1-xiaoyao.li@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM requires userspace to pass XFAM configuration via CPUID 0xD leaves.

Convert tdx_caps->xfam_fixed0/1 into corresponding
tdx_cpuid_lookup[].tdx_fixed0/1 field of CPUID 0xD leaves. Thus the
requirement can be applied naturally.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c     |  3 ---
 target/i386/cpu.h     |  3 +++
 target/i386/kvm/tdx.c | 24 ++++++++++++++++++++++++
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 03822d9ba8ee..160ba8c940a2 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1575,9 +1575,6 @@ static const X86RegisterInfo32 x86_reg_info_32[CPU_NB_REGS32] = {
 };
 #undef REGISTER
 
-/* CPUID feature bits available in XSS */
-#define CPUID_XSTATE_XSS_MASK    (XSTATE_ARCH_LBR_MASK)
-
 ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
     [XSTATE_FP_BIT] = {
         /* x87 FP state component is always enabled if XSAVE is supported */
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 5b6bcba778ae..23d187d7cc5f 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -588,6 +588,9 @@ typedef enum X86Seg {
                                  XSTATE_Hi16_ZMM_MASK | XSTATE_PKRU_MASK | \
                                  XSTATE_XTILE_CFG_MASK | XSTATE_XTILE_DATA_MASK)
 
+/* CPUID feature bits available in XSS */
+#define CPUID_XSTATE_XSS_MASK    (XSTATE_ARCH_LBR_MASK)
+
 /* CPUID feature words */
 typedef enum FeatureWord {
     FEAT_1_EDX,         /* CPUID[1].EDX */
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 5dfea0378f26..4c8455783e36 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -407,6 +407,30 @@ static void update_tdx_cpuid_lookup_by_tdx_caps(void)
         entry->tdx_fixed0 &= ~config;
         entry->tdx_fixed1 &= ~config;
     }
+
+    /*
+     * Because KVM gets XFAM settings via CPUID leaves 0xD,  map
+     * tdx_caps->xfam_fixed{0, 1} into tdx_cpuid_lookup[].tdx_fixed{0, 1}.
+     *
+     * Then the enforment applies in tdx_get_configurable_cpuid() naturally.
+     */
+    tdx_cpuid_lookup[FEAT_XSAVE_XCR0_LO].tdx_fixed0 =
+            (uint32_t)~tdx_caps->xfam_fixed0 & CPUID_XSTATE_XCR0_MASK;
+    tdx_cpuid_lookup[FEAT_XSAVE_XCR0_LO].tdx_fixed1 =
+            (uint32_t)tdx_caps->xfam_fixed1 & CPUID_XSTATE_XCR0_MASK;
+    tdx_cpuid_lookup[FEAT_XSAVE_XCR0_HI].tdx_fixed0 =
+            (~tdx_caps->xfam_fixed0 & CPUID_XSTATE_XCR0_MASK) >> 32;
+    tdx_cpuid_lookup[FEAT_XSAVE_XCR0_HI].tdx_fixed1 =
+            (tdx_caps->xfam_fixed1 & CPUID_XSTATE_XCR0_MASK) >> 32;
+
+    tdx_cpuid_lookup[FEAT_XSAVE_XSS_LO].tdx_fixed0 =
+            (uint32_t)~tdx_caps->xfam_fixed0 & CPUID_XSTATE_XSS_MASK;
+    tdx_cpuid_lookup[FEAT_XSAVE_XSS_LO].tdx_fixed1 =
+            (uint32_t)tdx_caps->xfam_fixed1 & CPUID_XSTATE_XSS_MASK;
+    tdx_cpuid_lookup[FEAT_XSAVE_XSS_HI].tdx_fixed0 =
+            (~tdx_caps->xfam_fixed0 & CPUID_XSTATE_XSS_MASK) >> 32;
+    tdx_cpuid_lookup[FEAT_XSAVE_XSS_HI].tdx_fixed1 =
+            (tdx_caps->xfam_fixed1 & CPUID_XSTATE_XSS_MASK) >> 32;
 }
 
 int tdx_kvm_init(MachineState *ms, Error **errp)
-- 
2.34.1


