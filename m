Return-Path: <kvm+bounces-32321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAA199D53D0
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 21:17:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 912C12822FB
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 20:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 095821DE3A8;
	Thu, 21 Nov 2024 20:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JJHQ5wiD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6EC1DE2DC;
	Thu, 21 Nov 2024 20:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732220144; cv=none; b=D4TGF4E3ayojfn0zFz/tLxbPhCXHLYUOUcF6/DxXvQL7RthKvXbNg1H8VQBiaEF9VbXZ6uyP0ioJZE++ji9/yxyOiFuP0zY7zLC7Aaua/AK9ZX6T6APzn7LT4Rm1ktRwhdZtUNnuIo+OC2OzyaTAisqlkKXCYmPa74NfuIb8eIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732220144; c=relaxed/simple;
	bh=ipju11d9uomFIv1hzZmYguMlYVvUFAhODJWr4EVRraM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfMQdd7NNkQ6A4vZNXFo8RRjHuDspkusLLmBCiKe/9P39I17SLNJsYCjwfA2Mx4eLTwuQWAIaBuxIZa41+KIE6dpsc6HCma4gIjNr4qIXRkkiW0v/sg5rn0P0DGvjw09oRWVoCj0TRO40jTqX2lgHOgUD/uIsF1js8NL97oouGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JJHQ5wiD; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732220143; x=1763756143;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ipju11d9uomFIv1hzZmYguMlYVvUFAhODJWr4EVRraM=;
  b=JJHQ5wiDL+rz4a2VqaTNRadwuaGY+WdtC1GV/ml+UaI+E7zcOGUFF3wh
   if5TVl4W9uI3cTwu/PMRpTWJpTHvhHxNUMBkiEdCRKd96ehE1GP+PLwaD
   0V09xaTKx6LdeQIFGdR7nUZ1ypwJinXAXDaFHPEAaFAmHRjKf8l/N0ku7
   XfqLwcwLZHptReJR3Ex7K4psQwJQju0o+5XiXvw4NBU/ex3CwjVr43jbx
   x4Mw/w11cAI0/3NezSvP4Vw0i00SFX+RUYdMV65Wq0XbQ9z7YlSGOsJ4l
   jJpZoelzJN0M5hxSFk5XlM1/5Z1w21yaGwlTUtfHUX1teP/sPb7mdnZww
   Q==;
X-CSE-ConnectionGUID: pq5ev+iSRGGr4RL+cZNEeg==
X-CSE-MsgGUID: Fpf6t8/yQseBcI1lsOTRRA==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="31715928"
X-IronPort-AV: E=Sophos;i="6.12,173,1728975600"; 
   d="scan'208";a="31715928"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 12:15:43 -0800
X-CSE-ConnectionGUID: NXOnp3amSWWnuaEgFzKtvw==
X-CSE-MsgGUID: iSnH9ZwsQJ+EoWnhMpKDwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,173,1728975600"; 
   d="scan'208";a="90161121"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.246.16.81])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 12:15:37 -0800
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	weijiang.yang@intel.com
Subject: [PATCH 6/7] KVM: TDX: restore user ret MSRs
Date: Thu, 21 Nov 2024 22:14:45 +0200
Message-ID: <20241121201448.36170-7-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241121201448.36170-1-adrian.hunter@intel.com>
References: <20241121201448.36170-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Several user ret MSRs are clobbered on TD exit.  Restore those values on
TD exit and before returning to ring 3.  Because TSX_CTRL requires special
treatment, this patch doesn't address it.

Co-developed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TD vcpu enter/exit v1:
 - Rename tdx_user_return_update_cache() ->
     tdx_user_return_msr_update_cache() (extrapolated from Binbin)
 - Adjust to rename in previous patches (Binbin)
 - Simplify comment (Tony)
 - Move code change in tdx_hardware_setup() to __tdx_bringup().
---
 arch/x86/kvm/vmx/tdx.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 00fdd2932205..4a33ca54c8ba 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2,7 +2,6 @@
 #include <linux/cleanup.h>
 #include <linux/cpu.h>
 #include <linux/mmu_context.h>
-
 #include <asm/fpu/xcr.h>
 #include <asm/tdx.h>
 #include "capabilities.h"
@@ -711,6 +710,28 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 }
 
 
+struct tdx_uret_msr {
+	u32 msr;
+	unsigned int slot;
+	u64 defval;
+};
+
+static struct tdx_uret_msr tdx_uret_msrs[] = {
+	{.msr = MSR_SYSCALL_MASK, .defval = 0x20200 },
+	{.msr = MSR_STAR,},
+	{.msr = MSR_LSTAR,},
+	{.msr = MSR_TSC_AUX,},
+};
+
+static void tdx_user_return_msr_update_cache(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
+		kvm_user_return_msr_update_cache(tdx_uret_msrs[i].slot,
+						 tdx_uret_msrs[i].defval);
+}
+
 static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
@@ -796,6 +817,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 
 	tdx_vcpu_enter_exit(vcpu);
 
+	tdx_user_return_msr_update_cache();
 	tdx_restore_host_xsave_state(vcpu);
 	tdx->host_state_need_restore = true;
 
@@ -2233,6 +2255,24 @@ static int __init __tdx_bringup(void)
 	for_each_possible_cpu(i)
 		INIT_LIST_HEAD(&per_cpu(associated_tdvcpus, i));
 
+	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++) {
+		/*
+		 * Check if MSRs (tdx_uret_msrs) can be saved/restored
+		 * before returning to user space.
+		 *
+		 * this_cpu_ptr(user_return_msrs)->registered isn't checked
+		 * because the registration is done at vcpu runtime by
+		 * tdx_user_return_msr_update_cache().
+		 */
+		tdx_uret_msrs[i].slot = kvm_find_user_return_msr(tdx_uret_msrs[i].msr);
+		if (tdx_uret_msrs[i].slot == -1) {
+			/* If any MSR isn't supported, it is a KVM bug */
+			pr_err("MSR %x isn't included by kvm_find_user_return_msr\n",
+				tdx_uret_msrs[i].msr);
+			return -EIO;
+		}
+	}
+
 	/*
 	 * Enabling TDX requires enabling hardware virtualization first,
 	 * as making SEAMCALLs requires CPU being in post-VMXON state.
-- 
2.43.0


