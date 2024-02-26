Return-Path: <kvm+bounces-9900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FE76867908
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:50:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E9891C28D51
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:50:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E70961386D0;
	Mon, 26 Feb 2024 14:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GB1Mcbht"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCDA12CD9D;
	Mon, 26 Feb 2024 14:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958201; cv=none; b=rdt0UKqa0NKfjO+7tZdr9qM40Gn3DCesCiPIawPR4bOkG9nwcvDOYKFU/1lCL4tkVL3IKNekJXTj/6mupN7MhuRtbE89mRY3bZVpEGTvKGJ4UgS0GV4XgvLEXNaimYumupT0x4VkN3GI34GjXL+RBY4zJLY00AFxsmyVcA11WhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958201; c=relaxed/simple;
	bh=Pc+HjLDfkMboz1gri9VqQXOqgPnZdAnlcdum7tFbpTQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JuLZ64R2Nl5Kh0TWd8FpglwPPvcDWvyLGh9EJgJBcLFqCLlycQfucH95yU8AvNS5gSkfzVwGGSKA3EAcc//7ZCDXbjcCLjqSBVXQQ3O4x+qavZI53YZe33gRMflhXARKsfZnU8TmHyT3BpOUmQ3mi9tupKC8xwdlhNSbApl3m/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GB1Mcbht; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e54451edc6so9825b3a.1;
        Mon, 26 Feb 2024 06:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958198; x=1709562998; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PuLDsBuYqqEPmR/eGtiQciHTrvGTXGMZNjGacLqQFso=;
        b=GB1McbhtC3WDTZqvffoHZUu4vQ0W5EPZ25bpbIvK6jEwxnCZTl3eV/XjdXzGE0VwLH
         xXliAadMbDVB/3F/DdirwBEoPULAKReZqpbo+95gvLW80yWonnOnzJH/56yv9exjgSua
         0pCXTb8GR30jS8oSugX8GPh+lJ9KMpGnHLhmz7oxlnTInNEMjevLOlsPCGCWPN89eD1W
         JeoOlLpQMCnm9vyF5yW0U42qIBCFBWc3DDqxuPhiK/Oly8iX6bbEdfTnBHegvmVdX3ue
         XUcE91U7Gfh+kPpKtK4o+XqdP+Ml4Wcz4NOVHsNYEb5b3EpTaCtcZYEbI3hR7leXqkfT
         ygCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958198; x=1709562998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PuLDsBuYqqEPmR/eGtiQciHTrvGTXGMZNjGacLqQFso=;
        b=HQzPTfEKceOolE8GlYfXlmHtFhbP6Jc7KM0HCWLhnaaeChi/ooMEd89xs9G/zKWpiy
         grmy5vivXXyBck+bKCEIqhTtN5Lv3TyydNnNunwa+5Npv9FZA79om+eKvpQhJsRaQ4Xx
         9rbHz409ORP4rcc7ADNV+D5nf4/+TKWBBerGY7zeBJLjlKxRPMLUBcDIz0lMTLL69LUN
         4rDVWCjVWBZJvcWeqPY1Bu5agyZHFnPERNVCkDdpDh/bec+Blp4X04m9VkM2qrNr/yLz
         0U6sty+xVUCEmC2yFyS0Pd0qoHcAnjdAfnDEkQnwryTNvQOQbyx78l5Lfy5OW/FPIsS5
         ck/A==
X-Forwarded-Encrypted: i=1; AJvYcCUjK5wCiuC/CytL0CXjUC/pH1EqMf7PPtcBEbv72rxcIPdrhOZfeu916c40rm5pehYkl6RP7opu4MC7Qrb1kytMn7lf
X-Gm-Message-State: AOJu0YxZfxLyRNuMgHFamxJ2hRPIhF69i5R3PPC4sFtcIcIfHp4QwSXM
	Cue5npnLZJDERbeZ31kOSjiVoNj3ptQP8+K2mTlCW/tvn50Uil+3wA12QhS2
