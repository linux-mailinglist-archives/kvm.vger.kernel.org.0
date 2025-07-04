Return-Path: <kvm+bounces-51580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F0D89AF8EA9
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 11:32:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A83D9B6651E
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:54:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24FE02F365D;
	Fri,  4 Jul 2025 08:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WkxCfwCB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2652EF665;
	Fri,  4 Jul 2025 08:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751619048; cv=none; b=OOFKl1uk78P7uVxQ5ToSG4AUyqkUAyPHB0AMQaSbg3EptjUOKMPHegni4yfRj/FtDMG5/ZQotcxDyKJJTc+dH21T5KXCgrxp65sXYaECQaxZMn6+KxfIu1ZyF4v2GxxDOUlHcK/1fTKZe1H4KzniAjAy0YEuxA1wX4Hexwt/W80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751619048; c=relaxed/simple;
	bh=WrIErqpAsLYYcuED0WnH89yjpjhV9lt00b3Cnw3x7v4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZfuQvWfmcpz8AUQFotIXAcVzxsmI+23ahmkwMauT094p7wAmut/k5V5aHBnR5hx5OuF2PRvPpEJXcsFtIMbNjCNVoRWOCrtiJxwax1MUF+83cGckX/qm+kBdlPAG8r7/HGzfToiJvnxk1I/9Qj18P51VBxErl+Rnqhg6uf+JQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WkxCfwCB; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751619047; x=1783155047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WrIErqpAsLYYcuED0WnH89yjpjhV9lt00b3Cnw3x7v4=;
  b=WkxCfwCBubsK8HXaQke8yMhFzhy2dEADL4ll5KW5mN2cDbWyAW1I7Nax
   kxmpsHgLC5DMfeGjwrIp01CQo6m34G7225i5EqBS6QE2x3Otas2pSi3Bz
   VPvUeHCQEdXqzhv2nCYV/j7lxZP54jDfvIfGkjm5PgKMV1DiqvqjejgLm
   uRTBJXUJ+Y5saTKk9buDcM5v2ATk23QWv4ZItIkfEy8H+ZUSnC82IfemJ
   l1+nCjWCfnhO0iF9VjLh1OKTSk1I6+gAdVbxhS8MeqhV7yF/jJrr8BrKx
   ygIFeRFNcunOqc/qFk/AsPakCn09pASZQFJl0lMHuvUp4g8C9AdNi5qXd
   w==;
X-CSE-ConnectionGUID: BrOYzSWITb+AFfrmdWlZ/Q==
X-CSE-MsgGUID: iALvERIvSHWf/wFZ8fbrzg==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="79391690"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="79391690"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:40 -0700
X-CSE-ConnectionGUID: KXGYiM98SnSFxwMV5CV1XQ==
X-CSE-MsgGUID: jCFfnOosSD+lEZGGHB7log==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="154721989"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:41 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com
Cc: rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com,
	minipli@grsecurity.net,
	xin@zytor.com,
	Chao Gao <chao.gao@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v11 13/23] KVM: x86: Enable guest SSP read/write interface with new uAPIs
Date: Fri,  4 Jul 2025 01:49:44 -0700
Message-ID: <20250704085027.182163-14-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250704085027.182163-1-chao.gao@intel.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
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
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/include/uapi/asm/kvm.h |  3 +++
 arch/x86/kvm/x86.c              | 10 +++++++++-
 arch/x86/kvm/x86.h              | 10 ++++++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index e72d9e6c1739..a4870d9c9279 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -421,6 +421,9 @@ struct kvm_x86_reg_id {
 	__u16 rsvd16;
 };
 
+/* KVM synthetic MSR index staring from 0 */
+#define KVM_SYNTHETIC_GUEST_SSP 0
+
 #define KVM_SYNC_X86_REGS      (1UL << 0)
 #define KVM_SYNC_X86_SREGS     (1UL << 1)
 #define KVM_SYNC_X86_EVENTS    (1UL << 2)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f6cf371ee16a..2373968ea7fd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5969,7 +5969,15 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 
 static int kvm_translate_synthetic_msr(struct kvm_x86_reg_id *reg)
 {
-	return -EINVAL;
+	switch (reg->index) {
+	case KVM_SYNTHETIC_GUEST_SSP:
+		reg->type = KVM_X86_REG_MSR;
+		reg->index = MSR_KVM_INTERNAL_GUEST_SSP;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
 }
 
 long kvm_arch_vcpu_ioctl(struct file *filp,
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 2914e99059c9..17b1485fa2f4 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -79,6 +79,16 @@ void kvm_spurious_fault(void);
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
2.47.1


