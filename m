Return-Path: <kvm+bounces-58084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 837B6B877BF
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 02:33:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D214D7C65EA
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 00:33:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE23C24DD01;
	Fri, 19 Sep 2025 00:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pZeBtuXF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA432246327
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758242000; cv=none; b=emjf5AiaeJRDl9H/ajBChAN2GPL4t6iGRUyeeLqET6cB6R2duX3RB1L/zcUVk7HBULixeATfc50u3yeA70z1sB+Efo5ozQglLmPiE55IW3uB9PXiFR1ESl5l3+55RLyZrakggW4cLkMW6UyFz8TexMDaE9w9lBKOp3X+G3f3YU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758242000; c=relaxed/simple;
	bh=ycQPZISrjoZHdv0v5uXiUkbAtVbty6qioOhXOgghES4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CVobS9dvfIrVTKUDrdg9VktaCooqDmnqp+SyUQUVCz+dy0u1sxX807Km/LJNnVYXMRohFamWkF8ygCP094x6s5SrzIS2ON8nFGwoNDtlOVmBKuWDIpkoHfKkjRJsIbtZBNLyCva7njzQCxhNZ3ggKpsm4mGwB1u0OH+YBRPqS/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pZeBtuXF; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b55055060e6so784515a12.3
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 17:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758241998; x=1758846798; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lM9hj9HYnvV2WwTWzJeyWDgwcN2sQ2JAUayMMeQFeWU=;
        b=pZeBtuXFGuhaOmG1dgFerx0Q2mzb40eZnBPXwXNOEVijh2nT4CZSvVuLP2Sv1IdvZc
         tyzGq0H6Hnpnu8EXBPpCWUaxWEwQCQJSIDgPqZTHkUMrOjK4gEANX4F0DHaijIi2Xig/
         HUuzPeZRgR3Zcaz2FA4cf9lYaOiHT7T6T4qKkPg4GMWpMwcSylTbATodX6hSgrc614DA
         ucA1Vp397dJF5nSe3LHYgkWv5ylLSGWUx7c2daa2q0YlKXMHHcv+K10DVZxClJYsFqQO
         e8JWQfcKnBTCdDUmO4+jfW4R0Ywc9KToTO1V0qvHRTgFP8aXKN3bArg/SikZjFe3EEiY
         7M9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758241998; x=1758846798;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lM9hj9HYnvV2WwTWzJeyWDgwcN2sQ2JAUayMMeQFeWU=;
        b=j7x9Cm++B3sGivNyx0+VyPVpjiU/C/k5scjQY2r7ZBF2+4xlIpVbLf5PyXA6MWMKGu
         jkX1OKGjCBh17gdhCSn2eBSPctdCNYStvkXvesKrAASkBJIbSHYQxaHz8T0Ampvhn835
         VcUYqn+DvJqjdwJTolGjtrP5EoFmVY3K8dSDDtmVGIl3Rdz0x87S9gofqb3QusJL8vML
         He79EGoJpV3xNbYCGlFgdzi56+ObRAPE81/Cg+brqY6A80IOr3Vagw3d40WN7lswoV1K
         GaFTLW75evaUY/SQEQZEf8uvqFUS1alrLM9f2DUwwGWjqj4iTibFl1CuZ/rBtqga2Y37
         4fMQ==
X-Forwarded-Encrypted: i=1; AJvYcCVG1/gCkqcVaC1PH3LrrcKf6WsdR0xNWBJv5D7AQ8NZAl4+NbT8pc9N/f+pan2PDtQDVrw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzruHM5TDb6Xjvro1CNG8nYlDjjBlUPMoZ+mTrTYIfShFwyH3cb
	s4zEmUXMz7xtMQPEU6xkQX2apVXYdDPM2dFzace9yEF0h8GjMVYjQMYCZ6+7OZFx3Uqwo/KcoFc
	F+ySMsg==
