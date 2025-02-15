Return-Path: <kvm+bounces-38265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 240A1A36B25
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:38:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFE1E3B2F01
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA0811624E0;
	Sat, 15 Feb 2025 01:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0lKrBt3U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBB91624C8
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583419; cv=none; b=FfeJ0QfdYSfY2qCQkqe537eDD0B2fyYSi2keTo13xtUsGRD4AW16A0Hd/bEuFU0I4Py4BnqI74TLy9vR3+mqFT4q4X9jCN/dq+vhSTcJHkO/v8pzQSwcYuo6hx61ftkpb0e3rM5MKq7qhtjxUkAh4GrQlKd/6+43el51piTWGHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583419; c=relaxed/simple;
	bh=Z8Yjti8le/oMWRK4MrIcMDNxtoyqTfraNgt/vJThg+I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fowRTaPVYn9FtN/QvN6YHklBjQ2yp8phED47J7pStwhhv3CI7+UV4BuZmdeBtmDN+bvPZuAGg/kq/TQp6/EleOhrsD+TZgUyREthHOZBrh9rEMPNP+FwnZr/pMlHS/tQ3kxv6+kh9RaW5lBGxa2bGGPBgLdoQH4sf3Emn9tfc94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0lKrBt3U; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-221063a808dso2251355ad.1
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583417; x=1740188217; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hMRLX7X1OtZ7IzEvG7jp285oTdSMheWT0/cZFlSHECc=;
        b=0lKrBt3UjOTu6LYPTzLYCGKeCSFtzUiQ9uAVtX0pXuoW5ZqTqF9FjsY1d3OpoRMxyY
         hpOpR0pCAKipWmXBJPKdVfLHFeA4XaL3FrsaU0OcdtUJCJpexSYm0IxvySCmFOsCMNB+
         8stKfdDcGcvW74jmThdPd8nJFyd6jFDE1RifkrucoAA8pMiaUG7ZWLfM+tNa9UPdbiSe
         P62M/54IVylPdvUla7QzU3CsRgDHKCa/fjnuNXcF3mbfIY/2CjQVdjCgD9WQTrIBpc9U
         tt+/6XCRWTcLgrdHV4jKFQ59OuK0wKit/+ZD99rnAEmZP/XN7np/YU2zmwMgRQ1nb/9u
         hxxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583417; x=1740188217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hMRLX7X1OtZ7IzEvG7jp285oTdSMheWT0/cZFlSHECc=;
        b=uubcKa5nGq26U29DjEvatBqoYQjdMPqREeYNlX8rhkNUlnnAwQEQyTqWSRIiRGT0kj
         ckzbAQR4LfUO7DVq6WhiyF89rvks2qgWYY923EmlDg5KOUXm2CJol+PeE/Hn88SVia/+
         fLA+qMTHU2fsxsn6S8G4ZDasR0QyJbpM629absRhRHUauTB+jPMCztylkxojrD3sVk/p
         VE7YeVjXR48grSQk6sHHXSIPPaII+eOq8n/90mEP8v+3fqVrQOk8pmwn7QaCt15aGfzl
         xx9GaoOtI0VoZo+Bo9S98xTEv91OtJcUtaHVIETKudi5l+0nEepG2hiibWmWSZHGvxAf
         PLfA==
X-Gm-Message-State: AOJu0Yz/flEVadvpTDCu4LUBVwZlw0Sv6LCxFklLUUEO0GhIGBuWXXWH
	DPllVdXhzOypAhR6z5DzDahjjiMF0fUF2paiFP5DtDAL6w7VI3tZ33tZW3zDOhf/XWNlLVdJhSn
	FyA==
