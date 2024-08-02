Return-Path: <kvm+bounces-23029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE08C945D5C
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 13:44:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1D9F1C210BF
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 11:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01F0A1E287F;
	Fri,  2 Aug 2024 11:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="I/RrvYXc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9105.amazon.com (smtp-fw-9105.amazon.com [207.171.188.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3E71DB430;
	Fri,  2 Aug 2024 11:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722599089; cv=none; b=McN9MOCY41BQfCq3oFTOFxc9An/1NfHiCdhN7Hwc37crjiU3s10oFRvI0iRAWiLNnGxZeU7wHQv9ydj2+12gAD2i3TPM1x5x5X0FrFIsSean7MCr49NUNR9UfeVghR1/X3jJEFGmKiDXqGbBC2CQ7M3dvdqdNJcU6XyW6VGnbGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722599089; c=relaxed/simple;
	bh=3lG7VY7KVCzB8GJjdeaFBAJ9Yy8cXe8V9oNboo4PskA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EyXIUE193JjFb0+GjnjfP6nWtI5IdJE6UHimLoRujU2wV7t6mW2kt1gXH56NnGz86moCIQnsUaV07xnTo5li4W8JJuVL3en+qXwk2vXp2sJe9F8M9oH+cV856dKx1AwMEHqtE1X7Eh5z2zSgG6dReTX8/59kzz+YYEXgQsZpDT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=I/RrvYXc; arc=none smtp.client-ip=207.171.188.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1722599087; x=1754135087;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=D15xhl8DebUMgUbMT6yp8Gi9oGiElLirxernELMeMWY=;
  b=I/RrvYXctDmWrpbxIFPqyE0JKAGhVAjxi51n3HAspxKwMTXM8G1zK/gI
   r0m6/mBGA8ZpEMWRBjJ57+zFX950U4qqVEaQ3SB4CYl9cAAlfjlvHnlxs
   uNgI/PIDTQwq4wBQHjE91MCuuh0OVrJIa5ANiwe9Xd2v8zmL0BpGyd+/m
   U=;
X-IronPort-AV: E=Sophos;i="6.09,257,1716249600"; 
   d="scan'208";a="747281510"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9105.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2024 11:44:40 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.17.79:21666]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.33.124:2525] with esmtp (Farcaster)
 id b9f1b537-0da7-43c0-9e59-d27fb5ad33fb; Fri, 2 Aug 2024 11:44:39 +0000 (UTC)
X-Farcaster-Flow-ID: b9f1b537-0da7-43c0-9e59-d27fb5ad33fb
Received: from EX19D010EUA003.ant.amazon.com (10.252.50.136) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 2 Aug 2024 11:44:39 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D010EUA003.ant.amazon.com (10.252.50.136) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 2 Aug 2024 11:44:38 +0000
Received: from dev-dsk-stollmc-1a-533028aa.eu-west-1.amazon.com
 (10.253.87.190) by mail-relay.amazon.com (10.250.64.254) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Fri, 2 Aug 2024 11:44:36 +0000
From: Carsten Stollmaier <stollmc@amazon.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>
CC: <nh-open-source@amazon.com>, Carsten Stollmaier <stollmc@amazon.com>,
	David Woodhouse <dwmw2@infradead.org>, Peter Xu <peterx@redhat.com>,
	Sebastian Biemueller <sbiemue@amazon.de>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: x86: Use gfn_to_pfn_cache for steal_time
Date: Fri, 2 Aug 2024 11:44:01 +0000
Message-ID: <20240802114402.96669-1-stollmc@amazon.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On vcpu_run, before entering the guest, the update of the steal time
information causes a page-fault if the page is not present. In our
scenario, this gets handled by do_user_addr_fault and successively
handle_userfault since we have the region registered to that.

handle_userfault uses TASK_INTERRUPTIBLE, so it is interruptible by
signals. do_user_addr_fault then busy-retries it if the pending signal
is non-fatal. This leads to contention of the mmap_lock.

This patch replaces the use of gfn_to_hva_cache with gfn_to_pfn_cache,
as gfn_to_pfn_cache ensures page presence for the memory access,
preventing the contention of the mmap_lock.

