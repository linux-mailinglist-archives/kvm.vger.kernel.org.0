Return-Path: <kvm+bounces-39385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE64CA46BAC
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:01:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8C5216CF0E
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:01:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9BB6280A28;
	Wed, 26 Feb 2025 19:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bN6B+ij8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E05127290D
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599770; cv=none; b=IqxvsLntPU356hqG9JQCV9JY2XC0ZH93Zwt04S0z2P61UWou1xozVeQN5wWeqxiS5y2Dy2VmpfuP3e8hkv62Z/Fut4EC3SBwSBMuXHF/gY/uYElYOggRgVKiDnv72jAsMOxHziNT/wmqcwu8ZbNSxRdXyqA1H1i94UL+i+Zghow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599770; c=relaxed/simple;
	bh=hi09F/q6dQPU3N15Qmxhs0cAa0R2AlpWYrnw+O/UxG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IriqCNXDGpF5AtSOCyZJYE2mk0nIBsdw8NaSxkeF3haMhtGnqzqO5XCAoI6fXSUyYcV07Wr3nL5lKDTL8GpHmjqgrnWmjK3zGu0baYV8n8UjHoCXMHGqmcC0HCyV7ONMznBMHAVeCSd0bgqMB6cXhXoGoZcJVX/sDwYRavRapbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bN6B+ij8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4zHNaGhOLIKF1RINghd//1N9mcPIA2fRtWEmdegcDMo=;
	b=bN6B+ij8QZL50Q14KL3U56Akc75boYyNVHZd46SJvknhIyfC2ZPtJYQ2SXJ4i8qnsalqOL
	JOEB9fGX2Nu3PNUsu2Qapnn/xkGsVWIVrzOHHWZWbNJ+nvE3UP5d8MmGqmpBSpED9manu2
	6rGrnpGsExjX56HowYmIS16H4lGC/rI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-487-SAvYt6WpNni28lDZfMDuYg-1; Wed,
 26 Feb 2025 14:56:02 -0500
X-MC-Unique: SAvYt6WpNni28lDZfMDuYg-1
X-Mimecast-MFC-AGG-ID: SAvYt6WpNni28lDZfMDuYg_1740599760
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95A5B18EAA9A;
	Wed, 26 Feb 2025 19:56:00 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9985C19560AE;
	Wed, 26 Feb 2025 19:55:59 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH 22/29] KVM: TDX: Add an ioctl to create initial guest memory
Date: Wed, 26 Feb 2025 14:55:22 -0500
Message-ID: <20250226195529.2314580-23-pbonzini@redhat.com>
In-Reply-To: <20250226195529.2314580-1-pbonzini@redhat.com>
References: <20250226195529.2314580-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a new ioctl for the user space VMM to initialize guest memory with the
specified memory contents.

Because TDX protects the guest's memory, the creation of the initial guest
memory requires a dedicated TDX module API, TDH.MEM.PAGE.ADD(), instead of
directly copying the memory contents into the guest's memory in the case of
the default VM type.

Define a new subcommand, KVM_TDX_INIT_MEM_REGION, of vCPU-scoped
KVM_MEMORY_ENCRYPT_OP.  Check if the GFN is already pre-allocated, assign
the guest page in Secure-EPT, copy the initial memory contents into the
guest memory, and encrypt the guest memory.  Optionally, extend the memory
measurement of the TDX guest.

The ioctl uses the vCPU file descriptor because of the TDX module's
requirement that the memory is added to the S-EPT (via TDH.MEM.SEPT.ADD)
prior to initialization (TDH.MEM.PAGE.ADD).  Accessing the MMU in turn
requires a vCPU file descriptor, just like for KVM_PRE_FAULT_MEMORY.  In
fact, the post-populate callback is able to reuse the same logic used by
KVM_PRE_FAULT_MEMORY, so that userspace can do everything with a single
ioctl.

Note that this is the only way to invoke TDH.MEM.SEPT.ADD before the TD
in finalized, as userspace cannot use KVM_PRE_FAULT_MEMORY at that
point.  This ensures that there cannot be pages in the S-EPT awaiting
TDH.MEM.PAGE.ADD, which would be treated incorrectly as spurious by
tdp_mmu_map_handle_target_level() (KVM would see the SPTE as PRESENT,
but the corresponding S-EPT entry will be !PRESENT).

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 - KVM_BUG_ON() for kvm_tdx->nr_premapped (Paolo)
 - Use tdx_operand_busy()
 - Merge first patch in SEPT SEAMCALL retry series in to this base
   (Paolo)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/uapi/asm/kvm.h |   9 ++
 arch/x86/kvm/vmx/tdx.c          | 144 ++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c             |   1 +
 3 files changed, 154 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index cd55484e3f0c..ee1b517351a3 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -932,6 +932,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
 	KVM_TDX_INIT_VCPU,
+	KVM_TDX_INIT_MEM_REGION,
 	KVM_TDX_GET_CPUID,
 
 	KVM_TDX_CMD_NR_MAX,
@@ -987,4 +988,12 @@ struct kvm_tdx_init_vm {
 	struct kvm_cpuid2 cpuid;
 };
 
+#define KVM_TDX_MEASURE_MEMORY_REGION   _BITULL(0)
+
+struct kvm_tdx_init_mem_region {
+	__u64 source_addr;
+	__u64 gpa;
+	__u64 nr_pages;
+};
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 989db4887963..12f3433d062d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/cleanup.h>
 #include <linux/cpu.h>
 #include <asm/cpufeature.h>
 #include <linux/misc_cgroup.h>
