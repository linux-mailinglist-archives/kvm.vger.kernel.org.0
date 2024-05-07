Return-Path: <kvm+bounces-16854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2026A8BE7B2
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 17:45:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBD582872BB
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 15:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B42FB16C856;
	Tue,  7 May 2024 15:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ii07afUV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF2E16ABC6
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715096707; cv=none; b=QYDFJHk4Kyi7sTfisIXZ3ybydqD884xOwy95sOjsrfjBBkEZO0ywiNzhPNPBN3oFJZh/xfEJPQlkzbt/rhBmnbt5pghdkqJZgKliYdk94TO6AoTds2YBUFuqnx2ZpS0Icul2JTWbTUtwo/dovPNg19Y+sp8YVW92y+ZiJ5eCzco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715096707; c=relaxed/simple;
	bh=7hcY1DK19et/zMDAnYOy2LFryAQQJMgdDKr+FeCfUqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i4cEH+Me65HOdvcNje4nEVkcks0hvso73aoT6sEJ1MRCk6q9M9EmSoL7SeQC3I0LC6SkXr2Py7+/naLJsXWvS3hraQ5Y572GHb/m1e8svKgnnrvgfsa06XRMvmslDeYUpZPGNC7KfFA8l4y0BREyo81W+9t2EsEVzq2JQFO5Lrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ii07afUV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715096705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TwTWd1LWboFZJFIO6b5zNSAq4i8lxaUHZBQQ5FiIFdY=;
	b=Ii07afUVKbHb+0RwE+YsHlAsKzJwd0dCARXwUJ63wFEZUH3KN/o7aPyMoy8/590wJ6HZIP
	0vf/UvyjVgSLGPvBe9ux2dm34wKQ/lfbFII+J+5+lMv4ej43NDD91Axvqk24EBsvsbUuPE
	Zo+7rdV7y5GjCpKkkmieXsTnjb3LQ2o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-bk7iVxlhNx22Yxz9fmL5OQ-1; Tue, 07 May 2024 11:45:01 -0400
X-MC-Unique: bk7iVxlhNx22Yxz9fmL5OQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 424AC801786;
	Tue,  7 May 2024 15:45:01 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1672CC0157D;
	Tue,  7 May 2024 15:45:01 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 3/7] KVM: x86/mmu: Allow non-zero value for non-present SPTE and removed SPTE
Date: Tue,  7 May 2024 11:44:55 -0400
Message-ID: <20240507154459.3950778-4-pbonzini@redhat.com>
In-Reply-To: <20240507154459.3950778-1-pbonzini@redhat.com>
References: <20240507154459.3950778-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

From: Sean Christopherson <seanjc@google.com>

For TD guest, the current way to emulate MMIO doesn't work any more, as KVM
is not able to access the private memory of TD guest and do the emulation.
Instead, TD guest expects to receive #VE when it accesses the MMIO and then
it can explicitly make hypercall to KVM to get the expected information.

To achieve this, the TDX module always enables "EPT-violation #VE" in the
VMCS control.  And accordingly, for the MMIO spte for the shared GPA,
1. KVM needs to set "suppress #VE" bit for the non-present SPTE so that EPT
violation happens on TD accessing MMIO range.  2. On EPT violation, KVM
sets the MMIO spte to clear "suppress #VE" bit so the TD guest can receive
the #VE instead of EPT misconfiguration unlike VMX case.  For the shared GPA
that is not populated yet, EPT violation need to be triggered when TD guest
accesses such shared GPA.  The non-present SPTE value for shared GPA should
set "suppress #VE" bit.

