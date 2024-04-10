Return-Path: <kvm+bounces-14158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 95EFD8A02DD
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 00:08:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A7930B23443
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 22:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D273D190694;
	Wed, 10 Apr 2024 22:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AjZB8IIe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F1518410B;
	Wed, 10 Apr 2024 22:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712786878; cv=none; b=CR4+Nj9+PqfdvUleS48IpDx5eP/h43HgFYMW0z1oT7Fa8ZxTDjUVCIi39CXW2bXe9JcjVGQ/lz+Nn2X5puV7ECVqENlqZcJeL2DWY5kfVhujyEIiiHC8yak0dEOQGSvgCbYrKco5gwWfDByT/ZqwqQTS3bXp91S9+XY6PBrU4jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712786878; c=relaxed/simple;
	bh=RGRZLnS1e0K8pXOQ+HzpK57xndukuVd+qCbivG6HpcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkNNKJtkoXstXGDfqUv2YQrX+1ZEiAyMp5ZfEL2l5ut/zIMQx9+BK4D8i5M8ZwQQDZuRuKUREwKAcz4v9CYU1DgzjqMpIFBvvsmJPJeEW59MYXQhxWI7Sr53zSh36gOcms1QIOV7pXoivoqPs2QaHV49VhKDlzlGHwV0NSEqx/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AjZB8IIe; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712786877; x=1744322877;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RGRZLnS1e0K8pXOQ+HzpK57xndukuVd+qCbivG6HpcQ=;
  b=AjZB8IIe3Jec3XJ6Z/XF+p3te2lQgfCoAgk7qo5DfYu0Mt4bAT39yVm+
   gUnS4xCh4DiXXPJ7721waNWYJiQ/j+WFkvBdShOpq1ZhAlmV7crN+RJ9/
   t1XbOOGQJ2NsbXgGE2k0jh549jCkS+3J8W5+mqA6Ik9V57Ah/fqJBoukl
   F71dtN1obFvqHoEMFTpV1PUeWyRMzSIXsduV6l19zZvLqkpUlL7NXD+6j
   xdUzP4xqaYjcbXdVoTzjV4AXLSIWn76MZzMKNbfd7KQM7M+pC4FcYkZ85
   SqZ24dgpxdGLcjAMmtryuPCuhb9ACGpkTcTh8cDEvWTS1f1t9AI9X4s1E
   g==;
X-CSE-ConnectionGUID: 2QDMHJKVSweq0egWJtWBlQ==
X-CSE-MsgGUID: UlfDWJi6TZaRXSmNHld0pQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="8041111"
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="8041111"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 15:07:54 -0700
X-CSE-ConnectionGUID: EOOvi2lWSD+k+1BWQbxUVQ==
X-CSE-MsgGUID: EUaxKyxZQs6D8QQUWpiJsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="25476300"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 15:07:53 -0700
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 02/10] KVM: Add KVM_MAP_MEMORY vcpu ioctl to pre-populate guest memory
Date: Wed, 10 Apr 2024 15:07:28 -0700
Message-ID: <819322b8f25971f2b9933bfa4506e618508ad782.1712785629.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <cover.1712785629.git.isaku.yamahata@intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a new ioctl KVM_MAP_MEMORY in the KVM common code. It iterates on the
memory range and calls the arch-specific function.  Add stub arch function
as a weak symbol.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v2:
- Drop need_resched(). (David, Sean, Kai)
- Move cond_resched() at the end of loop. (Kai)
- Drop added check. (David)
- Use EINTR instead of ERESTART. (David, Sean)
- Fix srcu lock leak. (Kai, Sean)
- Add comment above copy_to_user().
- Drop pointless comment. (Sean)
- Drop kvm_arch_vcpu_pre_map_memory(). (Sean)
- Don't overwrite error code. (Sean, David)
- Make the parameter in bytes, not pages. (Michael)
- Drop source member in struct kvm_memory_mapping. (Sean, Michael)
---
 include/linux/kvm_host.h |  3 +++
 include/uapi/linux/kvm.h |  9 +++++++
 virt/kvm/kvm_main.c      | 54 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 48f31dcd318a..e56a0c7e5b42 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2445,4 +2445,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
+int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
+			     struct kvm_memory_mapping *mapping);
+
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2190adbe3002..972aa9e054d3 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -917,6 +917,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_MAP_MEMORY 236
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1548,4 +1549,12 @@ struct kvm_create_guest_memfd {
 	__u64 reserved[6];
 };
 
+#define KVM_MAP_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_memory_mapping)
+
+struct kvm_memory_mapping {
+	__u64 base_address;
+	__u64 size;
+	__u64 flags;
+};
+
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fb49c2a60200..f2ad9e106cdb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4415,6 +4415,48 @@ static int kvm_vcpu_ioctl_get_stats_fd(struct kvm_vcpu *vcpu)
 	return fd;
 }
 
+__weak int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
+				    struct kvm_memory_mapping *mapping)
+{
+	return -EOPNOTSUPP;
+}
+
+static int kvm_vcpu_map_memory(struct kvm_vcpu *vcpu,
+			       struct kvm_memory_mapping *mapping)
+{
+	int idx, r;
+
+	if (mapping->flags)
+		return -EINVAL;
+
+	if (!PAGE_ALIGNED(mapping->base_address) ||
+	    !PAGE_ALIGNED(mapping->size) ||
+	    mapping->base_address + mapping->size <= mapping->base_address)
+		return -EINVAL;
+
+	vcpu_load(vcpu);
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+
+	r = 0;
+	while (mapping->size) {
+		if (signal_pending(current)) {
+			r = -EINTR;
+			break;
+		}
+
+		r = kvm_arch_vcpu_map_memory(vcpu, mapping);
+		if (r)
+			break;
+
+		cond_resched();
+	}
+
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	vcpu_put(vcpu);
+
+	return r;
+}
+
 static long kvm_vcpu_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
@@ -4616,6 +4658,18 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = kvm_vcpu_ioctl_get_stats_fd(vcpu);
 		break;
 	}
+	case KVM_MAP_MEMORY: {
+		struct kvm_memory_mapping mapping;
+
+		r = -EFAULT;
+		if (copy_from_user(&mapping, argp, sizeof(mapping)))
+			break;
+		r = kvm_vcpu_map_memory(vcpu, &mapping);
+		/* Don't check error to tell the processed range. */
+		if (copy_to_user(argp, &mapping, sizeof(mapping)))
+			r = -EFAULT;
+		break;
+	}
 	default:
 		r = kvm_arch_vcpu_ioctl(filp, ioctl, arg);
 	}
-- 
2.43.2