Signed-off-by: Carsten Stollmaier <stollmc@amazon.com>
CC: David Woodhouse <dwmw2@infradead.org>
CC: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Peter Xu <peterx@redhat.com>
CC: Sebastian Biemueller <sbiemue@amazon.de>
---
 arch/x86/include/asm/kvm_host.h |   2 +-
 arch/x86/kvm/x86.c              | 115 +++++++++++++++-----------------
 2 files changed, 54 insertions(+), 63 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 950a03e0181e..63d0c0cd7a8e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -898,7 +898,7 @@ struct kvm_vcpu_arch {
 		u8 preempted;
 		u64 msr_val;
 		u64 last_steal;
-		struct gfn_to_hva_cache cache;
+		struct gfn_to_pfn_cache cache;
 	} st;
 
 	u64 l1_tsc_offset;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index af6c8cf6a37a..2b8adbadfc50 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3652,10 +3652,8 @@ EXPORT_SYMBOL_GPL(kvm_service_local_tlb_flush_requests);
 
 static void record_steal_time(struct kvm_vcpu *vcpu)
 {
-	struct gfn_to_hva_cache *ghc = &vcpu->arch.st.cache;
-	struct kvm_steal_time __user *st;
-	struct kvm_memslots *slots;
-	gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
+	struct gfn_to_pfn_cache *gpc = &vcpu->arch.st.cache;
+	struct kvm_steal_time *st;
 	u64 steal;
 	u32 version;
 
@@ -3670,42 +3668,26 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	if (WARN_ON_ONCE(current->mm != vcpu->kvm->mm))
 		return;
 
-	slots = kvm_memslots(vcpu->kvm);
-
-	if (unlikely(slots->generation != ghc->generation ||
-		     gpa != ghc->gpa ||
-		     kvm_is_error_hva(ghc->hva) || !ghc->memslot)) {
+	read_lock(&gpc->lock);
+	while (!kvm_gpc_check(gpc, sizeof(*st))) {
 		/* We rely on the fact that it fits in a single page. */
 		BUILD_BUG_ON((sizeof(*st) - 1) & KVM_STEAL_VALID_BITS);
 
-		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gpa, sizeof(*st)) ||
-		    kvm_is_error_hva(ghc->hva) || !ghc->memslot)
+		read_unlock(&gpc->lock);
+
+		if (kvm_gpc_refresh(gpc, sizeof(*st)))
 			return;
+
+		read_lock(&gpc->lock);
 	}
 
-	st = (struct kvm_steal_time __user *)ghc->hva;
+	st = (struct kvm_steal_time *)gpc->khva;
 	/*
 	 * Doing a TLB flush here, on the guest's behalf, can avoid
 	 * expensive IPIs.
 	 */
 	if (guest_pv_has(vcpu, KVM_FEATURE_PV_TLB_FLUSH)) {
-		u8 st_preempted = 0;
-		int err = -EFAULT;
-
-		if (!user_access_begin(st, sizeof(*st)))
-			return;
-
-		asm volatile("1: xchgb %0, %2\n"
-			     "xor %1, %1\n"
-			     "2:\n"
-			     _ASM_EXTABLE_UA(1b, 2b)
-			     : "+q" (st_preempted),
-			       "+&r" (err),
-			       "+m" (st->preempted));
-		if (err)
-			goto out;
-
-		user_access_end();
+		u8 st_preempted = xchg(&st->preempted, 0);
 
 		vcpu->arch.st.preempted = 0;
 
@@ -3713,39 +3695,32 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 				       st_preempted & KVM_VCPU_FLUSH_TLB);
 		if (st_preempted & KVM_VCPU_FLUSH_TLB)
 			kvm_vcpu_flush_tlb_guest(vcpu);
-
-		if (!user_access_begin(st, sizeof(*st)))
-			goto dirty;
 	} else {
-		if (!user_access_begin(st, sizeof(*st)))
-			return;
-
-		unsafe_put_user(0, &st->preempted, out);
+		st->preempted = 0;
 		vcpu->arch.st.preempted = 0;
 	}
 
-	unsafe_get_user(version, &st->version, out);
+	version = st->version;
 	if (version & 1)
 		version += 1;  /* first time write, random junk */
 
 	version += 1;
