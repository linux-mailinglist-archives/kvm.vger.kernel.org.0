Return-Path: <kvm+bounces-61527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4008BC2208F
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 20:42:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C1944630C7
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 19:41:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFFD22FF676;
	Thu, 30 Oct 2025 19:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S02x53gD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DBF2DCF5B
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 19:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761853303; cv=none; b=JUbSjsSSTbCEUI+jJaoRtCmKtBWxDDAycbAOdONx8cDMkHhy3kQVvgrjpgaBTrbkUhgL5NmNcmjgVyYkeVcjr0KLgkCOBS9HV5XnC+JhWbvc7FCJ97alcroTkzNf8KLYEUuabNz9x664REHaeS3yh9K3pPM8FK0pWyY+sHWjJyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761853303; c=relaxed/simple;
	bh=WA1CJRX0ukLYCnktAdOZ7r/eXM+Yf8EYQrc3PTLtZTc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vni8OdPsm+aYX8JiVVMGvWb9rWKmjnpgSBvWmFzkTpbln7VFlpbJaEKepfzCOmUewiqrOg0jK1jQWnra+KHVDb7OYHHhVDdRBVGG8xgPzT5ADpv/N0TDLRKFB8Sepb3EVmkq8TVIwKGlHsrmpP5zQYYFtbswSeXdu9cmNHF+iMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S02x53gD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761853300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PwVb87332yDl40U4hCHa0la46+wdb8wFowPu6Dhk4SI=;
	b=S02x53gDJZbgvclNSFtCipobWxkui+b63yHSIlSW21omidW5qDSwAX+h53VubNpJUO2Z/7
	XVqsZp45Lo3ywaJHcGKeCA+5cb3c+e6nA5mTZaT19zC1vCpirOpcdmgsJgdHw4EaysLoIs
	DSyVel5LL0fBzeRYfipspzmyALcGOlo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-450-KhGgY1qSNzqorCeu6Nz6Rw-1; Thu,
 30 Oct 2025 15:41:35 -0400
X-MC-Unique: KhGgY1qSNzqorCeu6Nz6Rw-1
X-Mimecast-MFC-AGG-ID: KhGgY1qSNzqorCeu6Nz6Rw_1761853294
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9F5651955EAE;
	Thu, 30 Oct 2025 19:41:33 +0000 (UTC)
Received: from intellaptop.redhat.com (unknown [10.22.65.1])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 270F330001A5;
	Thu, 30 Oct 2025 19:41:30 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] KVM: SVM: switch to raw spinlock for svm->ir_list_lock
Date: Thu, 30 Oct 2025 15:41:30 -0400
Message-ID: <20251030194130.307900-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

svm->ir_list_lock can be taken during __avic_vcpu_put which can be called
from schedule() via kvm_sched_out.

Therefore use a raw spinlock instead.

This fixes the following lockdep warning:

[  728.022965] =============================
[  728.027438] [ BUG: Invalid wait context ]
[  728.031911] 6.12.0-146.1640_2124176644.el10.x86_64+debug #1 Not tainted
[  728.039294] -----------------------------
[  728.043765] qemu-kvm/38299 is trying to lock:
[  728.048624] ff11000239725600 (&svm->ir_list_lock){....}-{3:3}, at: __avic_vcpu_put+0xfd/0x300 [kvm_amd]
[  728.059135] other info that might help us debug this:
[  728.064768] context-{5:5}
[  728.067688] 2 locks held by qemu-kvm/38299:
[  728.072352]  #0: ff11000239723ba8 (&vcpu->mutex){+.+.}-{4:4}, at: kvm_vcpu_ioctl+0x240/0xe00 [kvm]
[  728.082425]  #1: ff11000b906056d8 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2e/0x130
[  728.092540] stack backtrace:
[  728.095758] CPU: 1 UID: 0 PID: 38299 Comm: qemu-kvm Kdump: loaded Not tainted 6.12.0-146.1640_2124176644.el10.x86_64+debug #1 PREEMPT(voluntary)
[  728.095763] Hardware name: AMD Corporation QUARTZ/QUARTZ, BIOS RQZ100AB 09/14/2023
[  728.095766] Call Trace:
[  728.095769]  <TASK>
[  728.095775]  dump_stack_lvl+0x6f/0xb0
[  728.095782]  __lock_acquire+0x921/0xb80
[  728.095787]  ? mark_held_locks+0x40/0x70
[  728.095793]  lock_acquire.part.0+0xbe/0x270
[  728.095797]  ? __avic_vcpu_put+0xfd/0x300 [kvm_amd]
[  728.095811]  ? srso_alias_return_thunk+0x5/0xfbef5
[  728.095815]  ? rcu_is_watching+0x15/0xb0
[  728.095818]  ? srso_alias_return_thunk+0x5/0xfbef5
[  728.095821]  ? lock_acquire+0x120/0x170
[  728.095824]  ? __avic_vcpu_put+0xfd/0x300 [kvm_amd]
[  728.095836]  _raw_spin_lock_irqsave+0x46/0x90
[  728.095840]  ? __avic_vcpu_put+0xfd/0x300 [kvm_amd]
[  728.095850]  __avic_vcpu_put+0xfd/0x300 [kvm_amd]
[  728.095866]  svm_vcpu_put+0xfa/0x130 [kvm_amd]
[  728.095877]  kvm_arch_vcpu_put+0x48c/0x790 [kvm]
[  728.095944]  kvm_sched_out+0x161/0x1c0 [kvm]
[  728.095994]  prepare_task_switch+0x36b/0xf60
[  728.095998]  ? rcu_is_watching+0x15/0xb0
[  728.096004]  __schedule+0x4f7/0x1890
[  728.096010]  ? __pfx___schedule+0x10/0x10
[  728.096012]  ? srso_alias_return_thunk+0x5/0xfbef5
[  728.096019]  ? __pfx_vcpu_enter_guest.constprop.0+0x10/0x10 [kvm]
[  728.096067]  ? srso_alias_return_thunk+0x5/0xfbef5
[  728.096069]  ? find_held_lock+0x32/0x90
[  728.096072]  ? local_clock_noinstr+0xd/0xe0
[  728.096080]  schedule+0xd4/0x260
[  728.096083]  xfer_to_guest_mode_handle_work+0x54/0xc0
[  728.096089]  vcpu_run+0x69a/0xa70 [kvm]
[  728.096136]  kvm_arch_vcpu_ioctl_run+0xdc0/0x17e0 [kvm]
[  728.096185]  kvm_vcpu_ioctl+0x39f/0xe00 [kvm]

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 16 ++++++++--------
 arch/x86/kvm/svm/svm.h  |  2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index f286b5706d7c..2814e7e24e89 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -788,7 +788,7 @@ int avic_init_vcpu(struct vcpu_svm *svm)
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	INIT_LIST_HEAD(&svm->ir_list);
-	spin_lock_init(&svm->ir_list_lock);
+	raw_spin_lock_init(&svm->ir_list_lock);
 
 	if (!enable_apicv || !irqchip_in_kernel(vcpu->kvm))
 		return 0;
@@ -816,9 +816,9 @@ static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)
 	if (!vcpu)
 		return;
 
-	spin_lock_irqsave(&to_svm(vcpu)->ir_list_lock, flags);
+	raw_spin_lock_irqsave(&to_svm(vcpu)->ir_list_lock, flags);
 	list_del(&irqfd->vcpu_list);
-	spin_unlock_irqrestore(&to_svm(vcpu)->ir_list_lock, flags);
+	raw_spin_unlock_irqrestore(&to_svm(vcpu)->ir_list_lock, flags);
 }
 
 int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
@@ -855,7 +855,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		 * list of IRQs being posted to the vCPU, to ensure the IRTE
 		 * isn't programmed with stale pCPU/IsRunning information.
 		 */
-		guard(spinlock_irqsave)(&svm->ir_list_lock);
+		guard(raw_spinlock_irqsave)(&svm->ir_list_lock);
 
 		/*
 		 * Update the target pCPU for IOMMU doorbells if the vCPU is
@@ -972,7 +972,7 @@ static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu,
 	 * up-to-date entry information, or that this task will wait until
 	 * svm_ir_list_add() completes to set the new target pCPU.
 	 */
-	spin_lock_irqsave(&svm->ir_list_lock, flags);
+	raw_spin_lock_irqsave(&svm->ir_list_lock, flags);
 
 	entry = svm->avic_physical_id_entry;
 	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
@@ -997,7 +997,7 @@ static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu,
 
 	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, action);
 
-	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
+	raw_spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 }
 
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
@@ -1035,7 +1035,7 @@ static void __avic_vcpu_put(struct kvm_vcpu *vcpu, enum avic_vcpu_action action)
 	 * or that this task will wait until svm_ir_list_add() completes to
 	 * mark the vCPU as not running.
 	 */
-	spin_lock_irqsave(&svm->ir_list_lock, flags);
+	raw_spin_lock_irqsave(&svm->ir_list_lock, flags);
 
 	avic_update_iommu_vcpu_affinity(vcpu, -1, action);
 
@@ -1059,7 +1059,7 @@ static void __avic_vcpu_put(struct kvm_vcpu *vcpu, enum avic_vcpu_action action)
 
 	svm->avic_physical_id_entry = entry;
 
-	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
+	raw_spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 }
 
 void avic_vcpu_put(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e4b04f435b3d..dbd87a87046a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -329,7 +329,7 @@ struct vcpu_svm {
 	 * back into remapped mode).
 	 */
 	struct list_head ir_list;
-	spinlock_t ir_list_lock;
+	raw_spinlock_t ir_list_lock;
 
 	struct vcpu_sev_es_state sev_es;
 
-- 
2.49.0


