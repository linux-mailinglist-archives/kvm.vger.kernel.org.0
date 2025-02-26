Return-Path: <kvm+bounces-39380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49F8CA46BA1
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:00:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 537B53A8B05
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:00:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 239E4271291;
	Wed, 26 Feb 2025 19:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S0RUyDXr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE3326FA7E
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599763; cv=none; b=uNX95UGANq+alUAU5NVJ8hYDB2ITPoRbPF1u0RhvWelOwV7FdesD9bCx6dc5i/lf0mt4VRMhJADqm63+HQM2mJKwDbY870uHlw+8KmV5rAYjfAFKtlIlPjAAbY+Sz3ZIOXcsHpm4Hz3EB9Zq1QDx7qfT3TLfyHQW1+KuzkEXavQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599763; c=relaxed/simple;
	bh=D25sFxeZGi5p9CBLnDhCYUnUJcbX0dtzmIU6zuJOHvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a9csf62X2qgmz7trtdUGN4567J29pCppL2qKu6F771o1kIj0BtDnwj8461ZKd4AGTRAuiKVc69WwjZZPT0u21BYtZlRba1MuEW7m9REz4yyKx6YTEsH2Gqd5jT6BGYkqS2sunIFhqkjTdC+6Wavst5rtJHnGXLxlUxLUkwF/fSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S0RUyDXr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599760;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fLEXFVuq3gIjiUjBuOfpGLR38BH6KwnUmUi7QvTL+28=;
	b=S0RUyDXreKl6V230QllUhrcb0bSP71wToNl1G2wsXkojW0aD9j1daKhbP0fCzctai2ma10
	97tONP9Jfs4/WSI29wzDjujJZ+KPPE8AIymbRFej60/fMXLIM6eqNBLZbMoKcdCegNqzFT
	Jp3RKyrt4p/GUDa26yQjE1c4M8lT2wA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-283-Xbh67S9rMxiIK6wkCj1VUw-1; Wed,
 26 Feb 2025 14:55:56 -0500
X-MC-Unique: Xbh67S9rMxiIK6wkCj1VUw-1
X-Mimecast-MFC-AGG-ID: Xbh67S9rMxiIK6wkCj1VUw_1740599755
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 599F71801A18;
	Wed, 26 Feb 2025 19:55:55 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 65EF0300018D;
	Wed, 26 Feb 2025 19:55:54 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH 18/29] KVM: TDX: Implement hooks to propagate changes of TDP MMU mirror page table
Date: Wed, 26 Feb 2025 14:55:18 -0500
Message-ID: <20250226195529.2314580-19-pbonzini@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Isaku Yamahata <isaku.yamahata@intel.com>

Implement hooks in TDX to propagate changes of mirror page table to private
EPT, including changes for page table page adding/removing, guest page
adding/removing.

TDX invokes corresponding SEAMCALLs in the hooks.

- Hook link_external_spt
  propagates adding page table page into private EPT.

- Hook set_external_spte
  tdx_sept_set_private_spte() in this patch only handles adding of guest
  private page when TD is finalized.
  Later patches will handle the case of adding guest private pages before
  TD finalization.

- Hook free_external_spt
  It is invoked when page table page is removed in mirror page table, which
  currently must occur at TD tear down phase, after hkid is freed.

- Hook remove_external_spte
  It is invoked when guest private page is removed in mirror page table,
  which can occur when TD is active, e.g. during shared <-> private
  conversion and slot move/deletion.
  This hook is ensured to be triggered before hkid is freed, because
  gmem fd is released along with all private leaf mappings zapped before
  freeing hkid at VM destroy.

  TDX invokes below SEAMCALLs sequentially:
  1) TDH.MEM.RANGE.BLOCK (remove RWX bits from a private EPT entry),
  2) TDH.MEM.TRACK (increases TD epoch)
  3) TDH.MEM.PAGE.REMOVE (remove the private EPT entry and untrack the
     guest page).

  TDH.MEM.PAGE.REMOVE can't succeed without TDH.MEM.RANGE.BLOCK and
  TDH.MEM.TRACK being called successfully.
  SEAMCALL TDH.MEM.TRACK is called in function tdx_track() to enforce that
  TLB tracking will be performed by TDX module for private EPT.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 - Remove TDX_ERROR_SEPT_BUSY and Add tdx_operand_busy() helper (Binbin)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/main.c     |  14 ++-
 arch/x86/kvm/vmx/tdx.c      | 213 +++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx_arch.h |  23 ++++
 arch/x86/kvm/vmx/x86_ops.h  |  37 +++++++
 4 files changed, 284 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 0ea4bec0626e..0c94810b1f48 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -36,9 +36,21 @@ static __init int vt_hardware_setup(void)
 	 * is KVM may allocate couple of more bytes than needed for
 	 * each VM.
 	 */
