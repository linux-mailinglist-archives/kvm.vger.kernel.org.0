Return-Path: <kvm+bounces-14889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A54C78A7571
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 22:22:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B9791F2536A
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 20:22:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 043DC13C829;
	Tue, 16 Apr 2024 20:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZMikUaLI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A4013B794
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 20:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713298787; cv=none; b=SfS1nPvgSvP6qqNeLM5GB7Mnch0vo9s3YiV5Iy+O6xtoi9FTz8oMNBMutBls60vAqhhBPozta+c4Vzxai0OHEdkK0JCkoIt+zks9u61iZuLI1WHRi6hEndMh7if0TfWzG3C+PHn8F8gBt+f81ax/UH8P61oL8l0yINxTGhQ0W8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713298787; c=relaxed/simple;
	bh=czdR7Th8MzHIEsGl2kG3zA2zrMvBtsVZocV83LzMCJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cOVzpowCcWiwFgqz3fqqidjNLnaUyA/X3dkHbAWi6YdrRpN9kQW8mA/IuzWbnYnHAVL1/7QFuzqPKkj72pZiB1VQAreRuJPrFmNsm187MekINK7s6iP476nc/gigen56q2MMFi8Oilkj2WJb/K6wTr9a4Mkcz4c+9lGnUwVuWIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZMikUaLI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713298784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wKHBMFyUvxqFiQQY3mVtCcupwWGc2q6fnOXY0GMQChE=;
	b=ZMikUaLIJXCmIoA56qiW4Kg35117rQgjr2NO+0vTAXsVGQPKuNO2PWUHhCZMvuuW2CNZui
	1wvs3FF04deS7y08qyjHGOIwLd38t+muSW8t9ASUSLZok5Wb8Ar4u2+olgsfU2BcbIW+o2
	0uipZp1IzXrzJlWOlfELCvjsxlefKW0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-u1d24xX6M9u_JjXAYGDRMw-1; Tue, 16 Apr 2024 16:19:39 -0400
X-MC-Unique: u1d24xX6M9u_JjXAYGDRMw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B5FF88CE80;
	Tue, 16 Apr 2024 20:19:39 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D353440B497B;
	Tue, 16 Apr 2024 20:19:38 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	chao.gao@intel.com
Subject: [PATCH v2 10/10] KVM: x86/mmu: check for invalid async page faults involving private memory
Date: Tue, 16 Apr 2024 16:19:35 -0400
Message-ID: <20240416201935.3525739-11-pbonzini@redhat.com>
In-Reply-To: <20240416201935.3525739-1-pbonzini@redhat.com>
References: <20240416201935.3525739-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

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
index 7c73952b6f4e..57ec96bd4221 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1850,6 +1850,7 @@ struct kvm_arch_async_pf {
 	gfn_t gfn;
 	unsigned long cr3;
 	bool direct_map;
+	u64 error_code;
 };
 
 extern u32 __read_mostly kvm_nr_uret_msrs;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 33aea47dce8b..402d04aa5423 100644
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
@@ -4342,7 +4345,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
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