X-Google-Smtp-Source: AGHT+IHdkM4DX7VjtkzDtAJ4EsTAfYAwgaskoTawruvw3bt0m71PwijPo8lWLT+I3fXBTLDhzkiQY6UXPeM=
X-Received: from pjuj4.prod.google.com ([2002:a17:90a:d004:b0:32d:57a8:8ae6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:e098:b0:243:f797:fdf9
 with SMTP id adf61e73a8af0-2927182c50dmr2195626637.47.1758241997936; Thu, 18
 Sep 2025 17:33:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 18 Sep 2025 17:33:00 -0700
In-Reply-To: <20250919003303.1355064-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919003303.1355064-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919003303.1355064-3-seanjc@google.com>
Subject: [PATCH v2 2/5] KVM: Export KVM-internal symbols for sub-modules only
From: Sean Christopherson <seanjc@google.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Tony Krowiak <akrowiak@linux.ibm.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>, 
	Harald Freudenberger <freude@linux.ibm.com>, Holger Dengler <dengler@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Rework the vast majority of KVM's exports to expose symbols only to KVM
submodules, i.e. to x86's kvm-{amd,intel}.ko and PPC's kvm-{pr,hv}.ko.
With few exceptions, KVM's exported APIs are intended (and safe) for KVM-
internal usage only.

Keep kvm_get_kvm(), kvm_get_kvm_safe(), and kvm_put_kvm() as normal
exports, as they are needed by VFIO, and are generally safe for external
usage (though ideally even the get/put APIs would be KVM-internal, and
VFIO would pin a VM by grabbing a reference to its associated file).

Implement a framework in kvm_types.h in anticipation of providing a macro
to restrict KVM-specific kernel exports, i.e. to provide symbol exports
for KVM if and only if KVM is built as one or more modules.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/include/asm/kvm_types.h |  15 ++++
 arch/x86/include/asm/kvm_types.h     |  10 +++
 include/linux/kvm_types.h            |  25 ++++--
 virt/kvm/eventfd.c                   |   2 +-
 virt/kvm/guest_memfd.c               |   4 +-
 virt/kvm/kvm_main.c                  | 128 +++++++++++++--------------
 6 files changed, 110 insertions(+), 74 deletions(-)
 create mode 100644 arch/powerpc/include/asm/kvm_types.h

diff --git a/arch/powerpc/include/asm/kvm_types.h b/arch/powerpc/include/asm/kvm_types.h
new file mode 100644
index 000000000000..656b498ed3b6
--- /dev/null
+++ b/arch/powerpc/include/asm/kvm_types.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_PPC_KVM_TYPES_H
+#define _ASM_PPC_KVM_TYPES_H
+
+#if IS_MODULE(CONFIG_KVM_BOOK3S_64_PR) && IS_MODULE(CONFIG_KVM_BOOK3S_64_HV)
+#define KVM_SUB_MODULES kvm-pr,kvm-hv
+#elif IS_MODULE(CONFIG_KVM_BOOK3S_64_PR)
+#define KVM_SUB_MODULES kvm-pr
+#elif IS_MODULE(CONFIG_KVM_INTEL)
+#define KVM_SUB_MODULES kvm-hv
+#else
+#undef KVM_SUB_MODULES
+#endif
+
+#endif
diff --git a/arch/x86/include/asm/kvm_types.h b/arch/x86/include/asm/kvm_types.h
index 08f1b57d3b62..23268a188e70 100644
--- a/arch/x86/include/asm/kvm_types.h
+++ b/arch/x86/include/asm/kvm_types.h
@@ -2,6 +2,16 @@
 #ifndef _ASM_X86_KVM_TYPES_H
 #define _ASM_X86_KVM_TYPES_H
 
+#if IS_MODULE(CONFIG_KVM_AMD) && IS_MODULE(CONFIG_KVM_INTEL)
+#define KVM_SUB_MODULES kvm-amd,kvm-intel
+#elif IS_MODULE(CONFIG_KVM_AMD)
+#define KVM_SUB_MODULES kvm-amd
+#elif IS_MODULE(CONFIG_KVM_INTEL)
+#define KVM_SUB_MODULES kvm-intel
+#else
+#undef KVM_SUB_MODULES
+#endif
+
 #define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
 
 #endif /* _ASM_X86_KVM_TYPES_H */
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 827ecc0b7e10..490464c205b4 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -3,6 +3,23 @@
 #ifndef __KVM_TYPES_H__
 #define __KVM_TYPES_H__
 
+#include <linux/bits.h>
+#include <linux/export.h>
+#include <linux/types.h>
+#include <asm/kvm_types.h>
+
+#ifdef KVM_SUB_MODULES
+#define EXPORT_SYMBOL_FOR_KVM_INTERNAL(symbol) \
+	EXPORT_SYMBOL_FOR_MODULES(symbol, __stringify(KVM_SUB_MODULES))
+#else
+#define EXPORT_SYMBOL_FOR_KVM_INTERNAL(symbol)
+#endif
+
+#ifndef __ASSEMBLER__
+
+#include <linux/mutex.h>
+#include <linux/spinlock_types.h>
+
 struct kvm;
 struct kvm_async_pf;
 struct kvm_device_ops;
@@ -19,13 +36,6 @@ struct kvm_memslots;
 
 enum kvm_mr_change;
 
-#include <linux/bits.h>
-#include <linux/mutex.h>
-#include <linux/types.h>
-#include <linux/spinlock_types.h>
-
-#include <asm/kvm_types.h>
-
 /*
  * Address types:
  *
@@ -116,5 +126,6 @@ struct kvm_vcpu_stat_generic {
 };
 
 #define KVM_STATS_NAME_SIZE	48
+#endif /* !__ASSEMBLER__ */
 
 #endif /* __KVM_TYPES_H__ */
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 6b1133a6617f..a7794ffdb976 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -525,7 +525,7 @@ bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin)
 
 	return false;
 }