X-Google-Smtp-Source: AGHT+IFQ/3bBQbOGHcBQV+UZbU9IzhmalAj69TR3Xp69m0QhVzQTXpB57NuE5HaVWReOIpYQxxz5xg==
X-Received: by 2002:a05:6a21:2d09:b0:1a0:fd3e:532c with SMTP id tw9-20020a056a212d0900b001a0fd3e532cmr4098092pzb.17.1708958198571;
        Mon, 26 Feb 2024 06:36:38 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id c9-20020a056a00008900b006e4452bd4c6sm4114532pfj.157.2024.02.26.06.36.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:36:38 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 37/73] KVM: x86/PVM: Use host PCID to reduce guest TLB flushing
Date: Mon, 26 Feb 2024 22:35:54 +0800
Message-Id: <20240226143630.33643-38-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Since the host doesn't use all PCIDs, PVM can utilize the host PCID to
reduce guest TLB flushing. The PCID allocation algorithm in PVM is
similar to that of the host.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 228 ++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/pvm/pvm.h |   5 +
 2 files changed, 232 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index 242c355fda8f..2d3785e7f2f3 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -349,6 +349,211 @@ static void pvm_switch_to_host(struct vcpu_pvm *pvm)
 	preempt_enable();
 }
 
+struct host_pcid_one {
+	/*
+	 * It is struct vcpu_pvm *pvm, but it is not allowed to be
+	 * dereferenced since it might be freed.
+	 */
+	void *pvm;
+	u64 root_hpa;
+};
+
+struct host_pcid_state {
+	struct host_pcid_one pairs[NUM_HOST_PCID_FOR_GUEST];
+	int evict_next_round_robin;
+};
+
+static DEFINE_PER_CPU(struct host_pcid_state, pvm_tlb_state);
+
+static void host_pcid_flush_all(struct vcpu_pvm *pvm)
+{
+	struct host_pcid_state *tlb_state = this_cpu_ptr(&pvm_tlb_state);
+	int i;
+
+	for (i = 0; i < NUM_HOST_PCID_FOR_GUEST; i++) {
+		if (tlb_state->pairs[i].pvm == pvm)
+			tlb_state->pairs[i].pvm = NULL;
+	}
+}
+
+static inline unsigned int host_pcid_to_index(unsigned int host_pcid)
+{
+	return host_pcid & ~HOST_PCID_TAG_FOR_GUEST;
+}
+
+static inline int index_to_host_pcid(int index)
+{
+	return index | HOST_PCID_TAG_FOR_GUEST;
+}
+
+/*
+ * Free the uncached guest pcid (not in mmu->root nor mmu->prev_root), so
+ * that the next allocation would not evict a clean one.
+ *
+ * It would be better if kvm.ko notifies us when a root_pgd is freed
+ * from the cache.
+ *
+ * Returns a freed index or -1 if nothing is freed.
+ */
+static int host_pcid_free_uncached(struct vcpu_pvm *pvm)
+{
+	/* It is allowed to do nothing. */
+	return -1;
+}
+
+/*
+ * Get a host pcid of the current pCPU for the specific guest pgd.
+ * PVM vTLB is guest pgd tagged.
+ */
+static int host_pcid_get(struct vcpu_pvm *pvm, u64 root_hpa, bool *flush)
+{
+	struct host_pcid_state *tlb_state = this_cpu_ptr(&pvm_tlb_state);
+	int i, j = -1;
+
+	/* find if it is allocated. */
+	for (i = 0; i < NUM_HOST_PCID_FOR_GUEST; i++) {
+		struct host_pcid_one *tlb = &tlb_state->pairs[i];
+
+		if (tlb->root_hpa == root_hpa && tlb->pvm == pvm)
+			return index_to_host_pcid(i);
+
+		/* if it has no owner, allocate it if not found. */
+		if (!tlb->pvm)
+			j = i;
+	}
+
+	/*
+	 * Fallback to:
+	 *    use the fallback recorded in the above loop.
+	 *    use a freed uncached.
+	 *    evict one (which might be still usable) by round-robin policy.
+	 */
+	if (j < 0)
+		j = host_pcid_free_uncached(pvm);
+	if (j < 0) {
+		j = tlb_state->evict_next_round_robin;
+		if (++tlb_state->evict_next_round_robin == NUM_HOST_PCID_FOR_GUEST)
+			tlb_state->evict_next_round_robin = 0;
+	}
+
+	/* associate the host pcid to the guest */
+	tlb_state->pairs[j].pvm = pvm;
+	tlb_state->pairs[j].root_hpa = root_hpa;
+
+	*flush = true;
+	return index_to_host_pcid(j);
+}
+
+static void host_pcid_free(struct vcpu_pvm *pvm, u64 root_hpa)
+{
+	struct host_pcid_state *tlb_state = this_cpu_ptr(&pvm_tlb_state);
+	int i;
+
+	for (i = 0; i < NUM_HOST_PCID_FOR_GUEST; i++) {
+		struct host_pcid_one *tlb = &tlb_state->pairs[i];
+
+		if (tlb->root_hpa == root_hpa && tlb->pvm == pvm) {
+			tlb->pvm = NULL;
+			return;
+		}
+	}
+}
+
+static inline void *host_pcid_owner(int host_pcid)
+{
+	return this_cpu_read(pvm_tlb_state.pairs[host_pcid_to_index(host_pcid)].pvm);
+}
+
+static inline u64 host_pcid_root(int host_pcid)
+{
+	return this_cpu_read(pvm_tlb_state.pairs[host_pcid_to_index(host_pcid)].root_hpa);
+}
+
+static void __pvm_hwtlb_flush_all(struct vcpu_pvm *pvm)
+{
+	if (static_cpu_has(X86_FEATURE_PCID))
+		host_pcid_flush_all(pvm);
+}
+
+static void pvm_flush_hwtlb(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+
+	get_cpu();
+	__pvm_hwtlb_flush_all(pvm);
+	put_cpu();
+}
+
+static void pvm_flush_hwtlb_guest(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * flushing hwtlb for guest only when:
+	 *	change to the shadow page table.
+	 *	reused an used (guest) pcid.
+	 * change to the shadow page table always results flushing hwtlb
+	 * and PVM uses pgd tagged tlb.
+	 *
+	 * So no hwtlb needs to be flushed here.
+	 */
+}
+
+static void pvm_flush_hwtlb_current(struct kvm_vcpu *vcpu)
+{
+	/* No flush required if the current context is invalid. */
+	if (!VALID_PAGE(vcpu->arch.mmu->root.hpa))
+		return;
+
+	if (static_cpu_has(X86_FEATURE_PCID)) {
+		get_cpu();
+		host_pcid_free(to_pvm(vcpu), vcpu->arch.mmu->root.hpa);
+		put_cpu();
+	}
+}
+
+static void pvm_flush_hwtlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	int max = MIN_HOST_PCID_FOR_GUEST + NUM_HOST_PCID_FOR_GUEST;
+	int i;
+
+	if (!static_cpu_has(X86_FEATURE_PCID))
+		return;
+
+	get_cpu();
+	if (!this_cpu_has(X86_FEATURE_INVPCID)) {
+		host_pcid_flush_all(pvm);
+		put_cpu();
+		return;
+	}
+
+	host_pcid_free_uncached(pvm);
+	for (i = MIN_HOST_PCID_FOR_GUEST; i < max; i++) {
+		if (host_pcid_owner(i) == pvm)
+			invpcid_flush_one(i, addr);
+	}
+
+	put_cpu();
+}
+
+static void pvm_set_host_cr3_for_guest_with_host_pcid(struct vcpu_pvm *pvm)
+{
+	u64 root_hpa = pvm->vcpu.arch.mmu->root.hpa;
+	bool flush = false;
+	u32 host_pcid = host_pcid_get(pvm, root_hpa, &flush);
+	u64 hw_cr3 = root_hpa | host_pcid;
+
+	if (!flush)
+		hw_cr3 |= CR3_NOFLUSH;
+	this_cpu_write(cpu_tss_rw.tss_ex.enter_cr3, hw_cr3);
+}
+
+static void pvm_set_host_cr3_for_guest_without_host_pcid(struct vcpu_pvm *pvm)
+{
+	u64 root_hpa = pvm->vcpu.arch.mmu->root.hpa;
+
+	this_cpu_write(cpu_tss_rw.tss_ex.enter_cr3, root_hpa);
+}
+
 static void pvm_set_host_cr3_for_hypervisor(struct vcpu_pvm *pvm)
 {
 	unsigned long cr3;
@@ -365,7 +570,11 @@ static void pvm_set_host_cr3_for_hypervisor(struct vcpu_pvm *pvm)
 static void pvm_set_host_cr3(struct vcpu_pvm *pvm)
 {
 	pvm_set_host_cr3_for_hypervisor(pvm);
-	this_cpu_write(cpu_tss_rw.tss_ex.enter_cr3, pvm->vcpu.arch.mmu->root.hpa);
+
+	if (static_cpu_has(X86_FEATURE_PCID))
+		pvm_set_host_cr3_for_guest_with_host_pcid(pvm);
+	else
+		pvm_set_host_cr3_for_guest_without_host_pcid(pvm);
 }
 
 static void pvm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
@@ -391,6 +600,9 @@ static void pvm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	__this_cpu_write(active_pvm_vcpu, pvm);
 
+	if (vcpu->cpu != cpu)
+		__pvm_hwtlb_flush_all(pvm);
+
 	indirect_branch_prediction_barrier();
 }
 
