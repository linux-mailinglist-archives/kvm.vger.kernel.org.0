Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7B9660B62
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 02:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236454AbjAGBRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 20:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236482AbjAGBRs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 20:17:48 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D27A3056C
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 17:17:45 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id u2-20020a17090341c200b00192bc565119so2240365ple.16
        for <kvm@vger.kernel.org>; Fri, 06 Jan 2023 17:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fuXSliv8FIF3N3/7qZl1OzzM/nJx2QL6aEeV4ofyMMs=;
        b=f0olwSia31Hi6Xreavl0pZZ4+61XaPYdZTuShAvnXUjqfYcv0sK0zQObAUDSz6g5Ja
         8CPs9Ejoiq/e5RorA1Kt7eNoQJp+K/c678aT9tUPVx+fCBso/UriF8AcF/rv6nMMDCfz
         xsUxznQeuPtCMG7aRJwiiONRS/LZEkUMvLxCUC58ez74oI3T0sCBWJTh46c6EO1N0Cio
         t2j4Rx/Xid+uO2YS8LzRRmXG/9N6GLRs1ox+D4gw9DPQsME/ZB39o1nXo9jm2rm4qh0H
         xOo5p0ksaY8zcXrKStSm7nBJ1TCuC6zwmday3HyararyTH2GvyCcJuTx+ubtyOrkzPvS
         peDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fuXSliv8FIF3N3/7qZl1OzzM/nJx2QL6aEeV4ofyMMs=;
        b=bzsZLThEyKTXLD58ICGh3hThNYUBDBmf0Kd6b++3rgoRAsugYQel92o41dD4WEVjJe
         Hwcwpk5Yev1n+wFwkJ80xOR3QF+YsvaH429ccqrbXn/vbIBJRL1yU6DOPdxgxADmnLAg
         e74eTEYmXYoXK1SD57T7Tv7NLW5qs2bCMpInY+pCfV2JIu8hbalxlk8fIH3EgTsEc4YC
         oJ+2tZIXfXEDFLzJdxh0Oqp0p4dk+eF81lbMfH/EcavCmtjqLnSOzv8PzHwQcBxNyrg8
         9RUzV/vgtuMhBuBOppHsaZ8q0hk5Brs0B6H3bZlUcSANolOoyStgTARWFVFTVXWOfpij
         buNA==
X-Gm-Message-State: AFqh2koaoR8JdIhliHM++U+lGV23py4inmA0bTCm2kv/1DxbVTvTa8kX
        L7Qnzdrq/lwnC0x9Xzul1IVcnzaqlFQ=
X-Google-Smtp-Source: AMrXdXtsxyaIy77W+Z7JHYUS0+G4deoIhkr006OeRMTECQYiL8bhbQna8EWloQ2G74GgraIgm0EhuNG+vno=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:5f87:0:b0:57f:ef13:63aa with SMTP id
 t129-20020a625f87000000b0057fef1363aamr3669493pfb.42.1673054264621; Fri, 06
 Jan 2023 17:17:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  7 Jan 2023 01:17:37 +0000
In-Reply-To: <20230107011737.577244-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230107011737.577244-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230107011737.577244-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 3/3] x86/msr: Add testcases for x2APIC MSRs
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

Verify that reads and writes to x2APIC MSRs #GP when x2APIC is disabled,
and that reads and writes honor KVM's emulation (which follows Intel
behavior) when x2APIC is enabled.  E.g. verify that writes to read-only
registers #GP, reads to write-onliy registers #GP, etc...

Write '0' to write-only registers to play nice with AMD's more restrictive
behavior (Intel doesn't care what value is written).

Note, the x2APIC enabled testcases will likely fail if run on AMD bare
metal as the KVM doesn't emulate registers above self-IPI, i.e. MSRs that
are expected to #GP are presumably handled by AMD hardware.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/msr.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/x86/msr.c b/x86/msr.c
index f97f0c51..97cf5987 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -1,6 +1,7 @@
 /* msr tests */
 
 #include "libcflat.h"
+#include "apic.h"
 #include "processor.h"
 #include "msr.h"
 #include <stdlib.h>
@@ -213,6 +214,63 @@ static void test_mce_msrs(void)
 	}
 }
 
+static void __test_x2apic_msrs(bool x2apic_enabled)
+{
+	enum x2apic_reg_semantics semantics;
+	unsigned int index, i;
+	char msr_name[32];
+
+	for (i = 0; i < 0x1000; i += 0x10) {
+		index = x2apic_msr(i);
+		snprintf(msr_name, sizeof(msr_name), "x2APIC MSR 0x%x", index);
+
+		if (x2apic_enabled)
+			semantics = get_x2apic_reg_semantics(i);
+		else
+			semantics = X2APIC_INVALID;
+
+		if (!(semantics & X2APIC_WRITABLE))
+			test_wrmsr_fault(index, msr_name, 0);
+
+		if (!(semantics & X2APIC_READABLE))
+			test_rdmsr_fault(index, msr_name);
+
+		/*
+		 * Except for ICR, the only 64-bit x2APIC register, bits 64:32
+		 * are reserved.  ICR is testable if x2APIC is disabled.
+		 */
+		if (!x2apic_enabled || i != APIC_ICR)
+			test_wrmsr_fault(index, msr_name, -1ull);
+
+		/* Bits 31:8 of self-IPI are reserved. */
+		if (i == APIC_SELF_IPI) {
+			test_wrmsr_fault(index, "x2APIC Self-IPI", 0x100);
+			test_wrmsr_fault(index, "x2APIC Self-IPI", 0xff00);
+			test_wrmsr_fault(index, "x2APIC Self-IPI", 0xff000000ull);
+		}
+
+		if (semantics == X2APIC_RW)
+			__test_msr_rw(index, msr_name, 0, -1ull);
+		else if (semantics == X2APIC_WO)
+			wrmsr(index, 0);
+		else if (semantics == X2APIC_RO)
+			report(!(rdmsr(index) >> 32),
+			       "Expected bits 63:32 == 0 for '%s'", msr_name);
+	}
+}
+
+static void test_x2apic_msrs(void)
+{
+	reset_apic();
+
+	__test_x2apic_msrs(false);
+
+	if (!enable_x2apic())
+		return;
+
+	__test_x2apic_msrs(true);
+}
+
 int main(int ac, char **av)
 {
 	/*
@@ -224,6 +282,7 @@ int main(int ac, char **av)
 	} else {
 		test_misc_msrs();
 		test_mce_msrs();
+		test_x2apic_msrs();
 	}
 
 	return report_summary();
-- 
2.39.0.314.g84b9a713c41-goog

