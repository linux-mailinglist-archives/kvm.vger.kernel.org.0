Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F68A5F180D
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbiJABO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbiJABNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:13:52 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EC011461
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:13:17 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id l72-20020a63914b000000b00434ac6f8214so3717457pge.13
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=BrQJA1GEfWK5dvPJqWYwg3wcFKIFArdWH1xnahMzA7M=;
        b=ppgOtxDSzPIJmEbJ95yLQd6JsUPhIMglgS9nAFNj2H5aFNwBheBsvCeElOlZ7MLYg0
         r3wM2kK5HfITmoWcoBvesApsWEIynOmFwZ1E0T8ojNxtDsgw62/6z9Yh2lQYjO1wX7G8
         3+cAIojFsaDLLoH0MbglWzgvuRmoqjYcP1Kfl+wHmIGcsxojHMSsC1t1TAVF5rHPYw5s
         Vch0yPZEId4IO650EXdr2dpcEYfNDnebFD5ViNqtucJ2+nz7oVHoUct/GCxQuVL2x5XM
         VKoLQjFcoV8qKiNrxkcah//lcdcHo2XughlMP2kJGvufvb9CEeT0BxWyNSoxqPQ0F8bS
         oobQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=BrQJA1GEfWK5dvPJqWYwg3wcFKIFArdWH1xnahMzA7M=;
        b=YT9S4nqqKxIIxwT6ZSotnxOaeWeJoCuDlhUNpNSSUwMPnJVe7d4qC1+zfFRwYAz5JH
         qBxV/TScwfez8iAgvg4TDbKr8gPmTbYeoI/y6yuKSrc6CwT7rSz86VhZmSBrKNhR2GKl
         leP//l2kTnHaI0ac1qqXoSuVMgqAW9dyZoqfn81aZ1ikLfTjpeMMDXLMTYpYw3gnu0VS
         sw9lXCCkdQzungFT1xzOlNeigymxYIaC406VRbOfIbmTfmVm8x38JUC647DKTZ1GEMV9
         XX2bfSt56dnhT//Hwgb637qc2ZF6CxuE/cgMSpTWS+l7JTlV7ZPQljZt2QqeLJM8cC0d
         eUpA==
X-Gm-Message-State: ACrzQf3nv5eqaLVE7OiCn2E3AyxkMixVpfV5q8h12huHm1N62trKg8T8
        8Ls9jOjwi6DhIYjteeNMPDx3m8+smiE=
X-Google-Smtp-Source: AMsMyM4EUPmX6HDfzdevzPf660npw9NDqtqFyliGQVi8jvvPCwCfMv6xjNnCUqs8uXyiYYHHIRIr3/5y9w0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c986:b0:205:f08c:a82b with SMTP id
 w6-20020a17090ac98600b00205f08ca82bmr520222pjt.1.1664586796335; Fri, 30 Sep
 2022 18:13:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 01:13:00 +0000
In-Reply-To: <20221001011301.2077437-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001011301.2077437-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001011301.2077437-9-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 8/9] x86/apic: Add test for logical mode IPI
 delivery (cluster and flat)
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an APIC sub-test to verify the darker corners of logical mode IPI
delivery.  Logical mode is rather bizarre, in that each "ID" is treated
as a bitmask, e.g. an ID with multiple bits set can match multiple
destinations.  Verify that overlapping and/or superfluous destinations
and IDs with multiple target vCPUs are handled correctly for both flat
and cluster modes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/apic.c | 201 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 192 insertions(+), 9 deletions(-)

diff --git a/x86/apic.c b/x86/apic.c
index 5be44b8..1cc61d3 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -257,11 +257,11 @@ static void test_apic_id(void)
 	on_cpu(1, __test_apic_id, NULL);
 }
 
-static int ipi_count;
+static atomic_t ipi_count;
 
-static void self_ipi_isr(isr_regs_t *regs)
+static void handle_ipi(isr_regs_t *regs)
 {
-	++ipi_count;
+	atomic_inc(&ipi_count);
 	eoi();
 }
 
@@ -270,13 +270,13 @@ static void __test_self_ipi(void)
 	u64 start = rdtsc();
 	int vec = 0xf1;
 
