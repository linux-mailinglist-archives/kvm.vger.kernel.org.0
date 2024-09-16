Return-Path: <kvm+bounces-27009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 547FB97A734
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 20:18:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10407286937
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 18:18:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21A0515DBB6;
	Mon, 16 Sep 2024 18:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BKEMIx7U";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SeELWg/o"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A723915852F;
	Mon, 16 Sep 2024 18:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726510693; cv=none; b=Wm9duvPcSMvxsqlBrSB5MhfvSfWQycNe9FgJfgNASkzr7krorYsDdvjgWLKePK7g6BeXScxOFQDgrvnutmyQUwFCLAtsrMWh+TZl6NRLyyBdoEYFIgmFJLS+M5Dt2YwdG/zIvDAngDsa1Ql8tRUHwtstrf6Sdu90ntZOjeNiaZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726510693; c=relaxed/simple;
	bh=r9BF4AQb3kqUUUTA/9bwhkryT/pPkfeJ8RGINnvT0Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhfVHg9HDv72nbia/YPGcVYjscXMZsPLpWvXfeejVQh40P0mY4Ahsuhbm2vCQahVYg6+XTafucy1Ea/5mxlKDD68AgLuywS+jdTn6uYxw9ncAK46NVjGzj2rHcQ4t4p1bL4S8SKMM4BHhyx8+4sr0SPmtq/kn5BplwYgJsWPPVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=BKEMIx7U; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=SeELWg/o; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E58D421C27;
	Mon, 16 Sep 2024 18:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1726510689; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o85+3T4JTGkyZbZYuD7FdFCNPlWLeI8TY7nbTcQx2e8=;
	b=BKEMIx7UrL8npzWipxAo2ZseNdZ6Dclhz/LZABOYJKg3TnT9vPbdGYDeyzv/4kbJoAtAUs
	qaivZ0e+2phYAJSxSrjZJj2i0BiiVcRX7GB15024Bm6t/2rxCpqIuQvnWq0R4OBbqB5EJU
	hPLsdSYve3cAXtxC9A+e7IVZTuvr2EI=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1726510688; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o85+3T4JTGkyZbZYuD7FdFCNPlWLeI8TY7nbTcQx2e8=;
	b=SeELWg/odUOEW6TFlBs7+tNHwWnIWZLbeA3NEGdtQt7Sy6jpu+SXHghhWJXsi5er3QL2up
	L1BQ0XOaou13FTMS5TU9pv26ANETsnFTiVVr87LP2fPCKq3sp6GYJ7hsek79l3b9rGniQZ
	bAl4cFpNvdoBsISlI8ZH09W6dYhXREQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 50F65139CE;
	Mon, 16 Sep 2024 18:18:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uCG6EWB26GbveAAAD6G6ig
	(envelope-from <roy.hopkins@suse.com>); Mon, 16 Sep 2024 18:18:08 +0000
From: Roy Hopkins <roy.hopkins@suse.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev
Cc: Roy Hopkins <roy.hopkins@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Michael Roth <michael.roth@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [RFC PATCH 2/5] x86/kvm: Create a child struct kvm_vcpu for each VMPL
Date: Mon, 16 Sep 2024 19:17:54 +0100
Message-ID: <7f939d682286d2abc5b22f7f21baa0e23f9f18ec.1726506534.git.roy.hopkins@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1726506534.git.roy.hopkins@suse.com>
References: <cover.1726506534.git.roy.hopkins@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	R_RATELIMIT(0.00)[to_ip_from(RLh8t8sqpgocps1pdp1zxxqsw5)];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -6.80
X-Spam-Flag: NO

Isolation technologies such as SEV-SNP introduce the concept of
virtual machine privilege levels (VMPLs), separate to the processor
CPL. A guest runs in the context of one of these VMPLs which allows
for a different register context, memory privileges, etc.

KVM must maintain state for each supported VMPL and switch between
these states before entering the guest based on guest requests or
other factors.

