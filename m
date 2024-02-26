Return-Path: <kvm+bounces-9638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AE38F866C51
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:32:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64B821F21872
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D52A52F75;
	Mon, 26 Feb 2024 08:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mVKnxvyW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8094EB44;
	Mon, 26 Feb 2024 08:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936068; cv=none; b=VsML1MoBy9enias2gfd/IjpZH7nSXT3z23KlfTU2RlolotPDSRWC9o8USP6AWvmM09BRQi19oT7eMWYpebM8PtOUgcOYictKBGpHxC77WIFBolmT+r9J4vPsl2s5XjYDBFSFVxc8aLlUSaGtI4Y/5HgK5O3HGE8dbtSSB1j69mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936068; c=relaxed/simple;
	bh=M0yJ/NQ+t9AuoodsI2KxRlq7XjG9s/CzpOfeudWoVdA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FgzyjHfi1rwO3GH9RYQTgVQ9VjYT5h6TwttAbErwBW4rU1O/vfWvsYECbpN17cqN+zo9tAXcWvTngE06Z/j0kshK+WBwXqd1tvuG/QyBCZq40b2hUgsY+QIhro7a8lb3g3WGUrFcxwzFJOM2yIuMZFnWGuVFEI8kJlVvMDLJUWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mVKnxvyW; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936066; x=1740472066;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M0yJ/NQ+t9AuoodsI2KxRlq7XjG9s/CzpOfeudWoVdA=;
  b=mVKnxvyWLyCTuYqw6QzSOlsLS4RJcLMSBEMRkMLagLkUBLdbJr87FoZB
   cH/+NsbqdjS3IpYfraICpHRg0s61YJbACYaof/lIv8NrzNGwvHz0X0GQL
   OdsGInhlC/jT6lby7Qi2GWoYJWj9gNFsGZeGuAtf4fEXX8FI8GVJbfbIM
   t87czq2tcqvbJR7GW9K/k8D51JKy6QoeoOnuhr/oAOfNUmhHL8WpQY5hP
   0JUDzH9p86hUBbYJp6RRYpL/b7SdOvEY/QRNAAPBZ3mRoNLjvkv0WpysU
   M2IzyQ+08BJMPcEKwTlY7RSqtyZUivjazlF9kKAQyzI5K6eJ0rNzJRLy+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="28631485"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="28631485"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6474338"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:42 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 014/130] KVM: Add KVM vcpu ioctl to pre-populate guest memory
Date: Mon, 26 Feb 2024 00:25:16 -0800
Message-Id: <8b7380f1b02f8e3995f18bebb085e43165d5d682.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add new ioctl KVM_MEMORY_MAPPING in the kvm common code. It iterates on the
memory range and call arch specific function.  Add stub function as weak
symbol.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v19:
- newly added
---
 include/linux/kvm_host.h |  4 +++
 include/uapi/linux/kvm.h | 10 ++++++
 virt/kvm/kvm_main.c      | 67 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0520cd8d03cc..eeaf4e73317c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2389,4 +2389,8 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
+void kvm_arch_vcpu_pre_memory_mapping(struct kvm_vcpu *vcpu);
+int kvm_arch_vcpu_memory_mapping(struct kvm_vcpu *vcpu,
+				 struct kvm_memory_mapping *mapping);
+
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c3308536482b..5e2b28934aa9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1155,6 +1155,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_MEMORY_MAPPING 236
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -2227,4 +2228,13 @@ struct kvm_create_guest_memfd {
 	__u64 reserved[6];
 };
 
+#define KVM_MEMORY_MAPPING	_IOWR(KVMIO, 0xd5, struct kvm_memory_mapping)
+
+struct kvm_memory_mapping {
+	__u64 base_gfn;
+	__u64 nr_pages;
+	__u64 flags;
+	__u64 source;
+};
+
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0349e1f241d1..2f0a8e28795e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4409,6 +4409,62 @@ static int kvm_vcpu_ioctl_get_stats_fd(struct kvm_vcpu *vcpu)
 	return fd;
 }
 
+__weak void kvm_arch_vcpu_pre_memory_mapping(struct kvm_vcpu *vcpu)
+{
+}
+
+__weak int kvm_arch_vcpu_memory_mapping(struct kvm_vcpu *vcpu,
+					struct kvm_memory_mapping *mapping)
+{
+	return -EOPNOTSUPP;
+}
+
+static int kvm_vcpu_memory_mapping(struct kvm_vcpu *vcpu,
+				   struct kvm_memory_mapping *mapping)
+{
+	bool added = false;
+	int idx, r = 0;
+
+	/* flags isn't used yet. */
+	if (mapping->flags)
+		return -EINVAL;
+
+	/* Sanity check */
+	if (!IS_ALIGNED(mapping->source, PAGE_SIZE) ||
+	    !mapping->nr_pages ||
+	    mapping->nr_pages & GENMASK_ULL(63, 63 - PAGE_SHIFT) ||
+	    mapping->base_gfn + mapping->nr_pages <= mapping->base_gfn)
+		return -EINVAL;
+
+	vcpu_load(vcpu);
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+	kvm_arch_vcpu_pre_memory_mapping(vcpu);
+
+	while (mapping->nr_pages) {
+		if (signal_pending(current)) {
+			r = -ERESTARTSYS;
+			break;
+		}
+
+		if (need_resched())
+			cond_resched();
+
+		r = kvm_arch_vcpu_memory_mapping(vcpu, mapping);
+		if (r)
+			break;
+
+		added = true;
+	}
+
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	vcpu_put(vcpu);
+
+	if (added && mapping->nr_pages > 0)
+		r = -EAGAIN;
+
+	return r;
+}
+
 static long kvm_vcpu_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
@@ -4610,6 +4666,17 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = kvm_vcpu_ioctl_get_stats_fd(vcpu);
 		break;
 	}
+	case KVM_MEMORY_MAPPING: {
+		struct kvm_memory_mapping mapping;
+
+		r = -EFAULT;
+		if (copy_from_user(&mapping, argp, sizeof(mapping)))
+			break;
+		r = kvm_vcpu_memory_mapping(vcpu, &mapping);
+		if (copy_to_user(argp, &mapping, sizeof(mapping)))
+			r = -EFAULT;
+		break;
+	}
 	default:
 		r = kvm_arch_vcpu_ioctl(filp, ioctl, arg);
 	}
-- 
2.25.1


