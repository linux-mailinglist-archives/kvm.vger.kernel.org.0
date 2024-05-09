Return-Path: <kvm+bounces-17101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C5F8E8C0C29
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 09:55:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 614801F22AC2
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 07:55:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4C81149C79;
	Thu,  9 May 2024 07:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dVxppJly"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDDC13C801;
	Thu,  9 May 2024 07:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715241304; cv=none; b=kIusQJo1BkcKuBPMLpI/crWJWokocuoOn9mEh1f3KSn0zRB+0+ewHQpSvK/901M2F5ACbFOnkzBKlU72DwYqtUWZ9jef5c0QCbnfCreZunisdgN8FgF0t9/UXcICZyp5ibEngeJpEx6Y40vdel7PBa2W0d/SWpjJAqNXdNf8CMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715241304; c=relaxed/simple;
	bh=GGccQTnqC8mHfE/l4F8QBhIaWm7K3vpcGZGfxrd99yA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qTcJm4+AtT226+u6TTWcTefZXci7cdFWYO2PyLcU9gYJzMGY9BjXbcwTQAyZDCTcVL+/+RPGJpC/vW6vF0ZobwJiFVPEru44JzdyfhlRYWo0kdgeQgQuA1UGNk+fpd+0hRxxHbHLFYhOhwvYP8oqI5ohMQlwKcidx/z9B2HV2pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dVxppJly; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715241303; x=1746777303;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GGccQTnqC8mHfE/l4F8QBhIaWm7K3vpcGZGfxrd99yA=;
  b=dVxppJlyaILOqt8W9e6t6FDiorLunSsTQh7mwdZahuFHsSleBWlRj8a2
   dsnuFQAOaFPc9JW7yYnz0G1lGCI/5C7mZnhM1qKJ8Iap98xqWQ3XiWD0A
   dO4cutmPSo3sRbBwatp5SY8TepYQ+P7fYAGneSb6vbOv6yS0Slgwn+Z9x
   Se2dUwb1Wb/SFmgXi102/rp2bv/FlHV2GQOZUBK/Zg19GZzKjlF+TFDLE
   s2oZkADWu2jUIVb4mqKCLcSouJEHxSvlOn3brNFdTNMEBC9rAOu/z6gkx
   EWMCEsTuISBqoLz4REkvxOONt9R4lvyNnq8m2pgPO/vOHmgwIjHsRzEpl
   w==;
X-CSE-ConnectionGUID: 4Tjlv7miQVizlyWp646h8g==
X-CSE-MsgGUID: ZMhEEs4dSNu3/pAxmHqZwg==
X-IronPort-AV: E=McAfee;i="6600,9927,11067"; a="28658406"
X-IronPort-AV: E=Sophos;i="6.08,147,1712646000"; 
   d="scan'208";a="28658406"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 00:55:02 -0700
X-CSE-ConnectionGUID: ozw2ceddTjKooZFGha8IMA==
X-CSE-MsgGUID: IGR/x8u5R+CIeSIGQBrLAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,147,1712646000"; 
   d="scan'208";a="29268231"
Received: from 984fee00a5ca.jf.intel.com ([10.165.9.183])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 00:55:02 -0700
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	mlevitsk@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Yang Weijiang <weijiang.yang@intel.com>
Subject: [RFC PATCH 1/2] KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs support
Date: Thu,  9 May 2024 00:54:22 -0700
Message-ID: <20240509075423.156858-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable KVM_{G,S}ET_ONE_REG uAPIs so that userspace can access HW MSR or
KVM synthetic MSR throught it.

In CET KVM series [*], KVM "steals" an MSR from PV MSR space and access
it via KVM_{G,S}ET_MSRs uAPIs, but the approach pollutes PV MSR space
and hides the difference of synthetic MSRs and normal HW defined MSRs.

Now carve out a separate room in KVM-customized MSR address space for
synthetic MSRs. The synthetic MSRs are not exposed to userspace via
KVM_GET_MSR_INDEX_LIST, instead userspace complies with KVM's setup and
composes the uAPI params. KVM synthetic MSR indices start from 0 and
increase linearly. Userspace caller should tag MSR type correctly in
order to access intended HW or synthetic MSR.

[*]:
https://lore.kernel.org/all/20240219074733.122080-18-weijiang.yang@intel.com/

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/uapi/asm/kvm.h | 10 ++++++
 arch/x86/kvm/x86.c              | 62 +++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index ef11aa4cab42..ca2a47a85fa1 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -410,6 +410,16 @@ struct kvm_xcrs {
 	__u64 padding[16];
 };
 
+#define KVM_X86_REG_MSR			(1 << 2)
+#define KVM_X86_REG_SYNTHETIC_MSR	(1 << 3)
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
index 91478b769af0..d0054c52f24b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2244,6 +2244,31 @@ static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
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
@@ -5859,6 +5884,11 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 	}
 }
 
+static int kvm_translate_synthetic_msr(u32 *index)
+{
+	return 0;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -5976,6 +6006,38 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
+		    id->type != KVM_X86_REG_SYNTHETIC_MSR)
+			break;
+
+		if (id->type == KVM_X86_REG_SYNTHETIC_MSR) {
+			r = kvm_translate_synthetic_msr(&id->index);
+			if (r)
+				break;
+		}
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
2.43.0


