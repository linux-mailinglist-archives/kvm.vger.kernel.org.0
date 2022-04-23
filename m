Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28EA50C71C
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 06:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbiDWDvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 23:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbiDWDvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 23:51:22 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94CE1C65EE
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:26 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id j8-20020aa78d08000000b0050ade744b37so4508868pfe.16
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=YY8H3iTygcq3QVv8LQgrDAaxhN4Yk1aATZLxq6rfZiU=;
        b=MsteZce6/w12u24Ta6z0Wiz+JiCEC6QQcGbGjaMpfop07BYflnQdSzMl3aU5y1eIp+
         ScPzgjJmFkmxpJQJlNKccfNZgqWiSxk3DbkOeNNAHa0/LJpEH/TECQZiCe3TKU6R/asC
         59kXNskB9aFnAtcJ8W68Cg/OYIiRkOWL6dWhFO8tOksfy9hhjlNQ6lLWpTCX8hkJhVeO
         svt4uiS6FlxbmN9Z95Iq7HP/MuvMtaf5csjKhkP+4RRYi++5F/E6X0hn2AM+wNRVUWGS
         LlEJsDipAlEiOC9yRinRHr33MzFJ7UNtr+cTIDnf0wlvIuGKqUaTFbwjRJE9SsbUBmBL
         9Ngg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=YY8H3iTygcq3QVv8LQgrDAaxhN4Yk1aATZLxq6rfZiU=;
        b=HVgfu9L/3403rWmic6fblZY3uAaIUnOYBwNgbDvCEZDr/dx67V9Wwg86IVAYA5uxw9
         B0721Amq4i8A7lqenSms8+nn9KENVKS8bJ38IXCLoyjIxOzXoHkLYqvbREQDW5yt4LbI
         AET57AqIfeF7JatjqVPwWhzKYPtvAfzUtTZyvFRdUZPIpAqjRtq8mdlNy2WAgw1zYOVX
         X7fE//Yw3SqnZDKhFs/VpP2E5w7Zp2XYbnW0nlYcmiCguL9vAM3vNalv7zuMUeStwA4q
         sigyYagkctiDaYFRlwrW+y5+wRvuKKzO6YcT602Hetm+lVBnhesFt710lMUjBFiXD6HJ
         +nxw==
X-Gm-Message-State: AOAM531SYF503Nh8CZw53b0mEMGYX3b9l4fKlf77CUhbj4K5XRRJiRtq
        TrLf5R02Av7QQ9i6Wnttd/WOZVWImRQ=
X-Google-Smtp-Source: ABdhPJzSTsbeEjfeieThDJe75FkXMw8fvWL8YHFt1inu2y4xMtSc+OenEYhKMblhZ2rOLi/mB6JMbzTrtQw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:f68e:b0:15c:4367:d1a0 with SMTP id
 l14-20020a170902f68e00b0015c4367d1a0mr5362196plg.164.1650685706328; Fri, 22
 Apr 2022 20:48:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 03:47:49 +0000
In-Reply-To: <20220423034752.1161007-1-seanjc@google.com>
Message-Id: <20220423034752.1161007-10-seanjc@google.com>
Mime-Version: 1.0
References: <20220423034752.1161007-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 09/12] KVM: x86/mmu: Expand and clean up page fault stats
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expand and clean up the page fault stats.  The current stats are at best
incomplete, and at worst misleading.  Differentiate between faults that
are actually fixed vs those that result in an MMIO SPTE being created,
track faults that are spurious, faults that trigger emulation, faults
that that are fixed in the fast path, and last but not least, track the
number of faults that are taken.

Note, the number of faults that require emulation for write-protected
shadow pages can roughly be calculated by subtracting the number of MMIO
SPTEs created from the overall number of faults that trigger emulation.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++++
 arch/x86/kvm/mmu/mmu.c          |  7 +++++--
 arch/x86/kvm/mmu/mmu_internal.h | 28 ++++++++++++++++++++++++++--
 arch/x86/kvm/mmu/paging_tmpl.h  |  1 -
 arch/x86/kvm/mmu/tdp_mmu.c      |  8 +-------
 arch/x86/kvm/x86.c              |  5 +++++
 6 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f164c6c1514a..c5fb4115176d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1269,7 +1269,12 @@ struct kvm_vm_stat {
 
 struct kvm_vcpu_stat {
 	struct kvm_vcpu_stat_generic generic;
+	u64 pf_taken;
 	u64 pf_fixed;
+	u64 pf_emulate;
+	u64 pf_spurious;
+	u64 pf_fast;
+	u64 pf_mmio_spte_created;
 	u64 pf_guest;
 	u64 tlb_flush;
 	u64 invlpg;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8b8b62d2a903..744c06bd7017 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2660,6 +2660,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 		 *sptep, write_fault, gfn);
 
 	if (unlikely(is_noslot_pfn(pfn))) {
+		vcpu->stat.pf_mmio_spte_created++;
 		mark_mmio_spte(vcpu, sptep, gfn, pte_access);
 		return RET_PF_EMULATE;
 	}
@@ -2943,7 +2944,6 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		return ret;
 
 	direct_pte_prefetch(vcpu, it.sptep);
-	++vcpu->stat.pf_fixed;
 	return ret;
 }
 
