Return-Path: <kvm+bounces-39391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 158C3A46BB8
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:03:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07F973ABDB8
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:03:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE63D25FA5B;
	Wed, 26 Feb 2025 19:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S6WW3pl6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383BE25BCEE
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599778; cv=none; b=rLEh2WBZlg20Plm+4nxyohOBbkUw+wgEl5CfApznZn+8IHkfWTiqRAY1sODgUWOu+0fQd3d4S0Se5U02jWijxk96bU0fVEi9MbLQIBVWNVOtyiYpmwLCRtssdV1m93C4yzneCYJF95v22Absq9FAFof8lamzhk8m/bknXqGFIDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599778; c=relaxed/simple;
	bh=16Zehdb4AgOjq9bNHlth8krJArW6jp6YJepC5NpyXfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IIaEKcIv4LTjT2cz/cRMXcAMm45IkD6eKk1zso56PMjQdRFcxoy3kAVaITDYOfy1sJaYydRahXfJ/6XfTpJ/rjHJwti4lmOduxXtHpO4fysHWa6ckeImgf8haKbbjWPQ0K/kwir+q4hzWnILNp9Lm0TvvjJJVIItTx0FPeFAwNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S6WW3pl6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SOMXc0XGb9i9NVESNvirv6McCEKwkARDJwtJyCjzRPc=;
	b=S6WW3pl6OJxSAvLQLD5HFGokbo7YoKhHAGyqt4Rew4eAeoXbW9hcX2uEixzAy2s/HDGJRR
	FjExmPiphhZaRxqDrs0gpmyBGZZfbef4YjSRmHJsTj2WHXg6OQRXwIQVo5pFjdCf/OTFPj
	iOUoqo98jK1OZFxgjLkKYDU73D7Ii2A=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-151-FsHr-p4EMC-5-cbQlFrsMw-1; Wed,
 26 Feb 2025 14:56:11 -0500
X-MC-Unique: FsHr-p4EMC-5-cbQlFrsMw-1
X-Mimecast-MFC-AGG-ID: FsHr-p4EMC-5-cbQlFrsMw_1740599770
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3D80E18009AC;
	Wed, 26 Feb 2025 19:56:07 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C15171955F0F;
	Wed, 26 Feb 2025 19:56:05 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	ANAND NARSHINHA PATIL <Anand.N.Patil@ibm.com>,
	Pedro Principeza <pedro.principeza@canonical.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH 27/29] KVM: x86: Make cpu_dirty_log_size a per-VM value
Date: Wed, 26 Feb 2025 14:55:27 -0500
Message-ID: <20250226195529.2314580-28-pbonzini@redhat.com>
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

From: Yan Zhao <yan.y.zhao@intel.com>