This patch introduces the ability to create multiple
struct kvm_cpus: one for each VMPL related to a single vCPU. This is
achieved by introducing a new structure, struct kvm_vcpu_vmpl_state that
is included in struct kvm_vcpu to track the state of each VMPL for
supported platforms (currently only SEV-SNP). The state for each VMPL is
then stored in its own struct kvm_vcpu. State that is common to all VMPL
kvm_vcpus is managed by vcpu->common, allowing a pointer to the
common fields to be shared amongst all VMPL kvm_vcpu's for a single vCPU
id.

The patch supports switching VMPLs by changing the target_vmpl in the
state structure. However, no code to generate a VMPL switch invokes this
at present.

Signed-off-by: Roy Hopkins <roy.hopkins@suse.com>
---
 arch/x86/kvm/cpuid.c       |  78 +++++++++++++------------
 arch/x86/kvm/trace.h       |  12 +++-
 arch/x86/kvm/x86.c         |  58 +++++++++++++++++--
 include/linux/kvm_host.h   |  17 ++++++
 include/trace/events/kvm.h |  48 +++++++++++++++
 virt/kvm/kvm_main.c        | 116 +++++++++++++++++++++++++------------
 6 files changed, 249 insertions(+), 80 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2617be544480..4dc5ac431e97 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -437,51 +437,55 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
                         int nent)
 {
 	int r;
+	int vtl;
+	struct kvm_vcpu_vmpl_state *vcpu_parent = vcpu->vcpu_parent;
 
-	__kvm_update_cpuid_runtime(vcpu, e2, nent);
+	for (vtl = 0; vtl <= vcpu_parent->max_vmpl; ++vtl) {
+		vcpu = vcpu_parent->vcpu_vmpl[vtl];
+		__kvm_update_cpuid_runtime(vcpu, e2, nent);
 
-	/*
-	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
-	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
-	 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
-	 * faults due to reusing SPs/SPTEs. In practice no sane VMM mucks with
-	 * the core vCPU model on the fly. It would've been better to forbid any
-	 * KVM_SET_CPUID{,2} calls after KVM_RUN altogether but unfortunately
-	 * some VMMs (e.g. QEMU) reuse vCPU fds for CPU hotplug/unplug and do
-	 * KVM_SET_CPUID{,2} again. To support this legacy behavior, check
-	 * whether the supplied CPUID data is equal to what's already set.
-	 */
-	if (kvm_vcpu_has_run(vcpu)) {
-		r = kvm_cpuid_check_equal(vcpu, e2, nent);
-		if (r)
-			return r;
-
-		kvfree(e2);
-		return 0;
-	}
+		/*
+		* KVM does not correctly handle changing guest CPUID after KVM_RUN, as
+		* MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
+		* tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
+		* faults due to reusing SPs/SPTEs. In practice no sane VMM mucks with
+		* the core vCPU model on the fly. It would've been better to forbid any
+		* KVM_SET_CPUID{,2} calls after KVM_RUN altogether but unfortunately
+		* some VMMs (e.g. QEMU) reuse vCPU fds for CPU hotplug/unplug and do
+		* KVM_SET_CPUID{,2} again. To support this legacy behavior, check
+		* whether the supplied CPUID data is equal to what's already set.
+		*/
+		if (kvm_vcpu_has_run(vcpu)) {
+			r = kvm_cpuid_check_equal(vcpu, e2, nent);
+			if (r)
+				return r;
+
+			kvfree(e2);
+			return 0;
+		}
 
 #ifdef CONFIG_KVM_HYPERV
-	if (kvm_cpuid_has_hyperv(e2, nent)) {
-		r = kvm_hv_vcpu_init(vcpu);
-		if (r)
-			return r;
-	}
+		if (kvm_cpuid_has_hyperv(e2, nent)) {
+			r = kvm_hv_vcpu_init(vcpu);
+			if (r)
+				return r;
+		}
 #endif
 
-	r = kvm_check_cpuid(vcpu, e2, nent);
-	if (r)
-		return r;
-
-	kvfree(vcpu->arch.cpuid_entries);
-	vcpu->arch.cpuid_entries = e2;
-	vcpu->arch.cpuid_nent = nent;
+		r = kvm_check_cpuid(vcpu, e2, nent);
+		if (r)
+			return r;
 
-	vcpu->arch.kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
-#ifdef CONFIG_KVM_XEN
-	vcpu->arch.xen.cpuid = kvm_get_hypervisor_cpuid(vcpu, XEN_SIGNATURE);
-#endif
-	kvm_vcpu_after_set_cpuid(vcpu);
+		kvfree(vcpu->arch.cpuid_entries);
+		vcpu->arch.cpuid_entries = e2;
+		vcpu->arch.cpuid_nent = nent;
 
+		vcpu->arch.kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
+	#ifdef CONFIG_KVM_XEN
+		vcpu->arch.xen.cpuid = kvm_get_hypervisor_cpuid(vcpu, XEN_SIGNATURE);
+	#endif
+		kvm_vcpu_after_set_cpuid(vcpu);
+	}
 	return 0;
 }
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index d3aeffd6ae75..882b8d2356c6 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -20,18 +20,26 @@ TRACE_EVENT(kvm_entry,
 
 	TP_STRUCT__entry(
 		__field(	unsigned int,	vcpu_id		)
+		__field(	unsigned int,	vcpu_vmpl	)
+		__field(	unsigned int,	current_vmpl	)
+		__field(	unsigned int,	target_vmpl	)
 		__field(	unsigned long,	rip		)
 		__field(	bool,		immediate_exit	)
 	),
 
 	TP_fast_assign(
 		__entry->vcpu_id        = vcpu->vcpu_id;
+		__entry->vcpu_vmpl	= vcpu->vmpl;
+		__entry->current_vmpl	= vcpu->vcpu_parent->current_vmpl;
+		__entry->target_vmpl	= vcpu->vcpu_parent->target_vmpl;
 		__entry->rip		= kvm_rip_read(vcpu);
 		__entry->immediate_exit	= force_immediate_exit;
 	),
 
-	TP_printk("vcpu %u, rip 0x%lx%s", __entry->vcpu_id, __entry->rip,
-		  __entry->immediate_exit ? "[immediate exit]" : "")
+	TP_printk("vcpu %u, rip 0x%lx%s, vcpu_vmpl %d, current_vmpl %d, target_vmpl %d",
+		  __entry->vcpu_id, __entry->rip, __entry->immediate_exit ? "[immediate exit]" : "",
+		  __entry->vcpu_vmpl, __entry->current_vmpl, __entry->target_vmpl
+		  )
 );
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e646b4042963..cc2f62b4cf76 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11299,6 +11299,7 @@ static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 static int vcpu_run(struct kvm_vcpu *vcpu)
 {
 	int r;
+	struct kvm_vcpu_vmpl_state *vcpu_parent = vcpu->vcpu_parent;
 
 	vcpu->common->run->exit_reason = KVM_EXIT_UNKNOWN;
 
@@ -11341,6 +11342,10 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 			if (r)
 				return r;
 		}
