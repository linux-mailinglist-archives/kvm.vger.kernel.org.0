Return-Path: <kvm+bounces-47509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 87283AC1985
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:17:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77FCF3A1FCD
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:16:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F052DBFEA;
	Fri, 23 May 2025 01:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k6trBw/h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668E02E62A8
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962112; cv=none; b=cEfk0x7uCsjq55AgTqWMRqD7WYDKgn31313ekVDW6UqYT2is1VkPFwm1e33LAtWlaBljpsSrH5qGTWpNbVK5dyBGJCLVgfKRMj1tinm7s3nrBw4VBz21t3FfjZlxsIkHmhM+pzOsf9mMyoUB2A9g7pvjJIyPyLwb/LkzxKZvalM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962112; c=relaxed/simple;
	bh=9KhTov6NigDBe98CfFfGcuC8nWRwinqRFBqUtK1H758=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XIc3f4fd3P4xhNVuPCFLhnoC+dht28GwuyTljxWMoJ1exefIYuzuOwUbGA7sQpDEVWarG3bifjfvobPWaj/Wa3wWgeOcoxA9w2q70KMBwkivolNSNEbstJbejBqo9MjET58MROGA/nor1uQFKvxkFfDgXYvk7xSf57iR/NBk2Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k6trBw/h; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3dc78d55321so48565365ab.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962109; x=1748566909; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=l2janC82c4esHYrjt7OIqyPO8MKzvHUx9JelC298Jlw=;
        b=k6trBw/hEMCMlw4Ji87RZRc5WITUyaquajlQ6mtVkuD+ZAtljAXXkaO9j176nnrZOn
         il/ptADyCObh2Wu1eJhBl1ioRb587cy/2GkZ6T2zKU24W7iFI66c/vzO5NuImlJvjc+S
         Wn184nidQHG5fVkxrFlHs2YQL31HOqDNbxWXW8Ig8bB5BrHQyFaNzRsjnE1HZaarufmc
         gbrqmZeVaCh+F1oJIqKSYrx6IuKk2sks+FBAmb7Zat/eqHzfragxVJI3ZhU5a78ZyyC5
         cUuSuwabEI/hobv6sfL8K4vPvNa6NLHVwyHXWfwHhGWRAMHO0ouH6oTHL3WPX6nbGfNh
         /mdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962109; x=1748566909;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l2janC82c4esHYrjt7OIqyPO8MKzvHUx9JelC298Jlw=;
        b=DUtzQ7n9ZmUrFWf4GqTdQ3mftgYrF5JtTThz0AY41m90kcnhD32DuS6v3dTUB+cVqm
         O1q2klk5cNtDy3yLa5dMQNsjaLDwtxC7+OZzVbF8lX6jVwfMD8Wa6VDLV6kORCjFhJhp
         NEOaeiBsJznKhFrJKYyoV4MF+yISNFBWnxQfcAjDsmshb6ENxUkDVJ7oDqmXgXnOSsW4
         3ynw5QMzugYO+VIu235+SMX1fnZxY7KLRc9RH7OUeXUblHyvO+3l7r+it+4KqSR5OLVm
         F2Dwitvbl2hgxoiKnDm9zcyCaVJy5VJ+HI/6Wolt1BCc748ksoyGu894/OgFjcH7dbz5
         AgnA==
X-Gm-Message-State: AOJu0YxhMAztpFpmzsox7IXefwu+KTI+NvjkXZZXqTuAtfHzdgujvTeI
	MUIZJbI/0BjONq/uEOepE9fAjzGr0JVFWUPIgZKduQmsB+F5MMLe2VhHEAVZKtDo4oG4JHphAun
	ifMnuCg==
X-Google-Smtp-Source: AGHT+IG7+QFXMaCOZGXhcLvVhEnNKLpzraqjuMbUJdLp1hOAQeSUFqqURcAYgABbsxGykvV+6E7RvJlYmzE=
X-Received: from pji12.prod.google.com ([2002:a17:90b:3fcc:b0:2f5:63a:4513])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6e02:743:b0:3dc:8c4e:2b8b
 with SMTP id e9e14a558f8ab-3dc8c4e2c10mr58846455ab.8.1747962109625; Thu, 22
 May 2025 18:01:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 18:00:04 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-60-seanjc@google.com>
Subject: [PATCH v2 59/59] KVM: SVM: Generate GA log IRQs only if the
 associated vCPUs is blocking
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
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
 arch/x86/include/asm/svm.h |  7 +++++
 arch/x86/kvm/svm/avic.c    | 63 ++++++++++++++++++++++++++++++--------
 2 files changed, 58 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 36f67c69ea66..ffc27f676243 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -252,6 +252,13 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
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
index e61ecc3514ea..e4e1d169577f 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -788,7 +788,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			pi_data.cpu = entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
 		} else {
 			pi_data.cpu = -1;
-			pi_data.ga_log_intr = true;
+			pi_data.ga_log_intr = entry & AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR;
 		}
 
 		ret = irq_set_vcpu_affinity(host_irq, &pi_data);
