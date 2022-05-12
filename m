Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E23525858
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 01:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359502AbiELXbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 19:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359491AbiELXax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 19:30:53 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431BF37BFA
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 16:30:51 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id d125-20020a636883000000b003db5e24db27so1827452pgc.13
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 16:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=b/zhssczsdHXkzR63sdlZL1EHwOMa+RVUpV5IGmqOU8=;
        b=mBQlb/2MtlOcOFrZVvQToanFRhy/+WkVg+mxQMaeDbamq0fz7BkfllXY5QFAgg9FeO
         i+mAGzWYZQ2xEZOXe+21XYeL6AN3HLMQ4N9iGaitij1P1VrcoQT7Zpb0OVxoGkutF4Wp
         X+QpTSyCYKed8hQnp/8oc+zoysfCEHM3ErKgQak3JlAwj2o+/BEYxHi0G9CxMiTqSRXC
         OfHXUIVFkYk0JSETEeNap5hKMQD4OAETSSCVEwmLdtksIFeM/1zm7wRWuJkswjDOG027
         nOd39l6xZHHT5ssSo4WkHLEfi+HysSIUlxKegdY2y/DL1sh9ZuO32cSbpdpMrpzthfo1
         ZFuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=b/zhssczsdHXkzR63sdlZL1EHwOMa+RVUpV5IGmqOU8=;
        b=hev6WOIZxwvuK4t+x99mDD9/Y1Qa1uCemHEgAEcsIbd4qR9aamgwiH2EipG6uEuqSL
         vFzpLBD8WVbtPLTKhlCuUEJK7PEtxo/MZ+7gnCxhNWknAWVuUPtJxiUi2Suoc0/FYYaK
         gHUqdwJHqx4lb580vOgdLIDJEFxMojtyliWy4v1iytmBkwA8DmIZlIY9RnQwxQmCqm8n
         5LGlIOqKgHtO58o/VrtIxDEqdgfiIenoaCL+77zo0JWW23VKU2UdhNFwLlA59koXImGL
         mfLQUBoBLNlXHH0WQlE2xHNpqHQfvK7bq6TFCPLy0FXNwO9SyBLM2nuTjo44n83ba/Q+
         c4vw==
X-Gm-Message-State: AOAM532WmZg7zAUg7NsnQ3q4HTej1b9MHfnM0G2WysFK282rqefKkFJo
        9hbz8jdhZdZ+YJ2qwEXnK64hGR0nUUQ=
X-Google-Smtp-Source: ABdhPJycyWFQrDqLgjAN69A5GZn93a9DHL/xXiBFMPUFIg4CWrERMcq93KeBtVOpFny+T2aOcRyL1Wi1N74=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:d551:b0:15e:c50f:41b5 with SMTP id
 z17-20020a170902d55100b0015ec50f41b5mr1941547plf.98.1652398250777; Thu, 12
 May 2022 16:30:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 12 May 2022 23:30:45 +0000
