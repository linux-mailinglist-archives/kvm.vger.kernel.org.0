Return-Path: <kvm+bounces-55286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 64D6FB2FAB8
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 15:40:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95286189B357
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:36:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E46534DCDF;
	Thu, 21 Aug 2025 13:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O+CFAz3W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AC3342C86;
	Thu, 21 Aug 2025 13:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755783128; cv=none; b=WTNAzwhb5YpM8dB3WF8nt8IYy8+SvgNZBMExr5VIhfeboeH/nqoSc5UFXcV36mjPy2wryTyjhRGCn+1JW1fpiHe3iOw4l1HEHNHRWYmoVig/WVj4ZmZccC5nLtzvww2oF2jT9esTVAHInk9sa7wthYR40DbQBwR11IsdusFtzX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755783128; c=relaxed/simple;
	bh=WeKKR+RDt3izijkWhwNau3UupyKGSg91PC0OQPMIrTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ufRODWAI1YvMu5mdt3lYanOdtnSCMcNkkxybvKEnmqGZPNOSKBrlhiwf9WhNddUjGGP1oKcKUJCOU67JZ9/CmTiFiZ8ElpQ0yfEKBE56noQzbrpMEzpTqBIMZAlg0uGj6G3saHZ2Bu9fJSXA5GpSfTepRVWvNJUyJbhUIS8+vBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O+CFAz3W; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755783126; x=1787319126;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WeKKR+RDt3izijkWhwNau3UupyKGSg91PC0OQPMIrTc=;
  b=O+CFAz3WHeYrRUyaWeiJsR+wfiQXUmeFE65+556mXbOW0YxyqczWaB4y
   58t8S1z5hfC2lXv8KEd9kAjOUA7fDG/WrC6vYUcD6l8ii87RdBJDwLOpW
   GGWBsXgMGjiJbp1sgu09G/MFL3xOM0/HriZrfIsgQsg1h2huLUCWEaMyP
   X9LAeOdb4PJz+KYwMKhrSwWNsoWFlAtC4LqxH+JRnow9EjAjHPV89vAO+
   w9YOoWm4qi89NzwN6jy6wCJfwJ16qmaya7aB+NYljrbdETjXW/PRCPkhb
   rke/0PsjBg1KS96nAGVWCDEGngCjM53EgXPfMYBAa7nQ9uy+CehsJE7Bu
   w==;
X-CSE-ConnectionGUID: HhyVH3gYRiqqv0E4+lI4RQ==
X-CSE-MsgGUID: d1jwl/ULRSil+X83VZ12Rg==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="69446149"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="69446149"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:32:01 -0700
X-CSE-ConnectionGUID: //Q3kti4TnuRi3VaYUy/+g==
X-CSE-MsgGUID: VUmgEUpfRQKaK6OFzdntnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="199285387"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:31:38 -0700
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
Subject: [PATCH v13 01/21] KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs support
Date: Thu, 21 Aug 2025 06:30:35 -0700
Message-ID: <20250821133132.72322-2-chao.gao@intel.com>
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
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>

---
v13:
 - Add vendor and size fields to the register ID to align with other
   architectures. (Sean)
 - Avoid exposing the struct overlay of the register ID to in uAPI
   headers (Sean)
 - Advertise KVM_CAP_ONE_REG
---
 arch/x86/include/uapi/asm/kvm.h | 21 +++++++++
 arch/x86/kvm/x86.c              | 82 +++++++++++++++++++++++++++++++++
 2 files changed, 103 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 0f15d683817d..969a63e73190 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -411,6 +411,27 @@ struct kvm_xcrs {
 	__u64 padding[16];
 };
 
+#define KVM_X86_REG_TYPE_MSR		2
+#define KVM_X86_REG_TYPE_SYNTHETIC_MSR	3
+
+#define KVM_X86_REG_TYPE_SIZE(type)						\
+({										\
+	__u64 type_size = (__u64)type << 32;					\
+										\
+	type_size |= type == KVM_X86_REG_TYPE_MSR ? KVM_REG_SIZE_U64 :		\
+		     type == KVM_X86_REG_TYPE_SYNTHETIC_MSR ? KVM_REG_SIZE_U64 :\
+		     0;								\
+	type_size;								\
+})
+
+#define KVM_X86_REG_ENCODE(type, index)				\
+	(KVM_REG_X86 | KVM_X86_REG_TYPE_SIZE(type) | index)
+
+#define KVM_X86_REG_MSR(index)					\
+	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_MSR, index)
+#define KVM_X86_REG_SYNTHETIC_MSR(index)			\
+	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_SYNTHETIC_MSR, index)
+
 #define KVM_SYNC_X86_REGS      (1UL << 0)
 #define KVM_SYNC_X86_SREGS     (1UL << 1)
 #define KVM_SYNC_X86_EVENTS    (1UL << 2)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7ba2cdfdac44..31a7e7ad310a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2254,6 +2254,31 @@ static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
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
@@ -4737,6 +4762,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_MEMORY_FAULT_INFO:
 	case KVM_CAP_X86_GUEST_MODE:
+	case KVM_CAP_ONE_REG:
 		r = 1;
 		break;
 	case KVM_CAP_PRE_FAULT_MEMORY:
@@ -5915,6 +5941,20 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 	}
 }
 
+struct kvm_x86_reg_id {
+	__u32 index;
+	__u8  type;
+	__u8  rsvd;
+	__u8  rsvd4:4;
+	__u8  size:4;
+	__u8  x86;
+};
+
+static int kvm_translate_synthetic_msr(struct kvm_x86_reg_id *reg)
+{
+	return -EINVAL;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -6031,6 +6071,48 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
+		if ((reg.id & KVM_REG_ARCH_MASK) != KVM_REG_X86)
+			break;
+
+		id = (struct kvm_x86_reg_id *)&reg.id;
+		if (id->rsvd || id->rsvd4)
+			break;
+
+		if (id->type != KVM_X86_REG_TYPE_MSR &&
+		    id->type != KVM_X86_REG_TYPE_SYNTHETIC_MSR)
+			break;
+
+		if ((reg.id & KVM_REG_SIZE_MASK) != KVM_REG_SIZE_U64)
+			break;
+
+		if (id->type == KVM_X86_REG_TYPE_SYNTHETIC_MSR) {
+			r = kvm_translate_synthetic_msr(id);
+			if (r)
+				break;
+		}
+
+		r = -EINVAL;
+		if (id->type != KVM_X86_REG_TYPE_MSR)
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
2.47.3


