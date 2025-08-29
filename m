Return-Path: <kvm+bounces-56220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AA60B3AEED
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 02:10:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 302B3188FA6B
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 00:10:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67B1D248F7F;
	Fri, 29 Aug 2025 00:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wGiBEFMb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C259D26ACB
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 00:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756426009; cv=none; b=EnEl351THDtwytLJvIMjOjKzqm+kOrUKj7oHLatO1GYzgo+NvcKf4CG8lxT3wBIMCDPzl7iAVnJ+o644XGy4zd/uw4u82vOvNvRVWl95VfnKGRkuuyT30J4z1JlrYcQ+1fJKA5MPo7K5RMl0OmjC8sk4wi9pqy3I8VO3H91EXZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756426009; c=relaxed/simple;
	bh=qytjR+kel2w3eORLh2zH54skNQJE5v9ARQq1wlkBUKc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tYseWp/5X7VkLNhF4xt766imOrxz01v3gXaz0GgAnTy6LONg2XpTqpNfRYSINeqYzxlu/oPNAQ+biNo+H1xCUj/0oMKd9Ft7OQRWMF9wLrUx6TL7MBGzEwSO726x5rSMnQh7SNqffYIfy2RkIl/UHHbZspJCVksU+s3Tha2K87c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wGiBEFMb; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b4c724d27f8so520527a12.3
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 17:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756426007; x=1757030807; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+Dy3rkmYpzV2fykEfNOl1VwjG9yNy+xSxuP+2h5ZcwU=;
        b=wGiBEFMbCvES6/D3tnlT9pDZdZXfy7Xv4oLLZ5/LzrAgXdmXQF/HN7ejwIK3aERcSC
         FOWEimKc/l40HqHvCmjg+KGMThrtOgrtiZUmfpcEYrrWvZq/Lp/a/mpEn52S84M5vyDh
         +NKTkCEIPz2XPPOb2b0ltSzbTToUQpExiRnqItoXQCitRi6HDOHp7Xx9rAVt7n2QpcH2
         kQv28XPqOPUj+0XMbe3NscGg94kZNtl12dLngcbkwhAl7nQ3yWYR5/bdQoBi9yeIJUti
         wmPHplEL4b7nEwM80uJq9I3DIXajCV+t4o5pkkxVOMEW/2+D/R96PG8+FdEZRXKWR9cP
         bYqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756426007; x=1757030807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Dy3rkmYpzV2fykEfNOl1VwjG9yNy+xSxuP+2h5ZcwU=;
        b=LcHDtj8ITXPnIJGDvpwGOp25JuH2SSOgn/QtAXELlXqbnjDmSca6vxxuSsWThJqJHe
         hOzXj8rdXGeIUgOkimnSHt9Juset3TeP35lX8+5YDnmezbJfy+YMhcRrOsP47O8qcudz
         Srzm97L/YI9fA3s70wJ9vu3ul9O4vMOfRIDMKMS/+P9ut9sb6Rqr5ULqfrB/sCHZnnBl
         sjVDPRv51leffmFz1ZiBfGbN1SDZJ+RZDgCuN+52DkaTi7G9+WrZ3bwaVwvRckVnbedF
         8sQwYyAZYRRhX2lQL9TSKEn0/EF07rFOMPegLb9MEFvUCvXWV5uakk+CrKFx7I3r5zwy
         +KVQ==
X-Gm-Message-State: AOJu0YwdfkY7v+8UR4irFTSPfrqcZ+T5fFerm/rCFWfSFDq+6giVh0Ba
	nkHP3hApSJjJIdbDU8aItuJ9UnXJ8q9qsJ0rhtkHcu7u0FAUQGmj0jLSt4flzYTeS7uy5vvwjh1
	iCnJFrQ==
X-Google-Smtp-Source: AGHT+IGfPCg7l4hBn7D2jwXdjrEUEovsveWlHE4vLEm6cr6KCYbMUVFnNMwsEgdOByingguf4XTMW3yZ568=
X-Received: from pgax22.prod.google.com ([2002:a05:6a02:2e56:b0:b42:3628:5c78])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:1585:b0:232:7c7b:1c7b
 with SMTP id adf61e73a8af0-24340c429e2mr40822536637.14.1756426007254; Thu, 28
 Aug 2025 17:06:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 28 Aug 2025 17:06:15 -0700