In-Reply-To: <20220512233045.4125471-1-seanjc@google.com>
Message-Id: <20220512233045.4125471-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220512233045.4125471-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [kvm-unit-tests PATCH 2/2] x86: msr: Add tests for MCE bank MSRs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add tests for MCi_XXX MSRs, a.k.a. CTL, STATUS, ADDR and MISC machine
check MSRs (each tuple of 4 MSRs is referred to as a "bank" of MSRs).
Verify that all MSRs in supported banks, as reported by the hypervsior
(or CPU), follow architecturally defined behavior (thankfully, Intel and
AMD don't diverge), e.g. CTL MSRs allow '0' or all ones, STATUS MSRs only
allow '0', non-existent MSRs #GP on read and write, etc...

Ignore AMD's non-architectural behavior of allowing writes to STATUS MSRs
if bit 18 in MSR_K7_HWCR is set.  Aside from the fact that it's not an
architectural bit, sane firmware/software will only set the bit when
stuffing STATUS MSRs, and clear it immediately after, e.g. see Linux's
MCE injection.  Neither KVM nor the hypervisor should set the bit by
default as PPRs for CPUs that support McStatusWrEn list its RESET value
as '0'.  So unless someone runs KUT with funky firmware, pretending the
bit doesn't exist should Just Work.

MSR_K7_HWCR bit 18 also apparently controls the behavior of AMD-only MISC
MSRs (0xC0000xxx range), but those aren't tested.

For banks that are not supported, but are (unofficially?) reserved for
banks on future CPUs, verify that all accesses #GP fault.

Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/msr.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 64 insertions(+), 2 deletions(-)

diff --git a/x86/msr.c b/x86/msr.c
index 3d48e396..a189991a 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -108,10 +108,11 @@ static void test_msr(struct msr_info *msr, bool is_64bit_host)
 int main(int ac, char **av)
 {
 	bool is_64bit_host = this_cpu_has(X86_FEATURE_LM);
+	unsigned int nr_mce_banks;
+	char msr_name[32];
 	int i;
 
 	if (ac == 3) {
-		char msr_name[16];
 		int index = strtoul(av[1], NULL, 0x10);
 		snprintf(msr_name, sizeof(msr_name), "MSR:0x%x", index);
 
@@ -122,8 +123,69 @@ int main(int ac, char **av)
 		};
 		test_msr(&msr, is_64bit_host);
 	} else {
-		for (i = 0 ; i < ARRAY_SIZE(msr_info); i++) {
+		for (i = 0 ; i < ARRAY_SIZE(msr_info); i++)
 			test_msr(&msr_info[i], is_64bit_host);
+
+		nr_mce_banks = rdmsr(MSR_IA32_MCG_CAP) & 0xff;
+		for (i = 0; i < nr_mce_banks; i++) {
+			snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_CTL", i);
+			test_msr_rw(MSR_IA32_MCx_CTL(i), msr_name, 0);
+			test_msr_rw(MSR_IA32_MCx_CTL(i), msr_name, -1ull);
+			test_wrmsr_fault(MSR_IA32_MCx_CTL(i), msr_name, NONCANONICAL);
+
+			snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_STATUS", i);
+			test_msr_rw(MSR_IA32_MCx_STATUS(i), msr_name, 0);
+			/*
+			 * STATUS MSRs can only be written with '0' (to clear
+			 * the MSR), except on AMD-based systems with bit 18
+			 * set in MSR_K7_HWCR.  That bit is not architectural
+			 * and should not be set by default by KVM or by the
+			 * VMM (though this might fail if run on bare metal).
+			 */
+			test_wrmsr_fault(MSR_IA32_MCx_STATUS(i), msr_name, 1);
+
+			snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_ADDR", i);
+			test_msr_rw(MSR_IA32_MCx_ADDR(i), msr_name, 0);
+			test_msr_rw(MSR_IA32_MCx_ADDR(i), msr_name, -1ull);
+			/*
+			 * The ADDR is a physical address, and all bits are
+			 * writable on 64-bit hosts.    Don't test the negative
+			 * case, as KVM doesn't enforce checks on bits 63:36
+			 * for 32-bit hosts.  The behavior depends on the
+			 * underlying hardware, e.g. a 32-bit guest on a 64-bit
+			 * host may observe 64-bit values in the ADDR MSRs.
+			 */
+			if (is_64bit_host)
+				test_msr_rw(MSR_IA32_MCx_ADDR(i), msr_name, NONCANONICAL);
+
+			snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_MISC", i);
+			test_msr_rw(MSR_IA32_MCx_MISC(i), msr_name, 0);
+			test_msr_rw(MSR_IA32_MCx_MISC(i), msr_name, -1ull);
+			test_msr_rw(MSR_IA32_MCx_MISC(i), msr_name, NONCANONICAL);
+		}
+
+		/*
+		 * The theoretical maximum number of MCE banks is 32 (on Intel
+		 * CPUs, without jumping to a new base address), as the last
+		 * unclaimed MSR is 0x479; 0x480 begins the VMX MSRs.  Verify
+		 * accesses to theoretically legal, unsupported MSRs fault.
+		 */
+		for (i = nr_mce_banks; i < 32; i++) {
+			snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_CTL", i);
+			test_rdmsr_fault(MSR_IA32_MCx_CTL(i), msr_name);
+			test_wrmsr_fault(MSR_IA32_MCx_CTL(i), msr_name, 0);
+
+			snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_STATUS", i);
+			test_rdmsr_fault(MSR_IA32_MCx_STATUS(i), msr_name);
+			test_wrmsr_fault(MSR_IA32_MCx_STATUS(i), msr_name, 0);
+
+			snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_ADDR", i);
+			test_rdmsr_fault(MSR_IA32_MCx_ADDR(i), msr_name);
+			test_wrmsr_fault(MSR_IA32_MCx_ADDR(i), msr_name, 0);
+
+			snprintf(msr_name, sizeof(msr_name), "MSR_IA32_MC%u_MISC", i);
+			test_rdmsr_fault(MSR_IA32_MCx_MISC(i), msr_name);
+			test_wrmsr_fault(MSR_IA32_MCx_MISC(i), msr_name, 0);
 		}
 	}
 
-- 
2.36.0.550.gb090851708-goog