-	handle_irq(vec, self_ipi_isr);
+	handle_irq(vec, handle_ipi);
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED | vec,
 		       id_map[0]);
 
 	do {
 		pause();
-	} while (rdtsc() - start < 1000000000 && ipi_count == 0);
+	} while (rdtsc() - start < 1000000000 && atomic_read(&ipi_count) == 0);
 }
 
 static void test_self_ipi_xapic(void)
@@ -287,9 +287,9 @@ static void test_self_ipi_xapic(void)
 	reset_apic();
 	report(is_xapic_enabled(), "Local apic enabled in xAPIC mode");
 
-	ipi_count = 0;
+	atomic_set(&ipi_count, 0);
 	__test_self_ipi();
-	report(ipi_count == 1, "self ipi");
+	report(atomic_read(&ipi_count) == 1, "self ipi");
 
 	report_prefix_pop();
 }
@@ -301,9 +301,9 @@ static void test_self_ipi_x2apic(void)
 	if (enable_x2apic()) {
 		report(is_x2apic_enabled(), "Local apic enabled in x2APIC mode");
 
-		ipi_count = 0;
+		atomic_set(&ipi_count, 0);
 		__test_self_ipi();
-		report(ipi_count == 1, "self ipi");
+		report(atomic_read(&ipi_count) == 1, "self ipi");
 	} else {
 		report_skip("x2apic not detected");
 	}
@@ -665,6 +665,188 @@ static void test_pv_ipi(void)
 	report(!ret, "PV IPIs testing");
 }
 