Add "suppress #VE" bit (bit 63) to SHADOW_NONPRESENT_VALUE and
REMOVED_SPTE.  Unconditionally set the "suppress #VE" bit (which is bit 63)
for both AMD and Intel as: 1) AMD hardware doesn't use this bit when
present bit is off; 2) for normal VMX guest, KVM never enables the
"EPT-violation #VE" in VMCS control and "suppress #VE" bit is ignored by
hardware.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Message-Id: <a99cb866897c7083430dce7f24c63b17d7121134.1705965635.git.isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 12 ++++++------
 arch/x86/kvm/mmu/spte.c        | 14 +++++++-------
 arch/x86/kvm/mmu/spte.h        | 16 +++++++++++++++-
 3 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index bebd73cd61bb..9aac3aa93d88 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -933,13 +933,13 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
 		return 0;
 
 	/*
-	 * Drop the SPTE if the new protections would result in a RWX=0
-	 * SPTE or if the gfn is changing.  The RWX=0 case only affects
-	 * EPT with execute-only support, i.e. EPT without an effective
-	 * "present" bit, as all other paging modes will create a
-	 * read-only SPTE if pte_access is zero.
+	 * Drop the SPTE if the new protections result in no effective
+	 * "present" bit or if the gfn is changing.  The former case
+	 * only affects EPT with execute-only support with pte_access==0;
+	 * all other paging modes will create a read-only SPTE if
+	 * pte_access is zero.
 	 */
-	if ((!pte_access && !shadow_present_mask) ||
+	if ((pte_access | shadow_present_mask) == SHADOW_NONPRESENT_VALUE ||
 	    gfn != kvm_mmu_page_get_gfn(sp, i)) {
 		drop_spte(vcpu->kvm, &sp->spt[i]);
 		return 1;
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 6c7ab3aa6aa7..768aaeddf5fa 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -144,19 +144,19 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	u64 spte = SPTE_MMU_PRESENT_MASK;
 	bool wrprot = false;
 
-	WARN_ON_ONCE(!pte_access && !shadow_present_mask);
+	/*
+	 * For the EPT case, shadow_present_mask has no RWX bits set if
+	 * exec-only page table entries are supported.  In that case,
+	 * ACC_USER_MASK and shadow_user_mask are used to represent
+	 * read access.  See FNAME(gpte_access) in paging_tmpl.h.
+	 */
+	WARN_ON_ONCE((pte_access | shadow_present_mask) == SHADOW_NONPRESENT_VALUE);
 
 	if (sp->role.ad_disabled)
 		spte |= SPTE_TDP_AD_DISABLED;
 	else if (kvm_mmu_page_ad_need_write_protect(sp))
 		spte |= SPTE_TDP_AD_WRPROT_ONLY;
 
-	/*
-	 * For the EPT case, shadow_present_mask is 0 if hardware
-	 * supports exec-only page table entries.  In that case,
-	 * ACC_USER_MASK and shadow_user_mask are used to represent
-	 * read access.  See FNAME(gpte_access) in paging_tmpl.h.
-	 */
 	spte |= shadow_present_mask;
 	if (!prefetch)
 		spte |= spte_shadow_accessed_mask(spte);
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 0f4ec2859474..8056b7853a79 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -149,7 +149,21 @@ static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
 
 #define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)
 
+/*
+ * Non-present SPTE value needs to set bit 63 for TDX, in order to suppress
+ * #VE and get EPT violations on non-present PTEs.  We can use the
+ * same value also without TDX for both VMX and SVM:
+ *
+ * For SVM NPT, for non-present spte (bit 0 = 0), other bits are ignored.
+ * For VMX EPT, bit 63 is ignored if #VE is disabled. (EPT_VIOLATION_VE=0)
+ *              bit 63 is #VE suppress if #VE is enabled. (EPT_VIOLATION_VE=1)
+ */
+#ifdef CONFIG_X86_64
+#define SHADOW_NONPRESENT_VALUE	BIT_ULL(63)
+static_assert(!(SHADOW_NONPRESENT_VALUE & SPTE_MMU_PRESENT_MASK));
+#else
 #define SHADOW_NONPRESENT_VALUE	0ULL
+#endif
 
 extern u64 __read_mostly shadow_host_writable_mask;
 extern u64 __read_mostly shadow_mmu_writable_mask;
@@ -192,7 +206,7 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
  *
  * Use a semi-arbitrary value that doesn't set RWX bits, i.e. is not-present on
  * both AMD and Intel CPUs, and doesn't set PFN bits, i.e. doesn't create a L1TF
- * vulnerability.  Use only low bits to avoid 64-bit immediates.
+ * vulnerability.
  *
  * Only used by the TDP MMU.
  */
-- 
2.43.0



