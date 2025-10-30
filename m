Return-Path: <kvm+bounces-61550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B4C9C2232B
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 21:19:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2F0754F2AB7
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 20:16:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AAEF33557F;
	Thu, 30 Oct 2025 20:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QxCyHq46"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BA937574B
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 20:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761855055; cv=none; b=UwWhWCLroSTigQHttS9WhnK/1SNmWLIJxghuSrDQ95jVj5G3VUCMZBQXPu2Ds2NoPcxzonC7ByTZn2o+0DQpUFSMcTLb15gXsAoAiVgIB0o5GoukP7IVQpgJl6lisNtcA6Vz/ARz6OxnRMB6ZYV5PVWy2vmpt+e9Md3dWn3+64Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761855055; c=relaxed/simple;
	bh=1TeuJjhP9mqGMQJvgPXRft34enFs+P5PX2+/Rfvv+AU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WuSyX3uYzUA4kJLi95XUclf1crH+rcs44qFdjmduzDctCktszMZ2aN1UjKDLPvnC8Ae0HdCwBAVm1RzxxF93vgpX/wjLZtmcaJqknau5UKakUj2iqt/T9fLMv9zNxZ5BxSfrfuodBYoB2JTVmKEnY97Rk3VDbxTEQJtUyE/D1Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QxCyHq46; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3324538ceb0so2548913a91.1
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 13:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761855052; x=1762459852; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xpa5Fver89jqQUHMNWla6MmRTI/zYJOh/l7CEBc/74M=;
        b=QxCyHq46FNsACnY9xxLczfXbrqZhxzlC0LfjtaADyUhKxvNIlI5b5r92E/67DGYJg9
         byHiP3t+5OzvGz09ixvUMjXTjF6qukfjE8qOHvmn0URLh3hp9nZeixEId99jAYbcUzju
         aMN0LNO+/VGXzQ9+ydK/teQZKOT8lKXe+5CTJo12XIk9l5GMkKX3kr7zId5bplUk0u3R
         UJO8lLsYQSNM/+3/GPz4n+EW3J1S9cnoYYUcs8YbJs7N+8OimXtWTctvKY6Pr5cujfux
         nu7X9grZppPGc2mrmkpsfekrZe6AyXssdCMG4bKMvJN8MJsZNZ/TOUie80GcPAbm9sXa
         ffHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761855052; x=1762459852;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xpa5Fver89jqQUHMNWla6MmRTI/zYJOh/l7CEBc/74M=;
        b=C+JpQuS+TBuILmqrYM45BPvnEqEQC/R1Xm9lgGxFy4jUIGd2me7LOWPgRputifHRfp
         Qjx/P6zrQz/hrBsS4D+XHwhwyItNUsflGkv7YQq2uGbaNFAKwLUUAmwxXe9pgMH2AST2
         Pmltlu6UHqdg6lxwLjcPi9L7kzfOfecHGxpGNjLJGF9K9+gE65wMV/oePf7npxo0JcNP
         HRgG0KvRZ5gCiDhBa2kli9VKZVMZoPmZXSxIiLq1WYF06AprAucHXoTJ148dEYcwF68W
         B9Ce1hpSIgCaVraJiZhE/791u1lRJ860sksqi9oj1rFU56mnLDneMeLDId+CuQMTJdUZ
         iV+g==
X-Forwarded-Encrypted: i=1; AJvYcCUK29Ia62nnroEars6jlJso7eB8gcJfjPAjcdDwFBtSA0ZuNGnC7gLMU0vdzKbSnccXa7Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6yHmkHxmfg9O/azTtDrtSJvGk1AGVZRNfHMX4PTT428VyBmvN
	P4seFD3jgOFIvRoxvakYPYVmJozlEYWJGhlXCYcxAaNSjbtLKIb8OA92uCieUbbBt5bwB0aU3Wq
	UfrJ/4A==
X-Google-Smtp-Source: AGHT+IGdH9ACR3MS+ju/IeUipjD96kAUXZo3BjKEOn1spE0qh/NlJMuCLno+Rlt479ILTGbPCBlzBUGVIBM=
X-Received: from pjl4.prod.google.com ([2002:a17:90b:2f84:b0:339:dc19:ae60])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c52:b0:338:3789:2e7b
 with SMTP id 98e67ed59e1d1-34082fd9099mr1370626a91.13.1761855052135; Thu, 30
 Oct 2025 13:10:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 13:09:44 -0700
In-Reply-To: <20251030200951.3402865-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030200951.3402865-22-seanjc@google.com>
Subject: [PATCH v4 21/28] KVM: TDX: Add macro to retry SEAMCALLs when forcing
 vCPUs out of guest
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a macro to handle kicking vCPUs out of the guest and retrying
SEAMCALLs on -EBUSY instead of providing small helpers to be used by each
SEAMCALL.  Wrapping the SEAMCALLs in a macro makes it a little harder to
tease out which SEAMCALL is being made, but significantly reduces the
amount of copy+paste code and makes it all but impossible to leave an
elevated wait_for_sept_zap.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 82 +++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 999b519494e9..97632fc6b520 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -294,25 +294,34 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
 	vcpu->cpu = -1;
 }
 