+
+		/* If the exit code results in a VTL switch then let the caller handle it */
+		if (vcpu_parent->target_vmpl != vcpu_parent->current_vmpl)
+			break;
 	}
 
 	return r;
@@ -11437,7 +11442,7 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 	trace_kvm_fpu(0);
 }
 
-int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
+static int kvm_arch_vcpu_ioctl_run_vtl(struct kvm_vcpu *vcpu)
 {
 	struct kvm_queued_exception *ex = &vcpu->arch.exception;
 	struct kvm_run *kvm_run = vcpu->common->run;
@@ -11560,6 +11565,43 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	return r;
 }
 
+static void kvm_sync_vcpu(struct kvm_vcpu *src, struct kvm_vcpu *dst) {
+	/* 
+	 * TODO: This sync should not be necessary if VMPL common fields
+	 * have been setup correctly. This is just a workaround for now.
+	 */
+	dst->arch.cpuid_nent = src->arch.cpuid_nent;
+	dst->arch.cpuid_entries = src->arch.cpuid_entries;
+	dst->arch.kvm_cpuid = src->arch.kvm_cpuid;
+}
+
+int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
+{
+	int r;
+	struct kvm_vcpu_vmpl_state *vcpu_parent = vcpu->vcpu_parent;
+	struct kvm_vcpu *vcpu_current_vtl;
+
+	for (;;) {
+		/* Select the correct structure for the current VTL */
+		vcpu_parent->current_vmpl = vcpu_parent->target_vmpl;
+		vcpu_current_vtl = vcpu_parent->vcpu_vmpl[vcpu_parent->current_vmpl];
+
+		/* Synchronise shared state from VTL0 to non-zero VTLs */
+		if (vcpu_parent->vcpu_vmpl[0] != vcpu_current_vtl) {
+			kvm_sync_vcpu(vcpu_parent->vcpu_vmpl[0], vcpu_current_vtl);
+		}
+
+		r = kvm_arch_vcpu_ioctl_run_vtl(vcpu_current_vtl);
+		if ((r < 0) || (vcpu_parent->current_vmpl == vcpu_parent->target_vmpl)) {
+			break;
+		}
+		/* Continue around again if there is a VTL switch */
+		trace_kvm_arch_vcpu_ioctl_run_vtl_switch(vcpu_parent);
+	} 
+
+	return r;
+}
+
 static void __get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
 	if (vcpu->arch.emulate_regs_need_sync_to_vcpu) {
@@ -12246,7 +12288,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!page)
 		goto fail_free_lapic;
