Return-Path: <kvm+bounces-55292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB8E1B2FAD8
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 15:44:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BF7C68785E
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3EE83570C5;
	Thu, 21 Aug 2025 13:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ughwzyfo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2491834F47F;
	Thu, 21 Aug 2025 13:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755783131; cv=none; b=N2BgxfT4xXVkkelIiK8fSv7cLt2OISX074FrCxLPeYFAF9GQ5/xHr8oqLgJNCofHyDlmNh4lIMcf6yn8tRLSVhxNbA9OyqQ1/KtzIz/rHDUqLshhiKtWgdDXaTHQaGrQ9eeU8yek/m/kCtF8paPgaM4OO7t1x1U4ITM0jAshBoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755783131; c=relaxed/simple;
	bh=y0LbNWA7vNu/GD5aAdpQCpx0Gf1hbl1BLmt0kGX0VmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJTFmipBflvnwDs5XuhGOZYcST464i7QgiO25SNxjLAJiVambpLhUVmQ4AkFqFqpEkZEO0V1eNQ96yKo0YUq/fVv8GXK8NfeVcgztS/P142aAKkXFn4GgZiIEcI3HT0YjzOLFvbmVZjig6F6TxQmVK3SxntUiE0uooQDocKzqUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ughwzyfo; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755783130; x=1787319130;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y0LbNWA7vNu/GD5aAdpQCpx0Gf1hbl1BLmt0kGX0VmM=;
  b=UghwzyfoFPa9oLfAj+b0lynSuJ8OvrzAU8oCp3CsyAMfzb3N/1qZ70hF
   v0RMPqCn7IaN7ozuIGLvQ8WjfP3ycesC38pcoIA2snpd3sJcGlGQJaW0R
   3r5hfRdhIk7T4rQwuAcnW5uBecNT9P6a7uMJBT4vcT9VQsTG3xjctPQlW
   Zubfa4fdeg8Ze846xhEZWCREx2/vrElRgSRpeIfJR8MUWR5eZUhFBdhC3
   RUIZU1n5ekpN5bKE8IbjE+CCei29/u6jokH77FmH+NeSk+mqMxdVBBW71
   yByH38Ams5swIkh13wzXRX9cPx3Qm7iCXfLu/ShC9XYg61o74fIdleuaT
   A==;
X-CSE-ConnectionGUID: AQ9ga/5cSQmRKq14C4f80g==
X-CSE-MsgGUID: 2emrtr23RbWgANora5Nskw==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="69446197"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="69446197"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:32:01 -0700
X-CSE-ConnectionGUID: O50a3DldQWysSeVoBldN5g==
X-CSE-MsgGUID: BIplhykpQeq1v9n+8YQe/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="199285408"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:31:46 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: chao.gao@intel.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	pbonzini@redhat.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com
Subject: [PATCH v13 09/21] KVM: x86: Enable guest SSP read/write interface with new uAPIs
Date: Thu, 21 Aug 2025 06:30:43 -0700
Message-ID: <20250821133132.72322-10-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250821133132.72322-1-chao.gao@intel.com>
References: <20250821133132.72322-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Enable guest shadow stack pointer(SSP) access interface with new uAPIs.
CET guest SSP is HW register which has corresponding VMCS field to save
/restore guest values when VM-{Exit,Entry} happens. KVM handles SSP as
a synthetic MSR for userspace access.

Use a translation helper to set up mapping for SSP synthetic index and
KVM-internal MSR index so that userspace doesn't need to take care of
KVM's management for synthetic MSRs and avoid conflicts.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/include/uapi/asm/kvm.h |  3 +++
 arch/x86/kvm/x86.c              | 10 +++++++++-
 arch/x86/kvm/x86.h              | 10 ++++++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 969a63e73190..478d9b63a9db 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -432,6 +432,9 @@ struct kvm_xcrs {
 #define KVM_X86_REG_SYNTHETIC_MSR(index)			\
 	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_SYNTHETIC_MSR, index)
 
+/* KVM synthetic MSR index staring from 0 */
+#define KVM_SYNTHETIC_GUEST_SSP 0
+
 #define KVM_SYNC_X86_REGS      (1UL << 0)
 #define KVM_SYNC_X86_SREGS     (1UL << 1)
 #define KVM_SYNC_X86_EVENTS    (1UL << 2)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 61e008be172d..a48e53b98c95 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5998,7 +5998,15 @@ struct kvm_x86_reg_id {
 
 static int kvm_translate_synthetic_msr(struct kvm_x86_reg_id *reg)
 {
-	return -EINVAL;
+	switch (reg->index) {
+	case KVM_SYNTHETIC_GUEST_SSP:
+		reg->type = KVM_X86_REG_TYPE_MSR;
+		reg->index = MSR_KVM_INTERNAL_GUEST_SSP;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
 }
 
 long kvm_arch_vcpu_ioctl(struct file *filp,
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index d90f1009ac10..0d11115dcd2a 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -101,6 +101,16 @@ do {											\
 #define KVM_SVM_DEFAULT_PLE_WINDOW_MAX	USHRT_MAX
 #define KVM_SVM_DEFAULT_PLE_WINDOW	3000
 
+/*
+ * KVM's internal, non-ABI indices for synthetic MSRs. The values themselves
+ * are arbitrary and have no meaning, the only requirement is that they don't
+ * conflict with "real" MSRs that KVM supports. Use values at the upper end
+ * of KVM's reserved paravirtual MSR range to minimize churn, i.e. these values
+ * will be usable until KVM exhausts its supply of paravirtual MSR indices.
+ */
+
+#define MSR_KVM_INTERNAL_GUEST_SSP	0x4b564dff
+
 static inline unsigned int __grow_ple_window(unsigned int val,
 		unsigned int base, unsigned int modifier, unsigned int max)
 {
-- 
2.47.3