-EXPORT_SYMBOL_GPL(kvm_irq_has_notifier);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_irq_has_notifier);
 
 void kvm_notify_acked_gsi(struct kvm *kvm, int gsi)
 {
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 08a6bc7d25b6..4c26000f4d36 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -702,7 +702,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	fput(file);
 	return r;
 }
-EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
 long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
@@ -784,5 +784,5 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 	fput(file);
 	return ret && !i ? ret : i;
 }
-EXPORT_SYMBOL_GPL(kvm_gmem_populate);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_populate);
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fee108988028..83a1b4dbbbd8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -77,22 +77,22 @@ MODULE_LICENSE("GPL");
 /* Architectures should define their poll value according to the halt latency */
 unsigned int halt_poll_ns = KVM_HALT_POLL_NS_DEFAULT;
 module_param(halt_poll_ns, uint, 0644);
-EXPORT_SYMBOL_GPL(halt_poll_ns);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(halt_poll_ns);
 
 /* Default doubles per-vcpu halt_poll_ns. */
 unsigned int halt_poll_ns_grow = 2;
 module_param(halt_poll_ns_grow, uint, 0644);
-EXPORT_SYMBOL_GPL(halt_poll_ns_grow);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(halt_poll_ns_grow);
 
 /* The start value to grow halt_poll_ns from */
 unsigned int halt_poll_ns_grow_start = 10000; /* 10us */
 module_param(halt_poll_ns_grow_start, uint, 0644);
-EXPORT_SYMBOL_GPL(halt_poll_ns_grow_start);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(halt_poll_ns_grow_start);
 
 /* Default halves per-vcpu halt_poll_ns. */
 unsigned int halt_poll_ns_shrink = 2;
 module_param(halt_poll_ns_shrink, uint, 0644);
-EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(halt_poll_ns_shrink);
 
 /*
  * Allow direct access (from KVM or the CPU) without MMU notifier protection
@@ -170,7 +170,7 @@ void vcpu_load(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_load(vcpu, cpu);
 	put_cpu();
 }
-EXPORT_SYMBOL_GPL(vcpu_load);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(vcpu_load);
 
 void vcpu_put(struct kvm_vcpu *vcpu)
 {
@@ -180,7 +180,7 @@ void vcpu_put(struct kvm_vcpu *vcpu)
 	__this_cpu_write(kvm_running_vcpu, NULL);
 	preempt_enable();
 }
-EXPORT_SYMBOL_GPL(vcpu_put);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(vcpu_put);
 
 /* TODO: merge with kvm_arch_vcpu_should_kick */
 static bool kvm_request_needs_ipi(struct kvm_vcpu *vcpu, unsigned req)
