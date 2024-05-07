Return-Path: <kvm+bounces-16873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A68078BE81C
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:02:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BF061F2A734
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F156816F0FD;
	Tue,  7 May 2024 15:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ib12fZg/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1069216D318
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715097509; cv=none; b=XdSigcFDlF68bJmazzbCEvFbak8BSkKPkFB9EURahal4W1s6JrPFVDMkPmmXEZZ5NuUDLi27WtvHCoeTGuxhZTjxCEjdU3vBuf0oYTBuRmEobyxXeT6lonhlcD12ZG9uQaTptmKPZ9+OPUBbsK+Se3ts8yfBG53JsWYynwYu0TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715097509; c=relaxed/simple;
	bh=GnaXsr+zbd/U7GYWO/XXTnyktbvceHVhOXczQVr4XWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=imR7s5iTOkS0v7AouWOAwp0HyRb7Lku4qaKGkzCt3dEDqDNV19Aiq+8RD3LHO5vKmuXqV/0on9TXlopZy8MIVu7dRQ9YXV2GOryy8h4T40xKsUAbPIBFiIQikf+5ZxuRgCQcwRuHtEcUxiReUbGVBlNM1lRMRuXO7HxRQA0uye8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ib12fZg/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715097505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5xfI8GlIpdk/dq7ZsckyDRl9W0stP1kv+OVmnAnTfxI=;
	b=ib12fZg/j5PHT5DYoCEN1WZLnbZnIeFuF7fvFOcLJ/98z6AokQ4v465Nmy+WwVx14YvrDG
	sHW1LLnM9tRA19nNWE4U5ovcq2Oqj74FyDEdxV+ygDTxOf836GyKX6bG5fveOsTKY1X1Vg
	ZPE/5D8jczpBQmzcypUV2UNp4KaY3mQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530--TK-8O3SNhOueOYN4IhQyA-1; Tue, 07 May 2024 11:58:20 -0400
X-MC-Unique: -TK-8O3SNhOueOYN4IhQyA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D716D802BFB;
	Tue,  7 May 2024 15:58:19 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9AF89492CAA;
	Tue,  7 May 2024 15:58:19 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Fuad Tabba <tabba@google.com>,
	Michael Roth <michael.roth@amd.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH 10/17] KVM: x86/mmu: Move private vs. shared check above slot validity checks
Date: Tue,  7 May 2024 11:58:10 -0400
Message-ID: <20240507155817.3951344-11-pbonzini@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

From: Sean Christopherson <seanjc@google.com>

Prioritize private vs. shared gfn attribute checks above slot validity
checks to ensure a consistent userspace ABI.  E.g. as is, KVM will exit to
userspace if there is no memslot, but emulate accesses to the APIC access
page even if the attributes mismatch.

Fixes: 8dd2eee9d526 ("KVM: x86/mmu: Handle page fault for private memory")
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
Cc: Chao Peng <chao.p.peng@linux.intel.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Michael Roth <michael.roth@amd.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Message-ID: <20240228024147.41573-10-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0d884d0b0f35..ba50b93e93ed 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4317,11 +4317,6 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			return RET_PF_EMULATE;
 	}
 
-	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
-		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
-		return -EFAULT;
-	}
-
 	if (fault->is_private)
 		return kvm_faultin_pfn_private(vcpu, fault);
 
@@ -4359,9 +4354,24 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 {
 	int ret;
 
+	/*
+	 * Note that the mmu_invalidate_seq also serves to detect a concurrent
+	 * change in attributes.  is_page_fault_stale() will detect an
+	 * invalidation relate to fault->fn and resume the guest without
+	 * installing a mapping in the page tables.
+	 */
 	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	smp_rmb();
 
+	/*
+	 * Now that we have a snapshot of mmu_invalidate_seq we can check for a
+	 * private vs. shared mismatch.
+	 */
+	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
+		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+		return -EFAULT;
+	}
+
 	/*
 	 * Check for a relevant mmu_notifier invalidation event before getting
 	 * the pfn from the primary MMU, and before acquiring mmu_lock.
-- 
2.43.0



