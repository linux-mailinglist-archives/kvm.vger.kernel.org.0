Return-Path: <kvm+bounces-32298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 75AEB9D530B
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 20:00:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 224921F23535
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 19:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B68B1E0DB2;
	Thu, 21 Nov 2024 18:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ACTzjQHK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847771E04A9
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 18:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732215219; cv=none; b=WbobbjfHs9Q2gVShe4CVjEgMp4QKNiEYmmOanfRkIeQD2WWEVnG8WY0ZpkGR+DLUySKkDJeZFQ09EHDeGNPWnDOEzaJxc3EzTHS3slzXzFRQZfXbvzjTxk8kUabf9K23/Z0aAQBMiXjcGnpT7vPY3GofSqKrwYcvzHoXQp0k9lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732215219; c=relaxed/simple;
	bh=VnUEvIgOY10j/aE/ufecNYMq79Fqq+mS5k1WDTSCKFE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SybPHkQEGsAbZn4UZycrctXlOE0090mDkYrt0aj3fdSnY2Nsn7+PxvRaXr/sz3wHy1dADhzLGlMLy9SHFLE/ahhUnxmbz2VZar0g7dWEU+B95TT6wb9bCcxIjoKnkNeH40ngWrX5+tgiZZX2sxP/IHyFWz//HvHelY9+11DfZkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ACTzjQHK; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ee7ccc0283so20404907b3.2
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 10:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732215216; x=1732820016; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AFRU4BWr8SpweEeBBix0zZoy9QkEncA+tQMcSsG2aPs=;
        b=ACTzjQHKDGL++AUqRLNBtmYDz9y5TfwonJSnUUFsHXdKIpFi9gQZcxXoLNXn9XArv/
         W0YjSc5Nvnt+47E2nFUv4m6Cqe6b/F1HxgU92TBSpI9ZhUx1bO4P1SR2Hdm2QQOj177i
         svIn41ihyk/eKtx8n9Ue51nU/5Ic18OiFu5XeWom2G1RJ/8FruQVB4RezAa6G6Wp25Xe
         cb8fJDfUJNP2nmojZdA61CbQ0mfn6z3VispEUXTw826BcO13KTQRANR4jlR4V7qJZWJ2
         mwj8C+mlZKRxCqG07sc/PhuaHKXyPSPTeP/ocs8kzrjZLt6a0P5Q4T0g1qEphwvxrTM1
         b5UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732215216; x=1732820016;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AFRU4BWr8SpweEeBBix0zZoy9QkEncA+tQMcSsG2aPs=;
        b=LQPiN5dxjJMgLR/FDZHYHHkkVZExVRjpUidj+Zqi6KJyHXOg3ow0Q5eIcNSS7+RMEN
         Nt+usnOV8Lt6IVFVpxTjX1v41w6v27Eo9AOJMGjZ/I2pI9UaBWNgY2FNNkh43iKvs7YR
         TPaeteVr4fAD/oZRD8FW3nJMqGCxMx3T6PkEmSoa7yk5iXhKxrrc8AMroYX7k7Cj9g0o
         cqP1sqeYE0rjG26hP/qDFvsJ8gyydX4n8foV/LANvnAtlXgokjp4dsGCWE8WvmRVtahw
         DeHRXOboSWb1mRST8KbgUf24YZDoAZ9o/SUypFwq7KL48ZLrPdqOR+YK8BPpN3f9axG+
         ZNjg==
X-Forwarded-Encrypted: i=1; AJvYcCVVBB6Mg9xRvYZu9n7f+KacJsv89F83a7o4+LTUNeEn0+32C4FPz/ApWLALv+1X7VxIQJk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywn+g1CKPknxHcZcc+BHvWv+g70m1DElQksax3owY0kK2Rl/1ZZ
	pAqYucHSilKpDL5A+5+nPqwHuRv+tYpacpIQQKlzNYPqdWr239e2PRNQfHekMAL+QSLJb8pnemu
	Y/8Be+A==
X-Google-Smtp-Source: AGHT+IG5NTyhfTOvOMtguS2XrmwrQUHPkXMhoswbbltJbsHj7nG8Hf9HsNhFgPZx0QThUafRc4jHGvqlK4Je
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a5b:f51:0:b0:e28:e97f:538d with SMTP id
 3f1490d57ef6-e38cb5d9aa0mr3198276.6.1732215216510; Thu, 21 Nov 2024 10:53:36
 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu, 21 Nov 2024 18:53:03 +0000
In-Reply-To: <20241121185315.3416855-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121185315.3416855-1-mizhang@google.com>
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241121185315.3416855-12-mizhang@google.com>
Subject: [RFC PATCH 11/22] KVM: x86: Initialize guest [am]perf at vcpu power-on
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

From: Jim Mattson <jmattson@google.com>

The guest's IA32_APERF and IA32_MPERF MSRs start at zero. However,
IA32_MPERF should be incremented whenever the vCPU is in C0, just as
the host's IA32_MPERF MSR is incremented by hardware.

Record the host TSC at vcpu_reset() to start tracking time spent in C0.
Later patches will add the host TSC delta to the guest's stored IA32_MPERF
value at appropriate points.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/kvm_host.h | 9 +++++++++
 arch/x86/kvm/x86.c              | 7 +++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 04ef56d10cbb1..067e6ec7f7e9c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -738,6 +738,13 @@ struct kvm_queued_exception {
 	bool has_payload;
 };
 
+struct kvm_vcpu_aperfmperf {
+	u64 guest_aperf;
+	u64 guest_mperf;
+	u64 host_tsc;
+	bool loaded_while_running;
+};
+
 struct kvm_vcpu_arch {
 	/*
 	 * rip and regs accesses must go through
@@ -1040,6 +1047,8 @@ struct kvm_vcpu_arch {
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t hv_root_tdp;
 #endif
+
+	struct kvm_vcpu_aperfmperf aperfmperf;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3c6b0ca91e5f5..d66cccff13347 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12476,6 +12476,13 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 		__kvm_set_xcr(vcpu, 0, XFEATURE_MASK_FP);
 		__kvm_set_msr(vcpu, MSR_IA32_XSS, 0, true);
+
+		/*
+		 * IA32_MPERF should start running now. Record the host TSC
+		 * so that we can add the host TSC delta the next time that
+		 * we load the guest [am]perf values into the hardware MSRs.
+		 */
+		vcpu->arch.aperfmperf.host_tsc = rdtsc();
 	}
 
 	/* All GPRs except RDX (handled below) are zeroed on RESET/INIT. */
-- 
2.47.0.371.ga323438b13-goog