@@ -288,7 +288,7 @@ bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
 
 	return called;
 }
-EXPORT_SYMBOL_GPL(kvm_make_all_cpus_request);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_make_all_cpus_request);
 
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
@@ -309,7 +309,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 	    || kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
 		++kvm->stat.generic.remote_tlb_flush;
 }
-EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_flush_remote_tlbs);
 
 void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages)
 {
@@ -499,7 +499,7 @@ void kvm_destroy_vcpus(struct kvm *kvm)
 
 	atomic_set(&kvm->online_vcpus, 0);
 }
-EXPORT_SYMBOL_GPL(kvm_destroy_vcpus);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_destroy_vcpus);
 
 #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
 static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
@@ -1356,7 +1356,7 @@ void kvm_put_kvm_no_destroy(struct kvm *kvm)
 {
 	WARN_ON(refcount_dec_and_test(&kvm->users_count));
 }
-EXPORT_SYMBOL_GPL(kvm_put_kvm_no_destroy);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_put_kvm_no_destroy);
 
 static int kvm_vm_release(struct inode *inode, struct file *filp)
 {
@@ -1388,7 +1388,7 @@ int kvm_trylock_all_vcpus(struct kvm *kvm)
 	}
 	return -EINTR;
 }
-EXPORT_SYMBOL_GPL(kvm_trylock_all_vcpus);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_trylock_all_vcpus);
 
 int kvm_lock_all_vcpus(struct kvm *kvm)
 {
@@ -1413,7 +1413,7 @@ int kvm_lock_all_vcpus(struct kvm *kvm)
 	}
 	return r;
 }
-EXPORT_SYMBOL_GPL(kvm_lock_all_vcpus);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_lock_all_vcpus);
 
 void kvm_unlock_all_vcpus(struct kvm *kvm)
 {
@@ -1425,7 +1425,7 @@ void kvm_unlock_all_vcpus(struct kvm *kvm)
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		mutex_unlock(&vcpu->mutex);
 }