-	if (enable_tdx)
+	if (enable_tdx) {
 		vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size,
 				sizeof(struct kvm_tdx));
+		/*
+		 * Note, TDX may fail to initialize in a later time in
+		 * vt_init(), in which case it is not necessary to setup
+		 * those callbacks.  But making them valid here even
+		 * when TDX fails to init later is fine because those
+		 * callbacks won't be called if the VM isn't TDX guest.
+		 */
+		vt_x86_ops.link_external_spt = tdx_sept_link_private_spt;
+		vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
+		vt_x86_ops.free_external_spt = tdx_sept_free_private_spt;
+		vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
+	}
 
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b80fc035e471..5f38c325dfa6 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -154,6 +154,12 @@ static DEFINE_MUTEX(tdx_lock);
 
 static atomic_t nr_configured_hkid;
 
+static bool tdx_operand_busy(u64 err)
+{
+	return (err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY;
+}
+
+
 static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
 {
 	tdx_guest_keyid_free(kvm_tdx->hkid);
@@ -520,6 +526,160 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
 }
 
+static void tdx_unpin(struct kvm *kvm, struct page *page)
+{
+	put_page(page);
+}
+
+static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
+			    enum pg_level level, struct page *page)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	u64 entry, level_state;
+	u64 err;
+
+	err = tdh_mem_page_aug(&kvm_tdx->td, gpa, tdx_level, page, &entry, &level_state);
+	if (unlikely(tdx_operand_busy(err))) {
+		tdx_unpin(kvm, page);
+		return -EBUSY;
+	}
+
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error_2(TDH_MEM_PAGE_AUG, err, entry, level_state);
+		tdx_unpin(kvm, page);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
+			      enum pg_level level, kvm_pfn_t pfn)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct page *page = pfn_to_page(pfn);
+
+	/* TODO: handle large pages. */
+	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
+		return -EINVAL;
+
+	/*
+	 * Because guest_memfd doesn't support page migration with
+	 * a_ops->migrate_folio (yet), no callback is triggered for KVM on page
+	 * migration.  Until guest_memfd supports page migration, prevent page
+	 * migration.
+	 * TODO: Once guest_memfd introduces callback on page migration,
+	 * implement it and remove get_page/put_page().
+	 */
+	get_page(page);
+
+	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
+		return tdx_mem_page_aug(kvm, gfn, level, page);
+
+	/*
+	 * TODO: KVM_TDX_INIT_MEM_REGION support to populate before finalize
+	 * comes here for the initial memory.
+	 */
+	return -EOPNOTSUPP;
+}
+
+static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
+				      enum pg_level level, struct page *page)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	u64 err, entry, level_state;
+
+	/* TODO: handle large pages. */
+	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
+		return -EINVAL;
+
+	if (KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm))
+		return -EINVAL;
+
+	do {
+		/*
+		 * When zapping private page, write lock is held. So no race
+		 * condition with other vcpu sept operation.  Race only with
+		 * TDH.VP.ENTER.
+		 */
+		err = tdh_mem_page_remove(&kvm_tdx->td, gpa, tdx_level, &entry,
+					  &level_state);
+	} while (unlikely(tdx_operand_busy(err)));
+
+	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE &&
+		     err == (TDX_EPT_WALK_FAILED | TDX_OPERAND_ID_RCX))) {
+		/*
+		 * This page was mapped with KVM_MAP_MEMORY, but
+		 * KVM_TDX_INIT_MEM_REGION is not issued yet.
+		 */
+		if (!is_last_spte(entry, level) || !(entry & VMX_EPT_RWX_MASK)) {
+			tdx_unpin(kvm, page);
+			return 0;
+		}
+	}
+
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error_2(TDH_MEM_PAGE_REMOVE, err, entry, level_state);
+		return -EIO;
+	}
+
+	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
+
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
+		return -EIO;
+	}
+	tdx_clear_page(page);
+	tdx_unpin(kvm, page);
+	return 0;
+}
+
+int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
+			      enum pg_level level, void *private_spt)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	struct page *page = virt_to_page(private_spt);
+	u64 err, entry, level_state;
+
+	err = tdh_mem_sept_add(&to_kvm_tdx(kvm)->td, gpa, tdx_level, page, &entry,
+			       &level_state);
+	if (unlikely(tdx_operand_busy(err)))
+		return -EBUSY;
+
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error_2(TDH_MEM_SEPT_ADD, err, entry, level_state);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
+				     enum pg_level level)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
+	u64 err, entry, level_state;
+
+	/* For now large page isn't supported yet. */
+	WARN_ON_ONCE(level != PG_LEVEL_4K);
+
+	err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
+	if (unlikely(tdx_operand_busy(err)))
+		return -EBUSY;
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error_2(TDH_MEM_RANGE_BLOCK, err, entry, level_state);
+		return -EIO;
+	}
+	return 0;
+}
+
 /*
  * Ensure shared and private EPTs to be flushed on all vCPUs.
  * tdh_mem_track() is the only caller that increases TD epoch. An increase in
@@ -544,7 +704,7 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
  * occurs certainly after TD epoch increment and before the next
  * tdh_mem_track().
  */
