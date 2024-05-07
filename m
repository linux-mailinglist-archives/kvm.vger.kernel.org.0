Return-Path: <kvm+bounces-16860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A5D4D8BE80E
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:00:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C85601C232DA
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:00:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD66716D308;
	Tue,  7 May 2024 15:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W3DoSbGF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFF8168B02
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715097504; cv=none; b=pXfNnYhLd8Kuqvg3HFVNZFMWnRtgjzku0hWiE1h5CB7oai5TsFOk81CoESTmaDhbMigzaWicGrMsNK7NQ1zQ7RuHb3LyINYzGDR1Ya8zY/4WZcXmHWes8H/ISras9XTXMLfQXdFKJRC7e4ozVHviWytVF+0rLdqPeoc17UPmeCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715097504; c=relaxed/simple;
	bh=HZKy2aHW+upiMPSHluVOwcsUAEtxNyzZMoKVaGehNFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GZaeFgsYbeTzYycdOwrsMaksfk2cAkbicmK+99zxTiiOM6ArnCiqeQzdwSJWc8o1nC4chDC753zhbU7ibxhfHlTzLUE5Ilt7em2k8rOjxYLGeHjTbVtYRMMynifhrDrshOHUoAPL/yOxRgSVKiHWcva1EJyeEZAthPK2SGvw8wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W3DoSbGF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715097502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z+xBy1esNtbCsVcAhQikleVQqCSB3z4WdMDWXlDHhFg=;
	b=W3DoSbGFoH3IiXpVEXuLAUNjPqrcyp/OJgDzvQoS1VNcKgqgFPu46zDa3tpPMWS44fEBHT
	20Mhb9S09mAV70aaoxfIOyh9i1lWi8meqHeAq5QMfrM00QWrF19ih5jDZCzM0tZ+9agyBd
	5jgiBWSR4vQJojEgtQJ3bfTvIoOY/Sk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-eJ7LFVbjMp-kRXiVb0Julw-1; Tue, 07 May 2024 11:58:19 -0400
X-MC-Unique: eJ7LFVbjMp-kRXiVb0Julw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8489101A551;
	Tue,  7 May 2024 15:58:18 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 81825200B2F6;
	Tue,  7 May 2024 15:58:18 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH 04/17] KVM: x86: Move synthetic PFERR_* sanity checks to SVM's #NPF handler
Date: Tue,  7 May 2024 11:58:04 -0400
Message-ID: <20240507155817.3951344-5-pbonzini@redhat.com>
In-Reply-To: <20240507155817.3951344-1-pbonzini@redhat.com>
References: <20240507155817.3951344-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Sean Christopherson <seanjc@google.com>

Move the sanity check that hardware never sets bits that collide with KVM-
define synthetic bits from kvm_mmu_page_fault() to npf_interception(),
i.e. make the sanity check #NPF specific.  The legacy #PF path already
WARNs if _any_ of bits 63:32 are set, and the error code that comes from
VMX's EPT Violatation and Misconfig is 100% synthesized (KVM morphs VMX's
EXIT_QUALIFICATION into error code flags).

Add a compile-time assert in the legacy #PF handler to make sure that KVM-
define flags are covered by its existing sanity check on the upper bits.

Opportunistically add a description of PFERR_IMPLICIT_ACCESS, since we
are removing the comment that defined it.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Message-ID: <20240228024147.41573-8-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/mmu/mmu.c          | 14 +++-----------
 arch/x86/kvm/svm/svm.c          |  9 +++++++++
 3 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 58bbcf76ad1e..12e727301262 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -267,7 +267,13 @@ enum x86_intercept_stage;
 #define PFERR_GUEST_ENC_MASK	BIT_ULL(34)
 #define PFERR_GUEST_SIZEM_MASK	BIT_ULL(35)
 #define PFERR_GUEST_VMPL_MASK	BIT_ULL(36)
+
+/*
+ * IMPLICIT_ACCESS is a KVM-defined flag used to correctly perform SMAP checks
+ * when emulating instructions that triggers implicit access.
+ */
 #define PFERR_IMPLICIT_ACCESS	BIT_ULL(48)
+#define PFERR_SYNTHETIC_MASK	(PFERR_IMPLICIT_ACCESS)
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
 				 PFERR_WRITE_MASK |		\
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c72a2033ca96..5562d693880a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4502,6 +4502,9 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 		return -EFAULT;
 #endif
 
+	/* Ensure the above sanity check also covers KVM-defined flags. */
+	BUILD_BUG_ON(lower_32_bits(PFERR_SYNTHETIC_MASK));
+
 	vcpu->arch.l1tf_flush_l1d = true;
 	if (!flags) {
 		trace_kvm_page_fault(vcpu, fault_address, error_code);
@@ -5786,17 +5789,6 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	int r, emulation_type = EMULTYPE_PF;
 	bool direct = vcpu->arch.mmu->root_role.direct;
 
-	/*
-	 * IMPLICIT_ACCESS is a KVM-defined flag used to correctly perform SMAP
-	 * checks when emulating instructions that triggers implicit access.
-	 * WARN if hardware generates a fault with an error code that collides
-	 * with the KVM-defined value.  Clear the flag and continue on, i.e.
-	 * don't terminate the VM, as KVM can't possibly be relying on a flag
-	 * that KVM doesn't know about.
-	 */
-	if (WARN_ON_ONCE(error_code & PFERR_IMPLICIT_ACCESS))
-		error_code &= ~PFERR_IMPLICIT_ACCESS;
-
 	if (WARN_ON_ONCE(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
 		return RET_PF_RETRY;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0f3b59da0d4a..535018f152a3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2047,6 +2047,15 @@ static int npf_interception(struct kvm_vcpu *vcpu)
 	u64 fault_address = svm->vmcb->control.exit_info_2;
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
+	/*
+	 * WARN if hardware generates a fault with an error code that collides
+	 * with KVM-defined sythentic flags.  Clear the flags and continue on,
+	 * i.e. don't terminate the VM, as KVM can't possibly be relying on a
+	 * flag that KVM doesn't know about.
+	 */
+	if (WARN_ON_ONCE(error_code & PFERR_SYNTHETIC_MASK))
+		error_code &= ~PFERR_SYNTHETIC_MASK;
+
 	trace_kvm_page_fault(vcpu, fault_address, error_code);
 	return kvm_mmu_page_fault(vcpu, fault_address, error_code,
 			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
-- 
2.43.0



