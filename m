Return-Path: <kvm+bounces-52864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C8FE7B09BB4
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 08:50:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D41B31C44F43
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 06:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CB84218AC4;
	Fri, 18 Jul 2025 06:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z86NTFOB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C422165E2;
	Fri, 18 Jul 2025 06:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752821413; cv=none; b=SC/wg9gB0kZ1h+D3H5bg8jDhlh/uDcXsKHTiRYKa4T1rj5rOa2RqU0HHQuywz0qTiWgjT6Bq5+yKMuHx8iQcRm+2aKHDqN6Z90tb29Qu3Pb2JvYg/4K6Zvva1y5xSgC738ZCZK0jGOZOYujAP6QK4WuFM48SRl0PFsxySZAaV4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752821413; c=relaxed/simple;
	bh=az5WShJBzTatj4e1fADgsYjVxGvIrztySJpSGhfMsTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYCnW99ptjHdT80iEiMIYlP9lgFhZST4VM6BRICXqa/SFo5VtMydIUHi950jD8b7oDmy8PbKchD6CtCM7ty23Q0U1L95K31pxBcRZ5jrlWgA81E9zItB4aGKJooJ+1e5LEgcrGL3I6/tbYe/F4Zz6CFDh0kDt5j2POahHXOvFZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z86NTFOB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F21C4CEF1;
	Fri, 18 Jul 2025 06:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752821413;
	bh=az5WShJBzTatj4e1fADgsYjVxGvIrztySJpSGhfMsTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z86NTFOBdrdXBhXsplkHCCuStm6qe32seKJiBsueeHRNdm7CVlV1VJdDoC2IbsYvi
	 e0KmG9wUf1Pqv8/wk4KZblrvuqKuMB0n1bKfoZJmwzJxJsuTcE+jGL3nNicxkJRAsW
	 bt9HTHA7PeImgD2kdrxN5uPXcXR5SbMV+c4136W8P/2tarNLXVV88o1yw/2r48s8Zy
	 i9iTb0SR4dZuZgbhOWiSTVsHTjF/QrJgPXTrMvoSkHM/JV7cW8k4E5BMWZn+Hknlml
	 nI0i5rvIS2ct06Kp5zOXcWHnZ8Fk96BHM3I/sBVtKo71pLqoFuivvOR04Dfr//N8L0
	 e94C78xhdqAkw==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 3/3] KVM: SVM: Optimize IRQ window inhibit handling
Date: Fri, 18 Jul 2025 12:13:36 +0530
Message-ID: <55adf9e49743b8027231d66d79369b774a353536.1752819570.git.naveen@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1752819570.git.naveen@kernel.org>
References: <cover.1752819570.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IRQ windows represent times during which an IRQ can be injected into a
vCPU, and thus represent times when a vCPU is running with RFLAGS.IF=1
and GIF enabled (TPR/PPR don't matter since KVM controls interrupt
injection and it only injects one interrupt at a time). On SVM, when
emulating the local APIC (i.e., AVIC disabled), KVM detects IRQ windows
by injecting a dummy virtual interrupt through VMCB.V_IRQ and
intercepting virtual interrupts (INTERCEPT_VINTR). This intercept
triggers as soon as the guest enables interrupts and is about to take
the dummy interrupt, at which point the actual interrupt can be injected
through VMCB.EVENTINJ.

When AVIC is enabled, VMCB.V_IRQ is ignored by the hardware and so
detecting IRQ windows requires AVIC to be inhibited. However, this is
only necessary for ExtINTs since all other interrupts can be injected
either by directly setting IRR in the APIC backing page and letting the
AVIC hardware inject the interrupt into the guest, or via VMCB.V_NMI for
NMIs.

If AVIC is enabled but inhibited for some other reason, KVM has to
request for IRQ window inhibits every time it has to inject an interrupt
into the guest. This is because APICv inhibits are dynamic in nature, so
KVM has to be sure that AVIC is inhibited for purposes of discovering an
IRQ window even if the other inhibit is cleared in the meantime.

This is particularly problematic with APICV_INHIBIT_REASON_PIT_REINJ
which stays set throughout the life of the guest and results in KVM
rapidly toggling IRQ window inhibit resulting in contention on
apicv_update_lock.

Address this by setting and clearing APICV_INHIBIT_REASON_PIT_REINJ
lazily: if some other inhibit reason is already set, just increment the
IRQ window request count and do not update apicv_inhibit_reasons
immediately. If any other inhibit reason is set/cleared in the meantime,
re-evaluate APICV_INHIBIT_REASON_PIT_REINJ by checking the IRQ window
request count and update apicv_inhibit_reasons appropriately. Otherwise,
just the IRQ window request count is incremented/decremented each time
an IRQ window is requested. This reduces much of the contention on the
apicv_update_lock semaphore and does away with much of the performance
degradation.

---
 arch/x86/kvm/x86.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

I think patch tags for this should be:
	From: Sean Christopherson <seanjc@google.com>

	Signed-off-by: Sean Christopherson <seanjc@google.com>
	Co-developed-by: Paolo Bonzini <pbonzini@redhat.com>
	Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
	Co-developed-by: Naveen N Rao (AMD) <naveen@kernel.org>
	Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>

- Naveen

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 216d1801a4f2..845afcf6e85f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10534,7 +10534,11 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 
 	old = new = kvm->arch.apicv_inhibit_reasons;
 
-	set_or_clear_apicv_inhibit(&new, reason, set);
+	if (reason != APICV_INHIBIT_REASON_IRQWIN)
+		set_or_clear_apicv_inhibit(&new, reason, set);
+
+	set_or_clear_apicv_inhibit(&new, APICV_INHIBIT_REASON_IRQWIN,
+				   atomic_read(&kvm->arch.apicv_nr_irq_window_req));
 
 	if (!!old != !!new) {
 		/*
@@ -10582,6 +10586,26 @@ void kvm_inc_or_dec_irq_window_inhibit(struct kvm *kvm, bool inc)
 	if (!enable_apicv)
 		return;
 
+	/*
+	 * IRQ windows are requested either because of ExtINT injections, or
+	 * because APICv is already disabled/inhibited for another reason.
+	 * While ExtINT injections are rare and should not happen while the
+	 * vCPU is running its actual workload, it's worth avoiding thrashing
+	 * if the IRQ window is being requested because APICv is already
+	 * inhibited.  So, toggle the actual inhibit (which requires taking
+	 * the lock for write) if and only if there's no other inhibit.
+	 * kvm_set_or_clear_apicv_inhibit() always evaluates the IRQ window
+	 * count; thus the IRQ window inhibit call _will_ be lazily updated on
+	 * the next call, if it ever happens.
+	 */
+	if (READ_ONCE(kvm->arch.apicv_inhibit_reasons) & ~BIT(APICV_INHIBIT_REASON_IRQWIN)) {
+		guard(rwsem_read)(&kvm->arch.apicv_update_lock);
+		if (READ_ONCE(kvm->arch.apicv_inhibit_reasons) & ~BIT(APICV_INHIBIT_REASON_IRQWIN)) {
+			atomic_add(add, &kvm->arch.apicv_nr_irq_window_req);
+			return;
+		}
+	}
+
 	/*
 	 * Strictly speaking, the lock is only needed if going 0->1 or 1->0,
 	 * a la atomic_dec_and_mutex_lock.  However, ExtINTs are rare and
-- 
2.50.1


