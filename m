Return-Path: <kvm+bounces-32319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 67CAE9D53CB
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 21:16:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED0111F2262D
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 20:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2710D1C5799;
	Thu, 21 Nov 2024 20:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K30g/Dsf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B153F1DDC29;
	Thu, 21 Nov 2024 20:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732220133; cv=none; b=bixJOYAUtOq8rJW/S3pgL4Ts9zqHk+D3f+1dy+lHP1BrkL93h2/E5/upUhEW6KSXuWxQdWoz9YKxjDXdVb8xGrj63iVuSdua6SK5R2lQxJo3iRqUOIILuY2+9EboZGnKl8I1ORrc6OIBppPxKt1xH0X9sYrMNv8CJXbnb0biqC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732220133; c=relaxed/simple;
	bh=+lyKQromjlZ1o8mi9dmy7hdTdeQ50uC0f5mCP8Awlyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pck3G6QdAVBPKFt3dB3Az01rZPXMc1WNFbsFLgpi8Cb851EyjR/+7HpKhZgg+BfB8hMOiw71VPOClg4e8O5GE88j/SSnurR3daYYMjKHhC8BMyMjh/h4gZi6eqUWkaUXcOGbZgiFdXoaU9p9oJEF7qT5fxw0oEoqfp4h98xBtb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K30g/Dsf; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732220132; x=1763756132;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+lyKQromjlZ1o8mi9dmy7hdTdeQ50uC0f5mCP8Awlyg=;
  b=K30g/DsfnGMVxPffCyhJRXraz6/he3cKt+HK7w1Z+xrESSMzb5d2vAx7
   QILgvJa/qV26KB8OLiajGFi0tfg5beNFJf6nPhwIO8+tdaKntPMkDJequ
   lFT54h/ty1zVA80aJS2e7osW1BiohQtcCYEtmuw/3DpT/VwWQoFcAP/V9
   5cGvCLWgWXNToRoHS4mybO16XU47Zxykbov0wb1st43KFZhcf0mFTPh2x
   W9bTbYzVEFewrrUyqxspT9L2vO8J4BJ0m3Pc2G5ewW0s+QFa7/tHz0cWU
   X/yW7K339YoPRf8lIRb8b9Ivi3WK0NmFVOmhkVyYOx8XpqIuRqcvJ96XT
   w==;
X-CSE-ConnectionGUID: DfSiJJMQQgWFhQjCqUEDDQ==
X-CSE-MsgGUID: It6uzUE0QTm5MtXSVjNzjQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="31715892"
X-IronPort-AV: E=Sophos;i="6.12,173,1728975600"; 
   d="scan'208";a="31715892"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 12:15:32 -0800
X-CSE-ConnectionGUID: LreYr/DVTqaEMJcxQ97JVg==
X-CSE-MsgGUID: BFuFuoiUR+Gp96mAw8oivQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,173,1728975600"; 
   d="scan'208";a="90161114"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.246.16.81])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 12:15:26 -0800
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
Subject: [PATCH 4/7] KVM: TDX: restore host xsave state when exit from the guest TD
Date: Thu, 21 Nov 2024 22:14:43 +0200
Message-ID: <20241121201448.36170-5-adrian.hunter@intel.com>
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

On exiting from the guest TD, xsave state is clobbered.  Restore xsave
state on TD exit.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
TD vcpu enter/exit v1:
- Remove noinstr on tdx_vcpu_enter_exit() (Sean)
- Switch to kvm_host struct for xcr0 and xss

v19:
- Add EXPORT_SYMBOL_GPL(host_xcr0)

v15 -> v16:
- Added CET flag mask
---
 arch/x86/kvm/vmx/tdx.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 6e4ea2d420bc..00fdd2932205 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2,6 +2,8 @@
 #include <linux/cleanup.h>
 #include <linux/cpu.h>
 #include <linux/mmu_context.h>
+
+#include <asm/fpu/xcr.h>
 #include <asm/tdx.h>
 #include "capabilities.h"
 #include "mmu.h"
@@ -709,6 +711,24 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 }
 
 
+static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+
+	if (static_cpu_has(X86_FEATURE_XSAVE) &&
+	    kvm_host.xcr0 != (kvm_tdx->xfam & kvm_caps.supported_xcr0))
+		xsetbv(XCR_XFEATURE_ENABLED_MASK, kvm_host.xcr0);
+	if (static_cpu_has(X86_FEATURE_XSAVES) &&
+	    /* PT can be exposed to TD guest regardless of KVM's XSS support */
+	    kvm_host.xss != (kvm_tdx->xfam &
+			 (kvm_caps.supported_xss | XFEATURE_MASK_PT |
+			  XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)))
+		wrmsrl(MSR_IA32_XSS, kvm_host.xss);
+	if (static_cpu_has(X86_FEATURE_PKU) &&
+	    (kvm_tdx->xfam & XFEATURE_MASK_PKRU))
+		write_pkru(vcpu->arch.host_pkru);
+}
+
 static void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
@@ -776,6 +796,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 
 	tdx_vcpu_enter_exit(vcpu);
 
+	tdx_restore_host_xsave_state(vcpu);
 	tdx->host_state_need_restore = true;
 
 	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
-- 
2.43.0


