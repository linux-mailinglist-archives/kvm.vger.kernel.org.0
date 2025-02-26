Return-Path: <kvm+bounces-39390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B4D7A46BB7
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:03:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 203F5188D036
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B02525FA41;
	Wed, 26 Feb 2025 19:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HOYJgp8n"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6020D281379
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599777; cv=none; b=FkUF3OMRJxKj7ONidsDE4f9YVQyJjAuMt/IoFpNdtSMqHmiigMLcY3xxSa0tAvGCYVObwJ9ioyYgBzM/H+1bFJfuCRsLcR9+gY1vtwqxLhvtW3yJlY0wYjQ1ilgSl0skL2t3oINlTQV9ROJ3z6hpRsYD6U5MozaY30HCl7cmcgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599777; c=relaxed/simple;
	bh=NETAek9P6jFoRao+0v3DspO+//m8Dy5rDDzZs9yl4fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jWIaSzFAkdU/7u4zy4TfPcPPLcr19+F4olaclQ8muEPdPrjxHz6LdCUNVgW6Evbc0Dg61NrFigk4xd0mfvoDGZ8OoDrWqEsovSY0EHSbSf2IAHgBfrARTHk5mOe08qCdNL46uxQwZi192tD+gtJtH+TUyB2U6HKAHLIylnUECFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HOYJgp8n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9x3o+9ZxYY1IDIcV6p0SSKe8rNG8+39lVVVMoUGc4IQ=;
	b=HOYJgp8nFV9soylr8EiBERIiOiWQ/kADhzDTmF/tEZOf9dvZYXxNHKK6bpUsf6Yt4wSzsC
	+YdLrWXdsi8Byti8MWjUpH9ge9Q3uhybuZneuu7wEniTriqPdOiSYEzE99deohZS4WdbQ5
	V7/Qdcz1rJlRqV7srbcUm8eeBUdq6VI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-644-1kRGc817PPy9WEX6XFbSrQ-1; Wed,
 26 Feb 2025 14:56:12 -0500
X-MC-Unique: 1kRGc817PPy9WEX6XFbSrQ-1
X-Mimecast-MFC-AGG-ID: 1kRGc817PPy9WEX6XFbSrQ_1740599771
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5CCF31800873;
	Wed, 26 Feb 2025 19:56:09 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8125C1955E79;
	Wed, 26 Feb 2025 19:56:08 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH 29/29] KVM: TDX: Handle SEPT zap error due to page add error in premap
Date: Wed, 26 Feb 2025 14:55:29 -0500
Message-ID: <20250226195529.2314580-30-pbonzini@redhat.com>
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

Move the handling of SEPT zap errors caused by unsuccessful execution of
tdh_mem_page_add() in KVM_TDX_INIT_MEM_REGION from
tdx_sept_drop_private_spte() to tdx_sept_zap_private_spte(). Introduce a
new helper function tdx_is_sept_zap_err_due_to_premap() to detect this
specific error.

During the IOCTL KVM_TDX_INIT_MEM_REGION, KVM premaps leaf SPTEs in the
mirror page table before the corresponding entry in the private page table
is successfully installed by tdh_mem_page_add(). If an error occurs during
the invocation of tdh_mem_page_add(), a mismatch between the mirror and
private page tables results in SEAMCALLs for SEPT zap returning the error
code TDX_EPT_ENTRY_STATE_INCORRECT.

The error TDX_EPT_WALK_FAILED is not possible because, during
KVM_TDX_INIT_MEM_REGION, KVM only premaps leaf SPTEs after successfully
mapping non-leaf SPTEs. Unlike leaf SPTEs, there is no mismatch in non-leaf
PTEs between the mirror and private page tables. Therefore, during zap,
SEAMCALLs should find an empty leaf entry in the private EPT, leading to
the error TDX_EPT_ENTRY_STATE_INCORRECT instead of TDX_EPT_WALK_FAILED.

Since tdh_mem_range_block() is always invoked before tdh_mem_page_remove(),
move the handling of SEPT zap errors from tdx_sept_drop_private_spte() to
tdx_sept_zap_private_spte(). In tdx_sept_zap_private_spte(), return 0 for
errors due to premap to skip executing other SEAMCALLs for zap, which are
unnecessary. Return 1 to indicate no other errors, allowing the execution
of other zap SEAMCALLs to continue.