-EXPORT_SYMBOL_GPL(kvm_unlock_all_vcpus);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_unlock_all_vcpus);
 
 /*
  * Allocation size is twice as large as the actual dirty bitmap size.
@@ -2133,7 +2133,7 @@ int kvm_set_internal_memslot(struct kvm *kvm,
 
 	return kvm_set_memory_region(kvm, mem);
 }
-EXPORT_SYMBOL_GPL(kvm_set_internal_memslot);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_set_internal_memslot);
 
 static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 					  struct kvm_userspace_memory_region2 *mem)
@@ -2192,7 +2192,7 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
 		*is_dirty = 1;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_get_dirty_log);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_get_dirty_log);
 
 #else /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 /**
@@ -2627,7 +2627,7 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 {
 	return __gfn_to_memslot(kvm_memslots(kvm), gfn);
 }
-EXPORT_SYMBOL_GPL(gfn_to_memslot);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(gfn_to_memslot);
 
 struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
@@ -2661,7 +2661,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
 
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_gfn_to_memslot);
 
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {
@@ -2669,7 +2669,7 @@ bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 
 	return kvm_is_visible_memslot(memslot);
 }
-EXPORT_SYMBOL_GPL(kvm_is_visible_gfn);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_is_visible_gfn);
 
 bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
@@ -2677,7 +2677,7 @@ bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
 
 	return kvm_is_visible_memslot(memslot);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_is_visible_gfn);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_is_visible_gfn);
 
 unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
@@ -2734,19 +2734,19 @@ unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot,
 {
 	return gfn_to_hva_many(slot, gfn, NULL);
 }
-EXPORT_SYMBOL_GPL(gfn_to_hva_memslot);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(gfn_to_hva_memslot);
 
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
 {
 	return gfn_to_hva_many(gfn_to_memslot(kvm, gfn), gfn, NULL);
 }
-EXPORT_SYMBOL_GPL(gfn_to_hva);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(gfn_to_hva);
 
 unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	return gfn_to_hva_many(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn, NULL);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_hva);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_gfn_to_hva);
 
 /*
  * Return the hva of a @gfn and the R/W attribute if possible.
@@ -2810,7 +2810,7 @@ void kvm_release_page_clean(struct page *page)
 	kvm_set_page_accessed(page);
 	put_page(page);
 }
-EXPORT_SYMBOL_GPL(kvm_release_page_clean);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_release_page_clean);
 
 void kvm_release_page_dirty(struct page *page)
 {
@@ -2820,7 +2820,7 @@ void kvm_release_page_dirty(struct page *page)
 	kvm_set_page_dirty(page);
 	kvm_release_page_clean(page);
 }
-EXPORT_SYMBOL_GPL(kvm_release_page_dirty);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_release_page_dirty);
 
 static kvm_pfn_t kvm_resolve_pfn(struct kvm_follow_pfn *kfp, struct page *page,
 				 struct follow_pfnmap_args *map, bool writable)
@@ -3064,7 +3064,7 @@ kvm_pfn_t __kvm_faultin_pfn(const struct kvm_memory_slot *slot, gfn_t gfn,
 
 	return kvm_follow_pfn(&kfp);
 }
-EXPORT_SYMBOL_GPL(__kvm_faultin_pfn);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(__kvm_faultin_pfn);
 
 int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
 		       struct page **pages, int nr_pages)
@@ -3081,7 +3081,7 @@ int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
 
 	return get_user_pages_fast_only(addr, nr_pages, FOLL_WRITE, pages);
 }
-EXPORT_SYMBOL_GPL(kvm_prefetch_pages);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_prefetch_pages);
 
 /*
  * Don't use this API unless you are absolutely, positively certain that KVM
@@ -3103,7 +3103,7 @@ struct page *__gfn_to_page(struct kvm *kvm, gfn_t gfn, bool write)
 	(void)kvm_follow_pfn(&kfp);
 	return refcounted_page;
 }
-EXPORT_SYMBOL_GPL(__gfn_to_page);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(__gfn_to_page);
 
 int __kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map,
 		   bool writable)
@@ -3137,7 +3137,7 @@ int __kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map,
 
 	return map->hva ? 0 : -EFAULT;
 }
-EXPORT_SYMBOL_GPL(__kvm_vcpu_map);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(__kvm_vcpu_map);
 
 void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map)
 {
@@ -3165,7 +3165,7 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map)
 	map->page = NULL;
 	map->pinned_page = NULL;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_unmap);
 
 static int next_segment(unsigned long len, int offset)
 {
@@ -3201,7 +3201,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 
 	return __kvm_read_guest_page(slot, gfn, data, offset, len);
 }
-EXPORT_SYMBOL_GPL(kvm_read_guest_page);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_read_guest_page);
 
 int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
 			     int offset, int len)
@@ -3210,7 +3210,7 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
 
 	return __kvm_read_guest_page(slot, gfn, data, offset, len);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_read_guest_page);
 
 int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len)
 {
@@ -3230,7 +3230,7 @@ int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len)
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_read_guest);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_read_guest);
 
 int kvm_vcpu_read_guest(struct kvm_vcpu *vcpu, gpa_t gpa, void *data, unsigned long len)
 {
@@ -3250,7 +3250,7 @@ int kvm_vcpu_read_guest(struct kvm_vcpu *vcpu, gpa_t gpa, void *data, unsigned l
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_read_guest);
 
 static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
 			           void *data, int offset, unsigned long len)
@@ -3281,7 +3281,7 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 	return __kvm_read_guest_atomic(slot, gfn, data, offset, len);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_read_guest_atomic);
 
 /* Copy @len bytes from @data into guest memory at '(@gfn * PAGE_SIZE) + @offset' */
 static int __kvm_write_guest_page(struct kvm *kvm,
@@ -3311,7 +3311,7 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn,
 
 	return __kvm_write_guest_page(kvm, slot, gfn, data, offset, len);
 }