-	unsafe_put_user(version, &st->version, out);
+	st->version = version;
 
 	smp_wmb();
 
-	unsafe_get_user(steal, &st->steal, out);
+	steal = st->steal;
 	steal += current->sched_info.run_delay -
 		vcpu->arch.st.last_steal;
 	vcpu->arch.st.last_steal = current->sched_info.run_delay;
-	unsafe_put_user(steal, &st->steal, out);
+	st->steal = steal;
 
 	version += 1;
-	unsafe_put_user(version, &st->version, out);
+	st->version = version;
+
+	kvm_gpc_mark_dirty_in_slot(gpc);
 
- out:
-	user_access_end();
- dirty:
-	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
+	read_unlock(&gpc->lock);
 }
 
 static bool kvm_is_msr_to_save(u32 msr_index)
@@ -4020,8 +3995,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		vcpu->arch.st.msr_val = data;
 
-		if (!(data & KVM_MSR_ENABLED))
-			break;
+		if (data & KVM_MSR_ENABLED) {
+			kvm_gpc_activate(&vcpu->arch.st.cache, data & ~KVM_MSR_ENABLED,
+					sizeof(struct kvm_steal_time));
+		} else {
+			kvm_gpc_deactivate(&vcpu->arch.st.cache);
+		}
 
 		kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
 
@@ -5051,11 +5030,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 {
-	struct gfn_to_hva_cache *ghc = &vcpu->arch.st.cache;
-	struct kvm_steal_time __user *st;
-	struct kvm_memslots *slots;
+	struct gfn_to_pfn_cache *gpc = &vcpu->arch.st.cache;
+	struct kvm_steal_time *st;
 	static const u8 preempted = KVM_VCPU_PREEMPTED;
-	gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
+	unsigned long flags;
 
 	/*
 	 * The vCPU can be marked preempted if and only if the VM-Exit was on
@@ -5080,20 +5058,28 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	if (unlikely(current->mm != vcpu->kvm->mm))
 		return;
 
-	slots = kvm_memslots(vcpu->kvm);
-
-	if (unlikely(slots->generation != ghc->generation ||
-		     gpa != ghc->gpa ||
-		     kvm_is_error_hva(ghc->hva) || !ghc->memslot))
-		return;
+	read_lock_irqsave(&gpc->lock, flags);
+	if (!kvm_gpc_check(gpc, sizeof(*st)))
+		goto out_unlock_gpc;
 
-	st = (struct kvm_steal_time __user *)ghc->hva;
+	st = (struct kvm_steal_time *)gpc->khva;
 	BUILD_BUG_ON(sizeof(st->preempted) != sizeof(preempted));
 
-	if (!copy_to_user_nofault(&st->preempted, &preempted, sizeof(preempted)))
-		vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
+	st->preempted = preempted;
+	vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
 
-	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
+	kvm_gpc_mark_dirty_in_slot(gpc);
+
+out_unlock_gpc:
+	read_unlock_irqrestore(&gpc->lock, flags);
+}
+
+static void kvm_steal_time_reset(struct kvm_vcpu *vcpu)
+{
+	kvm_gpc_deactivate(&vcpu->arch.st.cache);
+	vcpu->arch.st.preempted = 0;
+	vcpu->arch.st.msr_val = 0;
+	vcpu->arch.st.last_steal = 0;
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
@@ -12219,6 +12205,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	kvm_gpc_init(&vcpu->arch.pv_time, vcpu->kvm);
 
+	kvm_gpc_init(&vcpu->arch.st.cache, vcpu->kvm);
+
 	if (!irqchip_in_kernel(vcpu->kvm) || kvm_vcpu_is_reset_bsp(vcpu))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 	else
@@ -12331,6 +12319,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	int idx;
 
+	kvm_steal_time_reset(vcpu);
+
 	kvmclock_reset(vcpu);
 
 	kvm_x86_call(vcpu_free)(vcpu);
@@ -12401,7 +12391,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	vcpu->arch.apf.msr_en_val = 0;
 	vcpu->arch.apf.msr_int_val = 0;
-	vcpu->arch.st.msr_val = 0;
+
+	kvm_steal_time_reset(vcpu);
 
 	kvmclock_reset(vcpu);
 
-- 
2.40.1




Amazon Web Services Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