X-Google-Smtp-Source: AGHT+IGsY1gVG4g75pu1UxKrcth5Ooc3A/adxwchMJxG/miXLu+0TLin9C0K3rqp5F3rP7xzw/J1Y6OamQU=
X-Received: from pjbpv12.prod.google.com ([2002:a17:90b:3c8c:b0:2ea:5613:4d5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f547:b0:217:9172:2ce1
 with SMTP id d9443c01a7336-2210403dd64mr22613745ad.22.1739583416835; Fri, 14
 Feb 2025 17:36:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:36:28 -0800
In-Reply-To: <20250215013636.1214612-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013636.1214612-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013636.1214612-12-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v7 11/18] x86: pmu: Use macro to replace
 hard-coded instructions event index
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Replace hard-coded instruction event index with macro to avoid possible
mismatch issue if new event is added in the future and cause
instructions event index changed, but forget to update the hard-coded
event index.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 7ecde9f6..c7eda47a 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -55,6 +55,7 @@ struct pmu_event {
  * intel_gp_events[].
  */
 enum {
+	INTEL_INSTRUCTIONS_IDX  = 1,
 	INTEL_REF_CYCLES_IDX	= 2,
 	INTEL_BRANCHES_IDX	= 5,
 };
@@ -64,6 +65,7 @@ enum {
  * amd_gp_events[].
  */
 enum {
+	AMD_INSTRUCTIONS_IDX    = 1,
 	AMD_BRANCHES_IDX	= 2,
 };
 
@@ -329,11 +331,16 @@ static uint64_t measure_for_overflow(pmu_counter_t *cnt)
 
 static void check_counter_overflow(void)
 {
+	int i;
 	uint64_t overflow_preset;
-	int i;
+	int instruction_idx = pmu.is_intel ?
+			      INTEL_INSTRUCTIONS_IDX :
+			      AMD_INSTRUCTIONS_IDX;
+
 	pmu_counter_t cnt = {
 		.ctr = MSR_GP_COUNTERx(0),
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
+		.config = EVNTSEL_OS | EVNTSEL_USR |
+			  gp_events[instruction_idx].unit_sel /* instructions */,
 	};
 	overflow_preset = measure_for_overflow(&cnt);
 
@@ -389,13 +396,18 @@ static void check_counter_overflow(void)
 
 static void check_gp_counter_cmask(void)
 {
+	int instruction_idx = pmu.is_intel ?
+			      INTEL_INSTRUCTIONS_IDX :
+			      AMD_INSTRUCTIONS_IDX;
+
 	pmu_counter_t cnt = {
 		.ctr = MSR_GP_COUNTERx(0),
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
+		.config = EVNTSEL_OS | EVNTSEL_USR |
+			  gp_events[instruction_idx].unit_sel /* instructions */,
 	};
 	cnt.config |= (0x2 << EVNTSEL_CMASK_SHIFT);
 	measure_one(&cnt);
-	report(cnt.count < gp_events[1].min, "cmask");
+	report(cnt.count < gp_events[instruction_idx].min, "cmask");
 }
 
 static void do_rdpmc_fast(void *ptr)
@@ -470,9 +482,14 @@ static void check_running_counter_wrmsr(void)
 {
 	uint64_t status;
 	uint64_t count;
+	unsigned int instruction_idx = pmu.is_intel ?
+				       INTEL_INSTRUCTIONS_IDX :
+				       AMD_INSTRUCTIONS_IDX;
+
 	pmu_counter_t evt = {
 		.ctr = MSR_GP_COUNTERx(0),
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
+		.config = EVNTSEL_OS | EVNTSEL_USR |
+			  gp_events[instruction_idx].unit_sel,
 	};
 
 	report_prefix_push("running counter wrmsr");
@@ -481,7 +498,7 @@ static void check_running_counter_wrmsr(void)
 	loop();
 	wrmsr(MSR_GP_COUNTERx(0), 0);
 	stop_event(&evt);
-	report(evt.count < gp_events[1].min, "cntr");
+	report(evt.count < gp_events[instruction_idx].min, "cntr");
 
 	/* clear status before overflow test */
 	if (this_cpu_has_perf_global_status())
@@ -512,6 +529,9 @@ static void check_emulated_instr(void)
 	uint64_t gp_counter_width = (1ull << pmu.gp_counter_width) - 1;
 	unsigned int branch_idx = pmu.is_intel ?
 				  INTEL_BRANCHES_IDX : AMD_BRANCHES_IDX;
+	unsigned int instruction_idx = pmu.is_intel ?
+				       INTEL_INSTRUCTIONS_IDX :
+				       AMD_INSTRUCTIONS_IDX;
 	pmu_counter_t brnch_cnt = {
 		.ctr = MSR_GP_COUNTERx(0),
 		/* branch instructions */
@@ -520,7 +540,7 @@ static void check_emulated_instr(void)
 	pmu_counter_t instr_cnt = {
 		.ctr = MSR_GP_COUNTERx(1),
 		/* instructions */
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
+		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[instruction_idx].unit_sel,
 	};
 	report_prefix_push("emulated instruction");
 
-- 
2.48.1.601.g30ceb7b040-goog


