Return-Path: <kvm+bounces-63996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AD7FCC769EC
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:32:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 59548354CAC
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 23:32:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC1532F2918;
	Thu, 20 Nov 2025 23:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MrC0/gDn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6142A12FF69
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 23:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763681523; cv=none; b=sxmscPXDeBYdtA2YED3Dqd5hNzlN4FVx0gwtVnKpTw7b6/QskIE1lJUBII1FUUIFER0P1pIrhc12efi01v9Jmo+3dHSTKCpdSkadaS3LrXFdteGxzVE9tQOqDc4tySh0TGF13jK8rH+7DwuuQvq7VuLxnB5+UeFqhDB1/W0gEaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763681523; c=relaxed/simple;
	bh=jAQzUbwU9lh5DX7N+TYJJquqs0cEpOn2ceOpX3TEepw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ANceneaqyKKNVgAiapho1X33ksk4L+kCd9dMov/s8d5eXg0tghUo61MPlZWxLOCbtRDriBXTCXtQvar/dcu5TwRckdb2+QB3LFQUFYXBvqm2zJ7SUr4+u9I+AUIycBDrlJEGeNLxihHSvvcClDJCnOCgKLJSZ4HcLhhcl2NVaMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MrC0/gDn; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b8ed43cd00so1677182b3a.2
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 15:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763681522; x=1764286322; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aj/j30FlSZYF4ql5dX6cLCi8mRImN+8+YS5uG/BNFtQ=;
        b=MrC0/gDnNPNMI86TuOnewJsRRQxMKMuqg1T6q2EMV6KA0hHWcgxuXO07XJM+L44AT8
         GejtVDG9ky40QijCpQ5XRxZgITFJNPoB3ChgD2MnQe3sZv1sZ/t5M4x9767JxW4Yvpkf
         U0cU8pdr1SVZr8MpjTJa2UCvNWW2ZiWzxiJYqJ8HYrgGqmm7k2an2P+ZFX8JOfZSY4Kf
         NvVTS5WPXyBm/BQguWso9VN1NxQepFM0DcfHvmB9OPRKKP8PEyCwaUh8SOII0OkYGZVs
         RC4brk89bzYsVYqKDHeaMDbA+Du6nzYTeLuvg/5VFnvDjyfCozwRrBlXNUUIxbszwA0d
         0c2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763681522; x=1764286322;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aj/j30FlSZYF4ql5dX6cLCi8mRImN+8+YS5uG/BNFtQ=;
        b=u1nJgqoYTO1QLtLQ+VCgJd0Qq2GDRjRoibSp02tkF2WZmC2GNLvgfGG6FLgPbCAaIb
         9+QPUmZ9xKA3UWzHehIvze0TZsqqBibZEbj+t8mzMk/UNlmhmRCv0N3cUAKJTuQxyLjq
         4yNBEnAppzTnCveKWm1mFU9SA+KYVOuC1kgoZBeFctukbssGy/7pVccu0aGgGZU79pn5
         BWfXUFhOPhSf8fLSJD8TABZImyOlyw/VQ6XPkfTBrYIj3qNOtqXiIHqAkjjyBqb8vmh9
         vpNaDO07c0yi89WCUdExRMQwh7G2UMFkj2atlxfE+ml0zZmQiPwhFAUp+elokQeolKxT
         hC7A==
X-Gm-Message-State: AOJu0Yz0P4p9IQjYySzDsjGzgkM4+ui+whQv/bYqRgAMvxEnJh1xoba4
	AO25zAdTWCynsZMeUJYT+ufUJIKZoMC5EP7mSOkU5l1acEBrRRY5YyBtJr3pQwqcih1lTgYDC08
	LsBA3PA==
X-Google-Smtp-Source: AGHT+IFYPqu1HWRk/6F/KavWexFfqC+2o8Y/b5tZHwrgRTKGFb2SZUmcJE3mAX2GCIDBaUyLR4jbiSCXOJs=
X-Received: from pgbcq1.prod.google.com ([2002:a05:6a02:4081:b0:bbe:a147:5784])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d8b:b0:353:1edd:f7a
 with SMTP id adf61e73a8af0-3614eecd35bmr527235637.59.1763681521452; Thu, 20
 Nov 2025 15:32:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 20 Nov 2025 15:31:46 -0800
In-Reply-To: <20251120233149.143657-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251120233149.143657-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251120233149.143657-6-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 5/8] x86/pmu: Relax precise count check for
 emulated instructions tests
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Yi Lai <yi1.lai@intel.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Relax precise count check for emulated instructions tests on these
platforms with HW overcount issues.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
[sean: handle errata independently]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index e1e98959..ccf4ee63 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -756,6 +756,8 @@ static void check_emulated_instr(void)
 		/* instructions */
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[instruction_idx].unit_sel,
 	};
+	const bool has_perf_global_ctrl = this_cpu_has_perf_global_ctrl();
+
 	report_prefix_push("emulated instruction");
 
 	if (this_cpu_has_perf_global_status())
@@ -769,7 +771,7 @@ static void check_emulated_instr(void)
 	wrmsr(MSR_GP_COUNTERx(0), brnch_start & gp_counter_width);
 	wrmsr(MSR_GP_COUNTERx(1), instr_start & gp_counter_width);
 
-	if (this_cpu_has_perf_global_ctrl()) {
+	if (has_perf_global_ctrl) {
 		eax = BIT(0) | BIT(1);
 		ecx = pmu.msr_global_ctl;
 		edx = 0;
@@ -784,17 +786,15 @@ static void check_emulated_instr(void)
 
 	// Check that the end count - start count is at least the expected
 	// number of instructions and branches.
-	if (this_cpu_has_perf_global_ctrl()) {
-		report(instr_cnt.count - instr_start == KVM_FEP_INSNS,
-		       "instruction count");
-		report(brnch_cnt.count - brnch_start == KVM_FEP_BRANCHES,
-		       "branch count");
-	} else {
-		report(instr_cnt.count - instr_start >= KVM_FEP_INSNS,
-		       "instruction count");
-		report(brnch_cnt.count - brnch_start >= KVM_FEP_BRANCHES,
-		       "branch count");
-	}
+	if (has_perf_global_ctrl && !pmu.errata.instructions_retired_overcount)
+		report(instr_cnt.count - instr_start == KVM_FEP_INSNS, "instruction count");
+	else
+		report(instr_cnt.count - instr_start >= KVM_FEP_INSNS, "instruction count");
+
+	if (has_perf_global_ctrl && !pmu.errata.branches_retired_overcount)
+		report(brnch_cnt.count - brnch_start == KVM_FEP_BRANCHES, "branch count");
+	else
+		report(brnch_cnt.count - brnch_start >= KVM_FEP_BRANCHES, "branch count");
 
 	if (this_cpu_has_perf_global_status()) {
 		// Additionally check that those counters overflowed properly.
-- 
2.52.0.rc2.455.g230fcf2819-goog