@@ -825,16 +825,25 @@ enum avic_vcpu_action {
 
 	/*
 	 * No unique action is required to deal with a vCPU that stops/starts
-	 * running, as IRTEs are configured to generate GALog interrupts at all
-	 * times.
+	 * running.  A vCPU that starts running by definition stops blocking as
+	 * well, and a vCPU that stops running can't have been blocking, i.e.
+	 * doesn't need to toggle GALogIntr.
 	 */
 	AVIC_START_RUNNING	= 0,
 	AVIC_STOP_RUNNING	= 0,
+
+	/*
+	 * When a vCPU starts blocking, KVM needs to set the GALogIntr flag
+	 * int all associated IRTEs so that KVM can wake the vCPU if an IRQ is
+	 * sent to the vCPU.
+	 */
+	AVIC_START_BLOCKING	= BIT(1),
 };
 
 static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu,
 					    enum avic_vcpu_action action)
 {
+	bool ga_log_intr = (action & AVIC_START_BLOCKING);
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_kernel_irqfd *irqfd;
 
@@ -851,9 +860,9 @@ static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu,
 		void *data = irqfd->irq_bypass_data;
 
 		if (!(action & AVIC_TOGGLE_ON_OFF))
-			WARN_ON_ONCE(amd_iommu_update_ga(data, cpu, true));
+			WARN_ON_ONCE(amd_iommu_update_ga(data, cpu, ga_log_intr));
 		else if (cpu >= 0)
-			WARN_ON_ONCE(amd_iommu_activate_guest_mode(data, cpu, true));
+			WARN_ON_ONCE(amd_iommu_activate_guest_mode(data, cpu, ga_log_intr));
 		else
 			WARN_ON_ONCE(amd_iommu_deactivate_guest_mode(data));
 	}
@@ -888,7 +897,8 @@ static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu,
 	entry = svm->avic_physical_id_entry;
 	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
-	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
+	entry &= ~(AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK |
+		   AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR);
 	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
 	entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 
@@ -949,12 +959,26 @@ static void __avic_vcpu_put(struct kvm_vcpu *vcpu, enum avic_vcpu_action action)
 
 	avic_update_iommu_vcpu_affinity(vcpu, -1, action);
 
+	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR);
+
+	/*
+	 * Keep the previous APIC ID in the entry so that a rogue doorbell from
+	 * hardware is at least restricted to a CPU associated with the vCPU.
+	 */
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
-	svm->avic_physical_id_entry = entry;
 
 	if (enable_ipiv)
 		WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
 
+	/*
+	 * Note!  Don't set AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR in the table as
+	 * it's a synthetic flag that usurps an unused should-be-zero bit.
+	 */
+	if (action & AVIC_START_BLOCKING)
+		entry |= AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR;
+
+	svm->avic_physical_id_entry = entry;
+
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 }
 
@@ -969,11 +993,26 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	 */
 	u64 entry = to_svm(vcpu)->avic_physical_id_entry;
 
-	/* Nothing to do if IsRunning == '0' due to vCPU blocking. */
-	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
-		return;
+	/*
+	 * Nothing to do if IsRunning == '0' due to vCPU blocking, i.e. if the
+	 * vCPU is preempted while its in the process of blocking.  WARN if the
+	 * vCPU wasn't running and isn't blocking, KVM shouldn't attempt to put
+	 * the AVIC if it wasn't previously loaded.
+	 */
+	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)) {
+		if (WARN_ON_ONCE(!kvm_vcpu_is_blocking(vcpu)))
+			return;
 
-	__avic_vcpu_put(vcpu, AVIC_STOP_RUNNING);
+		/*
+		 * The vCPU was preempted while blocking, ensure its IRTEs are
+		 * configured to generate GA Log Interrupts.
+		 */
+		if (!(WARN_ON_ONCE(!(entry & AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR))))
+			return;
+	}
+
+	__avic_vcpu_put(vcpu, kvm_vcpu_is_blocking(vcpu) ? AVIC_START_BLOCKING :
+							   AVIC_STOP_RUNNING);
 }
 
 void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)
@@ -1039,7 +1078,7 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
 	 * CPU and cause noisy neighbor problems if the VM is sending interrupts
 	 * to the vCPU while it's scheduled out.
 	 */
-	__avic_vcpu_put(vcpu, AVIC_STOP_RUNNING);
+	__avic_vcpu_put(vcpu, AVIC_START_BLOCKING);
 }
 
 void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
-- 
2.49.0.1151.ga128411c76-goog


