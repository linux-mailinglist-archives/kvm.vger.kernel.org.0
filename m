Return-Path: <kvm+bounces-14556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9BC38A34DE
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 19:36:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 965B728136E
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 17:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAAF41509B2;
	Fri, 12 Apr 2024 17:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f+1R5hv5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDBA14EC61
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 17:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712943341; cv=none; b=lrk7wBRbnXtYtf5Wpxh41Cieh7cfg52qR5KimzuLHYf0cXzHYJHrJIpGVy0snutibsYtTM0xBEUrP1P3Js+OVlhL9kGq8RD1Ky7ZKYAzvKOwx7KqDcSFgX8sV3C2dEz2IAYOs+ldgRMFNhD3ufXr9JeK+8UAnZASpT5ImWw1gBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712943341; c=relaxed/simple;
	bh=ufzS21/7youUNMjyVUvni0StGellwHU8hcLjTR6wauA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QpArrsD2NFI58+TGMA77O0zJGX8/shPTGA2f0akGuGsZ4R2aNeMi1ec82r64m1g7xEUOkibwtln1CJEngIV9nu0iJtwpgff9GWKjzPSMPG7hKsX+olmqB43eztXgea+E0QcvdI8GicE3pIi3QuWrn77ZigfJE7XA+MJ3eHb9kek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f+1R5hv5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712943338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=75waKXSmIYtMtrXauv2s2wb+S8RC+sVEfUlq8dP5Jvo=;
	b=f+1R5hv59tFyBebakd5UfcAkgV+mklyGtmFhxka3IhG8BoaZbhIOEkVZ1xzJGF1QxjfL8l
	wRvNIygJpjy/QhjDCfXFreLeOSX2bBSIFvi4WsyFod6hWqkxM5VcwZDuU+FoljWqPkp1SZ
	BUQptJVTG29o1RtsffU4tAyVng222DA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-9pAF9ZHjMvGpQH_CH-Vjkg-1; Fri, 12 Apr 2024 13:35:34 -0400
X-MC-Unique: 9pAF9ZHjMvGpQH_CH-Vjkg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86E2A80171B;
	Fri, 12 Apr 2024 17:35:34 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 652CD492BC7;
	Fri, 12 Apr 2024 17:35:34 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Michael Roth <michael.roth@amd.com>
Subject: [PATCH 08/10] KVM: x86/mmu: Pass around full 64-bit error code for KVM page faults
Date: Fri, 12 Apr 2024 13:35:30 -0400
Message-ID: <20240412173532.3481264-9-pbonzini@redhat.com>
In-Reply-To: <20240412173532.3481264-1-pbonzini@redhat.com>
References: <20240412173532.3481264-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

From: Isaku Yamahata <isaku.yamahata@intel.com>

In some cases the full 64-bit error code for the KVM page fault will be
needed to determine things like whether or not a fault was for a private
or shared guest page, so update related code to accept the full 64-bit
value so it can be plumbed all the way through to where it is needed.

The use of lower_32_bits() moves from kvm_mmu_page_fault() to
FNAME(page_fault), since walking is independent of the data in the
upper bits of the error code.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Link: https://lore.kernel.org/kvm/20230612042559.375660-1-michael.roth@amd.com/T/#mbd0b20c9a2cf50319d5d2a27b63f73c772112076
[mdr: drop references/changes to code not in current gmem tree, update
      commit message]
Signed-off-by: Michael Roth <michael.roth@amd.com>
Message-Id: <20231230172351.574091-7-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c          | 3 +--
 arch/x86/kvm/mmu/mmu_internal.h | 4 ++--
 arch/x86/kvm/mmu/mmutrace.h     | 2 +-
 arch/x86/kvm/mmu/paging_tmpl.h  | 2 +-
 4 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index edfc6d67692b..8c56d278d8a2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5824,8 +5824,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	}
 
 	if (r == RET_PF_INVALID) {
-		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
-					  lower_32_bits(error_code), false,
+		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, error_code, false,
 					  &emulation_type);
 		if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
 			return -EIO;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 5390a591a571..49b428cca04e 100644
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
@@ -280,7 +280,7 @@ enum {
 };
 
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
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index bebd73cd61bb..ed2923d9a934 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -787,7 +787,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * The bit needs to be cleared before walking guest page tables.
 	 */
 	r = FNAME(walk_addr)(&walker, vcpu, fault->addr,
-			     fault->error_code & ~PFERR_RSVD_MASK);
+			     lower_32_bits(fault->error_code) & ~PFERR_RSVD_MASK);
 
 	/*
 	 * The page is not mapped by the guest.  Let the guest handle it.
-- 
2.43.0