-EXPORT_SYMBOL_GPL(kvm_write_guest_page);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_write_guest_page);
 
 int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 			      const void *data, int offset, int len)
@@ -3320,7 +3320,7 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 	return __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_write_guest_page);
 
 int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
 		    unsigned long len)
@@ -3341,7 +3341,7 @@ int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_write_guest);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_write_guest);
 
 int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
 		         unsigned long len)
@@ -3362,7 +3362,7 @@ int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_write_guest);
 
 static int __kvm_gfn_to_hva_cache_init(struct kvm_memslots *slots,
 				       struct gfn_to_hva_cache *ghc,
@@ -3411,7 +3411,7 @@ int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	return __kvm_gfn_to_hva_cache_init(slots, ghc, gpa, len);
 }
-EXPORT_SYMBOL_GPL(kvm_gfn_to_hva_cache_init);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gfn_to_hva_cache_init);
 
 int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 				  void *data, unsigned int offset,
@@ -3442,14 +3442,14 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_write_guest_offset_cached);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_write_guest_offset_cached);
 
 int kvm_write_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			   void *data, unsigned long len)
 {
 	return kvm_write_guest_offset_cached(kvm, ghc, data, 0, len);
 }
-EXPORT_SYMBOL_GPL(kvm_write_guest_cached);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_write_guest_cached);
 
 int kvm_read_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 				 void *data, unsigned int offset,
@@ -3479,14 +3479,14 @@ int kvm_read_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_read_guest_offset_cached);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_read_guest_offset_cached);
 
 int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			  void *data, unsigned long len)
 {
 	return kvm_read_guest_offset_cached(kvm, ghc, data, 0, len);
 }
-EXPORT_SYMBOL_GPL(kvm_read_guest_cached);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_read_guest_cached);
 
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 {
@@ -3506,7 +3506,7 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_clear_guest);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_clear_guest);
 
 void mark_page_dirty_in_slot(struct kvm *kvm,
 			     const struct kvm_memory_slot *memslot,
@@ -3531,7 +3531,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 			set_bit_le(rel_gfn, memslot->dirty_bitmap);
 	}
 }
-EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(mark_page_dirty_in_slot);
 
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 {
@@ -3540,7 +3540,7 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 	memslot = gfn_to_memslot(kvm, gfn);
 	mark_page_dirty_in_slot(kvm, memslot, gfn);
 }
-EXPORT_SYMBOL_GPL(mark_page_dirty);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(mark_page_dirty);
 
 void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
@@ -3549,7 +3549,7 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
 	memslot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	mark_page_dirty_in_slot(vcpu->kvm, memslot, gfn);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_mark_page_dirty);
 
 void kvm_sigset_activate(struct kvm_vcpu *vcpu)
 {
@@ -3786,7 +3786,7 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 
 	trace_kvm_vcpu_wakeup(halt_ns, waited, vcpu_valid_wakeup(vcpu));
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_halt);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_halt);
 
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
 {
@@ -3798,7 +3798,7 @@ bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
 
 	return false;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_wake_up);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_wake_up);
 
 #ifndef CONFIG_S390
 /*
@@ -3850,7 +3850,7 @@ void __kvm_vcpu_kick(struct kvm_vcpu *vcpu, bool wait)
 out:
 	put_cpu();
 }
-EXPORT_SYMBOL_GPL(__kvm_vcpu_kick);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(__kvm_vcpu_kick);
 #endif /* !CONFIG_S390 */
 
 int kvm_vcpu_yield_to(struct kvm_vcpu *target)