@@ -398,6 +610,7 @@ static void pvm_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_pvm *pvm = to_pvm(vcpu);
 
+	host_pcid_free_uncached(pvm);
 	pvm_prepare_switch_to_host(pvm);
 }
 
@@ -2086,6 +2299,11 @@ static struct kvm_x86_ops pvm_x86_ops __initdata = {
 	.set_rflags = pvm_set_rflags,
 	.get_if_flag = pvm_get_if_flag,
 
+	.flush_tlb_all = pvm_flush_hwtlb,
+	.flush_tlb_current = pvm_flush_hwtlb_current,
+	.flush_tlb_gva = pvm_flush_hwtlb_gva,
+	.flush_tlb_guest = pvm_flush_hwtlb_guest,
+
 	.vcpu_pre_run = pvm_vcpu_pre_run,
 	.vcpu_run = pvm_vcpu_run,
 	.handle_exit = pvm_handle_exit,
@@ -2152,8 +2370,16 @@ static void pvm_exit(void)
 }
 module_exit(pvm_exit);
 
+#define TLB_NR_DYN_ASIDS	6
+
 static int __init hardware_cap_check(void)
 {
+	BUILD_BUG_ON(MIN_HOST_PCID_FOR_GUEST <= TLB_NR_DYN_ASIDS);
+#ifdef CONFIG_PAGE_TABLE_ISOLATION
+	BUILD_BUG_ON((MIN_HOST_PCID_FOR_GUEST + NUM_HOST_PCID_FOR_GUEST) >=
+		     (1 << X86_CR3_PTI_PCID_USER_BIT));
+#endif
+
 	/*
 	 * switcher can't be used when KPTI. See the comments above
 	 * SWITCHER_SAVE_AND_SWITCH_TO_HOST_CR3
diff --git a/arch/x86/kvm/pvm/pvm.h b/arch/x86/kvm/pvm/pvm.h
index 4cdcbed1c813..31060831e009 100644
--- a/arch/x86/kvm/pvm/pvm.h
+++ b/arch/x86/kvm/pvm/pvm.h
@@ -28,6 +28,11 @@ extern u64 *host_mmu_root_pgd;
 void host_mmu_destroy(void);
 int host_mmu_init(void);
 
+#define HOST_PCID_TAG_FOR_GUEST			(32)
+
+#define MIN_HOST_PCID_FOR_GUEST			HOST_PCID_TAG_FOR_GUEST
+#define NUM_HOST_PCID_FOR_GUEST			HOST_PCID_TAG_FOR_GUEST
+
 struct vcpu_pvm {
 	struct kvm_vcpu vcpu;
 
-- 
2.19.1.6.gb485710b