-	vcpu->arch.pio_data = page_address(page);
+	if (vcpu->vmpl == 0)
+		vcpu->arch.pio_data = page_address(page);
+	else
+		vcpu->arch.pio_data = vcpu->vcpu_parent->vcpu_vmpl[0]->arch.pio_data;
 
 	vcpu->arch.mce_banks = kcalloc(KVM_MAX_MCE_BANKS * 4, sizeof(u64),
 				       GFP_KERNEL_ACCOUNT);
@@ -12308,7 +12353,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 fail_free_mce_banks:
 	kfree(vcpu->arch.mce_banks);
 	kfree(vcpu->arch.mci_ctl2_banks);
-	free_page((unsigned long)vcpu->arch.pio_data);
+	if (vcpu->vmpl == 0)
+		free_page((unsigned long)vcpu->arch.pio_data);
 fail_free_lapic:
 	kvm_free_lapic(vcpu);
 fail_mmu_destroy:
@@ -12357,8 +12403,10 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	kvm_mmu_destroy(vcpu);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
-	free_page((unsigned long)vcpu->arch.pio_data);
-	kvfree(vcpu->arch.cpuid_entries);
+	if (vcpu->vmpl == 0) {
+		free_page((unsigned long)vcpu->arch.pio_data);
+		kvfree(vcpu->arch.cpuid_entries);
+	}
 }
 
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fb5c58c90975..806b7ba869cb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -320,6 +320,8 @@ struct kvm_mmio_fragment {
 	unsigned len;
 };
 
+struct kvm_vcpu_vmpl_state;
+
 struct kvm_vcpu {
 	struct kvm *kvm;
 #ifdef CONFIG_PREEMPT_NOTIFIERS
@@ -402,6 +404,21 @@ struct kvm_vcpu {
 	} _common;
 
 	struct kvm_vcpu_common *common;
+
+	struct kvm_vcpu_vmpl_state *vcpu_parent;
+	int vmpl;
+};
+
+struct kvm_vcpu_vmpl_state {
+	/*
+	 * TODO: This array needs to be dynamically allocated to store the
+	 * required number of VMPLs based on the architecture. This has been
+	 * hardcoded to 4 for this RFC for SEV-SNP.
+	 */
+	struct kvm_vcpu *vcpu_vmpl[4];
+	int max_vmpl;
+	int current_vmpl;
+	int target_vmpl;
 };
 
 /*
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 74e40d5d4af4..f81187642347 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -84,6 +84,30 @@ TRACE_EVENT(kvm_set_irq,
 );
 #endif /* defined(CONFIG_HAVE_KVM_IRQCHIP) */
 