@@ -10,6 +11,7 @@
 #include "tdx.h"
 #include "vmx.h"
 #include "mmu/spte.h"
+#include "common.h"
 
 #pragma GCC poison to_vmx
 
@@ -1600,6 +1602,145 @@ static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
 	return 0;
 }
 
+struct tdx_gmem_post_populate_arg {
+	struct kvm_vcpu *vcpu;
+	__u32 flags;
+};
+
+static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+				  void __user *src, int order, void *_arg)
+{
+	u64 error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS;
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct tdx_gmem_post_populate_arg *arg = _arg;
+	struct kvm_vcpu *vcpu = arg->vcpu;
+	gpa_t gpa = gfn_to_gpa(gfn);
+	u8 level = PG_LEVEL_4K;
+	struct page *src_page;
+	int ret, i;
+	u64 err, entry, level_state;
+
+	/*
+	 * Get the source page if it has been faulted in. Return failure if the
+	 * source page has been swapped out or unmapped in primary memory.
+	 */
+	ret = get_user_pages_fast((unsigned long)src, 1, 0, &src_page);
+	if (ret < 0)
+		return ret;
+	if (ret != 1)
+		return -ENOMEM;
+
+	ret = kvm_tdp_map_page(vcpu, gpa, error_code, &level);
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * The private mem cannot be zapped after kvm_tdp_map_page()
+	 * because all paths are covered by slots_lock and the
+	 * filemap invalidate lock.  Check that they are indeed enough.
+	 */
+	if (IS_ENABLED(CONFIG_KVM_PROVE_MMU)) {
+		scoped_guard(read_lock, &kvm->mmu_lock) {
+			if (KVM_BUG_ON(!kvm_tdp_mmu_gpa_is_mapped(vcpu, gpa), kvm)) {
+				ret = -EIO;
+				goto out;
+			}
+		}
+	}
+
+	ret = 0;
+	err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn), src_page,
+			       &entry, &level_state);
+	if (err) {
+		ret = unlikely(tdx_operand_busy(err)) ? -EBUSY : -EIO;
+		goto out;
+	}
+
+	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
+		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
+			err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry,
+					    &level_state);
+			if (err) {
+				ret = -EIO;
+				break;
+			}
+		}
+	}
+
+out:
+	put_page(src_page);
+	return ret;
+}
+
+static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct kvm_tdx_init_mem_region region;
+	struct tdx_gmem_post_populate_arg arg;
+	long gmem_ret;
+	int ret;
+
+	if (tdx->state != VCPU_TD_STATE_INITIALIZED)
+		return -EINVAL;
+
+	guard(mutex)(&kvm->slots_lock);
+
+	/* Once TD is finalized, the initial guest memory is fixed. */
+	if (kvm_tdx->state == TD_STATE_RUNNABLE)
+		return -EINVAL;
+
+	if (cmd->flags & ~KVM_TDX_MEASURE_MEMORY_REGION)
+		return -EINVAL;
+
+	if (copy_from_user(&region, u64_to_user_ptr(cmd->data), sizeof(region)))
+		return -EFAULT;
+
+	if (!PAGE_ALIGNED(region.source_addr) || !PAGE_ALIGNED(region.gpa) ||
+	    !region.nr_pages ||
+	    region.gpa + (region.nr_pages << PAGE_SHIFT) <= region.gpa ||
+	    !vt_is_tdx_private_gpa(kvm, region.gpa) ||
+	    !vt_is_tdx_private_gpa(kvm, region.gpa + (region.nr_pages << PAGE_SHIFT) - 1))
+		return -EINVAL;
+
+	kvm_mmu_reload(vcpu);
+	ret = 0;
+	while (region.nr_pages) {
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
+
+		arg = (struct tdx_gmem_post_populate_arg) {
+			.vcpu = vcpu,
+			.flags = cmd->flags,
+		};
+		gmem_ret = kvm_gmem_populate(kvm, gpa_to_gfn(region.gpa),
+					     u64_to_user_ptr(region.source_addr),
+					     1, tdx_gmem_post_populate, &arg);
+		if (gmem_ret < 0) {
+			ret = gmem_ret;
+			break;
+		}
+
+		if (gmem_ret != 1) {
+			ret = -EIO;
+			break;
+		}
+
+		region.source_addr += PAGE_SIZE;
+		region.gpa += PAGE_SIZE;
+		region.nr_pages--;
+
+		cond_resched();
+	}
+
+	if (copy_to_user(u64_to_user_ptr(cmd->data), &region, sizeof(region)))
+		ret = -EFAULT;
+	return ret;
+}
+
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
@@ -1619,6 +1760,9 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	case KVM_TDX_INIT_VCPU:
 		ret = tdx_vcpu_init(vcpu, &cmd);
 		break;
+	case KVM_TDX_INIT_MEM_REGION:
+		ret = tdx_vcpu_init_mem_region(vcpu, &cmd);
+		break;
 	case KVM_TDX_GET_CPUID:
 		ret = tdx_vcpu_get_cpuid(vcpu, &cmd);
 		break;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 622b5a99078a..c88acfa154e6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2581,6 +2581,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
 
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
 
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {
-- 
2.43.5



