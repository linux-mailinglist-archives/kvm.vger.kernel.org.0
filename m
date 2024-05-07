Return-Path: <kvm+bounces-16872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 257798BE819
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:02:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D477C288CDB
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:02:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB6F616C6BE;
	Tue,  7 May 2024 15:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SV6FSRpz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57BB16C6B6
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715097509; cv=none; b=fXRH20CitERq9GpxPXViko+S5bd+WIxoC1p67hyezVgyK6H2dvUoQ1CjTpyAWFoSEi46XEX16tHG0u5OEzKn6rcziS3t7RldFK8sXs6au2nLVcOGfVslLx3tb0nFi+nrQ2mYEPg6RgqaOGHGE8PF0mvd5+B2wJ1TPqsIic76xf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715097509; c=relaxed/simple;
	bh=HsxzZgC5jxXkHY4zYL00OfgSETswji4hR2HknJAifG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qB4dwETwE4xWt3unvGTfiiAhkU4SBptOPn7yJwP7Nq6Iz6avGHnr6M6S/nUH+ncm7ahk/lotEzVdUcWLZnEV3wxbSLwfaS01PvAcI9WO+VK9e4KopGGapAW3d8ZRAV6qcZbn9JJx0dDDtXy97adq0bym/PW6/acHt10Y268eF5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SV6FSRpz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715097503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7okTVrMGeOFFHG7UxCDS+WAENSApopanLrurLFC1rq0=;
	b=SV6FSRpzBQq7bZ2mEYSjGnmTH6+ZLdZFMrsNrBTkzLOQrwXnX+mokoepsAgeoK+NSuOYEt
	p98UrWjnuHClqeuAUTPDYcSbOeAyEDhG0ebwO2+T/+dykYLTZEsIEY8lBb1yUHk4UGAhpy
	GLOJ2Feqwu2Rjqv0l0pI8l9M35rTg+c=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-320--GQ-nhaZOYWobWN9zV6GFw-1; Tue,
 07 May 2024 11:58:18 -0400
X-MC-Unique: -GQ-nhaZOYWobWN9zV6GFw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FC1A29ABA0C;
	Tue,  7 May 2024 15:58:18 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0E60E2141800;
	Tue,  7 May 2024 15:58:18 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 01/17] KVM: x86/mmu: Exit to userspace with -EFAULT if private fault hits emulation
Date: Tue,  7 May 2024 11:58:01 -0400
Message-ID: <20240507155817.3951344-2-pbonzini@redhat.com>
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

Exit to userspace with -EFAULT / KVM_EXIT_MEMORY_FAULT if a private fault
triggers emulation of any kind, as KVM doesn't currently support emulating
access to guest private memory.  Practically speaking, private faults and
emulation are already mutually exclusive, but there are many flow that
can result in KVM returning RET_PF_EMULATE, and adding one last check
to harden against weird, unexpected combinations and/or KVM bugs is
inexpensive.

Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20240228024147.41573-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c          |  8 --------
 arch/x86/kvm/mmu/mmu_internal.h | 19 +++++++++++++++++++
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 45b6d8f9e359..c72a2033ca96 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4257,14 +4257,6 @@ static inline u8 kvm_max_level_for_order(int order)
 	return PG_LEVEL_4K;
 }
 
-static void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
-					      struct kvm_page_fault *fault)
-{
-	kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
-				      PAGE_SIZE, fault->write, fault->exec,
-				      fault->is_private);
-}
-
 static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 				   struct kvm_page_fault *fault)
 {
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 5390a591a571..61f49967047a 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -279,6 +279,14 @@ enum {
 	RET_PF_SPURIOUS,
 };
 
+static inline void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
+						     struct kvm_page_fault *fault)
+{
+	kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
+				      PAGE_SIZE, fault->write, fault->exec,
+				      fault->is_private);
+}
+
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u32 err, bool prefetch, int *emulation_type)
 {
@@ -320,6 +328,17 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	else
 		r = vcpu->arch.mmu->page_fault(vcpu, &fault);
 
+	/*
+	 * Not sure what's happening, but punt to userspace and hope that
+	 * they can fix it by changing memory to shared, or they can
+	 * provide a better error.
+	 */
+	if (r == RET_PF_EMULATE && fault.is_private) {
+		pr_warn_ratelimited("kvm: unexpected emulation request on private memory\n");
+		kvm_mmu_prepare_memory_fault_exit(vcpu, &fault);
+		return -EFAULT;
+	}
+
 	if (fault.write_fault_to_shadow_pgtable && emulation_type)
 		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
 
-- 
2.43.0



