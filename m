Return-Path: <kvm+bounces-47507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BDBCAC197A
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:16:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B26B17E7A8
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:16:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7987F2DBFF2;
	Fri, 23 May 2025 01:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qkt6KdnX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337C827145D
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962110; cv=none; b=cAxBjY60C/yOS/4Vgup2WxtRR7JJSVDYVNKqEEsBiUd4+CUYgz1nk4rJGphZOajKDJbbTU1nfTKHqWmU3UmpLANFzH0KlQmhAHakcVihF6cMo/VKNBdLMfeeEsTUnDeTQC1hZGL5ZWEM5LO8XvOh/veknBBhXUu05Kz1rmbO0Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962110; c=relaxed/simple;
	bh=cgx/76xcA3zklybCr4c/hJY0siLMm57qoWAoljueJzg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IZDa9PMLlsqldbsgxjC/j4aJ8CI5JO+NtebismU403k02W3DziGx+52XFDXiQaPakJ/vMUAvTusfDP+RjtvoJrBiRgbqU9THoIJzRjJxX+qTK+4ecQatx7kHQjI0s+ugPwok7DCTCbfSi8c7jtFVrHmdjBO+u/oMKnzkIZbtzNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qkt6KdnX; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3dc78d55321so48564985ab.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962106; x=1748566906; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GOvRUDhf6WzZUhQYcj+S2GSmTkywb2uxqC7sAPGcWlY=;
        b=qkt6KdnXHJl/RZvfvOu+wT8fiteY2bdIDh87JbYbHNUtNzzoznJYGS99mQM7RCJBQH
         Z+GC6LMMg8BZNEgXwIDYFk/hdR05djv9LYnGUL5X5mV33ymPbCxdI6L1DVGvmUORdrQp
         w+Wtpx8vimTaI+if5C+xR9ceRe1rmHn3enVhleS2LQO+xtoT6chDSZLq9dy6uZPZik+5
         oeNEvCIwLDWvUXoJslDJ4cfg9kaTAr1LihisQ9Z0Vi7GRRtxCcz4TgUBxMLh+rkViqq6
         k84hhok+oQbSl3s54mCZYzUTQNcjYaMIpzClyv8AwqXk37Mj1beNfMjZcNwnUKJ0yfug
         KbAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962106; x=1748566906;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GOvRUDhf6WzZUhQYcj+S2GSmTkywb2uxqC7sAPGcWlY=;
        b=M3dAi3rrCc0ojspwK0cnvBqZiIez3+dFsrjkT6hFiNpxEAWzVVSJqmm3q9oMWBMnan
         jcQ7z0TQBStkuGZKa3b/pzCeLqcCqV/7BeIHxHtgDEaf4nNrdyiKZi5t5vZGQT3bPvv2
         KEK69gTAQvZI13iwjGE5NPbJiSHH/CKamDxvSRSGbeE24RhJir1E94shAPzKp1NngB3b
         t//lo9sOnCap9Me2x/dJXqqT+goVMyW6bZrXOO4tb5+fgcbW81YlYULUu8eJPE/e4BQ4
         7MmsLAeykcf25BxvMLpXpsLMe+PcLq8C1LuU1CVZzaq0buF/SuT70V5xkE43UFyDQfHS
         sN0Q==
X-Gm-Message-State: AOJu0Yze/ltZ7dJuaD75boYfDlYlXU78mVFeo9V9VcxvpQbFrlXmhiZ4
	Molhh8zfEr242BUs1bUYL4ngLsjl6KOag/wreLrBL90cWuwPhJm7hIss1ToYZ0e0Al2IZIFgpYL
	h+To6/w==
X-Google-Smtp-Source: AGHT+IFDHkcBTdgDBcf9RfdN3IcCGgtfCXkYoLUg7YY7Kt3b/82DHTKb51w7MjiVGEMAMdbOkvSZTJ677AI=
X-Received: from pjbsb7.prod.google.com ([2002:a17:90b:50c7:b0:30e:6bb2:6855])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6e02:743:b0:3dc:8c4e:2b8b
 with SMTP id e9e14a558f8ab-3dc8c4e2c10mr58843225ab.8.1747962106431; Thu, 22
 May 2025 18:01:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 18:00:02 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-58-seanjc@google.com>
Subject: [PATCH v2 57/59] KVM: SVM: Consolidate IRTE update when toggling AVIC on/off
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Fold the IRTE modification logic in avic_refresh_apicv_exec_ctrl() into
__avic_vcpu_{load,put}(), and add a param to the helpers to communicate
whether or not AVIC is being toggled, i.e. if IRTE needs a "full" update,
or just a quick update to set the CPU and IsRun.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 85 ++++++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 1e6e5d1f6b4e..2e47559a4134 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -810,7 +810,28 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	return irq_set_vcpu_affinity(host_irq, NULL);
 }
 
