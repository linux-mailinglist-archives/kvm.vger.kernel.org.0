Return-Path: <kvm+bounces-42749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53854A7C420
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:50:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3DD63B4E36
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:50:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00258253B66;
	Fri,  4 Apr 2025 19:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OEwTvkn7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2C02528FD
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795699; cv=none; b=h6G7oQHhUYpTqOtCC4CGXzdlIpi7Tb7zk8XgH5O75+EnyIVleef/ckG7EV/ET/YbPjKk8VSMD7sZkWHnSlPOisAh3y4DjQYcGujb+C/ujb7jMtrDYLFvHedgJ4TuBwfUMC4A61oy6K4Gqh6YaRjoNLRnh+i69DPbs5ZqtRmd0gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795699; c=relaxed/simple;
	bh=XeOgBYSVftBtJy/M3mgh+l9BlLK/PoI1PFhoIB5PCXs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kzGuVqbfWvTlCYkQUIeymaqVZmOzxDB6eSrDoifsOBUIV8n+rXwgtqCpQ9/YakhNlxHQAhDhjjZt/yh3P0+jpAfh2D1eWxYeZm3G+fisyYZL/B+QogDxIktzZQZHjWvHws3fcn9JDfeCEtu2BhLcMdBhM2cDYKOLUFyTp6XJLyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OEwTvkn7; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736b431ee0dso1964199b3a.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795695; x=1744400495; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gDdOE96/ndlhSLSZ4xilIdGO5S14+if5sDDWyRab2v0=;
        b=OEwTvkn78vyydATz8/iiEiX0FjIzhOOTEOiVrRSDPgS6lM0io8KwAnCXqufS4MEOb4
         yxBjY72ZGUYYGX/WmWxlWEQ2W7DqyOmBBUdwEaPPrZall9bJ8xPx3Hr9E/RSonqw4XER
         Ifm/I+31coqI7QyRLqbcIsv8xYddGtGRt3Z0nnBFtK5qyIzV6ARQ7x2bjvaoq1y4qvSU
         LUKLiMVSaDg3lhcl+4HtipvyeNKJsPqnD3lQYOq4izMYHZzb5tcxzY1OdXp0TfjPy0xn
         Uc8YqrVoo84V7FJEI14+yn492vj75Vv+Fw2ArblzweVAgTIDN1Rg+qknexQWLbR8x6Z1
         00zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795695; x=1744400495;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gDdOE96/ndlhSLSZ4xilIdGO5S14+if5sDDWyRab2v0=;
        b=o1VTWb35dbBoFbStBPsvvLY6y83NyafYib3Y7udsAHKryxvKz5fVudoP3Fs2UzrTnm
         jif1D54tvMx2GgBTtiBoW5tpasjciERXwlGt3Q63IX4Z9alisaD/Y+g6Kcx1z9zwQnv4
         OJGooiEimCq+M5ELR7iosVu+337y+MhbArqmiDfi/IY69/FQjLxQZx1NdrC/IX+Fq+in
         YYKz7EAJepZOLNkq1/9IWeQsXwieI0hOJmRnV48ixi0rdLIulblqtbZ7BYGwxXSAAThP
         qeIZNX8wXZQwaIBN9MTvUtCPPB20IbnykkBuuYDFCLr5mFWXQ71fQnXItZLOs8nXwQ1h
         LyJQ==
X-Gm-Message-State: AOJu0YwKXB0qg+hT/BWnKq+ncywFj42dFyEumTBoQJfkae0dmyESZ4QV
	jBrX/UxJ1BHuMdq6T81bubohSAdVeeDKni6ow1ezrDWHH/i/DRnf992Y62wiT6quqyFAmyr29zZ
	Izg==
X-Google-Smtp-Source: AGHT+IGBe+lm54I+yMwAzZHJq8Q74YtEHX3DjuXO0rhTwsnSv0p1gLbz4L+6vCz0PER0l1cbP14ndaZf4xw=
X-Received: from pfjq14.prod.google.com ([2002:a05:6a00:88e:b0:736:b2a2:5bfe])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2d24:b0:1f3:293b:7aa
 with SMTP id adf61e73a8af0-2010447cc25mr7173734637.4.1743795695588; Fri, 04
 Apr 2025 12:41:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:39:18 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-64-seanjc@google.com>
