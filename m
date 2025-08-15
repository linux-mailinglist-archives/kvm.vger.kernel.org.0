Return-Path: <kvm+bounces-54710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BA6FB27375
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:15:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CC515E874F
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:15:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EE811E51F1;
	Fri, 15 Aug 2025 00:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V+NBhyCc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEADC1DE4E1
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755216750; cv=none; b=UlRXGnagFausTvvnLFFBfzr2FWz5vZvpr9nhTo9C1Oy/MLKeZoMbRy3Mz012uRqwUJGbvm/7qIGdS88NuhFVlH79or7p7zHcDgKvfzZn9h7qKdr1jvJquMWYX5Q2conooflwMmcBmUwWx2/Sb1hpUF2cIPfLdqoEbBQgQHoeY3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755216750; c=relaxed/simple;
	bh=b0MSDJUvRaRrmaqNzr3tH1ktx4FdSQpCWc/AwKrDnco=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k5Li5VHoQzsP3/k8vioJw4G0eUWHp64X6h3sCOH/o3W0ix6QkX5vboItONHTeW5ois5W/TYBZEw8V/MB/3p9W6BmcmNVHKBXPqrQRGHdiq888x77+xhK+HpyC21Tg56exq1i3/e3K65dtOiBzXJxdWLxRm9Y6/fq8UDo356t0Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V+NBhyCc; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32326789e09so2777358a91.1
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755216748; x=1755821548; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1dCGbgwW0NS5O3KDS8Qj8WR3qsePAzSTDbd1f03DmFA=;
        b=V+NBhyCcWEjqK2mdAkIDmiZ4gU5P9Js20MvASYk8QrbhU9k6K9lcxw3ODfZiwiPO8I
         7h5vaqIXyZdP0doLI+utR7qIlwWIZB4r/onlGLOxXK6+M1qnGy0Qy1AK9VQedwsa772H
         C4Li/5+77Ncfc2dTWUZd/TJber/CeNBBkfyHb2G8AIu5kdtWnhCILaTbQiTRlsHwRlCH
         av5hy+XGE1ptcmWp3WuQSqRa9FF9VPIPmt3543eKsJyPLLZJC/I0GAl9dpIKV1K4qWY2
         WMJnLS8HrFlQpcS5WYRx0Bq5GnhJKZVF03qe4CR9i4uwUz3R6BVhSDTNcFVRhSm4inzB
         AbuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755216748; x=1755821548;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1dCGbgwW0NS5O3KDS8Qj8WR3qsePAzSTDbd1f03DmFA=;
        b=LoXYgv0j35q++oQDNx/8IxPeFPRFXYnvYqkDfppiKVviV14+5C4fEnSRY4432xVH+G
         vHSUIFpGUUYhEbOvNVxM92cCJ1KipCKVUCXNHUWG5Np0zk4wrmlXzYtZi1zF1sZ+LCLK
         EO1n2mxJxeAmhZ2+3Fq04YDny0J6bnIFjDxBTg0gG8GrpmEjHzlhzcb0NlkuYAbhojl8
         xFEU5rKYFr53ZSnmCCYVWo1xlwKZsZ9mEKtZ6ixode2jhdILiLnDbycwh/JtyYAyiz8k
         DF3lf8lvmcn/td5MCWOTg+qVDT4gWSP1QXzykYVOi7jXK9uEl0XgqUi3yz6NCnFfV4Z1
         LeEg==
X-Gm-Message-State: AOJu0YzSX22DIj17psUVz2FpMxtXJxHcuRQO3/SATfVAvkDrX0Y67F3e
	//VuCtmIHEQnTapc5+JhC6AIck58ScWmlSMuJv3CC90f2ASC+m4PI7dAZIpO4n6Y0PFCYVBrObN
	LgL0IEQ==
X-Google-Smtp-Source: AGHT+IHSbQwafud8Qz/m7ae8IRhczfBCvOeRvHnNzuxVSbiy+AufqS0UNTfG33jEJIXJxNQLdXS3xFn+KhM=
X-Received: from pjbqx15.prod.google.com ([2002:a17:90b:3e4f:b0:31f:37f:d381])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:224f:b0:31a:9004:899d
 with SMTP id 98e67ed59e1d1-3234213b9bemr306527a91.18.1755216748115; Thu, 14
 Aug 2025 17:12:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:11:53 -0700
