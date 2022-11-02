Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0636170E9
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbiKBWv5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiKBWvn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:51:43 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A065DEF9
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:34 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id c1-20020a170902d48100b0018723580343so169215plg.15
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gBIIb1dfv29FuIUf1jIH0lpUMWNPIm81ku/JH4sHLrE=;
        b=dX1O/ruc/RVd2fqwxLE0SgFz8oMgJI5lufDHNdy+LLYZdZJQmbSB0mfO8Il9cqQW6P
         y9s2I4jj87Zd1t1uCH+vwJ+EDWcOGUt9C+uvJbuioJ8xvQ1xVcTDl7Um0/HiqZhs/J3U
         BVcXhrGT5LDIfv6wLHn2OBpZqCp1WExe+EesmGUmBOnFzmUABojJa4aq+6+DR5bopRRU
         hCrfob8++nXKvsqq05OtrEcjUXStnvdT3hq5TunG0wmy9yEs2n6LroJckXLdIKV3OTSF
         O9DWqb9FWzrfPSrC6GUE04wdujptgAcf3kAJLgOhLA0TK/oIDu5XCS45S/UA2VWxvHrZ
         /Bvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gBIIb1dfv29FuIUf1jIH0lpUMWNPIm81ku/JH4sHLrE=;
        b=Dz6gG7j5VOq6QVYdlSUhn3Ye3Mso9UDmZlk4s0OfARiaHCLNbw8ZielJJGRrnnw7TE
         /IckUdrMR2yvnmsHNCkWvk1KFJfz+EPvPRNQSMalOe3/h6q4P1HwubIuf5PbfP+8vSML
         KnQ6Xh6pn60+wthPB6H6UebD7mRdlzVY1+GTrTXzmxmJ1ziawpVa9g9Oc3EngF3UJTNN
         HX1YhuwiF/iiGjl1/5dowhS7Wpg5GixHNFvxWZLWZyfOkQLko9ntmUGQFLvcWyq2JqwS
         jFsx1/RscPuqbo9Tc7kg+hIieDRvFOh5LHD9R8HtaqjJVdQLIk28l8BdPeKAgtZF+GO1
         a3tQ==
X-Gm-Message-State: ACrzQf3BiImSFCb/oZwnSkbPj3C6t9LPlb92N/kI1HU8P0Nuea11zu5R
        pSoDt6qaDma2Ir9j/NhuymPsztK1JZo=
X-Google-Smtp-Source: AMsMyM56fGNBOmE9wYMmeWft9JNfyAWIVhQQyOXIrwRHGQoSdZnu/PJT9a8ll+FlWM2M8z5bJiUsWBangps=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:da84:b0:187:28c4:eff5 with SMTP id
 j4-20020a170902da8400b0018728c4eff5mr15433985plx.146.1667429494024; Wed, 02
 Nov 2022 15:51:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:50:54 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-12-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 11/27] x86/pmu: Update rdpmc testcase to
 cover #GP path
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Like Xu <likexu@tencent.com>,
        Sandipan Das <sandipan.das@amd.com>
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

From: Like Xu <likexu@tencent.com>

Specifying an unsupported PMC encoding will cause a #GP(0).

There are multiple reasons RDPMC can #GP, the one that is being relied
on to guarantee #GP is specifically that the PMC is invalid. The most
extensible solution is to provide a safe variant.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 21 ++++++++++++++++++---
 x86/pmu.c           | 10 ++++++++++
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index f85abe36..ba14c7a0 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -438,11 +438,26 @@ static inline int wrmsr_safe(u32 index, u64 val)
 	return exception_vector();
 }
 
+static inline int rdpmc_safe(u32 index, uint64_t *val)
+{
+	uint32_t a, d;
+
+	asm volatile (ASM_TRY("1f")
+		      "rdpmc\n\t"
+		      "1:"
+		      : "=a"(a), "=d"(d) : "c"(index) : "memory");
+	*val = (uint64_t)a | ((uint64_t)d << 32);
+	return exception_vector();
+}
+
 static inline uint64_t rdpmc(uint32_t index)
 {
-	uint32_t a, d;
-	asm volatile ("rdpmc" : "=a"(a), "=d"(d) : "c"(index));
-	return a | ((uint64_t)d << 32);
+	uint64_t val;
+	int vector = rdpmc_safe(index, &val);
+
+	assert_msg(!vector, "Unexpected %s on RDPMC(%d)",
+		   exception_mnemonic(vector), index);
+	return val;
 }
 
 static inline int write_cr0_safe(ulong val)
diff --git a/x86/pmu.c b/x86/pmu.c
index 5fa6a952..03061388 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -651,12 +651,22 @@ static void set_ref_cycle_expectations(void)
 	gp_events[2].max = (gp_events[2].max * cnt.count) / tsc_delta;
 }
 
+static void check_invalid_rdpmc_gp(void)
+{
+	uint64_t val;
+
+	report(rdpmc_safe(64, &val) == GP_VECTOR,
+	       "Expected #GP on RDPMC(64)");
+}
+
 int main(int ac, char **av)
 {
 	setup_vm();
 	handle_irq(PC_VECTOR, cnt_overflow);
 	buf = malloc(N*64);
 
+	check_invalid_rdpmc_gp();
+
 	if (!pmu_version()) {
 		report_skip("No Intel Arch PMU is detected!");
 		return report_summary();
-- 
2.38.1.431.g37b22c650d-goog

