Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2072029F8BB
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 23:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgJ2W4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 18:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ2W4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 18:56:47 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF8DC0613CF
        for <kvm@vger.kernel.org>; Thu, 29 Oct 2020 15:56:45 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id ec4so2654116qvb.21
        for <kvm@vger.kernel.org>; Thu, 29 Oct 2020 15:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=cqVgUVr6NeVX3r2LoQl/czy6TdP/4mqDcQgIRYvpbWI=;
        b=TWwamgbGQnyjUTyUyW7/1azLQxnvAt4S4NKNq4rHAkqhkpoVmi37xSrkFilNd6LfT+
         T8hdXvhqw+Z73XExAgDgxS/JKHbsQ/4oJzJCQVLKNLy0ZeQBRltEjSkC3fZdT9bShTp7
         +LDsJ3IrkkUaJpuzhtj69MJQCXSt/RUSIJcjENRomlape/TJt9uwRpZT8x4MnL9Hc72y
         7UD+29oQYQOfz26Gpf+9ueC5RGBcJ06szXuPWNeubb8gQc5WwtlSThrof4k+SrPNNSSr
         m/1wPkD3UmDNBtoD69KWPSqxKHKi7947djwQzkwqdzCXmtMFhVigzH/RFQXTaqHma8/B
         QCUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=cqVgUVr6NeVX3r2LoQl/czy6TdP/4mqDcQgIRYvpbWI=;
        b=iIcpf3sYI9kebVgU99fN8Z3OQhocKQSu7kY4bl3Z8RFy05A/30EvF3KM1d3AlMnyqg
         BTfsc6PnWSwJWGv08m6GLjPQNnId0uNp5icxCkKvu3bue3i/X8TAcwwQyDKZdesbkRRQ
         HZrXyMdyE8jPlb9OoRH7JeG8CVrfcAwiAhpBm/qu6wSCxzmPFWQyUkq+qui6Pc4XEp+2
         +LF2sSUaswRlbhIiJZPrnj/R9PD9cyWlCsIYr3gXp2lkyFvERwdrDOBpLz3iw8xcw40Z
         t3xXqCnV1V1gJOzErbXX0fk9SVketH4+XjdZEpQ9+KxpPXuPXIpSdfoYc0huSMkDuhqP
         ofxA==
X-Gm-Message-State: AOAM533Ef+i2kG1SdOPqGH6L+IlP/MDy5R0GZ7Ou3waZDLRban15RPmb
        E9AFQ4GTPXbHNbwQINPqoR5rV84mBTyD5hqPjcjIIMdxUhm8/Q2sYOls+yfa+Jn2yx5HQme3Rfw
        y9A8cbwInNwb0wIffTb0d52AUg4I7ZWYHTo5nxl9p0wVi4I0kLtsuzbRexah9ei8=
X-Google-Smtp-Source: ABdhPJxLhTVejee5OE8CtXcZdDhRgYHXmo4T7W6vtmMjAc3X8MC64SP4E6ojKgHQTXvyQqPn6r7MTPC7afaVkQ==
Sender: "ricarkol via sendgmr" <ricarkol@ricarkol3.c.googlers.com>
X-Received: from ricarkol3.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:6596])
 (user=ricarkol job=sendgmr) by 2002:a05:6214:125:: with SMTP id
 w5mr6429587qvs.3.1604012204594; Thu, 29 Oct 2020 15:56:44 -0700 (PDT)
Date:   Thu, 29 Oct 2020 22:56:42 +0000
Message-Id: <20201029225642.1130237-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
Subject: [kvm-unit-tests PATCH] x86: apic: test self-IPI in xAPIC mode
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add self-IPI checks for both xAPIC and x2APIC explicitly as two separate
tests.  Both tests try to set up their respective mode (xAPIC or x2APIC)
and reset the mode to what was enabled before. If x2APIC is unsupported,
the x2APIC test is just skipped.

There was already a self-IPI test, test_self_ipi, that used x2APIC mode
if supported, and xAPIC otherwise.  This happened because test_self_ipi
used whatever mode was enabled before, and test_enable_x2apic (which
runs before) tries to enable x2APIC mode but falls back to legacy xAPIC
mode when x2APIC is unsupported.

Tested the case where x2apic is unsupported with:
./x86-run ./x86/apic.flat -smp 2 -cpu qemu64,-x2apic

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 x86/apic.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

diff --git a/x86/apic.c b/x86/apic.c
index a7681fea836c7..735022b7891f5 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -266,7 +266,7 @@ static void self_ipi_isr(isr_regs_t *regs)
     eoi();
 }
 
-static void test_self_ipi(void)
+static void __test_self_ipi(void)
 {
     u64 start = rdtsc();
     int vec = 0xf1;
@@ -279,8 +279,53 @@ static void test_self_ipi(void)
     do {
         pause();
     } while (rdtsc() - start < 1000000000 && ipi_count == 0);
+}
+
+static void test_self_ipi_xapic(void)
+{
+    u64 orig_apicbase = rdmsr(MSR_IA32_APICBASE);
+
+    report_prefix_push("self_ipi_xapic");
+
+    /* Reset to xAPIC mode. */
+    reset_apic();
+    report((rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN,
+           "Local apic enabled in xAPIC mode");
 
+    ipi_count = 0;
+    __test_self_ipi();
     report(ipi_count == 1, "self ipi");
+
+    /* Enable x2APIC mode if it was already enabled. */
+    if (orig_apicbase & APIC_EXTD)
+        enable_x2apic();
+
+    report_prefix_pop();
+}
+
+static void test_self_ipi_x2apic(void)
+{
+    u64 orig_apicbase = rdmsr(MSR_IA32_APICBASE);
+
+    report_prefix_push("self_ipi_x2apic");
+
+    if (enable_x2apic()) {
+        report((rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) ==
+               (APIC_EN | APIC_EXTD),
+               "Local apic enabled in x2APIC mode");
+
+        ipi_count = 0;
+        __test_self_ipi();
+        report(ipi_count == 1, "self ipi");
+
+        /* Reset to xAPIC mode unless x2APIC was already enabled. */
+        if (!(orig_apicbase & APIC_EXTD))
+            reset_apic();
+    } else {
+        report_skip("x2apic not detected");
+    }
+
+    report_prefix_pop();
 }
 
 volatile int nmi_counter_private, nmi_counter, nmi_hlt_counter, sti_loop_active;
@@ -657,7 +702,8 @@ int main(void)
     test_enable_x2apic();
     test_apicbase();
 
-    test_self_ipi();
+    test_self_ipi_xapic();
+    test_self_ipi_x2apic();
     test_physical_broadcast();
     if (test_device_enabled())
         test_pv_ipi();
-- 
2.29.1.341.ge80a0c044ae-goog