In-Reply-To: <20250829000618.351013-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829000618.351013-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
Message-ID: <20250829000618.351013-16-seanjc@google.com>
Subject: [RFC PATCH v2 15/18] KVM: TDX: Combine KVM_BUG_ON + pr_tdx_error()
 into TDX_BUG_ON()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Add TDX_BUG_ON() macros (with varying numbers of arguments) to deduplicate
the myriad flows that do KVM_BUG_ON()/WARN_ON_ONCE() followed by a call to
pr_tdx_error().  In addition to reducing boilerplate copy+paste code, this
also helps ensure that KVM provides consistent handling of SEAMCALL errors.

Opportunistically convert a handful of bare WARN_ON_ONCE() paths to the
equivalent of KVM_BUG_ON(), i.e. have them terminate the VM.  If a SEAMCALL
error is fatal enough to WARN on, it's fatal enough to terminate the TD.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 114 +++++++++++++++++------------------------
 1 file changed, 47 insertions(+), 67 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index aa6d88629dae..df9b4496cd01 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -24,20 +24,32 @@
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#define pr_tdx_error(__fn, __err)	\
-	pr_err_ratelimited("SEAMCALL %s failed: 0x%llx\n", #__fn, __err)
+#define __TDX_BUG_ON(__err, __f, __kvm, __fmt, __args...)			\
+({										\
+	struct kvm *_kvm = (__kvm);						\
+	bool __ret = !!(__err);							\
+										\
+	if (WARN_ON_ONCE(__ret && (!_kvm || !_kvm->vm_bugged))) {		\
+		if (_kvm)							\
+			kvm_vm_bugged(_kvm);					\
+		pr_err_ratelimited("SEAMCALL " __f " failed: 0x%llx" __fmt "\n",\
+				   __err,  __args);				\
+	}									\
+	unlikely(__ret);							\
+})
 
-#define __pr_tdx_error_N(__fn_str, __err, __fmt, ...)		\
-	pr_err_ratelimited("SEAMCALL " __fn_str " failed: 0x%llx, " __fmt,  __err,  __VA_ARGS__)
+#define TDX_BUG_ON(__err, __fn, __kvm)				\
+	__TDX_BUG_ON(__err, #__fn, __kvm, "%s", "")
 
-#define pr_tdx_error_1(__fn, __err, __rcx)		\
-	__pr_tdx_error_N(#__fn, __err, "rcx 0x%llx\n", __rcx)
+#define TDX_BUG_ON_1(__err, __fn, __rcx, __kvm)			\
+	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx", __rcx)
 
-#define pr_tdx_error_2(__fn, __err, __rcx, __rdx)	\
-	__pr_tdx_error_N(#__fn, __err, "rcx 0x%llx, rdx 0x%llx\n", __rcx, __rdx)
+#define TDX_BUG_ON_2(__err, __fn, __rcx, __rdx, __kvm)		\
+	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx, rdx 0x%llx", __rcx, __rdx)
+
+#define TDX_BUG_ON_3(__err, __fn, __rcx, __rdx, __r8, __kvm)	\
+	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx, rdx 0x%llx, r8 0x%llx", __rcx, __rdx, __r8)
 
-#define pr_tdx_error_3(__fn, __err, __rcx, __rdx, __r8)	\
-	__pr_tdx_error_N(#__fn, __err, "rcx 0x%llx, rdx 0x%llx, r8 0x%llx\n", __rcx, __rdx, __r8)
 
 bool enable_tdx __ro_after_init;
 module_param_named(tdx, enable_tdx, bool, 0444);
@@ -332,10 +344,9 @@ static int __tdx_reclaim_page(struct page *page)
 	 * before the HKID is released and control pages have also been
 	 * released at this point, so there is no possibility of contention.
 	 */
-	if (WARN_ON_ONCE(err)) {
-		pr_tdx_error_3(TDH_PHYMEM_PAGE_RECLAIM, err, rcx, rdx, r8);
+	if (TDX_BUG_ON_3(err, TDH_PHYMEM_PAGE_RECLAIM, rcx, rdx, r8, NULL))
 		return -EIO;
-	}
+
 	return 0;
 }
 
@@ -423,8 +434,8 @@ static void tdx_flush_vp_on_cpu(struct kvm_vcpu *vcpu)
 		return;
 
 	smp_call_function_single(cpu, tdx_flush_vp, &arg, 1);
-	if (KVM_BUG_ON(arg.err, vcpu->kvm))
-		pr_tdx_error(TDH_VP_FLUSH, arg.err);
+
+	TDX_BUG_ON(arg.err, TDH_VP_FLUSH, vcpu->kvm);
 }
 
 void tdx_disable_virtualization_cpu(void)
@@ -473,8 +484,7 @@ static void smp_func_do_phymem_cache_wb(void *unused)
 	}
 
 out:
-	if (WARN_ON_ONCE(err))
-		pr_tdx_error(TDH_PHYMEM_CACHE_WB, err);
+	TDX_BUG_ON(err, TDH_PHYMEM_CACHE_WB, NULL);
 }
 
 void tdx_mmu_release_hkid(struct kvm *kvm)
@@ -513,8 +523,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	err = tdh_mng_vpflushdone(&kvm_tdx->td);
 	if (err == TDX_FLUSHVP_NOT_DONE)
 		goto out;
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error(TDH_MNG_VPFLUSHDONE, err);
+	if (TDX_BUG_ON(err, TDH_MNG_VPFLUSHDONE, kvm)) {
 		pr_err("tdh_mng_vpflushdone() failed. HKID %d is leaked.\n",
 		       kvm_tdx->hkid);
 		goto out;
@@ -537,8 +546,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	 * tdh_mng_key_freeid() will fail.
 	 */
 	err = tdh_mng_key_freeid(&kvm_tdx->td);
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error(TDH_MNG_KEY_FREEID, err);
+	if (TDX_BUG_ON(err, TDH_MNG_KEY_FREEID, kvm)) {
 		pr_err("tdh_mng_key_freeid() failed. HKID %d is leaked.\n",
 		       kvm_tdx->hkid);
 	} else {
@@ -589,10 +597,9 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
 	 * when it is reclaiming TDCS).
 	 */
 	err = tdh_phymem_page_wbinvd_tdr(&kvm_tdx->td);
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
+	if (TDX_BUG_ON(err, TDH_PHYMEM_PAGE_WBINVD, kvm))
 		return;
-	}
+
 	tdx_clear_page(kvm_tdx->td.tdr_page);
 
 	__free_page(kvm_tdx->td.tdr_page);
@@ -615,11 +622,8 @@ static int tdx_do_tdh_mng_key_config(void *param)
 
 	/* TDX_RND_NO_ENTROPY related retries are handled by sc_retry() */
 	err = tdh_mng_key_config(&kvm_tdx->td);
-
-	if (KVM_BUG_ON(err, &kvm_tdx->kvm)) {
-		pr_tdx_error(TDH_MNG_KEY_CONFIG, err);
+	if (TDX_BUG_ON(err, TDH_MNG_KEY_CONFIG, &kvm_tdx->kvm))
 		return -EIO;
-	}
 
 	return 0;
 }
