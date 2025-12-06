Return-Path: <kvm+bounces-65431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A7E7CA9C03
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:41:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6D44B315E3D7
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8D3B3081D8;
	Sat,  6 Dec 2025 00:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gPbqaZJy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51C6305068
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980327; cv=none; b=KDkITCUs4C1cPOmLKfnvRdxR5WcuFGw7hAn+aPVedSyzoKZKSDj8cyM6Ex+nO2eGcU1+0w1KtSvt9wrIYkxv1d9bpi4ld5hq5pcRPXZyH3ZjBsyST5+35qKpSBasL+WYLd/KuBMY/0ToN6rot4IEw0KJQzplgyb9ljxXJb5A+XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980327; c=relaxed/simple;
	bh=NbkrBG3duMpaol6d8oG4nabrvUXIXCsgan8nKAy9HYc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TelNb3R2x3e61h5VdKqb1ZOTB70sfAnGb69MhvQbX0p+pzpqdYiTQmlbXcC237+/N1c7MBjWyfmcsV/rv+6kqtHGRBACfBh8sajhFuGhsUfOFujhDT96lrN+05GxS7pWZ03jHaIejYlAzsbF5Qkw9hX75Ke3LIgRfaTw+LcqWgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gPbqaZJy; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7be94e1a073so4966248b3a.2
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980324; x=1765585124; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0alQNA5MnRougM8104k8mY12SAXvJNUdA/VqOuM31LI=;
        b=gPbqaZJy8VbXYC4ud3kXmQdUa2VIcdS334VR5E5WhizmFlnP6MZar84aPvNckNhtXc
         TrRt0jmVdvIi+pTxkenCupOe3XE5DThLzOuUNVeod/Gl9JRuZ9wkOrEhBy4ZD3cKsTL9
         psZKtOdPfmSKVk0om6dvC64o2k8QJJfntq6qemfo2vKrXUDvNIiTEIGKA1b26mMy3BqG
         PqJh11awL5EPWBQr5AqUP63nnw6TLdWaey/C8m4xPLTd/Ds9AXp64y5f38iCZKRmmvP4
         tbyjRS24TZRt6hPoLAkqMBCnlr+wRN/AYV/sbiVF/j6m3A8hdlHQJdiYRiUKDIfB8saD
         R4nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980324; x=1765585124;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0alQNA5MnRougM8104k8mY12SAXvJNUdA/VqOuM31LI=;
        b=HIvhIunboo5ourgKiPeaEjbTbtXLqxzxlHG4wFtEQY1TO93+9QEuVUcxCucYGMfraD
         znPaSxDRdE/v8TatU6/7I/Ds9FTlLgUaknvZqaYqB2Ui8mMAmzcYxq1+bglliMi7ntNg
         uM2n3CpU/CtVHIXL6g7hJxdwBljLNWynZe2282sPEG91t3cPpF3soeap8pNRYGv1/mQ4
         LnCbY2/miJFnC4saufZjtWqlvro87kMZBMv2JMvLMcTjgkmveWnEuXSM8xwfyIwDpUT2
         r7uDA71b7xkscAUNuX/7nsvOyd2CSI6TXqIPIu1JWQR+wexKcvQwGI/891hhEAB4XTRj
         IvDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGGFY/gtzZDhR8M5CzxX+ybziXsnQzqqFCVnkanremeobyYl+IQSDMyqtBG/EpSxerJR4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOBLA7lc/jyFWT2aX0UO2PCI1FZ6V5Py4uwCUUdXh6tnl+4b9i
	JLNyX3RYIn+3pJbsYjWNS0+8Jf3hJQ3t4aRBEWrIHWdUOZ2WzFVpRYUNG5mjTDxUoNgQfB3iaMC
	51McGHQ==
