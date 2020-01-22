Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7E1144C88
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 08:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgAVHkF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 02:40:05 -0500
Received: from mail-vs1-f74.google.com ([209.85.217.74]:43028 "EHLO
        mail-vs1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVHkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 02:40:05 -0500
Received: by mail-vs1-f74.google.com with SMTP id j8so482711vsm.10
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 23:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Z571meg0eiiQxxoTP0BBBQ9SBLJ25qlGL+t6+g4n4iI=;
        b=UsQS5RxTjA06dw7M1OmdUOdvKBp7v8qg5OSEvcasBXyuL58IWM9a2gGVb3VcaOUMwW
         nR6kdxSAFuWw8NLRMkOxGOPdCSA8hkxNBPWeoav5pBQEWZ3SL+mRPh3h4Ax9u7k2UV9O
         DudaKmtb1XD7BruasrfvzCPy9U3nVyrIV7kJQhtx/W1GihnpncxzBVtiTGaFqbpdRzC2
         GhjqZdpe2zJtdFzPFGocrSHruNL3V+1AhD70i5UX5YSB70RNX8mICuSP/cyuu0W+YCDS
         fEAsIuSxyUwMIW1zN8zd/2pXlTyszirsPxuozkP/PgzK/zZuXcvQ/yEjFpMURsmvdeHO
         vLIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Z571meg0eiiQxxoTP0BBBQ9SBLJ25qlGL+t6+g4n4iI=;
        b=IQJdzAgEVvgV5Sl8o4gDtBJ1/0roP3NY7jL/WpJ2S6CYXODrhe6CYJdt7cFa7tHs6H
         QokovdHPlfZmPsHixZ7D9CUduINNfZTyXgpgjneVPekAQAKDS+tGLH0omv+8caH3gk0t
         tzeIsUWKX3shfemqYgGgIQN+xQ9mOlEGDhao9bfaOj7HHlJZmPMXlWkYB25Lw5MM3Z+n
         NuD4XaXLmQ2JlpRKZqgx8oc1AkwSDhh6rnJrQkWccu4a+ZsUehAZie3iLbpZiHIIUn7g
         k7bJurnrpldaOsPt7Wvdo4xmI7/trMMeU+Ncu/nS6NHlHqLxm5SmZfEAx8CHYsH8epfp
         U7QQ==
X-Gm-Message-State: APjAAAX4+lLvYc6f8LaymwUtw6c6ei6CAo6I8okqe4oTpbX8nlFIFB3A
        zIVqtHr7qBNLN2zDN/c8JzZi9++ce+c75l7BiRPJJZWa6qr5/75AF0iFhvQ6z7kEXh14UnMQF8p
        aAvmo5lHcjpt6MtPRSKyHP4Jmcbc1SpuX9neaXFl4xhXktZvrKtN8jghTVw==
X-Google-Smtp-Source: APXvYqzPUW3RAtQTN19/aaPWJ3VyhXGw3aRLwGp1ojJWcCU6sV8JJI+Vqa5cT6BqHnVokuA2y5Lwl1HsFFw=
X-Received: by 2002:a67:6842:: with SMTP id d63mr1846521vsc.171.1579678804266;
 Tue, 21 Jan 2020 23:40:04 -0800 (PST)
Date:   Tue, 21 Jan 2020 23:39:59 -0800
Message-Id: <20200122073959.192050-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [kvm-unit-tests PATCH] x86: VMX: Check preconditions for RDTSC test
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The RDTSC VM-exit test requires the 'use TSC offsetting' processor-based
VM-execution control be allowed on the host. Check this precondition
before running the test rather than asserting it later on to avoid
erroneous failures on a host without TSC offsetting.

Cc: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 x86/vmx_tests.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 3b150323b325..de9a931216e2 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -9161,9 +9161,6 @@ static void vmx_vmcs_shadow_test(void)
  */
 static void reset_guest_tsc_to_zero(void)
 {
-	TEST_ASSERT_MSG(ctrl_cpu_rev[0].clr & CPU_USE_TSC_OFFSET,
-			"Expected support for 'use TSC offsetting'");
-
 	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_USE_TSC_OFFSET);
 	vmcs_write(TSC_OFFSET, -rdtsc());
 }
@@ -9210,6 +9207,11 @@ static void rdtsc_vmexit_diff_test(void)
 	int fail = 0;
 	int i;
 
+	if (!(ctrl_cpu_rev[0].clr & CPU_USE_TSC_OFFSET)) {
+		printf("CPU doesn't support the 'use TSC offsetting' processor-based VM-execution control.\n");
+		return;
+	}
+
 	test_set_guest(rdtsc_vmexit_diff_test_guest);
 
 	reset_guest_tsc_to_zero();
-- 
2.25.0.341.g760bfbb309-goog

