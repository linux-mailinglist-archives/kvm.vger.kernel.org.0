Return-Path: <kvm+bounces-42962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8936FA817AB
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 23:32:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF3631B6335D
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 21:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D63402550DB;
	Tue,  8 Apr 2025 21:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="epboGODE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57752405EB
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 21:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744147894; cv=none; b=SOaEhrRCVv4bgFGv/g4dA0g4uVjzLGY7KCuKzF4YlTCeWMZ5wr8vbTZE0AyBM5w485QKsjqAQESgkI2OntXeun7thqbNwpDO7++SYjijrSQGS0iJQZbfLn6QTBVK8OeSG2Om4DBAxvle5ct6MmiyQaOBeFk0NAOEZMdK4UWiuUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744147894; c=relaxed/simple;
	bh=AGINcubrwDHhNZhMG/5qRMWHfMGWmK7tdHB0j9/zR7Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ozMBgIsPu7jNmLWE6KfkQ0imwFEqcOx7nYssMEBJSKgdyJ3nT+CU4ja0iHk2uGvXyQafCxXaEFlPX8fWEpIgjkG6UWjnW4aSF6yse3j1rRapnmvVa5uH7FwV9NaimkNVd0P0HDknXF7Vbfgqto6SuFLdZQWPrAZ9PgqXA9CKtYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=epboGODE; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2240a960f9cso59954135ad.0
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 14:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744147891; x=1744752691; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Uam7GnobKmUw9hclFkCECYy0gTHPZztonbEuBIMruls=;
        b=epboGODEtejbTq808AoYZkSeJOmKndRR55CtUpMKYvSuAV1uwuuhKJgEu7y0BZpQrm
         qKFGAGlMmcecP7SWcsZzgBhgEhIOmE7L/mwSEQ2E5rrHPGiBN6gN4TiXEtStbvW+aFnG
         uKHKs0ydVBtWePN8yLGfnhq1/6i08jy9qD4YL9dUv7gOUS21txxqv4mvqar7adl6xqr9
         AG92WdjANekKLYwmw31w1Wv8MGbu9n2mS2GyeeCHMXgHj1y82VJtFpYf52uPLMZRqVxG
         fVBnDY7Wap//42gwbZ1TnNqao26iEjTvknAbNLGvbHxnwJxmtgo9j8YDDDQHFD/thwOF
         FaAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744147891; x=1744752691;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uam7GnobKmUw9hclFkCECYy0gTHPZztonbEuBIMruls=;
        b=XhVmhQ3mDVzB3fC5b8EzhsvcuJpEojsg05cDzJLz0ZQJ2gbje6PTkW8LbkDRgeUywx
         fOcYbyNIAbLf8m/FsNjRkos/g+Q1SPfWaRa7MOGh0tC9tknpKP2+23xhuVcZytPCIQE8
         5aH78BCdqZIDByarGBho+7z69FPq6rD7rSQg5pIhyeT32RxWJsRtNmc3VjLQ7J4ymxvc
         is/RoVZU89VdYTw9zG/rBPLLyuRVGnAzsVz+Gfx4EaH4Gg3gj3jd2+MP+9MngLsAfcSZ
         5zaw7eZkqIfiLjdbsyZ6hKQoZhC0O7zW/2shGVXRpTRbQCaNKtS4TvtvECUVGX+wZcCs
         K4ww==
X-Forwarded-Encrypted: i=1; AJvYcCUhrdqLp1jMM+iLsCx1tnLd9UotfqVm0p0JhBucsr3Uf+4StoiR9oEkjaqfTt8cLIgiblc=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywwn04UKrDejTdjVJInLRahNdwMpXgiUPvTlUdOw5Nnh+SshN4S
	jpCWnAbWLX5aY2/zWJeXZrbLV1zJ4FwPxNOm1ccGYt6FG8+GfeJT/5ZVdKgQW7D15QKTOCRYYq5
	4Vw==
