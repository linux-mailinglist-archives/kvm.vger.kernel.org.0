Return-Path: <kvm+bounces-57074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 83B26B4A884
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:45:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2899C188C4B0
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:43:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 490E8308F34;
	Tue,  9 Sep 2025 09:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D1sq38OM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3402D661E;
	Tue,  9 Sep 2025 09:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757410804; cv=none; b=m2AWlJx7ITvxnWRWHuqztQxKIKjIMTGREd4l4vTGlCiAQBja0hs+OmKeWOUGKDJKwkvGOsm3lTUaTBfPfzrfaP8OcDUncCVuRIqLXekb3kinTr0fWVdLLH/h9CDr7gM7k9gRJ6bZiw762AVm54YTwZEhOjgXrLgX/M8rkV/gag4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757410804; c=relaxed/simple;
	bh=x3kJ51xSGR3x7Pxoo3adXv1ezy89yCQncm+vlqiyvpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxU585kOLl1+J/G/E4UmDJL1iL7DT2eHPqjYvoEdObODlqhgHHQ/Q5Ow1LNWcyfEuDAy0tVOIEuUkhWjftDFv1kgtkAqNe1HKUMOAVPgXwGDC5+ttomFpyVys3pZUWGzcy3x8Gr9j6rW2I0jsfELUcvhD35/3GNNADbY8XEVGKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D1sq38OM; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757410802; x=1788946802;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x3kJ51xSGR3x7Pxoo3adXv1ezy89yCQncm+vlqiyvpQ=;
  b=D1sq38OMKAlux3RAgLYmFma2QdJr3a81C2zkJSNJHvX58C7gP4Ll18zp
   pelXmPHpS0inWOFE6DHn08+XtPoM/3nAJtHrCyQBnS9ZWMlAl7RfOaI81
   wzod9iE1tvgEIQLnMHQjjRTftVNpmwxmaB8XAECfNDXnzyaJANq0ydGrV
   dkHYIJggaTPuWjWk67VTu4ixc3bVtk7cQittVrQMABh3vgoXdvWgA9wL6
   ieycwFdDJZIUHzHsfWRooQhPffUhuqJ2FlE85AFk8mDyrIzuxwvJAWb0A
   sLB+Y9pex7gF9vblAPw74Ka7XvMFtzGmmfwUvmKtbh9ODxmGkkskSL+qy
   Q==;
X-CSE-ConnectionGUID: iz4pNDxST3esEdbgAqkLdA==
X-CSE-MsgGUID: Ft9PMBvRRtOT65zxCZ+j6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="70307259"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="70307259"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:56 -0700
X-CSE-ConnectionGUID: AXOyJOM7SDqf5idMif3tkg==
X-CSE-MsgGUID: UgAfiDESSEGmV8Z953Zl5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="172207415"
Received: from unknown (HELO CannotLeaveINTEL.jf.intel.com) ([10.165.54.94])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:56 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: acme@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@kernel.org,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	namhyung@kernel.org,
	pbonzini@redhat.com,
	prsampat@amd.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	shuah@kernel.org,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com,
	xiaoyao.li@intel.com
Subject: [PATCH v14 10/22] KVM: x86: Enable guest SSP read/write interface with new uAPIs
Date: Tue,  9 Sep 2025 02:39:41 -0700
Message-ID: <20250909093953.202028-11-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250909093953.202028-1-chao.gao@intel.com>
References: <20250909093953.202028-1-chao.gao@intel.com>
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
 Documentation/virt/kvm/api.rst  |  7 +++++++
 arch/x86/include/uapi/asm/kvm.h |  3 +++
 arch/x86/kvm/x86.c              | 10 +++++++++-
 arch/x86/kvm/x86.h              | 10 ++++++++++
 4 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 28fc12b46eeb..2b999408a768 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2911,6 +2911,13 @@ such as set vcpu counter or reset vcpu, and they have the following id bit patte
 x86 MSR registers have the following id bit patterns::
   0x2030 0002 <msr number:32>
 
+Following are the KVM-defined registers for x86:
+======================= ========= =============================================
+    Encoding            Register  Description
+======================= ========= =============================================
+  0x2030 0003 0000 0000 SSP       Shadow Stack Pointer
+======================= ========= =============================================
+
 4.69 KVM_GET_ONE_REG
 --------------------
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 508b713ca52e..8cc79eca34b2 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -437,6 +437,9 @@ struct kvm_xcrs {
 #define KVM_X86_REG_KVM(index)					\
 	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_KVM, index)
 
+/* KVM-defined registers starting from 0 */
+#define KVM_REG_GUEST_SSP	0
+
 #define KVM_SYNC_X86_REGS      (1UL << 0)
 #define KVM_SYNC_X86_SREGS     (1UL << 1)
 #define KVM_SYNC_X86_EVENTS    (1UL << 2)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 691f8e68046f..a6036eab3852 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5999,7 +5999,15 @@ struct kvm_x86_reg_id {
 
 static int kvm_translate_kvm_reg(struct kvm_x86_reg_id *reg)
 {
-	return -EINVAL;
+	switch (reg->index) {
+	case KVM_REG_GUEST_SSP:
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
index 34afe43579bb..cf4f73a95825 100644
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


