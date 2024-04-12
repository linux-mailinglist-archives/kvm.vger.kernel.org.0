Return-Path: <kvm+bounces-14558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 469268A34E0
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 19:37:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF0561F22D3D
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 17:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1238F1514CB;
	Fri, 12 Apr 2024 17:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DQISfU5h"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4870014E2E0
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 17:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712943342; cv=none; b=EaKFHzDiVViY0Yaiz6a8/YKok+RZXk385wVpiXuOr4HkqQNgLxI3oSdVmw2jZab6Xfz8IdegmT8mXIbch1r46JhEmbZ8rxlrPh0oCv0PUe95kX5PC7VTcMZScjUjYQmoQ58y2SJQoMj5VM90GWtfBXcXayGI1G4YjN5hxzE6r0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712943342; c=relaxed/simple;
	bh=m6cvDpKwQxw/+1HX6xn29yBbQlMJwxJA/GOc2nFuhwM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Va9G71qk4IuLNXnUtpVrttlCSCi7bOsIJFKy4sy1WNy3yCFcCRY7dj06m97rrqbD2awnbOaY4neCb8wTx10JhM90CZksiQZeOHbQsJDehxn/QC8GjvgNUHuX7g8qElLOrDL1VoC53qEiwu7AAdHecSWBpWcVex0IlAWODWEXQ4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DQISfU5h; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712943338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VpeDD5FA3om+hsK2jspL++DDgX73rZcz5eJV48XG4Vk=;
	b=DQISfU5hOOKnh1UrPgZtKkVg+cKaFBPjImWIGb+dTtHrjX+V8Vs3TspoSNoCb9TJTHmrk5
	ZTNrfetqm4v9Y0Bzdrix5T2sQndgE/EL6oyQkg67IKN6zXsj1fYIZMbrYDskOZHIfzVHWj
	5ls9Srsrw5ZqA6j34DZoSkZ9GcMZKFg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-pGbX_jt3NbysqDWKIcvPAA-1; Fri, 12 Apr 2024 13:35:35 -0400
X-MC-Unique: pGbX_jt3NbysqDWKIcvPAA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE3291807ACE;
	Fri, 12 Apr 2024 17:35:34 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C64B32166B31;
	Fri, 12 Apr 2024 17:35:34 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 10/10] KVM: x86/mmu: check for invalid async page faults involving private memory
Date: Fri, 12 Apr 2024 13:35:32 -0400
Message-ID: <20240412173532.3481264-11-pbonzini@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Right now the error code is not used when an async page fault is completed.
This is not a problem in the current code, but it is untidy.  For protected
VMs, we will also need to check that the page attributes match the current
state of the page, because asynchronous page faults can only occur on
shared pages (private pages go through kvm_faultin_pfn_private() instead of
__gfn_to_pfn_memslot()).

Start by piping the error code from kvm_arch_setup_async_pf() to
kvm_arch_async_page_ready() via the architecture-specific async page
fault data.  For now, it can be used to assert that there are no
async page faults on private memory.

Extracted from a patch by Isaku Yamahata.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu/mmu.c          | 17 ++++++++++-------
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0b73f78dd70a..cf5f28dcda06 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1854,6 +1854,7 @@ struct kvm_arch_async_pf {
 	gfn_t gfn;
 	unsigned long cr3;
 	bool direct_map;
+	u64 error_code;
 };
 
 extern u32 __read_mostly kvm_nr_uret_msrs;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0fb175ad6b9b..7b0d671cf696 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4207,24 +4207,27 @@ static u32 alloc_apf_token(struct kvm_vcpu *vcpu)
 	return (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
 }
 
-static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-				    gfn_t gfn)
+static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu,
+				    struct kvm_page_fault *fault)
 {
 	struct kvm_arch_async_pf arch;
 
 	arch.token = alloc_apf_token(vcpu);
-	arch.gfn = gfn;
+	arch.gfn = fault->gfn;
 	arch.direct_map = vcpu->arch.mmu->root_role.direct;
 	arch.cr3 = kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
 
-	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
-				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
+	return kvm_setup_async_pf(vcpu, fault->addr,
+				  kvm_vcpu_gfn_to_hva(vcpu, fault->gfn), &arch);
 }
 
 void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 {
 	int r;
 
+	if (WARN_ON_ONCE(work->arch.error_code & PFERR_GUEST_ENC_MASK))
+		return;
+
 	if ((vcpu->arch.mmu->root_role.direct != work->arch.direct_map) ||
 	      work->wakeup_all)
 		return;
@@ -4237,7 +4240,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	      work->arch.cr3 != kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu))
 		return;
 
-	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true, NULL);
+	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, work->arch.error_code, true, NULL);
 }
 
 static inline u8 kvm_max_level_for_order(int order)
@@ -4350,7 +4353,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			trace_kvm_async_pf_repeated_fault(fault->addr, fault->gfn);
 			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
 			return RET_PF_RETRY;
-		} else if (kvm_arch_setup_async_pf(vcpu, fault->addr, fault->gfn)) {
+		} else if (kvm_arch_setup_async_pf(vcpu, fault)) {
 			return RET_PF_RETRY;
 		}
 	}
-- 
2.43.0