In-Reply-To: <20250815001205.2370711-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815001205.2370711-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815001205.2370711-10-seanjc@google.com>
Subject: [PATCH 6.1.y 09/21] KVM: x86: Plumb "force_immediate_exit" into
 kvm_entry() tracepoint
From: Sean Christopherson <seanjc@google.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

[ Upstream commit 9c9025ea003a03f967affd690f39b4ef3452c0f5 ]

Annotate the kvm_entry() tracepoint with "immediate exit" when KVM is
forcing a VM-Exit immediately after VM-Enter, e.g. when KVM wants to
inject an event but needs to first complete some other operation.
Knowing that KVM is (or isn't) forcing an exit is useful information when
debugging issues related to event injection.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20240110012705.506918-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/svm/svm.c          | 5 +++--
 arch/x86/kvm/trace.h            | 9 ++++++---
 arch/x86/kvm/vmx/vmx.c          | 4 ++--
 arch/x86/kvm/x86.c              | 2 +-
 5 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 555c7bf35e28..93f523762854 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1528,7 +1528,8 @@ struct kvm_x86_ops {
 	void (*flush_tlb_guest)(struct kvm_vcpu *vcpu);
 
 	int (*vcpu_pre_run)(struct kvm_vcpu *vcpu);
-	enum exit_fastpath_completion (*vcpu_run)(struct kvm_vcpu *vcpu);
+	enum exit_fastpath_completion (*vcpu_run)(struct kvm_vcpu *vcpu,
+						  bool force_immediate_exit);
 	int (*handle_exit)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion exit_fastpath);
 	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2c0f9c7d1242..b4283c2358a6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4005,12 +4005,13 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
 	guest_state_exit_irqoff();
 }
 
-static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
+static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
+					  bool force_immediate_exit)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool spec_ctrl_intercepted = msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL);
 
-	trace_kvm_entry(vcpu);
+	trace_kvm_entry(vcpu, force_immediate_exit);
 
 	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
 	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 6c1dcf44c4fa..ab407bc00d84 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -15,20 +15,23 @@
  * Tracepoint for guest mode entry.
  */
 TRACE_EVENT(kvm_entry,
-	TP_PROTO(struct kvm_vcpu *vcpu),
-	TP_ARGS(vcpu),
+	TP_PROTO(struct kvm_vcpu *vcpu, bool force_immediate_exit),
+	TP_ARGS(vcpu, force_immediate_exit),
 
 	TP_STRUCT__entry(
 		__field(	unsigned int,	vcpu_id		)
 		__field(	unsigned long,	rip		)
+		__field(	bool,		immediate_exit	)
 	),
 
 	TP_fast_assign(
 		__entry->vcpu_id        = vcpu->vcpu_id;
 		__entry->rip		= kvm_rip_read(vcpu);
+		__entry->immediate_exit	= force_immediate_exit;
 	),
 
-	TP_printk("vcpu %u, rip 0x%lx", __entry->vcpu_id, __entry->rip)
+	TP_printk("vcpu %u, rip 0x%lx%s", __entry->vcpu_id, __entry->rip,
+		  __entry->immediate_exit ? "[immediate exit]" : "")
 );
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 390af16d9a67..0b495979a02b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7171,7 +7171,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	guest_state_exit_irqoff();
 }
 
-static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
+static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4;
@@ -7198,7 +7198,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		return EXIT_FASTPATH_NONE;
 	}
 
-	trace_kvm_entry(vcpu);
+	trace_kvm_entry(vcpu, force_immediate_exit);
 
 	if (vmx->ple_window_dirty) {
 		vmx->ple_window_dirty = false;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e7c73360890d..652f90ad7107 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10856,7 +10856,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		WARN_ON_ONCE((kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu)) &&
 			     (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED));
 
-		exit_fastpath = static_call(kvm_x86_vcpu_run)(vcpu);
+		exit_fastpath = static_call(kvm_x86_vcpu_run)(vcpu, req_immediate_exit);
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
 			break;
 
-- 
2.51.0.rc1.163.g2494970778-goog


