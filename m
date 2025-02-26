Return-Path: <kvm+bounces-39386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F714A46BAF
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:02:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 397A6188CE98
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7BED280A59;
	Wed, 26 Feb 2025 19:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EUxoTvtB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA6D27FE7E
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599772; cv=none; b=rB9L9Q1Ioe8Ybvo1RwDY6Jnxdas5W8v5ze4EAO4SZUGKamlEzfUlL7wUQlIpdle5yURZHyuhzhgqdBnmZie8ZEAe31Bob2pgDpbV/MP2xAa4wMiEdiqVkwo1ZgfqSRihcEJkGQ4IR5L76Fw+Zr/0BRExtrfBTJTDMrog5AuJkVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599772; c=relaxed/simple;
	bh=x5UR3ZJZV1BTI4efw7+gLC37purtPC18f8t3fVVx3lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EhTdw0KRhmQr1OwdNqcfFoZC5GHA8wfraZhrAHoW+h+3BuOyl/tXIciFeUXkH/s1RuuagQ68QZEXw9vKGWRpbwVTj4HgEZCyP/Ib/IxExNg7IJbd/pp8lKnG3yDcpZxS4QNfWsW68ddoTIziwhraCwRrNVlc7hP9C4XpDi/Zl6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EUxoTvtB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2CL12CTCw2aUrAAWYDMowe+UqQvHYSWHA6008OECzMA=;
	b=EUxoTvtBOMVulfL3sCzsPMHYBa4C4pVXGaS2RS7jPl44KAZhHOJSLQnKXGMXIgaPi9CCgO
	6YYEnjUt2Kh22GzUCufWyK/yMguFROxg/QYkEzyE+dmAQ59RKXiFAmVwfdG7d39rC0IpLb
	bDLxFx4mblc5QM2FuQAMMIzhhPQh5r0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-384-N0vYDjylMLqE6aOmtGZ1LA-1; Wed,
 26 Feb 2025 14:56:04 -0500
X-MC-Unique: N0vYDjylMLqE6aOmtGZ1LA-1
X-Mimecast-MFC-AGG-ID: N0vYDjylMLqE6aOmtGZ1LA_1740599762
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E94B1905626;
	Wed, 26 Feb 2025 19:56:02 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C765119560AE;
	Wed, 26 Feb 2025 19:56:00 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 23/29] KVM: TDX: Finalize VM initialization
Date: Wed, 26 Feb 2025 14:55:23 -0500
Message-ID: <20250226195529.2314580-24-pbonzini@redhat.com>
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

Add a new VM-scoped KVM_MEMORY_ENCRYPT_OP IOCTL subcommand,
KVM_TDX_FINALIZE_VM, to perform TD Measurement Finalization.

Documentation for the API is added in another patch:
"Documentation/virt/kvm: Document on Trust Domain Extensions(TDX)"

For the purpose of attestation, a measurement must be made of the TDX VM
initial state. This is referred to as TD Measurement Finalization, and
uses SEAMCALL TDH.MR.FINALIZE, after which:
1. The VMM adding TD private pages with arbitrary content is no longer
   allowed
2. The TDX VM is runnable

Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-ID: <20240904030751.117579-21-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/vmx/tdx.c          | 78 +++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/tdx.h          |  3 ++
 3 files changed, 74 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index ee1b517351a3..89cc7a18ef45 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -933,6 +933,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_INIT_VM,
 	KVM_TDX_INIT_VCPU,
 	KVM_TDX_INIT_MEM_REGION,
