Return-Path: <kvm+bounces-61087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 82922C096CB
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 18:26:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BE9A54F2658
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 16:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5801826F45A;
	Sat, 25 Oct 2025 16:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JQnITyHD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B54216132F;
	Sat, 25 Oct 2025 16:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408917; cv=none; b=CujHRfdFEk8M+95LCua9hdlTQkERSCqZGbYjBmSKzpbTP3wI56xAbeBb8Mm3pCQenScbuo5O9kz0EhVyNWyNDcyKcFb4r2D9NUctqpBLfj2buszeHFHuI/7BrnyHvZ9JG4feDMyQ5U09Z1h9xL3c94AsCZkxJxhJ6iMxvoOwt/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408917; c=relaxed/simple;
	bh=7icf260TH1IAOojXz4oeHWOxBrQ1Dszrfs+Mac3MNK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iBVl8N6syf8OW//9UHAfux4lKsW6tlLLMu+foM9GjIpHmWqgXuHMM1wSe6AnL651ggHa8jIymHEwgWzZGt8He0UnTufPc8cwV+eNvxA77x2g7tKfcjAgLhNrZT/R35RTHJ+Ybm/56rdkqn3kCQlM92/xPm23uM8gxy/xvmv9LvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JQnITyHD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9EBC116B1;
	Sat, 25 Oct 2025 16:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408917;
	bh=7icf260TH1IAOojXz4oeHWOxBrQ1Dszrfs+Mac3MNK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JQnITyHDcJw+mivB9dl35H3w7yvPwGn0T9PPEeGmi1ZOlh3MlDDkw+uAPNYhsRTlv
	 KSllhwBROOmr/FWPv5r69kM4z808s1SqkSG8ToCJZjjDjzmrC42k3qYCUYiji2wSsT
	 K65ZQ4mJ28LlXXv/Z7LLMxDiuV1meIYGlq2DYSECuRP151MW/duXOc1oLh2h1F4tlH
	 h8sCz0MqiNSCNnwheCuXuQorQkEAGsEVdGLx8HE7WyRAuL41SGLjUin7qXT3wl3UsF
	 yxdYh+5ljC5PsZOwiJuemtZedTKSCcqzZdW12PlCFtKisYCw6Nl2R/BzWC4TxFh4NH
	 V2+jfMAfyKSDg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Li RongQing <lirongqing@baidu.com>,
	Sean Christopherson <seanjc@google.com>,
	Wangyang Guo <wangyang.guo@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.10] x86/kvm: Prefer native qspinlock for dedicated vCPUs irrespective of PV_UNHALT
Date: Sat, 25 Oct 2025 11:56:01 -0400
Message-ID: <20251025160905.3857885-130-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 960550503965094b0babd7e8c83ec66c8a763b0b ]

