Return-Path: <kvm+bounces-71305-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UBgwHN1XlmljeAIAu9opvQ
	(envelope-from <kvm+bounces-71305-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 01:22:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9473415B1E0
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 01:22:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4135C3007A5A
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE48B1EE033;
	Thu, 19 Feb 2026 00:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dsszFhzA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4891F38DF9
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 00:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771460568; cv=none; b=EKHAQqoaJMGhzid/XfLgb0VVYPtmCToTTRvtB0rDmWIi3BVET/eSDHwwLbYD7/Zm2aK8VLmXzViEQS6g5oaQCGwNMJ7lkA9a+a/uHyMIomQ4LgLT9Qo17VIdsK07XPf7BVrG2kwgsc2gMPpDUmhDp9b1cAS/REZOMoMYp4JI7gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771460568; c=relaxed/simple;
	bh=+kfYRyut5KCPJ9oqD/xciY4D45HRWUlxk9oZXB9XTEw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Wfeg6vBJgOFYYg2aZz+C5YwpXvGg4GlgriwyDg/ArwzIlapX3MLlqqolUg4WpY8rVfkwEEBiOskL9nI/hyJG8GGh82PO1kp3vcnPKjDK/KhFo2FRRyifGeixIFD6C2kZ3ZDki3okXdUBulN785t97cPqbJqqgbTGIpbNTtE59zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dsszFhzA; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a75ed2f89dso3207575ad.1
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 16:22:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771460565; x=1772065365; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UYU17NT3llAQaKXfVmEytmqQ3m/43EHrTowtQAG8Io4=;
        b=dsszFhzAR8BDghecZLKG+fkxnsWvDA+s7dbxXENvqiFEEHNzSYOSWjSP7lGgleC3eU
         jul2byvFeZX9XXPzWzESSap1EbNRJns5IIzIsYhuUaQT81T2L7Y9GBwNbaXA2PDSnxU/
         uu/2Lfh2CcCL+BF9GZwp1kf4VCVL/9Qf6NjgJELrkKZvykH5RdS6RlXK7BrloBXm+v32
         81nUeMhVmV9LO9dbcz/YXollSNDdWwavHecnL5WyTlrkP+vFSromxn+MiLJqFueUNMB5
         OSFVAscp7RKxlRKnWuGDA8gTcpdqT0nnYAhtzS4VoGWj98vly2GSvuucXkmx/uRWVHFc
         S8UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771460565; x=1772065365;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UYU17NT3llAQaKXfVmEytmqQ3m/43EHrTowtQAG8Io4=;
        b=Dx8nUj1qGn/edJ6irYdmJTc0pKeurkyfklJMb+j1DCEXV8L8M60rHpfItFqqAMXwAs
         323SK7D9VrnW28YiggAoGSbdqydy5jLm4ruFIvS9KSzX9vE1a2cPlaVXMiGEVqO4sncD
         eIO348wSjV6EUA3+gifVHE6lITt5lvTT5oYZSeS/dkHyLx+xa0ywdSPIk3G20VAFGPR0
         mV2k7oaNITNT9YQ02T+GQ8j2LIKuVeXnNp9hNgDwMVSEUcxdXkC0DufQ4yJVyIlv4PFH
         sF1UEKgwNMAQE2KFv5kGZg5WnWboI5QKlUEb34PjZ90CLcFn6Uqexc8Sl1BuBGrZ/MRn
         GXPA==
X-Gm-Message-State: AOJu0Yzou2z9CZK9Ofopovv/1ZYDtDZSBXcRrOmskQAyujXIqeGEfHsv
	owAew/0t7Bq4VesSgy1TlOvCJercr6oGqsTGD8xpm3uxmEBWStwiJKzsP191DxiGLwiWVxJu+fu
	7KOOeig==
X-Received: from plbkt3.prod.google.com ([2002:a17:903:883:b0:2a4:2817:d023])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:944:b0:2a7:683c:afd0
 with SMTP id d9443c01a7336-2ad1743ca98mr161214405ad.14.1771460564467; Wed, 18
 Feb 2026 16:22:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 18 Feb 2026 16:22:41 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <20260219002241.2908563-1-seanjc@google.com>
Subject: [PATCH] KVM: x86/mmu: Don't create SPTEs for addresses that aren't mappable
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71305-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:email];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 9473415B1E0
X-Rspamd-Action: no action

Track the mask of guest physical address bits that can actually be mapped
by a given MMU instance that utilizes TDP, and either exit to userspace
with -EFAULT or go straight to emulation without creating an SPTE (for
emulated MMIO) if KVM can't map the address.  Attempting to create an SPTE
can cause KVM to drop the unmappable bits, and thus install a bad SPTE.
E.g. when starting a walk, the TDP MMU will round the GFN based on the
root level, and drop the upper bits.

Exit with -EFAULT in the unlikely scenario userspace is misbehaving and
created a memslot that can't be addressed, e.g. if userspace installed
memory above the guest.MAXPHYADDR defined in CPUID, as there's nothing KVM
can do to make forward progress, and there _is_ a memslot for the address.
For emulated MMIO, KVM can at least kick the bad address out to userspace
via a normal MMIO exit.