-static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu)
+enum avic_vcpu_action {
+	/*
+	 * There is no need to differentiate between activate and deactivate,
+	 * as KVM only refreshes AVIC state when the vCPU is scheduled in and
+	 * isn't blocking, i.e. the pCPU must always be (in)valid when AVIC is
+	 * being (de)activated.
+	 */
+	AVIC_TOGGLE_ON_OFF	= BIT(0),
+	AVIC_ACTIVATE		= AVIC_TOGGLE_ON_OFF,
+	AVIC_DEACTIVATE		= AVIC_TOGGLE_ON_OFF,
+
+	/*
+	 * No unique action is required to deal with a vCPU that stops/starts
+	 * running, as IRTEs are configured to generate GALog interrupts at all
+	 * times.
+	 */
+	AVIC_START_RUNNING	= 0,
+	AVIC_STOP_RUNNING	= 0,
+};
+
+static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu,
+					    enum avic_vcpu_action action)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_kernel_irqfd *irqfd;
@@ -824,11 +845,20 @@ static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu)
 	if (list_empty(&svm->ir_list))
 		return;
 
-	list_for_each_entry(irqfd, &svm->ir_list, vcpu_list)
-		WARN_ON_ONCE(amd_iommu_update_ga(cpu, irqfd->irq_bypass_data));
+	list_for_each_entry(irqfd, &svm->ir_list, vcpu_list) {
+		void *data = irqfd->irq_bypass_data;
+
+		if (!(action & AVIC_TOGGLE_ON_OFF))
+			WARN_ON_ONCE(amd_iommu_update_ga(cpu, data));
+		else if (cpu >= 0)
+			WARN_ON_ONCE(amd_iommu_activate_guest_mode(data, cpu));
+		else
+			WARN_ON_ONCE(amd_iommu_deactivate_guest_mode(data));
+	}
 }
 
-static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu,
+			     enum avic_vcpu_action action)
 {
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
@@ -873,7 +903,7 @@ static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
 
-	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id);
+	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, action);
 
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 }
@@ -890,10 +920,10 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (kvm_vcpu_is_blocking(vcpu))
 		return;
 
-	__avic_vcpu_load(vcpu, cpu);
+	__avic_vcpu_load(vcpu, cpu, AVIC_START_RUNNING);
 }
 
-static void __avic_vcpu_put(struct kvm_vcpu *vcpu)
+static void __avic_vcpu_put(struct kvm_vcpu *vcpu, enum avic_vcpu_action action)
 {
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -915,7 +945,7 @@ static void __avic_vcpu_put(struct kvm_vcpu *vcpu)
 	 */
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
 
-	avic_update_iommu_vcpu_affinity(vcpu, -1);
+	avic_update_iommu_vcpu_affinity(vcpu, -1, action);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 	svm->avic_physical_id_entry = entry;
@@ -941,7 +971,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
 		return;
 
-	__avic_vcpu_put(vcpu);
+	__avic_vcpu_put(vcpu, AVIC_STOP_RUNNING);
 }
 
 void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)
@@ -970,41 +1000,18 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)
 
 void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
-	bool activated = kvm_vcpu_apicv_active(vcpu);
-	int apic_id = kvm_cpu_get_apicid(vcpu->cpu);
-	struct vcpu_svm *svm = to_svm(vcpu);
-	struct kvm_kernel_irqfd *irqfd;
-	unsigned long flags;
-
 	if (!enable_apicv)
 		return;
 
+	/* APICv should only be toggled on/off while the vCPU is running. */
+	WARN_ON_ONCE(kvm_vcpu_is_blocking(vcpu));
+
 	avic_refresh_virtual_apic_mode(vcpu);
 
-	if (activated)
-		__avic_vcpu_load(vcpu, vcpu->cpu);
+	if (kvm_vcpu_apicv_active(vcpu))
+		__avic_vcpu_load(vcpu, vcpu->cpu, AVIC_ACTIVATE);
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
-	list_for_each_entry(irqfd, &svm->ir_list, vcpu_list) {
-		void *data = irqfd->irq_bypass_data;
-
-		if (activated)
-			WARN_ON_ONCE(amd_iommu_activate_guest_mode(data, apic_id));
-		else
-			WARN_ON_ONCE(amd_iommu_deactivate_guest_mode(data));
-	}
-out:
-	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
+		__avic_vcpu_put(vcpu, AVIC_DEACTIVATE);
 }
 
 void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
@@ -1030,7 +1037,7 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
 	 * CPU and cause noisy neighbor problems if the VM is sending interrupts
 	 * to the vCPU while it's scheduled out.
 	 */
-	avic_vcpu_put(vcpu);
+	__avic_vcpu_put(vcpu, AVIC_STOP_RUNNING);
 }
 
 void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
-- 
2.49.0.1151.ga128411c76-goog