Subject: [PATCH 63/67] KVM: SVM: Consolidate IRTE update when toggling AVIC on/off
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Fold the IRTE modification logic in avic_refresh_apicv_exec_ctrl() into
__avic_vcpu_{load,put}(), and add a param to the helpers to communicate
whether or not AVIC is being toggled, i.e. if IRTE needs a "full" update,
or just a quick update to set the CPU and IsRun.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 55 ++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index d5fa915d0827..c896f00f901c 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -820,7 +820,8 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	return irq_set_vcpu_affinity(host_irq, NULL);
 }
 
-static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu)
+static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu,
+					    bool toggle_avic)
 {
 	struct amd_svm_iommu_ir *ir;
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -834,11 +835,17 @@ static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu)
 	if (list_empty(&svm->ir_list))
 		return;
 
-	list_for_each_entry(ir, &svm->ir_list, node)
-		WARN_ON_ONCE(amd_iommu_update_ga(cpu, ir->data));
+	list_for_each_entry(ir, &svm->ir_list, node) {
+		if (!toggle_avic)
+			WARN_ON_ONCE(amd_iommu_update_ga(cpu, ir->data));
+		else if (cpu >= 0)
+			WARN_ON_ONCE(amd_iommu_activate_guest_mode(ir->data, cpu));
+		else
+			WARN_ON_ONCE(amd_iommu_deactivate_guest_mode(ir->data));
+	}
 }
 
-static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool toggle_avic)
 {
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
@@ -883,7 +890,7 @@ static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
 
-	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id);
+	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, toggle_avic);
 
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 }
@@ -900,10 +907,10 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (kvm_vcpu_is_blocking(vcpu))
 		return;
 
-	__avic_vcpu_load(vcpu, cpu);
+	__avic_vcpu_load(vcpu, cpu, false);
 }
 
-static void __avic_vcpu_put(struct kvm_vcpu *vcpu)
+static void __avic_vcpu_put(struct kvm_vcpu *vcpu, bool toggle_avic)
 {
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -925,7 +932,7 @@ static void __avic_vcpu_put(struct kvm_vcpu *vcpu)
 	 */
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
 
-	avic_update_iommu_vcpu_affinity(vcpu, -1);
+	avic_update_iommu_vcpu_affinity(vcpu, -1, toggle_avic);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 	svm->avic_physical_id_entry = entry;
@@ -951,7 +958,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
 		return;
 
-	__avic_vcpu_put(vcpu);
+	__avic_vcpu_put(vcpu, false);
 }
 
 void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)
@@ -980,39 +987,15 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)
 
 void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
-	bool activated = kvm_vcpu_apicv_active(vcpu);
-	int apic_id = kvm_cpu_get_apicid(vcpu->cpu);
-	struct vcpu_svm *svm = to_svm(vcpu);
-	struct amd_svm_iommu_ir *ir;
-	unsigned long flags;
-
 	if (!enable_apicv)
 		return;
 
 	avic_refresh_virtual_apic_mode(vcpu);
 
-	if (activated)
-		__avic_vcpu_load(vcpu, vcpu->cpu);
+	if (kvm_vcpu_apicv_active(vcpu))
+		__avic_vcpu_load(vcpu, vcpu->cpu, true);
 	else
-		__avic_vcpu_put(vcpu);
-
-	/*
-	 * Here, we go through the per-vcpu ir_list to update all existing
-	 * interrupt remapping table entry targeting this vcpu.
-	 */
-	spin_lock_irqsave(&svm->ir_list_lock, flags);
-
-	if (list_empty(&svm->ir_list))
-		goto out;
-
-	list_for_each_entry(ir, &svm->ir_list, node) {
-		if (activated)
-			WARN_ON_ONCE(amd_iommu_activate_guest_mode(ir->data, apic_id));
-		else
-			WARN_ON_ONCE(amd_iommu_deactivate_guest_mode(ir->data));
-	}
-out:
-	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
+		__avic_vcpu_put(vcpu, true);
 }
 
 void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
-- 
2.49.0.504.g3bcea36a83-goog