The flaw has existed for a very long time, and was exposed by commit
988da7820206 ("KVM: x86/tdp_mmu: WARN if PFN changes for spurious faults")
thanks to a syzkaller program that prefaults memory at GPA 0x1000000000000
and then faults in memory at GPA 0x0 (the extra-large GPA gets wrapped to
'0').

  WARNING: arch/x86/kvm/mmu/tdp_mmu.c:1183 at kvm_tdp_mmu_map+0x5c3/0xa30 [kvm], CPU#125: syz.5.22/18468
  CPU: 125 UID: 0 PID: 18468 Comm: syz.5.22 Tainted: G S      W           6.19.0-smp--23879af241d6-next #57 NONE
  Tainted: [S]=CPU_OUT_OF_SPEC, [W]=WARN
  Hardware name: Google Izumi-EMR/izumi, BIOS 0.20250917.0-0 09/17/2025
  RIP: 0010:kvm_tdp_mmu_map+0x5c3/0xa30 [kvm]
  Call Trace:
   <TASK>
   kvm_tdp_page_fault+0x107/0x140 [kvm]
   kvm_mmu_do_page_fault+0x121/0x200 [kvm]
   kvm_arch_vcpu_pre_fault_memory+0x18c/0x230 [kvm]
   kvm_vcpu_pre_fault_memory+0x116/0x1e0 [kvm]
   kvm_vcpu_ioctl+0x3a5/0x6b0 [kvm]
   __se_sys_ioctl+0x6d/0xb0
   do_syscall_64+0x8d/0x900
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
   </TASK>

In practice, the flaw is benign (other than the new WARN) as it only
affects guests that ignore guest.MAXPHYADDR (e.g. on CPUs with 52-bit
physical addresses but only 4-level paging) or guests being run by a
misbehaving userspace VMM (e.g. a VMM that ignored allow_smaller_maxphyaddr
or is pre-faulting bad addresses).

For non-TDP shadow paging, always clear the unmappable mask as the flaw
only affects GPAs affected.  For 32-bit paging, 64-bit virtual addresses
simply don't exist.  Even when software can shove a 64-bit address
somewhere, e.g. into SYSENTER_EIP, the value is architecturally truncated
before it reaches the page table walker.  And for 64-bit paging, KVM's use
of 4-level vs. 5-level paging is tied to the guest's CR4.LA57, i.e. KVM
won't observe a 57-bit virtual address with a 4-level MMU.

Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  6 +++++
 arch/x86/kvm/mmu/mmu.c          | 42 +++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ff07c45e3c73..43b9777b896d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -493,6 +493,12 @@ struct kvm_mmu {
 	 */
 	u8 permissions[16];
 
+	/*
+	 * Mask of address bits that KVM can't map with this MMU given the root
+	 * level, e.g. 5-level EPT/NPT only consume bits 51:0.
+	 */
+	gpa_t unmappable_mask;
+
 	u64 *pae_root;
 	u64 *pml4_root;
 	u64 *pml5_root;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3911ac9bddfd..2dc9a297e6ed 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3540,6 +3540,14 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
 	if (unlikely(fault->gfn > kvm_mmu_max_gfn()))
 		return RET_PF_EMULATE;
 
+	/*
+	 * Similarly, if KVM can't map the faulting address, don't attempt to
+	 * install a SPTE because KVM will effectively truncate the address
+	 * when walking KVM's page tables.
+	 */
+	if (unlikely(fault->addr & vcpu->arch.mmu->unmappable_mask))
+		return RET_PF_EMULATE;
+
 	return RET_PF_CONTINUE;
 }
 
@@ -4681,6 +4689,11 @@ static int kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 		return RET_PF_RETRY;
 	}
 
+	if (fault->addr & vcpu->arch.mmu->unmappable_mask) {
+		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+		return -EFAULT;
+	}
+
 	if (slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT) {
 		/*
 		 * Don't map L1's APIC access page into L2, KVM doesn't support
@@ -5772,6 +5785,29 @@ u8 kvm_mmu_get_max_tdp_level(void)
 	return tdp_root_level ? tdp_root_level : max_tdp_level;
 }
 
+static void reset_tdp_unmappable_mask(struct kvm_mmu *mmu)
+{
+	int max_addr_bit;
+
+	switch (mmu->root_role.level) {
+	case PT64_ROOT_5LEVEL:
+		max_addr_bit = 52;
+		break;
+	case PT64_ROOT_4LEVEL:
+		max_addr_bit = 48;
+		break;
+	case PT32E_ROOT_LEVEL:
+		max_addr_bit = 32;
+		break;
+	default:
+		WARN_ONCE(1, "Unhandled root level %u\n", mmu->root_role.level);
+		mmu->unmappable_mask = 0;
+		return;
+	}
+
+	mmu->unmappable_mask = rsvd_bits(max_addr_bit, 63);
+}
+
 static union kvm_mmu_page_role
 kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 				union kvm_cpu_role cpu_role)
@@ -5816,6 +5852,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	else
 		context->gva_to_gpa = paging32_gva_to_gpa;
 
+	reset_tdp_unmappable_mask(context);
 	reset_guest_paging_metadata(vcpu, context);
 	reset_tdp_shadow_zero_bits_mask(context);
 }
@@ -5889,6 +5926,8 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 		root_role.passthrough = 1;
 
 	shadow_mmu_init_context(vcpu, context, cpu_role, root_role);
+	reset_tdp_unmappable_mask(context);
+
 	kvm_mmu_new_pgd(vcpu, nested_cr3);
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_init_shadow_npt_mmu);
@@ -5939,6 +5978,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 
 		update_permission_bitmask(context, true);
 		context->pkru_mask = 0;
+		reset_tdp_unmappable_mask(context);
 		reset_rsvds_bits_mask_ept(vcpu, context, execonly, huge_page_level);
 		reset_ept_shadow_zero_bits_mask(context, execonly);
 	}
@@ -5954,6 +5994,8 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
 
 	kvm_init_shadow_mmu(vcpu, cpu_role);
 
+	context->unmappable_mask = 0;
+
 	context->get_guest_pgd     = get_guest_cr3;
 	context->get_pdptr         = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;

base-commit: 183bb0ce8c77b0fd1fb25874112bc8751a461e49
-- 
2.53.0.345.g96ddfc5eaa-goog