X-Google-Smtp-Source: AGHT+IE9VOcwrfHydwxf79golQ2o2etTa7qJp+DbC2tY99Fupcp+X66ru5yHSbM1504AJSJDzZlYcA1+Jcw=
X-Received: from pgdc11.prod.google.com ([2002:a05:6a02:510b:b0:bd9:6028:d18c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:4ed2:10b0:361:4ca3:e17d
 with SMTP id adf61e73a8af0-36617e37b3fmr739726637.13.1764980324070; Fri, 05
 Dec 2025 16:18:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:17:14 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-39-seanjc@google.com>
Subject: [PATCH v6 38/44] KVM: VMX: Drop unused @entry_only param from add_atomic_switch_msr()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop the "on VM-Enter only" parameter from add_atomic_switch_msr() as it
is no longer used, and for all intents and purposes was never used.  The
functionality was added, under embargo, by commit 989e3992d2ec
("x86/KVM/VMX: Extend add_atomic_switch_msr() to allow VMENTER only MSRs"),
and then ripped out by commit 2f055947ae5e ("x86/kvm: Drop L1TF MSR list
approach") just a few commits later.

  2f055947ae5e x86/kvm: Drop L1TF MSR list approach
  72c6d2db64fa x86/litf: Introduce vmx status variable
  215af5499d9e cpu/hotplug: Online siblings when SMT control is turned on
  390d975e0c4e x86/KVM/VMX: Use MSR save list for IA32_FLUSH_CMD if required
  989e3992d2ec x86/KVM/VMX: Extend add_atomic_switch_msr() to allow VMENTER only MSRs

Furthermore, it's extremely unlikely KVM will ever _need_ to load an MSR
value via the auto-load lists only on VM-Enter.  MSRs writes via the lists
aren't optimized in any way, and so the only reason to use the lists
instead of a WRMSR are for cases where the MSR _must_ be load atomically
with respect to VM-Enter (and/or VM-Exit).  While one could argue that
command MSRs, e.g. IA32_FLUSH_CMD, "need" to be done exact at VM-Enter, in
practice doing such flushes within a few instructons of VM-Enter is more
than sufficient.

Note, the shortlog and changelog for commit 390d975e0c4e ("x86/KVM/VMX: Use
MSR save list for IA32_FLUSH_CMD if required") are misleading and wrong.
That commit added MSR_IA32_FLUSH_CMD to the VM-Enter _load_ list, not the
VM-Enter save list (which doesn't exist, only VM-Exit has a store/save
list).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a51f66d1b201..38491962b2c1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1094,7 +1094,7 @@ static __always_inline void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,
 }
 
 static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
-				  u64 guest_val, u64 host_val, bool entry_only)
+				  u64 guest_val, u64 host_val)
 {
 	int i, j = 0;
 	struct msr_autoload *m = &vmx->msr_autoload;
@@ -1132,8 +1132,7 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 	}
 
 	i = vmx_find_loadstore_msr_slot(&m->guest, msr);
-	if (!entry_only)
-		j = vmx_find_loadstore_msr_slot(&m->host, msr);
+	j = vmx_find_loadstore_msr_slot(&m->host, msr);
 
 	if ((i < 0 && m->guest.nr == MAX_NR_LOADSTORE_MSRS) ||
 	    (j < 0 &&  m->host.nr == MAX_NR_LOADSTORE_MSRS)) {
@@ -1148,9 +1147,6 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 	m->guest.val[i].index = msr;
 	m->guest.val[i].value = guest_val;
 
-	if (entry_only)
-		return;
-
 	if (j < 0) {
 		j = m->host.nr++;
 		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->host.nr);
@@ -1190,8 +1186,7 @@ static bool update_transition_efer(struct vcpu_vmx *vmx)
 		if (!(guest_efer & EFER_LMA))
 			guest_efer &= ~EFER_LME;
 		if (guest_efer != kvm_host.efer)
-			add_atomic_switch_msr(vmx, MSR_EFER,
-					      guest_efer, kvm_host.efer, false);
+			add_atomic_switch_msr(vmx, MSR_EFER, guest_efer, kvm_host.efer);
 		else
 			clear_atomic_switch_msr(vmx, MSR_EFER);
 		return false;
@@ -7350,7 +7345,7 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 			clear_atomic_switch_msr(vmx, msrs[i].msr);
 		else
 			add_atomic_switch_msr(vmx, msrs[i].msr, msrs[i].guest,
-					msrs[i].host, false);
+					      msrs[i].host);
 }
 
 static void vmx_update_hv_timer(struct kvm_vcpu *vcpu, bool force_immediate_exit)
-- 
2.52.0.223.gf5cc29aaa4-goog