+TRACE_EVENT(kvm_rdh2,
+	TP_PROTO(const char *msg, struct kvm_vcpu* vcpu),
+	TP_ARGS(msg, vcpu),
+
+	TP_STRUCT__entry(
+		__string(msg, msg)
+		__field(u32, vcpu_id)
+		__field(u32, vcpu_vmpl)
+		__field(u32, current_vmpl)
+		__field(u32, target_vmpl)
+	),
+
+	TP_fast_assign(
+		__assign_str(msg);
+		__entry->vcpu_id = vcpu ? vcpu->vcpu_id : 0xffffffff;
+		__entry->vcpu_vmpl = vcpu ? vcpu->vmpl : 0xffffffff;
+		__entry->current_vmpl = vcpu ? vcpu->vcpu_parent->current_vmpl : 0xffffffff;
+		__entry->target_vmpl = vcpu ? vcpu->vcpu_parent->target_vmpl : 0xffffffff;
+	),
+
+	TP_printk("%s vcpu_id %X vcpu_vmpl %X current_vmpl %X target_vmpl %X", __get_str(msg), 
+		__entry->vcpu_id, __entry->vcpu_vmpl, __entry->current_vmpl, __entry->target_vmpl)
+);
+
 #if defined(__KVM_HAVE_IOAPIC)
 #define kvm_deliver_mode		\
 	{0x0, "Fixed"},			\
@@ -489,6 +513,30 @@ TRACE_EVENT(kvm_test_age_hva,
 	TP_printk("mmu notifier test age hva: %#016lx", __entry->hva)
 );
 
+
+TRACE_EVENT(kvm_arch_vcpu_ioctl_run_vtl_switch,
+	TP_PROTO(struct kvm_vcpu_vmpl_state *vcpu_parent),
+	TP_ARGS(vcpu_parent),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, vcpu_id)
+		__field(unsigned int, current_vmpl)
+		__field(unsigned int, target_vmpl)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id	= vcpu_parent->vcpu_vmpl[0]->vcpu_id;
+		__entry->current_vmpl	= vcpu_parent->current_vmpl;
+		__entry->target_vmpl	= vcpu_parent->target_vmpl;
+	),
+
+	TP_printk("vcpu %u: current_vmpl %d, target vtl %d",
+			__entry->vcpu_id,
+			__entry->current_vmpl,
+			__entry->target_vmpl)
+);
+
+
 #endif /* _TRACE_KVM_MAIN_H */
 
 /* This part must be outside protection */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d1874848862d..09687ac0455a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -481,7 +481,10 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 
 static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 {
-	vcpu->common = &vcpu->_common;
+	if (vcpu->vmpl == 0)
+		vcpu->common = &vcpu->_common;
+	else
+		vcpu->common = vcpu->vcpu_parent->vcpu_vmpl[0]->common;
 
 	mutex_init(&vcpu->common->mutex);
 	vcpu->cpu = -1;
@@ -507,18 +510,28 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 
 static void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	kvm_arch_vcpu_destroy(vcpu);
-	kvm_dirty_ring_free(&vcpu->common->dirty_ring);
+	int vmpl;
+	struct kvm_vcpu_vmpl_state *vcpu_parent = vcpu->vcpu_parent;
+	for (vmpl = 0; vmpl <= vcpu_parent->max_vmpl; ++vmpl) {
+		struct kvm_vcpu *vcpu_free = vcpu_parent->vcpu_vmpl[vmpl];
 
-	/*
-	 * No need for rcu_read_lock as VCPU_RUN is the only place that changes
-	 * the vcpu->pid pointer, and at destruction time all file descriptors
-	 * are already gone.
-	 */
-	put_pid(rcu_dereference_protected(vcpu->common->pid, 1));
+		if (vmpl == 0) {
+			/*
+			* No need for rcu_read_lock as VCPU_RUN is the only place that changes
+			* the vcpu->pid pointer, and at destruction time all file descriptors
+			* are already gone.
+			*/
+			put_pid(rcu_dereference_protected(vcpu_free->common->pid, 1));
+
+			free_page((unsigned long)vcpu_free->common->run);
+			kvm_dirty_ring_free(&vcpu_free->common->dirty_ring);
+		}
+
+		kvm_arch_vcpu_destroy(vcpu_free);
 
-	free_page((unsigned long)vcpu->common->run);
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
+		kmem_cache_free(kvm_vcpu_cache, vcpu_free);
+	}
+	kfree(vcpu_parent);
 }
 
 void kvm_destroy_vcpus(struct kvm *kvm)
