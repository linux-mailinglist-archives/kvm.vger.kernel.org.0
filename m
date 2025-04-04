Return-Path: <kvm+bounces-42751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAB29A7C426
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:51:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 820DC1732A6
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:50:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 793D5253F36;
	Fri,  4 Apr 2025 19:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k4iZ8UZf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A6D253B5F
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795701; cv=none; b=RwBiUVh9KLdjBUaKqPu3bBT+bcDpqYIpcjBwcC9Sdzb1vP8pNDfkfp7TzJiSQq38U/9TpGe2JFfwDY5Mmx+b89QDYN2t+OWSG2sYBFPizY0ZlCiB+fPOkE75QxZyzgNSEwcaVJOzKTTLehWNSHJpvSUDsR4Vkrc5VI5KWpqoUsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795701; c=relaxed/simple;
	bh=Sb4bsa6vo9IYveps+nL7XukC6432K1ulPMRWWP6K8jc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G2N1M1AiF2wqFpwBgCuP7INkesOrky2gXym8sSGi7WJreYpKHVdvFaovq2HEhWoVs21ALpyo6Kkj9qwlVbdn/ZCxmZCsWg4Ggw26rtYgYYjKzSe8ZOaRa/o/asn6bF+vU7qE16Jo2U8NNvgQoZifjAoRTB7qXnHd7yeu5696HGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k4iZ8UZf; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-73691c75863so2948465b3a.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795699; x=1744400499; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xa2Ve4DPvmz0R4op/e/h5NsuopJcYdvF3WY5dpywXT4=;
        b=k4iZ8UZfVj3zLvO1UaZK2JSqoK2ZWIpmUKwEWOVKD2npRm0W44t066vIIJjr9/sbjX
         XRoJxyLH5l9P5fT+gMWsYgvnM/a2LAiRhvs8GkGtt3DTCTC+C5+/Sp3bU4tbJLeKmbqk
         BsjUApDCDjD872P6jmlBobuMWgI6PQzHnjn92tN96Xryg8AkxtdsZAwnUgGSwvpLR+C2
         QwusmiWAxjSH6hDHSjCWkN8Zk1J9xBQBbacGnbxs30rF9mb9TcsTgmQ6gI7MdScuvlbj
         R0O5IZWdPrGr9PDA6gV2LxEslJIr3JS3R1EkwtgHxnVzW9GB4yeJLVQioU5LbDCm8zlY
         R45g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795699; x=1744400499;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xa2Ve4DPvmz0R4op/e/h5NsuopJcYdvF3WY5dpywXT4=;
        b=M4fvnP4aBw8pLdB6CKu5d9alJknjB55F7Ar5QSdeCeN1XOf1UUfRwKOhsnolrOSsGe
         Jqi0DTmXyZXKVF0MeAVdr6q5L5lztZkH8XIEtcLyCSik+83ve/KZ04iePRWKpiarR2OW
         w8+SW33TfHc7HPxI2V7xJKZbtwptoBfOKX+rID9WOh9HO1sDGK4T10yOQnBeXiHQPNix
         uixSwZjZ78bNHbmRoDRZ0dVBqv6ivd28wLoUXJ+yCrOcVvkMxexKYtMlcdSJkEVZumml
         qdbUCrqMLUG1dSLzJ1xriKd3UrTW0mcoyCyxU7NxIcyZJpzej2wn1i3ACWVUi/k5hpNi
         yfwQ==
X-Gm-Message-State: AOJu0YyZu2RfZjJflHvnVVSqdD0wWsRNDFHAef4of38aHJ9D+5fponGY
	icnP9VEtdIozZp1vPqFsWEKXxj9IjNFPKoNB4pRqKlZdXsb5N+7eI9ioprqgDtIJpAo7lW10yKu
	ldA==
X-Google-Smtp-Source: AGHT+IGYu/yYBkSf+6Tq2bLTJpJywO70pYjALzEs/kBx6J6iNAtgjLKV0RF85EP9hys6qFZmYCGLhDM/+UY=
X-Received: from pfbho2.prod.google.com ([2002:a05:6a00:8802:b0:736:b315:f15e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:10ce:b0:736:5b85:a911
 with SMTP id d2e1a72fcca58-739e6ff6b96mr5876430b3a.8.1743795699069; Fri, 04
 Apr 2025 12:41:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:39:20 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-66-seanjc@google.com>
Subject: [PATCH 65/67] KVM: SVM: Generate GA log IRQs only if the associated
 vCPUs is blocking
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Configure IRTEs to GA log interrupts for device posted IRQs that hit
non-running vCPUs if and only if the target vCPU is blocking, i.e.
actually needs a wake event.  If the vCPU has exited to userspace or was
preempted, generating GA log entries and interrupts is wasteful and
unnecessary, as the vCPU will be re-loaded and/or scheduled back in
irrespective of the GA log notification (avic_ga_log_notifier() is just a
fancy wrapper for kvm_vcpu_wake_up()).

Use a should-be-zero bit in the vCPU's Physical APIC ID Table Entry to
track whether or not the vCPU's associated IRTEs are configured to
generate GA logs, but only set the synthetic bit in KVM's "cache", i.e.
never set the should-be-zero bit in tables that are used by hardware.
Use a synthetic bit instead of a dedicated boolean to minimize the odds
of messing up the locking, i.e. so that all the existing rules that apply
to avic_physical_id_entry for IS_RUNNING are reused verbatim for
GA_LOG_INTR.

Note, because KVM (by design) "puts" AVIC state in a "pre-blocking"
phase, using kvm_vcpu_is_blocking() to track the need for notifications
isn't a viable option.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/svm.h |  7 ++++++
 arch/x86/kvm/svm/avic.c    | 49 +++++++++++++++++++++++++++-----------
 2 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 8b07939ef3b9..be6e833bf92c 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -246,6 +246,13 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
 #define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
 
+/*
+ * GA_LOG_INTR is a synthetic flag that's never propagated to hardware-visible
+ * tables.  GA_LOG_INTR is set if the vCPU needs device posted IRQs to generate
+ * GA log interrupts to wake the vCPU (because it's blocking or about to block).
+ */
+#define AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR		BIT_ULL(61)
+
 #define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	GENMASK_ULL(11, 0)
 #define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	GENMASK_ULL(51, 12)
 #define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 1466e66cca6c..0d2a17a74be6 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -798,7 +798,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			pi_data.cpu = entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
 		} else {
 			pi_data.cpu = -1;
-			pi_data.ga_log_intr = true;
+			pi_data.ga_log_intr = entry & AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR;
 		}
 
 		ret = irq_set_vcpu_affinity(host_irq, &pi_data);
@@ -823,7 +823,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 }
 
 static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu,
