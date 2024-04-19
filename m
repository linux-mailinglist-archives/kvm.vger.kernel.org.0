Return-Path: <kvm+bounces-15219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 021DB8AAB15
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 11:01:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADD0428222E
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 09:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A23B876056;
	Fri, 19 Apr 2024 08:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aWi/5Rol"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB637EF1D
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 08:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713517179; cv=none; b=TORFiqesQlyRy4xLurvyXiVDv8iUBclgA2YeNGixw2qrAmqcILAI1wndqYG3yBiZb/TkdVShzdF5bO7xjrEBKhfO2lynWIFsfT46QsbjUKOeySMo7mwI8On7YtkFjNjrD9HMn0cc2vjPXYuGNyodCMVjX8KjRHuiyCNPc6CqXyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713517179; c=relaxed/simple;
	bh=6QsTyro7o0g/mAgLz5I9OAAjavd5uhJCINBH9wpklts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uPHnt7mVc02Alsze5j2hScaqOgiXYf67EJMm7L7N88QbLLwdv6Fvp6IYddcLzC2W9LyN6o7GcLCokF2u8aaA+tLY1YGIxMNcVdVjekHijtcb6V3NJviMa33Mz4gaUHtDY8sffdsNGY1hOXMUy21h8qIpc+8fuTWfi3JqYnezC4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aWi/5Rol; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713517177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AbYCbT6M2EaJK1Q6vJ2IcYCS7NUptHbLc4XrSU4QEHw=;
	b=aWi/5Rolb0Bt2KfsqTRDbkL/M7uygsJz0mkZ6BRycg69Zcx26cm41nqA+QRaLxsLq0Bwp1
	+HOvczo9zzqMkmrkT4AB0/tYONrqMtC6WyOgN2+rCMZ4LX2SyMiZDZXFoBljQ161MCdFlu
	GU94kWUkfdKmNrWFJIGxUs/3T7gkcEQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-265-PvhzoT8IPsW6Z41sicIZIw-1; Fri,
 19 Apr 2024 04:59:30 -0400
X-MC-Unique: PvhzoT8IPsW6Z41sicIZIw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE12C1C294CE;
	Fri, 19 Apr 2024 08:59:28 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BC7992033A7D;
	Fri, 19 Apr 2024 08:59:28 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 2/6] KVM: Add KVM_PRE_FAULT_MEMORY vcpu ioctl to pre-populate guest memory
Date: Fri, 19 Apr 2024 04:59:23 -0400
Message-ID: <20240419085927.3648704-3-pbonzini@redhat.com>
In-Reply-To: <20240419085927.3648704-1-pbonzini@redhat.com>
References: <20240419085927.3648704-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a new ioctl KVM_PRE_FAULT_MEMORY in the KVM common code. It iterates on the
memory range and calls the arch-specific function.  Add stub arch function
as a weak symbol.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-ID: <819322b8f25971f2b9933bfa4506e618508ad782.1712785629.git.isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/kvm_host.h |  5 ++++
 include/uapi/linux/kvm.h | 10 +++++++
 virt/kvm/Kconfig         |  3 ++
 virt/kvm/kvm_main.c      | 63 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 81 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8dea11701ab2..9e9943e5e37c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2478,4 +2478,9 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages
 void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 #endif
 
+#ifdef CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY
+long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
+				    struct kvm_pre_fault_memory *range);
+#endif
+
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2190adbe3002..917d2964947d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -917,6 +917,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_PRE_FAULT_MEMORY 236
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1548,4 +1549,13 @@ struct kvm_create_guest_memfd {
 	__u64 reserved[6];
 };
 
+#define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_memory)
+
+struct kvm_pre_fault_memory {
+	__u64 gpa;
+	__u64 size;
+	__u64 flags;
+	__u64 padding[5];
+};
+
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 754c6c923427..b14e14cdbfb9 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -67,6 +67,9 @@ config HAVE_KVM_INVALID_WAKEUPS
 config KVM_GENERIC_DIRTYLOG_READ_PROTECT
        bool
 
+config KVM_GENERIC_PRE_FAULT_MEMORY
+       bool
+
 config KVM_COMPAT
        def_bool y
        depends on KVM && COMPAT && !(S390 || ARM64 || RISCV)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 38b498669ef9..51d8dbe7e93b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4379,6 +4379,55 @@ static int kvm_vcpu_ioctl_get_stats_fd(struct kvm_vcpu *vcpu)
 	return fd;
 }
 
+#ifdef CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY
+static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
+				     struct kvm_pre_fault_memory *range)
+{
+	int idx;
+	long r;
+	u64 full_size;
+
+	if (range->flags)
+		return -EINVAL;
+
+	if (!PAGE_ALIGNED(range->gpa) ||
+	    !PAGE_ALIGNED(range->size) ||
+	    range->gpa + range->size <= range->gpa)
+		return -EINVAL;
+
+	if (!range->size)
+		return 0;
+
+	vcpu_load(vcpu);
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+
+	full_size = range->size;
+	do {
+		if (signal_pending(current)) {
+			r = -EINTR;
+			break;
+		}
+
+		r = kvm_arch_vcpu_pre_fault_memory(vcpu, range);
+		if (r < 0)
+			break;
+
+		if (WARN_ON_ONCE(r == 0))
+			break;
+
+		range->size -= r;
+		range->gpa += r;
+		cond_resched();
+	} while (range->size);
+
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	vcpu_put(vcpu);
+
+	/* Return success if at least one page was mapped successfully.  */
+	return full_size == range->size ? r : 0;
+}
+#endif
+
 static long kvm_vcpu_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
@@ -4580,6 +4629,20 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = kvm_vcpu_ioctl_get_stats_fd(vcpu);
 		break;
 	}
+#ifdef CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY
+	case KVM_PRE_FAULT_MEMORY: {
+		struct kvm_pre_fault_memory range;
+
+		r = -EFAULT;
+		if (copy_from_user(&range, argp, sizeof(range)))
+			break;
+		r = kvm_vcpu_pre_fault_memory(vcpu, &range);
+		/* Pass back leftover range. */
+		if (copy_to_user(argp, &range, sizeof(range)))
+			r = -EFAULT;
+		break;
+	}
+#endif
 	default:
 		r = kvm_arch_vcpu_ioctl(filp, ioctl, arg);
 	}
-- 
2.43.0



