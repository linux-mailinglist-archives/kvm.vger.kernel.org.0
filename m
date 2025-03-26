Return-Path: <kvm+bounces-42051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D645A71F47
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 20:38:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34214171152
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 19:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3638125F7B1;
	Wed, 26 Mar 2025 19:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h1lpQGR6"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14E025DAE6
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 19:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743017821; cv=none; b=RBEWOOYd9Ccqh5jXTQCLxRa4nlwk2nX3EhlrZbefX/qe5Fc77ENpARTdODMgpPzcEe64zPdeKUxfut3pQX820UIdxwQWWQDxkrYUCaIXhOjsyEODN7gm/II+LjYDFPrytnT0MDMO37mqUkL8gzxXvGZ2IlMkU6zg3o9V79J0i0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743017821; c=relaxed/simple;
	bh=3Z/qyQDmUr5OHNwcab1nN2KK9zaFyk0KijUSHhTecEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUrqyJanUsma8UBPn5w4Z6xwv7GVW1CKWlEjY4x+Do8nkRHLmGv2E/OksW5axN4zxQO5lf2mjj4dUJIJGY6G2qcBxRPfj1Fp0xuutditwBn6qzsTGwwduQqUCZhktB2iqUE5tuFHPA/r4C2sUeVxm9DD5khQcaapMY81Pyaa5D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h1lpQGR6; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743017817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pgJEtJgOJdFCDa3hMi2cg/nzD2GlrXCn85QUlreigwo=;
	b=h1lpQGR6v7BOuK1jOZlDKlHnYJ8TzR+Lfihx/xs365nE+cPD9JUoUVJOok+9LBgQz+s0Qb
	++UaCRJBkmCtE1fY2SNRY1ZtyrzuoDidVQbAPYGuKl81vFuigmiIzy5R7RBs6lEfjlY4kz
	YBpGMoXO///40EI+Aib2xn3QreyWlZU=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [RFC PATCH 06/24] KVM: SEV: Track ASID->vCPU instead of ASID->VMCB
Date: Wed, 26 Mar 2025 19:36:01 +0000
Message-ID: <20250326193619.3714986-7-yosry.ahmed@linux.dev>
In-Reply-To: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

SEV currently tracks the ASID to VMCB mapping for each physical CPU.
This is required to flush the ASID when a new VMCB using the same ASID
is run on the same CPU. Practically, there is a single VMCB for each
vCPU using SEV. Furthermore, TLB flushes on nested transitions between
VMCB01 and VMCB02 are handled separately (see
nested_svm_transition_tlb_flush()).

In preparation for generalizing the tracking and making the tracking
more expensive, start tracking the ASID to vCPU mapping instead. This
will allow for the tracking to be moved to a cheaper code path when
vCPUs are switched.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/sev.c | 12 ++++++------
 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/svm/svm.h |  4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d613f81addf1c..ddb4d5b211ed7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -240,7 +240,7 @@ static void sev_asid_free(struct kvm_sev_info *sev)
 
 	for_each_possible_cpu(cpu) {
 		sd = per_cpu_ptr(&svm_data, cpu);
-		sd->sev_vmcbs[sev->asid] = NULL;
+		sd->sev_vcpus[sev->asid] = NULL;
 	}
 
 	mutex_unlock(&sev_bitmap_lock);
@@ -3081,8 +3081,8 @@ int sev_cpu_init(struct svm_cpu_data *sd)
 	if (!sev_enabled)
 		return 0;
 
-	sd->sev_vmcbs = kcalloc(nr_asids, sizeof(void *), GFP_KERNEL);
-	if (!sd->sev_vmcbs)
+	sd->sev_vcpus = kcalloc(nr_asids, sizeof(void *), GFP_KERNEL);
+	if (!sd->sev_vcpus)
 		return -ENOMEM;
 
 	return 0;
@@ -3471,14 +3471,14 @@ int pre_sev_run(struct vcpu_svm *svm, int cpu)
 	/*
 	 * Flush guest TLB:
 	 *
-	 * 1) when different VMCB for the same ASID is to be run on the same host CPU.
+	 * 1) when different vCPU for the same ASID is to be run on the same host CPU.
 	 * 2) or this VMCB was executed on different host CPU in previous VMRUNs.
 	 */
-	if (sd->sev_vmcbs[asid] == svm->vmcb &&
+	if (sd->sev_vcpus[asid] == &svm->vcpu &&
 	    svm->vcpu.arch.last_vmentry_cpu == cpu)
 		return 0;
 
-	sd->sev_vmcbs[asid] = svm->vmcb;
+	sd->sev_vcpus[asid] = &svm->vcpu;
 	vmcb_set_flush_asid(svm->vmcb);
 	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 	return 0;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 18bfc3d3f9ba1..1156ca97fd798 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -694,7 +694,7 @@ static void svm_cpu_uninit(int cpu)
 	if (!sd->save_area)
 		return;
 
-	kfree(sd->sev_vmcbs);
+	kfree(sd->sev_vcpus);
 	__free_page(__sme_pa_to_page(sd->save_area_pa));
 	sd->save_area_pa = 0;
 	sd->save_area = NULL;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 843a29a6d150e..4ea6c61c3b048 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -340,8 +340,8 @@ struct svm_cpu_data {
 
 	struct vmcb *current_vmcb;
 
-	/* index = sev_asid, value = vmcb pointer */
-	struct vmcb **sev_vmcbs;
+	/* index = sev_asid, value = vcpu pointer */
+	struct kvm_vcpu **sev_vcpus;
 };
 
 DECLARE_PER_CPU(struct svm_cpu_data, svm_data);
-- 
2.49.0.395.g12beb8f557-goog