@@ -3873,7 +3873,7 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_yield_to);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_yield_to);
 
 /*
  * Helper that checks whether a VCPU is eligible for directed yield.
@@ -4028,7 +4028,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 	/* Ensure vcpu is not eligible during next spinloop */
 	kvm_vcpu_set_dy_eligible(me, false);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_on_spin);
 
 static bool kvm_page_in_dirty_ring(struct kvm *kvm, unsigned long pgoff)
 {
@@ -5010,7 +5010,7 @@ bool kvm_are_all_memslots_empty(struct kvm *kvm)
 
 	return true;
 }
-EXPORT_SYMBOL_GPL(kvm_are_all_memslots_empty);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_are_all_memslots_empty);
 
 static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 					   struct kvm_enable_cap *cap)
@@ -5465,7 +5465,7 @@ bool file_is_kvm(struct file *file)
 {
 	return file && file->f_op == &kvm_vm_fops;
 }
-EXPORT_SYMBOL_GPL(file_is_kvm);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(file_is_kvm);
 
 static int kvm_dev_ioctl_create_vm(unsigned long type)
 {
@@ -5560,10 +5560,10 @@ static struct miscdevice kvm_dev = {
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
 bool enable_virt_at_load = true;
 module_param(enable_virt_at_load, bool, 0444);
-EXPORT_SYMBOL_GPL(enable_virt_at_load);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(enable_virt_at_load);
 
 __visible bool kvm_rebooting;
-EXPORT_SYMBOL_GPL(kvm_rebooting);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_rebooting);
 
 static DEFINE_PER_CPU(bool, virtualization_enabled);
 static DEFINE_MUTEX(kvm_usage_lock);
@@ -5714,7 +5714,7 @@ int kvm_enable_virtualization(void)
 	--kvm_usage_count;
 	return r;
 }
-EXPORT_SYMBOL_GPL(kvm_enable_virtualization);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_enable_virtualization);
 
 void kvm_disable_virtualization(void)
 {
@@ -5727,7 +5727,7 @@ void kvm_disable_virtualization(void)
 	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
 	kvm_arch_disable_virtualization();
 }
-EXPORT_SYMBOL_GPL(kvm_disable_virtualization);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_disable_virtualization);
 
 static int kvm_init_virtualization(void)
 {
@@ -5864,7 +5864,7 @@ int kvm_io_bus_write(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 	r = __kvm_io_bus_write(vcpu, bus, &range, val);
 	return r < 0 ? r : 0;
 }
-EXPORT_SYMBOL_GPL(kvm_io_bus_write);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_io_bus_write);
 
 int kvm_io_bus_write_cookie(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx,
 			    gpa_t addr, int len, const void *val, long cookie)
@@ -5933,7 +5933,7 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 	r = __kvm_io_bus_read(vcpu, bus, &range, val);
 	return r < 0 ? r : 0;
 }
-EXPORT_SYMBOL_GPL(kvm_io_bus_read);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_io_bus_read);
 
 int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 			    int len, struct kvm_io_device *dev)
@@ -6051,7 +6051,7 @@ struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 
 	return iodev;
 }
-EXPORT_SYMBOL_GPL(kvm_io_bus_get_dev);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_io_bus_get_dev);
 
 static int kvm_debugfs_open(struct inode *inode, struct file *file,
 			   int (*get)(void *, u64 *), int (*set)(void *, u64),
@@ -6388,7 +6388,7 @@ struct kvm_vcpu *kvm_get_running_vcpu(void)
 
 	return vcpu;
 }
-EXPORT_SYMBOL_GPL(kvm_get_running_vcpu);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_get_running_vcpu);
 
 /**
  * kvm_get_running_vcpus - get the per-CPU array of currently running vcpus.
@@ -6523,7 +6523,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	kmem_cache_destroy(kvm_vcpu_cache);
 	return r;
 }
-EXPORT_SYMBOL_GPL(kvm_init);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_init);
 
 void kvm_exit(void)
 {
@@ -6546,4 +6546,4 @@ void kvm_exit(void)
 	kvm_async_pf_deinit();
 	kvm_irqfd_exit();
 }
-EXPORT_SYMBOL_GPL(kvm_exit);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_exit);
-- 
2.51.0.470.ga7dc726c21-goog


