Return-Path: <kvm+bounces-48596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F415EACF7CB
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:23:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C27DD172823
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:23:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C26E927E7F9;
	Thu,  5 Jun 2025 19:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gTA5IwBq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7302D1FDE33
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 19:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749151368; cv=none; b=Xpg5Sko+Mz/uZRQTo9R4TOZdYXWx783+hOeWyWFESUPyJ5NU5S9rEwtj2znQQ5Qt5/Fyu6xmdyzLtmjIXlg1+/Jiw+fG2MNBDA2DGry5ApQMQdg7TexU1WsXQFhXq9xY+W4vxnRZR6+ZkSiDUcs1yDcP02Cqrnhm0DKgY8En76U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749151368; c=relaxed/simple;
	bh=iG6BmNp57Y3A1eyPonHUFpkc7pJTJTrtpSI5pSiKMOc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jc3eDYOJZCyi2Isi26Tk0WNC7W0/BvQjyjldvZr4MZsP7hHTPUecLM5ig3lc1A70CaWcsPnEdI8MsCw9JT7B0JOsolDdjDaeeQ30jirechqEV+Xyx2QTJmF2ylOio9COJL/ZmQ9vTEM7alPlTby7GgT8fI2j0SMaQ2ASkZ0vauQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gTA5IwBq; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-740774348f6so1198597b3a.1
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 12:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749151365; x=1749756165; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IWpj6ZjnKJQdTlWciFUcMXXwp/SL9i9U4JtAIeyEb20=;
        b=gTA5IwBqvbBgYL04xagRG2Fy6QRn/tBitL621PWM19l03hB13wU4tMg23mpymrirvp
         e9NWuGv4gxI823iyGSq7mFC7dhsFAsnd+gr5jh/aGijSun4fHKscuN1SL/EmjhFpCbsq
         vCbrEbZtiayuVd3lSCOnnQbexPgqerHh4AcWk39/oXvTK7AqTbnDeTRY4j20SniIbGDo
         34mQkHmwzztF3peKnXq7PBB4HHs/otdPnHg0oVIJh5lX/Wt5e6Z+s27Co9Cls37C6MyE
         eOZuJwF8L51/wQkJNQrLp01tGURbQuP46gzlcuP12v05xip88m+eszXbjVDuHXq9ERqK
         O3nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749151365; x=1749756165;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IWpj6ZjnKJQdTlWciFUcMXXwp/SL9i9U4JtAIeyEb20=;
        b=gyC2eDn4A2Bbtas2KWDfsT++eZRrWHFepZSToJXRj/ZYeB1gExZV5Y9derUTykWWzQ
         eyO57LXoayOYTEx7qk1H0/koQ6jkgDgzSAKF6GIIe7fqO753NF8n/rX/fiRyLPwqzLbC
         LB8FTXVvzyOrtn3xsknWH8Zspt04Pm/MCkD0aJsCl2lVOzxIf3XLJar9K61Ja+mSjxMF
         To0qeSiCw46OynNB9YvEGyLtpa17mG8BOSDIoDYPASr5aDIafO0EzciA0ysli66JQOgr
         ET0Dyl640gOIh2Uwsas/l+sebY/UeWN30TUDKUfnW4BBSzGls/5FFo1Rrt1i1sAolDoj
         q0dw==
X-Gm-Message-State: AOJu0YwXRrwq41WmdgZcIkRfPzviu4Qa3me5P+MMnXkrj95gCA5Q1hwb
	A4JroyviOM0V/9KtGcw31SaWDCsJw75jicbn5qemGssYsMt18zCJn2OeS7KCKigxpxl8USjwL4I
	J6nDQpA==