@@ -1604,10 +1608,8 @@ static int tdx_mem_page_add(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 	if (unlikely(tdx_operand_busy(err)))
 		return -EBUSY;
 
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error_2(TDH_MEM_PAGE_ADD, err, entry, level_state);
+	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_ADD, entry, level_state, kvm))
 		return -EIO;
-	}
 
 	return 0;
 }
@@ -1626,10 +1628,8 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 	if (unlikely(tdx_operand_busy(err)))
 		return -EBUSY;
 
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error_2(TDH_MEM_PAGE_AUG, err, entry, level_state);
+	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_AUG, entry, level_state, kvm))
 		return -EIO;
-	}
 
 	return 0;
 }
@@ -1674,10 +1674,8 @@ static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 	if (unlikely(tdx_operand_busy(err)))
 		return -EBUSY;
 
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error_2(TDH_MEM_SEPT_ADD, err, entry, level_state);
+	if (TDX_BUG_ON_2(err, TDH_MEM_SEPT_ADD, entry, level_state, kvm))
 		return -EIO;
-	}
 
 	return 0;
 }
@@ -1725,8 +1723,7 @@ static void tdx_track(struct kvm *kvm)
 		tdx_no_vcpus_enter_stop(kvm);
 	}
 
-	if (KVM_BUG_ON(err, kvm))
-		pr_tdx_error(TDH_MEM_TRACK, err);
+	TDX_BUG_ON(err, TDH_MEM_TRACK, kvm);
 
 	kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);
 }
@@ -1783,10 +1780,8 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 		tdx_no_vcpus_enter_stop(kvm);
 	}
 
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error_2(TDH_MEM_RANGE_BLOCK, err, entry, level_state);
+	if (TDX_BUG_ON_2(err, TDH_MEM_RANGE_BLOCK, entry, level_state, kvm))
 		return;