X-Google-Smtp-Source: AGHT+IEKRdfCo7P0dOM9nLMdnn/wJxKiZkQkp2kalAXi+Af3MMzb50Othlo0RizKEkwtKlr8YY3PKqUJQ1s=
X-Received: from pfbfc24.prod.google.com ([2002:a05:6a00:2e18:b0:730:7e2d:df69])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ccc8:b0:227:e7c7:d451
 with SMTP id d9443c01a7336-22ac3f9a8fcmr4363085ad.29.1744147891223; Tue, 08
 Apr 2025 14:31:31 -0700 (PDT)
Date: Tue, 8 Apr 2025 14:31:29 -0700
In-Reply-To: <4c396e79-845a-481a-8a3e-4a7f458371b8@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com> <20250404193923.1413163-66-seanjc@google.com>
 <4c396e79-845a-481a-8a3e-4a7f458371b8@redhat.com>
Message-ID: <Z_WVsZQbY23XrhAG@google.com>
Subject: Re: [PATCH 65/67] KVM: SVM: Generate GA log IRQs only if the
 associated vCPUs is blocking
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Joao Martins <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 08, 2025, Paolo Bonzini wrote:
> On 4/4/25 21:39, Sean Christopherson wrote:
> > @@ -892,7 +893,7 @@ static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool toggle_avic)
> >   	WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
> > -	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, toggle_avic);
> > +	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, toggle_avic, false);
> >   	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
> >   }
> > @@ -912,7 +913,8 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >   	__avic_vcpu_load(vcpu, cpu, false);
> >   }
> > -static void __avic_vcpu_put(struct kvm_vcpu *vcpu, bool toggle_avic)
> > +static void __avic_vcpu_put(struct kvm_vcpu *vcpu, bool toggle_avic,
> > +			    bool is_blocking)
> 
> What would it look like to use an enum { SCHED_OUT, SCHED_IN, ENABLE_AVIC,
> DISABLE_AVIC, START_BLOCKING } for both __avic_vcpu_put and
> __avic_vcpu_load's second argument?

There's gotta be a way to make it look better than this code.  I gave a half-
hearted attempt at using an enum before posting, but wasn't able to come up with
anything decent.

Coming back to it with fresh eyes, what about this (full on-top diff below)?

enum avic_vcpu_action {
	AVIC_SCHED_IN		= 0,
	AVIC_SCHED_OUT		= 0,
	AVIC_START_BLOCKING	= BIT(0),

	AVIC_TOGGLE_ON_OFF	= BIT(1),
	AVIC_ACTIVATE		= AVIC_TOGGLE_ON_OFF,
	AVIC_DEACTIVATE		= AVIC_TOGGLE_ON_OFF,
};

AVIC_SCHED_IN and AVIC_SCHED_OUT are essentially syntactic sugar, as are
AVIC_ACTIVATE and AVIC_DEACTIVATE to a certain extent.  But it's much better than
booleans, and using a bitmask makes avic_update_iommu_vcpu_affinity() slightly
prettier.

> Consecutive bools are ugly...

Yeah, I hated it when I wrote it, and still hate it now.

And more error prone, e.g. the __avic_vcpu_put() call from avic_refresh_apicv_exec_ctrl()
should specify is_blocking=false, not true, as kvm_x86_ops.refresh_apicv_exec_ctrl()
should never be called while the vCPU is blocking.

---
 arch/x86/kvm/svm/avic.c | 41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 425674e1a04c..1752420c68aa 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -833,9 +833,20 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	return irq_set_vcpu_affinity(host_irq, NULL);
 }
 
+enum avic_vcpu_action {
+	AVIC_SCHED_IN		= 0,
+	AVIC_SCHED_OUT		= 0,
+	AVIC_START_BLOCKING	= BIT(0),
+
+	AVIC_TOGGLE_ON_OFF	= BIT(1),
+	AVIC_ACTIVATE		= AVIC_TOGGLE_ON_OFF,
+	AVIC_DEACTIVATE		= AVIC_TOGGLE_ON_OFF,
+};
+
 static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu,
