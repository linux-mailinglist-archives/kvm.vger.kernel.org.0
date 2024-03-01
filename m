Return-Path: <kvm+bounces-10660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C513386E738
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 18:30:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78418289659
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 17:30:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AEC422097;
	Fri,  1 Mar 2024 17:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b31Wjz+U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B598BED;
	Fri,  1 Mar 2024 17:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709314186; cv=none; b=r6aXqmtTVb8rCNj5Li65nQ3R4rPIwj0LSi+EvJ+U1/52PEgkAMVPKlw2HbuXzzKF/chbHGrQozs6aKvqNgrVtTDUubqH7sfRE2rIcFirFyYGQRfXxT5Vh4Pm8qZ1764pzAnLn5wjRFfHifMOE0YXEiWEWBAUzpCXUPpwtGzkxLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709314186; c=relaxed/simple;
	bh=L8tZoKqL5jzbGjkL4hvBkVrDBWeSD538UMVU5yxx08Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LkidMZwDr+LtAui0t7ocXHGCRPNJrJtB4dklOmzRbY+A7b2XgFr21n04nEe+ieYaM6KG2uYJQmn+QedjVlpiwmTnzdPapPjZxa+uwXfEHl54PxgYY7W1OlTSqxJ+ul10XwgE55SzaITG+2H4BbqPKQ6/GgJzif8K2C/W0hY4Vmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b31Wjz+U; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709314184; x=1740850184;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L8tZoKqL5jzbGjkL4hvBkVrDBWeSD538UMVU5yxx08Q=;
  b=b31Wjz+UQPbxdewQZ7Tr2YbgTzl5fjARkC4iTTJli4mSYJqK37hcZ7tt
   eU2JnNULlBhy2MSNdUUPOK5kiJUem01pkSJ7tHl6c0Q5N7i4iPC9I/Jqz
   R2d7bgl1UtlNknA1Numo3Em3CRqHHe5sP9ycxoPZC4ghg6jouZ6QbIxDd
   YAIopyG0QdvSPBY6l2g7ssPu/P3mGZRIHQJiiaFAFp3P8WrqfM/mprck4
   4lON4JUPB8nKeQUbmJhUAiIde4DKZpYoOn/VarLE3+AI8p8xX1ROr3y9m
   b+PsMJDzDy+XHGDDYJE45R9JqUUe56ca2483UfNYRJV1Q+gknzDz2ZuP3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11000"; a="6812387"
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="6812387"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 09:29:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="12946533"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 09:29:23 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>
Subject: [RFC PATCH 2/8] KVM: Add KVM_MAP_MEMORY vcpu ioctl to pre-populate guest memory
Date: Fri,  1 Mar 2024 09:28:44 -0800
Message-Id: <012b59708114ba121735769de94756fa5af3204d.1709288671.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1709288671.git.isaku.yamahata@intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add new ioctl KVM_MAP_MEMORY in the kvm common code. It iterates on the
memory range and call arch specific function.  Add stub function as weak
symbol.

[1] https://lore.kernel.org/kvm/Zbrj5WKVgMsUFDtb@google.com/
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/linux/kvm_host.h |  4 +++
 include/uapi/linux/kvm.h | 15 ++++++++
 virt/kvm/kvm_main.c      | 74 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 93 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9807ea98b568..afbed288d625 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2445,4 +2445,8 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
+int kvm_arch_vcpu_pre_map_memory(struct kvm_vcpu *vcpu);
+int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
+			     struct kvm_memory_mapping *mapping);
+
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2190adbe3002..f5d6b481244f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -917,6 +917,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_MAP_MEMORY 236
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1548,4 +1549,18 @@ struct kvm_create_guest_memfd {
 	__u64 reserved[6];
 };
 
+#define KVM_MAP_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_memory_mapping)
+
+#define KVM_MEMORY_MAPPING_FLAG_WRITE	_BITULL(0)
+#define KVM_MEMORY_MAPPING_FLAG_EXEC	_BITULL(1)
+#define KVM_MEMORY_MAPPING_FLAG_USER	_BITULL(2)
+#define KVM_MEMORY_MAPPING_FLAG_PRIVATE	_BITULL(3)
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
index d1fd9cb5d037..d77c9b79d76b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4419,6 +4419,69 @@ static int kvm_vcpu_ioctl_get_stats_fd(struct kvm_vcpu *vcpu)
 	return fd;
 }
 
+__weak int kvm_arch_vcpu_pre_map_memory(struct kvm_vcpu *vcpu)
+{
+	return -EOPNOTSUPP;
+}
+
+__weak int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
+				    struct kvm_memory_mapping *mapping)
+{
+	return -EOPNOTSUPP;
+}
+
+static int kvm_vcpu_map_memory(struct kvm_vcpu *vcpu,
+			       struct kvm_memory_mapping *mapping)
+{
+	bool added = false;
+	int idx, r = 0;
+
+	if (mapping->flags & ~(KVM_MEMORY_MAPPING_FLAG_WRITE |
+			       KVM_MEMORY_MAPPING_FLAG_EXEC |
+			       KVM_MEMORY_MAPPING_FLAG_USER |
+			       KVM_MEMORY_MAPPING_FLAG_PRIVATE))
+		return -EINVAL;
+	if ((mapping->flags & KVM_MEMORY_MAPPING_FLAG_PRIVATE) &&
+	    !kvm_arch_has_private_mem(vcpu->kvm))
+		return -EINVAL;
+
+	/* Sanity check */
+	if (!IS_ALIGNED(mapping->source, PAGE_SIZE) ||
+	    !mapping->nr_pages ||
+	    mapping->base_gfn + mapping->nr_pages <= mapping->base_gfn)
+		return -EINVAL;
+
+	vcpu_load(vcpu);
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+	r = kvm_arch_vcpu_pre_map_memory(vcpu);
+	if (r)
+		return r;
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
+		r = kvm_arch_vcpu_map_memory(vcpu, mapping);
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
@@ -4620,6 +4683,17 @@ static long kvm_vcpu_ioctl(struct file *filp,
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
+		if (copy_to_user(argp, &mapping, sizeof(mapping)))
+			r = -EFAULT;
+		break;
+	}
 	default:
 		r = kvm_arch_vcpu_ioctl(filp, ioctl, arg);
 	}
-- 
2.25.1


