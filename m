Return-Path: <kvm+bounces-54478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B956AB21B09
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 04:57:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0DFD1A2316A
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 02:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FAB32E5B32;
	Tue, 12 Aug 2025 02:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PMRxIzRD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796242E3B06;
	Tue, 12 Aug 2025 02:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754967393; cv=none; b=Q3odfPgYNzaf1l0S9MKBY7GsjEmohVS2NKHQb+kvPY0yLnGCytB+KG+SSeQxbv00XPqbBzkfIH7n1zNw2LCCl1SID8dSWQFCjP92PfArdOIpGb4udJl2dwQaT+bWljjJIf/YRuQLzM9Sl00Mh3jUQwVPJrFfqz+maSdlpkUKkoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754967393; c=relaxed/simple;
	bh=jeQqjBfT82jHpwHIytMtiFYaLrUjL/zJkR6ezqsWNk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKBO33V0F/TWBfYihbRa07g3ExPh8NyS2GIIDNg5sa84A5dhkREjdFO9kLbL+iqrskR91ipGJaDqqzgRdlsQuvgWAzlVaFivCjUK/WtyBojc9Jazc7L7MvkhtouGxhd6ACzps8czk+KY/St9SZahAQIqqChRUOyT2XdsCddxK+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PMRxIzRD; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754967391; x=1786503391;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jeQqjBfT82jHpwHIytMtiFYaLrUjL/zJkR6ezqsWNk0=;
  b=PMRxIzRDmkhwGspKfNQ4Z8e0okgCevmEz+c3wLmYls4Atl+6vJzsuiF2
   1M+A0aYCk4pb1nkH3DmPhqQPClxFgU5mMb69XX6HABSWy5OSn7pjvSPbq
   uX5MSp1ZVpsEaelqpWJfMrsLsnFA8Sux674TTqrvvmai85PRRj5DO+oD5
   8BCdgf2LfGwdByT7mhCrEH2UL24YK4pzDZ/oPBrWHO35ztEIuTq5iDtJy
   ar584tRCkgLB96grLmzFXS+GbuYpjqzHmzvHBCllfxURUMSQu016tVcIH
   +P0928bZ+zgGXaQT/PAwvPYiUmCfo2PbinsQnCDGp8AKEbFH/Tk4RoEu1
   w==;
X-CSE-ConnectionGUID: e9d8IHIhRl2g9N0Rp+M8Ww==
X-CSE-MsgGUID: U+OESObDQKKu0YDR7vQKeQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57100481"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="57100481"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:27 -0700
X-CSE-ConnectionGUID: j1N8w3HqSg6hdfihp8ZgEg==
X-CSE-MsgGUID: jsyFMOGiQn2goLd+1pJGJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="171321247"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:27 -0700
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
Subject: [PATCH v12 06/24] KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs support
Date: Mon, 11 Aug 2025 19:55:14 -0700
Message-ID: <20250812025606.74625-7-chao.gao@intel.com>
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

Enable KVM_{G,S}ET_ONE_REG uAPIs so that userspace can access HW MSR or
KVM synthetic MSR through it.

In CET KVM series [1], KVM "steals" an MSR from PV MSR space and access
it via KVM_{G,S}ET_MSRs uAPIs, but the approach pollutes PV MSR space
and hides the difference of synthetic MSRs and normal HW defined MSRs.

Now carve out a separate room in KVM-customized MSR address space for
synthetic MSRs. The synthetic MSRs are not exposed to userspace via
KVM_GET_MSR_INDEX_LIST, instead userspace complies with KVM's setup and
composes the uAPI params. KVM synthetic MSR indices start from 0 and
increase linearly. Userspace caller should tag MSR type correctly in
order to access intended HW or synthetic MSR.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Link: https://lore.kernel.org/all/20240219074733.122080-18-weijiang.yang@intel.com/ [1]
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/include/uapi/asm/kvm.h | 10 +++++
 arch/x86/kvm/x86.c              | 66 +++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 0f15d683817d..e72d9e6c1739 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -411,6 +411,16 @@ struct kvm_xcrs {
 	__u64 padding[16];
 };
 
+#define KVM_X86_REG_MSR			(1 << 2)
+#define KVM_X86_REG_SYNTHETIC		(1 << 3)
+
+struct kvm_x86_reg_id {
+	__u32 index;
+	__u8 type;
+	__u8 rsvd;
+	__u16 rsvd16;
+};
+
 #define KVM_SYNC_X86_REGS      (1UL << 0)
 #define KVM_SYNC_X86_SREGS     (1UL << 1)
 #define KVM_SYNC_X86_EVENTS    (1UL << 2)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0010aa45bf9f..f77949c3e9dd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2241,6 +2241,31 @@ static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 	return kvm_set_msr_ignored_check(vcpu, index, *data, true);
 }
 
+static int kvm_get_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *value)
+{
+	u64 val;
+	int r;
+
+	r = do_get_msr(vcpu, msr, &val);
+	if (r)
+		return r;
+
+	if (put_user(val, value))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_set_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *value)
+{
+	u64 val;
+
+	if (get_user(val, value))
+		return -EFAULT;
+
+	return do_set_msr(vcpu, msr, &val);
+}
+
 #ifdef CONFIG_X86_64
 struct pvclock_clock {
 	int vclock_mode;
@@ -5902,6 +5927,11 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 	}
 }
 
+static int kvm_translate_synthetic_msr(struct kvm_x86_reg_id *reg)
+{
+	return -EINVAL;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -6018,6 +6048,42 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		break;
 	}
+	case KVM_GET_ONE_REG:
+	case KVM_SET_ONE_REG: {
+		struct kvm_x86_reg_id *id;
+		struct kvm_one_reg reg;
+		u64 __user *value;
+
+		r = -EFAULT;
+		if (copy_from_user(&reg, argp, sizeof(reg)))
+			break;
+
+		r = -EINVAL;
+		id = (struct kvm_x86_reg_id *)&reg.id;
+		if (id->rsvd || id->rsvd16)
+			break;
+
+		if (id->type != KVM_X86_REG_MSR &&
+		    id->type != KVM_X86_REG_SYNTHETIC)
+			break;
+
+		if (id->type == KVM_X86_REG_SYNTHETIC) {
+			r = kvm_translate_synthetic_msr(id);
+			if (r)
+				break;
+		}
+
+		r = -EINVAL;
+		if (id->type != KVM_X86_REG_MSR)
+			break;
+
+		value = u64_to_user_ptr(reg.addr);
+		if (ioctl == KVM_GET_ONE_REG)
+			r = kvm_get_one_msr(vcpu, id->index, value);
+		else
+			r = kvm_set_one_msr(vcpu, id->index, value);
+		break;
+	}
 	case KVM_TPR_ACCESS_REPORTING: {
 		struct kvm_tpr_access_ctl tac;
 
-- 
2.47.1