@@ -3742,7 +3755,11 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		if (kvm_vcpu_check_block(vcpu) < 0)
 			break;
 
+		if (vcpu->vcpu_parent->current_vmpl != vcpu->vcpu_parent->target_vmpl)
+			break;
+
 		waited = true;
+
 		schedule();
 	}
 
@@ -4211,8 +4228,10 @@ static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 {
 	int r;
-	struct kvm_vcpu *vcpu;
-	struct page *page;
+	struct kvm_vcpu_vmpl_state *vcpu_parent;
+	struct page *kvm_run_page;
+	int vmpl;
+	int vcpu_idx;
 
 	/*
 	 * KVM tracks vCPU IDs as 'int', be kind to userspace and reject
@@ -4241,29 +4260,45 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	kvm->created_vcpus++;
 	mutex_unlock(&kvm->lock);
 
-	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
-	if (!vcpu) {
+	vcpu_parent = kzalloc(sizeof(struct kvm_vcpu_vmpl_state), GFP_KERNEL_ACCOUNT);
+	if (!vcpu_parent) {
 		r = -ENOMEM;
 		goto vcpu_decrement;
 	}
 
-	kvm_vcpu_init(vcpu, kvm, id);
+	/* 
+	 * TODO: The max_vmpl needs to be determined for the current architecture. This
+	 * has been hardcoded to 3 for this RFC to match the maximum VMPL for SEV-SNP
+	 */
+	vcpu_parent->max_vmpl = 3;
+	for (vmpl = 0; vmpl <= vcpu_parent->max_vmpl; ++vmpl) {
+		vcpu_parent->vcpu_vmpl[vmpl] = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
+		// TODO: Fix cleanup here
+		if (!vcpu_parent->vcpu_vmpl[vmpl]) {
+			r = -ENOMEM;
+			goto vcpu_decrement;
+		}
+		vcpu_parent->vcpu_vmpl[vmpl]->vcpu_parent = vcpu_parent;
+		vcpu_parent->vcpu_vmpl[vmpl]->vmpl = vmpl;
+
+		kvm_vcpu_init(vcpu_parent->vcpu_vmpl[vmpl], kvm, id);
+
+		r = kvm_arch_vcpu_create(vcpu_parent->vcpu_vmpl[vmpl]);
+		if (r)
+			goto vcpu_free_run_page;
+	}
 
 	BUILD_BUG_ON(sizeof(struct kvm_run) > PAGE_SIZE);
-	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-	if (!page) {
+	kvm_run_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!kvm_run_page) {
 		r = -ENOMEM;
 		goto vcpu_free;
 	}
-	vcpu->common->run = page_address(page);
-
-	r = kvm_arch_vcpu_create(vcpu);
-	if (r)
-		goto vcpu_free_run_page;
+	vcpu_parent->vcpu_vmpl[0]->common->run = page_address(kvm_run_page);
 
 	if (kvm->dirty_ring_size) {
-		r = kvm_dirty_ring_alloc(&vcpu->common->dirty_ring,
-					 id, kvm->dirty_ring_size);
+		r = kvm_dirty_ring_alloc(&vcpu_parent->vcpu_vmpl[0]->common->dirty_ring,
+					id, kvm->dirty_ring_size);
 		if (r)
 			goto arch_vcpu_destroy;
 	}
@@ -4281,18 +4316,21 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 		goto unlock_vcpu_destroy;
 	}
 
