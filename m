Return-Path: <kvm+bounces-32303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 632009D531A
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 20:02:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 290A22809DF
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 19:02:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC1441E1A05;
	Thu, 21 Nov 2024 18:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yWzJ++4E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486311E1C3E
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 18:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732215227; cv=none; b=iA8euQ8o6MOIJDBU4yma5Suu2rKtq9o7KPSaiyWpZvdlSgdofXoe+J3dY+AqmZp66uWDbF43uUSHI6m3O4Ovypv5ou91GRrBXHGlxJTxl8156lm7hVt/l5WSXo54TSeVyUzsY7RgYsBB4q61pP8ALqWtWUsBugensNkIo2rqMYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732215227; c=relaxed/simple;
	bh=kH3D5R4M6NKtNCZGtvdwg+QTSyMzUsIWYvW/jUpioyA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kBOOVQLoROUZ938TZbR4kYkSLq4notqnROlkWeFkODB3mJ/tv+qu6uMZFgIagJYkiHSCc6pbnSZQTMlPlm1brWndEsJSBjbdn0XQlQm2hGaGvDXFSF7QDNLuXKmpSMGcQ6qKG3zmHjj0uQceXSPW+WYhTW12cFqNq0E92GPEzB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yWzJ++4E; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71e55c9d23cso1017304b3a.0
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 10:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732215226; x=1732820026; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/vtFvw8p5uLNhWI0pwE3zjisLWQE5QnAFBSwBwyPeu0=;
        b=yWzJ++4E5julIyUqjtSvVkEqy23uSVKQLRijgA2PaTuBdR10Y9ksAspY0DS63UmAi8
         8F+G7iVPuwtzgxE7c3X91yIYXbYvgiTrbE4OQMbUQ8Y9VwrNkLnkLzk8EEjjuVUNF3j+
         TB6MHuchXvqADl8aFGn/BpHOmVG3mumcHzML9OIgRWy7IaHvyuHogLpA+9yZl/koq3b6
         mZ7B3/oTW28F/sQCofBh8FqrufOGVufTIb++TU/1F1HwpWzysz4UvFV/aYoPFUqt/3wF
         k01Udc7JsOKumRWflbJ30s3XoLgwS0A7aA6TBCusGw+3zYU5aG5hDRdx4zFQxusr7uEh
         FCgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732215226; x=1732820026;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/vtFvw8p5uLNhWI0pwE3zjisLWQE5QnAFBSwBwyPeu0=;
        b=t/JkVBY7ddSB0Y8kJizvBITkK2LdRJBJ0+ebvYacAnKyL1oape30WMlivsoOLg/CT4
         xrnm92xmb8VleOWKFR8+WzbU63q/eSeTUXb8tuWEntXGiWMeoPHdFfmuY/o0et7bTGEk
         kKwgDUOxb867uPqZO86A8fbvppLn/hw4C0XbQuKvhNpjo+q7Uy0y9kFvmGWu721tqujo
         zktSTpKGofRTaTEWPzADr6eWU+ovfG7o0/sq0MGBvtSveUp48kjinMPvYkoKc/0TUXFX
         vuv6h4/Dk2371w3QS8VcTz9gLouRWIObUtGO7GlTgQU9MrO7WN+SnbRrbxzqmK/KR52o
         d9qA==
X-Forwarded-Encrypted: i=1; AJvYcCUm6L2NkKRuxRI1tPqLP3ZBTouENUBlV7HwVk95Lm9iBz4Nvmp8eKWTRybggXo1JMGqlAY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwekPppicbkHWPy3Usaw4gcliY3kQaF19MEPEwwbYHP1GO2PqfZ
	ph2f7GFLRNz3vYDSbx28ucCF42uAWir4ykhTadjPT3Cr0njHEyVgNt27VDIsHOj2EGaugltxDfB
	6KNJk1w==
X-Google-Smtp-Source: AGHT+IFbWsmMQq438PKz0JqAFBdWxkozDwaN7GD30aXSE1hcn3GxW73iad3n1P+et4T/231tXqeFsMKVoHWU
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a62:e20d:0:b0:724:d915:5836 with SMTP id
 d2e1a72fcca58-724d915588fmr1625b3a.0.1732215225677; Thu, 21 Nov 2024 10:53:45
 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu, 21 Nov 2024 18:53:08 +0000
In-Reply-To: <20241121185315.3416855-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121185315.3416855-1-mizhang@google.com>
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241121185315.3416855-17-mizhang@google.com>
Subject: [RFC PATCH 16/22] KVM: x86: Save guest [am]perf checkpoint on HLT
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Huang Rui <ray.huang@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Perry Yuan <perry.yuan@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

When the guest executes HLT, the vCPU transitions from virtual C0 to
C1 state. Its virtual IA32_APERF and IA32_MPERF MSRs should stop
counting at this point, just as the host's MSRs stop when it enters
C1.

Save a checkpoint of the current hardware MSR values and host
TSC. Later, if/when the vCPU becomes runnable again, we will start
accumulating C0 cycles from this checkpoint.

To avoid complications, also restore host MSR values at this time,

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Co-developed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/x86.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ad5351673362c..793f5d2afeb2b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5139,6 +5139,21 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
 }
 
+static void kvm_put_guest_aperfmperf(struct kvm_vcpu *vcpu)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	if (vcpu->arch.aperfmperf.loaded_while_running) {
+		rdmsrl(MSR_IA32_APERF, vcpu->arch.aperfmperf.guest_aperf);
+		rdmsrl(MSR_IA32_MPERF, vcpu->arch.aperfmperf.guest_mperf);
+		vcpu->arch.aperfmperf.host_tsc = rdtsc();
+		if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED)
+			vcpu->arch.aperfmperf.loaded_while_running = false;
+	}
+	local_irq_restore(flags);
+}
+
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	int idx;
@@ -11363,10 +11378,13 @@ static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
 	 */
 	++vcpu->stat.halt_exits;
 	if (lapic_in_kernel(vcpu)) {
-		if (kvm_vcpu_has_events(vcpu))
+		if (kvm_vcpu_has_events(vcpu)) {
 			vcpu->arch.pv.pv_unhalted = false;
-		else
+		} else {
 			vcpu->arch.mp_state = state;
+			if (guest_can_use(vcpu, X86_FEATURE_APERFMPERF))
+				kvm_put_guest_aperfmperf(vcpu);
+		}
 		return 1;
 	} else {
 		vcpu->run->exit_reason = reason;
-- 
2.47.0.371.ga323438b13-goog


