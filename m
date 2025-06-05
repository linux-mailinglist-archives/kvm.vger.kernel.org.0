Return-Path: <kvm+bounces-48595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 14EBEACF7CA
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:23:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8337B3AACFA
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E786C27E7DA;
	Thu,  5 Jun 2025 19:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qo0UuoW5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E0427D766
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 19:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749151365; cv=none; b=rc1dRUF7qYZJuL/lguTPIFk6s0xhPTkw2VwAXL2RhuDSricor7Xa7h3nfjNuOuWtACBmn206UrAUDdPsQ0OMYbL9ttBtV7wC0hCcMVK2UEcdKvcTYOnfi5ovcB3hhRDN7bNEv3Oc7fpqdV75o71vtcj1QlvJK6HMrABvPQIA0AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749151365; c=relaxed/simple;
	bh=S0UB63BERDKcsVa1967aJOHbpD1AyJhtkamnUPyq5hg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nCfXwebQwlj/tFggVTtE4HxX834FhWkdbR5PwA4HqShElFo2V68Mv2eOTaWK5sYUJDfAac18uAJpVFPg5irge8B941f7ittC6TVkm4JxjMVuHptcYFwYrjFUI0a8w5haCizEMXqSZGBn+lUUJDPCheLiiYi71amJmv2IkuB2pGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qo0UuoW5; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-312c33585c2so1377008a91.0
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 12:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749151363; x=1749756163; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zVbg6gsQO8EWW6IFt7FTxxa2TN0qzHqe3tiINA6lqz8=;
        b=qo0UuoW5+8TjBDrQ0kqCPP86aybQszJMDlg0AsapCnpHjBlfjNYRgR0KVkGeTYdQFZ
         p/jX7hX56MfcXwGTwKcBkvvIhw46DQcGC5WIgvtzySl+T+h1nQMnBdaPVnC6mIVam8YM
         wMveoVvu9zTCzOaLi459yHZ27grMacqIDvf4re8kjVZf8OhMidPwvj1XT6HAEwAAr9sX
         IFzrktowY2Zmqmg0OVZeX7Xjq2eKHjixU6ApRLqZsfpGEd1zdj0zJgugPfagVESrXdeL
         qIsJPHK0Xdx08NTDvjnFIkSOzwGjXsyy4aG5F8md187vvNl4hdWRkWGBFuM1YkIwQl0U
         Zcng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749151363; x=1749756163;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zVbg6gsQO8EWW6IFt7FTxxa2TN0qzHqe3tiINA6lqz8=;
        b=fYA/tSNuDfH4of34AcbAVl66oLJzg+DoY7CtGjKaQRMAdZaasfG6ErhpqnZonN0DEi
         b9WAfyZdanifuuk/zLRC1OOofblrXvaIWLnWFPE352MMw7xPpcpwO6SjBqVCaVLczxmD
         y90X32u8BfL/fC+DmX+yIPYvpZJo9gGHCc9t3NoQq0ZgemzTcgCWOIbslCKS7kO8c83I
         TcndHdTj7gFZJb9cKk07NHbBouQVyrWR5SFoy0Hcx+vzrCkP7KuDxaqEiHLdPNj7XJiA
         X9u+bJDig7HHJXGErKmuwAlZ5O1OE+/X4DT/w+DwL8SUJCReE72bau23mj3qbHANVNW1
         cgNw==
X-Gm-Message-State: AOJu0Yz3jx6KERQV1/GUTIXdrxN26EhaIM1CH2CvsfLTg4FZ0e/9Xf4y
	kOAK/yUOucC7wRS7a+IGkzAcQqDsi4L3tKDEkdlFfhi1YoWZ6rZWhP6QRB78T+V2yzq+TdYJdze
	HoDLeOg==
