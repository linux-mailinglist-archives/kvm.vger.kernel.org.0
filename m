Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB6D8557C0
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 21:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfFYTZi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 15:25:38 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35160 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfFYTZi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 15:25:38 -0400
Received: by mail-pl1-f196.google.com with SMTP id w24so1478936plp.2
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2019 12:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=i+J0SKmGw6ZEpgEH930eO6KcIrrYT2XoE9OZaoJqIn4=;
        b=by7wxIt6zTKugGwlTbYo0dbHP0KO6n5tEuoKMTzXKmWRiWdfpGmLP2QqpKatcakJMz
         v5hv+8gXwiMhan+snRoOknwnCBZusH0/5Dedxbs/KmuI1B3VzOFk9IwvDqg1gktsEsjP
         dI58fhEA0FNjsNmK7vpuwUGDzWndUPaQAbH2on68Jldk63JS/O5ZmeNB++pQm2uRNHFp
         ajiUhE9fD0zfpCEwMkiBhQvS1gG4NRwvL7iHroprRCCKRMRAytqYBXe5yDxF1igJp9Tz
         rCkUqZZAt/y8oO8++V1f3BTIO+zbKdG5c8pElHfFqYxmbCoqadRTb5bjTGyt12bR3M23
         s3CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=i+J0SKmGw6ZEpgEH930eO6KcIrrYT2XoE9OZaoJqIn4=;
        b=JyiUIAB6iw6ohAZA4ptbZTnjoQpPT0tm3PSdWnYqUZovnOwbZInoEq2lMWizmFDYrl
         CMRlOlGgGBK6BA47OqCO0wHVIT2lRXQTVuNFApqNiqImltDFzTc46k0Fn0w1ofiEB0z0
         lmOIDGIWqUUnqvGWR/1/p8rt4Dx7pc93XXnSN+B5xI92QZWYn7u97NByugSsNYGc00oG
         OW7ODzHu3UDS9m46iPzXe3IkgnOc6zH9Mp1IkEegwAjKhnpSYIT6JrogYQbm8T5m9LbW
         T0+qJ57zVFZPMwjBVn9NfM3NJMw2kCrTsY6UBmOeYbimLOPr/zh0sTQt2wjhfee0DVcv
         cuFw==
X-Gm-Message-State: APjAAAUBIOm68GOFZjG2TaxBBcGQgzH7wU6+U86XPIKFXgJ2PwBJfKvD
        ygNl63cecovL5pvdElITsU8=
X-Google-Smtp-Source: APXvYqzlxEyBvhw3fNCgoDHqB2MUre/EDdT95TvPC2HwlY6XgHFZSxRHZZjqwb6BGLIt//aHR675xA==
X-Received: by 2002:a17:902:2ba7:: with SMTP id l36mr346194plb.334.1561490737335;
        Tue, 25 Jun 2019 12:25:37 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id x14sm17922158pfq.158.2019.06.25.12.25.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 12:25:36 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Marc Orr <marcorr@google.com>
Subject: [kvm-unit-tests PATCH] x86: Remove assumptions on CR4.MCE
Date:   Tue, 25 Jun 2019 05:03:22 -0700
Message-Id: <20190625120322.8483-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CR4.MCE might be set after boot. Remove the assertion that checks that
it is clear. Change the test to toggle the bit instead of setting it.

Cc: Marc Orr <marcorr@google.com>
Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/vmx_tests.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index b50d858..3731757 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7096,8 +7096,11 @@ static int write_cr4_checking(unsigned long val)
 
 static void vmx_cr_load_test(void)
 {
+	unsigned long cr3, cr4, orig_cr3, orig_cr4;
 	struct cpuid _cpuid = cpuid(1);
-	unsigned long cr4 = read_cr4(), cr3 = read_cr3();
+
+	orig_cr4 = read_cr4();
+	orig_cr3 = read_cr3();
 
 	if (!(_cpuid.c & X86_FEATURE_PCID)) {
 		report_skip("PCID not detected");
@@ -7108,12 +7111,11 @@ static void vmx_cr_load_test(void)
 		return;
 	}
 
-	TEST_ASSERT(!(cr4 & (X86_CR4_PCIDE | X86_CR4_MCE)));
-	TEST_ASSERT(!(cr3 & X86_CR3_PCID_MASK));
+	TEST_ASSERT(!(orig_cr3 & X86_CR3_PCID_MASK));
 
 	/* Enable PCID for L1. */
-	cr4 |= X86_CR4_PCIDE;
-	cr3 |= 0x1;
+	cr4 = orig_cr4 | X86_CR4_PCIDE;
+	cr3 = orig_cr3 | 0x1;
 	TEST_ASSERT(!write_cr4_checking(cr4));
 	write_cr3(cr3);
 
@@ -7126,17 +7128,16 @@ static void vmx_cr_load_test(void)
 	 * No exception is expected.
 	 *
 	 * NB. KVM loads the last guest write to CR4 into CR4 read
-	 *     shadow. In order to trigger an exit to KVM, we can set a
-	 *     bit that was zero in the above CR4 write and is owned by
-	 *     KVM. We choose to set CR4.MCE, which shall have no side
-	 *     effect because normally no guest MCE (e.g., as the result
-	 *     of bad memory) would happen during this test.
+	 *     shadow. In order to trigger an exit to KVM, we can toggle a
+	 *     bit that is owned by KVM. We choose to set CR4.MCE, which shall
+	 *     have no side effect because normally no guest MCE (e.g., as the
+	 *     result of bad memory) would happen during this test.
 	 */
-	TEST_ASSERT(!write_cr4_checking(cr4 | X86_CR4_MCE));
+	TEST_ASSERT(!write_cr4_checking(cr4 ^ X86_CR4_MCE));
 
-	/* Cleanup L1 state: disable PCID. */
-	write_cr3(cr3 & ~X86_CR3_PCID_MASK);
-	TEST_ASSERT(!write_cr4_checking(cr4 & ~X86_CR4_PCIDE));
+	/* Cleanup L1 state. */
+	write_cr3(orig_cr3);
+	TEST_ASSERT(!write_cr4_checking(orig_cr4));
 }
 
 static void vmx_nm_test_guest(void)
-- 
2.17.1