X-Google-Smtp-Source: AGHT+IFZHWpZPWWRKKg5H/9ncsgl+aqwZ3DdyNEIfl9nCvUpBb8xL7PrteqF2cFTsOg5b0+fHHCcWrtX9Qo=
X-Received: from pfbig20.prod.google.com ([2002:a05:6a00:8b94:b0:747:a305:836a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2e07:b0:740:6630:633f
 with SMTP id d2e1a72fcca58-74827e8061bmr1352687b3a.8.1749151364800; Thu, 05
 Jun 2025 12:22:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Jun 2025 12:22:25 -0700
In-Reply-To: <20250605192226.532654-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605192226.532654-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250605192226.532654-8-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 7/8] x86: nSVM: Verify disabling {RD,WR}MSR
 interception behaves as expected
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Extend nSVM's MSRPM test to verify that disabling MSR interception also
behaves as expected, i.e. that {RD,WR}MSR don't exit, and doesn't set the
VM on fire.

Disable x2APIC (if necessary) when writing x2APIC MSRs so that writes from
L2 #GP instead of doing random things, e.g. sending IPIs and crashing the
guest.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm_tests.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index ef8c2cec..a89a234e 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -308,12 +308,16 @@ static bool check_next_rip(struct svm_test *test)
 
 extern u8 *msr_bitmap;
 
+static bool is_x2apic;
+
 static void prepare_msr_intercept(struct svm_test *test)
 {
 	default_prepare(test);
 	vmcb->control.intercept |= (1ULL << INTERCEPT_MSR_PROT);
 
 	memset(msr_bitmap, 0, MSR_BITMAP_SIZE);
+
+	is_x2apic = is_x2apic_enabled();
 }
 
 #define SVM_MSRPM_BYTES_PER_RANGE 2048
@@ -404,6 +408,37 @@ static void __test_msr_intercept(struct svm_test *test)
 
 		test->scratch = BIT_ULL(33) | msr;
 		vmmcall();
+
+		if (get_msrpm_bit_nr(msr) < 0) {
+			report(msr == 0x2000 ||
+			       msr == 0xc0000000 - 1 || msr == 0xc0002000 ||
+			       msr == 0xc0010000 - 1 || msr == 0xc0012000,
+			       "MSR 0x%x not covered by an MSRPM range", msr);
+			continue;
+		}
+
+		/*
+		 * Verify that disabling interception for MSRs within an MSRPM
+		 * range behaves as expected.  Simply eat exceptions, the goal
+		 * is to verify interception, not MSR emulation/virtualization.
+		 */
+		test->scratch = -1;
+		(void)rdmsr_safe(msr, &val);
+		if (test->scratch != -1)
+			report_fail("RDMSR 0x%x, Wanted -1 (no intercept), got 0x%lx",
+				    msr, test->scratch);
+
+		test->scratch = BIT_ULL(34) | msr;
+		vmmcall();
+
+		test->scratch = -1;
+		(void)wrmsr_safe(msr, val);
+		if (test->scratch != -1)
+			report_fail("WRMSR 0x%x, Wanted -1 (no intercept), got 0x%lx",
+				    msr, test->scratch);
+
+		test->scratch = BIT_ULL(35) | msr;
+		vmmcall();
 	}
 }
 
@@ -434,6 +469,8 @@ static bool msr_intercept_finished(struct svm_test *test)
 	int bit_nr;
 
 	if (exit_code == SVM_EXIT_VMMCALL) {
+		u32 msr = test->scratch & -1u;
+
 		vmcb->save.rip += 3;
 
 		if (test->scratch == -3)
@@ -445,7 +482,7 @@ static bool msr_intercept_finished(struct svm_test *test)
 			return false;
 		}
 	
-		bit_nr = get_msrpm_bit_nr(test->scratch & -1u);
+		bit_nr = get_msrpm_bit_nr(msr);
 		if (bit_nr < 0)
 			return false;
 
@@ -459,6 +496,22 @@ static bool msr_intercept_finished(struct svm_test *test)
 			return false;
 		case 2:
 			restore_msrpm_bit(bit_nr + 1, all_set);
+			__clear_bit(bit_nr, msr_bitmap);
+			return false;
+		case 4:
+			restore_msrpm_bit(bit_nr, all_set);
+			__clear_bit(bit_nr + 1, msr_bitmap);
+			/*
+			 * Disable x2APIC so that WRMSR faults instead of doing
+			 * random things, e.g. sending IPIs.
+			 */
+			if (is_x2apic && msr >= 0x800 && msr <= 0x8ff)
+				reset_apic();
+			return false;
+		case 8:
+			restore_msrpm_bit(bit_nr + 1, all_set);
+			if (is_x2apic && msr >= 0x800 && msr <= 0x8ff)
+				enable_x2apic();
 			return false;
 		default:
 			return true;
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


