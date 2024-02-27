Return-Path: <kvm+bounces-10165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BB1E386A385
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 00:24:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 720111F2314E
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 23:24:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 723E15B66D;
	Tue, 27 Feb 2024 23:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aTlwu0i3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC9E58119
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 23:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709076073; cv=none; b=lqVr1yUFZ0Ue+jw4dRlMjRw4vCMjCWnrQUQU+B1iGfXERGr3Otl9glkjxLxp2YoLcWTi2ZYtuYSDCK2Cx+z+2B6kU1G+os52SnRgU6eHYYq4KVDVfPEpRp/P9S95JrHo7xIRH59foFOhBihe4YUFgO5ocboCHh8/PxT2inp54TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709076073; c=relaxed/simple;
	bh=9CfWX8HdW2UX3ZUVgxAdyd0guyhqoDk/NzwOHyIQqR4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dd2RIDRVhCk82ypaCGUvpeufowT1I/0AfQstZR2PAUOQwvnDvSBlI83BCO4PsVrXGQ/eNuPfEhZ6/MBceBiphl1g2kugq5kTTv/f7yBLEG6YWCGfhoFyD0NhR3XZWj9JVso9KFZ/LbCS758Rzr0i2AYacqHIzvjqF6szU3vzQno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aTlwu0i3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709076068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wp0PKi7LIqDV/bOhI4X8sRzgu//akmwfPB7H3G2jAjw=;
	b=aTlwu0i3X2Gy7OKG+Sw3B4mBta+/VqyI5JzJY0GmqKgcttCnrz7PoEDMk8efQYkXrHLIAX
	VoUX44MQlkSIkkZJXf6wk5H21d+Wv3w6YiI3bgNMICBjHGJVQx78rp8UtPfHBznew/JVQM
	FNQ4JfRYZOjEYSrA7NDV0cmNvenmzZQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-f86VfUR4MquqKV0uZzzIEw-1; Tue, 27 Feb 2024 18:21:06 -0500
X-MC-Unique: f86VfUR4MquqKV0uZzzIEw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C495C185A780;
	Tue, 27 Feb 2024 23:21:05 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 97B2C492BCF;
	Tue, 27 Feb 2024 23:21:05 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	isaku.yamahata@intel.com,
	thomas.lendacky@amd.com
Subject: [PATCH 21/21] KVM: x86: Add gmem hook for determining max NPT mapping level
Date: Tue, 27 Feb 2024 18:21:00 -0500
Message-Id: <20240227232100.478238-22-pbonzini@redhat.com>
In-Reply-To: <20240227232100.478238-1-pbonzini@redhat.com>
References: <20240227232100.478238-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

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

At this point there are no mixed attributes, and KVM would normally
allow for 2MB NPT mappings again, but this is actually not allowed
because the RMP table mappings are 4K and cannot be promoted on the
hypervisor side, so the NPT mappings must still be limited to 4K to
match this.

Add a hook to determine the max NPT mapping size in situations like
this.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Message-Id: <20231230172351.574091-31-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 1 +
 arch/x86/include/asm/kvm_host.h    | 1 +
 arch/x86/kvm/mmu/mmu.c             | 7 +++++++
 3 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 42474acb7375..436e3c157fae 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -140,6 +140,7 @@ KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL(get_untagged_addr)
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
+KVM_X86_OP_OPTIONAL_RET0(gmem_validate_fault)
 KVM_X86_OP_OPTIONAL(gmem_invalidate)
 
 #undef KVM_X86_OP
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e523b204697d..259e6bb1e447 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1806,6 +1806,7 @@ struct kvm_x86_ops {
 	gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
+	int (*gmem_validate_fault)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, u8 *max_level);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6b4cb71668df..bcf12ac489f9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4339,6 +4339,13 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 			       fault->max_level);
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
 
+	r = static_call(kvm_x86_gmem_validate_fault)(vcpu->kvm, fault->pfn,
+						     fault->gfn, &fault->max_level);
+	if (r) {
+		kvm_release_pfn_clean(fault->pfn);
+		return r;
+	}
+
 	return RET_PF_CONTINUE;
 }
 
-- 
2.39.0