-static void tdx_no_vcpus_enter_start(struct kvm *kvm)
-{
-	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-
-	lockdep_assert_held_write(&kvm->mmu_lock);
-
-	WRITE_ONCE(kvm_tdx->wait_for_sept_zap, true);
-
-	kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);
-}
-
-static void tdx_no_vcpus_enter_stop(struct kvm *kvm)
-{
-	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-
-	lockdep_assert_held_write(&kvm->mmu_lock);
-
-	WRITE_ONCE(kvm_tdx->wait_for_sept_zap, false);
-}
+/*
+ * Execute a SEAMCALL related to removing/blocking S-EPT entries, with a single
+ * retry (if necessary) after forcing vCPUs to exit and wait for the operation
+ * to complete.  All flows that remove/block S-EPT entries run with mmu_lock
+ * held for write, i.e. are mutually exclusive with each other, but they aren't
+ * mutually exclusive with running vCPUs, and so can fail with "operand busy"
+ * if a vCPU acquires a relevant lock in the TDX-Module, e.g. when doing TDCALL.
+ *
+ * Note, the retry is guaranteed to succeed, absent KVM and/or TDX-Module bugs.
+ */
+#define tdh_do_no_vcpus(tdh_func, kvm, args...)					\
+({										\
+	struct kvm_tdx *__kvm_tdx = to_kvm_tdx(kvm);				\
+	u64 __err;								\
+										\
+	lockdep_assert_held_write(&kvm->mmu_lock);				\
+										\
+	__err = tdh_func(args);							\
+	if (unlikely(tdx_operand_busy(__err))) {				\
+		WRITE_ONCE(__kvm_tdx->wait_for_sept_zap, true);			\
+		kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);	\
+										\
+		__err = tdh_func(args);						\
+										\
+		WRITE_ONCE(__kvm_tdx->wait_for_sept_zap, false);		\
+	}									\
+	__err;									\
+})
 
 /* TDH.PHYMEM.PAGE.RECLAIM is allowed only when destroying the TD. */
 static int __tdx_reclaim_page(struct page *page)
@@ -1722,14 +1731,7 @@ static void tdx_track(struct kvm *kvm)
 	 */
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	err = tdh_mem_track(&kvm_tdx->td);
-	if (unlikely(tdx_operand_busy(err))) {
-		/* After no vCPUs enter, the second retry is expected to succeed */
-		tdx_no_vcpus_enter_start(kvm);
-		err = tdh_mem_track(&kvm_tdx->td);
-		tdx_no_vcpus_enter_stop(kvm);
-	}
-
+	err = tdh_do_no_vcpus(tdh_mem_track, kvm, &kvm_tdx->td);
 	TDX_BUG_ON(err, TDH_MEM_TRACK, kvm);
 
 	kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);
@@ -1781,14 +1783,8 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
 		return;
 
-	err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
-	if (unlikely(tdx_operand_busy(err))) {
-		/* After no vCPUs enter, the second retry is expected to succeed */
-		tdx_no_vcpus_enter_start(kvm);
-		err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
-		tdx_no_vcpus_enter_stop(kvm);
-	}
-
+	err = tdh_do_no_vcpus(tdh_mem_range_block, kvm, &kvm_tdx->td, gpa,
+			      tdx_level, &entry, &level_state);
 	if (TDX_BUG_ON_2(err, TDH_MEM_RANGE_BLOCK, entry, level_state, kvm))
 		return;
 
@@ -1803,20 +1799,8 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * with other vcpu sept operation.
 	 * Race with TDH.VP.ENTER due to (0-step mitigation) and Guest TDCALLs.
 	 */
-	err = tdh_mem_page_remove(&kvm_tdx->td, gpa, tdx_level, &entry,
-				  &level_state);
-
-	if (unlikely(tdx_operand_busy(err))) {
-		/*
-		 * The second retry is expected to succeed after kicking off all
-		 * other vCPUs and prevent them from invoking TDH.VP.ENTER.
-		 */
-		tdx_no_vcpus_enter_start(kvm);
-		err = tdh_mem_page_remove(&kvm_tdx->td, gpa, tdx_level, &entry,
-					  &level_state);
-		tdx_no_vcpus_enter_stop(kvm);
-	}
-
+	err = tdh_do_no_vcpus(tdh_mem_page_remove, kvm, &kvm_tdx->td, gpa,
+			      tdx_level, &entry, &level_state);
 	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_REMOVE, entry, level_state, kvm))
 		return;
 
-- 
2.51.1.930.gacf6e81ea2-goog


