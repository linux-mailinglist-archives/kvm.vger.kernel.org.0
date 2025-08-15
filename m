Return-Path: <kvm+bounces-54716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EA4FB27386
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:17:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D23B27BEE7E
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 054262192F1;
	Fri, 15 Aug 2025 00:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sYLQ5sqP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768D91F561D
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755216761; cv=none; b=BhfPNErr2vL6zE7bBGGg64YedVR8pOqEBVutK4evYxFrst08u2h0/Ksn/uZESpCYrJvmkN8FUv0RYU9JckAsa8vpOnTYM3Z0i/Fwzjxi/4Mc7UGrzKpZS1M9LodvWcYQuV3OOs0pKNbce5GVZMNhs5s0pR6u27JiDKBjXhFl/a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755216761; c=relaxed/simple;
	bh=RZ7Dz8xwBsHGy5mh7rqSjgoKEOyTvpiJll9GacNdIxQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RY3WSgxv+JQLN+cinYA1QRvP5b7w2uPBbX3GiVyPVlMFeN90bqD1mI8J4nBhc8+v3bnFsZXBsuWc32ZX8Xcu10nDecNU04g93TleMjxz50CBBMHXtfUw2WeHrk5XuOvMB+BVSCBt3erxkTJrAGh6onYMOTMaJIToE6GR2vnsK9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sYLQ5sqP; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b47173ae6easo1990712a12.1
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755216759; x=1755821559; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5WU9voBHmtHCID+62ekjip+WsDaLPoXQ1Ho4KAjz+Bk=;
        b=sYLQ5sqP+joFgShRs229ltnfmFKtmVeGfB3+jobeQCppC5tinDwcFsakJuE7PWJD3n
         RCeGR2mhTHOLudMle49N2/iSBI+zo1uDLnobkkri/XPCm9PbmoHcXCRqVjaXl5Qlvot4
         1YFwDbnobQPgw2RBW7qVG/mTcMaHToJ17ByTiYtamMmmkAyYUXi6wganyRUvLdNpuqSR
         mynmI/SGoZEdteBvLpBWSrl7x9M39eUcdefHVyzrvCdj/J85uhNZlG9DChjhAKJJShFo
         bVUZth8UMurwozCNBm0TRJnOxNRkLBlqeXdZupDpawqnW0lXdZaNP0ilI9s6LNIlcqln
         TJag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755216759; x=1755821559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5WU9voBHmtHCID+62ekjip+WsDaLPoXQ1Ho4KAjz+Bk=;
        b=RiYFw9sK3Jc13iaIhR9pmVK6FmvWXlU8MS/xPTA444B4y0RWaaDsbIuMZmmfHKxS+W
         8CIUVlhoCRAMQeZSbRbwWVuyTBkDajgTuWIB2Mq2/TdLwRBC11iKu3ofNtsfLPSi2iPw
         dIMmz0RS4vhTzmM3EKt7TNX3bzADBq2KcpiaV2AUVLXJ8axqlXBaucexBNM0roojgtyg
         sCy7hPNuGfmDbWDTYQ5v4wZT7yngdfEr4zUAi34hywKOpgM/pvD+zWtA2NhZgxCG7aCD
         cyTZQNWJaQDfD8s4H+7WGM5aEsrhS6xKOvlgpYxqOLfubBn05RRpmZblusOtuoejmrMb
         E4LA==
X-Gm-Message-State: AOJu0YwGRzlUWwLSF14jxt3bqfMpaA/3UWRIKmq83eUjvTnHA22vZ8v+
	sQ4+pfmZe7lpilCvMUZQK3sC+7fyFqsEaGykckS6WHno/DxWE9OrTWWqNKWNfZrAWy78xZwzJ9X
	/HbUlwQ==