-	}
 
 	/*
 	 * TDX requires TLB tracking before dropping private page.  Do
@@ -1813,16 +1808,12 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 		tdx_no_vcpus_enter_stop(kvm);
 	}
 
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error_2(TDH_MEM_PAGE_REMOVE, err, entry, level_state);
+	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_REMOVE, entry, level_state, kvm))
 		return;
-	}
 
 	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
+	if (TDX_BUG_ON(err, TDH_PHYMEM_PAGE_WBINVD, kvm))
 		return;
-	}
 
 	tdx_clear_page(page);
 }
@@ -2451,8 +2442,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 		goto free_packages;
 	}
 
-	if (WARN_ON_ONCE(err)) {
-		pr_tdx_error(TDH_MNG_CREATE, err);
+	if (TDX_BUG_ON(err, TDH_MNG_CREATE, kvm)) {
 		ret = -EIO;
 		goto free_packages;
 	}
@@ -2493,8 +2483,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 			ret = -EAGAIN;
 			goto teardown;
 		}
-		if (WARN_ON_ONCE(err)) {
-			pr_tdx_error(TDH_MNG_ADDCX, err);
+		if (TDX_BUG_ON(err, TDH_MNG_ADDCX, kvm)) {
 			ret = -EIO;
 			goto teardown;
 		}
@@ -2511,8 +2500,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 		*seamcall_err = err;
 		ret = -EINVAL;
 		goto teardown;
-	} else if (WARN_ON_ONCE(err)) {
-		pr_tdx_error_1(TDH_MNG_INIT, err, rcx);
+	} else if (TDX_BUG_ON_1(err, TDH_MNG_INIT, rcx, kvm)) {
 		ret = -EIO;
 		goto teardown;
 	}
@@ -2790,10 +2778,8 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	cmd->hw_error = tdh_mr_finalize(&kvm_tdx->td);
 	if (tdx_operand_busy(cmd->hw_error))
 		return -EBUSY;
-	if (KVM_BUG_ON(cmd->hw_error, kvm)) {
-		pr_tdx_error(TDH_MR_FINALIZE, cmd->hw_error);
+	if (TDX_BUG_ON(cmd->hw_error, TDH_MR_FINALIZE, kvm))
 		return -EIO;
-	}
 
 	kvm_tdx->state = TD_STATE_RUNNABLE;
 	/* TD_STATE_RUNNABLE must be set before 'pre_fault_allowed' */
@@ -2873,16 +2859,14 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	}
 
 	err = tdh_vp_create(&kvm_tdx->td, &tdx->vp);
-	if (KVM_BUG_ON(err, vcpu->kvm)) {
+	if (TDX_BUG_ON(err, TDH_VP_CREATE, vcpu->kvm)) {
 		ret = -EIO;
-		pr_tdx_error(TDH_VP_CREATE, err);
 		goto free_tdcx;
 	}
 
 	for (i = 0; i < kvm_tdx->td.tdcx_nr_pages; i++) {
 		err = tdh_vp_addcx(&tdx->vp, tdx->vp.tdcx_pages[i]);
-		if (KVM_BUG_ON(err, vcpu->kvm)) {
-			pr_tdx_error(TDH_VP_ADDCX, err);
+		if (TDX_BUG_ON(err, TDH_VP_ADDCX, vcpu->kvm)) {
 			/*
 			 * Pages already added are reclaimed by the vcpu_free
 			 * method, but the rest are freed here.
@@ -2896,10 +2880,8 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	}
 
 	err = tdh_vp_init(&tdx->vp, vcpu_rcx, vcpu->vcpu_id);
-	if (KVM_BUG_ON(err, vcpu->kvm)) {
-		pr_tdx_error(TDH_VP_INIT, err);
+	if (TDX_BUG_ON(err, TDH_VP_INIT, vcpu->kvm))
 		return -EIO;
-	}
 
 	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
@@ -3105,10 +3087,8 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	 */
 	for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
 		err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry, &level_state);
-		if (KVM_BUG_ON(err, kvm)) {
-			pr_tdx_error_2(TDH_MR_EXTEND, err, entry, level_state);
+		if (TDX_BUG_ON_2(err, TDH_MR_EXTEND, entry, level_state, kvm))
 			return -EIO;
-		}
 	}
 
 	return 0;
-- 
2.51.0.318.gd7df087d1a-goog


