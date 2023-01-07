Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC24660B60
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 02:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235512AbjAGBRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 20:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236354AbjAGBRo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 20:17:44 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB66C3218F
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 17:17:41 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id q9-20020a17090a304900b00226e84c4880so948197pjl.4
        for <kvm@vger.kernel.org>; Fri, 06 Jan 2023 17:17:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=c3x1mmxx6TaNj9r8WPatQxSE1ESQY1hOyTXtA2x+pCI=;
        b=Dl/ZNRGf5+C1hLJRrVSHIhNgh+4anqIDA15i2+K70kVlOxNghEKnFBL9TAI++ErUlw
         V2603r7O87MA1Bmz5VCUeKq6M13RzpLx/mZxxwbeIrvC1Kvro8klvk3C/AR8fPA2Cj28
         ZWcODKIHSsAk2XsUToCcCpHDcYOxJHJD2obS0PAq+K941zSoCQ0Ch3KFO0VmhtzaxMiq
         6/5/zTKCdoO1PbqZXZRFGLimV2vVpVhUPO+hua+xzEDLbWkDphpYZEpJ3KBDnoRbxp7H
         CzVoEiL0SK591WezfSbqzt3Wvx2DQ4i99UAotO4udcqlrANJkWztCYRPh4ulzrZlEzkM
         ZmIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c3x1mmxx6TaNj9r8WPatQxSE1ESQY1hOyTXtA2x+pCI=;
        b=oGY9fZDYRHpd4/qRR8l6SSH7EThNvMmn9rqTdJUK3J1GmvGN6STAw64gXjOgVSiE3e
         oLbwY9TPeXRPxCyFH8dNBfPYUDK627jdbQIvucF0o336iLatjkpvnv7ASaica+3xny2o
         EInhg1cpybXkEPfMQGsGn1x60L5EoY0brQBOpu3YPBiDJcuSsYwkSvITEw/VIEICkt6h
         K/XoAZ+36Q8C2Hpra7Nb2VYYmzwRmkApLqiZAft522hpGQsofaUCUkEwL/5S0WX+qEE6
         NggPOkKYOnhp2wlvCfXIK49w6gs5YCEau5dGAVrkhrztykFUqKxwvA8ady/th8n0yivQ
         YB5Q==
X-Gm-Message-State: AFqh2kpwkb3ZIGvRsEl6cCSNZisB5XSGDnF9zaBCyjM0qENY6sttSsWQ
        +UXDcLlAfZk6pU5Bu4K7i0WUf+2qHho=
X-Google-Smtp-Source: AMrXdXvrTv4fa5r1HPDGrifRejbcWrVT0idyOPSrl2iCMTOwzvcIEfwzcdz1d44G2s+MCzOS1nYhk2a5UmM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:982f:0:b0:583:319a:4409 with SMTP id
 q15-20020aa7982f000000b00583319a4409mr544334pfl.27.1673054261265; Fri, 06 Jan
 2023 17:17:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  7 Jan 2023 01:17:35 +0000
In-Reply-To: <20230107011737.577244-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230107011737.577244-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230107011737.577244-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 1/3] x86/msr: Skip built-in testcases if user
 provides custom MSR+value to test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
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

Skip the built-in MSR testcases if the user provides a custom MSR+value
to test.  If the user is asking to test a specific MSR+value, they likely
don't want to wait for the test to burn though a pile of MCE MSRs.

Fixes: 039d9207 ("x86: msr: Add tests for MCE bank MSRs")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/msr.c | 170 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 96 insertions(+), 74 deletions(-)

diff --git a/x86/msr.c b/x86/msr.c
index 69e81475..f97f0c51 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -120,88 +120,110 @@ static void test_msr(struct msr_info *msr, bool is_64bit_host)
 	}
 }
 