@@ -3206,6 +3206,9 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	trace_fast_page_fault(vcpu, fault, sptep, spte, ret);
 	walk_shadow_page_lockless_end(vcpu);
 
+	if (ret != RET_PF_INVALID)
+		vcpu->stat.pf_fast++;
+
 	return ret;
 }
 
@@ -5311,7 +5314,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	write_unlock(&vcpu->kvm->mmu_lock);
 }
 
-int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
+int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len)
 {
 	int r, emulation_type = EMULTYPE_PF;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 9caa747ee033..bd2a26897b97 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -248,11 +248,35 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
 	};
+	int r;
+
+	/*
+	 * Async #PF "faults", a.k.a. prefetch faults, are not faults from the
+	 * guest perspective and have already been counted at the time of the
+	 * original fault.
+	 */
+	if (!prefetch)
+		vcpu->stat.pf_taken++;
 
 	if (IS_ENABLED(CONFIG_RETPOLINE) && fault.is_tdp)
-		return kvm_tdp_page_fault(vcpu, &fault);
+		r = kvm_tdp_page_fault(vcpu, &fault);
+	else
+		r = vcpu->arch.mmu->page_fault(vcpu, &fault);
 
-	return vcpu->arch.mmu->page_fault(vcpu, &fault);
+	/*
+	 * Similar to above, prefetch faults aren't truly spurious, and the
+	 * async #PF path doesn't do emulation.  Do count faults that are fixed
+	 * by the async #PF handler though, otherwise they'll never be counted.
+	 */
+	if (r == RET_PF_FIXED)
+		vcpu->stat.pf_fixed++;
+	else if (prefetch)
+		;
+	else if (r == RET_PF_EMULATE)
+		vcpu->stat.pf_emulate++;
+	else if (r == RET_PF_SPURIOUS)
+		vcpu->stat.pf_spurious++;
+	return r;
 }
 
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 7f8f1c8dbed2..db80f7ccaa4e 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -723,7 +723,6 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		return ret;
 
 	FNAME(pte_prefetch)(vcpu, gw, it.sptep);
-	++vcpu->stat.pf_fixed;
 	return ret;
 
 out_gpte_changed:
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a2eda3e55697..8089beb312d1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1099,6 +1099,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 
 	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
 	if (unlikely(is_mmio_spte(new_spte))) {
+		vcpu->stat.pf_mmio_spte_created++;
 		trace_mark_mmio_spte(rcu_dereference(iter->sptep), iter->gfn,
 				     new_spte);
 		ret = RET_PF_EMULATE;
@@ -1107,13 +1108,6 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 				       rcu_dereference(iter->sptep));
 	}
 
-	/*
-	 * Increase pf_fixed in both RET_PF_EMULATE and RET_PF_FIXED to be
-	 * consistent with legacy MMU behavior.
-	 */
-	if (ret != RET_PF_SPURIOUS)
-		vcpu->stat.pf_fixed++;
-
 	return ret;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7663c35a5c70..a6441b281fb3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -266,7 +266,12 @@ const struct kvm_stats_header kvm_vm_stats_header = {
 
 const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
+	STATS_DESC_COUNTER(VCPU, pf_taken),
 	STATS_DESC_COUNTER(VCPU, pf_fixed),
+	STATS_DESC_COUNTER(VCPU, pf_emulate),
+	STATS_DESC_COUNTER(VCPU, pf_spurious),
+	STATS_DESC_COUNTER(VCPU, pf_fast),
+	STATS_DESC_COUNTER(VCPU, pf_mmio_spte_created),
 	STATS_DESC_COUNTER(VCPU, pf_guest),
 	STATS_DESC_COUNTER(VCPU, tlb_flush),
 	STATS_DESC_COUNTER(VCPU, invlpg),
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

