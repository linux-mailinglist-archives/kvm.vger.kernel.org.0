Return-Path: <kvm+bounces-16874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47BF98BE821
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:02:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 025D228908C
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3660616F27B;
	Tue,  7 May 2024 15:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IEJz48Oo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4143D16D326
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715097509; cv=none; b=sxDfHQ93Td7ZwwekTctcI5I/sglOfbkVHOMzuNmoZ681DEEvydgm19fN48Iz86v9+W+CQNy2e7SLVDhbqYBM2P8IgGV1zDQZ+K1QEEMcP1NhxhnNhh3ueUhPNGQ2ry7FnrRgB1KEFqTonlgFGa6b3wQk4OO0LiQ0tXuNeYwf+s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715097509; c=relaxed/simple;
	bh=pa6UQFs5IVqPGa1HubYZhaKzaBNQ3H+E9fxCfy0yxHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eUyxBxpm9YEYK8JBi+dbSGMsyeWig5m+fB3keR9jjP5J4zNnkHTnbL38Hcx+UzXdeaCOrbMuG2r/0Ta3mLXr8aKAT5g1GIYxgTtX0N1EGvyF+wraUcI+vtjyGZYphGOVd+UHkdY/7ZITQn6twPq8CQz4ZjABJH2B7Slkfiwgwjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IEJz48Oo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715097505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3lnkqGa7h/6nD25Z7o+7/CTEjU22pWMiKsKWmTnmff0=;
	b=IEJz48OoGRPhdLRRzKATkS2TXjqbgbbYi2QsihnfYppCFBHtJb1O1mkC8vhyn5LLgo54G9
	ZK1WQ24lGQ/q2JkkB7nNnpWwHgj4KaNI/ZhhPRhFCrG6Z+ykesuibIQ20l9+NVqERXsXeQ
	mCDzIsh2Qa9iHvjvGWzIv89TEyWQmkE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-516-6rijs2KbNaCTbq9qJq9sKg-1; Tue,
 07 May 2024 11:58:19 -0400
X-MC-Unique: 6rijs2KbNaCTbq9qJq9sKg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBED01C031AC;
	Tue,  7 May 2024 15:58:18 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B0F242141800;
	Tue,  7 May 2024 15:58:18 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 05/17] KVM: x86/mmu: Pass full 64-bit error code when handling page faults
Date: Tue,  7 May 2024 11:58:05 -0400
Message-ID: <20240507155817.3951344-6-pbonzini@redhat.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Plumb the full 64-bit error code throughout the page fault handling code
so that KVM can use the upper 32 bits, e.g. SNP's PFERR_GUEST_ENC_MASK
will be used to determine whether or not a fault is private vs. shared.

Note, passing the 64-bit error code to FNAME(walk_addr)() does NOT change
the behavior of permission_fault() when invoked in the page fault path, as
KVM explicitly clears PFERR_IMPLICIT_ACCESS in kvm_mmu_page_fault().

Continue passing '0' from the async #PF worker, as guest_memfd and thus
private memory doesn't support async page faults.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[mdr: drop references/changes on rebase, update commit message]
Signed-off-by: Michael Roth <michael.roth@amd.com>
[sean: drop truncation in call to FNAME(walk_addr)(), rewrite changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <20240228024147.41573-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c          | 3 +--
 arch/x86/kvm/mmu/mmu_internal.h | 4 ++--
 arch/x86/kvm/mmu/mmutrace.h     | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5562d693880a..28b1e7657d7f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5800,8 +5800,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	}
 
 	if (r == RET_PF_INVALID) {
-		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
-					  lower_32_bits(error_code), false,
+		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, error_code, false,
 					  &emulation_type);
 		if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
 			return -EIO;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 61f49967047a..797b80f996a7 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -190,7 +190,7 @@ static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
 struct kvm_page_fault {
 	/* arguments to kvm_mmu_do_page_fault.  */
 	const gpa_t addr;
-	const u32 error_code;
+	const u64 error_code;
 	const bool prefetch;
 
 	/* Derived from error_code.  */
@@ -288,7 +288,7 @@ static inline void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 }
 
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-					u32 err, bool prefetch, int *emulation_type)
+					u64 err, bool prefetch, int *emulation_type)
 {
 	struct kvm_page_fault fault = {
 		.addr = cr2_or_gpa,
diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index ae86820cef69..195d98bc8de8 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -260,7 +260,7 @@ TRACE_EVENT(
 	TP_STRUCT__entry(
 		__field(int, vcpu_id)
 		__field(gpa_t, cr2_or_gpa)
-		__field(u32, error_code)
+		__field(u64, error_code)
 		__field(u64 *, sptep)
 		__field(u64, old_spte)
 		__field(u64, new_spte)
-- 
2.43.0