X-Google-Smtp-Source: AGHT+IHLp96Otjk1T4s0hj1MiompkYvxUqUTRUDczNOqtCXM0tJwB6ezd2X3zMPFXAvmZWvj66nHpW6DhT8=
X-Received: from pgc14.prod.google.com ([2002:a05:6a02:2f8e:b0:b42:1052:52f5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:430d:b0:238:351a:6437
 with SMTP id adf61e73a8af0-240d2f3f71bmr291638637.43.1755216758682; Thu, 14
 Aug 2025 17:12:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:11:59 -0700
In-Reply-To: <20250815001205.2370711-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815001205.2370711-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815001205.2370711-16-seanjc@google.com>
Subject: [PATCH 6.1.y 15/21] KVM: x86: Convert vcpu_run()'s immediate exit
 param into a generic bitmap
From: Sean Christopherson <seanjc@google.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

[ Upstream commit 2478b1b220c49d25cb1c3f061ec4f9b351d9a131 ]

Convert kvm_x86_ops.vcpu_run()'s "force_immediate_exit" boolean parameter
into an a generic bitmap so that similar "take action" information can be
passed to vendor code without creating a pile of boolean parameters.

This will allow dropping kvm_x86_ops.set_dr6() in favor of a new flag, and
will also allow for adding similar functionality for re-loading debugctl
in the active VMCS.

Opportunistically massage the TDX WARN and comment to prepare for adding
more run_flags, all of which are expected to be mutually exclusive with
TDX, i.e. should be WARNed on.

No functional change intended.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250610232010.162191-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[sean: drop TDX crud, account for lack of kvm_x86_call()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  6 +++++-
 arch/x86/kvm/svm/svm.c          |  4 ++--
 arch/x86/kvm/vmx/vmx.c          |  3 ++-
 arch/x86/kvm/x86.c              | 10 ++++++++--
 4 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 86f3bd6601e7..1383f5e5238a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1456,6 +1456,10 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 	return dest_mode_logical ? APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
 }
 
+enum kvm_x86_run_flags {
+	KVM_RUN_FORCE_IMMEDIATE_EXIT	= BIT(0),
+};
+
 struct kvm_x86_ops {
 	const char *name;
 
@@ -1529,7 +1533,7 @@ struct kvm_x86_ops {
 
 	int (*vcpu_pre_run)(struct kvm_vcpu *vcpu);
 	enum exit_fastpath_completion (*vcpu_run)(struct kvm_vcpu *vcpu,
-						  bool force_immediate_exit);
+						  u64 run_flags);
 	int (*handle_exit)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion exit_fastpath);
 	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 12de50db401f..dc8a1b72d8ec 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4008,9 +4008,9 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
 	guest_state_exit_irqoff();
 }
 
-static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
-					  bool force_immediate_exit)
+static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 {
+	bool force_immediate_exit = run_flags & KVM_RUN_FORCE_IMMEDIATE_EXIT;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool spec_ctrl_intercepted = msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 179747d04edc..382f42200688 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7204,8 +7204,9 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	guest_state_exit_irqoff();
 }
 
-static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
+static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 {
+	bool force_immediate_exit = run_flags & KVM_RUN_FORCE_IMMEDIATE_EXIT;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bc586a6df6ab..b9cc3c05590e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10591,6 +10591,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		dm_request_for_irq_injection(vcpu) &&
 		kvm_cpu_accept_dm_intr(vcpu);
 	fastpath_t exit_fastpath;
+	u64 run_flags;
 
 	bool req_immediate_exit = false;
 
@@ -10811,8 +10812,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		goto cancel_injection;
 	}
 
-	if (req_immediate_exit)
+	run_flags = 0;
+	if (req_immediate_exit) {
+		run_flags |= KVM_RUN_FORCE_IMMEDIATE_EXIT;
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
+	}
 
 	fpregs_assert_state_consistent();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
@@ -10848,7 +10852,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		WARN_ON_ONCE((kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu)) &&
 			     (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED));
 
-		exit_fastpath = static_call(kvm_x86_vcpu_run)(vcpu, req_immediate_exit);
+		exit_fastpath = static_call(kvm_x86_vcpu_run)(vcpu, run_flags);
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
 			break;
 
@@ -10860,6 +10864,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			break;
 		}
 
+		run_flags = 0;
+
 		/* Note, VM-Exits that go down the "slow" path are accounted below. */
 		++vcpu->stat.exits;
 	}
-- 
2.51.0.rc1.163.g2494970778-goog