X-Google-Smtp-Source: AGHT+IHBEatuZhaQeRf02Ooywkr9BUYN/npDmZlpuo41hmyTitbCIkzcIqIkrfRYjUHZ9AwokJZqV616eYc=
X-Received: from pjh8.prod.google.com ([2002:a17:90b:3f88:b0:308:6685:55e6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:540f:b0:311:ed2:b758
 with SMTP id 98e67ed59e1d1-313472d2a5bmr1229078a91.3.1749151363062; Thu, 05
 Jun 2025 12:22:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Jun 2025 12:22:24 -0700
In-Reply-To: <20250605192226.532654-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605192226.532654-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250605192226.532654-7-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 6/8] x86: nSVM: Set MSRPM bit on-demand when
 testing interception
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Set the to-be-tested {RD,WR}MSR's associated MSRPM bit on-demand when
verifying KVM's emulation of MSR interception.  Setting all bits in the
bitmap creates a massive blind spot in the test coverage, e.g. KVM could
completely ignore the bitmap, and the test would still pass.

Run the test with all bits initially clear, and all bits initially set,
mostly in prepartion for adding coverage of MSR passthrough in a future
commit.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm_tests.c | 104 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 96 insertions(+), 8 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 5d06249f..ef8c2cec 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -312,12 +312,41 @@ static void prepare_msr_intercept(struct svm_test *test)
 {
 	default_prepare(test);
 	vmcb->control.intercept |= (1ULL << INTERCEPT_MSR_PROT);
-	memset(msr_bitmap, 0xff, MSR_BITMAP_SIZE);
+
+	memset(msr_bitmap, 0, MSR_BITMAP_SIZE);
+}
+
+#define SVM_MSRPM_BYTES_PER_RANGE 2048
+#define SVM_BITS_PER_MSR 2
+#define SVM_MSRS_PER_BYTE 4
+#define SVM_MSRS_PER_RANGE 8192
+#define SVM_MSRPM_OFFSET_MASK (SVM_MSRS_PER_RANGE - 1)
+
+static int get_msrpm_bit_nr(u32 msr)
+{
+	int range_nr;
+
+	switch (msr & ~SVM_MSRPM_OFFSET_MASK) {
+	case 0:
+		range_nr = 0;
+		break;
+	case 0xc0000000:
+		range_nr = 1;
+		break;
+	case 0xc0010000:
+		range_nr = 2;
+		break;
+	default:
+		return - 1;
+	}
+
+	return range_nr * SVM_MSRPM_BYTES_PER_RANGE * BITS_PER_BYTE +
+	       (msr & SVM_MSRPM_OFFSET_MASK) * SVM_BITS_PER_MSR;
 }
 
-static void test_msr_intercept(struct svm_test *test)
+static void __test_msr_intercept(struct svm_test *test)
 {
-	u64 ignored, arb_val = 0xef8056791234abcd; /* Arbitrary value */
+	u64 val, arb_val = 0xef8056791234abcd; /* Arbitrary value */
 	int vector;
 	u32 msr;
 
@@ -341,9 +370,12 @@ static void test_msr_intercept(struct svm_test *test)
 		else if (msr == 0xc0002000 + 1)
 			msr = 0xc0010000 - 1;
 
+		test->scratch = msr;
+		vmmcall();
+
 		test->scratch = -1;
 
-		vector = rdmsr_safe(msr, &ignored);
+		vector = rdmsr_safe(msr, &val);
 		if (vector)
 			report_fail("Expected RDMSR(0x%x) to #VMEXIT, got exception '%u'",
 				    msr, vector);
@@ -351,12 +383,17 @@ static void test_msr_intercept(struct svm_test *test)
 			report_fail("Expected RDMSR(0x%x) to #VMEXIT, got scratch '%ld",
 				    msr, test->scratch);
 
+		test->scratch = BIT_ULL(32) | msr;
+		vmmcall();
+
 		/*
 		 * Poor man approach to generate a value that
 		 * seems arbitrary each time around the loop.
 		 */
 		arb_val += (arb_val << 1);
 
+		test->scratch = -1;
+
 		vector = wrmsr_safe(msr, arb_val);
 		if (vector)
 			report_fail("Expected WRMSR(0x%x) to #VMEXIT, got exception '%u'",
@@ -364,17 +401,69 @@ static void test_msr_intercept(struct svm_test *test)
 		else if (test->scratch != arb_val)
 			report_fail("Expected WRMSR(0x%x) to #VMEXIT, got scratch '%ld' (wanted %ld)",
 				    msr, test->scratch, arb_val);
+
+		test->scratch = BIT_ULL(33) | msr;
+		vmmcall();
 	}
+}
+
+static void test_msr_intercept(struct svm_test *test)
+{
+	__test_msr_intercept(test);
 
 	test->scratch = -2;
+	vmmcall();
+
+	__test_msr_intercept(test);
+
+	test->scratch = -3;
+}
+
+static void restore_msrpm_bit(int bit_nr, bool set)
+{
+	if (set)
+		__set_bit(bit_nr, msr_bitmap);
+	else
+		__clear_bit(bit_nr, msr_bitmap);
 }
 
 static bool msr_intercept_finished(struct svm_test *test)
 {
 	u32 exit_code = vmcb->control.exit_code;
+	bool all_set = false;
+	int bit_nr;
 
-	if (exit_code == SVM_EXIT_VMMCALL)
-		return true;
+	if (exit_code == SVM_EXIT_VMMCALL) {
+		vmcb->save.rip += 3;
+
+		if (test->scratch == -3)
+			return true;
+
+		if (test->scratch == -2) {
+			all_set = true;
+			memset(msr_bitmap, 0xff, MSR_BITMAP_SIZE);
+			return false;
+		}
+	
+		bit_nr = get_msrpm_bit_nr(test->scratch & -1u);
+		if (bit_nr < 0)
+			return false;
+
+		switch (test->scratch >> 32) {
+		case 0:
+			__set_bit(bit_nr, msr_bitmap);
+			return false;
+		case 1:
+			restore_msrpm_bit(bit_nr, all_set);
+			__set_bit(bit_nr + 1, msr_bitmap);
+			return false;
+		case 2:
+			restore_msrpm_bit(bit_nr + 1, all_set);
+			return false;
+		default:
+			return true;
+		}
+	}
 
 	if (exit_code != SVM_EXIT_MSR) {
 		report_fail("Wanted MSR VM-Exit, got reason 0x%x", exit_code);
@@ -402,8 +491,7 @@ static bool msr_intercept_finished(struct svm_test *test)
 
 static bool check_msr_intercept(struct svm_test *test)
 {
-	memset(msr_bitmap, 0, MSR_BITMAP_SIZE);
-	return (test->scratch == -2);
+	return (test->scratch == -3);
 }
 
 static void prepare_mode_switch(struct svm_test *test)
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