The failure of tdh_mem_page_add() is uncommon and has not been observed in
real workloads. Currently, this failure is only hypothetically triggered by
skipping the real SEAMCALL and faking the add error in the SEAMCALL
wrapper. Additionally, without this fix, there will be no host crashes or
other severe issues.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Message-ID: <20250217085642.19696-1-yan.y.zhao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx.c | 66 ++++++++++++++++++++++++++++++------------
 1 file changed, 47 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a6696448cb53..f2cbd8c440e9 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -775,20 +775,6 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 					  &level_state);
 	} while (unlikely(tdx_operand_busy(err)));
 
-	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE &&
-		     err == (TDX_EPT_WALK_FAILED | TDX_OPERAND_ID_RCX))) {
-		/*
-		 * Page is mapped by KVM_TDX_INIT_MEM_REGION, but hasn't called
-		 * tdh_mem_page_add().
-		 */
-		if ((!is_last_spte(entry, level) || !(entry & VMX_EPT_RWX_MASK)) &&
-		    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
-			atomic64_dec(&kvm_tdx->nr_premapped);
-			tdx_unpin(kvm, page);
-			return 0;
-		}
-	}
-
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error_2(TDH_MEM_PAGE_REMOVE, err, entry, level_state);
 		return -EIO;
@@ -826,8 +812,41 @@ int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+/*
+ * Check if the error returned from a SEPT zap SEAMCALL is due to that a page is
+ * mapped by KVM_TDX_INIT_MEM_REGION without tdh_mem_page_add() being called
+ * successfully.
+ *
+ * Since tdh_mem_sept_add() must have been invoked successfully before a
+ * non-leaf entry present in the mirrored page table, the SEPT ZAP related
+ * SEAMCALLs should not encounter err TDX_EPT_WALK_FAILED. They should instead
+ * find TDX_EPT_ENTRY_STATE_INCORRECT due to an empty leaf entry found in the
+ * SEPT.
+ *
+ * Further check if the returned entry from SEPT walking is with RWX permissions
+ * to filter out anything unexpected.
+ *
+ * Note: @level is pg_level, not the tdx_level. The tdx_level extracted from
+ * level_state returned from a SEAMCALL error is the same as that passed into
+ * the SEAMCALL.
+ */
+static int tdx_is_sept_zap_err_due_to_premap(struct kvm_tdx *kvm_tdx, u64 err,
+					     u64 entry, int level)
+{
+	if (!err || kvm_tdx->state == TD_STATE_RUNNABLE)
+		return false;
+
+	if (err != (TDX_EPT_ENTRY_STATE_INCORRECT | TDX_OPERAND_ID_RCX))
+		return false;
+
+	if ((is_last_spte(entry, level) && (entry & VMX_EPT_RWX_MASK)))
+		return false;
+
+	return true;
+}
+
 static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
-				     enum pg_level level)
+				     enum pg_level level, struct page *page)
 {
 	int tdx_level = pg_level_to_tdx_sept_level(level);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
@@ -840,11 +859,19 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 	err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
 	if (unlikely(tdx_operand_busy(err)))
 		return -EBUSY;
+
+	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level) &&
+	    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
+		atomic64_dec(&kvm_tdx->nr_premapped);
+		tdx_unpin(kvm, page);
+		return 0;
+	}
+
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error_2(TDH_MEM_RANGE_BLOCK, err, entry, level_state);
 		return -EIO;
 	}
-	return 0;
+	return 1;
 }
 
 /*
@@ -918,6 +945,7 @@ int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 				 enum pg_level level, kvm_pfn_t pfn)
 {
+	struct page *page = pfn_to_page(pfn);
 	int ret;
 
 	/*
@@ -928,8 +956,8 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
 		return -EINVAL;
 
-	ret = tdx_sept_zap_private_spte(kvm, gfn, level);
-	if (ret)
+	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
+	if (ret <= 0)
 		return ret;
 
 	/*
@@ -938,7 +966,7 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	 */
 	tdx_track(kvm);
 
-	return tdx_sept_drop_private_spte(kvm, gfn, level, pfn_to_page(pfn));
+	return tdx_sept_drop_private_spte(kvm, gfn, level, page);
 }
 
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
-- 
2.43.5