-	vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
-	r = xa_reserve(&kvm->vcpu_array, vcpu->vcpu_idx, GFP_KERNEL_ACCOUNT);
+	vcpu_idx = atomic_read(&kvm->online_vcpus);
+	for (vmpl = 0; vmpl <= vcpu_parent->max_vmpl; ++vmpl) {
+		vcpu_parent->vcpu_vmpl[vmpl]->vcpu_idx = vcpu_idx;
+	}
+	r = xa_reserve(&kvm->vcpu_array, vcpu_idx, GFP_KERNEL_ACCOUNT);
 	if (r)
 		goto unlock_vcpu_destroy;
 
 	/* Now it's all set up, let userspace reach it */
 	kvm_get_kvm(kvm);
-	r = create_vcpu_fd(vcpu);
+	r = create_vcpu_fd(vcpu_parent->vcpu_vmpl[0]);
 	if (r < 0)
 		goto kvm_put_xa_release;
 
-	if (KVM_BUG_ON(xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
+	if (KVM_BUG_ON(xa_store(&kvm->vcpu_array, vcpu_idx, vcpu_parent->vcpu_vmpl[0], 0), kvm)) {
 		r = -EINVAL;
 		goto kvm_put_xa_release;
 	}
@@ -4305,22 +4343,28 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	atomic_inc(&kvm->online_vcpus);
 
 	mutex_unlock(&kvm->lock);
-	kvm_arch_vcpu_postcreate(vcpu);
-	kvm_create_vcpu_debugfs(vcpu);
+	for (vmpl = 0; vmpl <= vcpu_parent->max_vmpl; ++vmpl) {
+		kvm_arch_vcpu_postcreate(vcpu_parent->vcpu_vmpl[vmpl]);
+	}
+	kvm_create_vcpu_debugfs(vcpu_parent->vcpu_vmpl[0]);
 	return r;
 
 kvm_put_xa_release:
 	kvm_put_kvm_no_destroy(kvm);
-	xa_release(&kvm->vcpu_array, vcpu->vcpu_idx);
+	xa_release(&kvm->vcpu_array, vcpu_idx);
 unlock_vcpu_destroy:
 	mutex_unlock(&kvm->lock);
-	kvm_dirty_ring_free(&vcpu->common->dirty_ring);
+	kvm_dirty_ring_free(&vcpu_parent->vcpu_vmpl[0]->common->dirty_ring);
 arch_vcpu_destroy:
-	kvm_arch_vcpu_destroy(vcpu);
+	for (vmpl = 0; vmpl <= vcpu_parent->max_vmpl; ++vmpl) {
+		kvm_arch_vcpu_destroy(vcpu_parent->vcpu_vmpl[vmpl]);
+	}
 vcpu_free_run_page:
-	free_page((unsigned long)vcpu->common->run);
+	free_page((unsigned long)vcpu_parent->vcpu_vmpl[0]->common->run);
 vcpu_free:
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
+	for (vmpl = 0; vmpl <= vcpu_parent->max_vmpl; ++vmpl) {
+		kmem_cache_free(kvm_vcpu_cache, vcpu_parent->vcpu_vmpl[vmpl]);
+	}
 vcpu_decrement:
 	mutex_lock(&kvm->lock);
 	kvm->created_vcpus--;
-- 
2.43.0