Make cpu_dirty_log_size (CPU's dirty log buffer size) a per-VM value and
set the per-VM cpu_dirty_log_size only for normal VMs when PML is enabled.
Do not set it for TDs.

Until now, cpu_dirty_log_size was a system-wide value that is used for
all VMs and is set to the PML buffer size when PML was enabled in VMX.
However, PML is not currently supported for TDs, though PML remains
available for normal VMs as long as the feature is supported by hardware
and enabled in VMX.

Making cpu_dirty_log_size a per-VM value allows it to be ther PML buffer
size for normal VMs and 0 for TDs. This allows functions like
kvm_arch_sync_dirty_log() and kvm_mmu_update_cpu_dirty_logging() to
determine if PML is supported, in order to kick off vCPUs or request them
to update CPU dirty logging status (turn on/off PML in VMCS).

This fixes an issue first reported in [1], where QEMU attaches an
emulated VGA device to a TD; note that KVM_MEM_LOG_DIRTY_PAGES
still works if the corresponding has no flag KVM_MEM_GUEST_MEMFD.
KVM then invokes kvm_mmu_update_cpu_dirty_logging() and from there
vmx_update_cpu_dirty_logging(), which incorrectly accesses a kvm_vmx
struct for a TDX VM.

Reported-by: ANAND NARSHINHA PATIL <Anand.N.Patil@ibm.com>
Reported-by: Pedro Principeza <pedro.principeza@canonical.com>
Reported-by: Farrah Chen <farrah.chen@intel.com>
Closes: https://github.com/canonical/tdx/issues/202
Link: https://github.com/canonical/tdx/issues/202 [1]
Suggested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 12 +++++++-----
 arch/x86/kvm/mmu/mmu.c          |  4 ++--
 arch/x86/kvm/mmu/mmu_internal.h |  2 +-
 arch/x86/kvm/vmx/main.c         |  1 -
 arch/x86/kvm/vmx/vmx.c          |  6 +++---
 arch/x86/kvm/x86.c              |  6 +++---
 6 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 04f6cc48167a..c89130fda012 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1560,6 +1560,13 @@ struct kvm_arch {
 	struct kvm_mmu_memory_cache split_desc_cache;
 
 	gfn_t gfn_direct_bits;
+
+	/*
+	 * Size of the CPU's dirty log buffer, i.e. VMX's PML buffer. A Zero
+	 * value indicates CPU dirty logging is unsupported or disabled in
+	 * current VM.
+	 */
+	int cpu_dirty_log_size;
 };
 
 struct kvm_vm_stat {
@@ -1813,11 +1820,6 @@ struct kvm_x86_ops {
 			       struct x86_exception *exception);
 	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
 
-	/*
-	 * Size of the CPU's dirty log buffer, i.e. VMX's PML buffer.  A zero
-	 * value indicates CPU dirty logging is unsupported or disabled.
-	 */
-	int cpu_dirty_log_size;
 	void (*update_cpu_dirty_logging)(struct kvm_vcpu *vcpu);
 
 	const struct kvm_x86_nested_ops *nested_ops;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3caeaebda637..e6eb3a262f8d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1305,7 +1305,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	 * enabled but it chooses between clearing the Dirty bit and Writeable
 	 * bit based on the context.
 	 */
-	if (kvm_x86_ops.cpu_dirty_log_size)
+	if (kvm->arch.cpu_dirty_log_size)
 		kvm_mmu_clear_dirty_pt_masked(kvm, slot, gfn_offset, mask);
 	else
 		kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
@@ -1313,7 +1313,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 
 int kvm_cpu_dirty_log_size(struct kvm *kvm)
 {
-	return kvm_x86_ops.cpu_dirty_log_size;
+	return kvm->arch.cpu_dirty_log_size;
 }
 
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 86d6d4f82cf4..db8f33e4de62 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -198,7 +198,7 @@ static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm *kvm,
 	 * being enabled is mandatory as the bits used to denote WP-only SPTEs
 	 * are reserved for PAE paging (32-bit KVM).
 	 */
-	return kvm_x86_ops.cpu_dirty_log_size && sp->role.guest_mode;
+	return kvm->arch.cpu_dirty_log_size && sp->role.guest_mode;
 }
 
 static inline gfn_t gfn_round_for_level(gfn_t gfn, int level)
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index abb0fc723a0b..ba3a23747bb1 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -322,7 +322,6 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
 
-	.cpu_dirty_log_size = PML_LOG_NR_ENTRIES,
 	.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
 
 	.nested_ops = &vmx_nested_ops,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 18150a38fe09..b71125a1b5cf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7653,6 +7653,9 @@ int vmx_vm_init(struct kvm *kvm)
 			break;
 		}
 	}
+
+	if (enable_pml)
+		kvm->arch.cpu_dirty_log_size = PML_LOG_NR_ENTRIES;
 	return 0;
 }
 
@@ -8506,9 +8509,6 @@ __init int vmx_hardware_setup(void)
 	if (!enable_ept || !enable_ept_ad_bits || !cpu_has_vmx_pml())
 		enable_pml = 0;
 
-	if (!enable_pml)
-		vt_x86_ops.cpu_dirty_log_size = 0;
-
 	if (!cpu_has_vmx_preemption_timer())
 		enable_preemption_timer = false;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e981e24820a0..edf47b8cb949 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6468,7 +6468,7 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
 
-	if (!kvm_x86_ops.cpu_dirty_log_size)
+	if (!kvm->arch.cpu_dirty_log_size)
 		return;
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
@@ -13055,7 +13055,7 @@ static void kvm_mmu_update_cpu_dirty_logging(struct kvm *kvm, bool enable)
 {
 	int nr_slots;
 
-	if (!kvm_x86_ops.cpu_dirty_log_size)
+	if (!kvm->arch.cpu_dirty_log_size)
 		return;
 
 	nr_slots = atomic_read(&kvm->nr_memslots_dirty_logging);
@@ -13127,7 +13127,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 		if (READ_ONCE(eager_page_split))
 			kvm_mmu_slot_try_split_huge_pages(kvm, new, PG_LEVEL_4K);
 
-		if (kvm_x86_ops.cpu_dirty_log_size) {
+		if (kvm->arch.cpu_dirty_log_size) {
 			kvm_mmu_slot_leaf_clear_dirty(kvm, new);
 			kvm_mmu_slot_remove_write_access(kvm, new, PG_LEVEL_2M);
 		} else {
-- 
2.43.5