-static void __always_unused tdx_track(struct kvm *kvm)
+static void tdx_track(struct kvm *kvm)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	u64 err;
@@ -557,7 +717,7 @@ static void __always_unused tdx_track(struct kvm *kvm)
 
 	do {
 		err = tdh_mem_track(&kvm_tdx->td);
-	} while (unlikely((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY));
+	} while (unlikely(tdx_operand_busy(err)));
 
 	if (KVM_BUG_ON(err, kvm))
 		pr_tdx_error(TDH_MEM_TRACK, err);
@@ -565,6 +725,55 @@ static void __always_unused tdx_track(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);
 }
 
+int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
+			      enum pg_level level, void *private_spt)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+
+	/*
+	 * free_external_spt() is only called after hkid is freed when TD is
+	 * tearing down.
+	 * KVM doesn't (yet) zap page table pages in mirror page table while
+	 * TD is active, though guest pages mapped in mirror page table could be
+	 * zapped during TD is active, e.g. for shared <-> private conversion
+	 * and slot move/deletion.
+	 */
+	if (KVM_BUG_ON(is_hkid_assigned(kvm_tdx), kvm))
+		return -EINVAL;
+
+	/*
+	 * The HKID assigned to this TD was already freed and cache was
+	 * already flushed. We don't have to flush again.
+	 */
+	return tdx_reclaim_page(virt_to_page(private_spt));
+}
+
+int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
+				 enum pg_level level, kvm_pfn_t pfn)
+{
+	int ret;
+
+	/*
+	 * HKID is released after all private pages have been removed, and set
+	 * before any might be populated. Warn if zapping is attempted when
+	 * there can't be anything populated in the private EPT.
+	 */
+	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
+		return -EINVAL;
+
+	ret = tdx_sept_zap_private_spte(kvm, gfn, level);
+	if (ret)
+		return ret;
+
+	/*
+	 * TDX requires TLB tracking before dropping private page.  Do
+	 * it here, although it is also done later.
+	 */
+	tdx_track(kvm);
+
+	return tdx_sept_drop_private_spte(kvm, gfn, level, pfn_to_page(pfn));
+}
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index b6fe458a4224..a8071409498f 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -120,6 +120,29 @@ struct td_params {
 #define TDX_MIN_TSC_FREQUENCY_KHZ		(100 * 1000)
 #define TDX_MAX_TSC_FREQUENCY_KHZ		(10 * 1000 * 1000)
 
+/* Additional Secure EPT entry information */
+#define TDX_SEPT_LEVEL_MASK		GENMASK_ULL(2, 0)
+#define TDX_SEPT_STATE_MASK		GENMASK_ULL(15, 8)
+#define TDX_SEPT_STATE_SHIFT		8
+
+enum tdx_sept_entry_state {
+	TDX_SEPT_FREE = 0,
+	TDX_SEPT_BLOCKED = 1,
+	TDX_SEPT_PENDING = 2,
+	TDX_SEPT_PENDING_BLOCKED = 3,
+	TDX_SEPT_PRESENT = 4,
+};
+
+static inline u8 tdx_get_sept_level(u64 sept_entry_info)
+{
+	return sept_entry_info & TDX_SEPT_LEVEL_MASK;
+}
+
+static inline u8 tdx_get_sept_state(u64 sept_entry_info)
+{
+	return (sept_entry_info & TDX_SEPT_STATE_MASK) >> TDX_SEPT_STATE_SHIFT;
+}
+
 #define MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM	BIT_ULL(20)
 
 /*
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 584db5fa8dab..6344548d6a7a 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -132,6 +132,15 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
+int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
+			      enum pg_level level, void *private_spt);
+int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
+			      enum pg_level level, void *private_spt);
+int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
+			      enum pg_level level, kvm_pfn_t pfn);
+int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
+				 enum pg_level level, kvm_pfn_t pfn);
+
 void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
@@ -146,6 +155,34 @@ static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
+static inline int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
+					    enum pg_level level,
+					    void *private_spt)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
+					    enum pg_level level,
+					    void *private_spt)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
+					    enum pg_level level,
+					    kvm_pfn_t pfn)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
+					       enum pg_level level,
+					       kvm_pfn_t pfn)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline void tdx_flush_tlb_current(struct kvm_vcpu *vcpu) {}
 static inline void tdx_flush_tlb_all(struct kvm_vcpu *vcpu) {}
 static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
-- 
2.43.5