-					    bool toggle_avic, bool ga_log_intr)
+					    enum avic_vcpu_action action)
 {
+	bool ga_log_intr = (action & AVIC_START_BLOCKING);
 	struct amd_svm_iommu_ir *ir;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -849,7 +860,7 @@ static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu,
 		return;
 
 	list_for_each_entry(ir, &svm->ir_list, node) {
-		if (!toggle_avic)
+		if (!(action & AVIC_TOGGLE_ON_OFF))
 			WARN_ON_ONCE(amd_iommu_update_ga(ir->data, cpu, ga_log_intr));
 		else if (cpu >= 0)
 			WARN_ON_ONCE(amd_iommu_activate_guest_mode(ir->data, cpu, ga_log_intr));
@@ -858,7 +869,8 @@ static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu,
 	}
 }
 
-static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool toggle_avic)
+static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu,
+			     enum avic_vcpu_action action)
 {
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
@@ -904,7 +916,7 @@ static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool toggle_avic)
 
 	WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
 
-	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, toggle_avic, false);
+	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, action);
 
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 }
@@ -921,11 +933,10 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (kvm_vcpu_is_blocking(vcpu))
 		return;
 
-	__avic_vcpu_load(vcpu, cpu, false);
+	__avic_vcpu_load(vcpu, cpu, AVIC_SCHED_IN);
 }
 
-static void __avic_vcpu_put(struct kvm_vcpu *vcpu, bool toggle_avic,
-			    bool is_blocking)
+static void __avic_vcpu_put(struct kvm_vcpu *vcpu, enum avic_vcpu_action action)
 {
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -947,7 +958,7 @@ static void __avic_vcpu_put(struct kvm_vcpu *vcpu, bool toggle_avic,
 	 */
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
 
-	avic_update_iommu_vcpu_affinity(vcpu, -1, toggle_avic, is_blocking);
+	avic_update_iommu_vcpu_affinity(vcpu, -1, action);
 
 	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR);
 
@@ -964,7 +975,7 @@ static void __avic_vcpu_put(struct kvm_vcpu *vcpu, bool toggle_avic,
 	 * Note!  Don't set AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR in the table as
 	 * it's a synthetic flag that usurps an unused a should-be-zero bit.
 	 */
-	if (is_blocking)
+	if (action & AVIC_START_BLOCKING)
 		entry |= AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR;
 
 	svm->avic_physical_id_entry = entry;
@@ -992,7 +1003,8 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 			return;
 	}
 
-	__avic_vcpu_put(vcpu, false, kvm_vcpu_is_blocking(vcpu));
+	__avic_vcpu_put(vcpu, kvm_vcpu_is_blocking(vcpu) ? AVIC_START_BLOCKING :
+							   AVIC_SCHED_OUT);
 }
 
 void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)
@@ -1024,12 +1036,15 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 	if (!enable_apicv)
 		return;
 
+	/* APICv should only be toggled on/off while the vCPU is running. */
+	WARN_ON_ONCE(kvm_vcpu_is_blocking(vcpu));
+
 	avic_refresh_virtual_apic_mode(vcpu);
 
 	if (kvm_vcpu_apicv_active(vcpu))
-		__avic_vcpu_load(vcpu, vcpu->cpu, true);
+		__avic_vcpu_load(vcpu, vcpu->cpu, AVIC_ACTIVATE);
 	else
-		__avic_vcpu_put(vcpu, true, true);
+		__avic_vcpu_put(vcpu, AVIC_DEACTIVATE);
 }
 
 void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
@@ -1055,7 +1070,7 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
 	 * CPU and cause noisy neighbor problems if the VM is sending interrupts
 	 * to the vCPU while it's scheduled out.
 	 */
-	__avic_vcpu_put(vcpu, false, true);
+	__avic_vcpu_put(vcpu, AVIC_START_BLOCKING);
 }
 
 void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)

base-commit: fe5b44cf46d5444ff071bc2373fbe7b109a3f60b
-- 

