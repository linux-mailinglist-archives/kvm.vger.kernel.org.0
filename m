Return-Path: <kvm+bounces-16914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C9DA38BEB34
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 20:10:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BE351F22ABA
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:10:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 731D216F29B;
	Tue,  7 May 2024 18:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b9Y0JMpG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAACD16DEC0
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 18:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715105260; cv=none; b=Jxhn7ElMn2YxTgFVdr4fcn+Ob0NNJ4pNT1Fji14wp6JQep0Pzljv1CmZ0mQymEFz5Oz593TzgehCDysOGBLAxbySbsBt5aswGrcxEcLJbNSBoatA6/lhktItwPsCM1JRgo2tfwa4ar71gw9aYHpIfTyKJG1/Nt4RJSb5nZGPrTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715105260; c=relaxed/simple;
	bh=FH7cYL5lvPSmvqfEep2f4O2RuFvzuxAEjokHvAHJUAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ii4W0Rkq9YVDsu8HXGc6Kf6vOd/cl0kmidsGe6N45v4MnRVsduYtyJJ56Dp1hGtIASMDEKho1+U5RG3yM/otwOEjXOFAgN5qAt7Wajl408YZY9F/7nHZoHelFIgCrsPPqtRnjsPlCyL9w+PZcGs2dPcdxkY2qetMUE8AFsML5Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b9Y0JMpG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715105258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=53/ANlC1o0IgKwLZ8A5FguWDI2cCDE7tcoOaBGJCClo=;
	b=b9Y0JMpG4rPbcxQ7W1qvVmZNLF1sk4uNlDIA4OchYWUhGzBHlQQKg7X862ohcsUzPTLxRb
	qwRMGuj1ayWF4YZrq7xba4Q9cpsUulAhbxUu0jF3vcR9etPz2O2c4ufMExfahIwUh4VsL6
	D+H96DpSTg853bTGCgRkvqbSlxt5SXw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-7mfOjuOeM062e_Lv9sPQ7Q-1; Tue, 07 May 2024 14:07:34 -0400
X-MC-Unique: 7mfOjuOeM062e_Lv9sPQ7Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA05C800053;
	Tue,  7 May 2024 18:07:32 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9891D40C6CBE;
	Tue,  7 May 2024 18:07:32 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: vbabka@suse.cz,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com,
	michael.roth@amd.com,
	yilun.xu@intel.com
Subject: [PATCH 9/9] KVM: x86: Add hook for determining max NPT mapping level
Date: Tue,  7 May 2024 14:07:29 -0400
Message-ID: <20240507180729.3975856-10-pbonzini@redhat.com>
In-Reply-To: <20240507180729.3975856-1-pbonzini@redhat.com>
References: <20240507180729.3975856-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

From: Michael Roth <michael.roth@amd.com>

In the case of SEV-SNP, whether or not a 2MB page can be mapped via a
2MB mapping in the guest's nested page table depends on whether or not
any subpages within the range have already been initialized as private
in the RMP table. The existing mixed-attribute tracking in KVM is
insufficient here, for instance:

- gmem allocates 2MB page
- guest issues PVALIDATE on 2MB page
- guest later converts a subpage to shared
- SNP host code issues PSMASH to split 2MB RMP mapping to 4K
- KVM MMU splits NPT mapping to 4K
- guest later converts that shared page back to private

At this point there are no mixed attributes, and KVM would normally
allow for 2MB NPT mappings again, but this is actually not allowed
because the RMP table mappings are 4K and cannot be promoted on the
hypervisor side, so the NPT mappings must still be limited to 4K to
match this.

Add a hook to determine the max NPT mapping size in situations like
this.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Message-ID: <20240501085210.2213060-3-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/mmu/mmu.c             | 23 +++++++++++++++++++++--
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index c81990937ab4..566d19b02483 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -140,6 +140,7 @@ KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL(get_untagged_addr)
 KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
+KVM_X86_OP_OPTIONAL_RET0(private_max_mapping_level)
 KVM_X86_OP_OPTIONAL(gmem_invalidate)
 
 #undef KVM_X86_OP
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c6c5018376be..87265b73906a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1816,6 +1816,7 @@ struct kvm_x86_ops {
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
+	int (*private_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 510eb1117012..a5259e070c06 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4271,6 +4271,25 @@ static inline u8 kvm_max_level_for_order(int order)
 	return PG_LEVEL_4K;
 }
 
+static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
+					u8 max_level, int gmem_order)
+{
+	u8 req_max_level;
+
+	if (max_level == PG_LEVEL_4K)
+		return PG_LEVEL_4K;
+
+	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
+	if (max_level == PG_LEVEL_4K)
+		return PG_LEVEL_4K;
+
+	req_max_level = static_call(kvm_x86_private_max_mapping_level)(kvm, pfn);
+	if (req_max_level)
+		max_level = min(max_level, req_max_level);
+
+	return req_max_level;
+}
+
 static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 				   struct kvm_page_fault *fault)
 {
@@ -4288,9 +4307,9 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 		return r;
 	}
 
-	fault->max_level = min(kvm_max_level_for_order(max_order),
-			       fault->max_level);
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
+	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault->pfn,
+							 fault->max_level, max_order);
 
 	return RET_PF_CONTINUE;
 }
-- 
2.43.0