+#define APIC_LDR_CLUSTER_FLAG	BIT(31)
+
+static void set_ldr(void *__ldr)
+{
+	u32 ldr = (unsigned long)__ldr;
+
+	if (ldr & APIC_LDR_CLUSTER_FLAG)
+		apic_write(APIC_DFR, APIC_DFR_CLUSTER);
+	else
+		apic_write(APIC_DFR, APIC_DFR_FLAT);
+
+	apic_write(APIC_LDR, ldr << 24);
+}
+
+static int test_fixed_ipi(u32 dest_mode, u8 dest, u8 vector,
+			  int nr_ipis_expected, const char *mode_name)
+{
+	u64 start = rdtsc();
+	int got;
+
+	atomic_set(&ipi_count, 0);
+
+	/*
+	 * Wait for vCPU1 to get back into HLT, i.e. into the host so that
+	 * KVM must handle incomplete AVIC IPIs.
+	 */
+	do {
+		pause();
+	} while (rdtsc() - start < 1000000);
+
+	start = rdtsc();
+
+	apic_icr_write(dest_mode | APIC_DM_FIXED | vector, dest);
+
+	do {
+		pause();
+	} while (rdtsc() - start < 1000000000 &&
+		 atomic_read(&ipi_count) != nr_ipis_expected);
+
+	/* Only report failures to cut down on the spam. */
+	got = atomic_read(&ipi_count);
+	if (got != nr_ipis_expected)
+		report_fail("Want %d IPI(s) using %s mode, dest = %x, got %d IPI(s)",
+			    nr_ipis_expected, mode_name, dest, got);
+	atomic_set(&ipi_count, 0);
+
+	return got == nr_ipis_expected ? 0 : 1;
+}
+
+static int test_logical_ipi_single_target(u8 logical_id, bool cluster, u8 dest,
+					  u8 vector)
+{
+	/* Disallow broadcast, there are at least 2 vCPUs. */
+	if (dest == 0xff)
+		return 0;
+
+	set_ldr((void *)0);
+	on_cpu(1, set_ldr,
+	       (void *)((u32)logical_id | (cluster ? APIC_LDR_CLUSTER_FLAG : 0)));
+	return test_fixed_ipi(APIC_DEST_LOGICAL, dest, vector, 1,
+			      cluster ? "logical cluster" : "logical flat");
+}
+
+static int test_logical_ipi_multi_target(u8 vcpu0_logical_id, u8 vcpu1_logical_id,
+					 bool cluster, u8 dest, u8 vector)
+{
+	/* Allow broadcast unless there are more than 2 vCPUs. */
+	if (dest == 0xff && cpu_count() > 2)
+		return 0;
+
+	set_ldr((void *)((u32)vcpu0_logical_id | (cluster ? APIC_LDR_CLUSTER_FLAG : 0)));
+	on_cpu(1, set_ldr,
+	       (void *)((u32)vcpu1_logical_id | (cluster ? APIC_LDR_CLUSTER_FLAG : 0)));
+	return test_fixed_ipi(APIC_DEST_LOGICAL, dest, vector, 2,
+			      cluster ? "logical cluster" : "logical flat");
+}
+
+static void test_logical_ipi_xapic(void)
+{
+	int c, i, j, k, f;
+	u8 vector = 0xf1;
+
+	if (cpu_count() < 2)
+		return;
+
+	/*
+	 * All vCPUs must be in xAPIC mode, i.e. simply resetting this vCPUs
+	 * APIC is not sufficient.
+	 */
+	if (is_x2apic_enabled())
+		return;
+
+	handle_irq(vector, handle_ipi);
+
+	/* Flat mode.  8 bits for logical IDs (one per bit). */
+	f = 0;
+	for (i = 0; i < 8; i++) {
+		/*
+		 * Test all possible destination values.  Non-existent targets
+		 * should be ignored.  vCPU is always targeted, i.e. should get
+		 * an IPI.
+		 */
+		for (k = 0; k < 0xff; k++) {
+			/*
+			 * Skip values that overlap the actual target the
+			 * resulting combination will be covered by other
+			 * numbers in the sequence.
+			 */
+			if (BIT(i) & k)
+				continue;
+
+			f += test_logical_ipi_single_target(BIT(i), false,
+							    BIT(i) | k, vector);
+		}
+	}
+	report(!f, "IPI to single target using logical flat mode");
+
+	/* Cluster mode.  4 bits for the cluster, 4 bits for logical IDs. */
+	f = 0;
+	for (c = 0; c < 0xf; c++) {
+		for (i = 0; i < 4; i++) {
+			/* Same as above, just fewer bits... */
+			for (k = 0; k < 0x10; k++) {
+				if (BIT(i) & k)
+					continue;
+
+				test_logical_ipi_single_target(c << 4 | BIT(i), true,
+							       c << 4 | BIT(i) | k, vector);
+			}
+		}
+	}
+	report(!f, "IPI to single target using logical cluster mode");
+
+	/* And now do it all over again targeting both vCPU0 and vCPU1. */
+	f = 0;
+	for (i = 0; i < 8 && !f; i++) {
+		for (j = 0; j < 8 && !f; j++) {
+			if (i == j)
+				continue;
+
+			for (k = 0; k < 0x100 && !f; k++) {
+				if ((BIT(i) | BIT(j)) & k)
+					continue;
+
+				f += test_logical_ipi_multi_target(BIT(i), BIT(j), false,
+								   BIT(i) | BIT(j) | k, vector);
+				if (f)
+					break;
+				f += test_logical_ipi_multi_target(BIT(i) | BIT(j),
+								   BIT(i) | BIT(j), false,
+								   BIT(i) | BIT(j) | k, vector);
+			}
+		}
+	}
+	report(!f, "IPI to multiple targets using logical flat mode");
+
+	f = 0;
+	for (c = 0; c < 0xf && !f; c++) {
+		for (i = 0; i < 4 && !f; i++) {
+			for (j = 0; j < 4 && !f; j++) {
+				if (i == j)
+					continue;
+
+				for (k = 0; k < 0x10 && !f; k++) {
+					if ((BIT(i) | BIT(j)) & k)
+						continue;
+
+					f += test_logical_ipi_multi_target(c << 4 | BIT(i),
+									   c << 4 | BIT(j), true,
+									   c << 4 | BIT(i) | BIT(j) | k, vector);
+					if (f)
+						break;
+					f += test_logical_ipi_multi_target(c << 4 | BIT(i) | BIT(j),
+									   c << 4 | BIT(i) | BIT(j), true,
+									   c << 4 | BIT(i) | BIT(j) | k, vector);
+				}
+			}
+		}
+	}
+	report(!f, "IPI to multiple targets using logical cluster mode");
+}
+
 typedef void (*apic_test_fn)(void);
 
 int main(void)
@@ -682,6 +864,7 @@ int main(void)
 		test_self_ipi_xapic,
 		test_self_ipi_x2apic,
 		test_physical_broadcast,
+		test_logical_ipi_xapic,
 
 		test_pv_ipi,
 
-- 
2.38.0.rc1.362.ged0d419d3c-goog