The commit b2798ba0b876 ("KVM: X86: Choose qspinlock when dedicated
physical CPUs are available") states that when PV_DEDICATED=1
(vCPU has dedicated pCPU), qspinlock should be preferred regardless of
PV_UNHALT.  However, the current implementation doesn't reflect this: when
PV_UNHALT=0, we still use virt_spin_lock() even with dedicated pCPUs.

This is suboptimal because:
1. Native qspinlocks should outperform virt_spin_lock() for dedicated
   vCPUs irrespective of HALT exiting
2. virt_spin_lock() should only be preferred when vCPUs may be preempted
   (non-dedicated case)

So reorder the PV spinlock checks to:
1. First handle dedicated pCPU case (disable virt_spin_lock_key)
2. Second check single CPU, and nopvspin configuration
3. Only then check PV_UNHALT support

This ensures we always use native qspinlock for dedicated vCPUs, delivering
pretty performance gains at high contention levels.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Tested-by: Wangyang Guo <wangyang.guo@intel.com>
Link: https://lore.kernel.org/r/20250722110005.4988-1-lirongqing@baidu.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Aligns behavior with the earlier policy “Choose qspinlock when
    dedicated physical CPUs are available” (commit b2798ba0b876):
    dedicated vCPUs should prefer native qspinlock regardless of
    PV_UNHALT support. Previously, if the host lacked
    `KVM_FEATURE_PV_UNHALT`, `kvm_spinlock_init()` returned early and
    never disabled the `virt_spin_lock()` hijack, leaving guests with
    the TAS fallback even on dedicated pCPUs, which is suboptimal for
    performance under contention.

- Key code changes and their effect
  - Reorders checks in `kvm_spinlock_init()` so the “dedicated pCPUs”
    path is handled before testing for `KVM_FEATURE_PV_UNHALT`:
    - Dedicated vCPU: `if (kvm_para_has_hint(KVM_HINTS_REALTIME)) { ...
      goto out; }` now runs first, followed by single-CPU and `nopvspin`
      checks; only then does it test
      `!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT)`
      (arch/x86/kernel/kvm.c:1095–1135).
    - The `out:` label disables `virt_spin_lock_key` with
      `static_branch_disable(&virt_spin_lock_key);`
      (arch/x86/kernel/kvm.c:1135). This forces native qspinlock instead
      of the virt TAS path.
  - Why this matters:
    - In guests, `native_pv_lock_init()` enables the
      `virt_spin_lock_key` when running under a hypervisor
      (arch/x86/kernel/paravirt.c:60). If `kvm_spinlock_init()` bails
      out early on “no PV_UNHALT”, the key remains enabled and
      `virt_spin_lock()` gets used.
    - `virt_spin_lock()` is gated by the key; when enabled it uses a
      Test-and-Set fallback for hypervisors without PV spinlock support
      (arch/x86/include/asm/qspinlock.h:88–110). For dedicated vCPUs,
      this fallback is slower than native qspinlock and unnecessary.
    - After this change, dedicated vCPUs always hit `goto out;` →
      `static_branch_disable(&virt_spin_lock_key);`, so
      `virt_spin_lock()` immediately returns false
      (arch/x86/include/asm/qspinlock.h:92), and the native qspinlock
      path is used, matching the intended behavior.

- Scope and containment
  - Single function change in `arch/x86/kernel/kvm.c`; no ABI or
    architectural changes.
  - Behavior when `KVM_FEATURE_PV_UNHALT` is present remains unchanged;
    the fix only corrects the corner case when PV_UNHALT is absent.
  - Also harmonizes single-CPU and `nopvspin` behavior in the no-
    PV_UNHALT case by ensuring the static key is disabled via the same
    `goto out` path, which is consistent with the printed messages and
    expected semantics.

- Risk assessment
  - Low risk: selection between native qspinlock and virt TAS fallback
    is internal and controlled by KVM hints; the change makes behavior
    consistent across PV_UNHALT presence/absence.
  - The only behavior change is for guests on hosts without
    `KVM_FEATURE_PV_UNHALT` that advertise `KVM_HINTS_REALTIME`: they
    now get native qspinlock (preferred) instead of TAS fallback. This
    mirrors what already happens on hosts with PV_UNHALT support, so it
    does not introduce a new class of risk.

- Stable backport rationale
  - Small, self-contained change; no API/ABI changes.
  - Corrects a logic mismatch with an earlier change’s documented intent
    (dedicated vCPU → native qspinlock), yielding concrete performance
    benefits under contention.
  - Fits stable criteria as a low-risk correctness/performance fix
    rather than a new feature.

Code references:
- arch/x86/kernel/kvm.c:1095 (KVM_HINTS_REALTIME → goto out), :1101
  (single CPU → goto out), :1107 (`nopvspin` → goto out), :1120–1126
  (PV_UNHALT check now after the above), :1135
  (`static_branch_disable(&virt_spin_lock_key);`).
- arch/x86/include/asm/qspinlock.h:88–110 (`virt_spin_lock()` gated by
  `virt_spin_lock_key`, uses TAS fallback when enabled).
- arch/x86/kernel/paravirt.c:60 (`native_pv_lock_init()` enables
  `virt_spin_lock_key` for guests).

 arch/x86/kernel/kvm.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 57379698015ed..2ecb2ec06aebc 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -1089,16 +1089,6 @@ static void kvm_wait(u8 *ptr, u8 val)
  */
 void __init kvm_spinlock_init(void)
 {
-	/*
-	 * In case host doesn't support KVM_FEATURE_PV_UNHALT there is still an
-	 * advantage of keeping virt_spin_lock_key enabled: virt_spin_lock() is
-	 * preferred over native qspinlock when vCPU is preempted.
-	 */
-	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT)) {
-		pr_info("PV spinlocks disabled, no host support\n");
-		return;
-	}
-
 	/*
 	 * Disable PV spinlocks and use native qspinlock when dedicated pCPUs
 	 * are available.
@@ -1118,6 +1108,16 @@ void __init kvm_spinlock_init(void)
 		goto out;
 	}
 
+	/*
+	 * In case host doesn't support KVM_FEATURE_PV_UNHALT there is still an
+	 * advantage of keeping virt_spin_lock_key enabled: virt_spin_lock() is
+	 * preferred over native qspinlock when vCPU is preempted.
+	 */
+	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT)) {
+		pr_info("PV spinlocks disabled, no host support\n");
+		return;
+	}
+
 	pr_info("PV spinlocks enabled\n");
 
 	__pv_init_lock_hash();
-- 
2.51.0


