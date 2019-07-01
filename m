Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB03C58978
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 20:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfF0SHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 14:07:05 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42488 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbfF0SHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 14:07:05 -0400
Received: by mail-pg1-f196.google.com with SMTP id k13so1364935pgq.9
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2019 11:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KvpccCGbIR5vR1fU6mkTYmo6UymuiN0W8cf9VwXY0Qs=;
        b=BmtkaUOpf5LIahpaLqBpBJBz/sxamYhhY6w1zckw+AvG4vbEUsQfP08zZcho+D/k48
         076aK4LCZ0l8huTeM6PUmsWvigaxLBJSH9XhLO2i/peeBYTtoVaJ3gQtZMhhz8pv/6le
         BbGdEHfxR6PyWtF92R2LwE0YBK57VIcZkyjs76q1SihzM0DNAzLGCqFWc19JfCPPI66r
         dHNlSQzHvAZt7pcY/4jJiHMOCIC2lXhw70Y48yO+/TuIFjRm1NIl1geO054hxrLuA7Wv
         1JQXTGB6HPVNi3/FT3LF4O2cFvPHfKEk287aeL6qmcyaxvdTn2vdlMECaSmZorc3E3pM
         frRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KvpccCGbIR5vR1fU6mkTYmo6UymuiN0W8cf9VwXY0Qs=;
        b=J5awWMFSNjiwmmG6Zav71E1Ai1Nc3wumh1qDBsO3Yf4bwyRDPIcTRoQO763pGcbd9v
         AAI47R1x4/UAeZiNkTkr8bZRZbTwqT06S4MIo7ioNKmGbTC9MDrkVEi1f/9lnoT9vYps
         dtwmSgMz9J7AHABlvVsyySkHTsPV5pCDLBfHIXs58mA1pbpCEGiyPPNznJRK1sKzTJdp
         nvBmZGksNuFvLTPfEuP/oW8f77+n1INpkV++XwplAXMYEY6LbCLYYFW98yWb/ANqFXYy
         A7MROvbpV7lGq09IZgSHy/Br2zW4ptGF9duSIouMKfhcjhXIrI9z/05uCDY3t1chB3rc
         llGw==
X-Gm-Message-State: APjAAAVK6DIK0EsJNIOsDhpxotCtXQfYFhxWJQiKYijhxCwQEh3sAKlv
        Hlm0v0nZWgbzdanfN4NMGVc=
X-Google-Smtp-Source: APXvYqzdFCUu4dgcewRq8k3L3UKHskJ+PPWrHmI2DGt5wnNv1Be2+3rEdrp0LSd/CgZytNDKBK9AQw==
X-Received: by 2002:a63:8f09:: with SMTP id n9mr4878631pgd.249.1561658824250;
        Thu, 27 Jun 2019 11:07:04 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id w22sm3263982pfi.175.2019.06.27.11.07.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 11:07:03 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Marc Orr <marcorr@google.com>
Subject: [kvm-unit-tests PATCH v2] x86: Remove assumptions on CR4.MCE
Date:   Thu, 27 Jun 2019 03:44:53 -0700
Message-Id: <20190627104453.4182-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CR4.MCE might be set after boot. Remove the assertion that checks that
it is clear. Change the test to toggle the bit instead of setting it.

Cc: Marc Orr <marcorr@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/vmx_tests.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index b50d858..329bafa 100644
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
 
@@ -7126,17 +7128,14 @@ static void vmx_cr_load_test(void)
 	 * No exception is expected.
 	 *
 	 * NB. KVM loads the last guest write to CR4 into CR4 read
-	 *     shadow. In order to trigger an exit to KVM, we can set a
-	 *     bit that was zero in the above CR4 write and is owned by
-	 *     KVM. We choose to set CR4.MCE, which shall have no side
-	 *     effect because normally no guest MCE (e.g., as the result
-	 *     of bad memory) would happen during this test.
+	 *     shadow. In order to trigger an exit to KVM, we can toggle a
+	 *     bit that is owned by KVM.
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