-int main(int ac, char **av)
+static void test_custom_msr(int ac, char **av)
+{
+	bool is_64bit_host = this_cpu_has(X86_FEATURE_LM);
+	char msr_name[32];
+	int index = strtoul(av[1], NULL, 0x10);
+	snprintf(msr_name, sizeof(msr_name), "MSR:0x%x", index);
+
+	struct msr_info msr = {
+		.index = index,
+		.name = msr_name,
+		.value = strtoull(av[2], NULL, 0x10)
+	};
+	test_msr(&msr, is_64bit_host);
+}
+
+static void test_misc_msrs(void)
+{
+	bool is_64bit_host = this_cpu_has(X86_FEATURE_LM);
+	int i;
+
+	for (i = 0 ; i < ARRAY_SIZE(msr_info); i++)
+		test_msr(&msr_info[i], is_64bit_host);
+}
+
+static void test_mce_msrs(void)
 {
 	bool is_64bit_host = this_cpu_has(X86_FEATURE_LM);
 	unsigned int nr_mce_banks;
 	char msr_name[32];
 	int i;
 
+	nr_mce_banks = rdmsr(MSR_IA32_MCG_CAP) & 0xff;
+	for (i = 0; i < nr_mce_banks; i++) {
+		snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_CTL", i);
+		test_msr_rw(MSR_IA32_MCx_CTL(i), msr_name, 0);
+		test_msr_rw(MSR_IA32_MCx_CTL(i), msr_name, -1ull);
+		test_wrmsr_fault(MSR_IA32_MCx_CTL(i), msr_name, NONCANONICAL);
+
+		snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_STATUS", i);
+		test_msr_rw(MSR_IA32_MCx_STATUS(i), msr_name, 0);
+		/*
+		 * STATUS MSRs can only be written with '0' (to clear the MSR),
+		 * except on AMD-based systems with bit 18 set in MSR_K7_HWCR.
+		 * That bit is not architectural and should not be set by
+		 * default by KVM or by the VMM (though this might fail if run
+		 * on bare metal).
+		 */
+		test_wrmsr_fault(MSR_IA32_MCx_STATUS(i), msr_name, 1);
+
+		snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_ADDR", i);
+		test_msr_rw(MSR_IA32_MCx_ADDR(i), msr_name, 0);
+		test_msr_rw(MSR_IA32_MCx_ADDR(i), msr_name, -1ull);
+		/*
+		 * The ADDR is a physical address, and all bits are writable on
+		 * 64-bit hosts.  Don't test the negative case, as KVM doesn't
+		 * enforce checks on bits 63:36 for 32-bit hosts.  The behavior
+		 * depends on the underlying hardware, e.g. a 32-bit guest on a
+		 * 64-bit host may observe 64-bit values in the ADDR MSRs.
+		 */
+		if (is_64bit_host)
+			test_msr_rw(MSR_IA32_MCx_ADDR(i), msr_name, NONCANONICAL);
+
+		snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_MISC", i);
+		test_msr_rw(MSR_IA32_MCx_MISC(i), msr_name, 0);
+		test_msr_rw(MSR_IA32_MCx_MISC(i), msr_name, -1ull);
+		test_msr_rw(MSR_IA32_MCx_MISC(i), msr_name, NONCANONICAL);
+	}
+
+	/*
+	 * The theoretical maximum number of MCE banks is 32 (on Intel CPUs,
+	 * without jumping to a new base address), as the last unclaimed MSR is
+	 * 0x479; 0x480 begins the VMX MSRs.  Verify accesses to theoretically
+	 * legal, unsupported MSRs fault.
+	 */
+	for (i = nr_mce_banks; i < 32; i++) {
+		snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_CTL", i);
+		test_rdmsr_fault(MSR_IA32_MCx_CTL(i), msr_name);
+		test_wrmsr_fault(MSR_IA32_MCx_CTL(i), msr_name, 0);
+
+		snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_STATUS", i);
+		test_rdmsr_fault(MSR_IA32_MCx_STATUS(i), msr_name);
+		test_wrmsr_fault(MSR_IA32_MCx_STATUS(i), msr_name, 0);
+
+		snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_ADDR", i);
+		test_rdmsr_fault(MSR_IA32_MCx_ADDR(i), msr_name);
+		test_wrmsr_fault(MSR_IA32_MCx_ADDR(i), msr_name, 0);
+
+		snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_MISC", i);
+		test_rdmsr_fault(MSR_IA32_MCx_MISC(i), msr_name);
+		test_wrmsr_fault(MSR_IA32_MCx_MISC(i), msr_name, 0);
+	}
+}
+
+int main(int ac, char **av)
+{
+	/*
+	 * If the user provided an MSR+value, test exactly that and skip all
+	 * built-in testcases.
+	 */
 	if (ac == 3) {
-		int index = strtoul(av[1], NULL, 0x10);
-		snprintf(msr_name, sizeof(msr_name), "MSR:0x%x", index);
-
-		struct msr_info msr = {
-			.index = index,
-			.name = msr_name,
-			.value = strtoull(av[2], NULL, 0x10)
-		};
-		test_msr(&msr, is_64bit_host);
+		test_custom_msr(ac, av);
 	} else {
-		for (i = 0 ; i < ARRAY_SIZE(msr_info); i++)
-			test_msr(&msr_info[i], is_64bit_host);
-
-		nr_mce_banks = rdmsr(MSR_IA32_MCG_CAP) & 0xff;
-		for (i = 0; i < nr_mce_banks; i++) {
-			snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_CTL", i);
-			test_msr_rw(MSR_IA32_MCx_CTL(i), msr_name, 0);
-			test_msr_rw(MSR_IA32_MCx_CTL(i), msr_name, -1ull);
-			test_wrmsr_fault(MSR_IA32_MCx_CTL(i), msr_name, NONCANONICAL);
-
-			snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_STATUS", i);
-			test_msr_rw(MSR_IA32_MCx_STATUS(i), msr_name, 0);
-			/*
-			 * STATUS MSRs can only be written with '0' (to clear
-			 * the MSR), except on AMD-based systems with bit 18
-			 * set in MSR_K7_HWCR.  That bit is not architectural
-			 * and should not be set by default by KVM or by the
-			 * VMM (though this might fail if run on bare metal).
-			 */
-			test_wrmsr_fault(MSR_IA32_MCx_STATUS(i), msr_name, 1);
-
-			snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_ADDR", i);
-			test_msr_rw(MSR_IA32_MCx_ADDR(i), msr_name, 0);
-			test_msr_rw(MSR_IA32_MCx_ADDR(i), msr_name, -1ull);
-			/*
-			 * The ADDR is a physical address, and all bits are
-			 * writable on 64-bit hosts.    Don't test the negative
-			 * case, as KVM doesn't enforce checks on bits 63:36
-			 * for 32-bit hosts.  The behavior depends on the
-			 * underlying hardware, e.g. a 32-bit guest on a 64-bit
-			 * host may observe 64-bit values in the ADDR MSRs.
-			 */
-			if (is_64bit_host)
-				test_msr_rw(MSR_IA32_MCx_ADDR(i), msr_name, NONCANONICAL);
-
-			snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_MISC", i);
-			test_msr_rw(MSR_IA32_MCx_MISC(i), msr_name, 0);
-			test_msr_rw(MSR_IA32_MCx_MISC(i), msr_name, -1ull);
-			test_msr_rw(MSR_IA32_MCx_MISC(i), msr_name, NONCANONICAL);
-		}
-
-		/*
-		 * The theoretical maximum number of MCE banks is 32 (on Intel
-		 * CPUs, without jumping to a new base address), as the last
-		 * unclaimed MSR is 0x479; 0x480 begins the VMX MSRs.  Verify
-		 * accesses to theoretically legal, unsupported MSRs fault.
-		 */
-		for (i = nr_mce_banks; i < 32; i++) {
-			snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_CTL", i);
-			test_rdmsr_fault(MSR_IA32_MCx_CTL(i), msr_name);
-			test_wrmsr_fault(MSR_IA32_MCx_CTL(i), msr_name, 0);
-
-			snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_STATUS", i);
-			test_rdmsr_fault(MSR_IA32_MCx_STATUS(i), msr_name);
-			test_wrmsr_fault(MSR_IA32_MCx_STATUS(i), msr_name, 0);
-
-			snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_ADDR", i);
-			test_rdmsr_fault(MSR_IA32_MCx_ADDR(i), msr_name);
-			test_wrmsr_fault(MSR_IA32_MCx_ADDR(i), msr_name, 0);
-
-			snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_MISC", i);
-			test_rdmsr_fault(MSR_IA32_MCx_MISC(i), msr_name);
-			test_wrmsr_fault(MSR_IA32_MCx_MISC(i), msr_name, 0);
-		}
+		test_misc_msrs();
+		test_mce_msrs();
 	}
 
 	return report_summary();
-- 
2.39.0.314.g84b9a713c41-goog