+	KVM_TDX_FINALIZE_VM,
 	KVM_TDX_GET_CPUID,
 
 	KVM_TDX_CMD_NR_MAX,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 12f3433d062d..246f924ae6f6 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -557,6 +557,29 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+/*
+ * KVM_TDX_INIT_MEM_REGION calls kvm_gmem_populate() to map guest pages; the
+ * callback tdx_gmem_post_populate() then maps pages into private memory.
+ * through the a seamcall TDH.MEM.PAGE.ADD().  The SEAMCALL also requires the
+ * private EPT structures for the page to have been built before, which is
+ * done via kvm_tdp_map_page(). nr_premapped counts the number of pages that
+ * were added to the EPT structures but not added with TDH.MEM.PAGE.ADD().
+ * The counter has to be zero on KVM_TDX_FINALIZE_VM, to ensure that there
+ * are no half-initialized shared EPT pages.
+ */
+static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
+					  enum pg_level level, kvm_pfn_t pfn)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+
+	if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
+		return -EINVAL;
+
+	/* nr_premapped will be decreased when tdh_mem_page_add() is called. */
+	atomic64_inc(&kvm_tdx->nr_premapped);
+	return 0;
+}
+
 int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 			      enum pg_level level, kvm_pfn_t pfn)
 {
@@ -577,14 +600,15 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	 */
 	get_page(page);
 
+	/*
+	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
+	 * barrier in tdx_td_finalize().
+	 */
+	smp_rmb();
 	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
 		return tdx_mem_page_aug(kvm, gfn, level, page);
 
-	/*
-	 * TODO: KVM_TDX_INIT_MEM_REGION support to populate before finalize
-	 * comes here for the initial memory.
-	 */
-	return -EOPNOTSUPP;
+	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
 }
 
 static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
@@ -615,10 +639,12 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE &&
 		     err == (TDX_EPT_WALK_FAILED | TDX_OPERAND_ID_RCX))) {
 		/*
-		 * This page was mapped with KVM_MAP_MEMORY, but
-		 * KVM_TDX_INIT_MEM_REGION is not issued yet.
+		 * Page is mapped by KVM_TDX_INIT_MEM_REGION, but hasn't called
+		 * tdh_mem_page_add().
 		 */
-		if (!is_last_spte(entry, level) || !(entry & VMX_EPT_RWX_MASK)) {
+		if ((!is_last_spte(entry, level) || !(entry & VMX_EPT_RWX_MASK)) &&
+		    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
+			atomic64_dec(&kvm_tdx->nr_premapped);
 			tdx_unpin(kvm, page);
 			return 0;
 		}
@@ -1365,6 +1391,36 @@ void tdx_flush_tlb_all(struct kvm_vcpu *vcpu)
 	ept_sync_global();
 }
 
+static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+
+	guard(mutex)(&kvm->slots_lock);
+
+	if (!is_hkid_assigned(kvm_tdx) || kvm_tdx->state == TD_STATE_RUNNABLE)
+		return -EINVAL;
+	/*
+	 * Pages are pending for KVM_TDX_INIT_MEM_REGION to issue
+	 * TDH.MEM.PAGE.ADD().
+	 */
+	if (atomic64_read(&kvm_tdx->nr_premapped))
+		return -EINVAL;
+
+	cmd->hw_error = tdh_mr_finalize(&kvm_tdx->td);
+	if (tdx_operand_busy(cmd->hw_error))
+		return -EBUSY;
+	if (KVM_BUG_ON(cmd->hw_error, kvm)) {
+		pr_tdx_error(TDH_MR_FINALIZE, cmd->hw_error);
+		return -EIO;
+	}
+
+	kvm_tdx->state = TD_STATE_RUNNABLE;
+	/* TD_STATE_RUNNABLE must be set before 'pre_fault_allowed' */
+	smp_wmb();
+	kvm->arch.pre_fault_allowed = true;
+	return 0;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -1389,6 +1445,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_TDX_INIT_VM:
 		r = tdx_td_init(kvm, &tdx_cmd);
 		break;
+	case KVM_TDX_FINALIZE_VM:
+		r = tdx_td_finalize(kvm, &tdx_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -1656,6 +1715,9 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 		goto out;
 	}
 
+	if (!KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm))
+		atomic64_dec(&kvm_tdx->nr_premapped);
+
 	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
 		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
 			err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry,
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 77d693dfcb08..b71f8e9643e4 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -31,6 +31,9 @@ struct kvm_tdx {
 	u64 tsc_offset;
 
 	struct tdx_td td;
+
+	/* For KVM_TDX_INIT_MEM_REGION. */
+	atomic64_t nr_premapped;
 };
 
 /* TDX module vCPU states */
-- 
2.43.5