-					    bool toggle_avic)
+					    bool toggle_avic, bool ga_log_intr)
 {
 	struct amd_svm_iommu_ir *ir;
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -839,9 +839,9 @@ static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu,
 
 	list_for_each_entry(ir, &svm->ir_list, node) {
 		if (!toggle_avic)
-			WARN_ON_ONCE(amd_iommu_update_ga(ir->data, cpu, true));
+			WARN_ON_ONCE(amd_iommu_update_ga(ir->data, cpu, ga_log_intr));
 		else if (cpu >= 0)
-			WARN_ON_ONCE(amd_iommu_activate_guest_mode(ir->data, cpu, true));
+			WARN_ON_ONCE(amd_iommu_activate_guest_mode(ir->data, cpu, ga_log_intr));
 		else
 			WARN_ON_ONCE(amd_iommu_deactivate_guest_mode(ir->data));
 	}
@@ -875,7 +875,8 @@ static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool toggle_avic)
 	entry = svm->avic_physical_id_entry;
 	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
-	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
+	entry &= ~(AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK |
+		   AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR);
 	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
 	entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 
@@ -892,7 +893,7 @@ static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool toggle_avic)
 
 	WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
 
-	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, toggle_avic);
+	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, toggle_avic, false);
 
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 }
@@ -912,7 +913,8 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	__avic_vcpu_load(vcpu, cpu, false);
 }
 
-static void __avic_vcpu_put(struct kvm_vcpu *vcpu, bool toggle_avic)
+static void __avic_vcpu_put(struct kvm_vcpu *vcpu, bool toggle_avic,
+			    bool is_blocking)
 {
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -934,14 +936,28 @@ static void __avic_vcpu_put(struct kvm_vcpu *vcpu, bool toggle_avic)
 	 */
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
 
-	avic_update_iommu_vcpu_affinity(vcpu, -1, toggle_avic);
+	avic_update_iommu_vcpu_affinity(vcpu, -1, toggle_avic, is_blocking);
 
+	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR);
+
+	/*
+	 * Keep the previouv APIC ID in the entry so that a rogue doorbell from
+	 * hardware is at least restricted to a CPU associated with the vCPU.
+	 */
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
-	svm->avic_physical_id_entry = entry;
 
 	if (enable_ipiv)
 		WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
 
+	/*
+	 * Note!  Don't set AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR in the table as
+	 * it's a synthetic flag that usurps an unused a should-be-zero bit.
+	 */
+	if (is_blocking)
+		entry |= AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR;
+
+	svm->avic_physical_id_entry = entry;
+
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 }
 
@@ -957,10 +973,15 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	u64 entry = to_svm(vcpu)->avic_physical_id_entry;
 
 	/* Nothing to do if IsRunning == '0' due to vCPU blocking. */
-	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
-		return;
+	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)) {
+		if (WARN_ON_ONCE(!kvm_vcpu_is_blocking(vcpu)))
+			return;
 
-	__avic_vcpu_put(vcpu, false);
+		if (!(WARN_ON_ONCE(!(entry & AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR))))
+			return;
+	}
+
+	__avic_vcpu_put(vcpu, false, kvm_vcpu_is_blocking(vcpu));
 }
 
 void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)
@@ -997,7 +1018,7 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 	if (kvm_vcpu_apicv_active(vcpu))
 		__avic_vcpu_load(vcpu, vcpu->cpu, true);
 	else
-		__avic_vcpu_put(vcpu, true);
+		__avic_vcpu_put(vcpu, true, true);
 }
 
 void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
@@ -1023,7 +1044,7 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
 	 * CPU and cause noisy neighbor problems if the VM is sending interrupts
 	 * to the vCPU while it's scheduled out.
 	 */
-	avic_vcpu_put(vcpu);
+	__avic_vcpu_put(vcpu, false, true);
 }
 
 void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
-- 
2.49.0.504.g3bcea36a83-goog


