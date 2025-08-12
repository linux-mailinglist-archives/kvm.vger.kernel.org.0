Return-Path: <kvm+bounces-54486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 58811B21B18
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 04:59:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E7471A242CE
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 03:00:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 627EC2E7F33;
	Tue, 12 Aug 2025 02:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ula7wo2V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74792E7174;
	Tue, 12 Aug 2025 02:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754967397; cv=none; b=JbaAPBZaaRr4y8BeE2egazN3B9j3yvZVhBfzSWV4PEg46iNANcud7gAyCJvp3fPUByECxzvvTxSMnqHijCN0R6WUfw9oMB7SzdgyobhBN/PdL/F1BpXl/a5H8yb1hB+QtW+MMiiBVM1Bj8AXg1+Q+EychGYjBUwMmvfdMQu5y+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754967397; c=relaxed/simple;
	bh=Pbs8pVnxI8ZQEBDx6QcNwUCWk1rHplcYcFzwnv6FgGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JihPdL/JmsdoIAOpkVE6KMQK7vSvVBC8UDG/g8RMx8YJPKO6RvgSBNIu2N0ZDEroDdzC3hgBnfETalZWtLDmmLc7BDlwv1GojGVJAb0k+tero3AddSZKpcdhiNam/AVGfgsobugd/EKIPK6HjnW4FNTXG4vku5DLcMntjO3m+K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ula7wo2V; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754967395; x=1786503395;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Pbs8pVnxI8ZQEBDx6QcNwUCWk1rHplcYcFzwnv6FgGk=;
  b=Ula7wo2V7I2/ttvq+1Oeh408odFcQwJH46ysMnUjTKWgjruKyqN685wf
   7hdnLMI/3MxW1abJd4q3rpGw57zkNjXXxQYU/gzwuqTpN5G580ljIiIQF
   RJZQzwoOWFpAAIsF+9vMCMBBLwsw5ZoyVdj1G5splfXWCipUWdBWDqkQw
   Dyms15yXXFao73YUnr0kr+yIu2ELwnMMWqAvU9HkccezG7QlzW8imgqFh
   jlXGH1oHxEsuMfkeUUv8XRmuz5vxV/3IdI9sThMrcdtAfny4MEG7Izx6g
   l77vjmPcEQUwhvQemQxIxFOCv+W4ZUBguHVTurZugZGfqcJzYUGYHzfBi
   Q==;
X-CSE-ConnectionGUID: ce8vz3G+QQ2U3wGwdI7hZw==
X-CSE-MsgGUID: 6EJ5FVWIRrSqxYSA01t22w==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57100561"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="57100561"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:33 -0700
X-CSE-ConnectionGUID: uJzIiBdfR1ODzuxn0Q34/g==
X-CSE-MsgGUID: YKTVyIHVQYCxBG0rbHHOqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="171321314"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:33 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: mlevitsk@redhat.com,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	xin@zytor.com,
	Sean Christopherson <seanjc@google.com>,
	Mathias Krause <minipli@grsecurity.net>,
	John Allen <john.allen@amd.com>,
	Chao Gao <chao.gao@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v12 14/24] KVM: x86: Enable guest SSP read/write interface with new uAPIs
Date: Mon, 11 Aug 2025 19:55:22 -0700
Message-ID: <20250812025606.74625-15-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250812025606.74625-1-chao.gao@intel.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
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
index 7134f428b9f7..b5c4db4b7e04 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5975,7 +5975,15 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 
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
index 31ce76369cc7..f8fbd33db067 100644
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
2.47.1


